$(document).ready(function(){

  $('#new_user').live('ajax:error', function(evt, xhr, status, error){

  	alert(xhr.responseText);
    // Display the errors (i.e. an error partial or helper)
    try {
    	// Populate errorText with the comment errors
      errors = $.parseJSON(xhr.responseText);
    } catch(err) {
    	// If the responseText is not valid JSON (like if a 500 exception was thrown), populate errors with a generic error message.
      alert("Please reload the page and try again");
    }

    for ( error in errors ) {
    	//$(this).find('.control-group.'+error.).html(xhr.responseText);
    	//errorText += "<li>" + error + ': ' + errors[error] + "</li> ";
    	alert(error);
    }

  });
});