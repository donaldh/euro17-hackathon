XDE=../xdeRuntime/bin/runXde.sh
XDE_JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre

COLLECTOR_DIR=../if-table-collector
KAFKA_AGENT_DIR=../prod-odl-kafka/kafka-agent
KAFKA_AGENT=$(KAFKA_AGENT_DIR)/features/target/*.kar

SKIP=-DskipTests -Dcheckstyle.skip
DEBUG=

sshuttle:	## Start sshuttle to PNDA bastion
	screen -S sshuttle-pnda sshuttle -H -r ciscopanda@panda-server5.cisco.com 192.168.0.0/24

ls:	## List the running screen sessions
	@screen -ls || true

karaf:	## Run the karaf instance
	cd $(COLLECTOR_DIR) && screen -S karaf ./karaf/target/assembly/bin/karaf $(DEBUG)

collector:	$(KAFKA_AGENT)	## Build the if-table-collector
	cd $(COLLECTOR_DIR) && mvn clean install $(SKIP)
	cp $(KAFKA_AGENT) $(COLLECTOR_DIR)/karaf/target/assembly/deploy

kafka-agent:	$(KAFKA_AGENT)	## Build the ODL kafka agent

$(KAFKA_AGENT):
	cd $(KAFKA_AGENT_DIR) && mvn clean install $(SKIP)

help:	## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: help
.DEFAULT_GOAL := help
