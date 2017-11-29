# segment_transcript_pc
This script segments a plain text file into "caption-ready" chunks. It then aligns the text file with audio, using Aeneas. 

The Segment_Only script segments an edited plain text file into "caption-ready" chunks. 

The Segment+Align script segments the TXT file into chunks and aligns it with audio, using Aeneas. The result is an SRT file.

NOTE: If you are just starting a captioning workflow for YouTube videos, we recommend using the YouTube.sh script to download the auto-Captions from YouTube https://github.com/polizoto/auto_captions_dl_pc . That script will download the auto-captions (a "raw" transcript) which you can then edit before running Segment_Only.sh or Segment+Align.sh.

## Dependencies

gnu-utilities (perl, sed, fold, rm)

Install git bash for windows: https://git-for-windows.github.io/

aeneas: https://github.com/readbeyond/aeneas/

We recommend using the executable installer available at sillsdev (Daniel Bair): https://github.com/sillsdev/aeneas-installer/releases


## Usage

Preliminary:
* Every sentence must be on the same line in the TXT file (1 single line of text)
* Include speaker IDs and non-speech sounds in brackets (they will be ignored for alignment)
* The TXT file and the AUDIO file must have the same name. They must also be located in the same directory.
* HONORIFICS is a file containing abbreviations with periods that should not be treated as the end of a sentence (for segmenting). This file should be in same directory as scripts. 
* sentence-boundary.pl is a perl script that places all the sentences in a TXT file on their own lines. This file should be in the same directory as the script.
1. Open a Git Bash Terminal
2. CD to the directory with the scripts.
3. Enter the path to the script and then enter the path to the TXT file:

`./Segment_Only.sh path_to_text_file`

OR

`./Segment+Align.sh path_to_text_file`

## Notes
- In Segment+Align.sh script, adjust, if necessary, the Aeneas command so that the correct audio file type is listed (Adjust other 'clean-up' commands with different file types as well). In addition, adjust Aeneas parameters as necessary (e.g., head/tail audio length)
