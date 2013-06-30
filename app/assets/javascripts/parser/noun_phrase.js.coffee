class window.NounPhrase
  articles: ["the", "a", "an"]

  constructor: (tokens) ->
    @noun_phrase = {}
    @noun_phrase["noun"] = tokens.pop()

    if $.inArray(tokens[0], @articles) >= 0
      @noun_phrase["article"] = tokens.shift()

    @noun_phrase["adjectives"] = tokens

    @noun_phrase

  data: ->
    @noun_phrase

  json: ->
    JSON.stringify(@data())


