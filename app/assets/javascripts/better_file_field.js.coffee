SITE = SITE || {}

SITE.fileInputs = ->
  $this = $(this)
  $val = $this.val()
  valArray = $val.split '\\'
  newVal = valArray[valArray.length-1]
  $button = $this.siblings 'button.file-button'
  $this.siblings('span.file-holder').remove()
  if newVal isnt ''
  	$button.after '<span class="file-holder">' + newVal + '</span>'

$ ->
  $('div.file-wrapper input[type=file]').bind 'change focus click', SITE.fileInputs