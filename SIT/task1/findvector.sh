#! /bin/bash
grep --include=\*.cpp -Rl '#include <vector>' . | xargs realpath 
