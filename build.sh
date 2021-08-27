#!/bin/bash

baseDir=$(dirname "$(readlink -f "$0")")
workDir=`pwd`
dependenciesDir="${workDir}/dependencies"
buildType=Release

while [[ $# -gt 0 ]]; do
	key="$1"
	case $key in
		-h | --help)
			usage
			exit
			;;
		-r | --release)
			buildType=Release
			;;
		-d | --debug)
			buildType=Debug
			;;
		*)
			echo "ERROR: Unknown parameter $key"
			exit 1
			;;
	esac
	shift # past argument or value
done

export PATH=${dependenciesDir}/cmake/bin:$PATH

generator=Ninja

mkdir ${workDir}/build/
cd ${workDir}/build/
cmake .. -G ${generator} -DCMAKE_BUILD_TYPE=${buildType}
ninja install

if [[ ! $? -eq 0 ]]; then
	echo "Error while building OpenViBE"
	exit 1
fi

echo ""
echo "Building process terminated successfully !"
echo ""

echo ""
echo "Install completed !"
echo ""