<!--- Be sure to reload Mura after adding methods here. A site's local eventHandler.cfc does not need to be init'd via appreload, only theme-specific ones (like this) --->
<cfcomponent extends="mura.cfobject" output="false">
	
	<cffunction name="onPageMyAssetsBodyRender" output="true">
		<cfargument name="event">
		<cfargument name="$">
			
		<cfoutput>
		<div #iif((IsBoolean($.content("hideList")) and NOT $.content("hideList")) or NOT IsBoolean($.content("hideList")), de("style='display: inline-block;'"), de(""))#>
		#$.content('body')#
		</div>

		<cfif (IsBoolean($.content("hideList")) and NOT $.content("hideList")) or NOT IsBoolean($.content("hideList")) >
		<div>
			<cfif Len(Trim($.event('asset'))) >
				#$.renderAssetDetail($.event('asset'))#
			<cfelse>
				<cfset thisQueue = "user|" & session.mura.userid />
				#$.renderAssetList(thisQueue)#
			</cfif>
		</div>
		</cfif>
		</cfoutput>
	</cffunction>

	<cffunction name="onPageSubmissionsBodyRender" output="true">
		<cfargument name="event">
		<cfargument name="$">
			
		<cfoutput>
		<div style="display: inline-block; width: 100%;">
		#$.content('body')#
		</div>

		<div>
			<cfif Len(Trim($.event('asset'))) >
				#$.renderAssetDetail($.event('asset'))#
			<cfelseif Len(Trim($.event('queue'))) >
				#$.renderAssetList(queue=$.event('queue'))#
			<cfelse>
				#$.renderAssetList()#
			</cfif>
		</div>

		</cfoutput>
	</cffunction>	

	<cffunction name="onPageCalloutsBodyRender" output="true">
		<cfargument name="event">
		<cfargument name="$">
			
		<cfoutput>
		<div>#$.renderCalloutDetail("[ Callouts ]")#</div>
		</cfoutput>
	</cffunction>
	
	<cffunction name="onFolderCalloutsBodyRender" output="true">
		<cfargument name="event">
		<cfargument name="$">
			
		<cfoutput>
		<div style="width: 100%; display: inline-block;">
		#$.content('body')#
		</div>

		<div>
			#$.renderCalloutList("[ Callouts ]")#
		</div>

		</cfoutput>
	</cffunction>

	<!--- // Login Overrides // --->
	<cffunction name="onSiteLogin" output="true">
		<cfargument name="event">
		<cfargument name="$">

		<cfset remoteVal = $.valRemoteUsr(form.username,form.password) />
	
		<cfif IsStruct(remoteVal) and StructKeyExists(remoteVal, "status_code") 
				and StructFind(remoteVal, "status_code") eq "200" >
			<cftry>
			<cfif StructKeyExists(remoteVal, "filecontent") and IsJson(remoteVal.filecontent) >
				<cfset rtnUser = DeserializeJson(remoteVal.filecontent) />
			<cfelse>
				<cfset rtnUser = StructNew() />
				<cfset rtnUser.nickname = form.username />
				<cfset rtnUser.cahperm = "" />
			</cfif>
	
				<cfcatch type="any">
					<cfset rtnUser = StructNew() />
					<cfset rtnUser.nickname = form.username />
					<cfset rtnUser.cahperm = "" />
				</cfcatch>
			</cftry>
	
			<!--- // Get Mura Groups for Site and Select Proper GroupID // --->
			<cfset groupsQry = application.userManager.getPublicGroups($.event('siteID')) />
			<cfquery dbtype="query" name="remoteMember">
			SELECT userid FROM groupsQry
			WHERE groupname = 
					<cfif rtnUser.cahperm eq "0" >
						'Reviewer'
					<cfelseif rtnUser.cahperm eq "1" >
						'Developer'
					<cfelse>
						'Submitter'
					</cfif>
			</cfquery>
	
			<!--- // Set Main User Struct // --->
			<cfset remoteUser = { 	found=true, 			fname=Left(rtnUser.nickname,50), 	lname=Right(rtnUser.nickname,50),
									username=form.username, remoteID=Left(rtnUser.nickname,35), email=form.username & "@cah.shroudoftheavatar.com",
									groupID=remoteMember.userid
								} />
		<cfelse>
			<!--- // Set Main User Struct // --->
			<cfset remoteUser = { 	found=false, 	fname="", 		lname="",
									username="", 	remoteID="", 	email="",
									groupID=""
								} />
		</cfif>
		<!--- // END Auth Selection END // --->

		<cfif remoteUser.found >
			<cfset userReady = false />
			<cftry>
				<cflock name="#$.event('siteID')##remoteUser.username#userBridge" timeout="30" type="exclusive">
					<cfset localUser=$.getBean("user").loadBy(username=remoteUser.username,siteID=$.event('siteid')) />
					
					<cfset localUser.setFName(remoteUser.fname) />
					<cfset localUser.setLName(remoteUser.lname) />
					<cfset localUser.setRemoteID(remoteUser.remoteid) />
					<cfset localUser.setEmail(remoteUser.email) />
					<cfset localUser.setlastUpdateBy('System') />
					<cfset localUser.setPassword(Hash(remoteUser.username & "-" & localUser.getValue('contentid'))) />
					<cfif Len(Trim(remoteUser.groupID)) >
						<cfset localUser.setGroupId(remoteUser.groupID) />
					</cfif>
					
					<cfif localUser.getIsNew() >
						<!--- user does not exist: create one --->
						<cfset localUser.setUsername(remoteUser.username) />
						<cfset localUser.setIsPublic(1) />
					</cfif>

					<cfset localUser.save() />

				</cflock>
						
				<cfset userReady = true />
				
				<cfcatch type="any">
					<cfset userReady = false />
				</cfcatch>
			</cftry>

			<cfif userReady >
				<!--- // Log the user in // --->
				<cfset $.event("username",localUser.getValue("username")) />
				<cfset $.event("password",localUser.getValue("password")) />
			<cfelse>
				<!--- // Fail User Login // --->
				<cfset $.event("password",CreateUUID()) />
			</cfif>
			
		<cfelse><!--- cfif remoteUser.found --->
			<!--- // Fail User Login // --->
			<cfset $.event("password",CreateUUID()) />
		</cfif><!--- cfif remoteUser.found --->

	</cffunction>


</cfcomponent>