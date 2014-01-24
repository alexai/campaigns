#! /bin/sh
# chkconfig: 2345 95 20
# description: The campaigns CDM process
# The cdm process that generate campaigns
# processname: campaigns



CAMPAIGN_HOME=/usr/local/cdm
LOG_CONFIG=/usr/local/cdm/config/log4j.properties
if [ -f $LOG_CONFIG ];
then
LOG4J_OVERRIDE=-Dlog4j.configuration=file://$LOG_CONFIG
else
LOG4J_OVERRIDE=""
fi

JNDI_CONFIG=/usr/local/cdm/config/jndi.xml
if [ -f $JNDI_CONFIG ];
then
JNDI_OVERRIDE=-Djava.naming.provider.url=file://$JNDI_CONFIG
else
LOG4J_OVERRIDE=""
fi

CDM_CONFIG=/usr/local/cdm/config/cdm.properties
if [ -f $CDM_CONFIG ];
then
CONFIG_OVERRIDE=-Dcdm.properties.override=file://$CDM_CONFIG
else
CONFIG_OVERRIDE=""
fi


if [[ -z "$1" ]]; then
	PID_FILE=$1
else
	PID_FILE=/var/run/campaigns.pid
fi	

PID_PROPERTY=-Dcampaign.pidfile=$PID_FILE

JAVA_HOME=/usr/local/java

CLASSPATH=$CAMPAIGN_HOME/lib

JMX="-Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.password.file=/root/jmxremote.password -Dcom.sun.management.jmxremote.port=18000"

nohup $JAVA_HOME/bin/java ${JMX} -cp classes:$CLASSPATH/'*' $PID_PROPERTY $CONFIG_OVERRIDE $LOG4J_OVERRIDE $JNDI_OVERRIDE com.demandforce.campaign.Manager <&- &
