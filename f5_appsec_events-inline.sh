#!/usr/bin/env bash
#
# Shell Script to Application Security Events from F5 Distributed Cloud with a valid API token
#
# Note: start_time and end_time refers to UTC time.
#       Please keep token files and query JSON files in the same path to prevent confusion.

printf "%s" "Enter tenant: "
read tenant

printf "%s" "Enter namespace: "
read namespace

printf "%s" "Enter Token File: "
read token

# printf "%s" "Enter JSON File: "
# read json

# namespace=$(jq --raw-output '.namespace' $json)

end_time_str=$(date -u +"%Y-%m-%dT%H:%M:%S.%3NZ")
start_time_str=$(date --date="1 hour ago" -u +"%Y-%m-%dT%H:%M:%S.%3NZ")

# echo $end_time_str
# echo $start_time_str

# json_str="{ \"start_time\": \"$start_time_str\", \"end_time\": \"$end_time_str\", \"limit\": 0, \"namespace\": \"$namespace\", \"scroll\" : true, \"sort\": \"DESCENDING\" }"
# echo $json_str

QUERY_JSON=$(jq --null-input \
  --arg aggs "{}" \
  --arg start_time "$start_time_str" \
  --arg end_time "$end_time_str" \
  --arg limit "0" \
  --arg namespace "$namespace" \
  --arg scroll "true" \
  --arg sort "DESCENDING" \
  '{ "aggs": $aggs, "start_time": $start_time, "end_time": $end_time, "limit": $limit, "namespace": $namespace, "scroll": $scroll, "sort": $sort }')

echo $QUERY_JSON

curl -X POST https://$tenant.console.ves.volterra.io/api/data/namespaces/$namespace/app_security/events \
    -H "Content-type: application/json" \
    -H "Authorization: APIToken `cat $token`" \
    -H "Accept: application/json" \
    -H "Access-Control-Allow-Origin: *" \
    -H "x-volterra-apigw-tenant: $tenant" \
    -d "$(QUERY_JSON)" | jq >> output.json
