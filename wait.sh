#!/bin/bash
wait=0
while [[ $(azure servicefabric application show --json | jq -r '.items[].status') == "Upgrading" ]]
do
    echo "Upgrade in progress.  Waiting 5 more seconds for upgrade to complete, total wait: $wait seconds"
    wait=$((wait+5))
    sleep 5
done

echo "Total upgrade time: $wait"
