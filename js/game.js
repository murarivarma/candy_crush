var Game;

Game = {
  shapes: ["twitter", "bitbucket", "safari", "apple", "firefox", "slack"],
  randomShapeClass: function() {
    return "fa-" + Game.shapes[Math.floor(Math.random() * Game.shapes.length)];
  },
  populateCellsWithShapes: function() {
    return $.each($(".cell i"), function(i, element) {
      return $(element).addClass(Game.randomShapeClass);
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
  checkMatches: function() {
    return console.log("Checking Matches");
  },
  init: function() {
    Game.rowsCount = 0;
    Game.columnsCount = 0;
    Game.populateCellsWithShapes();
    Game.populateCellsWithCoordinates();
    return Game.checkMatches();
  }
};

$(function() {
  return Game.init();
});
