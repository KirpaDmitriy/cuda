#include <iostream>
#include <vector>
#include <chrono>
#include <cmath>
#include <iomanip>
#include <cuda_runtime.h>

#define TILE_SIZE 32

#define gpuErrchk(ans) { gpuAssert((ans), __FILE__, __LINE__); }
inline void gpuAssert(cudaError_t code, const char *file, int line, bool abort=true)
{
   if (code != cudaSuccess) 
   {
      fprintf(stderr,"GPUassert: %s %s %d\n", cudaGetErrorString(code), file, line);
      if (abort) exit(code);
   }
}

/*
Gx = [-1  0  1]    Gy = [-1 -2 -1]
     [-2  0  2]         [ 0  0  0]
     [-1  0  1]         [ 1  2  1]

Magnitude = √(Gx² + Gy²)
*/

__global__ void SobelNaive(const float* A, float* R, int M, int N) {
    int row = blockIdx.y * TILE_SIZE + threadIdx.y + 1;
    int col = blockIdx.x * TILE_SIZE + threadIdx.x + 1;
    
    float Gx = (-1) * A[(row - 1) * N + col - 1] + A[(row - 1) * N + col + 1] + (-2) * A[row * N + col - 1] + 2 * A[row * N + col + 1] + (-1) * A[(row + 1) * N + col - 1] + A[(row + 1) * N + col + 1];
    float Gy = (-1) * A[(row - 1) * N + col - 1] + (-2)* A[(row - 1) * N + col] + (-1) * A[(row - 1) * N + col + 1] + A[(row + 1) * N + col - 1] + 2 * A[(row + 1) * N + col] + A[(row + 1) * N + col + 1];

    row--; col--;
    R[row * N + col] = sqrt(Gx * Gx + Gy + Gy);
}

__global__ void SobelShared(const float* A_raw, float* R, int M, int N) {
    __shared__ float A[TILE_SIZE + 2][TILE_SIZE + 2];

    int row = blockIdx.y * TILE_SIZE + threadIdx.y;
    int col = blockIdx.x * TILE_SIZE + threadIdx.x;

    int row_init_matrix = row + 1;
    int col_init_matrix = col + 1;

    A[threadIdx.y][threadIdx.x] = A_raw[(row_init_matrix - 1) * N + col_init_matrix - 1];
    A[threadIdx.y][threadIdx.x + 1] = A_raw[(row_init_matrix - 1) * N + col_init_matrix];
    A[threadIdx.y][threadIdx.x + 2] = A_raw[(row_init_matrix - 1) * N + col_init_matrix + 1];

    A[threadIdx.y + 1][threadIdx.x] = A_raw[row_init_matrix * N + col_init_matrix - 1];
    A[threadIdx.y + 1][threadIdx.x + 1] = A_raw[row_init_matrix * N + col_init_matrix];
    A[threadIdx.y + 1][threadIdx.x + 2] = A_raw[row_init_matrix * N + col_init_matrix + 1];

    A[threadIdx.y + 2][threadIdx.x] = A_raw[(row_init_matrix + 1) * N + col_init_matrix - 1];
    A[threadIdx.y + 2][threadIdx.x + 1] = A_raw[(row_init_matrix + 1) * N + col_init_matrix];
    A[threadIdx.y + 2][threadIdx.x + 2] = A_raw[(row_init_matrix + 1) * N + col_init_matrix + 1];

    __syncthreads();

    row = threadIdx.y + 1; col = threadIdx.x + 1;
    float Gx = (-1) * A[row - 1][col - 1] + A[row - 1][col + 1] + (-2) * A[row][col - 1] + 2 * A[row][col + 1] + (-1) * A[row + 1][col - 1] + A[row + 1][col + 1];
    float Gy = (-1) * A[row - 1][col - 1] + (-2)* A[row - 1][col] + (-1) * A[row - 1][col + 1] + A[row + 1][col - 1] + 2 * A[row + 1][col] + A[row + 1][col + 1];

    row = blockIdx.y * TILE_SIZE + threadIdx.y;
    col = blockIdx.x * TILE_SIZE + threadIdx.x;
    R[row * N + col] = sqrt(Gx * Gx + Gy + Gy);
}

void SobelCPU(const float* A, float* R, int M, int N) {
    for (int row = 1; row <= M; ++row) {
        for (int col = 1; col <= N; ++col) {
            float Gx = (-1) * A[(row - 1) * N + col - 1] + A[(row - 1) * N + col + 1] + (-2) * A[row * N + col - 1] + 2 * A[row * N + col + 1] + (-1) * A[(row + 1) * N + col - 1] + A[(row + 1) * N + col + 1];
            float Gy = (-1) * A[(row - 1) * N + col - 1] + (-2)* A[(row - 1) * N + col] + (-1) * A[(row - 1) * N + col + 1] + A[(row + 1) * N + col - 1] + 2 * A[(row + 1) * N + col] + A[(row + 1) * N + col + 1];

            R[(row - 1) * N + col - 1] = sqrt(Gx * Gx + Gy + Gy);
        }
    }
}


int main() {
    int M = 4056;
    int N = 1024;

    size_t sizeA = M * N * sizeof(float);
    size_t sizeR = (M - 2) * (N - 2) * sizeof(float);

    float* h_A = (float*)malloc(sizeA);
    float* h_R_CPU = (float*)malloc(sizeR);
    float* h_R_GPU = (float*)malloc(sizeR);

    srand(2024);
    for (int i = 0; i < M * N; ++i) h_A[i] = static_cast<float>(rand()) / RAND_MAX;

    float *d_A, *d_R;
    gpuErrchk(cudaMalloc(&d_A, sizeA));
    gpuErrchk(cudaMalloc(&d_R, sizeR));

    gpuErrchk(cudaMemcpy(d_A, h_A, sizeA, cudaMemcpyHostToDevice));

    std::cout << "Matrix size: " << M << " x " << N << std::endl;
    std::cout << "Calculating on CPU..." << std::endl;

    auto start_cpu = std::chrono::high_resolution_clock::now();
    SobelCPU(h_A, h_R_CPU, M - 2, N - 2);
    auto end_cpu = std::chrono::high_resolution_clock::now();
    double cpu_time = std::chrono::duration<double>(end_cpu - start_cpu).count();
    
    std::cout << "CPU Time: " << std::fixed << std::setprecision(4) << cpu_time << " s" << std::endl;

    dim3 dimBlock(TILE_SIZE, TILE_SIZE);
    dim3 dimGrid(((N - 2) + dimBlock.x - 1) / dimBlock.x, ((M - 2) + dimBlock.y - 1) / dimBlock.y);

    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    float gpu_time_naive = 0, gpu_time_shared = 0;

    cudaEventRecord(start);
    SobelNaive<<<dimGrid, dimBlock>>>(d_A, d_R, M - 2, N - 2);
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    cudaEventElapsedTime(&gpu_time_naive, start, stop);
    gpu_time_naive /= 1000.0f;

    cudaDeviceSynchronize();

    std::cout << "GPU Naive Time: " << gpu_time_naive << " s" << std::endl;
    cudaMemset(d_R, 0, sizeR);

    cudaEventRecord(start);
    SobelShared<<<dimGrid, dimBlock>>>(d_A, d_R, M - 2, N - 2);
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    cudaEventElapsedTime(&gpu_time_shared, start, stop);
    gpu_time_shared /= 1000.0f;

    std::cout << "GPU Shared Memory Time: " << gpu_time_shared << " s" << std::endl;

    gpuErrchk(cudaMemcpy(h_R_GPU, d_R, sizeR, cudaMemcpyDeviceToHost));

    double max_diff = 0.0;
    for (int i = 0; i < (M - 2) * (N - 2); ++i) {
        float diff = std::abs(h_R_CPU[i] - h_R_GPU[i]);
        if (diff > max_diff) max_diff = diff;
    }

    std::cout << "\n\nCorrectness check max Error: " << max_diff << std::endl;

    std::cout << "Speedup GPU Naive vs CPU: " << cpu_time / gpu_time_naive << "x" << std::endl;
    std::cout << "Speedup GPU Shared vs CPU: " << cpu_time / gpu_time_shared << "x" << std::endl;
    std::cout << "Speedup Shared vs Naive: " << gpu_time_naive / gpu_time_shared << "x" << std::endl;

    free(h_A); free(h_R_CPU); free(h_R_GPU);
    cudaFree(d_A); cudaFree(d_R);
    cudaEventDestroy(start); cudaEventDestroy(stop);

    return 0;
}

