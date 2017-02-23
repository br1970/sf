#!/bin/bash
[ -z $BUILD_BUILDNUMBER ] && { echo '$BUILDID is undefined, exiting.'; exit 1; }
echo "Deploying release to dev for Build ID: $BUILD_BUILDNUMBER"

echo "================================================="
echo "Step 2:  Connect to cluster: $SERVICEFABRICCLUSTER"
echo "================================================="
azure servicefabric cluster connect $SERVICEFABRICCLUSTER
[ $? -eq 0 ] || { echo "Failed to connect to $SERVICEFABRICCLUSTER, Exiting..."; exit 1; }
echo "================================================="
echo "Step 3:  Copy to ImageStore"
echo "================================================="
azure servicefabric application package copy dhNotification fabric:ImageStore
[ $? -eq 0 ] || { echo "Failed to copy to ImageStore, Exiting..."; exit 1; }
azure servicefabric application package copy dhClient fabric:ImageStore
[ $? -eq 0 ] || { echo "Failed to copy to ImageStore, Exiting..."; exit 1; }
echo "================================================="
echo "Step 4:  Register Application"
echo "================================================="
azure servicefabric application type register dhnotification
[ $? -eq 0 ] || { echo "Failed to register application, Exiting..."; exit 1; }
azure servicefabric application type register dhclient
[ $? -eq 0 ] || { echo "Failed to register application, Exiting..."; exit 1; }
echo "================================================="
echo "Step 5:  Create Application"
echo "================================================="
azure servicefabric application create fabric:/dh dreamhomesf $BUILD_BUILDNUMBER
[ $? -eq 0 ] || { echo "Failed to create application, Exiting..."; exit 1; }
# test
