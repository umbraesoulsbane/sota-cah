<cfset variables.strField = "" />
<cfsilent>
<cfsavecontent variable="variables.strField">
	<cfoutput>
	#variables.$.dspObject_Include(thefile='/formbuilder/fields/dsp_label.cfm',field=arguments.field,dataset=arguments.dataset)#</label>
	<textarea name="#arguments.field.name#"
	#variables.$.dspObject_Include(thefile='/formbuilder/fields/dsp_common.cfm',field=arguments.field,dataset=arguments.dataset)#
	#variables.strField#>#arguments.field.value#</textarea>
	</cfoutput>
</cfsavecontent>
</cfsilent>
<cfoutput>#variables.strField#</cfoutput>