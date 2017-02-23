#!/bin/bash
[ -z $BUILD_BUILDNUMBER ] && { echo '$BUILDID is undefined, exiting.'; exit 1; }
echo "Deploying release to dev for Build ID: $BUILD_BUILDNUMBER"
echo "================================================="
echo "Step 1:  Update the manifest versions to: $BUILD_BUILDNUMBER"
echo "================================================="
echo "---Updating ApplicationManifest.."
sed -i "/<ApplicationManifest.*ApplicationTypeVersion/s/ApplicationTypeVersion=\".*\"/ApplicationTypeVersion=\"$BUILD_BUILDNUMBER\"/" dreamhomesf/ApplicationManifest.xml
[ $? -eq 0 ] || { echo "Failed to update Application Manifest, Exiting..."; exit 1; }
echo "---Updating ApplicationManifest Completed"
echo "---Updating ServiceManifestRef.."
sed -i "/<ServiceManifestRef.*ServiceManifestVersion/s/ServiceManifestVersion=\".*\"/ServiceManifestVersion=\"$BUILD_BUILDNUMBER\"/" dreamhomesf/ApplicationManifest.xml
[ $? -eq 0 ] || { echo "Failed to update ServiceManifestRef, Exiting..."; exit 1; }
echo "Updating ServiceManifestRef Completed"
echo "---Updating ServiceManifest.."
sed -i "/<ServiceManifest.*Version/s/Version=\".*\"/Version=\"$BUILD_BUILDNUMBER\"/" dreamhomesf/dhNotification/ServiceManifest.xml
[ $? -eq 0 ] || { echo "Failed to update CodePackage, Exiting..."; exit 1; }
echo "---Updating ServiceManifest Completed"
echo "---Updating CodePackage.."
sed -i "/<CodePackage.*Version/s/Version=\".*\"/Version=\"$BUILD_BUILDNUMBER\"/" dreamhomesf/dhNotification/ServiceManifest.xml
[ $? -eq 0 ] || { echo "Failed to update CodePackage, Exiting..."; exit 1; }
echo "---Updating CodePackage Completed"
echo "---Updating ImageName.."
sed -i "s/<ImageName>.*<\/ImageName>/<ImageName>balduino\/dhnotificationsf:$BUILD_BUILDNUMBER<\/ImageName>/" dreamhomesf/dhNotification/ServiceManifest.xml
[ $? -eq 0 ] || { echo "Failed to update ImageName, Exiting..."; exit 1; }
echo "---Updating ImageName Completed"
echo "================================================="
echo "\n"
echo "================================================="
echo "---Updating ServiceManifest.."
sed -i "/<ServiceManifest.*Version/s/Version=\".*\"/Version=\"$BUILD_BUILDNUMBER\"/" dreamhomesf/dhClient/ServiceManifest.xml
[ $? -eq 0 ] || { echo "Failed to update CodePackage, Exiting..."; exit 1; }
echo "---Updating ServiceManifest Completed"
echo "---Updating CodePackage.."
sed -i "/<CodePackage.*Version/s/Version=\".*\"/Version=\"$BUILD_BUILDNUMBER\"/" dreamhomesf/dhClient/ServiceManifest.xml
[ $? -eq 0 ] || { echo "Failed to update CodePackage, Exiting..."; exit 1; }
echo "---Updating CodePackage Completed"
echo "---Updating ImageName.."
sed -i "s/<ImageName>.*<\/ImageName>/<ImageName>balduino\/dhclientsf:$BUILD_BUILDNUMBER<\/ImageName>/" dreamhomesf/dhClient/ServiceManifest.xml
[ $? -eq 0 ] || { echo "Failed to update ImageName, Exiting..."; exit 1; }
echo "---Updating ImageName Completed"
echo "================================================="
echo "\n"
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
