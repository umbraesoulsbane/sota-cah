<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. ?See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. ?If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (?GPL?) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, ?the copyright holders of Mura CMS grant you permission
to combine Mura CMS ?with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the ?/trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 ?without this exception. ?You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->

<cfcomponent extends="mura.cfobject">
<!--- Add theme-specific methods here --->

<cfset this.convertService = "your.converter.service" />
<cfset this.convertPort = "443" />
<cfset this.googleDoc = "https://spreadsheets.google.com/feeds/list/YOUR_PUBLISHED_SPREADSHEET/COLID/public/values?alt=atom" />
<cfset this.authProvider = "https://your.url.goes.here" />
<cfset this.authScript = "./your.sh" />


<!--- // Auth // --->
<cffunction name="valRemoteUsr" access="public" returntype="any" output="false">
	<cfargument name="inUser" type="string" required="true" default=""/>
	<cfargument name="inPass" type="string" required="true" default=""/>

	<!--- // Change this to auth provider // --->
	<cfset authURL = this.authProvider />
 
	<cfset argUser = arguments.inUser />
	<cfset argPass = arguments.inPass />
	<cfset payload = '{"user":"#Replace(argUser, '"', '\"', 'all')#","pass":"#Replace(argPass, '"', '\"', 'all')#"}' />
 
	<!--- // Change this to OpenSSL Script // --->
	<cfexecute name="#this.authScript#" arguments='#ToBase64(payload )#' variable="sigX" timeout="5" />

	<cfhttp method	="post" 
			url		="#authURL#"
			result	="doAuth"
			throwonerror="no">

		<cfhttpparam name="X-Signature" type="header" 	value="#Trim(ListGetAt(sigX, 2, "="))#" encoded="no">
		<cfhttpparam 					type="body" 	value="#authStr#" encoded="no">

	</cfhttp>

	<cfreturn doAuth />
	
</cffunction>

<!--- // Formbuilder // --->
<cffunction name="getFBFriendly" output="no" returntype="string">
	<cfargument name="rudeName" type="string" required="true" default=""/>
	<cfargument name="formid" type="string" required="true" default=""/>
	<cfargument name="siteid" type="string" default="#$.content('siteid')#"/>

	<cftry>
		<cfset thisForm = $.getBean("content").loadBy(contentid=arguments.formid,siteID=arguments.siteid,type='Form') >
		<cfset variables.fbManager = $.getBean('formBuilderManager') />
		<cfset formStruct = variables.fbManager.renderFormJSON( thisForm.getValue('body') ) />
		<cfset fieldStruct = formStruct.form.fields />
		
		<cfset rudeStruct = StructFindValue(fieldStruct, arguments.rudeName, "all") >
		
		<cfset friendlyStr = rudeStruct[1].owner.label >
	
		<cfset rtn = friendlyStr />
		
		<cfcatch type="any">
			<cfset rtn = ReReplace(arguments.rudeName,"\b(\w)","\u\1","ALL") />
		</cfcatch>
	</cftry>
	
	<cfreturn rtn />
</cffunction>

<cffunction name="getFBListDisplay" output="no" returntype="string">
	<cfargument name="formid" type="string" required="true" default=""/>
	<cfargument name="filterCSS" type="string" default="dspMyAssets"/>
	<cfargument name="siteid" type="string" default="#$.content('siteid')#"/>

	<cftry>
		<cfset thisForm = $.getBean("content").loadBy(contentid=arguments.formid,siteID=arguments.siteid,type='Form') >
		<cfset variables.fbManager = $.getBean('formBuilderManager') />
		<cfset formStruct = variables.fbManager.renderFormJSON( thisForm.getValue('body') ) />
		<cfset fieldStruct = StructFindKey(formStruct.form.fields,"cssclass","all") />


		<cfset dspArray = ArrayFilter(fieldStruct, function(v) {
			return v.owner.cssclass contains "dspM";
		}) />

		<cfset outList = "" />

		<cfloop index="i" from="1" to="#arrayLen(dspArray)#">
			<cfif i eq 1 >
				<cfset outList &= dspArray[i].owner.name />
			<cfelse>
				<cfset outList &= "," & dspArray[i].owner.name />
			</cfif>
			
		</cfloop>
		<cfset rtn = outList />

	
		<cfcatch type="any">
			<cfset rtn = "" />
		</cfcatch>
	</cftry>

	<cfreturn rtn />
</cffunction>

<cffunction name="getFBclasscss" output="yes" returntype="string">
	<cfargument name="field" type="string" required="true" default=""/>
	<cfargument name="formid" type="string" required="true" default=""/>
	<cfargument name="siteid" type="string" default="#$.content('siteid')#"/>

	<cftry>
		<cfset thisForm = $.getBean("content").loadBy(contentid=arguments.formid,siteID=arguments.siteid,type='Form') >
		<cfset variables.fbManager = $.getBean('formBuilderManager') />
		<cfset formStruct = variables.fbManager.renderFormJSON( thisForm.getValue('body') ) />
		<cfset fieldStruct = StructFindValue(formStruct.form.fields,arguments.field,"all") />

		<cfset rtn = fieldStruct[1].owner.cssclass />

		<cfcatch type="any">
			<cfset rtn = "" />
		</cfcatch>
	</cftry>

	<cfreturn rtn />
</cffunction>

<!--- // END Formbuilder // --->


<!--- // Asset Workflow // --->

	<!--- // Callout Import // --->
<cffunction name="getRemoteCatOptions" output="false" returntype="string">

	<cfset configObj = $.getBean('configBean') />

	<cfquery name="rCatQry" datasource="#configObj.getDatasource()#" username="#configObj.getDBusername()#" password="#configObj.getDBpassword()#">
	SELECT Distinct(d.attributeValue) 
	FROM 	tclassextendattributes e, tclassextenddata d
	WHERE 	e.attributeID = d.attributeID AND 
			e.name = 'remotecat' AND
			(d.attributeValue is not null or d.attributeValue != '')
	ORDER BY d.attributeValue
	</cfquery>

	<cfset myList = "">
	
		<cfset myList = valueList(rCatQry.attributeValue,"^") />
		<cfset myList = ListPrepend(myList,"None","^") />

		<cfset rtn = myList >

	<cfreturn rtn >

</cffunction>

<cffunction name="processGDoc" returntype="any" access="public" output="true">
	<cfargument name="showStat" type="string" required="false" default="true" />
	
		<cfset xmlDocs = XmlSearch($.getGDoc(), "//*[name() = 'entry']") />
		<cfset parent = $.getBean("content").loadBy(filename="callouts",siteID=$.event("siteid")) />		

		<cfset thisCat = "" />
		<cfset statArray = ArrayNew() />
		
		<cfloop index="gd" from="1" to="#ArrayLen(xmlDocs)#">
			<cfset isSave = false />

			<cfif Len(Trim(xmlDocs[gd]["gsx:id"].xmltext)) >
				<cfset isPage = $.getBean("content").loadBy(remoteID=xmlDocs[gd]["gsx:id"].xmltext,siteID=$.event("siteid")) />
				<cfset statMsg = "<strong>Processing:</strong> " & xmlDocs[gd]["gsx:id"].xmltext />
				<cfset statCode = "" />
				
				<cfif Len(Trim(isPage.getMenuTitle())) >
					<cfif DateCompare(isPage.getValue("LASTUPDATE"), xmlDocs[gd].updated.xmltext) eq -1 >
						<cfscript>
							updField = " (" & isPage.getValue('display') & "|" & xmlDocs[gd]["gsx:priority"].xmltext & "|" & xmlDocs[gd]["gsx:status"].xmltext;
							if (isPage.getTitle() neq xmlDocs[gd]["gsx:name"].xmltext) {
								isPage.setTitle(xmlDocs[gd]["gsx:name"].xmltext);
								isPage.setMenuTitle('');
								isPage.setURLTitle('');
								isPage.setHTMLTitle('');
								isSave = true;
								updField &= "-Title-";
							}
							if (isPage.getSummary() neq "<p>#xmlDocs[gd]["gsx:description"].xmltext#</p>") {
								isPage.setSummary("<p>" & xmlDocs[gd]["gsx:description"].xmltext & "</p>");
								isSave = true;
								updField &= "-Summary-";
							}
							if (isPage.getBody() neq "<p>#xmlDocs[gd]["gsx:notes"].xmltext#</p>") {
								isPage.setBody("<p>" & xmlDocs[gd]["gsx:notes"].xmltext & "</p>");
								isSave = true;
								updField &= "-Body-";
							}
							if (isPage.getValue('remoteID') neq xmlDocs[gd]["gsx:id"].xmltext) {
								isPage.setRemoteID(xmlDocs[gd]["gsx:id"].xmltext);
								isSave = true;
								updField &= "-Remoteid-";
							}
							if (isPage.getValue('assettype') neq xmlDocs[gd]["gsx:type"].xmltext) {
								isPage.setValue('assettype', xmlDocs[gd]["gsx:type"].xmltext);
								isSave = true;
								updField &= "-Type-";
							}
							if (isPage.getValue('bounty') neq xmlDocs[gd]["gsx:bounty"].xmltext) {
								isPage.setValue('bounty', xmlDocs[gd]["gsx:bounty"].xmltext);
								isSave = true;
							}
							if (isPage.getValue('remotecat') neq thisCat) {
								isPage.setValue('remotecat', thisCat);
								isSave = true;
								updField &= "-Cat-";
							}
							if (isPage.getValue('priority') neq xmlDocs[gd]["gsx:priority"].xmltext) {
								if (ListFindNoCase("low,medium,high",xmlDocs[gd]["gsx:priority"].xmltext)) {
									isPage.setValue('priority', xmlDocs[gd]["gsx:priority"].xmltext);
									isSave = true;
									updField &= "-Priority-";
								} elseif (isPage.getValue('display') eq 0 and xmlDocs[gd]["gsx:priority"].xmltext eq "closed") {
									// Do Nothing
								} else {
									isPage.setValue('priority', 'Low');
									isSave = true;
									updField &= "-Priority-";	
								}
							} elseif (isPage.getValue('display') eq 0 and (xmlDocs[gd]["gsx:priority"].xmltext neq "closed" and xmlDocs[gd]["gsx:status"].xmltext neq "closed")) {
								isSave = true;
								updField &= "-Priority/WaxOn-";
							} elseif (isPage.getValue('display') eq 1 and (xmlDocs[gd]["gsx:priority"].xmltext eq "closed" or xmlDocs[gd]["gsx:status"].xmltext eq "closed")) {
								isSave = true;
								updField &= "-Priority/WaxOff-";
							}
							updField &= ")";
						</cfscript>

						<cfset statMsg &= " (Page Found" />
						<cfif isSave >
							<cfset statMsg &= ": <strong>Update</strong> " & DateFormat(xmlDocs[gd].updated.xmltext,"m/d/yyyy") & " " & TimeFormat(xmlDocs[gd].updated.xmltext,"hh:mm:ss tt") & ") #updField#" />
						<cfelse>
							<cfset statMsg &= ": No Changes) #updField#" />
						</cfif>

					<cfelse>
						<cfset statMsg &= " (Page Found: No Changes)" />
					</cfif>
				<cfelse>
					<cfset statMsg &= " (No Match: <strong>Add Page</strong>)" />

					<cfscript>
						isPage.setTitle(xmlDocs[gd]["gsx:name"].xmltext);
						isPage.setMenuTitle('');
						isPage.setURLTitle('');
						isPage.setHTMLTitle('');
						isPage.setApproved(1);
						isPage.setSummary("<p>" & xmlDocs[gd]["gsx:description"].xmltext & "</p>");
						isPage.setBody("<p>" & xmlDocs[gd]["gsx:notes"].xmltext & "</p>");
						isPage.setParentID(parent.getContentID());
						isPage.setRemoteID(xmlDocs[gd]["gsx:id"].xmltext);
						isPage.setSubType("Callouts");
							
						isPage.setValue('assettype', xmlDocs[gd]["gsx:type"].xmltext);
						isPage.setValue('bounty', xmlDocs[gd]["gsx:bounty"].xmltext);
						isPage.setValue('remotecat', thisCat);
						if (ListFindNoCase("low,medium,high",xmlDocs[gd]["gsx:priority"].xmltext)) {
							isPage.setValue('priority', xmlDocs[gd]["gsx:priority"].xmltext);
						} else {
							isPage.setValue('priority', 'Low');
						}
							
						isSave = true;
					</cfscript>
				</cfif>

				<cfif isSave >
					<cfset statCode = "U" />
					<cfscript>							
						if (xmlDocs[gd]["gsx:priority"].xmltext eq "closed" or xmlDocs[gd]["gsx:status"].xmltext eq "closed") {
							isPage.setDisplay(0);
							isPage.setIsNav(0);
						} else {
							isPage.setDisplay(1);
							isPage.setIsNav(1);
						}
						isPage.save();
					</cfscript>
					
					<cfset statMsg &= " ((SAVED))" />
					
					<cfif !StructIsEmpty(isPage.getErrors()) >
						<cfset statCode = "E" />
						<cfset statMsg &= " <strong>ERROR:</strong> " & isPage.getErrors() />
					</cfif>
				<cfelseif DateCompare(isPage.getValue("LASTUPDATE"), xmlDocs[gd].updated.xmltext) eq -1 >
					<cfscript>							
						isPage.save();
					</cfscript>
				</cfif>
				
				
				<cfset tempStr.msg 	= statMsg />
				<cfset tempStr.code = statCode />
				<cfset ArrayAppend(statArray, Duplicate(tempStr)) />

			<cfelse>
				<cfset thisCat = xmlDocs[gd]["gsx:name"].xmltext />
			</cfif>

		</cfloop>

	<cftry>
		<cfcatch type="any">
			<cfset statArray = ArrayNew() />
			<cfset statArray[1].msg = "<strong>CRITICAL ERROR:</strong> " & cfcatch.message />
			<cfset statArray[1].code = "E" />
		</cfcatch>
	</cftry>

	<cfif arguments.showStat >
		<cfoutput>
		<style>
		body 	{ font-family: Verdana; color: Black; font-size: 100%; }
		div		{ background-color: Silver; padding: 10px; margin: 5px; width: 100%; diplay: block; }
		.e		{ background-color: FireBrick; color: white; }
		.u		{ background-color: Green; color: white; }
		</style>
		
		<cfloop index="stat" from="1" to="#ArrayLen(statArray)#">
			<div <cfif statArray[stat].code eq "E" or statArray[stat].code eq "U">
				class="#LCase(statArray[stat].code)#"
			</cfif>
			>
				#statArray[stat].msg#
			</div>
		</cfloop>
		</cfoutput>
	</cfif>

</cffunction>

<cffunction name="getGDoc" returntype="any" access="public" output="false">
	<cfargument name="gUrl" type="string" required="true" default="#this.googleDoc#"/>

	<cftry>
		<cfhttp method="get" 
				url="#arguments.gUrl#"
				result="gDoc"
				throwonerror="Yes">
		</cfhttp>

		<cfset rtn = XmlParse(gDoc.filecontent) />
	
		<cfcatch type="any">
			<cfset rtn = XmlNew() />
		</cfcatch>
	</cftry>
	
	<cfreturn rtn />

</cffunction>

	<!--- // Converter // --->
<cffunction name="startConvert" returntype="any" access="public" output="true">
<cfargument name="assetid" type="string" required="Yes">
<cfargument name="assetUrl" type="string" required="Yes">

	<cfset sanitizeUUID = Replace(arguments.assetid, "-", "", "ALL") >

	<cfhttp method="post" 
			url="#this.convertService#/submit/"
			port="#this.convertPort#" 
			throwonerror="Yes">

		<cfhttpparam name="token" type="FormField" value="#LCase(sanitizeUUID)#">
		<cfhttpparam name="url" type="FormField" value="#arguments.assetUrl#">

	</cfhttp>

</cffunction>

<cffunction name="getConvert" returntype="any" access="public" output="false">
	<cfargument name="assetid" type="string" required="Yes">

	<cfset sanitizeUUID = Replace(arguments.assetid, "-", "", "ALL") >
	<cfset thisURL = this.convertService & '/hopper?where={"id_user":"' & LCase(sanitizeUUID) & '"}' />

	<cftry>

		<cfhttp method="get" 
				url="#thisURL#"
				port="#this.convertPort#" 
				result="hopper"
				throwonerror="Yes">
		</cfhttp>

		<cfset thisJson = DeserializeJSON(hopper.filecontent) />
		
		<cfcatch type="any">
			<cfset thisJson = StructNew() />
		</cfcatch>
	</cftry>
	
	<cfif StructKeyExists(thisJson,"_items") and ArrayLen(thisJson._items) >
		<cfset rtn = thisJson._items[1] />
	<cfelse>
		<cfset rtn 			= StructNew() />
		<cfset rtn.status 	= "fail" />
		<cfset rtn._id	 	= "UNKNOWN" />
	</cfif>

	<cfreturn rtn />

</cffunction>

	<!--- // Queries // --->
<cffunction name="getStatus" output="no" returntype="struct">
	<cfargument name="assetid" type="string" required="true" default="-1"/>

	<cftry>
		<cfquery datasource="cah" name="getStatus">
		SELECT a.*, b.final_status  FROM cah.approval a, cah.asset b 
		WHERE 	a.assetid = b.uuid AND
				a.assetid = '#arguments.assetid#'
		ORDER BY a.created DESC
		</cfquery>
		
		<cfquery datasource="cah" name="getConvert">
		SELECT *  FROM cah.asset 
		WHERE 	uuid = '#arguments.assetid#'
		</cfquery>

		<cfcatch><cfset getStatus = QueryNew("none") /><cfset getConvert = QueryNew("convert_status") /></cfcatch>		
	</cftry>

	<cfset outStruct = StructNew() />
	<cfif getConvert.convert_status eq 0 >
		<cfif $.getConvert(arguments.assetid).status eq "review">
			<cfquery datasource="cah" name="getStatus">
			UPDATE cah.asset 
			SET 	convert_status = 1
			WHERE 	uuid = '#arguments.assetid#'
			</cfquery>
			<cfset outStruct.status 	= "Awaiting Peer Review" />
			<cfset outStruct.statuscode	= "Open" />
		<cfelse>
			<cfset outStruct.status 	= "Awaiting Conversion" />
			<cfset outStruct.statuscode	= "Open [c]" />
		</cfif>
	<cfelse>
		<cfset outStruct.status 	= "Awaiting Peer Review" />
		<cfset outStruct.statuscode	= "Open" />
	</cfif>
		<cfset outStruct.id 		= arguments.assetid />
	
	<cfif NOT getStatus.RecordCount >
		<cfset outStruct.peers.pass = ArrayNew() />
		<cfset outStruct.peers.fail = ArrayNew() />
		<cfset outStruct.devs.pass 	= ArrayNew() />
		<cfset outStruct.devs.fail 	= ArrayNew() />
	<cfelse>
		<cfset outStruct.peers.pass	= ArrayNew() />
		<cfset outStruct.peers.fail	= ArrayNew() />
		<cfset outStruct.devs.pass 	= ArrayNew() />
		<cfset outStruct.devs.fail 	= ArrayNew() />

		<cfset pPass = 0 />
		<cfset pFail = 0 />
		<cfset dPass = 0 />
		<cfset dFail = 0 />

		
		<cfoutput query="getStatus">
			<cfif reviewtype eq "peer">
				<cfif status_title eq "Approved">
					<cfset pPass = ArrayLen(outStruct.peers.pass)+1 />
						<cfset outStruct.peers.pass[pPass].approver = approver />
						<cfset outStruct.peers.pass[pPass].status = status_title />
						<cfset outStruct.peers.pass[pPass].created = created />
						<cfset outStruct.peers.pass[pPass].id = id />
				<cfelse>
					<cfset pFail = ArrayLen(outStruct.peers.fail)+1 />
						<cfset outStruct.peers.fail[pFail].approver = approver />
						<cfset outStruct.peers.fail[pFail].status = status_title />
						<cfset outStruct.peers.fail[pFail].created = created />
						<cfset outStruct.peers.fail[pFail].id = id />
				</cfif>				
			<cfelseif reviewtype eq "dev">
				<cfif status_title eq "Approved">
					<cfset dPass = ArrayLen(outStruct.devs.pass)+1 />
						<cfset outStruct.devs.pass[dPass].approver = approver />
						<cfset outStruct.devs.pass[dPass].status = status_title />
						<cfset outStruct.devs.pass[dPass].created = created />
						<cfset outStruct.devs.pass[dPass].id = id />
				<cfelse>
					<cfset dFail = ArrayLen(outStruct.devs.fail)+1 />
						<cfset outStruct.devs.fail[dFail].approver = approver />
						<cfset outStruct.devs.fail[dFail].status = status_title />
						<cfset outStruct.devs.fail[dFail].created = created />
						<cfset outStruct.devs.fail[dFail].id = id />
				</cfif>
			</cfif>
		</cfoutput>

		<cfif ArrayLen(outStruct.peers.fail) gte 2 >
			<cfset outStruct.status = "Peer Review Rejection" />
			<cfset outStruct.statuscode = "Rejected" />
		<cfelseif ArrayLen(outStruct.peers.pass) gte 2 >
			<cfset outStruct.status = "Peer Review Completed" />
			<cfset outStruct.statuscode	= "Open [" & ArrayLen(outStruct.peers.pass) & "]" />
		<cfelseif ArrayLen(outStruct.peers.pass) >
			<cfset outStruct.status = "Partial Peer Review" />
			<cfset outStruct.statuscode	= "Open [" & ArrayLen(outStruct.peers.pass) & "]" />
		</cfif>

		<cfif ArrayLen(outStruct.devs.pass) >
			<cfset outStruct.status = "Developer Approved" />
			<cfset outStruct.statuscode	= "Accepted" />
		<cfelseif ArrayLen(outStruct.devs.fail) >
			<cfset outStruct.status = "Developer Rejected" />
			<cfset outStruct.statuscode = "Rejected" />
		</cfif>
		
		<cfif outStruct.statuscode neq getStatus.final_status and outStruct.statuscode does not contain "open" >
			<cfquery datasource="cah" name="getStatus">
			UPDATE cah.asset 
				SET final_status = "#LCase(outStruct.statuscode)#"
			WHERE 	uuid = '#arguments.assetid#'
			</cfquery>
		</cfif>


	</cfif>
	
	<cfreturn outStruct />
</cffunction>

<cffunction name="getFeedback" output="no" returntype="query">
	<cfargument name="statusid" type="string" required="false" default=""/>
	<cfargument name="assetid" type="string" required="false" default=""/>
	
	<cftry>
		<cfquery datasource="cah" name="getFeedback">
		SELECT * FROM feedback 
		WHERE 	
			<cfif Len(Trim(arguments.assetid)) >
				assetid = '#arguments.assetid#'
			<cfelseif Len(Trim(arguments.statusid)) >
				statusid = '#arguments.statusid#' 
			<cfelse>
				commenter = '#session.mura.userid#'
			</cfif>
		ORDER BY created DESC, assetid 
		</cfquery>

		<!--- id,assetid,statusid,created,message,commenter,quickmessage --->		
		<cfcatch><cfset getFeedback = QueryNew("none") /></cfcatch>		
	</cftry>
	
	<cfreturn getFeedback />
</cffunction>

<cffunction name="getAssetList" output="no" returntype="query">
	<cfargument name="type" type="string" required="true" default="NA"/>
	<cfargument name="filter" type="string" required="false" default=""/>
	
	<cftry>
		<cfquery datasource="cah" name="qryAssets">

		<cfif arguments.type eq "user" >
			SELECT * FROM cah.asset 
			WHERE 	submitter = '#arguments.filter#'
		<cfelseif arguments.type eq "open" >
			SELECT 	*
			FROM	cah.asset 
			WHERE	(final_status IS NULL or
					final_status = '')
					and convert_status = 1
		<cfelseif arguments.type eq "rejected" >
			SELECT 	*
			FROM	cah.asset 
			WHERE	final_status = 'rejected'
		<cfelseif arguments.type eq "accepted" >
			SELECT 	*
			FROM	cah.asset 
			WHERE	final_status = 'accepted'
		<cfelseif arguments.type eq "all" >
			SELECT * FROM cah.asset 
			WHERE 	convert_status = 1
		<cfelseif arguments.type eq "unconverted" >
			SELECT * FROM cah.asset 
			WHERE 	convert_status = 0
		<cfelse>
			SELECT a.* FROM cah.asset a LEFT JOIN cah.approval b ON a.uuid = b.assetid
			WHERE	(	a.final_status IS NULL or
						a.final_status = '') AND 
					a.submitter <> '#session.mura.userid#' 
					and convert_status = 1
				<cfif $.currentUser().isInGroup("Reviewer") >
					AND a.uuid NOT IN  (	SELECT c.assetid FROM cah.approval c
											WHERE 	c.assetid = a.uuid AND
													c.reviewtype = 'peer' AND 
													c.approver = '#session.mura.userid#')
				<cfelseif $.currentUser().isInGroup("Developer") >
		 			AND (	SELECT Count(*) FROM cah.approval c
							WHERE 	c.assetid = a.uuid AND
									c.reviewtype = 'peer') > 1 
					GROUP BY a.uuid
				</cfif>

		</cfif>
		
		</cfquery>

		<cfcatch><cfrethrow><cfset qryAssets = QueryNew("none") /></cfcatch>		
	</cftry>
	
	<cfreturn qryAssets />
</cffunction>

<cffunction name="addAsset" returntype="any" access="public" output="true">
<cfargument name="data" type="struct">
	<cfset var responseid="">
	<cfset var action="create">
	<cfset var info=structnew()>
	<cfset var templist=''>
	<cfset var theFileStruct=structnew()>
	<cfset var formid=arguments.data.formid>
	<cfset var siteid=arguments.data.siteid>
	<cfset var fieldlist="">
	<cfset var fileID="">
	<cfset var entered="#now()#">
	<cfset var rf = "" />
	<cfset var thefield = "" />
	<cfset var f = "" />
	<cfset var theXml = "" />
	
	<cfparam name="info.fieldnames" default=""/>
	
	<cfif isdefined('arguments.data.responseid')>
		<cfset responseid=arguments.data.responseid>
		<cfset action="Update">
		<cfset fieldlist=arguments.data.fieldlist>
		<cfset entered=arguments.data.entered>
		<cfset delete('#responseid#',false)/>
	<cfelse>
		<cfset responseid=createuuid()>
		<cfset fieldlist=arguments.data.fieldnames>
	</cfif> 
	
	<cfloop list="#fieldlist#" index="f">
	<cfif f neq 'DOACTION' and f neq 'SUBMIT' and f neq 'MLID' and f neq 'SITEID' and f neq 'FORMID' and f neq 'POLLLIST' and f neq 'REDIRECT_URL' and f neq 'REDIRECT_LABEL' and f neq 'X' and f neq 'Y' and f neq 'UKEY' and f neq 'HKEY'
		and f neq 'formfield1234567891' and f neq 'formfield1234567892' and f neq 'formfield1234567893' and f neq 'formfield1234567894' and f neq 'useProtect' and f neq "linkservid">
	
		<cfif action eq 'create' and right(f,8) eq '_default'>
			<cfset rf=left(f,len(f)-8)>
			<cfif not listFindNoCase(arguments.data.fieldnames,rf)>
				<cfset arguments.data['#rf#']=arguments.data['#f#']>
				<cfset thefield=rf>
				<cfset info.fieldnames=listappend(info.fieldnames,thefield)>
			<cfelse>
				<cfset thefield=''>
			</cfif>
		<cfelse>
			<cfset thefield=f>
			<cfset info.fieldnames=listappend(info.fieldnames,thefield)>
		</cfif>
		
			<cfif thefield neq '' and structkeyexists(arguments.data, thefield)>
				
				<cfif findNoCase('attachment',theField) and arguments.data['#thefield#'] neq ''>
					<cftry>
<!--- // NOT NEEDED Custom File Handler //
						<cffile action="upload" filefield="#thefield#" nameconflict="makeunique" destination="#variables.configBean.getTempDir()#">
						<cfset theFileStruct=variables.fileManager.process(file,siteID) />
						<cfset arguments.data['#thefield#']=variables.fileManager.create(theFileStruct.fileObj,formid,siteID,file.ClientFile,file.ContentType,file.ContentSubType,file.FileSize,'00000000000000000000000000000000004',file.ServerFileExt,theFileStruct.fileObjSmall,theFileStruct.fileObjMedium,createUUID(),theFileStruct.fileObjSource) />
--->
						<cfcatch></cfcatch>
					</cftry>
					<cfset info['#thefield#']=arguments.data['#thefield#']>
				</cfif>
					
					<cfset info['#thefield#']=trim(arguments.data['#thefield#'])>
					<cfset info['#thefield#']=REREplaceNoCase(info['#thefield#'], "<script|<form",  "<noscript" ,  "ALL")/>
					<cfset info['#thefield#']=REREplaceNoCase(info['#thefield#'], "script>|form>",  "noscript>" ,  "ALL")/>		
					
			</cfif>
	</cfif>
	
	</cfloop>
	
	<cfif not StructIsEmpty(info)>

		<cftransaction>

		<cftry>

			<cfquery datasource="cah" name="insAsset">
			INSERT INTO asset
			(uuid,title,description,type,callout,package,submitter,created)
				VALUES
			(
				'#info['assetid']#',
				'#info['assettitle']#',
				'#info['assetdescription']#',
				'#info['assettype']#',
				'#info['callout']#',
				'#info['uploadasset_attachment']#',
				'#info['submitter']#',
				#ParseDateTime(Now())#
			)
			</cfquery>
			
			<cfif StructKeyExists(cookie,"cahSubmitID") and info['assetid'] eq cookie.cahSubmitID >
				<cfset delCookie = StructDelete(cookie,"cahSubmitID") />
			</cfif>

			<cfif Len(Trim(info['uploadasset_attachment'])) and Left(Trim(info['uploadasset_attachment']), 4) eq "http" >
				<cfset passConvert = $.startConvert(info['assetid'],info['uploadasset_attachment']) />
				<cfset viewerID = $.getConvert(info['assetid']) />
				<cfquery datasource="cah" name="updAsset">
				UPDATE	asset
				SET		viewer = '#viewerID._id#'
				<cfif viewerID.status eq "review">
						, convert_status = 1
				</cfif>
				WHERE uuid = '#info['assetid']#'
				</cfquery>
			</cfif>

			<cfcatch>
				<cftransaction action="rollback" />
			</cfcatch>
		</cftry>
	
		</cftransaction>

		</cfif>
	
	<cfreturn info />
</cffunction>

<cffunction name="saveJudgement">
	<cfargument name="thisForm" type="struct" required="true" default="#StructNew()#"/>
	<cfargument name="thisAsset" type="string" required="true" default="-1"/>

	<cftry>
		<cfset statid = CreateUUID() />
		<cfset err = StructNew() >
		<cfset feedbackBody = REReplaceNoCase(thisForm.feedback, "<script|<form",  "<noscript" ,  "ALL") />
		<cfset feedbackBody = REReplace(feedbackBody, "<[^>]*(?:>|$)",  "" ,  "ALL") />
		<cfset feedbackBody = ReplaceList(feedbackBody, ">,<",  ",") />

		<cftransaction>

		<cfquery datasource="cah" name="insStat">
		INSERT INTO approval
		(assetid,approver,reviewtype,created,status_title,id   )
			VALUES
		(
			'#arguments.thisAsset#',
			'#session.mura.userid#',
			'#thisForm.reviewtype#',
			#ParseDateTime(Now())#,
			'#thisForm.status#',
			'#statid#'
		)
		</cfquery>
		
		<cfif Len(Trim(thisForm.feedback)) or Len(Trim(thisForm.quickfeedback)) >
			<cfquery datasource="cah" name="insFeed">
			INSERT INTO feedback
			(id,assetid,statusid,created,message,quickmessage,commenter)
				VALUES
			(
				'#CreateUUID()#',
				'#arguments.thisAsset#',
				'#statid#',
				#ParseDateTime(Now())#,
				'#feedbackBody#',
				'#thisForm.quickfeedback#',
				'#session.mura.userid#'
			)
			</cfquery>
		</cfif>

		</cftransaction>
		
		<cfcatch><cfset err = cfcatch /><cftransaction action="rollback" /></cfcatch>
	</cftry>

	<cftransaction action="commit" />
	
	<cfif StructIsEmpty(err) >
		<cflocation url="#$.getCurrentURL()#&success" addtoken="no">
	<cfelse>
		<p class="fail">Unable to save rating. (<cfoutput>#err.Message#</cfoutput>)</p>
	</cfif>

</cffunction>
	<!--- // END Queries // --->

	<!--- // Displays // --->
<cffunction name="renderCalloutList">
<cfargument name="feedName" type="string" required="false" default="[ Callouts ]"/>

	<cfset feed=$.getBean("feed").loadBy(name=arguments.feedName,siteID=$.event("siteid"))>
	<cfset iterator=feed.getIterator()>

	
	<cfset $.addToHTMLHeadQueue("/#$.siteConfig('siteid')#/includes/display_objects/custom/datatable_jslib.cfm")>

	<script>
	$(document).ready(function() {
		var table = $('#calloutTBL').DataTable({
				"order": [[ 0, "asc" ]]
		});
		$("#calloutTBL tfoot th").each( function ( i ) {
			var select = $('<select><option value=""></option></select>').appendTo( $(this).empty() )
				.on( 'change', function () {
					if($(this).val().length > 0) {
						table.column( i ).search( '^'+$(this).val()+'$', true, false ).draw();
					} else {
						table.column( i ).search( '', true, false ).draw();
					}
				});
 
			table.column( i ).data().unique().sort().each( function ( d, j ) {
				select.append( '<option value="'+d+'">'+d+'</option>' )
			});
    	});
	});
	</script>

	<div class="myassets">
	<cfif iterator.hasNext()>
		<table id="calloutTBL">
		<thead>
			<tr>
				<th>Name</th>
				<th>Type</th>
				<th>Priority</th>
				<th>Bounty</th>
			</tr>	
		</thead>
		<tfoot>
			<tr>
				<th>Name</th>
				<th>Type</th>
				<th>Priority</th>
				<th>Bounty</th>
			</tr>	
		</tfoot>
		<tbody>
		<cfoutput>
		<cfloop condition="iterator.hasNext()">
			<cfset item=iterator.next()>
			<tr onclick="window.location.href='#item.getURL()#'">
				<td>#item.getValue('title')#</td>
				<td>#item.getValue('assettype')#</td>
				<td>#item.getValue('priority')#</td>
				<td>#item.getValue('bounty')#</td>
			</tr>
		</cfloop>
		</cfoutput>
		</tbody>
		</table>
	<cfelse>
		<div class="notfound">There are currently no Callouts for assets.</div>
	</cfif>
	</div>
</cffunction>

<cffunction name="renderCalloutDetail">
<cfargument name="feedName" type="string" required="false" default="[ Callouts ]"/>

	<cfset feed=$.getBean("feed").loadBy(name=arguments.feedName,siteID=$.event("siteid"))>
	<cfset iterator=feed.getIterator()>

	<!--- // Setup previous and next // --->
	<cfset sibArray = ArrayNew() />
	<cfset sibIdx = 0 />
	<cfloop condition="iterator.hasNext()">
		<cfset item=iterator.next() />
		<cfset sibIdx += 1 />

		<cfset sibArray[sibIdx].url = item.getUrl() />
		<cfset sibArray[sibIdx].title = item.getValue('title') />

		<cfif item.getValue('contentid') eq $.content('contentid') >
			<cfset curIdx = sibIdx />
		</cfif>

	</cfloop>
	<!--- // Previous // --->
	<cfif Val(curIdx-1) lt 1 >
		<cfset prvIdx = ArrayLen(sibArray) />
	<cfelse>
		<cfset prvIdx = Val(curIdx-1) />
	</cfif>
	<!--- // Next // --->
	<cfif Val(curIdx+1) GT ArrayLen(sibArray) >
		<cfset nxtIdx = 1 />
	<cfelse>
		<cfset nxtIdx = Val(curIdx+1) />
	</cfif>
	<!--- // END Setup previous and next // --->

	<div class="callout">
	<cfoutput>
		<div class="category">
			<div><a href="#$.getparent().getUrl()#">[ Back to List ]</a></div>
			<p><strong>Category:</strong> #$.content('remotecat')#</p>
		</div>
		
		<div class="flipper">
			<div><a href="#sibArray[nxtIdx].url#">[ #sibArray[nxtIdx].title# ] <strong>Next &gt;</strong></a></div>
			<p><a href="#sibArray[prvIdx].url#"><strong>&lt; Prev</strong> [ #sibArray[prvIdx].title# ]</a></p>
		</div>

				<h3>#$.content('title')#</h3>


		<div class="description">
			#$.content('summary')#
			<cfif Len(Trim(ReplaceList($.content('body'),"<p>,</p>",","))) >
				<p class="label">Notes:</p>
				#$.content('body')#
			</cfif>
		</div>

		<p>&nbsp;</p>

		<hr>
		
		<dl>
			<dt class="first">Type:</dt>
			<dd>#$.content('assettype')#</dd>

			<dt>Priority:</dt>
			<dd>#$.content('priority')#</dd>

			<dt>Bounty:</dt>
			<dd class="last">#$.content('bounty')#</dd>

		</dl>
<!--- Page Flipper Footer - If desired
		<p style="clear: both;">&nbsp;</p>
		<div class="flipper">
			<div><a href="#sibArray[nxtIdx].url#">[ #sibArray[nxtIdx].title# ] <strong>Next &gt;</strong></a></div>
			<p><a href="#sibArray[prvIdx].url#"><strong>&lt; Prev</strong> [ #sibArray[prvIdx].title# ]</a></p>
		</div>
--->
	</cfoutput>
	</div>

</cffunction>	
	
<cffunction name="renderAssetList">
	<cfargument name="queue" type="string" required="false" default=""/>

	<cfset var currentUser = session.mura.userid >
	<cfif Len(Trim(arguments.queue)) >
		<cfset passQueue = "&queue=#arguments.queue#" />
	<cfelse>
		<cfset passQueue = "" />
	</cfif>

	<cftry>
		<cfif Find("|", arguments.queue) >
			<cfset queueType = ListGetAt(arguments.queue,1,"|") />
			<cfset queueFltr = ListGetAt(arguments.queue,2,"|") />
		<cfelse>
			<cfset queueType = arguments.queue />
			<cfset queueFltr = "" />
		</cfif>
		
		<cfset getAssets = $.getAssetList(queueType,queueFltr) />
		
		<cfcatch><cfset getAssets = QueryNew("none") /></cfcatch>
	</cftry>
	
	<cfset $.addToHTMLHeadQueue("/#$.siteConfig('siteid')#/includes/display_objects/custom/datatable_jslib.cfm")>

	<script>
	$(document).ready(function() {
		var table = $('#submissionsTBL').DataTable({
				"order": [[ 3, "desc" ]]
		});
		$("#submissionsTBL tfoot th").each( function ( i ) {
			var select = $('<select><option value=""></option></select>').appendTo( $(this).empty() )
				.on( 'change', function () {
					if($(this).val().length > 0) {
						table.column( i ).search( '^'+$(this).val()+'$', true, false ).draw();
					} else {
						table.column( i ).search( '', true, false ).draw();
					}
				});
 
			table.column( i ).data().unique().sort().each( function ( d, j ) {
				select.append( '<option value="'+d+'">'+d+'</option>' )
			});
    	});
	});
	</script>

	<div class="myassets">
	<cfif queueType neq "user" or (queueType eq "user" and queueFltr neq session.mura.userid ) >
	<div id="queueList" class="navUtility">
		<cfoutput>
		<ul>
			<li id="queueinfo">
				<cfif queueType eq "user" >
					<cfset queueUsr = $.getUserInfo(queueFltr) />
					filtered by user "#queueUsr.fname#<!--- #queueUsr.lname# --->" 
				<cfelse>	
				quick filters 
				 </cfif>
				 : 
			</li>
			<cfif Len(Trim(queueType)) ><li id="queueinfo">[ <a href="#$.content().getURL()#">Clear</a> ]</li></cfif>
			
			<cfset fltrList = "open,accepted,rejected,all,unconverted" />
			<cfloop list="#fltrList#" index="fi">
				<cfif fi eq queueType >
					<li>#fi#</li>
				<cfelse>
					<li><a href="#$.content().getURL()#?queue=#fi#">#fi#</a></li>
				</cfif>
			</cfloop>
		</ul>
		</cfoutput>
	</div>
	</cfif>
	<cfif getAssets.RecordCount >
		<table id="submissionsTBL">
		<thead>
			<tr>
				<th>Asset Title</th>
				<th>Type</th>
				<th>Callout</th>
				<th>Submitted</th>
				<th>Status</th>
			</tr>	
		</thead>
		<tfoot>
			<tr>
				<th>Asset Title</th>
				<th>Type</th>
				<th>Callout</th>
				<th>Submitted</th>
				<th>Status</th>
			</tr>	
		</tfoot>
		<tbody>
		<cfoutput query="getAssets">
			<tr onclick="window.location.href='?asset=#uuid##passQueue#'">
				<td>#title#</td>
				<td>#type#</td>
				<td>#$.getPageName(callout)#</td>
				<td>#DateFormat(created, "mm/dd/yyyy")# #TimeFormat(created, "hh:mm tt")#</td>
				<cfset statusData = $.getStatus(uuid) />
				<td>#statusData.statuscode#</td>
			</tr>
		</cfoutput>
		</tbody>
		</table>
	<cfelse>
		<div class="notfound">There are no assets available to list.</div>
	</cfif>
	</div>
</cffunction>

<cffunction name="renderAssetDetail">
	<cfargument name="thisAsset" type="string" required="true" default="-1"/>

	<cfset $.addToHTMLHeadQueue("/#$.siteConfig('siteid')#/includes/display_objects/custom/unity_jslib.cfm")>

	<cfset var currentUser = session.mura.userid >

	<cfif StructKeyExists(form, "status") >
		<cfoutput>#saveJudgement(form,arguments.thisAsset)#</cfoutput>
	<cfelseif StructKeyExists(url, "success") >
		<p class="success">You have successfully rated this asset.</p>
	</cfif>

	<cftry>
		<cfquery datasource="cah" name="getAssets">
		SELECT * FROM cah.asset 
		WHERE 	uuid = '#arguments.thisAsset#'
		</cfquery>

		<cfcatch><cfset getAssets = QueryNew("none") /></cfcatch>
	</cftry>

	<cfset statusData = $.getStatus(getAssets.uuid) />
	
	<script>
	function showStatusWin() {
		$('html, body').animate({
			scrollTop: $("#wkflStat").offset().top
		}, 1000);

		/*
		$('#wkflStat').delay(600).animate( { letterSpacing : "2", marginLeft : "15" }, 150 ).animate( { letterSpacing : "-1", marginLeft : "-25" }, 150 ).animate( { letterSpacing : "0", marginLeft : "0" }, 150 );
		*/
		$('#wkflStat').delay(600).animate( { width : "50%" }, 50 ).animate( { width : "100%" }, 100 ).animate( { width : "auto" }, 100 );
	}
	function showFeedbackForm(s) {
		if(s) {
			$('#judgement').html("<b style='color: green;'>APPROVE</b> this asset?");
			$('#feedbackForm').hide();
			$("#feedbackbox input[name='status']").val("Approved");
		} else {
			$('#feedbackForm').show();
			$('#judgement').html("<b style='color: red;'>REJECT</b> this asset?");
			$("#feedbackbox input[name='status']").val("Rejected");
		}
		$('#feedbackbox').fadeToggle('slow');
		$('#feedbackbox .inner').delay(100).slideToggle('fast', function() {
			var offset = $("#feedbackbox .inner").offset().top - 100;
			$('html, body').animate({
				scrollTop: offset
			 }, 100);
		});
		$('#unityPlayer').hide();
	}
	
	function hideFeedbackForm(s) {
		if(s) {
			$('#feedbackbox form')[0].reset();
		}
		$('#feedbackbox .inner').slideToggle('fast');
		$('#feedbackbox').delay(100).fadeToggle('slow');
		$('#unityPlayer').show();
	}

	<cfoutput>
	function showFeedbackWin(id,orig) {
		feedUrl = "/#$.siteConfig('siteid')#/includes/display_objects/custom/remote/ajax_feedback.cfm?siteid=#$.event('siteid')#&statusid=" + id;
		$.get(feedUrl, function(data) { 
			$('##fbContent').html(data); 
		});

		$('##viewfeedback').fadeToggle('slow');
		$('##viewfeedback .inner').delay(100).slideToggle('fast', function() {
			var offset = $("##viewfeedback .inner").offset().top - 100;
			$('html, body').animate({
				scrollTop: offset
			 }, 100);
		});
		$('##unityPlayer').hide();
	}
	function hideFeedbackWin() {
		$('##viewfeedback .inner').slideToggle('fast');
		$('##viewfeedback').delay(100).fadeToggle('fast', function() {
			var offset = $("##wkflStat").offset().top;
			$('html, body').animate({
				scrollTop: offset
			 }, 50);
		});
		
		$('##unityPlayer').show();
	}
	</cfoutput>
	</script>


	<div class="myassets">
	<cfif getAssets.RecordCount eq 1 >
		<cfoutput>

		<div id="feedbackbox" style="display: none;">
			<div class="inner" style="display: none;">
				<div class="fancyborder">
				<form action="" id="" method="post">
					<div id="judgement"></div>
					<div id="feedbackForm">
					<select name="quickfeedback">
						<option value="">Common Issues (Optional)</option>
						<cfset issues = application.feedManager.readByName("[ Issues ]", request.siteid) />
						<cfset qIssues = issues.getQuery() />
						<cfloop query="qIssues">
							<option value="#contentid#">#MENUTITLE#</option>
						</cfloop>
					</select>
					<textarea name="feedback" placeholder="Enter Feedback"></textarea>
					</div>
					<div><input type="submit" value="Levy Judgement"><input type="button" value="Cancel" onclick="hideFeedbackForm(1);"></div>
					<cfif $.currentUser().isInGroup("Developer") >
						<input type="hidden" name="reviewtype" value="dev">
					<cfelseif $.currentUser().isInGroup("Reviewer") >
						<input type="hidden" name="reviewtype" value="peer">
					<cfelse>
						<input type="hidden" name="reviewtype" value="ERROR">
					</cfif>
					<input type="hidden" name="status" value="">
				</form>
				</div>
			</div>
		</div>
		
		<div id="viewfeedback" style="display: none;">
			<div class="inner" style="display: none;">
				<div class="fancyborder">
					<div><button id="closeFeedback" onclick="hideFeedbackWin();">Close</button></div>
					<div id="fbContent"></div>
				</div>
			</div>
		</div>

		<cfif Len(Trim($.event('queue'))) >
			<cfset passQueue = "?queue=#$.event('queue')#" />
		<cfelse>
			<cfset passQueue = "" />
		</cfif>
		
		<a class="actionItem" href="#$.content().getURL()##passQueue#">Return to List</a>
		<dl>
			<dt>Title</dt>
			<dd>#getAssets.title# &nbsp;</dd>

			<dt>Status </dt>
			<dd>
				<div id="statText" onclick="showStatusWin()" class="#iif(ArrayLen(statusData.devs.fail) or ArrayLen(statusData.peers.fail), de("statFail"), de(""))#"><u>#statusData.status#</u> <b>(#statusData.statuscode#)</b></div>
			</dd>

			<dt>Type</dt>
			<dd>#getAssets.type# &nbsp;</dd>

			<dt>Callout</dt>
			<dd>#$.getPageName(getAssets.callout)# &nbsp;</dd>
	
			<dt>
				Description 

				<div id="ratebox">
				<cfset thisApproved = StructFindValue(outStruct, session.mura.userid, "all") />
				<cfif ArrayLen(thisApproved) >
					<div class="message"><b class="#thisApproved[1].owner.status#">#thisApproved[1].owner.status#</b> by you on (#DateFormat(thisApproved[1].owner.created, "mm/dd/yyyy")#)</div>
				<cfelseif statusData.statuscode does not contain "open">
					<!--- // Show Nothing // --->
				<cfelseif ($.currentUser().isInGroup("Reviewer") or $.currentUser().isInGroup("Developer")) 
							and session.mura.userid neq getAssets.submitter >
					<button id="approveBTN" type="button" onclick="showFeedbackForm(1);"><label>Approve</label><div></div></button>
					<button id="rejectBTN" type="button" onclick="showFeedbackForm(0);"><label>Reject</label><div></div></button>
				</cfif>
				</div>

			</dt>
			<dd id="description">#getAssets.description# &nbsp;</dd>

			<dt class="preview">Preview</dt>
			<dd class="previewU3D">
				<div id="unityPlayer">
					<div class="missing">
					<a href="http://unity3d.com/webplayer/" title="Unity Web Player. Install now!">
						<img alt="Unity Web Player. Install now!" src="http://webplayer.unity3d.com/installation/getunity.png" width="193" height="63" />
					</a>
					</div>
				</div>
			</dd>

			<dt>Creator</dt>
			<cfset cUser = $.getUserInfo(getAssets.submitter) >
			<dd><a href="#$.content().getURL()#?queue=user|#getAssets.submitter#">#cUser.fname#<!--- #cUser.lname# ---></a> &nbsp;</dd>

			<dt>Submitted</dt>
			<dd>#DateFormat(getAssets.created, "mm/dd/yyyy")# &nbsp; #TimeFormat(getAssets.created, "hh:mm tt")#</dd>

			<dt>Asset ID</dt>
			<dd>#getAssets.uuid# &nbsp;</dd>
			
			<dt>Approvals</dt>
			<dd>

				<div id="wkflStat">
					<p>Peer Review:</p>
					<ul>
						<li class="pass">Approved:
							<ul>
							<cfif IsArray(statusData.peers.pass) and ArrayLen(statusData.peers.pass) >
								<cfloop index="pi" from="1" to="#ArrayLen(statusData.peers.pass)#">
									<cfset cUser = $.getUserInfo(statusData.peers.pass[pi].approver) >
									<li>#DateFormat(statusData.peers.pass[pi].created, "mm/dd/yyyy")# : #cUser.fname#<!--- #cUser.lname# ---></li>
								</cfloop>
							<cfelse>
								<li>None</li>
							</cfif>
							</ul>
						</li>
						<li class="reject">Rejected:
							<ul>
							<cfif IsArray(statusData.peers.fail) and ArrayLen(statusData.peers.fail) >
								<cfloop index="pi" from="1" to="#ArrayLen(statusData.peers.fail)#">
									<cfset cUser = $.getUserInfo(statusData.peers.fail[pi].approver) >
									<li onclick="showFeedbackWin('#statusData.peers.fail[pi].id#',this);">#DateFormat(statusData.peers.fail[pi].created, "mm/dd/yyyy")# : #cUser.fname#<!--- #cUser.lname# ---> <b>See Feedback</b></li>
								</cfloop>
							<cfelse>
								<li class="disable">None</li>
							</cfif>
							</ul>
						</li>
					</ul>
					<p>Developer Review:</p>
					<ul>
						<li class="pass">Approved:
							<ul>
							<cfif ArrayLen(statusData.devs.pass) >
								<cfloop index="di" from="1" to="#ArrayLen(statusData.devs.pass)#">
									<cfset cUser = $.getUserInfo(statusData.devs.pass[di].approver) >
									<li>#DateFormat(statusData.devs.pass[di].created, "mm/dd/yyyy")# : #cUser.fname#<!--- #cUser.lname# ---></li>
								</cfloop>
							<cfelse>
								<li>None</li>
							</cfif>
							</ul>
						</li>
						<li class="reject">Rejected:
							<ul>
							<cfif ArrayLen(statusData.devs.fail) >
								<cfloop index="di" from="1" to="#ArrayLen(statusData.devs.fail)#">
									<cfset cUser = $.getUserInfo(statusData.devs.fail[di].approver) >
									<li onclick="showFeedbackWin('#statusData.devs.fail[di].id#',this);">#DateFormat(statusData.devs.fail[di].created, "mm/dd/yyyy")# : #cUser.fname#<!--- #cUser.lname# ---> <b>See Feedback</b></li>
								</cfloop>
							<cfelse>
								<li class="disable">None</li>
							</cfif>
							</ul>
						</li>
					</ul>
				</div>				
			</dd>

		</dl>
		<a class="actionItem" href="#$.content().getURL()##passQueue#">Return to List</a>

		<script type="text/javascript">
		<!-- 
		function unityReady() {
		<cfif statusData.statuscode does not contain "[c]">
			u.getUnity().SendMessage("Rig", "LoadAsset", "#getAssets.viewer#");
		</cfif>
		}
		-->
		</script>

		</cfoutput>
	<cfelse>
		<div class="notfound">Unable to display asset.</div>
	</cfif>
	</div>
</cffunction>
	<!--- // END Displays // --->

<!--- // END Asset Workflow // --->


<!--- // Rollups // --->
<cffunction name="renderCycleByCat">
	<cfargument name="colFeed" type="string" required="false" default="[ Callouts ] Promos"/>
	<cfargument name="colImages" type="string" required="false" default="[ Callout Images ]"/>
	
	<cfset $.addToHTMLHeadQueue("/#$.siteConfig('siteid')#/includes/display_objects/custom/cycle_jslib.cfm")>
	
	<cfset var rtn = "">
	<cfset var feed = "">
	<cfset var iterator = "">
	<cfset var item = "">

	<cfset sldImg = "#$.siteConfig('themeAssetPath')#/images/cah/slide-general-default.png" />

	<cfset imgs=$.getBean("feed").loadBy(name=arguments.colImages,siteID=$.event("siteid")) />
	<cfset itImage=imgs.getIterator() />
	<cfset imgStore = StructNew() />
	<cfif itImage.hasNext()>
		<cfscript>
		while(itImage.hasNext()) {
			imgItem = itImage.next();
			// Set Cat Name and Default
			if (Len(Trim(imgItem.getValue('remoteCatSlide')))) {
				catName = imgItem.getValue('remoteCatSlide');
			} else {
				catName = "imgDefault";
			}
			
			// Determine Image to Use 
			if (Len(Trim(imgItem.getImageUrl('cycle')))) {
				catUrl = imgItem.getImageUrl('cycle');
			} elseif (Len(Trim(imgItem.getBody())) and imgItem.getBody() does not contain "<p>") {
				catUrl = imgItem.getBody();
			} else {
				catUrl = sldImg;
			}

			if (NOT StructKeyExists(imgStore, catName)) {
				tmpArray = ArrayNew();
				ArrayAppend(tmpArray, catUrl);
				StructInsert(imgStore, catName, Duplicate(tmpArray));
			} else {
				tmpArray = StructFind(imgStore, catName);
				ArrayAppend(tmpArray, catUrl);
				StructUpdate(imgStore, catName, Duplicate(tmpArray));
			}
		}
		</cfscript>
	</cfif>

	<cfset feed=$.getBean("feed").loadBy(name=arguments.colFeed,siteID=$.event("siteid")) />
	<cfset itFeed=feed.getIterator() />


	<cfsavecontent variable="rtn">
		<script>
		function newsClick(url, target, param){
			if (!target.length || target == "_self") {
				window.location.href = url;
			}
			else {
				newsOpen = window.open(url, target);
				newsOpen.focus();
			}
		}
		</script>

		<cfoutput>
			<cfif itFeed.hasNext()>
			<div id="homehero" class="stonebordersm">
				<div class="cycle-slideshow" 
						data-cycle-fx="fade" 
						data-cycle-pause-on-hover="true" 
						data-cycle-speed="1500"
						data-cycle-manual-speed="700"
						data-cycle-timeout="7500"
				    	data-cycle-swipe="true"
						data-cycle-swipe-fx="scrollHorz"
						data-cycle-caption-plugin="caption2"
						data-cycle-overlay-fx-sel=">div"
						data-cycle-overlay-fx-in="fadeIn"
						data-cycle-overlay-fx-out="fadeOut"
						data-cycle-caption-fx-in="slideDown"
						data-cycle-caption-fx-out="slideUp"
				>
					<div class="cycle-prev"></div>
					<div class="cycle-next"></div>

					<cfloop condition="itFeed.hasNext()">
						<cfset item=itFeed.next()>
						<cfset makeClick = "newsClick('/index.cfm/#item.getValue('filename')#','#item.getValue('target')#','#item.getValue('targetparams')#');" >

						<cfif StructKeyExists(imgStore, item.getValue('remoteCat')) >
							<cfset thisCatImgs = StructFind(imgStore, item.getValue('remoteCat')) />
							<cfif IsArray(thisCatImgs) >
								<cfset lottery = RandRange(1, ArrayLen(thisCatImgs)) />
								<cfset curSldImg = thisCatImgs[lottery] />
							<cfelse>
								<cfset curSldImg = sldImg />
							</cfif>
						<cfelseif StructKeyExists(imgStore, "imgDefault") >
							<cfset thisCatImgs = StructFind(imgStore, "imgDefault") />
							<cfset lottery = RandRange(1, ArrayLen(thisCatImgs)) />
							<cfset curSldImg = thisCatImgs[lottery] />
						<cfelse>
							<cfset curSldImg = sldImg />
						</cfif>
						
						<cfif Len(Trim(item.getValue('title'))) and item.getValue('title') neq "<p></p>" >
							<cfset sldTitle = Replace(item.getValue('title'), """", "","all") />
						<cfelse>
							<cfset sldTitle = "Untitled" />
						</cfif>
						<cfif Len(Trim(item.getSummary())) and item.getSummary() neq "<p></p>" >
							<cfset sldDesc = Replace(item.getSummary(), """", "","all") />
						<cfelse>
							<cfset sldDesc = "<p>&nbsp;</p>" />
						</cfif>
						<img src="#curSldImg#" onclick="#makeClick#" data-cycle-title="#sldTitle#" data-cycle-desc="#sldDesc#">
					</cfloop>

					<div class="cycle-overlay"></div>
					<div class="cycle-caption"></div>
				</div>
			</div>
			</cfif>
		</cfoutput>

	</cfsavecontent>

	<cfreturn rtn >

</cffunction>

<cffunction name="renderCycle">
	<cfargument name="collection" type="string" required="false" default="[ Callouts ]"/>
	
	<cfset var rtn = "">
	<cfset var feed = "">
	<cfset var iterator = "">
	<cfset var item = "">
		
	<cfset $.addToHTMLHeadQueue("/#$.siteConfig('siteid')#/includes/display_objects/custom/cycle_jslib.cfm")>
		
	<cfsavecontent variable="rtn">
		<script>
		function newsClick(url, target, param){
			if (!target.length || target == "_self") {
				window.location.href = url;
			}
			else {
				newsOpen = window.open(url, target);
				newsOpen.focus();
			}
		}
		</script>

		<cfset feed=$.getBean("feed").loadBy(name=arguments.collection,siteID=$.event("siteid"))>
		<cfset iterator=feed.getIterator()>

		<cfoutput>
			<cfif iterator.hasNext()>
			<div id="homehero" class="stonebordersm">
				<div class="cycle-slideshow" 
						data-cycle-fx="fade" 
						data-cycle-pause-on-hover="true" 
						data-cycle-speed="1500"
						data-cycle-manual-speed="700"
						data-cycle-timeout="7500"
				    	data-cycle-swipe="true"
						data-cycle-swipe-fx="scrollHorz"
						data-cycle-caption-plugin="caption2"
						data-cycle-overlay-fx-sel=">div"
						data-cycle-overlay-fx-in="fadeIn"
						data-cycle-overlay-fx-out="fadeOut"
						data-cycle-caption-fx-in="slideDown"
						data-cycle-caption-fx-out="slideUp"
				>
					<div class="cycle-prev"></div>
					<div class="cycle-next"></div>

					<cfloop condition="iterator.hasNext()">
						<cfset item=iterator.next()>
						<cfset makeClick = "newsClick('/index.cfm/#item.getValue('filename')#','#item.getValue('target')#','#item.getValue('targetparams')#');" >
						<img src="#item.getImageUrl('cycle')#" onclick="#makeClick#" data-cycle-title="#Replace(item.getValue('title'), """", "","all")#" data-cycle-desc="#Replace(item.getSummary(), """", "","all")#">
					</cfloop>

					<div class="cycle-overlay"></div>
					<div class="cycle-caption"></div>
				</div>
			</div>
			</cfif>
		</cfoutput>

	</cfsavecontent>

	<cfreturn rtn >
</cffunction>

<cffunction name="getPageUrl" output="no" returntype="string">
	<cfargument name="pageid" type="string" required="true" default=""/>
	<cfargument name="siteid" type="string" default="#$.content('siteid')#"/>

	<cftry>
		<cfset outUrl=$.getBean("content").loadBy(contentID=arguments.pageid,siteID=arguments.siteid).getUrl() />
	
		<cfcatch type="any">
			<cfset outUrl = "/" />
		</cfcatch>
	</cftry>
	
	<cfreturn outUrl >
</cffunction>

<cffunction name="getPageName" output="no" returntype="string">
	<cfargument name="pageid" type="string" required="true" default="" />
	<cfargument name="siteid" type="string" default="#$.content('siteid')#" />

	<cftry>
		<cfset page=$.getBean("content").loadBy(remoteID=arguments.pageid,siteID=arguments.siteid).getMenuTitle() />
	
		<cfcatch type="any">
			<cfset page = "Unknown" />
		</cfcatch>
	</cftry>
	
	<cfreturn page >
</cffunction>

<cffunction name="getUserInfo" output="no" returntype="struct">
	<cfargument name="userid" type="string" required="true" default="" />

	<cftry>
		<cfset user=$.getBean("User").loadBy(userId=arguments.userid,siteID=$.content('siteid')).getAllValues() />
	
		<cfcatch type="any">
			<cfset user = StructNew() />
		</cfcatch>
	</cftry>
	
	<cfreturn user >
</cffunction>

<!--- // END Rollups // --->


<!--- // Overloaded // --->
<cffunction name="allowLink" output="false" returntype="boolean">
			<cfargument name="restrict" type="numeric"  default=0>
			<cfargument name="restrictgroups" type="string" default="" />
			<cfargument name="loggedIn"  type="numeric" default=0 />
			<cfargument name="rspage"  type="query" />
		
			<cfset var allowLink=true>
			<cfset var G = 0 />
			<cfif  arguments.loggedIn and (arguments.restrict)>
						<cfif arguments.restrictgroups eq '' or listFind(session.mura.memberships,'S2IsPrivate;#application.settingsManager.getSite(variables.event.getValue('siteID')).getPrivateUserPoolID()#') or listFind(session.mura.memberships,'S2')>
									<cfset allowLink=True>
							<cfelseif arguments.restrictgroups neq ''>
									<cfset allowLink=False>
									<cfloop list="#arguments.restrictgroups#" index="G">
										<cfif listFind(session.mura.memberships,'#G#;#application.settingsManager.getSite(variables.event.getValue('siteID')).getPublicUserPoolID()#;1')>
										<cfset allowLink=true>
										</cfif>
									</cfloop>
							</cfif>
			<cfelseif !arguments.loggedin and arguments.restrict>
				<cfset allowLink=false>
			</cfif>
			
		<cfreturn allowLink>
</cffunction>
<!--- // END Overloaded // --->

</cfcomponent>


