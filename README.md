# BACKUP-RESTORE-PROGRAM

The Backup and Restore program written in Bash  deals with constantly checking whether a directory has been updated or not, saving changes with a maximum backup number limit and restoring the directory either to an old version or the one following the current one.

## Overview
These are the files and folders it contains:
backupd.sh is a daemon script that runs indefinitely until stopped and checks a source directory for changes, creating timestamped backups in a backup directory when changes are detected. It checks with specific time intervals and stores at most max_backups of the latest backups.
restore.sh is an interactive script to restore backups depending on user input.
Makefile creates its own test folders and runs the backup and restore sequence for testing purposes.
tests/ a directory that contains different bash scripts to test different use cases and checks for errors.

## Folder hierarchy
|--backupd.sh
|--restore.sh
|--Makefile
|--tests/
	|--backup_content_verification.sh
	|--backup_directory_naming_format.sh
	|--change_detection_and_automatic_backup.sh
	|--initial_backup_creation.sh
	|--invalid_interval.sh
	|--invalid_max_backups.sh
	|--LAST_FILE
	|--maximum_backups_limit.sh
	|--non_existent_source.sh
	|--restore_args.sh
	|--restore_content_verification.sh
	|--restore_navigation.sh
	|--restore_no_matching.sh
	|--wrong_arguments.sh


## Installation
First installation would be for automating the execution of the commands in the Makefile.
We used the following command to install make:

```bash
sudo apt install make
```

Second installation was because of an error that occurred because of using WIndows-style line endings (CRLF) instead of using Unix-style (LF)

```bash 
sudo apt update
sudo apt install dos2unix
```

## Step-by-step instructions for running backupd.sh and restore.sh
1.Create your **source** (necessary)  and **backup** directory (optional)
2.Determine number of latest backups required and interval (in secs) between each check
3.Start the backup daemon:
```bash
./backupd.sh <sourcedir> <backupdir> <interval> <maxbackups>
```
4.In another terminal, modify files inside your source directory
5.The backup daemon would detect the change and create a new timestamped folder
6.Stop the backup daemon when needed (CTRL + C)
7.Start restore.sh by giving it the same source and backup directories used in the backup process
```bash
./restore.sh <sourcedir> <backupdir>
```
8.Its interactive options are:
1-move to previous backup from current backup
2-move to the backup following the current backup
3-exit the program
Note: restore programm will stay running until you choose 3 to exit it, until then it will always require an input.

# Running using the MakeFile
As the backupd.sh daemon runs forever, the **Makefile** is programmed to execute the backup daemon for 20 seconds, stops it and then uses the same source and backup directories to execute the restore.sh.
Each check is 1sec apart from the others and it saves a maximum of 3 backups.

To run everything automatically:
```bash
make run
```

[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/eZm3ZHfi)

