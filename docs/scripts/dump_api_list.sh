#!/bin/bash

for f in $(ls -l ~/.julia/v0.6  | grep CV | awk '{print $9}' | sort | grep -v "^OpenCV$" | grep -v "LibOpenCV" | awk '{print $1}')
do
    ff=$(echo $f | tr '[:upper:]' '[:lower:]')
    echo "\"${f/CV/}\" => \"modules/${ff/cv/}.md\""
done
