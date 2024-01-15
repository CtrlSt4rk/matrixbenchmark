#!/bin/bash

function getData(){
	arch="$(uname -m)"

	if [ "$arch" = arm64 ]
	then
		phyCores=$( echo "$(system_profiler SPHardwareDataType)" | sed -n 9p | cut -d ":" -f2 |  awk -F'[^0-9]+' '{ print $2 }' )
	fi

	if [ "$arch" = x86_64 ]
	then
		smt=$( cat /proc/cpuinfo | grep -o ht | uniq )
		cpu=$( lscpu | grep 'Model name' | cut -f 2 -d ":" | awk '{$1=$1}1' )
		# cpuCurrFreq=$( grep 'cpu MHz' /proc/cpuinfo | head -1 | awk -F: '{print $2/1024}' )
		cpuTurboFreq=$( neofetch | grep CPU | cut -d"@" -f 2 | sed -r 's/^.{1}//' )

		if  [ "$smt" = "ht" ]
		then 
			cores=$( grep -c ^processor /proc/cpuinfo )
			phyCores=$( grep ^cpu\\scores /proc/cpuinfo | uniq |  awk '{print $4}' )
		else
			cores=$( grep -c ^processor /proc/cpuinfo )
		fi

		avx512data=$(gcc -march=native -dM -E - < /dev/null | egrep "AVX512" | sort)
		if [[ -n "$avx512data" ]]
		then
			avx512=1
		else
			avx512=0
		fi
	fi

	if [ "$smt" != "ht" ]
	then
		cputhreads=$phyCores
	else
		cputhreads=$cores
	fi
 
	gpu=$( neofetch | grep GPU | cut -d":" -f 2 | sed -r 's/^.{5}//' )

	Settings
}

function Settings(){
	if [ "$arch" = x86_64 ]
	then
		smt="Enabled"
	else
		smt="Disabled"
	fi

	matrixSize="Medium"
	matrixSizeNum="4000"

	if [ avx512 = 1 ]
	then
		mode="AVX-512"
	else
		mode="CPU"
	fi
}

function Start(){
	clear
	echo "MatrixBench v2.0"
	echo " "

	if [ "$arch" = x86_64 ]
	then
		echo "$cpu/$cpuTurboFreq"
		if  [ $smt = "ht" ]
		then 
			echo "Arch: $arch"
			echo "CPU Cores: $phyCores physical / $cores logical"
		else
			echo "Arch: $arch"
			echo "CPU Cores: $cores physical / $cores logical"
		fi
	fi
	if [ "$arch" = arm64 ]
	then
		echo "Arch: $arch"
		echo "CPU: $phyCores cores" #change to $cores for biglittle and add a if for arm64
	fi
	echo "GPU: $gpu"

	echo ""
	echo "Current Settings:"
	echo "	Mode: $mode"
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

	case $matrixSize in
		Small) matrixSizeNum="1000";;
		Medium) matrixSizeNum="4000";;
		Large) matrixSizeNum="10000"
	esac

	Options
}

function Run(){
	clear
	echo "MatrixBench v2.0"
	echo ""
	echo "Running..."
	case $mode in
		CPU)
			ResultInt=$(./CPUInt.x $matrixSizeNum $cputhreads IPsetName 1.1.1.1 2>&1)
			ResultFloat=$(./CPUFloat.x $matrixSizeNum $cputhreads IPsetName 1.1.1.1 2>&1);;
		GPU)
			ResultInt=$(./GPUInt.x $matrixSizeNum IPsetName 1.1.1.1 2>&1)
			ResultFloat=$(./GPUFloat.x $matrixSizeNum IPsetName 1.1.1.1 2>&1);;
		AVX512)
			ResultInt=$(./AVX512Int.x $matrixSizeNum $cputhreads IPsetName 1.1.1.1 2>&1)
			ResultFloat=$(./AVX512Float.x $matrixSizeNum $cputhreads IPsetName 1.1.1.1 2>&1);;	
	esac
	Results
}

function Results(){
	clear
	echo "MatrixBench v2.0"
	echo ""
	echo "Settings used:"
	echo "Matrix size: $matrixSize ($matrixSizeNum rows/columns)"
	echo "CPU threads: $cputhreads"
	echo ""
	echo "Results:"
	echo "	Integer: $ResultInt""s"
	echo "	Float: $ResultFloat""s"
	echo ""
	echo "Benchmark successfully completed"
}

make clean && make
getData
Start