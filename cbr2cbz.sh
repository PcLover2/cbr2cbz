#!/bin/bash

function Help {
  echo "cbr2cbz Conversion Tool"
  echo "Version 0.2"
  echo "https://git.zaks.web.za/thisiszeev/cbr2cbz"
  echo
  echo 'Usage: cbr2cbz single "filename.cbr"'
  echo "	Convert a single file."
  echo "Usage: cbr2cbz all"
  echo "	Convert all files recursively from the current location."
  echo "Usage: cbr2cbz help"
  echo "	Display this text."
  echo
  echo "Warning: If conversion is successful, the original file(s) will be deleted."
  exit
}

function Convert {
  echo "Converting: $cbr to $cbz"
  echo "Files remaining: $files"
  echo
  sleep 2s
  unrar e "$cbr" /tmp/cbr2cbz
  exitcoder=$?
  echo
  if [[ $exitcoder == "0" ]]
  then
  	zip -jm "$cbz" /tmp/cbr2cbz/*
        echo
  	exitcodez=$?
  	if [[ $exitcodez == "0" ]]
  	then
  		rm "$cbr"
  		echo "Successfully Converted $cbr to $cbz..."
                sleep 2s
                echo
  	else
  		echo "Error Writing $cbz - Skipping..."
                sleep 2s
                echo
  		rm "$cbz"
  	fi
  else
  	echo "Error Reading $cbr - Skipping..."
        sleep 2s
        echo
  fi
}

function BatchRun {
  mkdir -p "/tmp/cbr2cbz"
  find . -type f -name "*.cbr" > /tmp/cbr2cbz.list
  files=$(( cat /tmp/cbr2cbz.list | wc -l ))
  while read -r filename
  do
    cbr="$filename"
    size="$(( ${#cbr} - 1 ))"
    cbz="${cbr:0:$size}z"
    clear
    Convert
  done < /tmp/cbr2cbz.list
  rm /tmp/cbr2cbz.list
  rm -R "/tmp/cbr2cbz"
  exit
}

if [[ -z $1 ]]
then
  Help
elif [[ $1 == "single" ]]
then
  if [[ -z $2 ]]
  then
    Help
  else
    if [[ ! -z $3 ]]
    then
	echo "If filename has spaces or special characters please pass it within quotes."
	Help
    fi
    cbr=$2
    size=$(( ${#cbr} - 1 ))
    cbz="${cbr:0:$size}z"
    mkdir -p "/tmp/cbr2cbz"
    files=1
    Convert
    rm -R "/tmp/cbr2cbz"
    exit
  fi
elif [[ $1 == "help" ]]
then
  Help
elif [[ $1 == "all" ]]
then
  BatchRun
else
  Help
fi


