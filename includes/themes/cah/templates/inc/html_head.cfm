<cfoutput>
<!DOCTYPE html>
<html>
<head>
	<meta name="viewport" content="width=device-width, user-scalable=yes">
	
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="description" content="#HTMLEditFormat($.getMetaDesc())#" />
	<meta name="keywords" content="#HTMLEditFormat($.getMetaKeywords())#" />
	<cfif request.contentBean.getCredits() neq ""><meta name="author" content="#HTMLEditFormat($.content('credits'))#" /></cfif>
	<meta name="generator" content="Mura CMS #$.globalConfig('version')#" />
	
	<meta name="robots" content="noindex, nofollow" />
	
	<title>#HTMLEditFormat($.content('HTMLTitle'))# - #HTMLEditFormat($.siteConfig('site'))#</title>

	<link rel="icon" href="#$.siteConfig('themeAssetPath')#/images/cah/favicon.ico" type="image/x-icon" />
	<link rel="shortcut icon" href="#$.siteConfig('themeAssetPath')#/images/cah/favicon.ico" type="image/x-icon" />

	<link rel="stylesheet" href="/#$.siteConfig('siteid')#/css/mura.css" type="text/css" media="all" />

	<link rel="stylesheet" href="#$.siteConfig('themeAssetPath')#/css/animate.css" type="text/css" media="all" />
	<script src="#$.siteConfig('themeAssetPath')#/js/animate.js"></script>
	
	<link rel="stylesheet" href="#$.siteConfig('themeAssetPath')#/css/sota.css" type="text/css" media="all" />
	<link rel="stylesheet" href="#$.siteConfig('themeAssetPath')#/css/sota-950.css" type="text/css" media="screen and (max-device-width: 949px)" />

	<script src="#$.siteConfig('themeAssetPath')#/js/jquery-1.11.0.min.js"></script>
	<cfinclude template="ie_conditional_includes.cfm" />
	
	<cfset rs=$.getBean('feedManager').getFeeds($.event('siteID'),'Local',true,true) />
	<cfloop query="rs">
	<link rel="alternate" type="application/rss+xml" title="#HTMLEditFormat($.siteConfig('site'))# - #HTMLEditFormat(rs.name)#" href="#XMLFormat('http://#cgi.http_host##$.globalConfig('context')#/tasks/feed/?feedID=#rs.feedID#')#" />
	</cfloop>

</head>

</cfoutput>