function course_num_int_to_padded_str(course_num){
    if (isNaN(val))
        return "";
    // course numbers are length 3, padded by 0s
    pad = val+'';
    while (pad.length < 3) {
        pad = '0'+pad;
    }
    return pad;
}
