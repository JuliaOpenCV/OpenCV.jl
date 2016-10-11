#!/bin/bash

set -e

for f in $(ls -l ~/.julia/v0.6  | grep CV | awk '{print $9}' | sort | grep -v "^OpenCV$" | grep -v "CVCore" | grep -v "LibOpenCV")
do
    lowername=$(echo $f | tr '[:upper:]' '[:lower:]')
    dstname=src/modules/${lowername/cv/}.md
    echo $dstname
    sed -i '' -e "s/CVCore/$f/g" $dstname
done
