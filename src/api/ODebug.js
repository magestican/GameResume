Debug = function () {
    this.updateStats = new Stats('update', 100);
    this.renderStats = new Stats('render', 100);
    this.gameTickbox = new GameTickbox();
    this.objCount = new ObjCount();
    this.worldInfo = new WorldInfo();
    this.camInfo = new CamInfo();
};

Debug.prototype = {
    initialize: function (viewport) {
        viewport.appendChild(this.updateStats.domElement);
        viewport.appendChild(this.renderStats.domElement);
        viewport.appendChild(this.gameTickbox.domElement);
        viewport.appendChild(this.objCount.domElement);
        viewport.appendChild(this.worldInfo.domElement);
        viewport.appendChild(this.camInfo.domElement);
        this.renderStats.position(this.updateStats.domElement.offsetHeight, 0);
        this.gameTickbox.position(0, this.updateStats.domElement.offsetWidth);
        this.objCount.position(this.gameTickbox.domElement.offsetHeight, this.updateStats.domElement.offsetWidth);
        this.worldInfo.position(42, this.updateStats.domElement.offsetWidth);
        this.camInfo.position(64, this.updateStats.domElement.offsetWidth);
    },
    update: function () {
        this.updateStats.update();

    },
    draw: function () {
        this.renderStats.update();
        this.gameTickbox.update();
        this.objCount.update();
        this.worldInfo.update();
        this.camInfo.update();
    }
};

var Stats = function (name, delay) {

    var id = name;
    var updateDelay = delay;
    var startTime = Date.now(), prevTime = startTime;
    var ms = 0, msMin = Infinity, msMax = 0;
    var fps = 0, fpsMin = Infinity, fpsMax = 0;
    var frames = 0, mode = 0;

    var container = document.createElement('div');
    container.id = 'debug-stats';
    container.className = 'debug ' + id;
    container.addEventListener('mousedown', function (event) {
        event.preventDefault();
        setMode(++mode % 2);
        msMin = Infinity;
        msMax = 0;
        fpsMin = Infinity;
        fpsMax = 0;
    }, false);
    container.style.cssText = 'width:120px;opacity:0.9;cursor:pointer;z-index:10000;position:absolute;';

    var fpsDiv = document.createElement('div');
    fpsDiv.id = 'fps';
    fpsDiv.style.cssText = 'padding:0 0 3px 3px;text-align:left;background-color:#002';
    container.appendChild(fpsDiv);

    var fpsText = document.createElement('div');
    fpsText.id = 'fpsText';
    fpsText.style.cssText = 'color:#0ff;font-family:Helvetica,Arial,sans-serif;font-size:9px;font-weight:bold;line-height:15px';
    fpsText.innerHTML = 'FPS';
    fpsDiv.appendChild(fpsText);

    var fpsGraph = document.createElement('div');
    fpsGraph.id = 'fpsGraph';
    fpsGraph.style.cssText = 'position:relative;width:112px;height:30px;background-color:#0ff';
    fpsDiv.appendChild(fpsGraph);

    while (fpsGraph.children.length < 112) {
        var bar = document.createElement('span');
        bar.style.cssText = 'width:1px;height:30px;float:left;background-color:#113';
        fpsGraph.appendChild(bar);
    }

    var msDiv = document.createElement('div');
    msDiv.id = 'ms';
    msDiv.style.cssText = 'padding:0 0 3px 3px;text-align:left;background-color:#020;display:none';
    container.appendChild(msDiv);

    var msText = document.createElement('div');
    msText.id = 'msText';
    msText.style.cssText = 'color:#0f0;font-family:Helvetica,Arial,sans-serif;font-size:9px;font-weight:bold;line-height:15px';
    msText.innerHTML = 'MS';
    msDiv.appendChild(msText);

    var msGraph = document.createElement('div');
    msGraph.id = 'msGraph';
    msGraph.style.cssText = 'position:relative;width:112px;height:30px;background-color:#0f0';
    msDiv.appendChild(msGraph);

    while (msGraph.children.length < 112) {
        var bar = document.createElement('span');
        bar.style.cssText = 'width:1px;height:30px;float:left;background-color:#131';
        msGraph.appendChild(bar);

    }

    var setMode = function (value) {
        mode = value;
        switch (mode) {
            case 0:
                fpsDiv.style.display = 'block';
                msDiv.style.display = 'none';
                break;
            case 1:
                fpsDiv.style.display = 'none';
                msDiv.style.display = 'block';
                break;
        }
    };

    var updateGraph = function (dom, value) {
        var child = dom.appendChild(dom.firstChild);
        child.style.height = value + 'px';

    };

    return {
        domElement: container,
        setMode: setMode,
        position: function (x, y) {
            container.style.top = x + "px";
            container.style.left = y + "px";
        },
        begin: function () {
            startTime = Date.now();
        },
        end: function () {

            //TODO min and max values shouldn't persist forever

            var time = Date.now();
            frames++;
            if (time > prevTime + updateDelay) {
                ms = time - startTime;
                msMin = Math.min(msMin, ms);
                msMax = Math.max(msMax, ms);

                msText.textContent = id + ' (' + msMin + '-' + msMax + ') ' + ms + ' MS';
                updateGraph(msGraph, Math.min(30, 30 - (ms / 200) * 30));

                fps = Math.round((frames * 1000) / (time - prevTime));
                fpsMin = Math.min(fpsMin, fps);
                fpsMax = Math.max(fpsMax, fps);

                fpsText.textContent = id + ' (' + fpsMin + '-' + fpsMax + ') ' + fps + ' FPS';
                updateGraph(fpsGraph, Math.min(30, 30 - (fps / 100) * 30));

                prevTime = time;
                frames = 0;
            }

            return time;

        },
        update: function () {
            startTime = this.end();
        }
    };
};

var GameTickbox = function () {

    var container = document.createElement('div');
    container.id = "debug-gameTickbox";
    container.style.cssText = 'width:120px;height:20px;opacity:0.9;cursor:pointer;z-index:10000;position:absolute;color:#FFFFFF;text-shadow:1px 1px #000000';

    return {
        domElement: container,
        position: function (x, y) {
            container.style.top = x + "px";
            container.style.left = y + "px";
        },
        update: function () {
            container.innerHTML = "T: " + Math.round(TwoD.tick);
        }
    };
};
var ObjCount = function () {

    var container = document.createElement('div');
    container.id = "debug-objCount";
    container.style.cssText = 'width:100px;height:20px;opacity:0.9;cursor:pointer;z-index:10000;position:absolute;color:#FFFFFF;text-shadow:1px 1px #000000';

    return {
        domElement: container,
        position: function (x, y) {
            container.style.top = x + "px";
            container.style.left = y + "px";
        },
        update: function () {
            container.innerHTML = "O: [" + World.tiles.length + "] E: [" + (World.entities.length + 1) + "]";
        }
    };
};
var WorldInfo = function () {

    var container = document.createElement('div');
    container.id = "debug-worldInfo";
    container.style.cssText = 'width:150px;height:40px;opacity:0.9;cursor:pointer;z-index:10000;position:absolute;color:#FFFFFF;text-shadow:1px 1px #000000';

    return {
        domElement: container,
        position: function (x, y) {
            container.style.top = x + "px";
            container.style.left = y + "px";
        },
        update: function () {
            container.innerHTML = "TileX: " + ((TwoD.screen.world.camera.x / 128) >> 0);
        }
    };
};
var CamInfo = function () {

    var container = document.createElement('div');
    container.id = "debug-camInfo";
    container.style.cssText = 'width:150px;height:40px;opacity:0.9;cursor:pointer;z-index:10000;position:absolute;color:#FFFFFF;text-shadow:1px 1px #000000';

    return {
        domElement: container,
        position: function (x, y) {
            container.style.top = x + "px";
            container.style.left = y + "px";
        },
        update: function () {
            container.innerHTML = "cam_X: " + TwoD.screen.world.camera.x + "<br/>cam_Y: " + TwoD.screen.world.camera.y;
        }
    };
};
