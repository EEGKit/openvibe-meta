#!/bin/bash

base_dir=$(dirname "$(readlink -f "$0")")
work_dir=`pwd`
dependencies_dir="${work_dir}/dependencies"

if [[ ! -z ${dependencies_dir} ]]
then
  source ${base_dir}/sdk/scripts/unix-init-env.sh --dependencies-dir ${dependencies_dir}
else
  echo "dependencies_dir not set: not initialisaing environment"
fi

generator=Ninja

mkdir ${work_dir}/build/
cd ${work_dir}/build/
cmake .. -G ${generator} -DCMAKE_BUILD_TYPE=Release
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