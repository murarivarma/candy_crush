var Game;

Game = {
  shapes: ["twitter", "bitbucket", "safari", "apple", "firefox", "slack"],
  randomShapeClass: function() {
    return "fa-" + Game.shapes[Math.floor(Math.random() * Game.shapes.length)];
  },
  init: function() {
    return $.each($(".cell i"), function(i, element) {
      return $(element).addClass(Game.randomShapeClass);
    });
  }
};

$(function() {
  return Game.init();
});
