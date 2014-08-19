<cfsilent>
<cfset variables.strField = "" />	
<cfsavecontent variable="variables.strField">
	<cfoutput>
	#variables.$.dspObject_Include(thefile='/formbuilder/fields/dsp_label.cfm',field=arguments.field,dataset=arguments.dataset)#
	</label>
	<cfif $.content('subType') eq "myassets">
		<div id="#arguments.field.name#_container">
			<div id="#arguments.field.name#_ajax">Upload</div>
		</div>
		<div id="#arguments.field.name#_success" style="display: none;">Upload</div>
		<div id="#arguments.field.name#_attachment_container" class="ajaxalt">
			<div id="#arguments.field.name#_attachment_text">Alternatively you may provide a link to a cloud storage provider below:</div>
			<input type="text" name="#arguments.field.name#_attachment" onkeyup="valURL(this);" onblur="valURL(this);" oninput="valURL(this);" onpaste="valURL(this);" value="#arguments.field.value#"#variables.$.dspObject_Include(thefile='/formbuilder/fields/dsp_common.cfm',field=arguments.field,dataset=arguments.dataset)#	
		
	<cfelse>
		<input type="file" name="#arguments.field.name#_attachment" value="#arguments.field.value#"#variables.$.dspObject_Include(thefile='/formbuilder/fields/dsp_common.cfm',field=arguments.field,dataset=arguments.dataset)#	
	</cfif>
	</cfoutput>
</cfsavecontent>
</cfsilent>
<cfoutput>
#variables.strField#  />
<cfif $.content('subType') eq "myassets">
</div>
<script>
$(document).ready(function()
{
	var textERR 		= $("##extraerror");
	var submitBTN 		= $("input[type='submit']");
	var buttons 		= $(".buttons");
	var ajaxUpload		= $("###arguments.field.name#_ajax");
	var ajaxContainer	= $("###arguments.field.name#_container");
	var ajaxSuccess		= $("###arguments.field.name#_success");
	var inputAttach		= $("input[name='#arguments.field.name#_attachment']");
	var inputText		= $("###arguments.field.name#_attachment_text");
	
	submitBTN.attr('disabled','disabled');
	buttons.click(function() {
		textERR.html("<b  class='alert'>!</b> &nbsp; Please upload an asset first.");
		textERR.show();
	});

	ajaxUpload.uploadFile({
	allowedTypes:"unitypackage", 
	url:"/#$.siteConfig('siteid')#/includes/display_objects/custom/remote/asset_upload.cfm?siteid=#$.siteConfig('siteid')#",
	dynamicFormData: function() {
		var data ={ assetid:"#request.thisUUID#"}
		return data;
	},
	showFileCounter:false,
	onSuccess:function(files,data,xhr)
	{
		//files: list of files | data: response from server | xhr : jquer xhr object
		jsonData = $.parseJSON(data.trim());

		ajaxContainer.hide();
		if (jsonData.ERR) {
			ajaxSuccess.html("<div class='uploadFail'><b>Failed to Upload:</b><br>" + files + "<br>" + jsonData.ERRMSG + "<br><a href='javascript:resetUpload();'>Try Again</a></div>").show();
		} else {
			ajaxSuccess.html("<div class='uploadSuccess'><b>Successful Upload of:</b><br>" + files + "</div>").show();
		}
		
		inputAttach.val(jsonData.URL);
		if (!jsonData.ERR) {
			inputAttach.prop("readonly", true);
			inputAttach.addClass("disabled");
			inputText.html("Public link to your asset below:");
			submitBTN.removeAttr('disabled');
			buttons.unbind('click');
			textERR.hide();
		}
	},
	multiple:false,
	maxFileCount:1
	});
});
function resetUpload() {
	$("###arguments.field.name#_success").html("").hide();
	$("###arguments.field.name#_container").show();
}
function valURL(fld) {
	if (fld.value.length > 13 && fld.value.toLowerCase().substring(0, 4) == 'http') {
		$("input[type='submit']").removeAttr('disabled');
		$(".buttons").unbind('click');
	}
}
</script>
</cfif>
</cfoutput>