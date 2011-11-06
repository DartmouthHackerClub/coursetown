#!/usr/bin/perl

$output = "";

while (<>) {

    if (/<td class="left">([\w ]+)<\/td>/) {
	$dept = uc $1;
    }
    
    if (/<td><a href="http:\/\/www.dartmouth.edu\/~reg\/courses\/desc\/([\w-]+).html">Courses<\/a><\/td>/) {
	$abbrev = uc $1;
	$output = $output . "{\"dept_name\" : \"$dept\", \"dept_abbrev\": \"$abbrev\"}, ";
    }
}

chop $output; chop $output;

print "{\"abbrevs\": [$output]}"
