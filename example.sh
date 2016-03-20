#!/bin/bash

# Remember to source the library first!
source "progressbar.sh"

# So... truth is the current progress bar doesn't work 
# if the terminal scrolls. That's why this `clear` is here.
clear

echo "Hello, these are two examples of progressbar."

###################
# First example   #
###################

# Call this before starting
# Wherever you call this, there is where the progressbar will be printed
progressbar start

for i in `seq 0 8 150`; do
	#         value        message
	#            | total     |
	#            |  |        |
	#            v  v        v
    progressbar $i 150 "example text"

    if [ $i -eq 48 ]; then
        echo "In this particular step (48/150) there are two echoes"
        echo "But the progress bar will remain where it started :)"
    fi

    # This is so you can see the bar progress move
    sleep .01
done

# When you finish you may let the bar know.
# This fills it to 100% and prints $pb_done_msg
progressbar finish "First example completed."
echo 

###################
# Second example  #
###################


echo "This is another progress bar, with less arguments"

# Call this again!
progressbar start

sleep 1
echo "We can even print stuff before using it (and it will be after the progress bar)"
sleep 2

for i in `seq 0 5 100`; do
	# Here I'm just passing a value, 
	# it assumes it is a percentage
    progressbar $i

    # This is so you can see the bar progress move
    sleep .2
done

echo "End of the demo :)"