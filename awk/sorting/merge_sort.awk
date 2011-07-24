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
# Fixes:
# - It seems if we pass arrays using return, we get errors such as
# - awk: merge_sort.awk:42: (FILENAME=- FNR=1) fatal: attempt to use array `return_array' in a scalar context
# Use strings instead


function dump_array(arr_arg){

    arr_arg_len = length(arr_arg)
    RSEP = ORS;
    ORS=" ";
    dctr = 0;
    # Do not use length(arr_arg) in place of arr_arg
    # It fails.
    while (dctr < arr_arg_len){
        print arr_arg[dctr++];
    };
    ORS = RSEP;
    print "\n";
}


function merge_sort(unsorted_str, unsorted_array, left_array, right_array, left_merge, right_merge, result_str, array_length, left_str,  right_str)
{
    # Field splits always begin at idx 1
    split(unsorted_str, unsorted_array, " ");

    array_length = length(unsorted_array);
    str_len = length(unsorted_str);

    if (debug >= 1){
        print "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
        print "Called with string: "unsorted_str
        print "Merge start with arr_length: "array_length;
    }

    if (array_length <= 1 || str_len <= 1){
       return unsorted_str;
    }
    middle_idx = array_length / 2;
    i = 1;
    left_idx = 0;
    right_idx = 0;
    while(i <= middle_idx){
       #print "Appending: "unsorted_array[i]" at idx: "left_idx
       left_array[left_idx++] = unsorted_array[i++];
    }
    while(i <= array_length){
       right_array[right_idx++] = unsorted_array[i++];
    }

    if (debug >= 1){
        print "Left Array: "
        dump_array(left_array);
        print "Right Array: "
        dump_array(right_array);
    }

    # Marshal array back to a string
    left_str=""
    array_length = length(left_array)
    num = 0
    while (num < array_length){
        left_str = left_str" "left_array[num++]	
    }

    # Same thing for right array
    right_str=""
    array_length = length(right_array) 
    num = 0
    while (num < array_length){
        right_str = right_str" "right_array[num++]
    }

    left_merge = merge_sort(left_str);
    right_merge = merge_sort(right_str);
    result_str = merge(left_merge, right_merge);

    return result_str
}

function merge(left_str, right_str, left_array, right_array, result_array, result_str, left_length, right_length)
{
    result_idx = 0
    # Split arrays start at index 1
    left_idx = 1
    right_idx = 1

    split(left_str, left_array, " ");
    split(right_str, right_array, " ");
    left_length = length(left_array)
    right_length = length(right_array)

    if (debug >= 1){
        print "-----------BEGIN-------------- "
        print "Going to merge"
        print "left length: "left_length " - str: "left_str
        print "right length: "right_length " - str: "right_str
    }

    while (left_length > 0  && right_length > 0 )
    {
        if (left_array[left_idx] < right_array[right_idx])
        {
            result_array[result_idx++] = left_array[left_idx];
            delete left_array[left_idx++];
            left_length--;
        }
        else
        {
            result_array[result_idx++] = right_array[right_idx];
            delete right_array[right_idx++];
            right_length--;
        }
    }

    if (debug >= 1){
        print "Partial Merge. Result now: "
        dump_array(result_array);
    }

    left_length = length(left_array)
    right_length = length(right_array)

    if (left_length > 0)
    {
        while (left_length > 0)
        {
            result_array[result_idx++] = left_array[left_idx++];
            left_length--;
        }
    }

    if (right_length > 0)
    {
         while (right_length > 0)
         {
             result_array[result_idx++] = right_array[right_idx++];
             right_length--;
         }
    }

    if (debug >= 1){
        print "Complete Merge. Result now: "
        dump_array(result_array);
    }

    # Marshal array back to a string
    result_str=""
    result_length = length(result_array)
    num = 0
    while (num < result_length){
        result_str = result_str" "result_array[num++]	
    }

    return result_str
}


BEGIN{
    print "Merge Sort"
}

{
    # print the unsorted objects
    print "Unsorted "NF" objects:\n"$0; 

    sorted_str = merge_sort($0)

}

END{
    print "Sorted "NF" objects"; 
    print sorted_str
}
