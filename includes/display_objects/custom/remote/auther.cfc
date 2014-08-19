<cfcomponent  output="false">

<cffunction name="valUser" access="remote" returntype="any" output="no">
	<cfargument name="u" type="string" required="true" default=""/>
	<cfargument name="p" type="string" required="true" default=""/>
	
	<cfset lstUser = "butter,soap,fred,pam,jim,todd,dinky,submit1,submit2,submit3,review,review2,port">
	<cfset lstMod = "butter,soap,review,review2">
	<cfset lstPort = "todd,port">
	
	<cfif ListFind(lstUser,arguments.u) >
		<cfif ListFind(lstMod,arguments.u) >
			<cfset utype = "m" />
		<cfelseif ListFind(lstPort,arguments.u) >
			<cfset utype = "p" />
		<cfelse>
			<cfset utype = "u" />
		</cfif>
		<cfset rtn = {displayname="User #UCase(arguments.u)#", usertype="#utype#", email="none@right.now.org"} />
	<cfelse>
		<cfset rtn = StructNew() />
	</cfif>

	<cfreturn rtn />
	
</cffunction>

<cffunction name="valHeader" access="remote" returntype="any" output="yes">
	BODY:
	<cfdump var="#GetHttpRequestData().content#">
	<br/>
	RAW HEADERS:
	<cfdump var="#GetHttpRequestData().headers#">
	<br/>
	CF CGI:
	<cfdump var="#CGI#">	
</cffunction>

</cfcomponent>

