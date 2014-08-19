<cfoutput>
<cfinclude template="inc/html_head.cfm" />
<body id="#$.getTopID()#" class="home depth#arrayLen($.event('crumbdata'))#">
<div id="container" class="#$.createCSSid($.content('menuTitle'))#">
	<cfinclude template="inc/header.cfm" />
	<div id="content" class="clearfix">
		<div id="engrave">
			<div id="primary" class="article">
				<!---
				#$.dspCrumbListLinks("crumbList","&nbsp;&raquo;&nbsp;")#
				<cfset thisTitle = "">
				<cfif $.content('title') neq "home">
					<cfset thisTitle = $.content('title') >
				</cfif>
				--->
				#$.dspBody(body=$.content('body'),crumbList=false,showMetaImage=true,metaImageSizeArgs={size="callout"})#
				#$.dspObjects(1)#
				#$.dspObjects(2)#
				#$.dspObjects(3)#
				<div id="flareBG"></div>
			</div>

		<cfinclude template="inc/footer.cfm" />
		</div>
	</div>

	
</div>
</body>
</html>
</cfoutput>