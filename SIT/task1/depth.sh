#! /bin/bash
find . -name 'how_far_are_you.txt' | grep -o '/' - | wc -l
