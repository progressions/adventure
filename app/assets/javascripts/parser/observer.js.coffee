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

      Observer.submit(parser)


  @submit: (parser) ->
    $.ajax
      type: "POST"
      url: "/game/command"
      data: 
        "command": parser.json()

