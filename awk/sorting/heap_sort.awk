# vim: tabstop=4 expandtab shiftwidth=4 softtabstop=4
# Heap sort - As defined here
# http://www.codecodex.com/wiki/Heapsort
# If you want debug invoke add a -v variable to awk such as 
# awk -v debug=1 -f this_file.awk
# A sample bash based random number generator
# generate_random () { for i in $(seq $1); do echo -n "$RANDOM "; done }
# Sample invocation: generate_random 10 | awk -f this_file.awk

function dump_array(arr_arg){

    arr_arg_len = length(arr_arg)
    print "Arg len:"arr_arg_len
    RSEP = ORS;
    ORS=" ";
    dctr = 0;
    # Do not use length(arr_arg) in place of arr_arg
    # It fails.
    while (dctr < arr_arg_len){
        #print dctr":"arr_arg[dctr++];
        print arr_arg[dctr++];
    };
    ORS = RSEP;
    print "\n";
}


function heapSort(a, count, end)
{
    print "============================";
    count = length(a)
    # First place a in max-heap order
    heapify(a, count)

    
    #In languages with zero-based arrays the children are 2*i+1 and 2*i+2
    end = count-1 

    if (debug >= 1){
        print "\n----"
        print "Heapify called: "
        dump_array(arr)
        print "count:"count" end:"end
        print "++++\n"
    }

    while ( end > 0 ){
         # swap the root(maximum value) of the heap with the last element of the heap)
         # swap(a[end], a[0])
         tmp = a[end]
         a[end] = a[0]
         a[0] = tmp

         # put the heap back in max-heap order)
         siftDown(a, 0, end-1)
         # decrease the size of the heap by one so that the previous max value will
         # stay in its proper placement
         end = end - 1
     }
     print "############################";
}
 
function heapify(a, count, start)
{
    # Start is assigned the index in a of the last parent node
    start = int(count / 2) - 1

    if (debug >= 1){
        print "Called with count:"count" start is:"start
    }
    while (start >= 0)
    {
        if (debug >= 1){
            print "Calling siftdown with count :"count-1" start is:"start
            #print "Before array looks like"
            #dump_array(a)
        }

        # Sift down the node at index start to the proper place such that all nodes below
        # the start index are in heap order
        siftDown(a, start, count-1)
        start--;
        if (debug >= 1){
            print "After array looks like"
            dump_array(a)
        }


     }
}
 
function siftDown(a, start, end)
{
    root = start
    
    # While the root has at least one child)
    while (root*2 + 1 <= end){
		child = root * 2 + 1 #root*2 + 1 points to the left child
		
		# Keeps track of child to swap withcheck if root is smaller than left child
		swap = root
		if (a[swap] < a[child]){
			swap = child
		}

		# Check if right child exists, and if it's bigger than what we're currently swapping with
		if ( child < end  && a[swap] < a[child+1] ){
			swap = child + 1
		}
		# Check if we need to swap at all
		if (swap != root){
            # swap(a[root], a[swap])
            if (debug >= 1){
                print " > Swapping "a[root]" with "a[swap]
            }
            tmp = a[swap]
            a[swap] = a[root]
            a[root] = tmp
            if (debug >= 1){
                print "Array after swap "dump_array(a)
            }

			 root = swap #repeat to continue sifting down the child now)
		} else {
			return
		}
	}
}

BEGIN{
	num = 1;
}

{
	array_len = NF;
	# print the unsorted objects
	print "Unsorted "NF" objects:\n"$0; 

	# Put the random numbers into an array
    # $0 is special in awk, elements start at $1
	while (num <= NF){ 
		arr[num-1] = $num;
		num++
	};
    heapSort(arr)

}

END{
	print "Sorted "NF" objects"; 
    dump_array(arr)
}
