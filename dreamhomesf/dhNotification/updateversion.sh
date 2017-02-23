#!/bin/bash
codeversion=$(grep -n  "<CodePackage.*Version" ServiceManifest.xml | cut -d: -f1)
sed s/
