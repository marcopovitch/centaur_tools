#!/bin/bash

INSTALL_DIR="/media/removable0"
CENTAUR_DIR="$INSTALL_DIR/centaur_tools"
SDS_DIR="$INSTALL_DIR/SDS"

# ---------------------------

SCRIPTS_DIR=$CENTAUR_DIR/scripts
CONF_DIR=$CENTAUR_DIR/conf
LOG_DIR=$CENTAUR_DIR/log
VAR_DIR=$CENTAUR_DIR/var

# directories
mkdir -p $SDS_DIR
mkdir -p $LOG_DIR
mkdir -p $VAR_DIR

mkdir -p $VAR_DIR/ring
mkdir -p $VAR_DIR/ring/tlog
mkdir -p $VAR_DIR/slarchive

# get from Centaur the network code and station code
NET_STA=$($SCRIPTS_DIR/get_channels.sh)
echo "Starting acquisition for $NET_STA"

# SLARCHIVE
$CENTAUR_DIR/bin/slarchive \
    -SDS $SDS_DIR \
    -S "$NET_STA:???.D" \
    -x $VAR_DIR/slarchive/slarchive.statefile:120 localhost:18000 \
> $LOG_DIR/slarchive.log 2>&1 &


# generate ringserver configuration file 
sed "s#@VAR@#${VAR_DIR}#g; ; s#@SDS@#${SDS_DIR}#g" $CONF_DIR/ringserver.conf.template > $CONF_DIR/ringserver.conf

# Ringserver
$CENTAUR_DIR/bin/ringserver $CONF_DIR/ringserver.conf > $LOG_DIR/ringserver.log 2>&1 &
