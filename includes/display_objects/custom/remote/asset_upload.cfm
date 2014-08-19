<cfsilent>
<cfparam name="url.siteid" default="sota" />
<cfset rawURL = "" />
<cfset rtn 				= StructNew() />
	<cfset rtn.err 		= false />
	<cfset rtn.errMsg 	= "" />
	<cfset rtn.url 		= "" />
	
<cftry>
	<!--- simple test for form existance --->
	<cfif StructIsEmpty(form) or NOT StructKeyExists(form,"assetid") >
		<cfset rtn.err 		= true />
		<cfset rtn.errMsg 	= "Form data not available." />
	<cfelse>
		<!--- upload process --->
		<cftry>
			<cfset $ = application.serviceFactory.getBean('$').init(url.siteid) />
		
			<cfset rawPath = "/assets/uploads/" />
			<cffile action="upload" filefield="file" destination="#ExpandPath($.siteConfig('assetPath') & rawPath)#" nameconflict="overwrite" />
				
			<cfset rawFile = form.assetid & "." & cffile.serverFileExt />
				
			<cfif cgi.https eq "on">
				<cfset rawProto = "https://" />
			<cfelse>
				<cfset rawProto = "http://" />
			</cfif>
		
			<cffile action="rename" 
					source="#ExpandPath($.siteConfig('assetPath') & rawPath & cffile.serverFile)#" 
					destination="#ExpandPath($.siteConfig('assetPath') & rawPath & rawFile)#" />
		
			<cfset rawURL = rawProto & $.siteConfig('domain') & $.siteConfig('assetPath') & rawPath & rawFile />

			<cfcatch type="any">
				<cfset rtn.err 		= true />
				<cfset rtn.errMsg 	= "Problem uploading file. (#cfcatch.message#)" />
		  	</cfcatch>
		</cftry>

	</cfif>

	<cfcatch type="any">
		<cfset rtn.err 		= true />
		<cfset rtn.errMsg 	= "Form data not available. (#cfcatch.message#)" />
  	</cfcatch>
</cftry>

<!--- set rtn values --->
<cftry>
	<cfif NOT rtn.err >
		<cfset rtn.url 		= rawURL />
	</cfif>				

	<cfcatch type="any">
		<cfset rtn.err 		= true />
		<cfset rtn.errMsg 	= "Cannot finish." />
		<cfset rtn.url 		= rawURL />
	</cfcatch>
</cftry>

</cfsilent><cfoutput>#SerializeJSON(rtn)#</cfoutput>