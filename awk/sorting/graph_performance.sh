#!/bin/sh
RESULT_FILE="tmp/results.txt"
GRAPH_IMAGE="./performance.png"
./make_stats.sh > ${RESULT_FILE}
cat ${RESULT_FILE} |sed -e "s/.* of \(\w\+\).awk.* \([0-9]\+\) ints.*\: \(.*\)/\1 \2 \3/g"|sort|grep bub > tmp/bsort.perf 
cat ${RESULT_FILE} |sed -e "s/.* of \(\w\+\).awk.* \([0-9]\+\) ints.*\: \(.*\)/\1 \2 \3/g"|sort|grep qui > tmp/qsort.perf 
cat ${RESULT_FILE} |sed -e "s/.* of \(\w\+\).awk.* \([0-9]\+\) ints.*\: \(.*\)/\1 \2 \3/g"|sort|grep sele > tmp/ssort.perf 


echo """
set terminal png;
set output "$GRAPH_IMAGE";
set xrange [0:];
set title "Sort performance";
set xlabel "Sort set size";
set ylabel "Time in seconds";
plot "./tmp/qsort.perf" using 2:3 smooth csplines title "Quick sort", "./tmp/ssort.perf" using 2:3 smooth csplines title "Selection sort", "./tmp/bsort.perf" using 2:3 smooth csplines title "Bubble sort"
"""|gnuplot

