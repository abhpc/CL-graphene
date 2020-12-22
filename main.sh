#! /bin/bash

# Check the input args
if [ ! $# == 1 ]; then
echo "Usage: $0 cfgfile"
exit
fi

# define the cfg file to be analyzed
cfgfile=$1

# The initial dimensions of a flat polycrystalline graphene
#int_X=$1
#int_Y=$2


# obtain the dimensions of relaxed polycrystalline graphene
XL=`head $cfgfile | grep "H0(1,1)"|awk '{print $3}'|cut -d '.' -f1`
YL=`head $cfgfile | grep "H0(2,2)"|awk '{print $3}'|cut -d '.' -f1`

# define the width of the line
linewidth=3

#
XLhi=$[$XL/100*50-50]
XLlo=-$XLhi

# load the ovito 3.0.0 according to your situation.
module load ovito/3.0.0dev


# When the lines are along x-axis, obtain the grain numbers
for i in `seq $XLlo 50 $XLhi`
do
  ovitos linecut-cfg.py $cfgfile X $i $[$i+$linewidth]
done
