#!/bin/bash

function CleanFiles(){
	rm -f BenchFloat.o
	rm -f BenchFloat
	rm -f BenchInt.o
	rm -f BenchInt
}
function Start(){
	echo "MatrixBench v1.0"
	echo " "

	smt=$( cat /proc/cpuinfo | grep -o ht | uniq )
	cpuFreq=$( grep 'cpu MHz' /proc/cpuinfo | head -1 | awk -F: '{print $2/1024}' )

	echo "$(lscpu | grep 'Model name' | cut -f 2 -d ":" | awk '{$1=$1}1') @ $cpuFreq GHz"

	if  [ $smt = "ht" ]
	then 
		cores=$( grep -c ^processor /proc/cpuinfo )
		phyCores=$( grep ^cpu\\scores /proc/cpuinfo | uniq |  awk '{print $4}' )
		echo "Cores: $phyCores physical / $cores logical"
	else
		cores=$( grep -c ^processor /proc/cpuinfo )
		echo "Cores: $cores physical / $cores logical"
	fi

	echo " "
	echo "Press [I] for more information"
	echo " "
	echo "Press [O] for options (advanced)"
	echo " "
	echo "Press Ctrl+C to abort"
	echo " "
	echo " "
	CurrentSettings
	echo " "

	echo "Select the Data Size Preset:"
	echo "	S -> Quick"
	echo "	M -> Recommended"
	echo "	L -> For high core count systems / Stress test"
	echo " "

	read -s -n 1 dataSize

	if [ $dataSize == "i" ] || [ $dataSize == "I" ]
	then
		Info
	fi
	if [ $dataSize == "o" ] || [ $dataSize == "O" ]
	then 
		Options
	fi
}
function CurrentSettings(){
	echo "Current Settings:"
	if [ $t1 == "0" ] && [ $t2 == "3" ] && [ $v1 == "0" ] && [ $v2 == "3" ]
	then
		echo "	Complete test"
	fi
	if [ $t1 == "0" ] && [ $t2 == "1" ] && [ $v1 == "0" ] && [ $v2 == "3" ]
	then
		echo "	Complete integer test"
	fi
	if [ $t1 == "2" ] && [ $t2 == "3" ] && [ $v1 == "0" ] && [ $v2 == "3" ]
	then
		echo "	Complete float test"
	fi

	if [ $t1 == "0" ] && [ $t2 == "3" ] && [ $v1 == "1" ] && [ $v2 == "3" ]
	then
		echo "	Complete test (no speedup graphs)"
	fi
	if [ $t1 == "0" ] && [ $t2 == "1" ] && [ $v1 == "1" ] && [ $v2 == "3" ]
	then
		echo "	Complete integer test (no speedup graphs)"
	fi
	if [ $t1 == "2" ] && [ $t2 == "3" ] && [ $v1 == "1" ] && [ $v2 == "3" ]
	then
		echo "	Complete float test (no speedup graphs)"
	fi

	if [ $t1 == "0" ] && [ $t2 == "3" ] && [ $v1 == "0" ] && [ $v2 == "2" ]
	then
		echo "	Fast test"
	fi
	if [ $t1 == "0" ] && [ $t2 == "1" ] && [ $v1 == "0" ] && [ $v2 == "2" ]
	then
		echo "	Fast integer test"
	fi
	if [ $t1 == "2" ] && [ $t2 == "3" ] && [ $v1 == "0" ] && [ $v2 == "2" ]
	then
		echo "	Fast float test"
	fi

	if [ $t1 == "0" ] && [ $t2 == "3" ] && [ $v1 == "1" ] && [ $v2 == "2" ]
	then
		echo "	Fast test (no speedup graphs)"
	fi
	if [ $t1 == "0" ] && [ $t2 == "1" ] && [ $v1 == "1" ] && [ $v2 == "2" ]
	then
		echo "	Fast integer test (no speedup graphs)"
	fi
	if [ $t1 == "2" ] && [ $t2 == "3" ] && [ $v1 == "1" ] && [ $v2 == "2" ]
	then
		echo "	Fast float test (no speedup graphs)"
	fi
}
function Info(){
	clear
	echo "MatrixBench v1.0"
	echo " "
	echo "This software uses OpenMP to paralelize the matrix multiplication."
	echo " "
	echo "The GCC v7 or higher and Python3 is needed to run the application."
	echo " "
	echo "If the computer uses any form of Hyper-Threading, the software will"
	echo "execute a core+ht benchmark to stress the whole core structure,"
	echo "if not, only the standard benchmark will run."
	echo " "
	echo "The [S] preset -> square matrix from 500-1500 size"
	echo "The [M] preset -> square matrix from 1500-2500 size"
	echo "The [L] preset -> square matrix from 3000-4000 size"
	echo " "
	echo "For more info, visit the GitHub Repo: "
	echo " "
	echo " "
	echo "Press [Q] to go back"
	read -s -n 1 info
	if [ $info == "q" ] || [ $info == "Q" ]
	then
		clear
		Start
	else
		Info
	fi
}
function Options(){
	clear
	echo "OPTIONS (1/2)"
	echo " "
	#test0 = int close, test1 = int spread, test2 = float close, test3 = float spread
	echo "The software can be run in ways that certain parts of the CPU are stressed:"
	echo "Press [0] for the full test"
	echo "Press [1] for the integer test"
	echo "Press [2] for the float test"
	echo " "
	echo " "
	echo "Press [Q] to go to main menu"
	read -s -n 1 o1
	if [ $o1 == "0" ] || [ $o1 == "1" ] || [ $o1 == "2" ] || [ $o1 == "q" ] || [ $o1 == "Q" ]
	then
		if [ $o1 == "0" ]
		then
			t1=0
			t2=3
		fi
		if [ $o1 == "1" ]
		then
			t1=0
			t2=1
		fi
		if [ $o1 == "2" ]
		then
			t1=2
			t2=3
		fi
		if [ $o1 == "q" ] || [ $o1 == "Q" ]
		then
			clear
			Start
		fi
		clear
		Options2
	else
		Options
	fi
}
function Options2(){
	clear
	echo "OPTIONS (2/2)"
	echo " "
	#full=0..2 (single thread, external lace, middle lace (trocar por openACC ext lace)) TODO
	echo "The software can be run in ways that certain parts of the CPU are stressed:"
	echo "Press [0] for the full test"
	echo "Press [1] for the fast test (weaker cache stress)"
	echo " "
	echo " "
	echo "Press [Q] to go to main menu"
	read -s -n 1 o2
	if [ $o2 == "0" ] || [ $o2 == "1" ] || [ $o2 == "2" ] || [ $o2 == "3" ] || [ $o2 == "q" ] || [ $o2 == "Q" ]
	then
		if [ $o2 == "0" ]
		then
			v1=0
			v2=2 #com openACC seria de 0 a 5 creio eu
		fi
		if [ $o2 == "1" ]
		then
			v1=1
			v2=2
		fi
		clear
		Start
	else
		Options2
	fi
}
function ThreadsSettings(){
	if [ $cores -le 16 ]
	then
		minCpuCores=2
		currentCores=2
		for n in {0..8}
		do
			if [ $currentCores -le $cores ]
			then
				mthreadsarray[n]=$currentCores
				currentCores=$(( $currentCores + $minCpuCores ))
			fi
		done
	fi


	if [ $cores -gt 16 ]
	then
		minCpuCores=8
		currentCores=4
		for n in {0..8}
		do
			if [ $currentCores -le $cores ]
			then
				mthreadsarray[n]=$currentCores
				currentCores=$(( $currentCores + $minCpuCores ))
			fi
		done
	fi
}
function MatrixSettings(){
	if [ $dataSize == "s" ] || [ $dataSize == "S" ]
	then
		minSize=500
		stepSize=200
		#minSize=100
		#stepSize=20
		for n in {0..5}
		do
			msizearray[n]=$(( $minSize + (( $stepSize * $n ))))
		done
		echo ""
		echo "Selected: S"
	fi

	if [ $dataSize == "m" ] || [ $dataSize == "M" ]
	then
		minSize=1500
		stepSize=200
		for n in {0..5}
		do
			msizearray[n]=$(( $minSize + (( $stepSize * $n ))))
		done
		echo ""
		echo "Selected: M"
	fi

	if [ $dataSize == "l" ] || [ $dataSize == "L" ]
	then
		minSize=3000
		stepSize=200
		for n in {0..5}
		do
			msizearray[n]=$(( $minSize + (( $stepSize * $n ))))
		done
		echo ""
		echo "Selected: L"
	fi
}
function HtExe(){
	if [ $test -eq 0 ]
	then
		output=$( './BenchInt' )s
		export OMP_PROC_BIND=close
		./BenchInt $tam $threads $version >> temp.txt
	fi
	if [ $test -eq 1 ]
	then
		output=$( './BenchInt' )s
		export OMP_PROC_BIND=spread
		./BenchInt $tam $threads $version >> temp.txt
	fi
	if [ $test -eq 2 ]
	then
		output=$( './BenchFloat' )s
		export OMP_PROC_BIND=close
		./BenchFloat $tam $threads $version >> temp.txt
	fi
	if [ $test -eq 3 ]
	then
		output=$( './BenchFloat' )s
		export OMP_PROC_BIND=spread
		./BenchFloat $tam $threads $version >> temp.txt
	fi
}
function NonHtExe(){
	if [ $test -eq 1 ]
	then
		output=$( './BenchInt' )s
		export OMP_PROC_BIND=spread
		./BenchInt $tam $threads $version >> temp.txt
	fi
	if [ $test -eq 3 ]
	then
		output=$( './BenchFloat' )s
		export OMP_PROC_BIND=spread
		./BenchFloat $tam $threads $version >> temp.txt
	fi
}
function PostProcess() {
	array=()
	standardDeviation=()
	cwd=$(pwd)

	tam=$1
	threads=$2
	version=$3

	readarray -t array < timedata.txt

	sum=$(dc -e "0 ${array[*]/-/_} ${array[*]/*/+} p")
			
	media=$(echo "scale=10; $sum / 30" | bc -l)
	
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
	echo ""$media" "$standardDeviation" "$tam" "$threads" "$version"" >> execLog.txt

	if  [ $smt = "ht" ]
	then 
		if [ "$test" -eq 1 ] || [ "$test" -eq 3 ]
		then
			scoreThreaded=$( echo "$scoreThreaded + $media" | bc )
		else
			scoreFC=$( echo "$scoreFC + $media" | bc )
		fi
	else
		scoreThreaded=$( echo "$scoreThreaded + $media" | bc )
	fi
}
function Graphics(){
	echo "Executing MatrixBench v1.0"
	echo "Plotting graphics"

	mkdir -p Graphs
	
	#TODO
	#python3 plot.py
	#python3 plotBars.py
	#python3 plotSpeedup.py
	#python3 plotSpeedupBars.py
}
function LogAdjustments(){
	sed -i '1 i\average normalDist size threads version' execLog.txt
	folderDate=$(date +'%b%d%y_%H%M')
	mkdir -p Logs/"$folderDate"

	if [ $test -eq 0 ]
	then
		mv Graphs Logs/"$folderDate"/IntFullCore
		mv execLog.txt Logs/"$folderDate"/IntFullCore/logIntFullCore.txt
	fi
	if [ $test -eq 1 ]
	then
		mv Graphs Logs/"$folderDate"/IntThreaded
		mv execLog.txt Logs/"$folderDate"/IntThreaded/logIntThreaded.txt
	fi
	if [ $test -eq 2 ]
	then
		mv Graphs Logs/"$folderDate"/FloatMT
		mv execLog.txt Logs/"$folderDate"/FloatMT/logFloatFullCore.txt
	fi
	if [ $test -eq 3 ]
	then
		mv Graphs Logs/"$folderDate"/FloatST
		mv execLog.txt Logs/"$folderDate"/FloatST/logFloatThreaded.txt
	fi
}

clear
CleanFiles
rm -f temp.txt
rm -f execLog.txt

make CFLAGS="-g -O3"

#stock settings
t1=0
t2=3
v1=0
v2=3

clear
Start

ThreadsSettings
MatrixSettings

echo ""
echo "Press the Enter key to start!"
read z

msizelen=${#msizearray[@]}
mthreadslen=${#mthreadsarray[@]}

progress=$(echo "scale=2; 100.0 / $((($t2-$t1+1) * ($v2-$v1+1) * $mthreadslen))" | bc -l) #--> TEST CALC

progprint=$progress

clear
echo "Executing MatrixBench v1.0"
echo "Progress: 0%"
echo " "
echo "Press Ctrl+C to abort"

for (( test=$t1; test<=$t2; test++ )) #test0 = int close, test1 = int spread, test2 = float close, test3 = float spread
do
	scoreThreaded=0
	scoreFC=0

	for ((k=$mthreadslen-1;k>=0;k--))
	do
		for (( version=$v1; version<=$v2; version++ )) #full=0..3 (single thread, external lace, middle lace, inner lace)
		do
			for ((i=0;i<$msizelen;i++))
			do
				tam=${msizearray[$i]}
				threads=${mthreadsarray[$k]}
			
				for j in {0..29}
				do
					if [ $smt == "ht" ]
					then
						HtExe
					else
						NonHtExe
					fi
				done

				cat temp.txt | awk '{if ($1 == "t") print $2}' temp.txt >> timedata.txt

				PostProcess $tam $threads $version $test
				rm temp.txt
				rm timedata.txt
			done
			clear
			echo "Executing MatrixBench v1.0"
			echo "Progress: ${progprint}%"
			echo " "
			echo "Press Ctrl+C to abort"
			progprint=$( echo "$progprint + $progress" | bc )
		done
	done

	Graphics
	LogAdjustments

	#if  [ $smt = "ht" ]
	#then 
	#	scores[test]=$scoreThreaded
	#	test2=`echo "$test + 4" | bc`
	#	scores[$test2]=$scoreFC
	#else
	#	scores[test]=$scoreThreaded
	#fi

	#clear
done

CleanFiles
clear

echo "MatrixBench v1.0"
echo "Finished"
echo " "
echo " "
echo "The results can be found in the \"Logs\" Folder"
echo " "

if  [ $smt = "ht" ]
	then 
		echo "Score Threaded: $scoreThreaded"
		echo "Score Full Core: $scoreFC" #--> NOT WORKING!!!!!!
	else
		echo "Score Threaded: $scoreThreaded"
fi

echo " "
echo "Press [C] to compare to previous runs"
echo "IMPLEMENTAR"
