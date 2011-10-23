#!/usr/bin/perl
use JSON;
use Memoize;
use strict;
use Switch;
use Text::CSV;
my $stdin = *STDIN;
 my $csv = Text::CSV->new ( { binary => 1 } )  # should set binary attribute.
                 or die "Cannot use CSV: ".Text::CSV->error_diag ();
#use CouchDB::Client;
#my $dbserver = shift @ARGV;
#my $dbname = shift @ARGV;
#my $c = CouchDB::Client->new(uri => $dbserver);
# $c->testConnection or die "The server cannot be reached";
#print "Running version " . $c->serverInfo->{version} . "\n";
#my $db = $c->newDB($dbname);
sub dndlookup{
    my $profinformal = shift;
    return `dndlookup -f NAME  -f UID $profinformal`;
}
memoize('dndlookup');
my %whatsubject = ();
my @courses;
#For CouchDB
my $updatetime = time();
my $formatrev = 1;  # The major revision
while(my $_  = $csv->getline($stdin) ){ # Read courses
    next unless defined; # Detect EOF
    my @coursedata = @{$_};
    my %course = ();
    my ($term,$CRN,$deptcode,$num,$section,$title,$xlist_string,$period,$room,$building,$profs_string,$wc,$dist,$lim,$enroll) = @coursedata;
    my $fys = "N"; # TODO: Re-add first year seminars
    # my $CRN = "$term-$deptcode-$num-$section";
    next if $whatsubject{"$deptcode $num $section $term"};
    $course{'CRN'} = $CRN;
    $course{'title'} = $title;
    $course{'period'} = $period;
    $course{'wc'} = $wc;
    my @distribs = split /\ or\ /,$dist;
    $course{'dist'} = \@distribs;
    $course{'enroll'} = $enroll;
    $course{'limit'} = $lim;
      
    my $lab = "No";
    if (($dist=~/SLA/) || ($dist =~/TLA/)){ # Check for lab
	$lab= "Yes";
    }
    my $type;
    # First year seminar
    if($fys == "N"){
	$type="Dartmouth";
    }
    elsif($fys=="Y"){
	$type="Dartmouth";
    }
    else {"Invalid FYS attribute, has to be Y or N". $fys;
    }
    next if ($period == "AR" || $period =="");
    next if ($title =~ /\(Laboratory\)\s*$/ || $title =~ /\(Discussion\)\s*$/);
    $type= "FSP" if($period == "FS");
    $type = "LSA" if($period == "LS");
    my ($termnum,$termyear);
    if($term =~ /(\d\d\d\d)(\d\d)/){
	switch ($2){
	    case "01"    {$termnum = "Winter";}
	    case "03"	 {$termnum = "Spring";}
	    case "06"    {$termnum = "Summer";}
	    case "09"    {$termnum = "Fall";}
	    else {die "What term is $2";}
		
	}
	$termyear =$1;
    } else {
	die "Could not parse term number" . $term;
    }
    $course{'term'} = $termnum;
    $course{'year'} = $termyear;
    $course{'lab'} = $lab;
    $course{'type'} = $type;
    my @names;
    $xlist_string = "$deptcode $num $section" . $xlist_string;
    chomp $xlist_string;
    if($xlist_string){
	foreach (split(/,/,$xlist_string)){ # Every crosslisted course
	    #print $_;
	    if($_ =~ /(\S+)\s+(\d+)\s+(\d+)/){
		push @names, { 'Department' => $1,
			       'Number' => $2,
			       'Section' => $3};
		$whatsubject{"$1 $2 $3 $term"} = 1;
	    }
	    else{
		print STDERR  "Ignoring invalid XLIST specification $_\n";
	    }
	}
    }
    $course{'names'} = \@names;
    my @profs = split(/,/,$profs_string);
    $course{'Professors'} =  \@profs;
    $course{'_id'} = $CRN;
    $course{'_rev'} = "$formatrev-$updatetime";
    
    push @courses, \%course;
}
my %update;
$update{'docs'}=\@courses;
print to_json(\%update);


