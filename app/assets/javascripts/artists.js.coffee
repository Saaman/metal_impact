add_artist_block = (artist_id) ->
  $.get '/artists/'+artist_id+'/smallblock.html', (data) ->
    $('#artists_association').append(data)

$ ->
  $('#artist_typeahead').typeahead(
      # source can be a function
      source: (typeahead, query) ->
        $.getJSON '/artists/search.json', {'name_like': query, 'for-product': $('#artist_typeahead').data("product-type")}, (data) =>
          # data must be a list of either strings or objects
          typeahead.process(data)
      # if we return objects to typeahead.process we must specify the property
      # that typeahead uses to look up the display value
      property: 'name'
      onselect: (obj) ->
        add_artist_block obj.id
    )

  #hide artist label when unchecking artist
  $('#artists_association').on 'change', 'div.artist_label', (e) ->
    $(e.currentTarget).hide 'fast'
    $('#cancel_artists_deletions').addClass('btn-info').prop 'disabled', false

  #undo all hides, reset screens with all artists shown
  $('#cancel_artists_deletions').on 'click', (e) ->
    $('#artists_association input:checkbox').prop 'checked', true
    $('#artists_association div.artist_label').show 'fast'
    $('#cancel_artists_deletions').removeClass('btn-info').prop 'disabled', true