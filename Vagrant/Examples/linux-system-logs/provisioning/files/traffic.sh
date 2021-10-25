#!/bin/bash
# Use this file to cause Linux to generate logs from commands. This will help
# generate logs that can be piped to Humio.
# *NOTE* This file should be ran by a non-root user

# Function for random sleep interval
function random_sleep() {
    sleep $[ ( $RANDOM % 30 )  + 1 ]s
}

# Create users and gen logs
while true;
do
    for user in {1..10}
    do
        sudo useradd -m dummy${user}

        # Set passwd to draft8Sky5Squat
        if [[ -f /etc/redhat-release ]]; then
            echo "draft8Sky5Squat" | sudo passwd --stdin dummy${user}
        else
            echo "dummy${user}:draft8Sky5Squat" | sudo chpasswd
        fi

        # Become dummy user and generate logs
        random_sleep
        sudo -i -u dummy${user} bash << EOF
function random_sleep { sleep $[ ( $RANDOM % 30 )  + 1 ]s; }
random_sleep
cat /etc/shadow
random_sleep
cat /root/.bash_history
random_sleep
test -f /etc/redhat-release && getenforce
random_sleep
test -f /etc/redhat-release && setenforce 0
random_sleep
useradd fail
random_sleep
userdel root
random_sleep
chgrp dummy${user} /root
random_sleep
echo "draft8Sky5Squat" | sudo -S -k cat /etc/shadow
random_sleep
echo "draft8Sky5Squat" | sudo -S -k cat /root/.bash_history
random_sleep
echo "draft8Sky5Squat" | sudo -S -k useradd -m fail
random_sleep
echo "draft8Sky5Squat" | sudo -S -k userdel root
EOF

        # Exit as dummy user and delete
        random_sleep
        sudo userdel -r dummy${user}
    done
done

