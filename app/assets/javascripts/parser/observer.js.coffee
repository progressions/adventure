class window.Observer
  @init: ->
    $(".source").focus()
    $(".source").change ->
      raw = $(".source").val()
      $(".source").val("")
      $(".source").focus()

      parser = new Parser(raw)
      Observer.update(parser.json())
      Observer.submit(parser)

  @update: (message) ->
    line = $("<p>").html(message)
    $(".output").append(line)

  @submit: (parser) ->
    $.ajax
      type: "POST"
      url: "/game/command"
      data:
        "command": parser.json()
      success: (data) ->
        Observer.update(data["message"])

