#!/bin/bash
#This will start at 1 and cycle through 1 2 3.
#This will create a file named run in the same directory. It will automatically be created.
#./run will store the next number to be used.

read n < ./run || n=1
echo $(( n < 3 ? n + 1 : 1 )) > ./run
echo $n
