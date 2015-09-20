N_RUNS = 10
N_PROCS = 11
BROADCAST_ARRAY_SZ = 720*720*8
SCATTER_ARRAY_SZ = 720*720*8

single:
	mpic++ -DBROADCAST_ARRAY_SZ=$(BROADCAST_ARRAY_SZ) broadcast_benchmark_singlechunk.cpp -o singlechunk
	mpirun -np 11 ./singlechunk
multi:
	mpic++ -DSCATTER_ARRAY_SZ=$(SCATTER_ARRAY_SZ) scatter_benchmark_multichunk.cpp -o multichunk
	mpirun -np 11 ./multichunk
compare:
	mpic++ -DBROADCAST_ARRAY_SZ=$(BROADCAST_ARRAY_SZ) broadcast_benchmark_singlechunk.cpp -o singlechunk
	mpic++ -DSCATTER_ARRAY_SZ=$(SCATTER_ARRAY_SZ) scatter_benchmark_multichunk.cpp -o multichunk
	rm -f singlechunk_output
	rm -f multichunk_output
	for i in `seq 1 $(N_RUNS)`; do mpirun -np $(N_PROCS) ./singlechunk >> singlechunk_output; done
	for i in `seq 1 $(N_RUNS)`; do mpirun -np $(N_PROCS) ./multichunk >> multichunk_output; done
	more singlechunk_output | grep "TIME ELAPSED: " | grep -oEi '[0-9]+' | awk 'NR == 1 { max=$$1; min=$$1; sum=0 } { if ($$1>max) max=$$1; if ($$1<min) min=$$1; sum+=$$1;} END {printf "Min: %d\tMax: %d\tAverage: %f\n", min, max, sum/NR}'
	more multichunk_output | grep "TIME ELAPSED: " | grep -oEi '[0-9]+' | awk 'NR == 1 { max=$$1; min=$$1; sum=0 } { if ($$1>max) max=$$1; if ($$1<min) min=$$1; sum+=$$1;} END {printf "Min: %d\tMax: %d\tAverage: %f\n", min, max, sum/NR}'
