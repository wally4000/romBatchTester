#!/bin/bash

TARGET=daedalus
WINDOWID=daedalus
EXTENSION="*.z64"

mkdir -p Test/Roms

# Generate initial HTML Document
cat <<EOF > test_results.html
<html>
<title> DaedalusX64 Test Results $(date) </title>
<table border="1">
<tr>
<td>Game Name:</td>
<td>Screenshot</td>
<td>Gameplay</td>
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
		flatpak run com.obsproject.Studio --minimize-to-tray --disable-shutdown-check --startrecording --profile Daedalus &
		sleep 5
		OBS_PID=$(ps -ef | awk '{if($8=="obs"){print $2}}')
		echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
		echo " OBS : $OBS_PID"
		echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
		sleep 27 # makes the video 30 seconds
		kill $OBS_PID
		sleep 2
		file=$(ls -1rt $HOME/*.mkv)
		ffmpeg -y -i "$file" "Test/${i:0:-4}.mp4"
		rm -f "$file"
    ;;
    default)
    echo "Screen capture software needed"
    ;;
    esac
    kill -9 "$pid"

cat <<EOF >> test_results.html
<tr>
<td>${i:5:-4}</td>
<td><img src="Test/${i}.png" width="320" height="200"></td>
<td>
  <video width="320" height="200" controls>
    <source src="Test/${i:0:-4}.mp4" type="video/mp4"
  </video>
</td>
</tr>
EOF


done

cat <<EOF >> test_results.html
</table>
</html>
EOF
