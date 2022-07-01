#!/usr/bin/bash

# Search for all attached hard drives
function getAllHddAtached {
    echo "get all hdd attached"
    
    #create array
    fsTypeArray=()
    uuidArray=()
    mapfile -t fsTypeArray < <(lsblk -o FSTYPE,MOUNTPOINT,UUID | awk 'NF==2 {print $1}')
    mapfile -t uuidArray < <(lsblk -o FSTYPE,MOUNTPOINT,UUID | awk 'NF==2 {print $2}')

    echo "output array we created"
    echo "${fsTypeArray[@]}"
    echo "${uuidArray[@]}"

    index=0
    for i in "${fsTypeArray[@]}"
    do
        if [ $i == ntfs ] 
        then
            echo "mountNtfsDrive"
            currentDate="date +%Y%m%d%H%M%S"
            mountNtfsDrive "${uuidArray[$index]}" `$currentDate`
        elif [ $i == ext4 ]
        then
            echo "mount ext4" 
            currentDate="date +%Y%m%d%H%M%S"
            mountExt4Drive "${uuidArray[$index]}" `$currentDate`
        fi
        echo index
        let "index++"
         sleep 1s
    done
}

# Mount a ext4 drive
function mountExt4Drive {
    uuid=$1
    location=$2
    mkdir -pv "/home/$location"
    sleep 3s
    echo "mounting ext4 hdd $uuid in $location"
    mount UUID=$uuid $location
}

# Mount NTFS drive
function mountNtfsDrive {
    echo "mounting ntfs $1 in $2"
    mkdir -pv "/home/$2"
    sleep 3s
    mount -t ntfs-3g "UUID=$1" "/home/$2"
}

getAllHddAtached