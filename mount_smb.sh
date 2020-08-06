#!/bin/bash
umount /Volumes/SHAREDOCS/
mkdir -p  /Volumes/SHAREDOCS/
mount_smbfs //guest:@192.168.1.126/SHAREDOCS /Volumes/SHAREDOCS/
