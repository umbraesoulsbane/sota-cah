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
		
		<cfif $.siteConfig('assetdir') contains "/#$.siteConfig('siteid')#" >
			<cfset writePath = $.siteConfig('assetdir') />
		<cfelse>
			<cfset writePath = $.siteConfig('assetdir') & "/" & $.siteConfig('siteid') />
		</cfif>
		<cfif $.siteConfig('assetPath') contains "/#$.siteConfig('siteid')#" >
			<cfset readPath = $.siteConfig('assetPath') />
		<cfelse>
			<cfset readPath = $.siteConfig('assetPath') & "/" & $.siteConfig('siteid') />
		</cfif>
		
		<cfset rawPath = "/assets/uploads/" />
		<cffile action="upload" filefield="file" destination="#ExpandPath(writePath & rawPath)#" nameconflict="overwrite" />
				
		<cfset rawFile = form.assetid & "." & cffile.serverFileExt />
				
		<cfif cgi.https eq "on">
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