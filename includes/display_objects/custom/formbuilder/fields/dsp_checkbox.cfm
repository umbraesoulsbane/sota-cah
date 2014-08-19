<cfsilent>
<cfset variables.mmRBFstrField = "" />
<cfset variables.cssAppend = "" />
<cfset variables.cssAppend = "class=""#arguments.field.cssclass#""" />
<cfif structkeyexists(arguments.field,'cssclass') and len(arguments.field.cssclass) >
	<cfset variables.cssAppend = "class=""#arguments.field.cssclass#""" />
</cfif>
</cfsilent>
<cfsavecontent variable="variables.strField">
	<cfoutput>#variables.$.dspObject_Include(thefile='/formbuilder/fields/dsp_label.cfm',field=arguments.field,dataset=arguments.dataset)#</p>
	<div #variables.cssAppend#>
	<cfloop from="1" to="#ArrayLen(arguments.dataset.datarecordorder)#" index="variables.iiy">
		<cfset variables.record = arguments.dataset.datarecords[arguments.dataset.datarecordorder[variables.iiy]] />
		<label for="#variables.record.datarecordid#"><input id="#variables.record.datarecordid#" name="#variables.field.name#" type="checkbox"<cfif variables.record.isselected eq 1> CHECKED</cfif> value="#variables.record.value#">#variables.record.label#</label>
	</cfloop>
	</div>
	</cfoutput>
</cfsavecontent>
<cfoutput>
#variables.strField#
</cfoutput>