var Screen = function () {
    this.canvas = document.createElement("canvas");
    this.context = this.canvas.getContext("2d");
    this.viewport = getViewport();
    this.cursor = new Cursor();
    this.width = (this.viewport.width % 2 === 0) ? this.viewport.width : this.viewport.width + 1;
    this.height = (this.viewport.height % 2 === 0) ? this.viewport.height : this.viewport.height + 1;
    this.resizing = false;
};

Screen.prototype = {
    initialize: function (viewport) {
        this.canvas.width = Game.screen.width;
        this.canvas.height = Game.screen.height;
        this.canvas.style.position = "absolute";
        this.canvas.style.zIndex = "1000";
        this.canvas.style.top = 0;
        this.canvas.style.left = 0;
        viewport.appendChild(this.canvas);
        window.onresize = function () {
            Game.screen.resize();
        };
        window.onmousemove = function (e) {
            Game.screen.cursor.update(Game.screen.canvas.getBoundingClientRect(), e);
        };
    },
    setWorld: function (world) {
        this.world = world;
        this.world.initialize(this.context);
    },
    update: function () {
        this.world.update();
    },
    clear: function () {
        this.context.clearRect(0, 0, this.canvas.width, this.canvas.height);
    },
    draw: function () {
        this.world.draw(this.context);
        this.cursor.draw(this.context);
    },
    resize: function () {
        if (TwoD.screen.resizing)
            return;
        TwoD.pause();
        TwoD.screen.resizing = true;
        setTimeout(function () {
            TwoD.screen.resizing = false;
            TwoD.screen.viewport = getViewport();
            TwoD.screen.width = (TwoD.screen.viewport.width % 2 === 0) ? TwoD.screen.viewport.width : TwoD.screen.viewport.width + 1;
            TwoD.screen.height = (TwoD.screen.viewport.height % 2 === 0) ? TwoD.screen.viewport.height : TwoD.screen.viewport.height + 1;
            TwoD.screen.canvas.width = TwoD.screen.width;
            TwoD.screen.canvas.height = TwoD.screen.height;
            TwoD.pause();
        }, TwoD.skipTicks);
    }
};