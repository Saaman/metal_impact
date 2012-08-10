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