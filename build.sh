#!/bin/bash

baseDir=$(dirname "$(readlink -f "$0")")
work_dir=`pwd`
build_dir_base="${work_dir}/build"
dependencies_dir="${work_dir}/dependencies"
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

mkdir ${build_dir_base}
cd ${build_dir_base}
cmake ${baseDir} -G ${generator} -DCMAKE_BUILD_TYPE=${buildType}
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
