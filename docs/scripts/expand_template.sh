#!/bin/bash -e

for f in $(ls -l ~/.julia/v0.6  | grep CV | awk '{print $9}' | sort | grep -v "^OpenCV$" | grep -v "LibOpenCV" | grep -v "CVCore" | awk '{print tolower($1)}')
do
    echo $f
    cp src/modules/core.md src/modules/${f/cv/}.md
done
