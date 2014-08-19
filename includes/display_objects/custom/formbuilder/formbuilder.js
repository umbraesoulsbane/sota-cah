/* Requires MURA default FormBuilder library (global.js)
 * and JQueryUI.
 * Extends Validation to Custom Form
 */
/* Not Needed with JqueryUI Tooltips
function muraFormbuilderValidateTip(fldid,act) {
	if($('#'+fldid).length) {
		if ($('#'+fldid).hasClass('err')) {
			msg = getValidationMessage($('#'+fldid).get(0),' is not correct.');
		} else {
			msg = '';				
		}
		$('#mura-formbuilder-errors').html(msg);
	}
} 
*/
function muraFormbuilderClearAlert(fldid) {
	if($('#'+fldid).length && $('#'+fldid).hasClass('err')) {
		$('#'+fldid).removeClass('err');
		$('#'+fldid).tooltip("destroy");
	}
} 
function mfbSetAlert(fldid) {
	if($('#'+fldid).length) {
		$('#'+fldid).addClass('err');
		$('#'+fldid).tooltip({ content: function() {
			return "<b class='alert'>!</b> " + getValidationMessage($('#'+fldid).get(0),' is not correct.');
			}, 
			show: { effect: "fade", delay: 200 },
			hide: { effect: "puff", delay: 200 },
			position: { my: "left center", at: "left-15 top-20" },
			tooltipClass: "mura-formbuilder-tooltip"
		});
	}
}


function validateForm(theForm) {
		var errors="";
		var setFocus=0;
		var started=false;
		var startAt;
		var firstErrorNode;
		var firstErrorID;
		var validationType='';
		var frmInputs = theForm.getElementsByTagName("input");	
		for (f=0; f < frmInputs.length; f++) {
		 theField=frmInputs[f];
		 validationType=getValidationType(theField);
		 
			if(theField.style.display==""){
				if(getValidationIsRequired(theField) && theField.value == "" )
					{	
						if (!started) {
						started=true;
						startAt=f;
						firstErrorNode="input";
						firstErrorID=theField.id;
						}
						mfbSetAlert(theField.id);						
						errors += theField.id;
						//errors += getValidationMessage(theField,' is required.');
						 			
					}
				else if(validationType != ''){
						
					if(validationType=='EMAIL' && theField.value != '' && !isEmail(theField.value))
					{	
						if (!started) {
						started=true;
						startAt=f;
						firstErrorNode="input";
						firstErrorID=theField.id;
						}
						mfbSetAlert(theField.id);
						errors += theField.id;
						//errors += getValidationMessage(theField,' must be a valid email address.');
					}
	
					else if(validationType=='NUMERIC' && isNaN(theField.value))
					{	
						if(!isNaN(theField.value.replace(/\$|\,|\%/g,'')))
						{
							theField.value=theField.value.replace(/\$|\,|\%/g,'');
	
						} else {
							if (!started) {
							started=true;
							startAt=f;
							firstErrorNode="input";
							firstErrorID=theField.id;
							}
							mfbSetAlert(theField.id);
							errors += theField.id;
							//errors += getValidationMessage(theField,' must be numeric.');
						}					
					}
					
					else if(validationType=='REGEX' && theField.value !='' && hasValidationRegex(theField))
					{	
						var re = new RegExp(getValidationRegex(theField));
						if(!theField.value.match(re))
						{
							if (!started) {
							started=true;
							startAt=f;
							firstErrorNode="input";
							firstErrorID=theField.id;
							}
							mfbSetAlert(theField.id);
							errors += theField.id;
							//errors += getValidationMessage(theField,' is not valid.');
						}					
					}
					else if(validationType=='MATCH' 
							&& hasValidationMatchField(theField) && theField.value != theForm[getValidationMatchField(theField)].value)
					{	
						if (!started) {
						started=true;
						startAt=f;
						firstErrorNode="input";
						firstErrorID=theField.id;
						}
						mfbSetAlert(theField.id);
						errors += theField.id;
						//errors += getValidationMessage(theField, ' must match' + getValidationMatchField(theField) + '.' );
					}
					else if(validationType=='DATE' && theField.value != '' && !isDate(theField.value))
					{
						if (!started) {
						started=true;
						startAt=f;
						firstErrorNode="input";
						firstErrorID=theField.id;
						}
						mfbSetAlert(theField.id);
						errors += theField.id;
						//errors += getValidationMessage(theField, ' must be a valid date [MM/DD/YYYY].' );
					}
				}
					
			}
		}
		var frmTextareas = theForm.getElementsByTagName("textarea");	
		for (f=0; f < frmTextareas.length; f++) {
		
			
				theField=frmTextareas[f];
				validationType=getValidationType(theField);
				 
				if(theField.style.display=="" && getValidationIsRequired(theField) && theField.value == "" )
				{	
					if (!started) {
					started=true;
					startAt=f;
					firstErrorNode="textarea";
					firstErrorID=theField.id;
					}
					mfbSetAlert(theField.id);
					errors += theField.id;
					//errors += getValidationMessage(theField, ' is required.' );		
				}	
				else if(validationType != ''){
					if(validationType=='REGEX' && theField.value !='' && hasValidationRegex(theField))
					{	
						var re = new RegExp(getValidationRegex(theField));
						if(!theField.value.match(re))
						{
							if (!started) {
							started=true;
							startAt=f;
							firstErrorNode="input";
							firstErrorID=theField.id;
							}
							mfbSetAlert(theField.id);
							errors += theField.id;
							//errors += getValidationMessage(theField, ' is not valid.' );
						}					
					}
				}
		}
		
		var frmSelects = theForm.getElementsByTagName("select");	
		for (f=0; f < frmSelects.length; f++) {
				theField=frmSelects[f];
				validationType=getValidationType(theField);
				if(theField.style.display=="" && getValidationIsRequired(theField) && theField.options[theField.selectedIndex].value == "-")
				{	
					if (!started) {
					started=true;
					startAt=f;
					firstErrorNode="select";
					firstErrorID=theField.id;
					}
					mfbSetAlert(theField.id);
					errors += theField.id;
					//errors += getValidationMessage(theField, ' is required.' );	
				}	
		}
		
		if(errors != ""){
			msg = "<b class='alert'>!</b> Form is incomplete. Please see highlighted fields.";
			$('#'+theForm.id+'err').html(msg);
			$('#'+theForm.id+'err').show();
			/*
			alert(errors);
			*/
			if(firstErrorNode=="input"){
				frmInputs[startAt].focus();
			}
			else if (firstErrorNode=="textarea"){
				frmTextareas[startAt].focus();
			}
			else if (firstErrorNode=="select"){
				frmSelects[startAt].focus();
			}

			
			return false;
		}
		else
		{
		    $('#'+theForm.id+'err').hide();
			return true;
		}

}
$.fn.scrollTo = function( target, options, callback ){
  if(typeof options == 'function' && arguments.length == 2){ callback = options; options = target; }
  var settings = $.extend({
    scrollTarget  : target,
    offsetTop     : 50,
    duration      : 500,
    easing        : 'swing'
  }, options);
  return this.each(function(){
    var scrollPane = $(this);
    var scrollTarget = (typeof settings.scrollTarget == "number") ? settings.scrollTarget : $(settings.scrollTarget);
    var scrollY = (typeof scrollTarget == "number") ? scrollTarget : scrollTarget.offset().top + scrollPane.scrollTop() - parseInt(settings.offsetTop);
    scrollPane.animate({scrollTop : scrollY }, parseInt(settings.duration), settings.easing, function(){
      if (typeof callback == 'function') { callback.call(this); }
    });
  });
}
