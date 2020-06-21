#!/bin/bash

function postprocess() {
	array=()
	standardDeviation=()
	cwd=$(pwd)

	tam=$1
	threads=$2
	version=$3

	readarray -t array < timedata.txt

	sum=$(dc -e "0 ${array[*]/-/_} ${array[*]/*/+} p")
			
	media=$(echo "scale=10; $sum / 30" | bc -l)
	
	echo ""$media" "$tam" "$threads" "$version"" >> table.txt

	standardDeviation=$(
		echo "${array[*]}" | 
			awk '{
				sum=0;ssq=0;
				for(i=1; i<=30; i++){
					sum+=$i;
					ssq+=($i*$i);
				}
				print 2*(sqrt(ssq/30-(sum/30)*(sum/30)))
			}'		
		)
	echo $standardDeviation >> stddev.txt
}
clear
echo "Initializing program MMATRIX v11"
readarray -t configarray < settings.config
configlen=${#configarray[@]}
flag=0
m=0
n=0
for (( i=1; i<$configlen; i++ ))
do
	if [ "${configarray[$i]}" = 'THREADS' ]
	then
		flag=1
	fi
	if [ $flag -eq 0 ]
	then
		msizearray[$m]=${configarray[$i]}
		let "m++"
	fi
	if [ $flag -eq 1 ] && [ "${configarray[$i]}" != 'THREADS' ]
	then
		mthreadsarray[$n]=${configarray[$i]}
		let "n++"
	fi
done

msizelen=${#msizearray[@]}
mthreadslen=${#mthreadsarray[@]}

progress=$((100 / $((7* $mthreadslen))))
progprint=$progress

clear
echo "Executing MMATRIX v11"
echo "Progress: 0%"

for ((k=$mthreadslen-1;k>=0;k--))
do
	for version in {1..7}
	do
		for ((i=0;i<$msizelen;i++))
		do
			tam=${msizearray[$i]}
			tam=$(($tam * 1))

			threads=${mthreadsarray[$k]}
			threads=$(($threads * 1))
			
			output=$( './mmatriz' )

			for j in {0..29}
			do
				./mmatriz $tam $threads $version 1>>log.txt
			done

			cat log.txt | awk '{if ($1 == "t") print $2}' log.txt >> timedata.txt |
				awk '{if ($1 != "t") print $0}' log.txt >> log${tam}and${threads}ver${version}.txt

			postprocess $tam $threads $version
			rm log.txt
			rm timedata.txt
		done
		clear
		echo "Executing MMATRIX v11"
		echo "Progress: ${progprint}%"
		let "progprint=progprint+progress"
	done
done
clear
echo "Executing MMATRIX v11"
echo "Plotting graphics"
python3 plota.py
python3 plotb.py
clear
echo "Executing MMATRIX v11"
echo "Checking for errors"
for i in {2..7}
do
	for ((j=0;j<$msizelen;j++))
	do
		tam=${msizearray[$j]}	
		if !(diff "log${tam}and${threads}ver1.txt" "log${tam}and${threads}ver${i}.txt" &> /dev/null ; )
		then
   			echo "Files log${tam}and${threads}ver1.txt and log${tam}and${threads}ver${i}.txt differ" >> errorcheck.txt
		fi
	done
done
clear
echo "MMATRIX v11"
echo "Finished"