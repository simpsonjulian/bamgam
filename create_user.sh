#!/bin/bash

set -x

die() {
  echo $@
  exit 1
}

. env.sh

firstname=$1
lastname=$2
domain=$3
group=$4
recipient=$5

[ $# -eq 5 ] || die "Usage: $0 firstname lastname domain group (case insensitive) recipient"

for varname in domain TWO_STEP_EXCEPTION_GROUP GAM_BINARY; do
  if [ ! -n "${!varname}" ]; then
    die "Error: I need a ${varname} variable set in env.sh"
  fi
done

username=`echo ${firstname}.${lastname/ /} | awk '{print tolower($0)}'`
password=`pwgen -Bs 11 1`
set -e
$GAM_BINARY create user $username firstname $firstname lastname "$lastname" password $password
$GAM_BINARY update group $group add member $username
$GAM_BINARY update group everyone add member $username

message="
Hello $firstname,

Welcome to $domain!

Your login is $username@$domain
Your password is $password

You can login at https://www.google.com/work/apps/business/

Please enable 2-Step Verification ASAP: https://support.google.com/accounts/answer/185839?hl=en
"

./send_email.sh $recipient "Welcome to $domain" "$message"

echo "User $username@$domain created.  Send the email"
