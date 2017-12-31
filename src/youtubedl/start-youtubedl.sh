#!/bin/bash
set -e

function help() {
    echo '======Help========'
    echo ''
    echo '------pluralsight------'
    echo 'for pluralsight format use [pluralsight {$2:username} {$3:password} {$4:sleepinterveral=30} {$5:maxsleepinterval=120}]'
    echo 'pluralsight require [files.txt] in /download for download links and [cookies.txt] in /download for cookie to use'
    echo 'if /downloads/files.txt not exist, last param will be pass to youtubedl as single donwload url'
    echo ''
    echo '-------default---------'
    echo 'if first parameter is not any predefine, then [youtube-dl] is used, any parameter is pass to youtube-dl'
}

if [ "$1" = "pluralsight" ]; then
    downloads="/downloads"
    username=(--username $2)
    password=(--password $3)
    outputformat=(-o "${downloads}/%(playlist)s/%(chapter_number)s. %(chapter)s/%(playlist_index)s. %(title)s.%(ext)s")
    sleepInterval=(--sleep-interval ${4-30})
    sleepMaxInterval=(--max-sleep-interval ${5-120})
    withSub=(--all-subs -v)
    userAgent=(--user-agent 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36')

    downloadFile="$downloads/files.txt"
    cookieFile="$downloads/cookies.txt"
    
    if [ -f "$cookieFile" ]; then
        cookieFile=(--cookies $cookieFile)
    fi

    if [ -f "$downloadFile" ]; then
            downloadlink=(-a $downloadFile)
        else
            downloadlink=($6)
    fi

    exec youtube-dl "${username[@]}" "${password[@]}" "${outputformat[@]}" "${sleepInterval[@]}" "${sleepMaxInterval[@]}" "${withSub[@]}" "${userAgent[@]}" "${cookieFile[@]}" "${downloadlink[@]}"
elif [ "$1" == "debug" ]; then
    shift
    exec "$@"    
elif [ "$1" == "help" ]; then
    shift
    trap "help" SIGHUP SIGINT EXIT SIGKILL SIGTERM
else
    shift
    exec youtube-dl "$@"
fi

exit 0