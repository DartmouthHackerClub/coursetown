#!/usr/bin/perl

# use curl http://www.dartmouth.edu/~reg/201103_nro.html to get html 
#
# scrapes data from NRO webpage
# takes input from stdin
# outputs JSON to stdout
# JSON format is
# {
#   [
#     {
#       "department" : $department,
#       "courses": [
#         $coursenumber1,
#         ...
#       ]
#     }
#   ]
# }
# some departments don't let you NRO any courses,
# in this case output will be "courses": "all"




$flag = 0;

while (<>) {
    
    if (/NON-RECORDING OPTION OUT-OF-BOUNDS/) {
	$flag = 1;
    }
 
    if (/<p>([a-zA-Z ']+)((: All courses)|( [\d,\w\(\) ]+))<\/p>/ && $flag) {
	$dept = uc $1;
	$dept = `../utils/dept_abbrev.pl '$dept'`;
	chomp($dept);

	if ($dept) {
	    $output = $output . parseCourseNumList($dept, $2) . ", ";
	}
    }
}

sub parseCourseNumList() {
    my ($dept, $nums) = @_;
    
    if ($nums =~ "All courses") {
	return "{\"department\": \"$dept\", \"courses\": \"all\"}";
    }

    my $out = "{\"department\": \"$dept\", \"courses\": [";

    while ($nums =~ /(\d+)([\(\)\w\d, ]*)/) {
	$out = $out . "$1, ";
	$nums = $2;
    }

    chop $out; chop $out; # delete extra comma and space on the end
    return $out . "]}";
}

chop $output; chop $output; # delete extra comma and space on the end

print "[$output]\n";
