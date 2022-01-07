node("${NodeName}") {
	def PlatformTarget = params.containsKey("PlatformTarget") ? params.PlatformTarget : "x64"
	def MetaBranch = params.containsKey("MetaBranch") ? params.MetaBranch : "master"
	
	// Add some informations about the build
	manager.addShortText("${params.BuildType}", "red", "white", "0px", "white")
	manager.addShortText("${NodeName}", "blue", "white", "0px", "white")
	manager.addShortText("${PlatformTarget}", "green", "white", "0px", "white")

	OpenViBEVersion = "x.x.x"
	
	def BuildOptions = [
		"Release" : "--release",
		"Debug" : "--debug"
	]
	def BuildOption = BuildOptions[BuildType]
	

	url_sdk = "https://gitlab.inria.fr/openvibe/sdk.git"
	url_designer = "https://gitlab.inria.fr/openvibe/designer.git"
	
	if(isUnix()) {
		build_dir = "${WORKSPACE}/build"
		dist_dir = "${WORKSPACE}/dist"
		dependencies_dir = "${WORKSPACE}/dependencies"
		dependencies_base = "${WORKSPACE}/dependencies"
	} else {
		build_dir = "${WORKSPACE}\\build\\${PlatformTarget}"
		dist_dir = "${WORKSPACE}\\dist"
		if( "${PlatformTarget}" == "x64") {
			dependencies_dir = "${WORKSPACE}\\dependencies_x64"
		} else {
			dependencies_dir = "${WORKSPACE}\\dependencies"
		}
		dependencies_base = "${WORKSPACE}\\dependencies"
	}
	
	user_data_subdir = "openvibe-${OpenViBEVersion}"
	
	git url: 'https://gitlab.inria.fr/openvibe/meta.git', branch: "${MetaBranch}"
	shortCommitMeta = get_short_commit()
	manager.addShortText("Meta : ${MetaBranch} (${shortCommitMeta})", "black", "white", "0px", "white")

    dir("${dependencies_dir}") {
        deleteDir()
    }
	dir("build") {
		deleteDir()
	}
    dir("dist") {
		deleteDir()
	}
	
	// In order to update the dependencies, we need to pull all repositories first
	stage('Checkout') {
		dir("sdk") { 
			git url: "${url_sdk}", branch: "${params.SDKBranch}"
			shortCommitSDK = get_short_commit()
			manager.addShortText("SDK : ${params.SDKBranch} (${shortCommitSDK})", "black", "white", "0px", "white")
		}
		
		dir("designer") {
			git url: "${url_designer}", branch: "${params.DesignerBranch}"
			shortCommitDesigner = get_short_commit()
			manager.addShortText("Designer : ${params.DesignerBranch} (${shortCommitDesigner})", "black", "white", "0px", "white")	
		}
		
		dir("extras") {
			git url: 'https://gitlab.inria.fr/openvibe/extras.git', branch: "${params.ExtrasBranch}"
			shortCommitExtras = get_short_commit()
			manager.addShortText("Extras : ${params.ExtrasBranch} (${shortCommitExtras})", "black", "white", "0px", "white")
			if(isUnix()) {
				sh "git submodule update --init --recursive"
			} else {
				bat "git submodule update --init --recursive"
			}
		}
	}
	
	stage('Update dependencies') {
		if(isUnix()) {
			sh "./install_dependencies.sh"
		} else {
			bat "install_dependencies.cmd --platform-target ${PlatformTarget}"
		}
	}
	
	stage('Build') {
		if(isUnix()) {
		    sh "./build.sh ${BuildOption}"
		} else {
			bat "build.cmd ${BuildOption} --platform-target ${PlatformTarget}"
		}
	}

	stage('Tests SDK') {
		dir ("${build_dir}/sdk") {
			dir("unit-test/Testing") {
				deleteDir()
			}
			dir("validation-test/Testing") {
				deleteDir()
			}
			if(isUnix()) {
				sh './ctest-launcher.sh -T Test ; exit 0'
			} else {
				withEnv(["PATH+OV=${dist_dir}\\sdk-${params.BuildType}-${PlatformTarget}\\bin"]) {
					bat 'ctest-launcher.cmd -T Test -E uoTimeTest ; exit 0'
				}
			}
			step([$class: 'XUnitBuilder',
				thresholds: [[$class: 'FailedThreshold', unstableThreshold: '0']],
				tools: [[$class: 'CTestType', pattern: "unit-test/Testing/*/Test.xml"],
						[$class: 'CTestType', pattern: "validation-test/Testing/*/Test.xml"],]
			])
		}
	}

	stage('Tests Extras') {
		dir ("${build_dir}/extras") {
			dir("Testing") {
				deleteDir()
			}
			if(isUnix()) {
				wrap([$class: 'Xvfb']) {
					sh "ctest -T Test ; exit 0"
				}
			} else {
				withEnv(["PATH+CTEST=${dependencies_dir}\\cmake\\bin", 
						 "PATH+OV=${dist_dir}\\extras-${params.BuildType}-${PlatformTarget}"]) {
					bat "ctest -T Test ; exit 0"
				}
			}
			step([$class: 'XUnitBuilder',
				thresholds: [[$class: 'FailedThreshold', unstableThreshold: '0']],
				tools: [[$class: 'CTestType', pattern: "Testing/*/Test.xml"],]])
		}
	}

	stage('Create Archive') {
		if(isUnix()) {
			dir("package") {
				deleteDir()
				sh "tar --owner 0 --group 0 --transform s,^\\.,openvibe-${OpenViBEVersion}-src, --exclude \".git*\" --exclude build --exclude dependencies --exclude dist --exclude  scripts/*.exe --exclude package --exclude \"*@tmp\" -cJvf openvibe-${OpenViBEVersion}-src.tar.xz ${WORKSPACE}"
				sh "md5sum openvibe-${OpenViBEVersion}-src.tar.xz >openvibe-${OpenViBEVersion}-src.md5"
			}
		} else {
			dir("package") {
				deleteDir()
				withEnv(["PATH+NSIS=${dependencies_dir}\\nsis_log_zip_access"]) {
					bat """
                        for %%I in ("${build_dir}\\extras\\scripts\\windows-openvibe-*-setup-${PlatformTarget}.nsi") do set "nsiScript=%%I"
                    	makensis /DDEPENDENCIES_DIR=${dependencies_dir} /DOUTFILE=${WORKSPACE}\\package\\openvibe-${OpenViBEVersion}-${PlatformTarget}-setup.exe %nsiScript%
                    """
				}
				withEnv(["PATH+CMAKE=${dependencies_dir}\\cmake\\bin"]) {
					bat "@cmake -E md5sum openvibe-${OpenViBEVersion}-${PlatformTarget}-setup.exe >openvibe-${OpenViBEVersion}-${PlatformTarget}-setup.md5"
				}
			}
		}
	}
}

def get_short_commit() {
	if(isUnix()) {
		sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()
	} else {
		bat(returnStdout: true, script: "@git log -n 1 --pretty=format:\'%%h\'").trim()
	}
}
