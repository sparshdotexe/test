#!/bin/bash

# Get current hour (0-23)
current_hour=$(date +%H)

# Check if time is between 18:00 and 04:00
if [ $current_hour -ge 18 ] || [ $current_hour -lt 4 ]; then
  hyprsunset -t 2700
fi
