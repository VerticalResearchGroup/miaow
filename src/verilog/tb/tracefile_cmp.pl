#!/usr/bin/perl -w

sub trim($)
{
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}

$in1 = $ARGV[0]; # trace from multi2sim
$in2 = $ARGV[1]; # trace from tracemon

open (FILE1, $in1) || die ("Cannot open multi2sim trace.\n") ;
open (FILE2, $in2) || die ("Cannot open tracemon trace.\n") ;

@file1 = <FILE1> ;
@file2 = <FILE2> ;

@out = (); # trimmed multi2sim trace

foreach(@file1)
{
	if($_ !~ /^$/) {
		if($_ =~ /\/\//) {
			@temp = split(/\//);
			push(@out, " // " . (trim($temp[2])) . "\n");
		}
		elsif($_ !~ /^\s/) {
			if($_ =~ /<=/) {
				push(@out, $_);
			}
		}
	}
}

#push(@out, "");

if (@file2 eq @out) {
	$equals = 1;
	
	foreach (my $i = 0; $i < @out; $i++) {
        if ((trim($file2[$i])) ne (trim($out[$i]))) {
            $equals = 0;
            last;
        }
    }
	
	if($equals == 1) {
		print "TEST PASS!\n";
	}
	else {
		print "TEST FAIL! (Diff)\n";
	}
}
else {
	print "TEST FAIL! (Hang)\n";
}

print "GOLDEN:\n@out";
print "TEST:\n@file2";

#Dump stripped down golden trace
open(GOLDEN,">$in1.gold") or die ("Failed to open $in1.gold") ;
print GOLDEN @out;
close(GOLDEN);

#Dump stripped down verilog trace
open(VERILOG,">$in1.verilog") or die ("Failed to open $in1.verilog");
print VERILOG @file2;
close(VERILOG);
