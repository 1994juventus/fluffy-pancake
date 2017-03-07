#!/usr/bin/perl

use Getopt::Long;

my $weight=10;

my $scaling_coeff=30;

my $range_coeff=1000;

my $round_coeff=0.5;

my $city_tier_dummy=1;

my $max_hour=23;

my %denominatorhash=();

my %numeratorhash=();

my %scorehash=();

my $line;


while (my $line = <>) {
    chop($line);
    my ($key,$win_num,$click_num,$weight,$ctr)=split(/\,/,$line);
    last unless $line;
#    if($media_name=~/$loopvariable/){
#    $key=join("-",$media_name,$material_id,$pid);
    if($ctr>0){
	$denominatorhash{$key}=$denominatorhash{$key}+$weight;
    }
    else {
	$denominatorhash{$key}=$denominatorhash{$key};
    }
    $numeratorhash{$key}=$numeratorhash{$key}+$weight*$ctr;
}

foreach $key (keys %denominatorhash)
{
    my($media_name,$material_id,$pid)=split /\-/,$key;
    my $denom=$denominatorhash{$key};
    my $numer=$numeratorhash{$key};
    if ($denom>0){
	$score=$numer/$denom;
    }
    else{
	$score=0;
    }
    my $final_score=int((2/(1+exp(-$scaling_coeff*$score))-1)*$range_coeff+$round_coeff);
    for (my $i=0;$i<=$max_hour;$i++)
    {
	printf "%-2d,%10s,%3d,%50s,%10s,%10d\n",$i,$media_name,$city_tier_dummy,$pid,$material_id,$final_score;
#	printf "%-2d,%10s,%3d,%15d,%15d,%10d,%15.8f,%10d,%15.8f\n",$i,$media_name,$city_tier_dummy,$pid,$material_id,$final_score,$numer,$denom,$score;
    }
}
