# cbr2cbz

BASH tool to convert cbr files to cbz files either in batch or one by one.

## Download the tool using:

$ git clone git@git.zaks.web.za:thisiszeev/cbr2cbz.git

$ chmod +x cbr2cbz.sh

$ sudo cp cbr2cbz.sh /usr/bin/cbr2cbz

That's it.

## Usage: 

### Convert a single file.

$ cbr2cbz single "filename.cbr"

### Convert all files recursively from the current location.

$ cbr2cbz all

### Display help text.

$ cbr2cbz help

### Warning: 

If conversion is successful, the original file(s) will be deleted.

## Dependancies:

The script requires "zip" and "unrar". Please ensure they are installed before trying to run the script. A simple online search will help you with this. At a later stage I will build an install and update functionality which will do this automatically.

## IMPORTANT NOTE

Currently, the tool uses a fixed location for the temp files and the files list. If you decide to run this two in two sessions, they will conflict and you will have a bad day. At a later stage, I will add support to allow more than one session to be run at a time, for all those hardcore users.

## ROAD MAP

I am currently trying to add the support for a log file and statistics. Having a few issues, so my most recent and non-working commit is in the unstable folder.

I will eventually add support for more formats and in different directions. Right now, I had 10 000 + files, and some were cbr and some were cbz, but my device has issues with cbr, probably because RAR is a closed patent. So I wanted to convert all my cbr files to cbz, for my own needs.

## Contact the developer.

I never check my email. If you would like to get hold of me, send me a DM on Reddit u/thisiszeev

I am looking for someone to port this to Windows Powershell. Contact me on Reddit if you are interested?
