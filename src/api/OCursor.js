var Cursor = function () {
    this.x = 0;
    this.y = 0;
    this.colorR = 255;
    this.colorG = 255;
    this.colorB = 0;
    this.image = new Image();
    this.image.src = "images/cursors/radix_phantasma_normal_select.png";
};

Cursor.prototype.update = function (rect, evt) {
    this.x = evt.clientX - rect.left - 5;
    this.y = evt.clientY - rect.top - 5;
};

Cursor.prototype.draw = function (context) {
    context.drawImage(this.image, this.x, this.y);
};
