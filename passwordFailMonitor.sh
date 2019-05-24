#!/bin/bash
# Simple script to look for attempted password spraying attacks
# The script tallies a count of failed login attempts for all users and date of last failed login.

# Get failed user logins from logs, list of users from etc/passwd
LOGFILE=/var/log/btmp
PASSWD=/etc/passwd

# Create table header row for displaying to terminal
HEADER="User \t LastFailedLogin \t BadPasswordCount"
HEADER="${HEADER} \n ----------------- \t ----------------- \t -----------------\n"

OUTPUT=""    

# Launch subshell
{
  # Loop over each username on the system
  for USR in $(grep -E '/home/' "${PASSWD}" | cut -d':' -f 1 | sort)
  do
    # Check if the user is also in the logfile with failed login attempts
    if [[ -z $(grep "${USR}" "${LOGFILE}") ]]
    then
      # Create an emtpy line in the output table
      OUTPUT="${OUTPUT} \n ${USR} \t - \t 0"
    else
      # Get corresponding count of failed login attempts and datetime stamp of last attempt
      FAILS=$(lastb -wFf ${LOGFILE} | grep "${USR}")
      COUNT=$(echo "${FAILS}" | awk '{ print $1 }' | wc -l | awk '{ print $1 }')
      DATE=$(echo "${FAILS}" | awk '{ x=$3"-"$4"-"$5"-"$6"-"$7; print x }' | sort -r | head -n 1)

      # Create a line in the output table with the count data and datetime stamp
      OUTPUT="${OUTPUT} \n ${USR} \t ${DATE} \t ${COUNT}"
    fi
  done

  # Format display of output table to the terminal, aligned as column-seperated table.
  printf "%b" "${HEADER} \n $(printf %b ${OUTPUT} | sort -k 3 -r)" | column -t
}