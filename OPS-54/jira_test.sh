#!/bin/bash

#AUTH='pburkholder:4testing'
AUTH='github:RESTful'
HOST=jira.audaxhealth.com
URL="https://$HOST/rest/api/2/issue/OCT-5460/transitions"
#    --data '{ "update": { "comment": [ { "add": { "body": "Dev Complete" } } ] }, "fields": { "assignee": { "name": "pburkholder" }, "resolution": { "name": "Fixed" } }, "transition": { "id": "761" } }' 

transitions() {
  curl -s -u $AUTH $URL 
}


devcomplete() {
  curl -v -s -u $AUTH \
    -H "Content-Type: application/json" -X POST \
    $URL \
    --data '{ "update": { "comment": [ { "add": { "body": "Dev Complete" } } ] }, "fields": { "assignee": { "name": "pburkholder" }, "resolution": { "id": "1" } }, "transition": { "id": "781" } }' 
    #--data '{ "update": { "comment": [ { "add": { "body": "Dev Complete" } } ] }, "fields": { "assignee": { "name": "pburkholder" }, "resolution": { "name": "Fixed" } }, "transition": { "id": "781" } }' 
}

reopen() {
  curl -v -s -u $AUTH \
    -H "Content-Type: application/json" -X POST \
    $URL \
    --data '{ "update": { "comment": [ { "add": { "body": "ReOpen 3" } } ] }, "fields": { "assignee": { "name": "pburkholder" }},  "transition": { "id": "3" } }' 
}

eval $1
