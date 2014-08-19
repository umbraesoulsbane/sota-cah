<cfsilent>
<cfset xmlFile = "#application.configBean.getAssetDir()#/#$.siteConfig('siteid')#/assets/System/generic-statelist.xml">

<cftry>

		<cfif FileExists(xmlFile) >
		<cffile action="read" file="#xmlFile#" variable="xfStates">
	<cfelse>
		<!--- // Hard Coded List if there is an issue // --->
		<cfsavecontent variable="xfStates"><?xml version="1.0" encoding="UTF-8"?><states><state label="Please select a value" value=""/><state label="Alabama" value="Alabama"/><state label="Alaska" value="Alaska"/><state label="Arizona" value="Arizona"/><state label="Arkansas" value="Arkansas"/><state label="California" value="California"/><state label="Canada" value="Canada"/><state label="Colorado" value="Colorado"/><state label="Conneticut" value="Conneticut"/><state label="Delaware" value="Delaware"/><state label="District of Columbia" value="Delaware"/><state label="Florida" value="Florida"/><state label="Georgia" value="Georgia"/><state label="Hawaii" value="Hawaii"/><state label="Idaho" value="Idaho"/><state label="Illinois" value="Illinois"/><state label="Indiana" value="Indiana"/><state label="Iowa" value="Iowa"/><state label="Kansas" value="Kansas"/><state label="Kentucky" value="Kentucky"/><state label="Louisiana" value="Louisiana"/><state label="Maine" value="Maine"/><state label="Maryland" value="Maryland"/><state label="Massachusetts" value="Massachusetts"/><state label="Michigan" value="Michigan"/><state label="Minnesota" value="Minnesota"/><state label="Mississippi" value="Mississippi"/><state label="Missouri" value="Missouri"/><state label="Montana" value="Montana"/><state label="Nebraska" value="Nebraska"/><state label="Nevada" value="Nevada"/><state label="New Hampshire" value="New Hampshire"/><state label="New Jersey" value="New Jersey"/><state label="New Mexico" value="New Mexico"/><state label="New York" value="New York"/><state label="North Carolina" value="North Carolina"/><state label="North Dakota" value="North Dakota"/><state label="Ohio" value="Ohio"/><state label="Oklahoma" value="Oklahoma"/><state label="Oregon" value="Oregon"/><state label="Pennsylvannia" value="Pennsylvannia"/><state label="Rhode Island" value="Rhode Island"/><state label="South Carolina" value="South Carolina"/><state label="South Dakota" value="South Dakota"/><state label="Tennessee" value="Tennessee"/><state label="Texas" value="Texas"/><state label="Utah" value="Utah"/><state label="Vermont" value="Vermont"/><state label="Virginia" value="Virginia"/><state label="Washington" value="Washington"/><state label="West Virginia" value="West Virginia"/><state label="Wisconsin" value="Wisconsin"/><state label="Wyoming" value="Wyoming"/></states></cfsavecontent>
	</cfif>
	
	<cfset stXML = XmlParse(xfStates) >
	<cfset states = stXML.states >
	
	<cfset strDataOrder = "">
	<cfloop index="sti" from="1" to="#ArrayLen(states.XmlChildren)#">
		<cfset dataRecords[sti] = structNew() />
		<cfset dataRecords[sti]['datarecordid'] = sti />
		<cfset dataRecords[sti]['label'] = states.XmlChildren[sti].XmlAttributes.label />
		<cfset dataRecords[sti]['value'] = states.XmlChildren[sti].XmlAttributes.value />
		<cfset strDataOrder &= "#sti#">
		<cfif sti lt ArrayLen(states.XmlChildren) >
			<cfset strDataOrder &= ",">
		</cfif>
	</cfloop>

	<cfset dataOrder     = ListtoArray(strDataOrder) />

	<cfcatch type="any">
		<cfset dataRecords['a'] = structNew() />
		<cfset dataRecords['a']['datarecordid'] = "a" />
		<cfset dataRecords['a']['label'] = "" />
		<cfset dataRecords['a']['value'] = "" />

		<cfset dataRecords['a'] = structNew() />
		<cfset dataRecords['a']['datarecordid'] = "a" />
		<cfset dataRecords['a']['label'] = "Unable to List States" />
		<cfset dataRecords['a']['value'] = "Unknown" />

		<cfset dataOrder     = ['a','b'] />

	</cfcatch>
</cftry>
</cfsilent>
<cfset arguments.dataset['datarecordorder'] = dataOrder />
<cfset arguments.dataset['datarecords'] = dataRecords />

