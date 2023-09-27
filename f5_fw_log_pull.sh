#!/usr/bin/env bash
#
# Shell Script to Read Logs from F5 Distributed Cloud with a valid API token
#

printf "%s" "Enter tenant: "
read tenant

printf "%s" "Enter namespace: "
read namespace

printf "%s" "Enter Token File: "
read token

printf "%s" "Enter JSON File: "
read json

curl -X POST \
    -H "Content-type: application/json" \
    -H "Authorization: APIToken `cat $token`" \
    -H "Accept: application/json" \
    -H "Access-Control-Allow-Origin: *" \
    -H "x-volterra-apigw-tenant: $tenant" \
    -d @$json https://$tenant.console.ves.volterra.io/api/data/namespaces/$namespace/firewall_logs | jq >> output.json
