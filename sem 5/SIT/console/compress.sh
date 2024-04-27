#! /bin/bash
find $1 -type f -name "*.cpp" -print | xargs zip -r archive.zip 
