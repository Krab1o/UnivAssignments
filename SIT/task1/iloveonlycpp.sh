#! /bin/bash
find -type f,d ! -name "*.cpp" ! -path "." -print | xargs rm -r
