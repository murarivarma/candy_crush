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
        Game.swapCells(Game.selectedCell, cell)
      Game.deselectCell()
  candyInCell: (cell) ->
    $(cell).children('i')
  findShapeClassOfCandy: (candy) ->
    candy.attr('class').split(" ").find((classname) ->
      classname.match(/fa\-/)?)
  swapCells: (c1, c2) ->
    child1 = Game.candyInCell(c1)
    child2 = Game.candyInCell(c2)
    classname1 = Game.findShapeClassOfCandy(child1)
    classname2 = Game.findShapeClassOfCandy(child2)

    child1.removeClass(classname1).addClass(classname2)
    child2.removeClass(classname2).addClass(classname1)
    Game.checkMatches()
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
    console.log "checkMatches"
    checkingRowNo = Game.rowsCount
    checkingColNo = 1
    checkingShape = null
    currentLength = 0

    while checkingColNo <= Game.columnsCount
      currentCell = Game.fetchCell(checkingRowNo, checkingColNo)
      currentCandy = Game.candyInCell(currentCell)
      currentShape = Game.findShapeClassOfCandy(currentCandy)
      checkingShape = currentShape unless checkingShape?
      if currentShape == checkingShape
        currentLength++
      else
        if currentLength > 2
          console.log "Length is greater : #{currentLength}"
          #Remove the matching elements
          #Bring down the elements
          #Populate blank cells with random shapes
          #Break the checking process
        checkingShape = currentShape
        currentLength = 1
      checkingColNo++
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
