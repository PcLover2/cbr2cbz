# cbr2cbz

BASH tool to convert cbr files to cbz files either in batch or one by one.

##Download the tool using:

$ git clone git@git.zaks.web.za:thisiszeev/cbr2cbz.git

$ chmod +x cbr2cbz.sh

$ sudo cp cbr2cbz.sh /usr/bin/cbr2cbz

That's it.

##Usage: 

###Convert a single file.

$ cbr2cbz single "filename.cbr"

###Convert all files recursively from the current location.

$ cbr2cbz all

### Display help text.

$ cbr2cbz help

###Warning: 

If conversion is successful, the original file(s) will be deleted.

##Dependancies:

The script requires "zip" and "unrar". Please ensure they are installed before trying to run the script. A simple online search will help you with this. At a later stage I will build an install and update functionality which will do this automatically.