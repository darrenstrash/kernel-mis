#! /bin/bash

pid=$1
timeout=$2
i=1

while [ "$i" -lt "$timeout" ]; do

    sleep 1
    kill -0 $pid
    if [ $? -eq 1 ]; then
        exit 1
    fi

    i=$(($i+1))
done

kill $pid 1>&2
exit $?
