<cfsilent>
<cfparam name="url.siteid" default="sota" />
<cfset rawURL = "" />
<cfset rtn 				= StructNew() />
	<cfset rtn.err 		= false />
	<cfset rtn.errMsg 	= "" />
	<cfset rtn.url 		= "" />
	
<cftry>
	<!--- upload process --->
	<cftry>
		<cfset $ = application.serviceFactory.getBean('$').init(url.siteid) />
		
		<cfset writePath = $.globalConfig('assetdir') & "/" & $.siteConfig('siteid') />
		<cfset readPath = $.globalConfig('assetPath') & "/" & $.siteConfig('siteid') />
		<cfset rawPath = "/assets/uploads/" />

		<cffile action="upload" filefield="file" destination="#ExpandPath(writePath & rawPath)#" nameconflict="overwrite" />
				
		<cfset rawFile = form.assetid & "." & cffile.serverFileExt />

		<cfif Len($.globalConfig('assetPath')) gte 4 and Left($.globalConfig('assetPath'), 4) eq "http">
			<cfset rawProto = "" />
		<cfelseif cgi.https eq "on">
			<cfset rawProto = "https://" />
		<cfelse>
			<cfset rawProto = "http://" />
		</cfif>
		
		<cffile action="rename" 
				source="#ExpandPath(writePath & rawPath & cffile.serverFile)#" 
				destination="#ExpandPath(writePath & rawPath & rawFile)#" />
		
		<cfset rawURL = rawProto & $.siteConfig('domain') & readPath & rawPath & rawFile />

		<cfcatch type="any">
			<cfset rtn.err 		= true />
			<cfset rtn.errMsg 	= "Problem uploading file. (#Replace(cfcatch.message,$.siteConfig('assetdir'),"CENSOR","ALL")#)" />
	  	</cfcatch>
	</cftry>

	<cfcatch type="any">
		<cfset rtn.err 		= true />
		<cfset rtn.errMsg 	= "Critical Error. (#Replace(cfcatch.message,$.siteConfig('assetdir'),"CENSOR","ALL")#)" />
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