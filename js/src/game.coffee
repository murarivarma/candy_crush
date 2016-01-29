Game =
  shapes: ["twitter", "bitbucket", "safari", "apple", "firefox", "slack"]

  randomShapeClass: ->
    "fa-" + Game.shapes[Math.floor(Math.random()*Game.shapes.length)]

  populateCellsWithShapes: ->
    $.each $(".cell i"), (i, element) -> $(element).addClass Game.randomShapeClass

  populateCellsWithCoordinates: ->
      rowNo = 1
      colNo = 1
      $.each $("#board .row"), (i, row) ->
        colNo = 1
        $.each $(row).children('.cell'), (j, cell) ->
          cell.dataset.rowNo = rowNo;
          cell.dataset.colNo = colNo;
          colNo++
        rowNo++
      Game.rowsCount = rowNo - 1
      Game.columnsCount = colNo - 1
  checkMatches: ->
     console.log "Checking Matches"

  init: ->
    Game.rowsCount = 0
    Game.columnsCount = 0
    Game.populateCellsWithShapes()
    Game.populateCellsWithCoordinates()
    Game.checkMatches()
$ ->
  Game.init()
