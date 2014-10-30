#!/bin/bash

function random_org {
    local min=${1:-1}
    local max=${2:-100}
    local url=http://www.random.org/integers/?num=1\&min=$min\&max=$max\&col=1\&base=10\&format=plain\&rnd=new
    echo $(curl -s $url)
}


function wiki {
    local url=http://en.wikipedia.org/wiki/Special:Random
    local random_article=`curl -s -L -I -o /dev/null -w '%{url_effective}' $url`
    echo "$random_article"
}


USERNAME="random.org"
CHANNEL="#random"
while [ $# -gt 0 ]
do
    case $1 in
        --channel)
            CHANNEL=$2
            shift 2
            ;;
        --user)
            USERNAME=$2
            shift 2
            ;;
        *)
            echo "Unknown argument $1"
            exit 1
    esac
done


generator=`random_org 1 2`

case $generator in
    1)
        MESSAGE=`random_org 1 100`
        ;;
    2)
        MESSAGE=`wiki`
        ;;
    *)
        MESSAGE=`random_org 1 100`
        ;;
esac

USERNAME="random.org"
CHANNEL="#random"
PAYLOAD="payload={\"channel\": \"$CHANNEL\", \"username\": \"$USERNAME\", \"text\": \"$MESSAGE\"}"
TOKEN=$1
SLACK_URL=https://jive.slack.com/services/hooks/incoming-webhook?token=$TOKEN

curl -X POST --data "$PAYLOAD" $SLACK_URL
