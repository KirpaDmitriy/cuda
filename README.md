# CUDA

Полезная утилита:
```
ncu --metrics smsp__sass_average_data_bytes_per_wavefront_mem_shared_op_ld.sum_perc_shared,smsp__sass_average_data_bytes_per_wavefront_mem_shared_op_st.sum_perc_shared,l1tex__data_bank_conflicts_pipe_lsu_mem_shared_op_ld.sum,l1tex__data_bank_conflicts_pipe_lsu_mem_shared_op_st.sum --set full ./script
```

Макрос, чтобы отлавливать ошибки на девайсе (украдено [отсюда](https://stackoverflow.com/questions/14038589/what-is-the-canonical-way-to-check-for-errors-using-the-cuda-runtime-api/14038590#14038590)):
```
#define gpuErrchk(ans) { gpuAssert((ans), __FILE__, __LINE__); }
inline void gpuAssert(cudaError_t code, const char *file, int line, bool abort=true)
{
   if (code != cudaSuccess) 
   {
      fprintf(stderr,"GPUassert: %s %s %d\n", cudaGetErrorString(code), file, line);
      if (abort) exit(code);
   }
}
```
