SITE = SITE || {}

SITE.fileInputs = ->
  $this = $(this)
  $val = $this.val()
  valArray = $val.split '\\'
  newVal = valArray[valArray.length-1]
  $button = $this.siblings '.file-button'
  $this.siblings('.file-holder').remove()
  if newVal isnt ''
  	$button.after '<span class="file-holder">' + newVal + '</span>'

$ ->
  $('.file-wrapper input[type=file]').bind 'change focus click', SITE.fileInputs