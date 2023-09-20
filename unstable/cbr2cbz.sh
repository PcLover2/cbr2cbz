#!/bin/bash

version="0.7"

function Help {
  echo "cbr2cbz Conversion Tool"
  echo "Version $version"
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
  echo "Files remaining: $((files--))"
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
      temp=( $( du "$cbz" ) )
      tmp=$(( $convsize + ${temp[0]} ))
      convsize=$tmp
      sleep 2s
      echo
    else
      echo "Error Writing $cbz - Skipping..."
      if [[ $isbatch = true ]]
      then
        ((failedfiles++))
        echo "  $cbr"
      fi
      sleep 2s
      echo
      rm "$cbz"
    fi
  else
    echo "Error Reading $cbr - Skipping..."
    if [[ $isbatch = true ]]
    then
      ((failedfiles++))
      echo "  $cbr"
    fi
    sleep 2s
    echo
  fi
}

function BatchRun {
  isbatch=true
  rm -Rf "/tmp/cbr2cbz"
  mkdir -p "/tmp/cbr2cbz"
  find . -type f -name "*.cbr" > /tmp/cbr2cbz.list
  totalfiles=$( find . -type f -name "*" | wc -l )
  startsize=$( du | tail -1 )
  cbrfiles=$( find . -type f -name "*.cbr" | wc -l )
  if [[ $cbrfiles == 0 ]]
  then
    echo "No files to convert!"
    echo
    exit
  fi
  temp=( $( du -c *.cbr | tail -1 ) )
  cbrsize=${temp[0]}
  temp=$(( $startsize / 1024 / 1024 ))
  if [[ $temp > 0 ]]
  then
    startsizeh="$temp GB"
  else
    temp=$(( $startsize / 1024 ))
    if [[ $temp > 0 ]]
    then
      startsizeh="$temp MB"
    else
      startsizeh="$temp KB"
    fi
  fi
  temp=$(( $cbrsize / 1024 / 1024 ))
  if [[ $temp > 0 ]]
  then
    cbrsizeh="$temp GB"
  else
    temp=$(( $cbrsize / 1024 ))
    if [[ $temp > 0 ]]
    then
      cbrsizeh="$temp MB"
    else
      cbrsizeh="$temp KB"
    fi
  fi
  cbzfiles=$( find . -type f -name "*.cbz" | wc -l )
  temp=( $( du -c *.cbz | tail -1 ) )
  cbzsize=${temp[0]}
  temp=$(( $cbzsize / 1024 / 1024 ))
  if [[ $temp > 0 ]]
  then
    cbzsizeh="$temp GB"
  else
    temp=$(( $cbzsize / 1024 ))
    if [[ $temp > 0 ]]
    then
      cbzsizeh="$temp MB"
    else
      cbzsizeh="$temp KB"
    fi
  fi
  echo "CBR2CBZ Batch Log" > cbr2cbz.log
  echo "Version $version" >> cbr2cbz.log
  echo "You can check for script updates at https://git.zaks.web.za/thisiszeev/cbr2cbz"
  echo "Batch Start Date & Time: $(( date ))" >> cbr2cbz.log
  echo >> cbr2cbz.log
  echo "Considering $totalfiles ($startsize)" >> cbr2cbz.log
  echo "   of which..." >> cbr2cbz.log
  echo "CBZ files: $cbzfiles ($cbzsizeh)" >> cbr2cbz.log
  echo "CBR files: $cbrfiles ($cbrsizeh)" >> cbr2cbz.log
  echo
  echo "Failed files:" >> cbr2cbz.log
  files=$( cat /tmp/cbr2cbz.list | wc -l )
  while read -r filename
  do
    cbr="$filename"
    size="$(( ${#cbr} - 1 ))"
    cbz="${cbr:0:$size}z"
    clear
    Convert
  done < /tmp/cbr2cbz.list
  temp=$(( $convsize / 1024 / 1024 ))
  if [[ $temp > 0 ]]
  then
    convsizeh="$temp GB"
  else
    temp=$(( $convsize / 1024 ))
    if [[ $temp > 0 ]]
    then
      convsizeh="$temp MB"
    else
      convsizeh="$temp KB"
    fi
  fi
  rm -f /tmp/cbr2cbz.list
  rm -Rf "/tmp/cbr2cbz"
  PrintStats
  exit
}

function SingleRun {
  isbatch=false
  rm -Rf "/tmp/cbr2cbz"
  cbr=$2
  size=$(( ${#cbr} - 1 ))
  cbz="${cbr:0:$size}z"
  mkdir -p "/tmp/cbr2cbz"
  files=1
  Convert
  rm -Rf "/tmp/cbr2cbz"
  PrintStats
  exit
}

function PrintStats {
  RunTime
  if [[ $isbatch == true ]]
  then
    echo
    echo "Total CBR files: $cbrfiles ($cbrsizeh)"
    temp=$(( $cbrfiles - $failedfiles ))
    echo "Succefully converted: $temp ($convsizeh)"
    echo "Failed: $failedfiles"
    echo
    echo "A log file has been written to cbr2cbz.log which contains all the failed files."
    if [[ $failedfiles == 0 ]]
    then
      echo "  none" >> cbr2cbz.log
    fi
    echo >> cbr2cbz.log
    echo "Total CBR files: $cbrfiles ($cbrsizeh)" >> cbr2cbz.log
    echo "Succefully converted: $(( $cbrfiles - $failedfiles )) ($convsizeh)" >> cbr2cbz.log
    echo "Failed: $failedfiles" >> cbr2cbz.log
  fi
}

function RunTime {
  temp=$SECONDS
  days=$(( $temp / 60 / 60 / 24 ))
  hour=$(( $temp / 60 / 60 % 24 ))
  mins=$(( $temp / 60 % 60 ))
  secs=$(( $temp % 60 ))
  echo -n "Runtime: "
  if [[ $days > 0 ]]
  then
    [[ $days = 1 ]] && echo -n "$days day " || echo -n "$days days "
  fi
  if [[ $hour > 0 ]]
  then
    [[ $hour = 1 ]] && echo -n "$hour hour " || echo -n "$hour hours "
  fi
  if [[ $mins > 0 ]]
  then
    [[ $mins = 1 ]] && echo -n "$mins minute " || echo -n "$mins minutes "
  fi
  if [[ $d = 0 && $h = 0 && $m = 0 ]]
  then
    [[ $s = 1 ]] && echo -n "$s second" || echo -n "$s seconds"
  fi  
  echo
  if [[ $isbatch == true ]]
  then
    echo -n "Runtime: " >> cbr2cbz.log
    if [[ $days > 0 ]]
    then
      [[ $days = 1 ]] && echo -n "$days day " >> cbr2cbz.log || echo -n "$days days " >> cbr2cbz.log
    fi
    if [[ $hour > 0 ]]
    then
      [[ $hour = 1 ]] && echo -n "$hour hour " >> cbr2cbz.log || echo -n "$hour hours " >> cbr2cbz.log
    fi
    if [[ $mins > 0 ]]
    then
      [[ $mins = 1 ]] && echo -n "$mins minute " >> cbr2cbz.log || echo -n "$mins minutes " >> cbr2cbz.log
    fi
    if [[ $d = 0 && $h = 0 && $m = 0 ]]
    then
      [[ $s = 1 ]] && echo -n "$s second" >> cbr2cbz.log || echo -n "$s seconds" >> cbr2cbz.log
    fi  
  fi
}

SECONDS=0
convsize=0

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
    SingleRun
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


