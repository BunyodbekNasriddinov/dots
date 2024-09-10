#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use
polybar-msg cmd quit
killall -q polybar
# Otherwise you can use the nuclear option:

#!/bin/bash

# Check if HDMI-A-0 is connected
HDMI_STATUS=$(xrandr | grep "HDMI-A-0 connected")

if [[ -n "$HDMI_STATUS" ]]; then
  # HDMI connected, set the layout
  xrandr --output HDMI-A-0 --auto --right-of eDP

  # Send desktops to the right monitor
  bspc monitor eDP -d 1 2 3 4 5 6
  bspc monitor HDMI-A-0 -d 1 2 3 4 5 6

  # Restart polybar for HDMI monitor
  polybar-msg cmd quit
  # Launch bar1 and bar2
  echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
  MONITOR=HDMI-A-0 polybar main 2>&1 | tee -a /tmp/polybar2.log &
  disown

  echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
  MONITOR=eDP polybar main 2>&1 | tee -a /tmp/polybar1.log &
  disown
else
  # HDMI disconnected, go back to single monitor
  xrandr --output HDMI-A-0 --off

  # Set workspaces back to eDP
  bspc monitor eDP -d 1 2 3 4 5 6

  # Restart polybar for eDP monitor
  polybar-msg cmd quit

  # Launch bar1 and bar2
  echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
  MONITOR=eDP polybar main 2>&1 | tee -a /tmp/polybar1.log &
  disown
fi

echo "Bars launched..."
