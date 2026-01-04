# Перф

## Логи:
```
Speedup Shared vs Naive: 1.2004x
```

## NCU для наивного ядра:
```
  SobelNaive(const float *, float *, int, int) (32, 127, 1)x(32, 32, 1), Context 1, Stream 7, Device 0, CC 7.5
    Section: Command line profiler metrics
    ---------------------------------------------------------------------------- ----------- ------------
    Metric Name                                                                  Metric Unit Metric Value
    ---------------------------------------------------------------------------- ----------- ------------
    l1tex__data_bank_conflicts_pipe_lsu_mem_shared_op_ld.sum                                            0
    l1tex__data_bank_conflicts_pipe_lsu_mem_shared_op_st.sum                                            0
    smsp__sass_average_data_bytes_per_wavefront_mem_shared_op_ld.sum_perc_shared                  (!) n/a
    smsp__sass_average_data_bytes_per_wavefront_mem_shared_op_st.sum_perc_shared                  (!) n/a
    ---------------------------------------------------------------------------- ----------- ------------

    Section: GPU Speed Of Light Throughput
    ----------------------- ------------- ------------
    Metric Name               Metric Unit Metric Value
    ----------------------- ------------- ------------
    DRAM Frequency          cycle/nsecond         4.94
    SM Frequency            cycle/usecond       578.43
    Elapsed Cycles                  cycle       164925
    Memory Throughput                   %        50.30
    DRAM Throughput                     %        50.30
    Duration                      usecond       285.12
    L1/TEX Cache Throughput             %        47.98
    L2 Cache Throughput                 %        17.02
    SM Active Cycles                cycle    149077.25
    Compute (SM) Throughput             %        43.37
    ----------------------- ------------- ------------

    WRN   This kernel exhibits low compute throughput and memory bandwidth utilization relative to the peak performance 
          of this device. Achieved compute throughput and/or memory bandwidth below 60.0% of peak typically indicate    
          latency issues. Look at Scheduler Statistics and Warp State Statistics for potential reasons.                 

    Section: GPU Speed Of Light Roofline Chart
    INF   The ratio of peak float (fp32) to double (fp64) performance on this device is 32:1. The kernel achieved 10%   
          of this device's fp32 peak performance and 0% of its fp64 peak performance. See the Kernel Profiling Guide    
          (https://docs.nvidia.com/nsight-compute/ProfilingGuide/index.html#roofline) for more details on roofline      
          analysis.                                                                                                     

    Section: Compute Workload Analysis
    -------------------- ----------- ------------
    Metric Name          Metric Unit Metric Value
    -------------------- ----------- ------------
    Executed Ipc Active   inst/cycle         1.44
    Executed Ipc Elapsed  inst/cycle         1.30
    Issue Slots Busy               %        36.00
    Issued Ipc Active     inst/cycle         1.44
    SM Busy                        %        36.00
    -------------------- ----------- ------------

    INF   FMA is the highest-utilized pipeline (25.1%) based on active cycles, taking into account the rates of its     
          different instructions. It executes 32-bit floating point (FADD, FMUL, FMAD, ...) and integer (IMUL, IMAD)    
          operations. It is well-utilized, but should not be a bottleneck.                                              

    Section: Memory Workload Analysis
    ----------------- ------------ ------------
    Metric Name        Metric Unit Metric Value
    ----------------- ------------ ------------
    Memory Throughput Gbyte/second       159.02
    Mem Busy                     %        23.90
    Max Bandwidth                %        50.30
    L1/TEX Hit Rate              %        76.74
    L2 Hit Rate                  %        57.89
    Mem Pipes Busy               %        43.37
    ----------------- ------------ ------------

    Section: Memory Workload Analysis Tables
    WRN   The memory access pattern for global loads in L1TEX might not be optimal. On average, this kernel accesses    
          4.0 bytes per thread per memory request; but the address pattern, possibly caused by the stride between       
          threads, results in 4.8 sectors per request, or 4.8*32 = 154.0 bytes of cache data transfers per request.     
          The optimal thread address pattern for 4.0 byte accesses would result in 4.0*32 = 128.0 bytes of cache data   
          transfers per request, to maximize L1TEX cache performance. Check the Source Counters section for             
          uncoalesced global loads.                                                                                     
    ----- --------------------------------------------------------------------------------------------------------------
    WRN   The memory access pattern for global stores in L1TEX might not be optimal. On average, this kernel accesses   
          4.0 bytes per thread per memory request; but the address pattern, possibly caused by the stride between       
          threads, results in 4.8 sectors per request, or 4.8*32 = 152.0 bytes of cache data transfers per request.     
          The optimal thread address pattern for 4.0 byte accesses would result in 4.0*32 = 128.0 bytes of cache data   
          transfers per request, to maximize L1TEX cache performance. Check the Source Counters section for             
          uncoalesced global stores.                                                                                    
    ----- --------------------------------------------------------------------------------------------------------------
    WRN   The memory access pattern for loads from L1TEX to L2 is not optimal. The granularity of an L1TEX request to   
          L2 is a 128 byte cache line. That is 4 consecutive 32-byte sectors per L2 request. However, this kernel only  
          accesses an average of 2.3 sectors out of the possible 4 sectors per cache line. Check the Source Counters    
          section for uncoalesced loads and try to minimize how many cache lines need to be accessed per memory         
          request.                                                                                                      
    ----- --------------------------------------------------------------------------------------------------------------
    WRN   The memory access pattern for stores from L1TEX to L2 is not optimal. The granularity of an L1TEX request to  
          L2 is a 128 byte cache line. That is 4 consecutive 32-byte sectors per L2 request. However, this kernel only  
          accesses an average of 2.5 sectors out of the possible 4 sectors per cache line. Check the Source Counters    
          section for uncoalesced stores and try to minimize how many cache lines need to be accessed per memory        
          request.                                                                                                      

    Section: Scheduler Statistics
    ---------------------------- ----------- ------------
    Metric Name                  Metric Unit Metric Value
    ---------------------------- ----------- ------------
    One or More Eligible                   %        36.96
    Issued Warp Per Scheduler                        0.37
    No Eligible                            %        63.04
    Active Warps Per Scheduler          warp         7.29
    Eligible Warps Per Scheduler        warp         0.94
    ---------------------------- ----------- ------------

    WRN   Every scheduler is capable of issuing one instruction per cycle, but for this kernel each scheduler only      
          issues an instruction every 2.7 cycles. This might leave hardware resources underutilized and may lead to     
          less optimal performance. Out of the maximum of 8 warps per scheduler, this kernel allocates an average of    
          7.29 active warps per scheduler, but only an average of 0.94 warps were eligible per cycle. Eligible warps    
          are the subset of active warps that are ready to issue their next instruction. Every cycle with no eligible   
          warp results in no instruction being issued and the issue slot remains unused. To increase the number of      
          eligible warps, avoid possible load imbalances due to highly different execution durations per warp.          
          Reducing stalls indicated on the Warp State Statistics and Source Counters sections can help, too.            

    Section: Warp State Statistics
    ---------------------------------------- ----------- ------------
    Metric Name                              Metric Unit Metric Value
    ---------------------------------------- ----------- ------------
    Warp Cycles Per Issued Instruction             cycle        19.71
    Warp Cycles Per Executed Instruction           cycle        19.72
    Avg. Active Threads Per Warp                                26.74
    Avg. Not Predicated Off Threads Per Warp                    26.23
    ---------------------------------------- ----------- ------------

    WRN   On average, each warp of this kernel spends 5.9 cycles being stalled waiting for a scoreboard dependency on a 
          L1TEX (local, global, surface, texture, rtcore) operation. This represents about 30.1% of the total average   
          of 19.7 cycles between issuing two instructions. To reduce the number of cycles waiting on L1TEX data         
          accesses verify the memory access patterns are optimal for the target architecture, attempt to increase       
          cache hit rates by increasing data locality or by changing the cache configuration, and consider moving       
          frequently used data to registers and to shared memory.                                                       
    ----- --------------------------------------------------------------------------------------------------------------
    INF   Check the Source Counters section for the top stall locations in your source based on sampling data. The      
          Kernel Profiling Guide (https://docs.nvidia.com/nsight-compute/ProfilingGuide/index.html#sampling) provides   
          more details on each stall reason.                                                                            

    Section: Instruction Statistics
    ---------------------------------------- ----------- ------------
    Metric Name                              Metric Unit Metric Value
    ---------------------------------------- ----------- ------------
    Avg. Executed Instructions Per Scheduler        inst     53640.89
    Executed Instructions                           inst      8582543
    Avg. Issued Instructions Per Scheduler          inst     53672.89
    Issued Instructions                             inst      8587663
    ---------------------------------------- ----------- ------------

    WRN   This kernel executes 780206 fused and 1430446 non-fused FP32 instructions. By converting pairs of non-fused   
          instructions to their fused (https://docs.nvidia.com/cuda/floating-point/#cuda-and-floating-point),           
          higher-throughput equivalent, the achieved FP32 performance could be increased by up to 32% (relative to its  
          current performance). Check the Source page to identify where this kernel executes FP32 instructions.         

    Section: Launch Statistics
    -------------------------------- --------------- ---------------
    Metric Name                          Metric Unit    Metric Value
    -------------------------------- --------------- ---------------
    Block Size                                                  1024
    Function Cache Configuration                     CachePreferNone
    Grid Size                                                   4064
    Registers Per Thread             register/thread              22
    Shared Memory Configuration Size           Kbyte           32.77
    Driver Shared Memory Per Block        byte/block               0
    Dynamic Shared Memory Per Block       byte/block               0
    Static Shared Memory Per Block        byte/block               0
    Threads                                   thread         4161536
    Waves Per SM                                              101.60
    -------------------------------- --------------- ---------------

    Section: Occupancy
    ------------------------------- ----------- ------------
    Metric Name                     Metric Unit Metric Value
    ------------------------------- ----------- ------------
    Block Limit SM                        block           16
    Block Limit Registers                 block            2
    Block Limit Shared Mem                block           16
    Block Limit Warps                     block            1
    Theoretical Active Warps per SM        warp           32
    Theoretical Occupancy                     %          100
    Achieved Occupancy                        %        90.06
    Achieved Active Warps Per SM           warp        28.82
    ------------------------------- ----------- ------------

    INF   This kernel's theoretical occupancy is not impacted by any block limit.                                       

    Section: Source Counters
    ------------------------- ----------- ------------
    Metric Name               Metric Unit Metric Value
    ------------------------- ----------- ------------
    Branch Instructions Ratio           %         0.14
    Branch Instructions              inst      1170212
    Branch Efficiency                   %        83.34
    Avg. Divergent Branches                     812.36
    ------------------------- ----------- ------------

    WRN   This kernel has uncoalesced global accesses resulting in a total of 942848 excessive sectors (17% of the      
          total 5624576 sectors). Check the L2 Theoretical Sectors Global Excessive table for the primary source        
          locations. The CUDA Programming Guide                                                                         
          (https://docs.nvidia.com/cuda/cuda-c-programming-guide/index.html#device-memory-accesses) had additional      
          information on reducing uncoalesced device memory accesses.                                                   
```

## NCU для ядра с тайлингом:
```
SobelShared(const float *, float *, int, int) (32, 127, 1)x(32, 32, 1), Context 1, Stream 7, Device 0, CC 7.5
    Section: Command line profiler metrics
    ---------------------------------------------------------------------------- ----------- ------------
    Metric Name                                                                  Metric Unit Metric Value
    ---------------------------------------------------------------------------- ----------- ------------
    l1tex__data_bank_conflicts_pipe_lsu_mem_shared_op_ld.sum                                            0
    l1tex__data_bank_conflicts_pipe_lsu_mem_shared_op_st.sum                                            0
    smsp__sass_average_data_bytes_per_wavefront_mem_shared_op_ld.sum_perc_shared                  (!) n/a
    smsp__sass_average_data_bytes_per_wavefront_mem_shared_op_st.sum_perc_shared                  (!) n/a
    ---------------------------------------------------------------------------- ----------- ------------

    Section: GPU Speed Of Light Throughput
    ----------------------- ------------- ------------
    Metric Name               Metric Unit Metric Value
    ----------------------- ------------- ------------
    DRAM Frequency          cycle/nsecond         5.00
    SM Frequency            cycle/usecond       585.23
    Elapsed Cycles                  cycle       266796
    Memory Throughput                   %        70.68
    DRAM Throughput                     %        33.13
    Duration                      usecond       455.87
    L1/TEX Cache Throughput             %        75.99
    L2 Cache Throughput                 %        10.53
    SM Active Cycles                cycle    248147.50
    Compute (SM) Throughput             %        70.68
    ----------------------- ------------- ------------

    INF   Compute and Memory are well-balanced: To reduce runtime, both computation and memory traffic must be reduced. 
          Check both the Compute Workload Analysis and Memory Workload Analysis sections.                               

    Section: GPU Speed Of Light Roofline Chart
    INF   The ratio of peak float (fp32) to double (fp64) performance on this device is 32:1. The kernel achieved 6% of 
          this device's fp32 peak performance and 0% of its fp64 peak performance. See the Kernel Profiling Guide       
          (https://docs.nvidia.com/nsight-compute/ProfilingGuide/index.html#roofline) for more details on roofline      
          analysis.                                                                                                     

    Section: Compute Workload Analysis
    -------------------- ----------- ------------
    Metric Name          Metric Unit Metric Value
    -------------------- ----------- ------------
    Executed Ipc Active   inst/cycle         1.07
    Executed Ipc Elapsed  inst/cycle         1.00
    Issue Slots Busy               %        26.87
    Issued Ipc Active     inst/cycle         1.07
    SM Busy                        %        27.95
    -------------------- ----------- ------------

    WRN   All compute pipelines are under-utilized. Either this kernel is very small or it doesn't issue enough warps   
          per scheduler. Check the Launch Statistics and Scheduler Statistics sections for further details.             

    Section: Memory Workload Analysis
    ----------------- ------------ ------------
    Metric Name        Metric Unit Metric Value
    ----------------- ------------ ------------
    Memory Throughput Gbyte/second       105.97
    Mem Busy                     %        36.86
    Max Bandwidth                %        70.68
    L1/TEX Hit Rate              %        79.15
    L2 Hit Rate                  %        58.16
    Mem Pipes Busy               %        70.68
    ----------------- ------------ ------------

    Section: Memory Workload Analysis Tables
    WRN   The memory access pattern for global loads in L1TEX might not be optimal. On average, this kernel accesses    
          4.0 bytes per thread per memory request; but the address pattern, possibly caused by the stride between       
          threads, results in 4.8 sectors per request, or 4.8*32 = 154.7 bytes of cache data transfers per request.     
          The optimal thread address pattern for 4.0 byte accesses would result in 4.0*32 = 128.0 bytes of cache data   
          transfers per request, to maximize L1TEX cache performance. Check the Source Counters section for             
          uncoalesced global loads.                                                                                     
    ----- --------------------------------------------------------------------------------------------------------------
    WRN   The memory access pattern for global stores in L1TEX might not be optimal. On average, this kernel accesses   
          4.0 bytes per thread per memory request; but the address pattern, possibly caused by the stride between       
          threads, results in 4.8 sectors per request, or 4.8*32 = 152.0 bytes of cache data transfers per request.     
          The optimal thread address pattern for 4.0 byte accesses would result in 4.0*32 = 128.0 bytes of cache data   
          transfers per request, to maximize L1TEX cache performance. Check the Source Counters section for             
          uncoalesced global stores.                                                                                    
    ----- --------------------------------------------------------------------------------------------------------------
    WRN   The memory access pattern for loads from L1TEX to L2 is not optimal. The granularity of an L1TEX request to   
          L2 is a 128 byte cache line. That is 4 consecutive 32-byte sectors per L2 request. However, this kernel only  
          accesses an average of 2.3 sectors out of the possible 4 sectors per cache line. Check the Source Counters    
          section for uncoalesced loads and try to minimize how many cache lines need to be accessed per memory         
          request.                                                                                                      
    ----- --------------------------------------------------------------------------------------------------------------
    WRN   The memory access pattern for stores from L1TEX to L2 is not optimal. The granularity of an L1TEX request to  
          L2 is a 128 byte cache line. That is 4 consecutive 32-byte sectors per L2 request. However, this kernel only  
          accesses an average of 2.5 sectors out of the possible 4 sectors per cache line. Check the Source Counters    
          section for uncoalesced stores and try to minimize how many cache lines need to be accessed per memory        
          request.                                                                                                      

    Section: Scheduler Statistics
    ---------------------------- ----------- ------------
    Metric Name                  Metric Unit Metric Value
    ---------------------------- ----------- ------------
    One or More Eligible                   %        27.31
    Issued Warp Per Scheduler                        0.27
    No Eligible                            %        72.69
    Active Warps Per Scheduler          warp         7.63
    Eligible Warps Per Scheduler        warp         1.00
    ---------------------------- ----------- ------------

    WRN   Every scheduler is capable of issuing one instruction per cycle, but for this kernel each scheduler only      
          issues an instruction every 3.7 cycles. This might leave hardware resources underutilized and may lead to     
          less optimal performance. Out of the maximum of 8 warps per scheduler, this kernel allocates an average of    
          7.63 active warps per scheduler, but only an average of 1.00 warps were eligible per cycle. Eligible warps    
          are the subset of active warps that are ready to issue their next instruction. Every cycle with no eligible   
          warp results in no instruction being issued and the issue slot remains unused. To increase the number of      
          eligible warps, avoid possible load imbalances due to highly different execution durations per warp.          
          Reducing stalls indicated on the Warp State Statistics and Source Counters sections can help, too.            

    Section: Warp State Statistics
    ---------------------------------------- ----------- ------------
    Metric Name                              Metric Unit Metric Value
    ---------------------------------------- ----------- ------------
    Warp Cycles Per Issued Instruction             cycle        27.94
    Warp Cycles Per Executed Instruction           cycle        27.95
    Avg. Active Threads Per Warp                                27.77
    Avg. Not Predicated Off Threads Per Warp                    27.36
    ---------------------------------------- ----------- ------------

    WRN   On average, each warp of this kernel spends 9.2 cycles being stalled waiting for an MIO instruction queue to  
          be not full. This represents about 32.9% of the total average of 27.9 cycles between issuing two              
          instructions. This stall reason is high in cases of utilization of the MIO pipelines, which include special   
          math instructions, dynamic branches, as well as shared memory instructions. When caused by shared memory      
          accesses, trying to use fewer but wider loads can reduce pipeline pressure.                                   
    ----- --------------------------------------------------------------------------------------------------------------
    INF   Check the Source Counters section for the top stall locations in your source based on sampling data. The      
          Kernel Profiling Guide (https://docs.nvidia.com/nsight-compute/ProfilingGuide/index.html#sampling) provides   
          more details on each stall reason.                                                                            

    Section: Instruction Statistics
    ---------------------------------------- ----------- ------------
    Metric Name                              Metric Unit Metric Value
    ---------------------------------------- ----------- ------------
    Avg. Executed Instructions Per Scheduler        inst     66645.69
    Executed Instructions                           inst     10663311
    Avg. Issued Instructions Per Scheduler          inst     66677.69
    Issued Instructions                             inst     10668431
    ---------------------------------------- ----------- ------------

    WRN   This kernel executes 780206 fused and 1430446 non-fused FP32 instructions. By converting pairs of non-fused   
          instructions to their fused (https://docs.nvidia.com/cuda/floating-point/#cuda-and-floating-point),           
          higher-throughput equivalent, the achieved FP32 performance could be increased by up to 32% (relative to its  
          current performance). Check the Source page to identify where this kernel executes FP32 instructions.         

    Section: Launch Statistics
    -------------------------------- --------------- ---------------
    Metric Name                          Metric Unit    Metric Value
    -------------------------------- --------------- ---------------
    Block Size                                                  1024
    Function Cache Configuration                     CachePreferNone
    Grid Size                                                   4064
    Registers Per Thread             register/thread              22
    Shared Memory Configuration Size           Kbyte           32.77
    Driver Shared Memory Per Block        byte/block               0
    Dynamic Shared Memory Per Block       byte/block               0
    Static Shared Memory Per Block       Kbyte/block            4.62
    Threads                                   thread         4161536
    Waves Per SM                                              101.60
    -------------------------------- --------------- ---------------

    Section: Occupancy
    ------------------------------- ----------- ------------
    Metric Name                     Metric Unit Metric Value
    ------------------------------- ----------- ------------
    Block Limit SM                        block           16
    Block Limit Registers                 block            2
    Block Limit Shared Mem                block            6
    Block Limit Warps                     block            1
    Theoretical Active Warps per SM        warp           32
    Theoretical Occupancy                     %          100
    Achieved Occupancy                        %        94.36
    Achieved Active Warps Per SM           warp        30.20
    ------------------------------- ----------- ------------

    INF   This kernel's theoretical occupancy is not impacted by any block limit.                                       

    Section: Source Counters
    ------------------------- ----------- ------------
    Metric Name               Metric Unit Metric Value
    ------------------------- ----------- ------------
    Branch Instructions Ratio           %         0.11
    Branch Instructions              inst      1170212
    Branch Efficiency                   %        83.34
    Avg. Divergent Branches                     812.36
    ------------------------- ----------- ------------

    WRN   This kernel has uncoalesced global accesses resulting in a total of 1072896 excessive sectors (17% of the     
          total 6274816 sectors). Check the L2 Theoretical Sectors Global Excessive table for the primary source        
          locations. The CUDA Programming Guide                                                                         
          (https://docs.nvidia.com/cuda/cuda-c-programming-guide/index.html#device-memory-accesses) had additional      
          information on reducing uncoalesced device memory accesses.
```
  
