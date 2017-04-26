SERVER=http://192.168.10.24:8888
PACKAGE=pnda-soam-app-0.0.1.tar.gz

app:		## Build the application jar
	sbt assembly

package:	## Build the deployable package
	sbt universal:packageZipTarball

deploy:		## Deploy the package to PNDA cluster
	curl -XPUT $(SERVER)/packages/$(PACKAGE) --data-binary @target/universal/$(PACKAGE) > /dev/null

list:		## Show the deployed packages
	curl $(SERVER)/packages

delete:		## Delete the deployed package
	curl -XDELETE $(SERVER)/packages/$(PACKAGE)

clean:		## Clean the scala build
	sbt clean

help:		## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: help
.DEFAULT_GOAL := help
