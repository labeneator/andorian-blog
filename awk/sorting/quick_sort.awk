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


function simple_quicksort(unsorted_str,unsorted_array,pivot,less_str,more_str)
{

	# Unpack from the str - space separated
	print "******************************"
	print "Called with "unsorted_str
	# Split the space separated string into an array
	split(unsorted_str, unsorted_array, " ");

	array_len = length(unsorted_array);

	# No more sorting to be done. Break recursion
	if (array_len <= 1){
		print "Ending recursion with "unsorted_str
		return unsorted_str
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
		# Skip pivot
		if (idx != num){
			if (unsorted_array[num] <= pivot){
				if (debug >= 1){
					print "Element less than pivot: "unsorted_array[num]
				}
				less_arr[less_ctr] = unsorted_array[num]
				less_ctr++;
			}else{
				if (debug >= 1){
					print "Element more than pivot: "unsorted_array[num]
				}
				more_arr[more_ctr] = unsorted_array[num]
				more_ctr++;
			}
		}
		num++
	};
	# strip out the holder in idx 0
	delete less_arr[0]
	delete more_arr[0]
	if (debug >= 1){
		print "Less than pivot:"
		print dump_array(less_arr)
		print "More than pivot:"
		print dump_array(more_arr)
	}

	# Marshal array back to a string
	less_str=""
	less_length = length(less_arr)
	num = 1
	print "Less length: "less_length
	while (num <= less_length){
		less_str = less_str" "less_arr[num]	
		num++;
	}

	# same thing for more
	more_str=""
	more_length = length(more_arr) 
	num = 1
	while (num <= more_length){
		more_str = more_str" "more_arr[num]
		num++;
	}

	if (debug >= 1){
		print "Going for a recursive call with elements < pivot: "less_str
		print "Going for a recursive call with elements > pivot: "more_str
		print "pivot was: "pivot
	}

	# Tried to delete the local variables
	# Coz it seems like local vars are visible to recursed functions
	# Is this why it fails?
	delete less_arr
	delete more_arr
	delete unsorted_array
	print "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
	print ""
	
	return simple_quicksort(less_str) " "pivot" "simple_quicksort(more_str)


}

BEGIN{
	print "-- quick sort --"
}

{
	# print the unsorted objects
	print "Unsorted "NF" objects:\n"$0; 

	# We'll use a slightly different method,
	# Pass the $0 string to the sorter, let it split
	# it into an array, qsort that array, generate sub- 
	# strings and recursively qsort them

	#Simple version
	sorted = simple_quicksort($0)
	split(sorted, sorted_array, " ");


}

END{
	print "Sorted "NF" objects"; 
	dump_array(sorted_array)
}
