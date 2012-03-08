<%
    if (property.type == Boolean || property.type == boolean)
        out << renderBooleanEditor(domainClass, property)
    else if (Number.isAssignableFrom(property.type) || (property.type.isPrimitive() && property.type != boolean))
        out << renderNumberEditor(domainClass, property)
    else if (property.type == String)
        out << renderStringEditor(domainClass, property)
    else if (property.type == Date || property.type == java.sql.Date || property.type == java.sql.Time || property.type == Calendar)
        out << renderDateEditor(domainClass, property)
    else if (property.type == URL)
        out << renderStringEditor(domainClass, property)
    else if (property.isEnum())
        out << renderEnumEditor(domainClass, property)
    else if (property.type == TimeZone)
        out << renderSelectTypeEditor("timeZone", domainClass, property)
    else if (property.type == Locale)
        out << renderSelectTypeEditor("locale", domainClass, property)
    else if (property.type == Currency)
        out << renderSelectTypeEditor("currency", domainClass, property)
    else if (property.type == ([] as Byte[]).class) //TODO: Bug in groovy means i have to do this :(
        out << renderByteArrayEditor(domainClass, property)
    else if (property.type == ([] as byte[]).class) //TODO: Bug in groovy means i have to do this :(
        out << renderByteArrayEditor(domainClass, property)
    else if (property.manyToOne || property.oneToOne)
        out << renderManyToOne(domainClass, property)
    else if ((property.oneToMany && !property.bidirectional) || (property.manyToMany && property.isOwningSide()))
        out << renderManyToMany(domainClass, property)
    else if (property.oneToMany)
        out << renderOneToMany(domainClass, property)

    private renderEnumEditor(domainClass, property) {
        return "<g:select name=\"${property.name}\" from=\"\${${property.type.name}?.values()}\" keys=\"\${${property.type.name}?.values()*.name()}\" value=\"\${${domainInstance}?.${property.name}?.name()}\" ${renderNoSelection(property)} />"
    }

    private renderStringEditor(domainClass, property) {
        if (!cp) {
            return "<g:textField name=\"${property.name}\" value=\"\${${domainInstance}?.${property.name}}\" />"
        } else {
            if ("textarea" == cp.widget || (cp.maxSize > 250 && !cp.password && !cp.inList)) {
                return "<g:textArea name=\"${property.name}\" cols=\"40\" rows=\"5\" value=\"\${${domainInstance}?.${property.name}}\" />"
            } else if (cp.inList) {
                return "<g:select name=\"${property.name}\" from=\"\${${domainInstance}.constraints.${property.name}.inList}\" value=\"\${${domainInstance}?.${property.name}}\" valueMessagePrefix=\"${domainClass.propertyName}.${property?.name}\" ${renderNoSelection(property)} />"
            } else {
                def sb = new StringBuffer("")
                if (cp.password) {
                    sb << "<g:field type=\"password\" "
                } else if (cp.url) {
                    sb << "<g:field type=\"url\" "
                } else if (cp.email) {
                    sb << "<g:field type=\"email\" "
                } else {
                    sb << "<g:textField "
                }
                sb << "name=\"${property.name}\" "
                if (cp.maxSize) sb << "maxlength=\"${cp.maxSize}\" "
                if (!cp.editable) sb << "readonly=\"readonly\" "
                if (!cp.nullable && !cp.blank) sb << "required=\"required\" "
                sb << "value=\"\${${domainInstance}?.${property.name}}\" />"
                return sb.toString()
            }
        }
    }

    private renderByteArrayEditor(domainClass, property) {
        return "<input type=\"file\" id=\"${property.name}\" name=\"${property.name}\" />"
    }

    private renderManyToOne(domainClass, property) {
        if (property.association) {
            return "<g:select name=\"${property.name}.id\" from=\"\${${property.type.name}.list()}\" optionKey=\"id\" value=\"\${${domainInstance}?.${property.name}?.id}\" ${renderNoSelection(property)} />"
        }
    }

    private renderManyToMany(domainClass, property) {
        return "<g:select name=\"${property.name}\" from=\"\${${property.referencedDomainClass.fullName}.list()}\" multiple=\"multiple\" optionKey=\"id\" size=\"5\" value=\"\${${domainInstance}?.${property.name}*.id}\" />"
    }

    private renderOneToMany(domainClass, property) {
        def sw = new StringWriter()
        def pw = new PrintWriter(sw)
        pw.println()
        pw.println "<ul>"
        pw.println "<g:each in=\"\${${domainInstance}?.${property.name}?}\" var=\"${property.name[0]}\">"
        pw.println "    <li><g:link controller=\"${property.referencedDomainClass.propertyName}\" action=\"show\" id=\"\${${property.name[0]}.id}\">\${${property.name[0]}?.encodeAsHTML()}</g:link></li>"
        pw.println "</g:each>"
        pw.println "</ul>"
        pw.println "<g:link controller=\"${property.referencedDomainClass.propertyName}\" action=\"create\" params=\"['${domainClass.propertyName}.id': ${domainInstance}?.id]\">\${message(code: 'default.add.label', args: [message(code: '${property.referencedDomainClass.propertyName}.label', default: '${property.referencedDomainClass.shortName}')])}</g:link>"
        return sw.toString()
    }

    private renderNumberEditor(domainClass, property) {
        if (!cp) {
            if (property.type == Byte) {
                return "<g:select name=\"${property.name}\" from=\"\${-128..127}\" class=\"range\" value=\"\${fieldValue(bean: ${domainInstance}, field: '${property.name}')}\" />"
            } else {
                return "<g:field type=\"number\" name=\"${property.name}\" value=\"\${fieldValue(bean: ${domainInstance}, field: '${property.name}')}\" />"
            }
        } else {
            if (cp.range) {
                return "<g:select name=\"${property.name}\" from=\"\${${cp.range.from}..${cp.range.to}}\" class=\"range\" value=\"\${fieldValue(bean: ${domainInstance}, field: '${property.name}')}\" ${renderNoSelection(property)} />"
            } else if (cp.inList) {
                return "<g:select name=\"${property.name}\" from=\"\${${domainInstance}.constraints.${property.name}.inList}\" value=\"\${fieldValue(bean: ${domainInstance}, field: '${property.name}')}\" valueMessagePrefix=\"${domainClass.propertyName}.${property?.name}\" ${renderNoSelection(property)} />"
            } else {
                return "<g:field type=\"number\" name=\"${property.name}\" value=\"\${fieldValue(bean: ${domainInstance}, field: '${property.name}')}\" />"
            }
        }
    }

    private renderBooleanEditor(domainClass, property) {
        if (!cp) {
            return "<g:checkBox name=\"${property.name}\" value=\"\${${domainInstance}?.${property.name}}\" />"
        } else {
            def sb = new StringBuffer("<g:checkBox name=\"${property.name}\" ")
            if (cp.widget) sb << "widget=\"${cp.widget}\" ";
            cp.attributes.each { k, v ->
                sb << "${k}=\"${v}\" "
            }
            sb << "value=\"\${${domainInstance}?.${property.name}}\" />"
            return sb.toString()
        }
    }

    private renderDateEditor(domainClass, property) {
        def precision = (property.type == Date || property.type == java.sql.Date || property.type == Calendar) ? "day" : "minute";
        if (!cp) {
            return "<g:datePicker name=\"${property.name}\" precision=\"${precision}\" value=\"\${${domainInstance}?.${property.name}}\" />"
        } else {
            if (!cp.editable) {
                return "\${${domainInstance}?.${property.name}?.toString()}"
            } else {
                def sb = new StringBuffer("<g:datePicker name=\"${property.name}\" ")
                if (cp.format) sb << "format=\"${cp.format}\" "
                if (cp.widget) sb << "widget=\"${cp.widget}\" "
                cp.attributes.each { k, v ->
                    sb << "${k}=\"${v}\" "
                }
                sb << "precision=\"${precision}\" value=\"\${${domainInstance}?.${property.name}}\" ${renderNoSelection(property)} />"
                return sb.toString()
            }
        }
    }

    private renderSelectTypeEditor(type, domainClass, property) {
        if (!cp) {
            return "<g:${type}Select name=\"${property.name}\" value=\"\${${domainInstance}?.${property.name}}\" />"
        } else {
            def sb = new StringBuffer("<g:${type}Select name=\"${property.name}\" ")
            if (cp.widget) sb << "widget=\"${cp.widget}\" ";
            cp.attributes.each { k, v ->
                sb << "${k}=\"${v}\" "
            }
            sb << "value=\"\${${domainInstance}?.${property.name}}\" ${renderNoSelection(property)} />"
            return sb.toString()
        }
    }

    private renderNoSelection(property) {
        if (property.optional) {
            if (property.manyToOne || property.oneToOne) {
                return "noSelection=\"['null': '']\""
            } else if (property.type == Date || property.type == java.sql.Date || property.type == java.sql.Time || property.type == Calendar) {
                return "default=\"none\" noSelection=\"['': '']\""
            } else {
                return "noSelection=\"['': '']\""
            }
        }
        return ""
    }
%>