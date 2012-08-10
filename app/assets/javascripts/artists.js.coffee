$ ->
  $('.typeahead').typeahead(
      # source can be a function
      source: (typeahead, query) ->
        # this function receives the typeahead object and the query string
        $.ajax(
          url: "/lookup/?q="+query
          # i'm binding the function here using CoffeeScript syntactic sugar,
          # you can use for example Underscore's bind function instead.
          success: (data) =>
            # data must be a list of either strings or objects
            # data = [{'name': 'Joe', }, {'name': 'Henry'}, ...]
            typeahead.process(data)
        )
      # if we return objects to typeahead.process we must specify the property
      # that typeahead uses to look up the display value
      property: "name"
    )

  $('.artist_label').on 'change', (e) ->
    $(e.delegateTarget).toggle 'fast'
    $('#cancel_artists_deletions').prop 'disabled', false

  $('#cancel_artists_deletions').on 'click', (e) ->
    $('#artists_association input:checkbox').prop 'checked', true
    $('#artists_association .artist_label').show()
    $('#cancel_artists_deletions').prop 'disabled', true