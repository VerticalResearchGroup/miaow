#!/usr/bin/perl -w

use warnings "all";
use Getopt::Long;

#*****************************SECTION 0**********************************
#Summary of script function
#-Read and parse the input file
#-Identify each embedded perl section and do the following
#--Create a perl script
#--Run the perl script
#--Append the output of the script to the output file
#************************************************************************

#*****************************SECTION I**********************************
#Declaration and initialization of variables
my $infile = "";
my $outfile = "";
my $help = 0;
my $release = 0;
my $opt_result;
my $script_name = $0;
my @stat_infile;
my @stat_outfile;
my @stat_script;
my @input_file;
my $perl_script;
my $input_file_size;
my $i;
my @outfile_contents = ();
my @perlfile_contents = ();
my $parse_status;
my $perlsection_count;
my $perlfile;
my $perlfile_output;
my @perl_output;
my $printlineno_1;
my $printlineno_2;
#************************************************************************

#*****************************SECTION II*********************************
#Parse command line arguments and check for sanity of command line arguments
$opt_result = GetOptions (
  "infile=s"   => \$infile,
  "outfile=s"  => \$outfile,
  "help"       => \$help,
  "release"    => \$release
);

if(!$opt_result)
{
  print STDERR "$script_name: Invalid command line options!\n";
  print STDERR "$script_name: Use -help if you need it :)\n";
  die;
}
if($help)
{
  print_help();
  exit 0;
}
if($infile eq "")
{
  print STDERR "$script_name: Compulsory option -infile is missing!\n";
  print STDERR "$script_name: Use -help if you need it :)\n";
  die;
}
if($outfile eq "")
{
  print STDERR "$script_name: Compulsory option -outfile is missing!\n";
  print STDERR "$script_name: Use -help if you need it :)\n";
  die;
}
if(!(-e $infile))
{
  print STDERR "$script_name: Input file $infile does not exist!\n";
  die;
}
if(-e $outfile)
{
  @stat_script = stat($script_name);
  @stat_infile = stat($infile);
  @stat_outfile = stat($outfile);
  if(($stat_infile[1] == $stat_outfile[1]) && ($stat_infile[0] == $stat_outfile[0]))
  {
    print STDERR "$script_name: Input file should not be same as output file!\n";
    die;
  }
  if(($stat_script[1] == $stat_outfile[1]) && ($stat_script[0] == $stat_outfile[0]))
  {
    print STDERR "$script_name: The script should not be same as output file!\n";
    die;
  }
}
#************************************************************************

#*****************************SECTION III********************************
#This is the functional part of the script

#Read the contents of the input file
if(0 == open(INFILE, "$infile"))
{
  print STDERR "$script_name: Cannot open $infile for reading!\n";
  die;
}
@input_file = <INFILE>;
close(INFILE);
$input_file_size = scalar(@input_file);

#$parse_status takes the value "verilog" if we are in a section of regular verilog code
#If in an embedded perl section, $parse_status takes the value of the starting
#line number of the perl section 
$parse_status = "verilog";
$perlsection_count = 0;
#Loop to iterate over and process each line of the input file
for($i=0; $i<$input_file_size; $i=$i+1)
{
  $line = $input_file[$i];
  #For line marking the beginning of an embedded perl section
  if($line =~ m/^%%start_veriperl/)
  {
    $parse_status = "$i";
    @perlfile_contents = ();
    if(!$release)
    {
      push(@outfile_contents, "// $line");
    }
    #Loop to iterate until we reach the end of the perl section or end of the input file
    for($i=$i+1 ; $i<$input_file_size; $i=$i+1)
    {
      $line = $input_file[$i];
      if(!$release)
      {
        push(@outfile_contents, "// $line");
      }
      if($line =~ m/^%%start_veriperl/)
      {
        $printlineno_1 = $i + 1;
        $printlineno_2 = $parse_status + 1;
        print STDERR "$script_name: %%start_veriperl at line $printlineno_1 occurs within a veriperl section starting at line $printlineno_2!\n";
        die;
      }
      #If the script sees the end of the perl section
      elsif($line =~ m/^%%stop_veriperl/)
      {
        $parse_status = "verilog";
        $perlsection_count = $perlsection_count + 1;
        #Call the run_perl function
        run_perl();
        last;
      }
      #For a regular perl line in the ebedded perl section, keep pushing to an array
      else
      {
        push(@perlfile_contents, "$line");
      }
    }
  }
  #%%stop_veriperl should not be seen before %%start_veriperl
  elsif($line =~ m/^%%stop_veriperl/)
  {
    $printlineno_1 = $i + 1;
    print STDERR "$script_name: %%stop_veriperl at line $printlineno_1 is not matched by an earlier %%start_veriperl!\n";
    die;
  }
  #For lines which are part of regular verilog code, push them to an array
  else
  {
    push(@outfile_contents, "$line");
  }  
}

#If $parse_status is not verilog, there is an unterminated perl section
if(!($parse_status eq "verilog"))
{
  $printlineno_1 = $parse_status + 1;
  print STDERR "$script_name: %%start_veriperl at line $printlineno_1 is not matched by a later %%stop_veriperl!\n";
  die;
}

#Open the output file and print the output
if (0 == open(OUTFILE, ">$outfile"))
{
  print STDERR "$script_name: Cannot open $outfile for writing!\n";
  die;
}
print OUTFILE @outfile_contents;
close(OUTFILE);
#************************************************************************

#*****************************SECTION IV*********************************
#Function for creating perl scripts and running them
sub run_perl
{
  #Create a perl file for dumping the contents of the embedded perl section in verilog
  $perlfile = "$outfile-veriperl-$perlsection_count.pl";
  if (0 == open(PERLFILE, ">$perlfile"))
  {
    print STDERR "$script_name: Cannot open $perlfile for writing!\n";
    die;
  }
  #Header for the embedded perl file  
  print PERLFILE qq{#!/usr/bin/perl -w

use warnings "all";
};
  print PERLFILE @perlfile_contents;
  close(PERLFILE);
  #Setup the script output file, set execute permissions, run the script
  $perlfile_output = "$perlfile.out";
  `chmod u+x $perlfile`;
  `./$perlfile > $perlfile_output`;
  #Read the output generated by the embedded perl script
  if (0 == open(PERLOUT, "$perlfile_output"))
  {
    print STDERR "$script_name: Cannot open $perlfile_output for reading!\n";
    die;
  }
  @perl_output = <PERLOUT>;
  close(PERLOUT);
  `rm -f $perlfile $perlfile_output`;
  #Append the output of the embedded perl to the output verilog file
  @outfile_contents = (@outfile_contents, @perl_output);
}
#************************************************************************

#*****************************SECTION V**********************************
#Function for printing help message
sub print_help
{
print STDOUT qq{$script_name:

DESCRIPTION:
	This script can parse pseudo verilog files with embedded perl code and generate verilog code as the output. The embedded verilog code in the input file should be enclosed within %%start_veriperl and %%stop_veriperl.

USAGE:
	$script_name -i <input_file_name> -o <output_file_name> [-r] [-h]

ARGUMENTS:

-i
-infile <input_file_name>	This is a compulsory option; used to specify the name of the pseudo verilog input file.

-o
-outfile <output_file_name>	This is a compulsory option; used to specify the name of the output verilog file.

-r
-release			With this option, the output file will not have comments generated by veriperl. This option can be used for releasing verilog.

-h
-help				Well, you know what this option is for! You couldn't be reading this otherwise.
};
}
#************************************************************************
