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

# segment transcript into sentences
perl sentence_boundary.pl -d HONORIFICS -i "$f" -o test.txt

# Add blank line after every new line

sed -e 'G' test.txt > test2.txt

# Clean up
rm test.txt
rm "$f"

 # Break each line at 35 characters

fold -w 35 -s test2.txt > test3.txt

# Clean up further
rm test2.txt

 # Insert new line for every two lines, preserving paragraphs

perl -00 -ple 's/.*\n.*\n/$&\n/mg' test3.txt > "$f"

# Final Clean Up
rm test3.txt

done