# cbr2cbz

BASH tool to convert cbr files to cbz files either in batch or one by one.

## Download the tool using:
```shell
git clone https://github.com/PcLover2/cbr2cbz.git
```
```shell
chmod +x cbr2cbz/cbr2cbz.sh
```
```shell
sudo cp cbr2cbz/cbr2cbz.sh /usr/bin/cbr2cbz
```
That's it.

## Usage: 

### Convert a single file.
```shell
cbr2cbz single "filename.cbr"
```
### Convert all files recursively from the current location.
```shell
cbr2cbz all
```
### Display help text.
```shell
cbr2cbz help
```
### Warning: 

If conversion is successful, the original file(s) will be deleted.

## Dependancies:

The script requires "zip" and "unrar". Please ensure they are installed before trying to run the script. A simple online search will help you with this. At a later stage I will build an install and update functionality which will do this automatically.

## IMPORTANT NOTE

Currently, the tool uses a fixed location for the temp files and the files list. If you decide to run this two in two sessions, they will conflict and you will have a bad day. At a later stage, I will add support to allow more than one session to be run at a time, for all those hardcore users.
