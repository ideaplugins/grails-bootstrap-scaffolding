grails.project.dependency.resolution = {
    inherits('global')
    log 'warn'
    repositories {
        grailsPlugins()
        grailsHome()
        grailsCentral()
    }
	plugins {
		runtime ':resources:1.1.6'
		runtime ':zipped-resources:1.0'
		runtime ':cached-resources:1.0'
		runtime ':cache-headers:1.1.5'
		runtime ':jquery:1.7.1'
		runtime ':jquery-ui:1.8.15'
		runtime ':twitter-bootstrap:2.0.1.21'
	}
}
