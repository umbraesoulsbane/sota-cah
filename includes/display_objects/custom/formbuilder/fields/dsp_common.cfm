<cfsilent>
<cfset variables.strField = "" />
<cfif structkeyexists(arguments.field,'size') and len(arguments.field.size)>
	<cfif arguments.field.fieldtype.fieldtype eq "textarea">
		<cfset variables.strField = strField & ' rows="#arguments.field.size#"' />
	<cfelse>
		<cfset variables.strField = strField & ' size="#arguments.field.size#"' />
	</cfif>
</cfif>
<cfif structkeyexists(arguments.field,'placeholder') and len(arguments.field.placeholder)>
	<cfset variables.strField = strField & ' placeholder="#arguments.field.placeholder#"' />
</cfif>
<cfif structkeyexists(arguments.field,'maxlength') and len(arguments.field.maxlength)>
	<cfset variables.strField = variables.strField & ' maxlength="#arguments.field.maxlength#"' />
<cfelseif structkeyexists(arguments.field,'size') and len(arguments.field.size) and arguments.field.fieldtype.fieldtype neq "textarea">
	<cfset variables.strField = variables.strField & ' maxlength="#arguments.field.size#"' />
</cfif>
<cfif structkeyexists(arguments.field,'cols') and len(arguments.field.cols)>
	<cfset variables.strField = variables.strField & ' cols="#arguments.field.cols#"' />
</cfif>
<cfif structkeyexists(arguments.field,'cssid') and len(arguments.field.cssid)>
	<cfset variables.strField = variables.strField & ' id="#arguments.field.cssid#"' />
<cfelse>
	<cfset variables.strField = variables.strField & ' id="#arguments.field.fieldid#"' />
</cfif>
<cfif structkeyexists(arguments.field,'cssclass') and len(arguments.field.cssclass) >
	<cfset variables.strField = variables.strField & ' class="#arguments.field.cssclass#"' />
</cfif>
<cfif len(arguments.field.validatemessage)>
	<cfset variables.strField = variables.strField & ' data-message="#replace(arguments.field.validatemessage,"""","&quot;","all")#"' />
</cfif>

<cfif arguments.field.isrequired or len(arguments.field.validatetype) >
	<cfset variables.strField = variables.strField & " onclick=""muraFormbuilderClearAlert('#arguments.field.fieldid#');"" onblur=""muraFormbuilderClearAlert('#arguments.field.fieldid#');"" title=""Please fill out this field.""" />	
</cfif>
<cfif arguments.field.isrequired>
	<cfset variables.strField = variables.strField & ' data-required="true" required="required"' />
</cfif>
<cfif len(arguments.field.validatetype)>
	<cfif arguments.field.validatetype eq "regex" and len(arguments.field.validateregex)>
		<cfset variables.strField = variables.strField & ' data-validate="#arguments.field.validatetype#" data-regex="#arguments.field.validateregex#"' />
	<cfelse>
		<cfset variables.strField = variables.strField & ' data-validate="#arguments.field.validatetype#"' />
	</cfif>
</cfif>
<cfif len(arguments.field.remoteid)>
	<cfset variables.strField = variables.strField & ' data-remoteid="#arguments.field.remoteid#"' />
</cfif>
</cfsilent>
<cfoutput>#variables.strField#</cfoutput>