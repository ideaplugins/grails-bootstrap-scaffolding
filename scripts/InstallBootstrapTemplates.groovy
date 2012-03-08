includeTargets << grailsScript("_GrailsInit")

target(installBootstrapTemplates: "Installs the Bootstrap scaffolding templates") {
	depends(checkVersion, parseArguments)

	sourceDir = "${bootstrapScaffoldingPluginDir}/src/templates"
	targetDir = "${basedir}/src/templates"
	overwrite = false

	if (new File(targetDir).exists()) {
		if (!isInteractive || confirmInput("Overwrite existing templates?", "overwrite.templates")) {
			overwrite = true
		}
	} else {
		ant.mkdir(dir: targetDir)
	}

	ant.copy(todir: "$targetDir/scaffolding", overwrite: overwrite) {
		fileset dir: "$sourceDir/scaffolding"
	}

	event "StatusUpdate", ["bootstrap templates installed successfully"]
}

setDefaultTarget installBootstrapTemplates
