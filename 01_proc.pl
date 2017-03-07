#!/usr/bin/perl

use Getopt::Long;

$usage = "$0 [options]\n".
  "Outputs histogram (and cumulative) of things it reads from STDIN.\n".
    "Options:\n".
    "\t -w weight the relative weight for a given day within time window\n".
    "\t -f filename      input file name either flat file or .gz file\n\n"; 

my $weight=10;

my $impression_cutoff=1000;

my @media=qw(vtq wax bitauto);

my %winhash=();

my %clickhash=();

my %scorehash=();

my $line;

GetOptions(
    "w=i" => \$weight,
    "f=s" => \$file,
    ) or die "Incorrect usage\n";


foreach my $loopvariable (@media){

    undef %winhash;
    undef %clickhash;
    
if ($file =~ /.gz$/) {
open(INPUT, "gunzip -c $file |") || die "can’t open pipe to $file";
}
else {
open(INPUT, $file) || die "can’t open $file";
    }
    
while (my $line = <INPUT>) {
    chop($line);
    my ($date,$media_name,$material_id,$tier,$pid,$win_num,$click_num)=split(/\,/,$line);
    last unless $line;
#    print $line,"\n";
    if($media_name=~/$loopvariable/){
    $key=join("-",$media_name,$material_id,$pid);
    $winhash{$key}=$winhash{$key}+$win_num;
    $clickhash{$key}=$clickhash{$key}+$click_num;
 }
}

foreach $key (keys %winhash)
{
    my $win=$winhash{$key};
    my $click=$clickhash{$key};
    if ($win<impression_cutoff){
	$ctr=0;
    }
    else
    {
	$ctr=$click/$win;
    }
    printf"%-70s,%10d,%8d,%8d,%15.8f\n",$key,$win,$click,$weight,$ctr;
}
close(INPUT)            || die "can't close $file: $!";
}



