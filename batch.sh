#!/bin/bash

TARGET=daedalus
EXTENSION="*.z64"

mkdir -p Test/Roms

# Generate initial HTML Document
cat <<EOF > test_results.html
<html>
<title> DaedalusX64 Test Results $(date) </title>
<table>
<tr>
<td>Game Name:</td>
<td></td>
<td>Screenshot</td>
</tr>
EOF

for i in Roms/$EXTENSION; do
    touch "Test/${i}.txt"
    ./$TARGET "$i" > "Test/${i}.txt" &
    pid=$!
    sleep 10
    case $(uname -s) in

    Darwin)
    screencapture "Test/${i}.png" ## need to capture window not whole screen
    ;;
    Linux)
    import -windows "$TARGET" "Test/${i}.png"
    ;;
    default)
    echo "Screen capture software needed"
    ;;
    esac
    kill -9 "$pid"

cat <<EOF >> test_results.html
<tr>
<td>${i:5:-4}</td>
<td></td>
<td><img src="Test/${i}.png" width="320" height="200"> </td>
</tr>
EOF

done

cat <<EOF >> test_results.html
</html>
EOF
