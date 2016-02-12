#!/usr/bin/perl -w  

use warnings "all";
use Getopt::Long;

my $opt_result;
my $test = "";
my $rdir = "";
my $outdir = "";
my $waves = 0;
my $glitch = 0;
my $killtime = 0;
my $copy = 0;
my $force = 0;
my $list = 0;
my $dontrun = 0;
my $argument = "";
my $help = 0;
my $script_name = $0;
my $pwd;
my $starttime = 0;
my $endtime = 0;
my $elapsedtime = 0;
my $hostname;

my $batchdir;
my $testconfigdir;
my $testdir;
my @raw_test_list;
my @available_tests;
my $waveform = "";
my @tracecmp;
my $testcount = 0;
my $passcount = 0;
my @summary = ();
my @logappend;
my $passed_wavefronts;
my $failed_wavefronts;
my $total_wavefronts;
my @goldentraces;

$pwd = `pwd`;
chomp($pwd);
$hostname = `hostname`;
chomp($hostname);

#Parse arguments
$opt_result = GetOptions (
  "test=s"       => \$test,
  "rdir=s"       => \$rdir,
  "outdir=s"     => \$outdir,
  "waves"        => \$waves,
  "glitch"       => \$glitch,
  "killtime=s"   => \$killtime,
  "copy"         => \$copy,
  "force"        => \$force,
  "list"         => \$list,
  "dontrun"      => \$dontrun,
  "argument=s"   => \$argument,
  "help"         => \$help
);

#Sanity check of arguments
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
if($test eq "")
{
  print STDERR "$script_name: Compulsory option -test is missing!\n";
  print STDERR "$script_name: Use -help if you need it :)\n";
  die;
}
if($rdir eq "")
{
  print STDERR "$script_name: Compulsory option -rdir is missing!\n";
  print STDERR "$script_name: Use -help if you need it :)\n";
  die;
}
if($killtime == 0)
{
  #Setting default killtimes if not specified
  if ($rdir =~ /^[1-5]$/)
  {
    #100 for unit tests
    $killtime = 10000;
  }
  else
  {
    #A 100 million for benchmarks
    $killtime = 100000000000;
  }
}
if(($outdir eq "") && (0 == $list))
{
  print STDERR "$script_name: Compulsory option -outdir is missing!\n";
  print STDERR "$script_name: Use -help if you need it :)\n";
  die;
}
$batchdir = "results/$outdir";
if((-d $batchdir) && (0 == $force) && (0 == $list))
{
  print STDERR "$script_name: Result directory $outdir already exists! Use -f to overwrite or try another name.\n";
  die;
}
if(1 == $waves)
{
  $waveform = "+dump_waveforms=1";
  if(1 == $glitch)
  {
    $waveform = "$waveform +dump_glitches=1";
  }
}
if ("" ne $argument)
{
  $waveform = "$waveform $argument";
}

my $test_source;
if("0" eq $rdir)
{
  $test_source = "../../sw/benchmarks";
}
elsif ("6" eq $rdir)
{
	$test_source = "../../sw/rodinia/opencl";
}
elsif ("7" eq $rdir)
{
	$test_source = "../../sw/AMDAPP_4.2";
}
elsif ($rdir =~ /^[1-5]$/)
{
  $test_source = "../../sw/miaow_unit_tests";
}
else
{
  $test_source = $rdir;
}

#Find list of available tests
@raw_test_list = `cd $test_source && ls -d *`;
chomp(@raw_test_list);
foreach $thistest (@raw_test_list)
{
  if(($thistest !~ m/^std_instr.csv$/) && ($thistest !~ m/^run$/) && ($thistest !~ m/^common$/))
  {
    push(@available_tests,$thistest);
  }
}

if(1 == $list)
{
  foreach $thistest (@available_tests)
  {
    if($thistest =~ m/$test/)
    {
      print "$thistest\n";
    }
  }
  exit 0;
}

#Create the batch directory
`rm -rf $batchdir && mkdir -p $batchdir`;

#Copy the simv and related files to batch directory
if(1 == $copy)
{
  `cp simv $batchdir/.`;
  `cp -r simv.daidir $batchdir/.`;
  `cp -r csrc $batchdir/.`;
  `cp compile.log $batchdir/.`;
}
else
{
  `cd $batchdir && ln -s $pwd/simv simv`;
  `cd $batchdir && ln -s $pwd/simv.daidir simv.daidir`;
  `cd $batchdir && ln -s $pwd/csrc csrc`;
  `cd $batchdir && ln -s $pwd/compile.log compile.log`;
}

#Open sumamry file
open(SUMMARY, ">$batchdir/summary.txt");
print SUMMARY "***************************************************\n";
print SUMMARY "Summary:\n";

foreach $thistest (@available_tests)
{
  if($thistest =~ m/$test/)
  {
    $testdir = "$batchdir/$thistest";
    $testconfigdir = "$test_source/$thistest";
    `mkdir -p $testdir`;
    #Copy the Makefile for launching waveform browser
    `cp ../make/test.mk $testdir/Makefile`;

    #Copy the test files
    #`cp $testconfigdir/config_*.txt $testdir/.`;
    #`cp $testconfigdir/data_*.mem $testdir/.`;
    #`cp $testconfigdir/instr_*.mem $testdir/.`;
    #`cp $testconfigdir/${thistest}_trace* $testdir/.`;
    `cp -r $testconfigdir/kernel_* $testdir/.`;

    if(0 == $dontrun)
    {
      #Launch the test
      $starttime = time;
      system "cd $testdir && ../simv $waveform +KILLTIME=$killtime |& tee run.log";      
      $endtime = time;
      $elapsedtime = $endtime - $starttime;
      system("echo \"Elapsed wall time in $hostname: $elapsedtime\"");
      system("echo \"Elapsed wall time in $hostname: $elapsedtime\" >> $testdir/run.log");
    }

    @logappend = ();
    $passed_wavefronts = 0;
    $failed_wavefronts = 0;
    $total_wavefronts = 0;
    open(RUNLOG,">>$testdir/run.log");
    
    @kernelFolders = `ls -d $testdir/kernel_*`;
    chomp(@kernelFolders);

    foreach $kfolder (@kernelFolders)
    {
      @goldentraces = `ls $kfolder/${thistest}_trace_*`;
      chomp(@goldentraces);

      foreach $test_trace_id (@goldentraces)
      {
        $test_trace_id =~ s/.*_trace_//g;
        $total_wavefronts = $total_wavefronts + 1;
        
        if(-e "$kfolder/tracemon_$test_trace_id.out")
        {
          @tracecmp = `./tracefile_cmp.pl $kfolder/${thistest}_trace_$test_trace_id $kfolder/tracemon_$test_trace_id.out`;
          push(@logappend, "----- trace comparison (component: $test_trace_id) ------\n");
          @logappend = (@logappend,@tracecmp);
          push(@logappend,"----------------------------------------------------------\n");
          push(@summary,"---------------------------------------------------\n");
          push(@summary,"Trace comparison for $thistest $test_trace_id:\n");
          @summary = (@summary,@tracecmp);
          push(@summary,"---------------------------------------------------\n");
          
          if($tracecmp[0] =~ m/PASS/)
          {
            $passed_wavefronts = $passed_wavefronts + 1;
          }
          else
          {
            $failed_wavefronts = $failed_wavefronts + 1;
          }
        }
        else
        {
          print RUNLOG "$script_name: Verilog trace $kfolder/tracemon_$test_trace_id.out not found.\n";
          $failed_wavefronts = $failed_wavefronts + 1;
        }
      }
    }

    push(@summary, "!!!!!!!!!!!!!!!!!!!!!!\n");
    push(@summary, "$thistest\t: $passed_wavefronts/$total_wavefronts wavefronts have passed trace comparison\n");
    push(@summary, "!!!!!!!!!!!!!!!!!!!!!!\n");
    push(@logappend, "!!!!!!!!!!!!!!!!!!!!!!\n");
    push(@logappend, "$thistest\t: $passed_wavefronts/$total_wavefronts wavefronts have passed trace comparison\n");
    push(@logappend, "!!!!!!!!!!!!!!!!!!!!!!\n");
    print RUNLOG "@logappend";
    close(RUNLOG);
    $testcount = $testcount + 1;
    if($failed_wavefronts == 0)
    {
      $passcount = $passcount + 1;
      print SUMMARY "$thistest\tPASS\n";
    }
    else
    {
      print SUMMARY "$thistest\tFAIL\n";
    }
  }
}

#Write to sumamry file
print SUMMARY "***************************************************\n";
print SUMMARY "Total test count: $testcount\n";
print SUMMARY "Total pass count: $passcount\n";
print SUMMARY "***************************************************\n";
print SUMMARY @summary;
print SUMMARY "***************************************************\n";
close(SUMMARY);

#Subroutine for help message
sub print_help
{
print STDOUT qq{$script_name:

DESCRIPTION:
	This script is for running unit tests. All the files required for running the test are copied to the batch directory /miaow/src/verilog/tb/results/<outputdir> and test directory /miaow/src/verilog/tb/results/<outputdir>

	After running the tests, this script further calls the script tracefile_cmp.pl to diff the standard trace file for the test with the generated trace file. The output generated by tracefile_cmp.pl is appended to the test log (run.log) of the test. Further, a summary of the trace comparison is generated in summary.txt (can be found in the batch directory).

USAGE:
	$script_name -r <0 for benchmarks, 1/2/3/4/5 for random test folder> -t <testname/regex> -o <outputdir> [-w] [-c] [-f] [-l] [-d] [-h] [-g] [-k]

ARGUMENTS:

-r
-folder from which tests will be picked. Provide 0 for AMDAPP_benchmarks, 1/2/3/4/5 for random tests, 6 for Rodinia suite and 7 for AMDAPP_4.2 version benchamrks.

-t
-test <testname/regex>	This is a compulsory argument; used to specify the name of the unit test to be run. When this is a regular expression, it can select multiple tests

-o
-outdir <outputdir>	This is a compulsory argument; used to specify the name of the batch directory where tests are run

-w
-waves			This option enables waveform dumps. Makes simulations run slower, output directories to occupy more disc space

-g
-glitch			This option enables waveform dumps with glitches and delta cycles enabled. This option is ignored if -waves is not used. Makes simulations run extremely slow, output directories to occupy a lot of disc space

-k
-killtime		This option can be used to set the killtime of verilog simulations in units of timescale (#delay). If not specified, defaults to 1000 for unit tests and 100000000 for benchmarks

-c
-copy			This option forces a copy of the vcs executable and the related directories to the batch directory. Without this option, the default behaviour is creation of symbolic links

-f
-force			This option forces overwrite of output directories if already existing

-l
-list			With this option, no tests are launched. Instead the script will just list out the tests which would be selected.

-d
-dontrun		With this option, no tests are launched. The batch directory and all the test directories are created and populated with the necessary files. This option becomes useful if the user wants to alter the test launch command. After this is done, cd to test directory and use 'make run' or 'make waves' to launch simulations

-h
-help			Well, you know what this option is for! You couldn't be reading this otherwise.

EXAMPLE USAGE:
	$script_name -r 1 -t test_000_branch -o trial1
  This will pick the test test_000_branch from rand_unit_tests_1 folder
	For above run, results can be found at /miaow/src/verilog/tb/results/trial1

  $script_name -r 0 -t BinarySearch -o trial1
  This will pick the test BinarySearch from benchmarks folder
  For above run, results can be found at /miaow/src/verilog/tb/results/trial1

	$script_name -r 1 -t "_0|_1" -o trial1 -l
	This will just list the tests which will be selected

	$script_name -r 1 -t "_0|_1" -o trial1
	This will run tests without waveform dumps

	$script_name -r 1 -t "_0|_1" -o trial1 -w
	This will run tests with waveform dumps
};
}
