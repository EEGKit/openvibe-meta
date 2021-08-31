# |OpenViBE meta repository| |README|  
[![Website](https://img.shields.io/badge/Web-Website-informational)](http://openvibe.inria.fr/)
[![Doxygen Documentation](https://img.shields.io/badge/Doc-Doxygen%20Documentation-informational)](http://openvibe.inria.fr/documentation/latest/)
[![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)

|Build Status :|   |
|:-------------|:-:|
|Ubuntu 18.04 x64|[![Build Status](https://ci.inria.fr/openvibe/buildStatus/icon?job=OV-Nightly-Ubuntu18.04&style=plastic)](https://ci.inria.fr/openvibe/job/OV-Nightly-Ubuntu18.04/)|
|Fedora 31 x64|[![Build Status](https://ci.inria.fr/openvibe/buildStatus/icon?job=OV-Nightly-Fedora31&style=plastic)](https://ci.inria.fr/openvibe/job/OV-Nightly-Fedora31/)|
|Windows 10 x64|[![Build Status](https://ci.inria.fr/openvibe/buildStatus/icon?job=OV-Nightly-Win10-x64&style=plastic)](https://https://ci.inria.fr/openvibe/job/OV-Nightly-Win10-x64/)|
|Windows 10 x86|[![Build Status](https://ci.inria.fr/openvibe/buildStatus/icon?job=OV-Nightly-Win10-x86&style=plastic)](https://ci.inria.fr/openvibe/job/OV-Nightly-Win10-x86/)|

OpenViBE project is now divided into 3 parts :

- SDK, that contains the certifiable core and plugins of OpenViBE
- Designer, the graphical interface for OpenViBE
- Extras, for community plugins and contributions

The current repository, OpenViBE-meta, exist to bring the three repositories together and build the project.

To build OpenViBE, follow these instructions :

- Pull this repository
- Pull its submodules
- Install the dependencies
- Build the project

## Pulling this repository

Run the following command:

`git pull git@gitlab.inria.fr:openvibe/meta.git`

or with any GUI for git, like GitKraken.

## Pulling the submodules

Pull the sdk, designer and extras repositories with the following:

`git submodule update --init --recursive`

## Installing the dependencies

### Windows

Run the following command:

`> .\install_dependencies.cmd`

Dependencies will be installed in a *dependencies* folder at the root of the project.

### Linux

Run the following command:

`$ ./install_dependencies.sh`

Dependencies will be installed in a *dependencies* folder at the root of the project.<br>
Some will be installed on the system.


## Building the project

### Windows

Execute the following command:

`> .\build.cmd`

You will require Visual Studio 2013 (Professional or Community editions)

Applications are installed in the *dist* folder at the root, and are launchable using their launch script: __*openvibe-[application-name].cmd*__

#### Generate Visual Studio Solution

To generate the visual studio solution of the project, run the following command:

`> .\build.cmd --vsbuild`

The solution will be in the folder *build-vs*<br>
The solution allows you to view/edit code in Visual Studio, but not to compile the project for the moment.

### Linux

Execute the following command:

`$ ./build.sh`

Applications are installed in the *dist* folder at the root, and are launchable using their launch script: __*openvibe-[application-name].sh*__


## Updating the repository
You can update the whole directory (including submodules) with :

```bash
git pull
git submodule sync --recursive
git submodule update --init --recursive
```

Aliases can be created to ease the global update process :
`git config --global alias.spull '!git pull && git submodule sync --recursive && git submodule update --init --recursive'`

