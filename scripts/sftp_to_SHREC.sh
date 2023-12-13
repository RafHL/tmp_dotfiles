#!/bin/bash
# Made by Andrew Sain
# Optional command line arguments added by Rafael Hernandez

# Variables - Configuration
#user_name="andrewsain"
user_name="rhernandezlopez1"
server_prefix="ece-b312-shrec"
server_suffix="hcs.ufl.edu"
SHREC_Index=-1

# Process
## Get SHREC Server index from commandline arguments
for ind in "$@"
do
    SHREC_Index=$ind

	# Make sure we are dealing w/ an integer
	if ! [[ $SHREC_Index =~ ^[0-9]+$ ]]; then
	    echo $SHREC_Index "not a valid number, skipping.";
		continue;
	fi

	# check if SHREC server index is valid
	if [[ $SHREC_Index -ge 0 && $SHREC_Index -le 5 ]]; then
		echo "Index is valid:" $SHREC_Index
		break;
	else
		echo "Index is invalid:" $SHREC_Index
	fi
done

## Get SHREC Server index via prompt if not command line argument
if ! [[ $SHREC_Index -ge 0 && $SHREC_Index -le 5 ]]; then
    ## Get SHREC Server index
    while :; do
        # get SHREC server
        read -p "Enter index of the SHREC server [0-5] or q: " SHREC_Index

        # Check if quitting
        if [[ $SHREC_Index = "q" || $SHREC_Index = "Q" || $SHREC_Index = "quit" ]]; then
            echo "Quitting"
            exit
        fi

        # Make sure we are dealing w/ an integer
        if ! [[ $SHREC_Index =~ ^[0-9]+$ ]]; then
            echo "Enter a valid number!"; 
            continue;
        fi

        # check if SHREC server index is valid
        if [[ $SHREC_Index -ge 0 && $SHREC_Index -le 5 ]]; then
            echo "Index is valid"
            break;
        else
            echo "Index is invalid"
        fi
    done
fi

## Login to SHREC Server
sftp_command="sftp ${user_name}@${server_prefix}${SHREC_Index}.${server_suffix}"
echo "running: < ${sftp_command} >"
$sftp_command
