<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without
Mura CMS under the license of your choice, provided that you follow these specific guidelines:

Your custom code

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->

<cfif not isBoolean(variables.$.event('isBlocked'))>
	<cfset variables.$.event('isBlocked',false)>
</cfif>

<cfoutput>
<h4>Access Restricted</h4>
<br /><br />
<div id="svLoginContainer">

	#variables.$.content('summary')# <!--- The page summary can be used to show some content before the user has logged in. Outputs only if there is content in the summary field. --->

	<cfif variables.$.event('status') eq 'failed'>
		<cfif isDate(session.blockLoginUntil) and session.blockLoginUntil gt now()>
		<cfset variables.$.event('isBlocked',true) />
		<p id="loginMsg" class="error">#variables.$.rbKey('user.loginblocked')#</p>
		<cfelse>
		<p id="loginMsg" class="error">#variables.$.rbKey('user.loginfailed')#</p>
		</cfif>
	</cfif>

	<cfif not variables.$.event('isBlocked')>
	<div class="fixcenter">
	<div id="login" class="well clearfix">
		<div class="fancyborder">
		<#variables.$.getHeaderTag('subHead1')#>#variables.$.rbKey('user.signin')#</#variables.$.getHeaderTag('subHead1')#>
		<form action="<cfoutput>?nocache=1</cfoutput>" name="loginForm" method="post">
			<div class="left">
			<ol>
				<li class="control-group">
					<label class="control-label" for="txtUserName">#variables.$.rbKey('user.username')#</label>
					<input type="text" id="txtUserName" name="username" placeholder="#variables.$.rbKey('user.username')#" />
				</li>
				<li class="control-group">
					<label class="control-label" for="txtPassword">#variables.$.rbKey('user.password')#</label>
					<input type="password" id="txtPassword" name="password" placeholder="#variables.$.rbKey('user.password')#" />
				</li>
				<li class="control-group">
					<label class="checkbox" for="cbRemember"><input type="checkbox" id="cbRemember" class="checkbox first" name="rememberMe" value="1" />
					#variables.$.rbKey('user.rememberme')#</label>
				</li>
			</ol>
			</div>
			<div class="buttons">
				<input type="hidden" name="linkServID" value="#HTMLEditFormat(variables.$.event('linkServID'))#" />
				<input type="hidden" name="returnURL" value="#HTMLEditFormat(variables.$.event('returnURL'))#" />
				<input type="hidden" name="doaction" value="login" />
				<button type="submit" class="submit btn">#variables.$.rbKey('user.signin')#</button>
			</div>
		</form>
		</div>
	</div>
	</div>

		<cfif variables.$.event('doaction') eq 'sendlogin'>
			<cfset msg2=application.userManager.sendLoginByEmail(variables.$.event('email'), variables.$.event('siteID'),'#urlencodedformat(variables.$.event('returnURL'))#')>
		</cfif>

		<div id="forgot" class="well clearfix">
		<form name="form2" class="form-horizontal <cfif this.formWrapperClass neq "">#this.formWrapperClass#</cfif>" method="post" action="?nocache=1" id="sendLogin" onsubmit="return validate(this);" novalidate="novalidate">

			<legend>#variables.$.rbKey('user.forgetusernameorpassword')#</legend>
			<p>
			This site uses your login information from the Shroud of the Avatar main site. If you are unable to login, please use one of the following links:
			<ul>
				<li><a href="https://www.shroudoftheavatar.com/wp-login.php?action=register" target="_blank">Signup / Register</a></li>
				<li><a href="https://www.shroudoftheavatar.com/wp-login.php?action=lostpassword" target="_blank">Forgot Password / Username</a></li>
				<li><a href="https://www.shroudoftheavatar.com/?page_id=19##faq_18" target="_blank">Contact Support</a></li>
			</ul>
			</p>
			
<!---
			<p>#variables.$.rbKey('user.forgotloginmessage')#</p>

			<cfif isdefined('msg2')>
				<cfif FindNoCase('is not a valid',msg2)><div class="alert alert-error">#HTMLEditFormat(variables.$.siteConfig("rbFactory").getResourceBundle().messageFormat(variables.$.rbKey('user.forgotnotvalid'),variables.$.event('email')))#<cfelseif FindNoCase('no account',msg2)><div class="error">#HTMLEditFormat(variables.$.siteConfig("rbFactory").getResourceBundle().messageFormat(variables.$.rbKey('user.forgotnotfound'),variables.$.event('email')))#<cfelse><div class="alert">#variables.$.rbKey('user.forgotsuccess')#</cfif></div>
			</cfif>

			<div class="control-group">
				<label class="control-label" for="txtEmail">#variables.$.rbKey('user.email')#</label>
				<div class="controls">
					<input id="txtEmail" name="email" type="text" placeholder="#variables.$.rbKey('user.email')#" validate="email" required="true" message="#htmlEditFormat(variables.$.rbKey('user.emailvalidate'))#" />
				</div>
			</div>

			<div class="control-group">
				<div class="controls">
					<input type="hidden" name="doaction" value="sendlogin" />
					<input type="hidden" name="linkServID" value="#HTMLEditFormat(variables.$.event('linkServID'))#" />
					<input type="hidden" name="display" value="login" />
					<input type="hidden" name="returnURL" value="#HTMLEditFormat(variables.$.event('returnURL'))#" />
					<button type="submit" class="btn">#htmlEditFormat(variables.$.rbKey('user.getpassword'))#</button>
				</div>
			</div>

		</form>

		<cfif variables.$.siteConfig('ExtranetPublicReg')>
		<div id="notRegistered">
			<#variables.$.getHeaderTag('subHead1')#>#variables.$.rbKey('user.notregistered')# <a class="callToAction" href="#variables.$.siteConfig('editProfileURL')#&returnURL=#urlencodedformat(variables.$.event('returnURL'))#">#variables.$.rbKey('user.signup')#.</a></#variables.$.getHeaderTag('subHead1')#>
		</div>
		</cfif>

		<script type="text/javascript">
		<!--
		   document.getElementById("login").elements[0].focus();
		-->
		</script>
--->
		</div>
	</cfif>
</cfoutput>
</div>