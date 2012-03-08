<% import grails.persistence.Event %>
<% import org.codehaus.groovy.grails.plugins.PluginManagerHolder %>
<%=packageName%>
<!doctype html>
<html>
    <head>
        <meta name="layout" content="bootstrap">
        <g:set var="entityName" value="\${message(code: '${domainClass.propertyName}.label', default: '${className}')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
    </head>
    <body>
    <div class="row">
        <div class="span8">

            <g:if test="\${flash.message}">
                <div class="message" role="alert">\${flash.message}</div>
            </g:if>
            <g:hasErrors bean="\${${propertyName}}">
                <div class="errors" role="alert">
                    <g:renderErrors bean="\${${propertyName}}" as="list"/>
                </div>
            </g:hasErrors>

            <g:form action="save" id="editForm" class="form-horizontal" accept-charset="UTF-8" <%=multiPart ? ' enctype="multipart/form-data"' : '' %>>
                <input type="hidden" name="id" value="217">
                <fieldset>
                    <legend><g:message code="default.create.label" args="[entityName]"/></legend>

<%
    excludedProps = Event.allEvents.toList() << 'version' << 'id' << 'dateCreated' << 'lastUpdated'
    persistentPropNames = domainClass.persistentProperties*.name
    props = domainClass.properties.findAll { persistentPropNames.contains(it.name) && !excludedProps.contains(it.name) }
    Collections.sort(props, comparator.constructors[0].newInstance([domainClass] as Object[]))
    display = true
    required = false
    boolean hasHibernate = PluginManagerHolder.pluginManager.hasGrailsPlugin('hibernate')
    props.each { p ->
        if (hasHibernate) {
            cp = domainClass.constrainedProperties[p.name]
            display = (cp ? cp.display : true)
            required = (cp ? !(cp.propertyType in [boolean, Boolean]) && !cp.nullable : false)
        }
        if (display) {
%>
                    <div class="control-group">
                        <label class="control-label" for="${p.name}">
                            <g:message code="${domainClass.propertyName}.${p.name}.label" default="${p.naturalName}"/>
                        </label>
                        <div class="controls">${renderEditor(p)}</div>
                    </div>
<%
        }
    }
%>


                    <div class="control-group"><label class="control-label" for="codigo">C&oacute;digo


                            <input type="text" class="input-xlarge required" id="codigo" name="codigo" value="A002">

                            <p class="help-block"></p>

                    </div>

                    <div class="control-group">
                        <label class="control-label" for="codigo_paypal">C&oacute;digo Paypal</label>

                        <div class="controls">
                            <input type="text" class="input-xlarge required" id="codigo_paypal" name="codigo_paypal"
                                   value="A002_Bewitching_English">

                            <p class="help-block"></p>
                        </div>
                    </div>

                    <div class="control-group">
                        <label class="control-label" for="nombre">Nombre</label>

                        <div class="controls">
                            <input type="text" class="input-xlarge required" id="nombre" name="nombre"
                                   value="Bewitching">

                            <p class="help-block"></p>
                        </div>
                    </div>

                    <div class="control-group">
                        <label class="control-label" for="idioma">Idioma</label>

                        <div class="controls">
                            <select id="idioma" name="idioma">
                                <option value="1">Espa&ntilde;ol</option>
                                <option value="2" selected="selected">Ingl&eacute;s</option>
                            </select>
                        </div>
                    </div>

                    <div class="control-group">
                        <label class="control-label" for="gratis">Gratis</label>

                        <div class="controls">
                            <label class="checkbox">
                                <input type="checkbox" id="gratis" name="gratis" value="1">
                            </label>
                        </div>
                        /div>
                        <div class="control-group">
                            <label class="control-label" for="contenido">File input</label>

                        <div class="controls">
                                <input class="input-file" id="contenido" name="contenido" type="file">
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary"><g:message code="default.button.create.label" default="Create"/></button>
                            <button type="reset" class="btn">Cancel</button>
                        </div>
                </fieldset>
            </g:form>
        </div>
    </div>



%{--
    <div data-role="header" data-position="fixed">
        <h1></h1>

        <div data-role="navbar">
            <ul>
                <li><a data-icon="home" href="\${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
                <li><g:link data-icon="grid" data-ajax="false" action="list"><g:message code="default.list.label"
                                                                                        args="[entityName]"/></g:link></li>
            </ul>
        </div>
    </div>
--}%

    </body>
</html>
