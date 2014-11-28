var Camera = function (player, zoom) {
    this.zoom = zoom;
    this.x = player.x;
    this.y = player.y;
    this.boundsX = (Game.width / 16) / this.zoom;
    this.boundsY = (Game.height / 14) / this.zoom;
};

Camera.prototype.update = function (player) {
    this.x = player.x;
    this.y = player.y;
};
