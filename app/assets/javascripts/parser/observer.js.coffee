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


