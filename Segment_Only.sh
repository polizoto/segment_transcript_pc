#!/bin/bash
# Joseph Polizzotto
# Script used in captioning workflow
# This script has been tested to work on MacOS; please contact me for any questions about use on other platforms
# This script should be run after each sentence has been placed on its own line (use sentenceboundary.pl script)
# 408-996-6044

###### SCRIPT #######
for f in "$@"
do
# Get the full file PATH without the extension
filepathWithoutExtension="${f%.*}"

# remove all paragraph breaks and line breaks
tr -d '\r\n' < "$f" > test2.txt

# Remove extra white spaces
sed -i 's/[[:space:]]\+/ /g' test2.txt

# Remove Brackets around speaker IDs (necessary for proper segmentation in next step; will add back later)
sed -i 's/\[STUDENT\]/STUDENT/g' test2.txt
sed -i 's/\[PROFESSOR\]/PROFESSOR/g' test2.txt

# segment transcript into sentences
perl sentence_boundary.pl -d HONORIFICS -i test2.txt -o test3.txt

# Add blank line after every new line

sed -e 'G' test3.txt > test4.txt

# Clean up
rm test2.txt
rm test3.txt
rm "$f"

# Add Brackets around speaker IDs
sed -i 's/STUDENT:/\[STUDENT\]/g' test4.txt
sed -i 's/PROFESSOR:/\[PROFESSOR\]/g' test4.txt

# Add two line breaks between ] and [ characters (non speech sound ending and speaker id beginning)
sed -i 's/\] \[/\]7\[/g' test4.txt
perl -00 -ple 's/7\[/\n\n\[/g' test4.txt > test5.txt
perl -00 -ple 's/ \[/\n\n\[/g' test5.txt > test6.txt


 # Break each line at 35 characters

fold -w 35 -s test6.txt > test7.txt

# Clean up further
rm test4.txt
rm test5.txt
rm test6.txt

 # Insert new line for every two lines, preserving paragraphs

perl -00 -ple 's/.*\n.*\n/$&\n/mg' test7.txt > "$f"

# Final Clean Up
rm test7.txt

done
