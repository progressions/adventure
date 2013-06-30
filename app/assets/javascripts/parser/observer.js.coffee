class window.Observer
  @init: ->
    Observer.show()

    $(".source").focus()
    $(".source").change ->
      raw = $(".source").val()
      $(".source").val("")
      $(".source").focus()

      parser = new Parser(raw)
      Observer.submit(parser)

  @show: ->
    $.ajax
      type: "GET"
      url: "/game/show"
      success: (data) ->
        Observer.update(data)

  @update: (data) ->
    output = $("<div>")

    console.log(data)
    if data["message"]
      message = $("<p>").html(data["message"])

      output.append(message)
    else
      room_name = $("<h3>").html(data["name"])
      room_description = $("<p>").html(data["description"])
      room_exits = $("<p>").html("Exits: " + data["exits"].join(",  "))
      console.log(data["exits"])

      output.append(room_name)
      output.append(room_description)
      output.append(room_exits)

    $(".output").prepend(output)

  @submit: (parser) ->
    $.ajax
      type: "POST"
      url: "/game/command"
      data:
        "command": parser.json()
      success: (data) ->
        Observer.update(data)
