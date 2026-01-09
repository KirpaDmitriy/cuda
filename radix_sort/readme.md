```
@gpu:~/radix_sort$ ./sort_check
N:100000
Data Size: 100000
Padded Size (for Bitonic): 131072

1. Run CPU std::sort...
   Time: 0.0073 s

2. Run GPU Radix Sort (Blelloch Scan)...
   Time: 0.0007 s
   Status: Correct

3. Run GPU Radix Sort (Hillis-Steele Scan)...
   Time: 0.0002 s
   Status: Correct

4. Run GPU Bitonic Sort (Comparison Based, Padded input)...
   Time: 0.0007 s
   Status: Correct

@gpu:~/radix_sort$ ./sort_check
N:1000000
Data Size: 1000000
Padded Size (for Bitonic): 1048576

1. Run CPU std::sort...
   Time: 0.0861 s

2. Run GPU Radix Sort (Blelloch Scan)...
   Time: 0.0021 s
   Status: Correct

3. Run GPU Radix Sort (Hillis-Steele Scan)...
   Time: 0.0016 s
   Status: Correct

4. Run GPU Bitonic Sort (Comparison Based, Padded input)...
   Time: 0.0041 s
   Status: Correct

```
