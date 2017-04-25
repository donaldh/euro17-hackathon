LOGSTASH_DIR=../../logstash-2.4.0

start:	## Start collecting
	screen -S logstash -dm $(LOGSTASH_DIR)/bin/logstash -f logstash-syslog.conf

stop:	## Stop collecting
	-screen -X -S logstash quit

ls:	## List the running screen sessions
	screen -ls

help:	## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: help
.DEFAULT_GOAL := help
