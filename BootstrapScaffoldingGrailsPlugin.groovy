class BootstrapScaffoldingGrailsPlugin {

    def version = '0.1'

    def grailsVersion = '2.0.0 > *'

    def dependsOn = [:]

    def pluginExcludes = []

    def author = 'Alejandro Gómez'

    def authorEmail = "ideaplugins@gmail.com"

    def title = 'Bootstrap Scaffolding'

    def description = '''\\
This plugin provides templates that can be used during the scaffolding process, it relies on the Bootstrap components.
'''

    //TODO
    def documentation = "http://grails.org/plugin/xxx"

    def doWithWebDescriptor = { xml ->
    }

    def doWithSpring = {
    }

    def doWithDynamicMethods = { ctx ->
    }

    def doWithApplicationContext = { applicationContext ->
    }

    def onChange = { event ->
    }

    def onConfigChange = { event ->
    }
}
