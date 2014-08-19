<cfsilent>
<cfset variables.strField = "" />
<cfparam name="arguments.dataset.defaultid" default="" />
<cfsavecontent variable="variables.strField">
	<cfoutput>
	#variables.$.dspObject_Include(thefile='/formbuilder/fields/dsp_label.cfm',field=arguments.field,dataset=arguments.dataset)#</label>
	<select name="#arguments.field.name#"#variables.$.dspObject_Include(thefile='/formbuilder/fields/dsp_common.cfm',field=arguments.field,dataset=arguments.dataset)#
	</cfoutput>
</cfsavecontent>
<cfsavecontent variable="variables.strField">
	<cfoutput>
	#variables.strField#>
	<cfloop from="1" to="#ArrayLen(dataset.datarecordorder)#" index="variables.iiy">
		<cfset variables.record = arguments.dataset.datarecords[arguments.dataset.datarecordorder[variables.iiy]] />
		<option<cfif len(variables.record.value)> value="#variables.record.value#"</cfif><cfif variables.record.datarecordid eq arguments.dataset.defaultid> SELECTED</cfif>>#variables.record.label#</option>
	</cfloop>
	</select>
	</cfoutput>
</cfsavecontent>
</cfsilent>
<cfoutput>
#variables.strField#
</cfoutput>