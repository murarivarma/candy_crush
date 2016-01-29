Game =
  shapes: ["twitter", "bitbucket", "safari", "apple", "firefox", "slack"]

  randomShapeClass: ->
    "fa-" + Game.shapes[Math.floor(Math.random()*Game.shapes.length)]

  init: ->
    $.each $(".cell i"), (i, element) -> $(element).addClass Game.randomShapeClass

$ ->
  Game.init()
