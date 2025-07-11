#!/bin/bash

TARGET=(./daedalus --fullscreen) # Boot target 

EXTENSION="*.z64" # Targeted file extension
SLEEP_TIME=10 #Wait for X seconds to pass boot logos

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
<td>Debug Log</td>
</tr>
EOF

for i in Roms/$EXTENSION; do
    touch "Test/${i}.txt"
    "${TARGET[@]}" "$i" > "Test/${i}.txt" &
    pid=$!
    sleep $SLEEP_TIME

    case $(uname -s) in
    Darwin)
    echo "Darwin"
    screencapture -D 1 "Test/${i}.png" 
    screencapture -D 1 -v -V 30 -g "Test/${i}.mp4" 
    ;;
    Linux)
    import -windows "$WINDOWID" "Test/${i}.png" 
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
		ffmpeg -y -i "$file" "Test/${i:0:-4}.webm"
		rm -f "$file"

    # Grab Screenshot from captured footage
    ffmpeg -y -ss 00:00:10 -i "Test/${i:0:-4}.webm" -frames:v 1 "Test/${i}.png"
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
    <source src="Test/${i:0:-4}.mp4" type="video/mp4">
  </video>
</td>
<td>
<pre>
$(tail -n 5 "Test/${i}.txt" | tr '\r' '\n' | perl -pe 's/\e\[[0-9;?]*[a-zA-Z]//g')
<a href="Test/${i}.txt">See more</a>
</pre>
</td>
</tr>
EOF
done

cat <<EOF >> test_results.html
</table>
</html>
EOF