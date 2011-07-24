# Bubble sort
# if we want debug invoke add a -v variable to awk such as 
# awk -v debug=1 -f this_file.awk
# A sample bash based random number generator
# generate_random () { for i in $(seq $1); do echo -n "$RANDOM "; done }
# Sample invocation: generate_random 10 | awk -f this_file.awk

BEGIN{
	# Initial sort status
	sorted = 0; 
	# Counter variable
	num = 1; 
}

{
	# print the unsorted objects
	print "Unsorted "NF" objects:\n"$0; 

	# Put the random numbers into an array
	while (num <= NF){ 
		arr[num] = $num;
		num++
	};

	# Bubble sort it out
	while(sorted == 0){
		num = 2;
		sorted = 1;
		# Go through the array
		while (num <= NF){ 
			curr = arr[num];
			if (debug > 0){
				print "Checking:"num" "arr[num-1]" < "curr;
			}
			# Swap array values and reset sorted variable
			if (curr < arr[num-1]){
				sorted = 0; 
				if (debug > 0){
					print "Swapping";
				}
				temp = arr[num-1];
				arr[num-1] = curr; 
				arr[num] = temp; 
			} 
			num++;
		} 
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
