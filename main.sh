#! /bin/bash

# Check the input args
if [ ! $# == 3 ]; then
echo "Usage: $0 cfgfile XSize Ysize"
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
interval=50
Doubleinterval=$[$interval*2]

# The maximum and minimum X
XLhi=$[$XL/$Doubleinterval*$interval-$interval]
XLlo=-$XLhi

# The maximum and minimum Y
YLhi=$[$YL/$Doubleinterval*$interval-$interval]
YLlo=-$YLhi


# load the ovito 3.0.0 according to your situation.
module load ovito/3.0.0dev

# remove the temp files
rm -rf tmp.Xnum tmp.Ynum

# When the lines are along x-axis, obtain the grain numbers
for i in `seq $YLlo 50 $YLhi`
do
  ovitos linecut-cfg.py $cfgfile Y $i $[$i+$linewidth] >> tmp.Xnum
done

# When the lines are along y-axis, obtain the grain numbers
echo "When the lines are along y-axis, obtain the grain numbers:"
for i in `seq $XLlo 50 $XLhi`
do
  ovitos linecut-cfg.py $cfgfile X $i $[$i+$linewidth] >> tmp.Ynum
done

cat tmp.Xnum|awk '{sum+=$1} END {print "X-axis Average number = ", sum/NR}'
cat tmp.Ynum|awk '{sum+=$1} END {print "Y-axis Average number = ", sum/NR}'

# remove the temp files
rm -rf tmp.Xnum tmp.Ynum
