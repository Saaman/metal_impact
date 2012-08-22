var SITE = SITE || {};

SITE.fileInputs = function() {
  var $this = $(this),
      $val = $this.val(),
      valArray = $val.split('\\'),
      newVal = valArray[valArray.length-1],
      $button = $this.siblings('.file-button')
  $this.siblings('.file-holder').remove()
  if(newVal !== '') {
  	$button.after('<div class="file-holder">' + newVal + '</div>');
  }
};

$(document).ready(function() {
  $('.file-wrapper input[type=file]').bind('change focus click', SITE.fileInputs);
});