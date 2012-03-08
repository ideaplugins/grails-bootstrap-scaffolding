def dev = grails.util.GrailsUtil.isDevelopmentEnv()

modules = {

    'jquery-validate' {
        dependsOn 'jquery'
        resource id: 'js', url: [dir: 'js/jquery.validate', file: "jquery.validate${dev ? '' : '.min'}.js"], nominify: !dev
        resource id: 'additional', url: [dir: 'js/jquery.validate', file: "additional-methods${dev ? '' : '.min'}.js"], nominify: !dev
    }
}
