#! /bin/bash
find . -name \*.h -print -o -name \*.cpp -print | xargs cat | wc -l

