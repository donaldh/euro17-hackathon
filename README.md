# euro17-hackathon

### Prerequisites

You will need to install sshuttle for connecting to the PNDA deployment. The PNDA connection is
authenticated using a private key which you can get from me.

#### macOS

```
brew install sshuttle
```

#### Linux / Ubuntu

```
sudo apt install sshuttle
```

### Setting Up

```
git clone git@github.com:donaldh/if-table-collector.git
git clone git@github.com:donaldh/prod-odl-kafka.git
git clone git@github.com:donaldh/euro17-hackathon.git
```

### Getting Started

Various tasks are automated with make:

```
% cd euro17-hackathon
% make
sshuttle             Start sshuttle to PNDA bastion
ls                   List the running screen sessions
karaf                Run the karaf instance
collector            Build the if-table-collector
kafka-agent          Build the ODL kafka agent
help                 This help
%
```

### Running sshuttle

sshuttle is a poor-man's VPN and is used to connect to the PNDA cluster. We run sshuttle in a
screen session so that we can disconnect the screen and leave it running in the background. The
screen escape character is Ctrl-a, so you disconnect by typing [Ctrl-a] [d]

```
% make sshuttle
[local sudo] Password:
client: Connected.
[Ctrl-a] [d]
```

### Building and Running OpenDaylight

You can build the if-table-collector project and the kafka-agent dependency using make:

```
% make collector
```

You can run the if-table-collector OpenDaylight instance in a screen session - use [Ctrl-a] [d] to disconnect:

```
% make karaf
Apache Karaf starting up. Press Enter to open the shell now...
100% [========================================================================]

Karaf started in 14s. Bundle stats: 334 active, 334 total

    ________                       ________                .__  .__       .__     __
    \_____  \ ______   ____   ____ \______ \ _____  ___.__.|  | |__| ____ |  |___/  |_
     /   |   \\____ \_/ __ \ /    \ |    |  \\__  \<   |  ||  | |  |/ ___\|  |  \   __\
    /    |    \  |_> >  ___/|   |  \|    `   \/ __ \\___  ||  |_|  / /_/  >   Y  \  |
    \_______  /   __/ \___  >___|  /_______  (____  / ____||____/__\___  /|___|  /__|
            \/|__|        \/     \/        \/     \/\/            /_____/      \/


Hit '<tab>' for a list of available commands
and '[cmd] --help' for help on a specific command.
Hit '<ctrl-d>' or type 'system:shutdown' or 'logout' to shutdown OpenDaylight.

opendaylight-user@root>
```

### Configuring OpenDaylight

#### Kafka Agent

First you need to configure the kafka-agent to talk to the PNDA cluster:

```
PUT :host/restconf/config/kafka-agent:kafka-producer-config
Authorization: :basic-auth
Content-Type: application/json
{
  kafka-producer-config: {
    kafka-broker-list: "192.168.10.18:9092",
    kafka-topic: "odl",
    compression-type: "none",
    message-serialization: "avro",
    avro-schema-namespace:"com.example.project",
    message-host-ip-xpath:"/payload/source/text()",
    default-message-source: "if-table-collector"
  }
}
```

#### Event Aggregator

Next you need to configure the OpenDaylight event aggregator to publish events

```
POST :host/restconf/operations/event-aggregator:create-topic
Authorization: :basic-auth
Content-Type: application/json
{ "event-aggregator:input": {"notification-pattern": "*", "node-id-pattern":".*"}}
```

#### Add a Device to OpenDaylight

Finally you can add devices to OpenDaylight, with SNMP credentials to enable if-table polling:

```
POST :host/restconf/config/network-topology:network-topology/topology/topology-netconf
Authorization: :basic-auth
Content-Type: application/json
{
  "node" : {
    "node-id": ":node",
    "snmp-community": ":snmpcommunity",
    "snmp-port": :snmpport,
    "poll-interval": 60,
    "host": ":addr",
    "password": ":devicepassword",
    "username": ":deviceusername",
    "port": :netconfport,
    "tcp-only": false,
    "keepalive-delay": 0
  }
}
```
