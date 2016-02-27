#!/bin/bash
# Will check a directory for the latest file and check to see if the file is being updated. If it is will output Recording
saveDir="/Users/Edward/Movies"
fileType="mp4"

#do not edit
cd $saveDir

oldsize=`sed '1q;d' size.log`
newsize=`sed '2q;d' size.log`

if test `find size.log -mmin -1`; then
  if [[ $newsize -gt $oldsize ]]; then
    echo "Recording"
  fi
else
  currentfile=`ls -Art *.$fileType | tail -n 1`
  oldsize=$newsize
  newsize=`wc -c "$currentfile" | awk '{print $1}'`
  echo $oldsize > size.log
  echo $newsize >> size.log
  if [[ $newsize -gt $oldsize ]]; then
   echo "Recording"
  fi
fi
