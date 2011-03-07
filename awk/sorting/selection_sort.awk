#Selection sort
# Scans an array for the largest array and moves it to the end
# nth largest moves to length(array) - nth position.

BEGIN{
	sorted = 0;	
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
	
	# Search for the max integer, store it, 
	# remember where we got it and swap it 
	# with the element at the last position
	# when we finish scanning the array
	while (array_len > 1){
		num = 1;
		max = 0;
		swap_pos = 0;
		if (debug > 0){
			print "Array_len "array_len
		}
		while (num <= array_len){
			if (max < arr[num]){
				max = arr[num];	
				swap_pos = num;
			}
			num++;
		};
		if (swap_pos > 0){
			if (debug > 0){
				print "Found: "max" moving to "array_len
			}
			arr[swap_pos] = arr[array_len];
			arr[array_len] = max;	
		}
		array_len--;
	}
}

END{
	print "Sorted "NF" objects"; 
	# Print out the sorted array in a line. 
	# We need to replace the output record separator
	# with " " instead of  "\n"
	RSEP = ORS;
	ORS=" ";
	num = 1; 
	while (num <= NF){
		print arr[num]; 
		num++
	}; 
	ORS = RSEP;
	print "\n";
}
