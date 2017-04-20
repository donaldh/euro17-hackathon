# Hacking on PNDA

A good way to get started hacking with PNDA is to start by looking at the example projects provided by PNDA:

```
git clone git@github.com:donaldh/example-applications.git
```

### Developer Tools

You're probably going to need a Scala development environment - http://scala-ide.org/

At the very least you'll want the Scala built tool `sbt`

```
brew install sbt
```

### Sample Project For if-table Data

I have modified the kafka-spark-opentsdb example on the tsdb-streaming branch so that it works
with the if-table-collector. The app can be deployed to PNDA, where it will receive events from
if-table-collector and transform them into datapoints in OpenTSDB. It is then possible to build
data dashboards using Grafana.

First, build and package the kafka-spark-opentsdb application:

```
git checkout tsdb-streaming
cd kafka-spark-opentsdb
sbt assembly
sbt universal:packageZipTarball
```

Next, deploy the kafka-spark-opentsdb package to the PNDA cluster:

