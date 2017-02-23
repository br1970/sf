#!/bin/bash
sed "/<ServiceManifestRef.*ServiceManifestVersion/s/ServiceManifestVersion=\".*\"/ServiceManifestVersion=\"$BUILDID\"/" ApplicationManifest.xml