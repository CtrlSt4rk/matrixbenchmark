#!/bin/bash

clear
echo "Choose an option for a terminal install of the following packages:"
echo "- neofetch"
echo "- clang"
echo ""
echo "[0] apt"
echo "[1] dnf"
echo "[2] brew"
echo ""
echo "Press any other key to quit"

read -s -n 1 keybd
case $keybd in
		0) apt;;
		1) dnf;;
		2) brew;;
	esac

function apt(){
    sudo apt update
    sudo apt install neofetch
    sudo apt install clang
}

function dnf(){
    sudo dnf update
    sudo dnf install neofetch
    sudo dnf install clang
}

function brew(){
    brew update
    brew install neofetch
    #clang already preinstalled (Sonoma+)
}