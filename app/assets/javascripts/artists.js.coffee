$ ->
  $('#artist_typeahead').typeahead(
      # source can be a function
      source: (typeahead, query) ->
        # this function receives the typeahead object and the query string
        $.getJSON '/artists/typeahead.json', {'name_like': query}, (data) =>
          # data must be a list of either strings or objects
          # data = [{'name': 'Joe', }, {'name': 'Henry'}, ...]
          typeahead.process(data)
      # if we return objects to typeahead.process we must specify the property
      # that typeahead uses to look up the display value
      property: 'name'
      onselect: (obj) ->
        $.get '/artists/'+obj.id+'/smallblock.html', (data) ->
          $('#artists_association').append(data)
    )

  $('#artists_association').on 'change', '.artist_label', (e) ->
    $(e.currentTarget).hide 'fast'
    $('#cancel_artists_deletions').addClass('btn-info').prop 'disabled', false

  $('#cancel_artists_deletions').on 'click', (e) ->
    $('#artists_association input:checkbox').prop 'checked', true
    $('#artists_association .artist_label').show 'fast'
    $('#cancel_artists_deletions').removeClass('btn-info').prop 'disabled', true