<cfsilent>
<cfset variables.strField = "" />
<cfset variables.cssAppend = "" />
<cfif structkeyexists(arguments.field,'cssclass') and len(arguments.field.cssclass) >
	<cfset variables.cssAppend = "class=""#arguments.field.cssclass#""" />
</cfif>
</cfsilent>
<cfsavecontent variable="variables.strField">
	<cfoutput>
	#$.dspObject_Include(thefile='/formbuilder/fields/dsp_label.cfm',field=arguments.field,dataset=arguments.dataset)#</p>
	<div #variables.cssAppend#>
	<cfset doSelect = true >
	<cfloop from="1" to="#ArrayLen(arguments.dataset.datarecordorder)#" index="variables.iiy">
		<cfset variables.record = arguments.dataset.datarecords[dataset.datarecordorder[variables.iiy]] />
		<label for="#variables.record.datarecordid#"><input name="#arguments.field.name#" id="#record.datarecordid#" type="radio"<cfif variables.record.isselected eq 1> CHECKED<cfset doSelect = false ></cfif> value="#variables.record.value#">#variables.record.label#</label>
	</cfloop>
	</div>
	<cfif doSelect >
		<script>
		$( document ).ready(function() {
    		$("input[id=#arguments.dataset.datarecordorder[1]#]").attr("checked", true);
		});
		</script>
	</cfif>
	</cfoutput>
</cfsavecontent>
<cfoutput>
#variables.strField#
</cfoutput>