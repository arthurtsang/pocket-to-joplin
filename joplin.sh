#!/usr/bin/env bash

set -exou pipefail

// read in joplin_token
source .secret

host=localhost
port=41184
curl "http://${host}:${port}/notes?token=${joplin_token}" | jq . > joplin_list.json

curl "http://${host}:${port}/resources?token=${joplin_token}" | jq . > joplin_rss_list.json

curl "http://${host}:${port}/notes/2152bd2f06264964a42f506b9f26896c/resources?token=${joplin_token}" | jq . 

