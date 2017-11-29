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
rm test3.txt

done