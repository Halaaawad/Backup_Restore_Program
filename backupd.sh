#! /bin/bash

dir="$1"
backupdir="$2"
interval_secs="$3"
max_backups="$4"

if [[ -z "$dir" || -z "$backupdir" || -z "$interval_secs" || -z "$max_backups" ]]; then
    echo "Invalid number of arguments, usage: $0 <source_dir> <backup_dir> <interval_secs> <max_backups>"
    exit 1
fi

if [[ ! -d "$dir" ]]; then
    echo "Error: source directory $dir does not exist."
    exit 1
fi

if ! [[ "$interval_secs" =~ ^[0-9]+$ ]]; then
    echo "Error: interval_secs must be a positive integer (in seconds)."
    exit 1
fi

if ! [[ "$max_backups" =~ ^[0-9]+$ ]]; then
    echo "Error: interval_secs must be a positive integer (in seconds)."
    exit 1
fi

mkdir -p "$backupdir"

LAST_FILE="$backupdir/directory-info.last"
NEW_FILE="$backupdir/directory-info.new"

find "$dir" -type f -exec md5sum {} + | sort > "$LAST_FILE"

current_date=$(date +'%Y-%m-%d-%H-%M-%S')
cp -r "$dir" "$backupdir/$current_date"
echo "[$(date +'%Y-%m-%d-%H-%M-%S')] Initial backup created at $backupdir/$current_date"
backup_counter=1

while true; do
	sleep "$interval_secs"

	find "$dir" -type f -exec md5sum {} + | sort > "$NEW_FILE"

	if ! diff -q "$NEW_FILE" "$LAST_FILE" > /dev/null; then
		current_date=$(date +'%Y-%m-%d-%H-%M-%S')
		cp -r "$dir" "$backupdir/$current_date"
		echo "[$(date +'%Y-%m-%d-%H-%M-%S')] Change in the file was detected. New Backup created at $backupdir/$current_date"

		cp "$NEW_FILE" "$LAST_FILE"
		backup_counter=$((backup_counter + 1))
		if (( backup_counter > max_backups )); then
			deleted_files=$(ls -dt "$backupdir"/* | tail -n +$(($max_backups + 1)))
			echo "The following old backups were removed"
			echo "$deleted_files"
			rm -rf $deleted_files
		fi
	else
		echo "No change was detected, starting a new check"
	fi

done


