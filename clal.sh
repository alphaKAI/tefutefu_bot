#!/bin/sh
LIB=libmy_lib.a
MYLI=my_lib.c
MYLIO=my_lib.o
COMP=gcc
LOG=tefutefu_log
LOGS=tefutefu_log.c

$COMP -c $MYLI
ar rv $LIB $MYLIO
$COMP -o $LOG $LOGS $LIB
make
echo "Complete"
