#!/run/current-system/sw/bin/bash

# Terminate already running bar instances
pkill polybar
# If all your bars have ipc enabled, you can also use 
# polybar-msg cmd quit

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch mybar
echo "---" | tee -a /tmp/polybar_mybar.log
polybar mybar 2>&1 | tee -a /tmp/polybar_mybar.log & disown
polybar mybar2 2>&1 | tee -a /tmp/polybar_mybar.log & disown
polybar mybar3 2>&1 | tee -a /tmp/polybar_mybar.log & disown
