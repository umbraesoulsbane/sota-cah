<cfsilent>
<cfset variables.fbManager = $.getBean('formBuilderManager') />

<cfset variables.frmID			= "frm" & replace(arguments.formID,"-","","ALL") />
<cfset variables.frm			= variables.fbManager.renderFormJSON( arguments.formJSON ) />
<cfset variables.frmForm		= variables.frm.form />
<cfset variables.frmData		= variables.frm.datasets />
<cfset variables.frmFields		= variables.frmForm.fields />
<cfset variables.dataset		= "" />
<cfset variables.isMultipart	= false />

<cfset frmBean =  variables.$.getBean("content").loadBy(contentID=arguments.formID,siteID=request.siteid)>
<cfset frmInfo = frmBean.getAllValues()>
<cfset thisAction = "">
<cfset thisIDAppend = "">

<cfset $.addToHTMLHeadQueue("/#$.siteConfig('siteid')#/includes/display_objects/custom/formbuilder/formbuilder_jslib.cfm") >

<!--- start with fieldsets closed --->
<cfset request.fieldsetopen = false />
<cfset request.dualcolopen = false />
<cfset variables.aFieldOrder = variables.frmForm.fieldorder />

<cfif $.content('subType') eq "myassets">
	<cfif StructKeyExists(cookie,"cahSubmitID") and IsValid("UUID",cookie.cahSubmitID) >
		<cfset request.thisUUID = cookie.cahSubmitID />
	<cfelse>
		<cfset request.thisUUID = CreateUUID() />
		<cfcookie name="cahSubmitID" value="#request.thisUUID#" expires="100">
	</cfif>
</cfif>

</cfsilent>

<cfsavecontent variable="frmFieldContents">
<cfoutput>
<cfloop from="1" to="#ArrayLen(aFieldOrder)#" index="variables.iiX">
	<cfif StructKeyExists(variables.frmFields,variables.aFieldOrder[variables.iiX])>
		<cfset variables.field = variables.frmFields[variables.aFieldOrder[variables.iiX]] />
		<!---<cfif iiX eq 1 and field.fieldtype.fieldtype neq "section">
			<ol>
		</cfif>--->
		<cfif variables.field.fieldtype.isdata eq 1 and len(variables.field.datasetid)>
			<cfset variables.dataset = variables.fbManager.processDataset( variables.$,variables.frmData[variables.field.datasetid] ) />
		</cfif>
		<cfif variables.field.fieldtype.fieldtype eq "file">
			<cfset variables.isMultipart = true />

			<cfif $.content('subType') eq "myassets" and variables.field.name eq "uploadasset">
				<cfset variables.field.isrequired = true />
			</cfif>
		</cfif>
		<cfif variables.field.fieldtype.fieldtype eq "hidden">
		#variables.$.dspObject_Include(thefile='/formbuilder/fields/dsp_#variables.field.fieldtype.fieldtype#.cfm',
			field=variables.field,
			dataset=variables.dataset
			)#			
		<cfelseif variables.field.fieldtype.fieldtype neq "section">
			<cfsilent>
			<cfset variables.tooltip = "">
			<cfif len(variables.field.validatetype) or variables.field.isrequired >
				<cfif structkeyexists(variables.field,'cssid') and len(variables.field.cssid) >
					<cfset variables.thisFldId = variables.field.cssid >
				<cfelse>
					<cfset variables.thisFldId = variables.field.fieldid >
				</cfif>
				<!---
				<cfset variables.tooltip &= "onmouseover=""muraFormbuilderValidateTip('#variables.thisFldId#',true);"" "> 
				<cfset variables.tooltip &= "onmouseout=""muraFormbuilderValidateTip('#variables.thisFldId#',false);"" ">
				--->
				
			</cfif>
			</cfsilent>
			<div class="mura-form-#variables.field.fieldtype.fieldtype#<cfif variables.field.isrequired> req</cfif> control-group" #variables.tooltip#>
			#variables.$.dspObject_Include(thefile='/formbuilder/fields/dsp_#variables.field.fieldtype.fieldtype#.cfm',
				field=variables.field,
				dataset=variables.dataset
				)#			
			</div>
		<cfelseif variables.field.fieldtype.fieldtype eq "section">
			#variables.$.dspObject_Include(thefile='/formbuilder/fields/dsp_#variables.field.fieldtype.fieldtype#.cfm',
				field=variables.field,
				dataset=variables.dataset
				)#
		<cfelse>
		#variables.$.dspObject_Include(thefile='/formbuilder/fields/dsp_#variables.field.fieldtype.fieldtype#.cfm',
			field=variables.field,
			dataset=variables.dataset
			)#
		</cfif>		
		<!---#$.dspObject_Include('formbuilder/fields/dsp_#field.fieldtype.fieldtype#.cfm')#--->
	<cfelse>
		<!---<cfthrow message="ERROR 9000: Field Missing: #aFieldOrder[iiX]#">--->
	</cfif>
</cfloop>
<cfif request.fieldsetopen eq true></div></div><cfset request.fieldsetopen = false /></cfif>
<!---</ol>--->
</cfoutput>

</cfsavecontent>
<cfoutput>
<form id="#variables.frmID##thisIDAppend#" <cfif Len(Trim(thisAction)) >action="#thisAction#" </cfif>class="mura-formbuilder #variables.$.siteConfig('bsFormLayout')#" method="post" <cfif isMultipart>enctype="multipart/form-data"</cfif> novalidate >
<cfif $.content('subType') eq "myassets">
	<input type="hidden" name="assetid" value="#request.thisUUID#" />
</cfif>

<div id="#variables.frmID##thisIDAppend#err" class="mura-formbuilder-errors" style="display: none;"></div>
<div class="mura-formbuilder-form">
	#variables.frmFieldContents#
	<cfif Len(Trim(thisAction)) >
	</cfif>
	<div id="mura-formbuilder-footer">
		<div class="mura-formbuilder-instructions"><label><ins>*</ins> Required Field</label></div>
		<cfif $.content('subType') eq "myassets">
			<div id="agree" class="form-actions buttons"><input type="submit" value="Accept Terms and #$.rbKey('form.submit')#"></div>
		<cfelse>
			<div class="form-actions buttons"><input type="submit" value="#$.rbKey('form.submit')#"></div>
		</cfif>
	</div>
	<div id="extraerror" class="mura-formbuilder-tooltip-manual" style="display:none;width: 200px;float: right;"></div>
	#variables.$.dspObject_Include(thefile='dsp_form_protect.cfm')#
	<!--- 	#$.dspObject_Include(thefile='dsp_captcha.cfm')#	--->
</div>
</form>

</cfoutput>

