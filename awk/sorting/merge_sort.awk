# Merge sort - As defined here
# http://www.codecodex.com/wiki/Merge_sort#Pseudocode
# Divide an array into two sub arrays recursively till a ?singleton?
# Reassemble the array (merge) while sorting 
# If you want debug invoke add a -v variable to awk such as 
# awk -v debug=1 -f this_file.awk
# A sample bash based random number generator
# generate_random () { for i in $(seq $1); do echo -n "$RANDOM "; done }
# Sample invocation: generate_random 10 | awk -f this_file.awk
# vim: tabstop=4 expandtab shiftwidth=4 softtabstop=4

function dump_array(arr_arg){

    arr_arg_len = length(arr_arg)
    #print "Dumper has seen arr_arg_len: "arr_arg_len
    RSEP = ORS;
    ORS=" ";
    dctr = 0;
    # Do not use length(arr_arg) in place of arr_arg
    # It fails. The following doesn't work
    while (dctr < arr_arg_len){
        print arr_arg[dctr++];
        #print dctr" : "arr_arg[dctr++];
    }; 
    ORS = RSEP;
    print "\n";
}


function merge_sort(unsorted_array,left_array, right_array, left_merge, right_merge, result_array, array_length)
{
    array_length = length(unsorted_array)
    print "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
    print "Merge start with arr_length: "array_length;
    print "Array looks like: "
    dump_array(unsorted_array)

    if (array_length <= 1){
        #This is stupid
        return_array[0] = unsorted_array[0]
       return return_array;
    }
    middle_idx = array_length / 2;
    i = 0;
    left_idx = 0;
    right_idx = 0;
    while(i < middle_idx){
       left_array[left_idx++] = unsorted_array[i++];
    }
    while(i < array_length){
       right_array[right_idx++] = unsorted_array[i++];
    }

    # Delete vars
    #delete unsorted_array

    print "Left Array: "
    dump_array(left_array);
    print "Right Array: "
    dump_array(right_array);

    left_merge = merge_sort(left_array);
    right_merge = merge_sort(right_array);
    result_array = merge(left_merge, right_merge);
    print "#######################################"
    return result
}

function merge(left_array, right_array, result_array)
{
    result_idx = 0
    left_idx = 0
    right_idx = 0

    left_length = length(left_array)
    right_length = length(right_array)

    print "-----------BEGIN-------------- "
    print "Going to merge"
    print "Left: "
    dump_array(left_array);
    print " - "
    print "Right:"
    dump_array(right_array);

    while (left_length > 0  && right_length > 0 )
    {
        if (left_array[0] > right_array[0])
        {
            result_array[result_idx++] = left_array[left_idx];
            delete left_array[left_idx++];
        }
        else
        {
                result_array[result_idx++] = right_array[right_idx];
        delete right_array[right_idx++];
        }
    }


    print "Partial Merge. Result now: "
    dump_array(result_array);


    left_length = length(left_array)
    right_length = length(right_array)
    
    if (left_length > 0)
    {
     print "Appending remainder of left to result"
     dump_array(left_array);
     while (left_length >= 0)
     {
          result_array[result_idx++] = left_array[left_idx++];
          left_length--;
     }
    } 
    
    if (right_length > 0)
    {
         print "Appending remainder of right to result"
         dump_array(right_array);

         while (right_length >= 0)
         {
             result_array[result_idx++] = right_array[right_idx++];
             right_length--;
         }
    } 

    print "Complete Merge. Result now: "
    dump_array(result_array);
    print "+++++++++++BEGIN++++++++++++++ "

    return result
}


BEGIN{
    print "Merge Sort"
    num = 1
}

{
    # print the unsorted objects
    print "Unsorted "NF" objects:\n"$0; 

    # Put the random numbers into an array
    while (num <= NF){ 
        arr[num-1] = $num;
        num++
    };
    merge_sort(arr)

}

END{
    print "Sorted "NF" objects"; 
}
