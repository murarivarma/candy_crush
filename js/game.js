var Game;

Game = {
  shapes: ["twitter", "bitbucket", "safari", "apple", "firefox", "slack"],
  randomShapeClass: function() {
    return "fa-" + Game.shapes[Math.floor(Math.random() * Game.shapes.length)];
  },
  populateCellsWithShapes: function() {
    return $.each($(".cell i"), function(i, element) {
      return $(element).addClass(Game.randomShapeClass).addClass('animated').addClass('infinite');
    });
  },
  populateCellsWithCoordinates: function() {
    var colNo, rowNo;
    rowNo = 1;
    colNo = 1;
    $.each($("#board .row"), function(i, row) {
      colNo = 1;
      $.each($(row).children('.cell'), function(j, cell) {
        cell.dataset.rowNo = rowNo;
        cell.dataset.colNo = colNo;
        return colNo++;
      });
      return rowNo++;
    });
    Game.rowsCount = rowNo - 1;
    return Game.columnsCount = colNo - 1;
  },
  fetchCell: function(rowNo, colNo) {
    var selector;
    selector = ".cell";
    selector += "[data-row-no='" + rowNo + "']";
    selector += "[data-col-no='" + colNo + "']";
    return $(selector);
  },
  coordinatesOfCell: function(cell) {
    var colNo, rowNo;
    rowNo = parseInt(cell.dataset.rowNo);
    colNo = parseInt(cell.dataset.colNo);
    return [rowNo, colNo];
  },
  highlightCell: function(cell) {
    return $(cell).children('i').addClass('flash');
  },
  possibleSwapsForClick: function(cell) {
    var absDiff, colNo, coords, orgColNo, orgRowNo, rowNo;
    if (Game.selectedCell === null) {
      return Game.selectCell(cell);
    } else {
      coords = Game.coordinatesOfCell(cell);
      rowNo = coords[0];
      colNo = coords[1];
      coords = Game.coordinatesOfCell(Game.selectedCell);
      orgRowNo = coords[0];
      orgColNo = coords[1];
      absDiff = [Math.abs(rowNo - orgRowNo), Math.abs(colNo - orgColNo)].sort();
      if (absDiff[0] === 0 && absDiff[1] === 1) {
        Game.swapCells(Game.selectedCell, cell);
      }
      return Game.deselectCell();
    }
  },
  candyInCell: function(cell) {
    return $(cell).children('i');
  },
  findShapeClassOfCandy: function(candy) {
    return candy.attr('class').split(" ").find(function(classname) {
      return classname.match(/fa\-/) != null;
    });
  },
  swapCells: function(c1, c2) {
    var child1, child2, classname1, classname2;
    child1 = Game.candyInCell(c1);
    child2 = Game.candyInCell(c2);
    classname1 = Game.findShapeClassOfCandy(child1);
    classname2 = Game.findShapeClassOfCandy(child2);
    child1.removeClass(classname1).addClass(classname2);
    child2.removeClass(classname2).addClass(classname1);
    return Game.checkMatches();
  },
  selectCell: function(cell) {
    var colNo, coords, rowNo;
    Game.selectedCell = cell;
    $(cell).children('i').addClass('pulse');
    coords = Game.coordinatesOfCell(cell);
    rowNo = coords[0];
    colNo = coords[1];
    Game.highlightCell(Game.fetchCell(rowNo - 1, colNo));
    Game.highlightCell(Game.fetchCell(rowNo + 1, colNo));
    Game.highlightCell(Game.fetchCell(rowNo, colNo - 1));
    return Game.highlightCell(Game.fetchCell(rowNo, colNo + 1));
  },
  deselectCell: function() {
    $('.cell i').removeClass('flash').removeClass('pulse');
    return Game.selectedCell = null;
  },
  onClick: function() {
    return $('.cell').click(function() {
      return Game.possibleSwapsForClick(this);
    });
  },
  checkMatches: function() {
    var checkingColNo, checkingRowNo, checkingShape, currentCandy, currentCell, currentLength, currentShape, results;
    console.log("checkMatches");
    checkingRowNo = Game.rowsCount;
    checkingColNo = 1;
    checkingShape = null;
    currentLength = 0;
    results = [];
    while (checkingColNo <= Game.columnsCount) {
      currentCell = Game.fetchCell(checkingRowNo, checkingColNo);
      currentCandy = Game.candyInCell(currentCell);
      currentShape = Game.findShapeClassOfCandy(currentCandy);
      if (checkingShape == null) {
        checkingShape = currentShape;
      }
      if (currentShape === checkingShape) {
        currentLength++;
      } else {
        if (currentLength > 2) {
          console.log("Length is greater : " + currentLength);
        }
        checkingShape = currentShape;
        currentLength = 1;
      }
      results.push(checkingColNo++);
    }
    return results;
  },
  init: function() {
    Game.rowsCount = 0;
    Game.columnsCount = 0;
    Game.deselectCell();
    Game.populateCellsWithShapes();
    Game.populateCellsWithCoordinates();
    Game.onClick();
    return Game.checkMatches();
  }
};

$(function() {
  return Game.init();
});
