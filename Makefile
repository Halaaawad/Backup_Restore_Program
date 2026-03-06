TEST_BASE_DIR=./backup_test_$(shell date +%s)
SOURCE_DIR=$(TEST_BASE_DIR)/source
BACKUP_DIR=$(TEST_BASE_DIR)/backups

interval=1
maxbackups=3

run:
	mkdir -p $(SOURCE_DIR) $(BACKUP_DIR)
	@echo "Backup directory is ready: $(BACKUP_DIR)"
	bash backupd.sh $(SOURCE_DIR) $(BACKUP_DIR) $(interval) $(maxbackups) & \
	PID=$$!; \
	sleep 20; \
	kill $$PID; \
	echo "Stopped backupd.sh (PID $$PID)"; \
	bash restore.sh $(SOURCE_DIR) $(BACKUP_DIR)

