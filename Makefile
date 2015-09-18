single:
	mpic++ broadcast_benchmark_singlechunk.cpp -o singlechunk
	mpirun -np 11 ./singlechunk
multi:
	mpic++ scatter_benchmark_multichunk.cpp -o multichunk
	mpirun -np 11 ./multichunk
