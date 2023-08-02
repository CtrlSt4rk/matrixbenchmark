#!/bin/bash

function getData(){
	smt=$( cat /proc/cpuinfo | grep -o ht | uniq )
	cpu=$( lscpu | grep 'Model name' | cut -f 2 -d ":" | awk '{$1=$1}1' )
	# cpuCurrFreq=$( grep 'cpu MHz' /proc/cpuinfo | head -1 | awk -F: '{print $2/1024}' )
	cpuTurboFreq=$( neofetch | grep CPU | cut -d"@" -f 2 | sed -r 's/^.{1}//' )

	if  [ $smt = "ht" ]
	then 
		cores=$( grep -c ^processor /proc/cpuinfo )
		phyCores=$( grep ^cpu\\scores /proc/cpuinfo | uniq |  awk '{print $4}' )
	else
		cores=$( grep -c ^processor /proc/cpuinfo )
	fi

	gpu=$( neofetch | grep GPU | cut -d":" -f 2 | sed -r 's/^.{5}//' )
	Settings
}

function Settings(){
	smt=Enabled
	matrixSize=Medium
	mode=CPU
}

function Start(){
	clear
	echo "MatrixBench v2.0"
	echo " "

	echo "$cpu/$cpuTurboFreq"
	if  [ $smt = "ht" ]
	then 
		echo "Cores: $phyCores physical / $cores logical"
	else
		echo "Cores: $cores physical / $cores logical"
	fi
	echo "$gpu"

	echo ""
	echo "Current Settings:"
	echo "	Mode: $option"
	echo "	SMT: $smt"
	echo "	Matrix Size: $matrixSize"
	echo ""
	echo "Options:"
	echo "	Information [I]"
	echo "	Options [O]"
	echo "	Run [R]"
	echo ""
	echo ""
	echo "Press Ctrl+C to abort"

	read -s -n 1 keybd
	case $keybd in
		i) Info;;
		I) Info;;
		o) Options;;
		O) Options;;
		r) Run;;
		R) Run;;
		*) Start
	esac
}

function Info(){
	clear
	echo "MatrixBench v2.0"
	echo " "
	echo "This software uses OpenMP to paralelize matrix multiplications on CPU/GPU."
	echo " "
	echo "The GCC v7 or higher and Python3 are needed to run the application."
	echo "Neofetch is used to get GPU name and CPU turbo clock"
	echo " "
	echo "This benchmark uses integer and floating point operations by default, as well as logical cores"
	echo " "
	echo "If the computer uses any form of Hyper-Threading, the software will"
	echo "execute a core+ht benchmark to stress the whole core structure,"
	echo "if not, only the standard benchmark will run."
	echo " "
	echo "For more info, visit the GitHub Repo: "
	echo " "
	echo " "
	echo "Press [Q] to go back"

	read -s -n 1 keybd
	case $keybd in
		q)  clear
			Start;;
		Q) 	clear
			Start;;
		*)	Info
	esac
}

function Options(){
	clear
	echo "MatrixBench v2.0"
	echo ""
	echo "Options:"
	echo ""
	echo "Current Settings:"
	echo "	Mode: $mode"
	echo "	SMT: $smt"
	echo "	Matrix Size: $matrixSize"
	echo ""
	echo "Mode:"
	echo "	CPU only [C]"
	echo "	CPU only w/AVX-512 [A] (TODO)"
	echo "	GPU only [G] (TODO)"
	echo "	CPU+GPU [H] (TODO)"
	echo ""
	echo "SMT:"
	echo "	Enable [Y]"
	echo "	Disable [N]"
	echo ""
	echo "Matrix Size:"
	echo "	Small (1000x1000) [S]"
	echo "	Small (4000x4000) [M]"
	echo "	Small (10000x10000) [L]"
	echo ""
	echo ""
	echo "Press [R] to run"
	echo "Press [Q] to go back"

	read -s -n 1 keybd
	case $keybd in
		c) mode="CPU";;
		C) mode="CPU";;
		a) mode="CPU+AVX512";;
		A) mode="CPU+AVX512";;
		g) mode="GPU";;
		G) mode="GPU";;
		h) mode="CPU+GPU";;
		H) mode="CPU+GPU";;
		y) smt=Enabled;;
		Y) smt=Enabled;;
		n) smt=Disabled;;
		N) smt=Disabled;;
		s) matrixSize=Small;;
		S) matrixSize=Small;;
		m) matrixSize=Medium;;
		M) matrixSize=Medium;;
		l) matrixSize=Large;;
		L) matrixSize=Large;;
		r) Run;;
		R) Run;;
		q) clear
		   Start;;
		Q) clear
		   Start;;
	esac

	if [ smt == "Disabled" ]
	then
		cputhreads=$phyCores
	else
		cputhreads=$cores
	fi
	case $matrixSize in
		Small) matrixSizeNum = 1000;;
		Medium) matrixSizeNum = 4000;;
		Large) matrixSizeNum = 10000
	esac				 

	Options
}

function Run(){
	clear
	echo "MatrixBench v2.0"
	echo ""
	echo "Running:"

	case $mode in
		CPU)
			ResultCPUInt= ./CPUInt.x $matrixSizeNum $cputhreads
			ResultCPUFloat= ./CPUFloat.x $matrixSizeNum $cputhreads;;
		GPU)
			ResultGPUInt= ./GPUInt.x $matrixSizeNum
			ResultGPUFloat= ./GPUFloat.x $matrixSizeNum;;
			
	esac
}

make clean && make
getData
Start