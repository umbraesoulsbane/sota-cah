<cfset variables.strField = "" />
<cfsilent>
<cfsavecontent variable="variables.strField">
	<cfoutput>
	<cfif request.fieldsetopen eq true><cfif arguments.field.name neq "right"></div></cfif></div><cfset request.fieldsetopen = false /></cfif>

	<cfif arguments.field.name neq "right">
		<div class="mura-formbuilder-tbl set-#arguments.field.name#">
	</cfif>
			<!--- <div class="mura-formbuilder-legend">#arguments.field.label#</div> --->
			<div class="mura-formbuilder-data data-#arguments.field.name#">
	</cfoutput>
</cfsavecontent>

<!--- note that fieldsets are open --->
<cfset request.fieldsetopen = true />
</cfsilent>
<cfoutput>
#variables.strField#
</cfoutput>