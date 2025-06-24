#!/bin/bash

mkdir -p Test/Roms

# Generate initial HTML Document
cat <<EOF > test_results.html
<html>
<title> DaedalusX64 Test Results $(date) </title>
<table>
<tr>
<td>Game Name:</td>
<td>Screenshot</td>
</tr>
EOF


for i in Roms/*.z64; do
    # echo $i
    touch "Test/${i}.txt"
    ./daedalus "$i" > "Test/${i}.txt" &
    pid=$!
    sleep 10
    case $(uname -s) in

    Darwin)
    screencapture "Test/${i}.png"
    ;;
    Linux)
    ;;
    default)
    echo "Screen capture software needed"
    ;;
    esac
    kill "$pid"

cat <<EOF >> test_results.html
<tr>
<td>"$i"</td>
<td><img src="Test/${i}.png" width="320" height="200"> </td>
</tr>
EOF

done

cat <<EOF >> test_results.html
</html>
EOF
