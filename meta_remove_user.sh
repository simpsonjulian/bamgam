#!/bin/bash
. env.sh
username=$1
email=${username}@${domain}
executor=$2

./remove_user.sh $username prep $executor
#./dropbox.sh remove ${email} ${executor}@${domain}
./trello.sh remove ${email}
./slack.sh remove ${email}
