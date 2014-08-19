<cfsilent>
<cfset variables.strField = "" />	
<cfsavecontent variable="variables.strField">
	<cfoutput>
	#variables.$.dspObject_Include(thefile='/formbuilder/fields/dsp_label.cfm',field=arguments.field,dataset=arguments.dataset)#
	</label><input type="text" name="#arguments.field.name#" value="#arguments.field.value#"#variables.$.dspObject_Include(thefile='/formbuilder/fields/dsp_common.cfm',field=arguments.field,dataset=arguments.dataset)#</cfoutput>
</cfsavecontent>
</cfsilent>
<cfoutput>
#variables.strField# />
</cfoutput>