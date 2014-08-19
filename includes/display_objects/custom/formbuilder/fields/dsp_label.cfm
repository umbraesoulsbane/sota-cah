<cfset variables.cssAppend = "" />
<cfif structkeyexists(arguments.field,'cssclass') and len(arguments.field.cssclass) >
	<cfset variables.cssAppend = "class=""#arguments.field.cssclass#""" />
</cfif>


<cfif len(arguments.field.rblabel)>
	<cfoutput><label for="#arguments.field.name#" #variables.cssAppend#>#$.rbKey(arguments.field.rblabel)#: </cfoutput>
<cfelse>
	<cfoutput>
	<cfif arguments.field.fieldtype.fieldtype eq "radio">
		<p>#arguments.field.label#
	<cfelseif arguments.field.fieldtype.fieldtype eq "checkbox">
		<p>#arguments.field.label#
	<cfelseif arguments.field.fieldtype.fieldtype eq "hidden">
	<cfelse>
		<label for="#arguments.field.name#" #variables.cssAppend#>#arguments.field.label#:
	</cfif>
	</cfoutput>
</cfif>
