# Quick sort - Simple variant. Requires 0(n) extra store 
# Divide and conquer. Pick a pivot, compare elements to
# pivot generating two sublists; one greater than pivot 
# and the other less than pivot. Sort this two recursively.
# See http://en.wikipedia.org/wiki/Quicksort#Simple_version

function dump_array(arr_arg){

	arr_arg_len = length(arr_arg)
	RSEP = ORS;
	ORS=" ";
	dctr = 1; 
	# Do not use length(arr_arg) in place of arr_arg
	# It fails. The following doesn't work
	#while (dctr <= arr_arg_len){
	while (dctr <= arr_arg_len){
		print arr_arg[dctr]; 
		dctr++;
	}; 
	ORS = RSEP;
	print "\n";
}


function concatenate_array(arr_arg1, arr_arg2)
{
	#Concatenates two arrays
	# assumes integer indices
	arr_arg1_len = length(arr_arg1)	
	arr_arg2_len = length(arr_arg2)	
	ctr = 1
	while (ctr <= arr_arg2_len){
		arr_arg1[ctr+arr_arg1_len] = arr_arg2[ctr]; 
		ctr++;
	}; 
}

function simple_quicksort(unsorted_array)
{
	array_len = length(unsorted_array);

	if (array_len <= 1){
		return unsorted_array
	}
	# Pick a random value as pivot
	# index must not be 0
	idx = 0
	while (idx == 0){
		srand()
		idx = int(rand() * array_len)
	}
	pivot = unsorted_array[idx]
	if (debug >= 1){
		print "---------------------------------"
		print "idx:"idx" pivot is: "pivot
	}

	num = 1;
	# we don't use the zero'th element,
	# this helps us declare an empty array
	# dunno any other method
	# we'll remove it anyway
	less_arr[0] = 0
	less_ctr = 1
	more_arr[0] = 0
	more_ctr = 1
	while (num <= array_len){ 
		if (idx != num){
			if (unsorted_array[num] <= pivot){
				if (debug >= 1){
					print "less than pivot: "unsorted_array[num]
				}
				less_arr[less_ctr] = unsorted_array[num]
				less_ctr++;
			}else{
				if (debug >= 1){
					print "more than pivot: "unsorted_array[num]
				}
				more_arr[more_ctr] = unsorted_array[num]
				more_ctr++;
			}
		}
		num++
	};
	print "Less:"
	print dump_array(less_arr)
	print "More:"
	print dump_array(more_arr)
	# concatenate_array(less_arr, more_arr)
	#print "concat:"dump_array(less_arr)
	print "+++++++++++++++++++++++++++++++++++++++++++"

	delete less[0];
	delete more[0];

}

BEGIN{
	num = 1;
}

{
	array_len = NF;
	# print the unsorted objects
	print "Unsorted "NF" objects:\n"$0; 

	# Put the random numbers into an array
	while (num <= NF){ 
		arr[num] = $num;
		num++
	};

	#Simple version
	simple_quicksort(arr)

}

END{
	print "Sorted "NF" objects"; 
	# Print out the sorted array in a line. 
	# We need to replace the output record separator
	# with " " instead of  "\n"
	dump_array(arr)
}
