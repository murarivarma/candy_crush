Game =
  shapes: ["twitter", "bitbucket", "safari", "apple", "firefox", "slack"]

  randomShapeClass: ->
    "fa-" + Game.shapes[Math.floor(Math.random()*Game.shapes.length)]

  populateCellsWithShapes: ->
    $.each $(".cell i"), (i, element) -> $(element).addClass(Game.randomShapeClass).addClass('animated').addClass('infinite')

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
  fetchCell: (rowNo, colNo) ->
    selector = ".cell"
    selector += "[data-row-no='#{rowNo}']"
    selector += "[data-col-no='#{colNo}']"
    $(selector)
  coordinatesOfCell: (cell) ->
    rowNo = parseInt(cell.dataset.rowNo)
    colNo = parseInt(cell.dataset.colNo)
    [rowNo, colNo]
  highlightCell: (cell) ->
    $(cell).children('i').addClass('flash')
  possibleSwapsForClick: (cell) ->
    if Game.selectedCell == null
      Game.selectCell(cell)
    else
      coords = Game.coordinatesOfCell(cell)
      rowNo = coords[0]
      colNo = coords[1]
      coords = Game.coordinatesOfCell(Game.selectedCell)
      orgRowNo = coords[0]
      orgColNo = coords[1]
      absDiff = [Math.abs(rowNo - orgRowNo), Math.abs(colNo - orgColNo)].sort()
      if absDiff[0] == 0 && absDiff[1] == 1
        console.log "Neighbour Clicked"
      else
        Game.deselectCell()
  selectCell: (cell) ->
    Game.selectedCell = cell
    $(cell).children('i').addClass('pulse')
    coords = Game.coordinatesOfCell(cell)
    rowNo = coords[0]
    colNo = coords[1]
    Game.highlightCell(Game.fetchCell(rowNo-1, colNo))
    Game.highlightCell(Game.fetchCell(rowNo+1, colNo))
    Game.highlightCell(Game.fetchCell(rowNo, colNo-1))
    Game.highlightCell(Game.fetchCell(rowNo, colNo+1))
  deselectCell: ->
    $('.cell i').removeClass('flash').removeClass('pulse')
    Game.selectedCell = null
  onClick: ->
    $('.cell').click ->
      Game.possibleSwapsForClick(@)
  checkMatches: ->
     console.log "Checking Matches"

  init: ->
    Game.rowsCount = 0
    Game.columnsCount = 0
    Game.deselectCell()
    Game.populateCellsWithShapes()
    Game.populateCellsWithCoordinates()
    Game.onClick()
    Game.checkMatches()
$ ->
  Game.init()
