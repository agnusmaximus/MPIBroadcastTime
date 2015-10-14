PROCS=(2 4 8 16 32)
for i in $(seq 0 $((${#PROCS[*]}-1)))
do
    make N_PROCS=${PROCS[i]} compare
done
