#!/bin/bash

USAGE="
Usage: $(basename "$0") [options] turn-server-ip <username>=<password>

where:
    -h show this help text
    -s UDP datagram size in bytes
    -d session duration in seconds
    -t test duration in seconds
    -b bitrate in kbps

Example: $(basename "$0") -b 100 -t1201 127.0.0.1 john=password
"

PACKET_SIZE=100
DURATION=60
SESSIONS=1
BITRATE=50
TESTDURATION=30

while getopts ":hc:s:d:n:b:t:" opt; do
    case $opt in
    h)
        echo "$USAGE"
        exit
        ;;
    s)
        PACKET_SIZE="$OPTARG"
        ;;
    d)
        DURATION="$OPTARG"
        ;;
    t)
        TESTDURATION="$OPTARG"
        ;;
    n)
        SESSIONS="$OPTARG"
        ;;
    b)
        BITRATE="$OPTARG"
        ;;
    :) 
        echo "missing argument for -$OPTARG"
        exit
    esac
done

shift $((OPTIND -1))

if [ $# -ne 2 ]
then
    echo "Bad number of positional arguments. Expected: 2, got: $# $*. Were TURN IP and credentials passed?"
    echo "$USAGE"
    exit 1
fi

TURN_IP=$1
CREDENTIALS=$2

echo "
Runing TURN benchmark with the following configuration
TURN_IP=$TURN_IP
CREDENTIALS=$CREDENTIALS
SESSIONS=$SESSIONS
BITRATE=$BITRATE kbps
DURATION=$DURATION s
TESTDURATION=$TESTDURATION s
PACKET_SIZE=$PACKET_SIZE bytes
"

i=0
while [ $i -le $TESTDURATION ]
do
./turn_bench -host $TURN_IP -user $CREDENTIALS -packetSize $PACKET_SIZE -bitrate $BITRATE -duration $DURATION
i=$(( $i + $DURATION ));
done