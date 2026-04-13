#!/bin/bash

echo "Enter number of processes: "
read n

declare -a pid
declare -a at
declare -a bt
declare -a ct
declare -a tat
declare -a wt

# Input
for((i=0; i<n; i++))
do
    echo "Enter the arrival time of the process P$i:"
    read at[$i]

    echo "Enter the burst time of the process P$i:"
    read bt[$i]

    pid[$i]=$i
done

# Sorting by Arrival Time
for((i=0; i<n; i++))
do
    for((j=i+1; j<n; j++))
    do
        if [ ${at[$i]} -gt ${at[$j]} ]; then

            temp=${at[$i]}
            at[$i]=${at[$j]}
            at[$j]=$temp

            temp=${bt[$i]}
            bt[$i]=${bt[$j]}
            bt[$j]=$temp

            temp=${pid[$i]}
            pid[$i]=${pid[$j]}
            pid[$j]=$temp
        fi
    done
done

current_time=0
total_wt=0
total_tat=0
total_idle=0

# Calculation
for((i=0; i<n; i++))
do
    if [ $current_time -lt ${at[$i]} ]; then
        total_idle=$((total_idle + ${at[$i]} - current_time))
        current_time=${at[$i]}
    fi

    ct[$i]=$((current_time + bt[$i]))
    tat[$i]=$((ct[$i] - at[$i]))
    wt[$i]=$((tat[$i] - bt[$i]))

    total_wt=$((total_wt + wt[$i]))
    total_tat=$((total_tat + tat[$i]))

    current_time=${ct[$i]}
done

# Output Table
echo ""
echo "PID AT BT CT TAT WT"
for((i=0; i<n; i++))
do
    echo "P${pid[$i]} ${at[$i]} ${bt[$i]} ${ct[$i]} ${tat[$i]} ${wt[$i]}"
done

avg_wt=$(awk "BEGIN {printf \"%.2f\", $total_wt/$n}")
avg_tat=$(awk "BEGIN {printf \"%.2f\", $total_tat/$n}")

echo ""
echo "Average Waiting Time: $avg_wt"
echo "Average Turnaround Time: $avg_tat"
echo "Total Idle Time: $total_idle"

# Gantt Chart
echo ""
echo "Gantt Chart:"
echo -n "|"
current_time=0

for((i=0; i<n; i++))
do
    if [ $current_time -lt ${at[$i]} ]; then
        echo -n " Idle |"
        current_time=${at[$i]}
    fi

    echo -n " P${pid[$i]} |"
    current_time=${ct[$i]}
done

echo ""
echo -n "0"
current_time=0

for((i=0; i<n; i++))
do
    if [ $current_time -lt ${at[$i]} ]; then
        echo -n "    ${at[$i]}   "
        current_time=${at[$i]}
    fi

    echo -n "    ${ct[$i]}   "
    current_time=${ct[$i]}
done

echo ""