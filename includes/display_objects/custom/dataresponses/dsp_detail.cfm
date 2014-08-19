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

? Must not alter any default objects in the Mura CMS database and
? May not alter the default display of the Mura CMS logo within Mura CMS and
? Must not alter any files in the following directories.

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

<cfsilent>
<cfset variables.rsData=application.dataCollectionManager.read(request.responseid)/>
<cfif variables.formBean.getValue('ResponseDisplayFields') neq ''>
	<cfset variables.fieldnames=replace(listLast(variables.formBean.getValue('ResponseDisplayFields'),"~"),"^",",","ALL")/>
<cfelse>
	<cfset variables.fieldnames=variables.rsData.FieldList/>
	<!---
	<cfset variables.fieldnames=application.dataCollectionManager.getCurrentFieldList(variables.formBean.getValue('contentID'))/>
	--->
</cfif>
<cfset variables.fieldnames=variables.rsData.FieldList/>
<cfwddx action="wddx2cfml" input="#variables.rsData.data#" output="variables.info">

<cfset hideFields = "approved,rating,submitter">
<cfif $.content('subType') eq "myassets">
	<cfset variables.fieldnames = ListFilter(variables.fieldnames, function(o) {if (ListFindNoCase(hideFields, o) eq 0) return true; else return false;} ) /> 
	<cfset variables.fieldnames &= ",entered"/>
<cfelseif $.content('subType') eq "reviewer">
	<cfset variables.fieldnames &= ",entered"/>
</cfif>
<!---
approved
Asset Description
Asset Title
Asset Type
Callout
Preview Link
Rating
Submitter
review
URL to Asset Files
--->
</cfsilent>
<cfoutput>
<div id="dsp_detail" class="dataResponses">
<cfif $.content('subType') neq "myassets" and $.content('subType') neq "reviewer">
	<#variables.$.getHeaderTag('subHead1')#>#variables.$.content('title')#</#variables.$.getHeaderTag('subHead1')#>
</cfif>
<a class="actionItem" href="##" onclick="history.go(-1); return false;">Return to List</a>
</cfoutput>


<dl>
<cfset unityScript = "">
<cfloop list="#variables.fieldnames#" index="variables.f">
<cftry><cfset variables.fValue=variables.info['#variables.f#']><cfcatch><cfset variables.fValue=""></cfcatch></cftry>
	
<cfif $.content('subType') eq "myassets" or $.content('subType') eq "reviewer">

	<dt class=
		<cfif ListFindNoCase(getFBclasscss(variables.f,rsdata.formid),"fbPreview"," ") >
			"preview">
		<cfelse>
			"">
		</cfif>
		<cfoutput>#getFBFriendly(variables.f,rsdata.formid)#</cfoutput>
	</dt>
	<cfif variables.f eq "entered">
		<cfoutput>
		<dd>#DateFormat(variables.rsdata.entered, "mm/dd/yyyy")# #TimeFormat(variables.rsdata.entered, "hh:mm:ss tt")# </dd>
		</cfoutput>
	<cfelseif variables.f eq "reviewers">
		<cfoutput>
		<cfset showReview = true >
		<dd>
		<cfif ListLen(fvalue) >
			<cfif ListLen(fvalue) gt 4 >
				<cfset showReview = false >
			</cfif>
			<ul class="revApprove">
			<cfloop index="ri" from="1" to="#ListLen(fvalue)#">
				<li>#HTMLEditFormat(fvalue)#</li>
			</cfloop>
			</ul>
		<cfelse>
			None<br /><br />
		</cfif>
			<cfif showReview and $.currentUser().isInGroup('reviewer') ><a href="##" class="button">Yes / No</a></cfif></dd>
		</cfoutput>
	<cfelseif variables.f eq "approved">
		<cfoutput>
		<dd>
		<cfif Len(Trim(fvalue)) >
			#HTMLEditFormat(fvalue)#
		<cfelse>
			No <br /><br /><cfif $.currentUser().isInGroup('developer') ><a href="##" class="button">Approve</a></cfif></dd>
		</cfif>
		</dd>
		</cfoutput>
	<cfelseif ListFindNoCase(getFBclasscss(variables.f,rsdata.formid),"fbLink"," ") >
		<cfoutput>
		<dd><a href="#fvalue#" class="button" alt="#HTMLEditFormat(fvalue)#" target="_blank">Download</a></dd>
		</cfoutput>
	<cfelseif ListFindNoCase(getFBclasscss(variables.f,rsdata.formid),"fbPreview"," ") >
		<dd class=
		<cfif ListFindNoCase("gif,png,jpg,jpeg",Right(Trim(fvalue),3)) >
			"previewIMG">
			<cfoutput>
			<img src="#fvalue#" style="width: 640px;" /></dd>
			</cfoutput>
		<cfelseif FindNoCase("youtube.com", fvalue) or FindNoCase("youtu.be", fvalue) >
			"previewVID">
			<cfif not FindNoCase("embed", fvalue) >
				<cfset fvalue = "//www.youtube.com/embed/" & ListLast(fvalue, "/") />
			</cfif>
			<cfoutput>
			<iframe width="640" height="360" src="#fvalue#" frameborder="0" allowfullscreen></iframe></dd>
			</cfoutput>
		<cfelseif FindNoCase("vimeo.com", fvalue) or FindNoCase("youtu.be", fvalue) >
			"previewVID">
			<cfoutput>
			<cfif not FindNoCase("player", fvalue) >
				<cfset fvalue = "//player.vimeo.com/video/" & ListLast(fvalue, "/") />
			</cfif>
				<iframe src="#fvalue#" width="640" height="360" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe></dd>
			</cfoutput>
		<cfelseif Right(Trim(fvalue),7) eq "unity3d" >
			"previewU3D">

			<cfsavecontent variable="unityScript">
		<script type="text/javascript">
		<!--
		var unityObjectUrl = "http://webplayer.unity3d.com/download_webplayer-3.x/3.0/uo/UnityObject2.js";
		if (document.location.protocol == 'https:')
			unityObjectUrl = unityObjectUrl.replace("http://", "https://ssl-");
		document.write('<script type="text\/javascript" src="' + unityObjectUrl + '"><\/script>');
		-->
		</script>
		<script type="text/javascript">
		<!--
			var config = {
				width: 640, 
				height: 360,
				params: { enableDebugging:"0" }
				
			};
			var u = new UnityObject2(config);
			
			jQuery(function() {

				var $missingScreen = jQuery("#unityPlayer").find(".missing");
				var $brokenScreen = jQuery("#unityPlayer").find(".broken");
				$missingScreen.hide();
				$brokenScreen.hide();

				u.observeProgress(function (progress) {
					switch(progress.pluginStatus) {
						case "broken":
							$brokenScreen.find("a").click(function (e) {
								e.stopPropagation();
								e.preventDefault();
								u.installPlugin();
								return false;
							});
							$brokenScreen.show();
						break;
						case "missing":
							$missingScreen.find("a").click(function (e) {
								e.stopPropagation();
								e.preventDefault();
								u.installPlugin();
								return false;
							});
							$missingScreen.show();
						break;
						case "installed":
							$missingScreen.remove();
						break;
						case "first":
						break;
					}
				});
				u.initPlugin(jQuery("#unityPlayer")[0], <cfoutput>"#fvalue#"</cfoutput>);
			});
		-->
		</script>
			</cfsavecontent>
			<div id="unityPlayer"></div></dd>
		<cfelse>
			previewNone">
			NO PREVIEW AVAILABLE
			<!---
			<img src="#fvalue#" style="width: 100%;" /
			--->
			</dd>
		</cfif>
		
		</dd>
	<cfelse>
		<dd><cfoutput><cfif fvalue eq "-">N/A<cfelse>#HTMLEditFormat(fvalue)#</cfif></cfoutput></dd>
	</cfif>


<cfelse>
	<cfoutput>
	<dt>#getFBFriendly(variables.f,rsdata.formid)#</dt>
	<dd>#HTMLEditFormat(fvalue)#</dd>
	</cfoutput>
</cfif>

</cfloop>
</dl>

<cfoutput>#unityScript#</cfoutput>
</div>


<!---
<div id="" style="overflow:scroll; height:400px;">
<cfdump var="#rsdata#"/>
</div>
--->


