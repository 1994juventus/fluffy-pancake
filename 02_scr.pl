#!/usr/bin/perl

use Getopt::Long;

my $weight=10;

my $scaling_coeff=100;

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
    $denominatorhash{$key}=$denominatorhash{$key}+$weight;
    $numeratorhash{$key}=$numeratorhash{$key}+$weight*$ctr;
}

foreach $key (keys %denominatorhash)
{
    my($media_name,$material_id,$pid)=split /\-/,$key;
    my $denom=$denominatorhash{$key};
    my $numer=$numeratorhash{$key};
    my $score=$numer/$denom;
    my $final_score=int((2/(1+exp(-$scaling_coeff*$score))-1)*$range_coeff+$round_coeff);
    for (my $i=0;$i<=$max_hour;$i++)
    {
	printf "%-2d,%10s,%3d,%15d,%15d,%10d\n",$i,$media_name,$city_tier_dummy,$pid,$material_id,$final_score;
    }
}


