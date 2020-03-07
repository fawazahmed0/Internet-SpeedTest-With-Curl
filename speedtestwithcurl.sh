#!/bin/sh

#  args1=string 
sanitize () {

#https://bash.cyberciti.biz/guide/The_exit_status_of_a_command
# https://shapeshed.com/unix-exit-codes/
# https://askubuntu.com/questions/972076/how-to-separate-command-output-to-individual-lines
status="$?"


if [ "$status" = "0" ]
then
speed="$(echo "$speed" | tail -n 1 | awk '{print $NF}')"
elif [ "$status" = "28" ]
then
speed="$(echo "$speed" | tail -n 2 | head -n 1 | awk '{print $NF}')"
else
echo "Some error in curl, try running the script again"
exit $?
fi



# Removing last character and saving in variable
# https://unix.stackexchange.com/questions/144298/delete-the-last-character-of-a-string-using-string-manipulation-in-shell-script
number="$(echo ${speed%?})"


# converting speed into bytes per second
# ref : https://stackoverflow.com/questions/9017478/multiplication-of-2-variables
# https://stackpointer.io/script/shell-script-get-last-character-string/299/
#  https://stackoverflow.com/questions/39550623/how-to-do-character-comparison-in-bash-scripts


onekb=1024
lastchar="$(echo -n $speed | tail -c 1 )"
speed="$(echo "$speed" | tail -n 2 | head -n 1 | awk '{print $NF}')"

if [ "$lastchar" = "k" ]
then
  number=$(($number * $onekb))
elif [ "$lastchar" = "M" ]
then
  number=$(($number * $onekb * $onekb))
elif [ "$lastchar" = "G" ]
then
  number=$(($number * $onekb * $onekb * $onekb))
elif [ "$lastchar" = "T" ]
then
  number=$(($number * $onekb * $onekb * $onekb * $onekb))
elif [ "$lastchar" = "P" ]
then
  number=$(($number * $onekb * $onekb * $onekb * $onekb * $onekb))
else
# Data is already in bytes per second  without any suffix
  number=$speed
fi

# Converting bytes per second to kilo bits per second
  number=$(($number / 1000 ))
  number=$(($number * 8 ))


 echo "$1 : $number kbps"





}





# Testing Upload Speed, upload speed is in kbps
#refer:
#https://iperf.fr/iperf-servers.php
#https://speedtest.serverius.net/
#https://iperf.cc/
#https://gist.github.com/raulmoyareyes/34cbd643e2c93be64746
#ref: https://stackoverflow.com/questions/2096490/print-second-last-column-field-in-awk
# https://stackoverflow.com/questions/4651437/how-do-i-set-a-variable-to-the-output-of-a-command-in-bash
# https://stackoverflow.com/questions/12583930/use-pipe-for-curl-data
#  https://unix.stackexchange.com/questions/29457/how-to-monitor-only-the-# https://unix.stackexchange.com/questions/6699/how-do-i-suppress-dd-outputlast-n-lines-of-a-log-file


# uploadspeed="$(iperf -c speedtest.serverius.net -f k | tail -n 1| awk '{print $(NF-1)}')"

# uploading 20mb file for 12 seconds
# https://anonymousfiles.io/api.html


echo "Please wait, the test results will be shown after 30 seconds"
echo "Note: Curl is required for this script to work"
sleep 4
echo $'\n'

speed="$(dd bs=1M count=20  </dev/urandom | curl -m 12 -k -o /dev/null -F "file=@-" https://api.anonymousfiles.io 2>&1)"

# uploadstatus="$?"

uploadval="$(sanitize 'Upload Speed')"



# Testing Download Speed with 20mb data
# Refer : https://superuser.com/questions/1045239/what-is-a-simple-way-to-let-a-command-run-for-5-minutes

# https://stackoverflow.com/questions/44749895/curl-including-garbage-when-redirecting-stderr-to-stdout
# https://stackoverflow.com/questions/24252804/how-to-re-direct-curl-progress-meter-to-a-file

# https://ec.haxx.se/cmdline/cmdline-progressmeter  (refer for k, m etc)
# https://stackoverflow.com/questions/43197581/curl-upload-download-speed-test
# https://osxdaily.com/2013/07/31/speed-test-command-line/



# 2>$1 to redirect stderr (progress meter) to stdout
# Refer: https://stackoverflow.com/questions/4651437/how-do-i-set-a-variable-to-the-output-of-a-command-in-bash
# # https://curl.haxx.se/docs/manpage.html

speed="$(curl -m 12 -k -o /dev/null https://cdn.jsdelivr.net/gh/fawazahmed0/LargeTxtFile@master/testabc.txt 2>&1 )"


downloadval="$(sanitize 'Download Speed' )"

# Echo new line
# Ref: https://stackoverflow.com/questions/8467424/echo-newline-in-bash-prints-literal-n
echo $'\n'

echo $uploadval
echo $downloadval

# https://ryanstutorials.net/bash-scripting-tutorial/bash-functions.php


