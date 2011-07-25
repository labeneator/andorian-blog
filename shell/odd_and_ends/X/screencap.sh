#!/bin/bash - 
#===============================================================================
#
#          FILE:  screencap.sh
# 
#         USAGE:  ./screencap.sh 
# 
#   DESCRIPTION:  Captures your screen and makes a video out of it
# 
#
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: Laban Mwangi (lmwangi), lmwangi@gmail.com
#       COMPANY: 
#       CREATED: 23/05/11 14:10:47 MUT
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

TIMER=":"
IMG="png"
FPS=5
AUDIO=0
MYPID=$$
CLEAR=1

# If we have a ctrl-c during screen cap, stop the cap and assemble the video
trap bashtrap INT

bashtrap()
{
	echo "Ctrl-C received. Assembling video"
	kill $CAP_PID;
	make_video
}

usage ()
{
	echo """
	Usage: $0 [-t capture length in seconds] [-f frame rate] [-i image format] [-a Enable audio]
	"""

}

capture_screen()
{
	while $TIMER; 
	do 
		xwd -root |convert - capture-${MYPID}-$(date +%s.%N).${IMG}; 
		sleep $SLEEP_TIME;
	done
}

capture_audio()
{
	arecord  -f cd -t wav audio-${MYPID}.wav
}

make_video ()
{
	# TODO: Video encode is a bit too fast ~ 1.4 times faster
	# No audio
	[ $AUDIO -eq 0 ] && mencoder "mf://*.${IMG}" -mf fps=$FPS -o output-${MYPID}.avi -ovc lavc -lavcopts vcodec=mpeg4

	# We have audio 
	[ $AUDIO -ne 0 ] && mencoder  "mf://*.${IMG}" -mf fps=$FPS -o output-${MYPID}.avi -ovc lavc -lavcopts vcodec=mpeg4 -oac mp3lame -audiofile audio-${MYPID}.wav
	#Clean up
	[ $CLEAR -eq 1 ] && rm -f capture-${MYPID}* audio-${MYPID}*
	exit;
}


while getopts  "c:t:i:f:a" flag
do
	case $flag in
		t)
			TIMER=$OPTARG
		;;
		i)
			IMG=$OPTARG
		;;
		f)
			FPS=$OPTARG
		;;
		c)
			clear=1
		;;
		a)
			AUDIO=1
		;;
		\?)
			usage
		;;
	esac	
done


echo "Starting capture. Press ctrl-c to stop the capture or wait for the capture timeout"
SLEEP_TIME=$(echo "scale=2; 1/$FPS"|bc); 
capture_screen &
CAP_PID=$!

#If we audio, capture it
[ $AUDIO -ne 0 ] && capture_audio & AUD_PID=$!

# Wait for started jobs to finish
wait;

echo "Starting the video encode process"
make_video

