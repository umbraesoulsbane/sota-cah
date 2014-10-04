<cfparam name="url.siteid" default="sota" />
<cfparam name="url.statusid" default="" />
<cfparam name="url.assetid" default="" />

<cfset $ = application.serviceFactory.getBean('$').init(url.siteid) />
<cfset defaultContent = "00000000000000000000000000000000001">
<cfset cBean = $.getBean('content').loadBy(contentid=defaultContent) />
<cfset temp = $.setContentBean(cBean) >
<cftry>
	<cfif Len(Trim(url.statusid)) >
		<cfset fbQry = $.getFeedback(statusid=url.statusid) />
	<cfelseif Len(Trim(url.assetid)) >
		<cfset fbQry = $.getFeedback(assetid=url.assetid) />
	<cfelse>
		<cfset fbQry = $.getFeedback() />
	</cfif>
	
	<cfcatch><cfset fbQry = QueryNew("id,assetid,statusid,created,message,commenter,quickmessage") /></cfcatch>
</cftry>

<!--- id,assetid,statusid,created,message,commenter,quickmessage --->		

<cfif fbQry.RecordCount >

<ul>
	<cfoutput query="fbQry">
	<li>
		<ul>
			<cfset cUser = $.getUserInfo(commenter) >
			<li class="feedbackFrom"><b>From:</b> #cUser.fname# <!--- #cUser.lname# ---> <p>#DateFormat(created, "mm/dd/yyyy")#</p></li>
			<cfif Len(Trim(quickmessage)) >
				<li class="feedbackQuick">#$.getPageName(quickmessage)# &nbsp; (<a href="#$.getPageUrl(quickmessage)#">more info</a>)</li>
			</cfif>
			<li class="feedbackMSG">#ParagraphFormat(message)#</li>
		</ul>
	</li>
	</cfoutput>
</ul>

<cfelse>
<p>Not Found</p>
</cfif>
