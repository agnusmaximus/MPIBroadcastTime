#include <iostream>
#include <time.h>
#include <stdlib.h>
#include <mpi.h>
#include <sys/time.h>

using namespace std;

long long int get_time() {
  struct timeval tp;
  gettimeofday(&tp, NULL);
  return tp.tv_sec * 1000 + tp.tv_usec / 1000;
}

int main(void) {
    //Initialization
    int n_procs, proc_id;
    MPI_Init(NULL, NULL);
    MPI_Comm_rank(MPI_COMM_WORLD, &proc_id);
    MPI_Comm_size(MPI_COMM_WORLD, &n_procs);
    MPI_Barrier(MPI_COMM_WORLD);

    //Create n_workers different arrays
    int n_workers = n_procs - 1;
    char *data;
    if (proc_id == 0) {
	data = (char *)malloc(sizeof(char) * BROADCAST_ARRAY_SZ);
	for (int i = 0; i < BROADCAST_ARRAY_SZ; i++)
	    data[i] = (char)(i % 256);
    }
    else {
	data = (char *)malloc(sizeof(char) * BROADCAST_ARRAY_SZ);
    }

    long long int start_time = -1;

    MPI_Barrier(MPI_COMM_WORLD);
    if (proc_id == 0) start_time = get_time();

    //Broadcast to workers
    MPI_Bcast(data, BROADCAST_ARRAY_SZ, MPI_CHARACTER, 0, MPI_COMM_WORLD);

    if (proc_id == 0) {
	MPI_Request waiting[n_workers];
	MPI_Status statuses[n_workers];
	char done_waiting[n_workers];
	for (int i = 0; i < n_workers; i++) {
	    MPI_Irecv(&done_waiting[i], 1, MPI_CHARACTER, i+1,
		      0, MPI_COMM_WORLD, &waiting[i]);
	}
	MPI_Waitall(n_workers, waiting, statuses);
	long long int end_time = get_time();
	cout << "TIME ELAPSED: " << end_time-start_time << endl;
    }
    else {
	char a;
	MPI_Send(&a, 1, MPI_CHARACTER, 0, 0, MPI_COMM_WORLD);
    }
    MPI_Finalize();
}
