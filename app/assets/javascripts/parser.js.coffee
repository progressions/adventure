class window.Parser
  prepositions: ["to", "into", "from"]

  constructor: (@raw) ->
    @raw = String(@raw).toLowerCase()
    @parse(@raw)

  parse: (raw) ->
    @tokens = raw.split(" ")
    @verb = @tokens.shift()

    @preposition_index = @parse_preposition(@tokens)
    @preposition = @tokens[@preposition_index]
    if @preposition
      @indirect_object = @parse_indirect_object(@tokens)
    @direct_object = @parse_direct_object(@tokens)

  parse_preposition: (tokens) ->
    preposition_index = -1
    $(@prepositions).each (i, preposition) ->
      pi = $.inArray(preposition, tokens)
      if pi >= 0
        preposition_index = pi

    preposition_index

  parse_direct_object: (tokens) ->
    if @preposition_index >= 0
      direct_object_tokens = tokens.slice(0, @preposition_index)
    else
      direct_object_tokens = tokens

    if direct_object_tokens.length > 0
      new NounPhrase(direct_object_tokens)

  parse_indirect_object: (tokens) ->
    indirect_object_tokens = tokens.slice(@preposition_index+1)

    new NounPhrase(indirect_object_tokens)

  data: ->
    data =
      "raw": @raw
      "verb": @verb

    if @direct_object
      data["direct_object"] = @direct_object.data()
    if @preposition
      data["preposition"] = @preposition
    if @indirect_object
      data["indirect_object"] = @indirect_object.data()

    data

  json: ->
    JSON.stringify(@data())

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

class window.Observer
  @init: ->
    $(".source").focus()
    $(".source").change ->
      raw = $(".source").val()
      $(".source").val("")
      $(".source").focus()

      parser = new Parser(raw)
      line = $("<p>").html(parser.json())
      $(".output").append(line)

