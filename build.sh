#!/bin/bash

baseDir=$(dirname "$(readlink -f "$0")")
workDir=`pwd`
buildDirBase="${workDir}/build"
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

mkdir ${buildDirBase}
cd ${buildDirBase}
cmake ${baseDir} -G ${generator} -DCMAKE_BUILD_TYPE=${buildType} -DCMAKE_INSTALL_PREFIX=${workDir}/dist/${buildType}
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
