node("${NodeName}") {
	if(!params.containsKey("PlatformTarget")) {
		params.PlatformTarget = "x86"
	}
	if(!params.containsKey("MetaBranch")) {
		params.MetaBranch = "master"
	}
	
	// Add some informations about the build
	manager.addShortText("${params.BuildType}", "red", "white", "0px", "white")
	manager.addShortText("${NodeName}", "blue", "white", "0px", "white")
	manager.addShortText("${params.reposOrigin}", "green", "white", "0px", "white")
	manager.addShortText("${params.PlatformTarget}", "green", "white", "0px", "white")

	OpenViBEVersion = "x.x.x"
	
	def BuildOptions = [
		"Release" : "--release",
		"Debug" : "--debug"
		]
	def BuildOption = BuildOptions[BuildType]
	
	if ("${params.reposOrigin}" == "Mensia") {
		url_sdk = "git@github.com:mensiatech/certivibe.git"
		url_designer = "git@bitbucket.org:mensiatech/studio.git"
		url_test = "git@github.com:mensiatech/certivibe-test.git"
		cred_sdk = "ci_mensia_1"
		cred_designer = "ci_mensia_1"
		cred_test = "ci_mensia_2"
	} else {
		url_sdk = "https://gitlab.inria.fr/openvibe/sdk.git"
		url_designer = "https://gitlab.inria.fr/openvibe/designer.git"
		url_test = "git@github.com:mensiatech/certivibe-test.git"
		cred_sdk = ""
		cred_designer = ""
		cred_test = ""
	}
	
	if(isUnix()) {
		build_dir = "${WORKSPACE}/build"
		dist_dir = "${WORKSPACE}/dist"
		dependencies_dir = "/builds/dependencies"
		dependencies_base "/builds/dependencies"
	} else {
		build_dir = "${WORKSPACE}\\build"
		dist_dir = "${WORKSPACE}\\dist"
		if( "${params.PlatformTarget}" == "x64") {
			dependencies_dir = "c:\\builds\\dependencies_x64"		
		} else {
			dependencies_dir = "c:\\builds\\dependencies"
		}
		dependencies_base = "c:\\builds\\dependencies"
	}
	
	user_data_subdir = "openvibe-${OpenViBEVersion}"
	
	git url: 'https://gitlab.inria.fr/openvibe/meta.git', branch: "${params.MetaBranch}"
	shortCommitMeta = get_short_commit()
	manager.addShortText("Meta : ${params.MetaBranch} (${shortCommitMeta})", "black", "white", "0px", "white")

	dir("build") {
		deleteDir()
	}
    dir("dist") {
		deleteDir()
	}
	
	// In order to update the dependencies, we need to pull all repositories first
	stage('Checkout') {
		dir("sdk") { 
			git url: "${url_sdk}", branch: "${params.SDKBranch}", credentialsId: "${cred_sdk}"
			shortCommitSDK = get_short_commit()
			manager.addShortText("SDK : ${params.SDKBranch} (${shortCommitSDK})", "black", "white", "0px", "white")
		}
		
		dir("designer") {
			git url: "${url_designer}", branch: "${params.DesignerBranch}", credentialsId: "${cred_designer}"
			shortCommitDesigner = get_short_commit()
			manager.addShortText("Designer : ${params.DesignerBranch} (${shortCommitDesigner})", "black", "white", "0px", "white")	
		}
		
		dir("extras") {
			git url: 'https://gitlab.inria.fr/openvibe/extras.git', branch: "${params.ExtrasBranch}"
			shortCommitExtras = get_short_commit()
			manager.addShortText("Extras : ${params.ExtrasBranch} (${shortCommitExtras})", "black", "white", "0px", "white")	
		}
	}
	
	stage('Update dependencies') {
		if(isUnix()) {
			manager.addShortText("Not updating dependencies on Linux", "black", "white", "0px", "white")
		} else {
			bat "install_dependencies.cmd --dependencies-dir ${dependencies_base} --platform-target ${params.PlatformTarget}"
		}
	}
	
	stage('Build SDK') {
		dir("sdk") { 
			dir ("scripts") {
				if(isUnix()) {
					sh "./unix-build --build-type ${params.BuildType} --build-dir ${build_dir}/sdk-${params.BuildType} --install-dir ${dist_dir}/sdk-${params.BuildType} --dependencies-dir ${dependencies_dir} --userdata-subdir ${user_data_subdir} --build-unit --build-validation --test-data-dir ${dependencies_dir}/test-input"
				} else {
					bat "windows-build.cmd --no-pause ${BuildOption} --build-dir ${build_dir}\\sdk-${params.BuildType} --install-dir ${dist_dir}\\sdk-${params.BuildType}-${params.PlatformTarget} --dependencies-dir ${dependencies_dir} --userdata-subdir ${user_data_subdir} --platform-target ${params.PlatformTarget} --build-unit --build-validation --test-data-dir ${dependencies_dir}\\test-input"
				}
			}
		}
	}
	stage('Tests SDK') {
		dir ("build/sdk-${params.BuildType}") {
			dir("unit-test/Testing") {
				deleteDir()
			}
			dir("validation-test/Testing") {
				deleteDir()
			}
			if(isUnix()) {
				sh './ctest-launcher.sh -T Test ; exit 0'
			} else {
				withEnv(["PATH+OV=${dist_dir}\\sdk-${params.BuildType}-${params.PlatformTarget}\\bin"]) {
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

	stage('Build Designer') {
		dir("designer") {
			dir ("scripts") {
				if(isUnix()) {
					sh "./unix-build --build-type=${params.BuildType} --build-dir=${build_dir}/designer-${params.BuildType} --install-dir=${dist_dir}/designer-${params.BuildType} --sdk=${dist_dir}/sdk-${params.BuildType}"
				} else {
					bat "windows-build.cmd --no-pause ${BuildOption} --build-dir ${build_dir}\\designer-${params.BuildType} --install-dir ${dist_dir}\\designer-${params.BuildType}-${params.PlatformTarget} --sdk ${dist_dir}\\sdk-${params.BuildType}-${params.PlatformTarget} --dependencies-dir ${dependencies_dir} --userdata-subdir ${user_data_subdir} --platform-target ${params.PlatformTarget}"
				}	
			}
		}
	}
	stage('Build Extras') {
		dir("extras") {
			dir ("scripts") {
				if(isUnix()) {
					sh "./linux-build ${BuildOption} --build-dir ${build_dir}/extras-${params.BuildType} --install-dir ${dist_dir}/extras-${params.BuildType} --sdk ${dist_dir}/sdk-${params.BuildType} --designer ${dist_dir}/designer-${params.BuildType} --dependencies-dir ${dependencies_dir} --userdata-subdir ${user_data_subdir}"
				} else {
					bat "windows-build.cmd --no-pause ${BuildOption} --build-dir ${build_dir}\\extras-${params.BuildType} --install-dir ${dist_dir}\\extras-${params.BuildType}-${params.PlatformTarget} --sdk ${dist_dir}\\sdk-${params.BuildType}-${params.PlatformTarget} --designer ${dist_dir}\\designer-${params.BuildType}-${params.PlatformTarget} --dependencies-dir ${dependencies_dir} --userdata-subdir ${user_data_subdir} --platform-target ${params.PlatformTarget}"
				}
			}
		}
	}
	stage('Tests Extras') {
		dir ("build/extras-${params.BuildType}") {
			dir("Testing") {
				deleteDir()
			}
			if(isUnix()) {
				wrap([$class: 'Xvfb']) {
					sh "ctest -T Test ; exit 0"
				}
			} else {
				withEnv(["PATH+CTEST=${dependencies_dir}\\cmake\\bin", 
						 "PATH+OV=${dist_dir}\\extras-${params.BuildType}-${params.PlatformTarget}"]) {
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
					bat "makensis /DDEPENDENCIES_DIR=${dependencies_dir} /DOUTFILE=${WORKSPACE}\\package\\openvibe-${OpenViBEVersion}-${params.PlatformTarget}-setup.exe ${WORKSPACE}\\extras\\scripts\\windows-openvibe-x.x.x-setup-${params.PlatformTarget}.nsi"
				}
				withEnv(["PATH+CMAKE=${dependencies_dir}\\cmake\\bin"]) {
					bat "@cmake -E md5sum openvibe-${OpenViBEVersion}-${params.PlatformTarget}-setup.exe >openvibe-${OpenViBEVersion}-${params.PlatformTarget}-setup.md5"
				}
			}
		}
	}

	/*stage('Test one click scripts') {
		dir("build") {
			deleteDir()
		}
		if(isUnix()) {
			sh "./build.sh"
		} else {
			error("TODO")
		}
	}*/
}

def get_short_commit() {
	if(isUnix()) {
		sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()
	} else {
		bat(returnStdout: true, script: "@git log -n 1 --pretty=format:\'%%h\'").trim()
	}
}