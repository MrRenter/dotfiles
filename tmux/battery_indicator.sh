#!/bin/bash
# modified from http://ficate.com/blog/2012/10/15/battery-life-in-the-land-of-tmux/

if [[ `uname` == 'Linux' ]]; then
  current_charge=$(cat /proc/acpi/battery/BAT1/state | grep 'remaining capacity' | awk '{print $3}')
  total_charge=$(cat /proc/acpi/battery/BAT1/info | grep 'last full capacity' | awk '{print $4}')
else
  battery_info=`ioreg -rc AppleSmartBattery`
  current_charge=$(echo $battery_info | grep -o '"CurrentCapacity" = [0-9]\+' | awk '{print $3}')
  total_charge=$(echo $battery_info | grep -o '"MaxCapacity" = [0-9]\+' | awk '{print $3}')
  time_left=$(echo $battery_info | grep -o '"AvgTimeToEmpty" = [0-9]\+' | awk '{print $3}')
fi

charge=$(echo "(($current_charge/$total_charge)*100)" | bc -l | cut -d '.' -f 1)
if [[ $charge -lt 25 ]]; then
  echo -n '#[fg=colour1]'
elif [[ $charge -lt 50 ]]; then
  echo -n '#[fg=colour227]'
else
  echo -n '#[fg=colour77]'
fi

((hour = $time_left/60))
((min = $time_left-$hour*60))
if [[ $hour -lt 20 ]]; then
  echo -n $charge"% "$hour":"$min" left"
else
  echo -n $charge"% Charging "
fi
