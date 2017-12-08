#!/bin/bash
# Joseph Polizzotto
# Script used in captioning workflow
# This script has been tested to work on PC with Git Bash installed; please contact me at 408-996-6044
# This script should be run after each sentence has been placed on its own line (use sentenceboundary.pl script)
# TXT file and MP4 must have same name and be located in the same directory as the script
# Basic_Usage: path_to_Segment+Align.sh path_to_text_file.txt


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

# Convert MP4 to MP3
ffmpeg -i *.mp4 -ab 128k -f mp3 - >"$f".mp3

# Align Transcript with Audio
'C:\Python27\Scripts\aeneas_execute_task.py' "$f".mp3 "$f" "task_language=fr|os_task_file_format=srt|is_text_type=subtitles|task_adjust_boundary_nonspeech_min=1.000|task_adjust_boundary_nonspeech_string=REMOVE|task_adjust_boundary_algorithm=percent|task_adjust_boundary_percent_value=75|is_text_file_ignore_regex=[*]" "$f".srt --output-html

# Adjust path to audio file in .html file
sed -ri 's/.txt.mp3/.mp3/' "$f".srt.html

# Rename files (remove .txt in name)
for f in *.txt.mp3*; do mv "$f" "${f//.txt.mp3/.mp3}"; done
for f in *.txt.srt*; do mv "$f" "${f//.txt.srt/.srt}"; done
for f in *.srt.html*; do mv "$f" "${f//.srt.html/.html}"; done

# Final Clean Up
rm test7.txt

# Open Finetuneas Page
open *.html

done
