#!/bin/bash

#Random number generator
generate_random () { for i in $(seq $1); do echo -n "$RANDOM "; done }

#How many integers to randomly generate
#SET_SIZES="100 500 "
SET_SIZES=$(seq 100 100 1500)
# How many iterations to run
ROUNDS=10
# what algorithms do we have?
SORT_METHODS="bubble_sort.awk quick_sort.awk selection_sort.awk"


for SET_SIZE in $SET_SIZES;
do
	#Generate the set
	generate_random $SET_SIZE > random_ints;

	#Run an algorithm
	for METHOD in $SORT_METHODS;
	do
		echo -n "Doing $ROUNDS rounds of $METHOD with a dataset of $SET_SIZE ints. "
		#For X rounds
		for round in $(seq $ROUNDS); 
		do 
			time cat random_ints |awk -f $METHOD |grep -e "(real)"; 
		# It becomes interesting here:
		# Redirect the output of time from stderr to stdin
		# Look up the real time, remove the minute and second parameters
		# from the time output replacing them with spaces <good for awk>
		# Iterate over each line result totalling up the time spent,
		# average it and print it out
		done 2>&1 |grep -e "real"|cut -f 2|sed -e "s/[ms]/ /g" |awk  'BEGIN{total=0} {total= total + $1*60+$2} END{print "Average real time in seconds: "total/NR}'
		echo ""
	done
done

