 <cfoutput>
	<div id="header" class="clearfix">
		<div class="quickmenu">
			<ul class="navUtility">
			<cfif Len(Trim(session.mura.username)) >
				<li><strong>Logged In [</strong> #HTMLEditFormat("#session.mura.username#")# <strong>]</strong></li>
				<li class="last"><a href="/?doaction=logout">Log Out</a></li>
			<cfelse>
				<li><a href="https://www.shroudoftheavatar.com/wp-login.php?action=register">Register</a></li>
				<li class="last"><a href="/?doaction=login">Log In</a></li>
			</cfif>
			</ul>
			<!--- Search Form - Not Used
			<form action="" id="searchForm">
			<fieldset>
				<input type="search" name="Keywords" id="txtKeywords" class="text" value="Search" onfocus="this.value=(this.value=='Search') ? '' : this.value;" onblur="this.value=(this.value=='') ? 'Search' : this.value;" />
				<input type="hidden" name="display" value="search" />
				<input type="hidden" name="newSearch" value="true" />
				<input type="hidden" name="noCache" value="1" />
				<!--- <input type="submit" class="submit" value="Go" />--->
			</fieldset>
			</form>
			--->
		</div>
		<div id="logoplate">
		<h1><a href="#$.createHREF(filename='')#" id="logo">#HTMLEditFormat($.siteConfig('site'))#</a></h1>

		<cf_CacheOMatic key="dspPrimaryNav#request.contentBean.getcontentID()#">
			#$.dspPrimaryNav(
				viewDepth="1",
				id="navPrimary",
				displayHome="Never",
				closePortals="true",
				showCurrentChildrenOnly="false"
				)#</cf_cacheomatic>
		</div>
	</div>
</cfoutput>

