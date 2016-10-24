#!/bin/bash

declare -i PERCENTUSED
PERCENTUSED=$(df | egrep "/$" | awk '{print $5;}')100

echo -n $PERCENTUSED

