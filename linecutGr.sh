#! /bin/bash

# Check the input args
if [ ! $# == 4 ]; then
echo "Usage: $0 cfgfile XSize Ysize interval"
exit
fi

# define the cfg file to be analyzed
cfgfile=$1

# The initial dimensions of a flat polycrystalline graphene
XSize=$2
YSize=$3


# obtain the dimensions of relaxed polycrystalline graphene
XL=`head $cfgfile | grep "H0(1,1)"|awk '{print $3}'|cut -d '.' -f1`
YL=`head $cfgfile | grep "H0(2,2)"|awk '{print $3}'|cut -d '.' -f1`

# define the width of the line
linewidth=3

# define the interval distance between lines
interval=$4
Doubleinterval=$[$interval*2]

# The maximum and minimum X
XLhi=$[$XL/$Doubleinterval*$interval-$interval]
XLlo=-$XLhi

# The maximum and minimum Y
YLhi=$[$YL/$Doubleinterval*$interval-$interval]
YLlo=-$YLhi


# load the ovito 3.0.0 according to your situation. In addition, give a null value to "DISPLAY" for non-graphical computing environment (e.g., running on a cluster).
module load ovito/3.0.0dev
export DISPLAY=""

# remove the temp files
rm -rf tmp.Xnum tmp.Ynum

# When the lines are along x-axis, obtain the grain numbers
for i in `seq $YLlo $interval $YLhi`
do
  ovitos linecut-cfg.py $cfgfile Y $i $[$i+$linewidth] >> tmp.Xnum
done

# When the lines are along y-axis, obtain the grain numbers
for i in `seq $XLlo $interval $XLhi`
do
  ovitos linecut-cfg.py $cfgfile X $i $[$i+$linewidth] >> tmp.Ynum
done

aveXnum=`cat tmp.Xnum|awk '{sum+=$1} END {print sum/NR}'`
aveYnum=`cat tmp.Ynum|awk '{sum+=$1} END {print sum/NR}'`

# remove the temp files
rm -rf tmp.Xnum tmp.Ynum

# compute the average grain size
grainXsize=`echo "scale=9; $XSize/$aveXnum" | bc`
grainYsize=`echo "scale=9; $YSize/$aveYnum" | bc`
grainsize=`echo "scale=9; sqrt($XSize*$YSize/($aveXnum*$aveYnum))" | bc`

# print the results
echo "The average grain number along x-axis: $aveXnum."
echo "The average grain number along y-axis: $aveYnum."
echo ""
echo "The average grain size along x-axis: $grainXsize."
echo "The average grain size along y-axis: $grainYsize."
echo ""
echo "The average grain size: $grainsize."
