#!/bin/bash 
# Check arguments first 
#!/bin/bash 
# Argument validation 
dir="$1" 
backupdir="$2" 
if [[ -z "$dir" || -z "$backupdir" ]]; then 
	progname=$(basename "$0")
	echo "Usage: $progname <source_dir> <backupdir>" 
	exit 1 
fi 

if [[ ! -d "$backupdir" ]]; then 
	echo "Usage: The Backup directory '$backupdir' given does not exist" 
	exit 1 
fi 

mapfile -t backups < <(ls -1 "$backupdir" | sort)
current_index=-1

for i in "${!backups[@]}"; do
    if diff -qr "$dir" "$backupdir/${backups[$i]}" > /dev/null 2>&1; then
        current_index=$i
        break
    fi
done


for i in "${!backups[@]}"; do 
	ls -lR "$backupdir/${backups[$i]}" > /tmp/backup-info.txt 	
	if diff -q /tmp/current-info.txt /tmp/backup-info.txt > /dev/null; then 
		current_index=$i 
		break 
		fi 
done 

if [ "$current_index" -eq -1 ]; then
    echo "No matching backup found for current state"
    echo "Press 3 to exit."
    current_index=0  # dummy index to keep structure valid
fi

while true; do
	echo "Choose an option:"
	echo "Press 1 to restore source directory to the most recent version prior to current backup" 
	echo "Press 2 to move forward" 
	echo "Press 3 to break" 
	read -r input 

if [ "$current_index" -eq -1 ]; then
        echo "No valid backup to navigate. Please exit (option 3)."
fi
   
if [ "$input" -eq 1 ]; then 
	if [ "$current_index" -le 0 ]; then 
		echo "The current backup is the oldest one" 
	else
		current_index=$((current_index - 1))
		selected_backup="${backups[$current_index]}" 
		cp -a "$backupdir/$selected_backup/." "$dir" 
		echo "Restored to previous version: $selected_backup" 
	fi 
	
elif [ "$input" -eq 2 ]; then 
	if [ "$current_index" -ge $(( ${#backups[@]} - 1 )) ]; then
		echo "The current backup is the newest" 
	else 
		current_index=$((current_index + 1))
		selected_backup="${backups[$current_index]}" 
		cp -a "$backupdir/$selected_backup/." "$dir/" 
		echo "Restored to new version : $selected_backup"
	fi 

elif [ "$input" -eq 3 ]; then 
	echo "Exiting the prog" 
	break 
	
else 
	echo "Invalid selection. Please enter either 1,2, or 3" 
fi

done
