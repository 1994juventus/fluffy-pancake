#!/bin/bash

WINDOW_LENGTH=30
INPUT_DIR=$AGG_DIR
OUTPUT_DIR=$OUTPUT_DIR
PROCESSING_SCRIPT=$SCRIPTS_DIR/01_proc.pl
SCORING_SCRIPT=$SCRIPTS_DIR/02_scr.pl

date

STARTING_DATE=$(date -d "-$WINDOW_LENGTH days" +%Y%m%d)
echo STARTING DATE IS $STARTING_DATE

END_DATE=$(date +%Y%m%d)
echo END DATE IS $END_DATE

rm -rf $OUTPUT_DIR/tmp$END_DATE
mkdir $OUTPUT_DIR/tmp$END_DATE

#PROCESSING PART: calculate the ctr rate on daily basis within time window


for ((VAR=0;VAR<=WINDOW_LENGTH-1;VAR++))

do
    DATE_STRING=$(date -d "-$VAR days" +%Y%m%d)

    if [ -f "$INPUT_DIR/$DATE_STRING.csv" ]

    then

	let WEIGHT=$WINDOW_LENGTH-$VAR

#	echo $DATE_STRING " weight is " $WEIGHT
	
	LINE_NUM=$(cat $INPUT_DIR/$DATE_STRING.csv|wc -l)
    
	#   echo "WE NEED FILE" $DATE_STRING".csv"

	echo  $DATE_STRING".csv has" $LINE_NUM "lines"

	$PROCESSING_SCRIPT -w $WEIGHT -f $INPUT_DIR/$DATE_STRING.csv>$OUTPUT_DIR/tmp$END_DATE/${DATE_STRING}_CTR.csv

    else

	echo $DATE_STRING".csv does not exist"

    fi
    
done

# SCORING PART: combine the daily ctr using weighted average within time window

cat $OUTPUT_DIR/tmp$END_DATE/*_CTR.csv|$SCORING_SCRIPT>$OUTPUT_DIR/${END_DATE}_gm_scores.csv


#CLEAN UP

rm -rf $OUTPUT_DIR/tmp$END_DATE
