<cfsilent>
<cfset variables.strField = "" />
<cfsavecontent variable="variables.strField">
	<cfoutput>
	#arguments.field.value#
	</cfoutput>
</cfsavecontent>
</cfsilent>
<cfoutput>#variables.strField#</cfoutput>