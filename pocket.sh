#!/usr/bin/env bash

set -xou pipefail

// read in pocket_key
source .secret

function auth() {
  redirect="redirect_uri=http://localhost/dummy.html"
  code=$(curl -L -v -d ${pocket_key} -d ${redirect} -c .cookie https://getpocket.com/v3/oauth/request?mobile=1)
  request=$(echo ${code} | awk -F= '{print $2}')
  google-chrome "https://getpocket.com/auth/authorize?request_token=${request}&${redirect}"
  pid=$(echo $!)
  wait ${pid}
  authorized=$(curl -v -L -d ${pocket_key} -d ${code} -b .cookie -c .cookie https://getpocket.com/v3/oauth/authorize)
  echo ${authorized} > .token
  access=$(echo ${authorized} | awk -F'&' '{print $1}')
  username=$(echo ${authorized} | awk -F'&' '{print $2}')
}


if [ ! -f ".token" ]; then
  rm -f .cookie
  auth
else
  access=$(cat .token | awk -F'&' '{print $1}')
  username=$(cat .token | awk -F'&' '{print $2}')
fi

curl -v -L "https://getpocket.com/v3/get?${pocket_key}&${access}&detailType=complete" | jq . > pocket_list.json

