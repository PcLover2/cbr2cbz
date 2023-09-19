# cbr2cbz

BASH tool to convert cbr files to cbz files either in batch or one by one.

Download the tool using:

$ git clone git@git.zaks.web.za:thisiszeev/cbr2cbz.git

$ chmod +x cbr2cbz.sh

$ sudo cp cbr2cbz.sh /usr/bin/cbr2cbz

That's it.

Usage: cbr2cbz single "filename.cbr"
        Convert a single file.
Usage: cbr2cbz all
        Convert all files recursively from the current location.
Usage: cbr2cbz help
        Display this text.

Warning: If conversion is successful, the original file(s) will be deleted.
