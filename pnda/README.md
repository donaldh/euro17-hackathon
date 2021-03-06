# Hacking on PNDA

A good way to get started hacking with PNDA is to start by looking at the example projects
provided by PNDA. Here is a fork of the example-applications project:

```
git clone git@github.com:donaldh/example-applications.git
```

### Background Reading

http://pnda.io/guide - The official PNDA documentation

### Developer Tools

You're probably going to need a Scala development environment, such as the Eclipse based Scala
IDE - http://scala-ide.org/

http://download.scala-ide.org/sdk/lithium/e46/scala211/stable/site

At the very least you'll want the Scala built tool `sbt`:

```
brew install sbt
```

### Sample Streaming Project For if-table Data

Now that OpenDaylight is publishing if-table data to the PNDA kafka bus, we can do something
useful with it. The simplest thing we can do is write a Spark streaming application to consume
data from the kafka bus and produce datapoints in OpenTSDB. It will then be possible to build
data dashboards using Grafana.

I have taken the kafka-spark-opentsdb example from PNDA example-applications and adapted it to
our needs. This application can be found in pnda-kso-iftable-app. The app can be deployed to
PNDA, where it will receive kafka events from the OpenDaylight if-table-collector and transform
them into datapoints in OpenTSDB. It is then possible to build data dashboards using Grafana.

First, build and package the pnda-kso-iftable-app application:

```sh
cd pnda-kso-iftable-app
make app        # sbt assembly
make package    # sbt universal:packageZipTarball
```

Next, deploy the pnda-kso-iftable-app package to the PNDA cluster:

```sh
make deploy

# curl -v -XPUT http://192.168.10.24:8888/packages/pnda-kso-iftable-app-0.0.1.tar.gz \
#   --data-binary @target/universal/pnda-kso-iftable-app-0.0.1.tar.gz
```

