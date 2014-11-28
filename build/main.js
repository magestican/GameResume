(function() {

    ////////////////////////////////////////////////////////////
    // App
    ////////////////////////////////////////////////////////////

    var App = window.App = angular.module('bryan_resume_game', ['Controllers', 'Directives', 'Factories', 'Filters', 'Services']);

    ////////////////////////////////////////////////////////////
    // CONFIG
    ////////////////////////////////////////////////////////////

    App.config(['$routeProvider', function($routeProvider) {


    }]);

})();;angular.module('Controllers', []);
;
angular.module('Directives', []);
;angular.module('Factories', []);;angular.module('Filters', []);
;
angular.module('Services', []);
;(function() {
  angular.module('Services').service('AssetsSvc', [
    '$rootScope', '$q', 'Particle', 'GameSvc', function($rootScope, $q, Particle, GameSvc) {
      var AssetHelper;
      AssetHelper = (function() {
        var url;

        url = "https://localhost/";

        AssetHelper.prototype.loadResource = function(resourceName) {
          var image;
          image = new Image();
          image.src = url + resourceName;
          image.onError = function() {
            return console.log("Error loading this image");
          };
          return image;
        };

        function AssetHelper() {
          this.cursor = this.loadResource("img/radix_phantasma_normal_select.png");
        }

        return AssetHelper;

      })();
      return new AssetHelper();
    }
  ]);

}).call(this);

//# sourceMappingURL=OAssets.js.map
;var Camera = function (player, zoom) {
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
;Debug = function () {
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
            container.innerHTML = "T: " + Math.round(Game.tick);
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
            container.innerHTML = "TileX: " + ((Game.screen.world.camera.x / 128) >> 0);
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
            container.innerHTML = "cam_X: " + Game.screen.world.camera.x + "<br/>cam_Y: " + Game.screen.world.camera.y;
        }
    };
};
;(function() {
  angular.module('Services').service('GameSvc', [
    '$rootScope', '$q', 'Particle', function($rootScope, $q, Particle) {
      var Game;
      Game = (function() {
        function Game() {}

        Game.debug = true;

        return Game;

      })();
      return new Game();
    }
  ]);

}).call(this);

//# sourceMappingURL=OGame.js.map
;function Player(config) {
    this.w = config.w;
    this.l = config.l;
    this.x = 0;
    this.y = 0;
    this.zoomW = this.w;
    this.zoomL = this.l;
    this.sourceX = 0;
    this.sourceY = 0;
    this.posX = (TwoD.screen.width / 2) - (this.w / 2);
    this.posY = (TwoD.screen.height / 2) - (this.l / 2);
    this.velocityX = 0;
    this.velocityY = 0;
    this.velocityMax = config.velocityMax;
    this.velocityMin = config.velocityMin;
    this.velocityUnit = config.velocityUnit;
    this.image = new Image();
    this.image.src = config.sprite;
};

Player.prototype.initialize = function (context) {
    this.context = context;
};

Player.prototype.update = function () {
    if (TwoD.input.isKeyDown(Keys.A)) {
        this.velocityX -= (this.velocityX > this.velocityMin) ? this.velocityUnit : 0;
        this.x += this.velocityX;
    } else if (TwoD.input.isKeyDown(Keys.D)) {
        this.velocityX += (this.velocityX < this.velocityMax) ? this.velocityUnit : 0;
        this.x += this.velocityX;
    } else {
        this.velocityX = 0;
    }
    if (TwoD.input.isKeyDown(Keys.W)) {
        this.velocityY -= (this.velocityY > this.velocityMin) ? this.velocityUnit : 0;
        this.y += this.velocityY;
    } else if (TwoD.input.isKeyDown(Keys.S)) {
        this.velocityY += (this.velocityY < this.velocityMax) ? this.velocityUnit : 0;
        this.y += this.velocityY;
    } else {
        this.velocityY = 0;
    }

    this.zoomW = this.w / TwoD.screen.world.camera.zoom;
    this.zoomL = this.l / TwoD.screen.world.camera.zoom;

    this.posX += this.velocityX / TwoD.screen.world.camera.zoom;
    this.posY += this.velocityY / TwoD.screen.world.camera.zoom;

    if (this.posX < 0 + TwoD.screen.world.camera.boundsX) {
        this.posX -= this.velocityX / TwoD.screen.world.camera.zoom;;
    }
    if (this.posX > TwoD.screen.width - this.zoomW - TwoD.screen.world.camera.boundsX) {
        this.posX -= this.velocityX / TwoD.screen.world.camera.zoom;;
    }
    if (this.posY < 0 + TwoD.screen.world.camera.boundsY) {
        this.posY -= this.velocityY / TwoD.screen.world.camera.zoom;;
    }
    if (this.posY > TwoD.screen.height - this.zoomL - TwoD.screen.world.camera.boundsY) {
        this.posY -= this.velocityY / TwoD.screen.world.camera.zoom;;
    }
};
Player.prototype.draw = function (context) {
    context.drawImage(this.image, this.sourceX, this.sourceY, this.w, this.l, this.posX, this.posY, this.zoomW, this.zoomL);
};;var Screen = function () {
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
};;function getRandomColor() {
    var letters = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"];
    var color = '#';
    for (var i = 0; i < 6; i++) {
        color += letters[Math.round(Math.random() * 15)];
    }
    return color;
}

function getViewport() {
    var e = window;
    var a = 'inner';
    if (!('innerWidth' in window)) {
        a = 'client';
        e = document.documentElement || document.body;
    }
    return { width: e[a + 'Width'], height: e[a + 'Height'] };
}

function getMousePos(canvas, evt) {
    var rect = canvas.getBoundingClientRect();
    return {
        x: evt.clientX - rect.left,
        y: evt.clientY - rect.top
    };
};function Vector(x, y) {
    this.x = x || 0;
    this.y = y || 0;
}
Vector.prototype.add = function (vector) {
    this.x += vector.x;
    this.y += vector.y;
}
Vector.prototype.getMagnitude = function () {
    return Math.sqrt(this.x * this.x + this.y * this.y);
};
Vector.prototype.getAngle = function () {
    return Math.atan2(this.y, this.x);
};
Vector.fromAngle = function (angle, magnitude) {
    return new Vector(magnitude * Math.cos(angle), magnitude * Math.sin(angle));
};;(function() {
  angular.module('Services').service('DeviceSvc', [
    '$rootScope', '$q', 'Particle', function($rootScope, $q, Particle) {
      this.canvas = document.getElementById("myCanvas");
      this.ctx = this.canvas.getContext("2d");
      return void 0;
    }
  ]);

}).call(this);

//# sourceMappingURL=ODevice.js.map
;(function() {
  angular.module('Services').service('CursorSvc', [
    '$rootScope', '$q', 'Particle', 'AssetsSvc', 'DeviceSvc', function($rootScope, $q, Particle, AssetsSvc, DeviceSvc) {
      var Cursor;
      Cursor = (function() {
        var x, y;

        function Cursor() {}

        x = 0;

        y = 0;

        Cursor.colorR = 255;

        Cursor.colorG = 255;

        Cursor.colorB = 0;

        Cursor.event = {};

        window.onmousemove = function(event) {
          return Cursor.event = event;
        };

        Cursor.prototype.update = function() {
          var rect;
          if (!Cursor.event.clientX) {
            return;
          }
          rect = DeviceSvc.canvas.getBoundingClientRect();
          x = Math.round(Cursor.event.clientX - rect.left / (rect.right - rect.left) * DeviceSvc.canvas.width) - 5;
          return y = Math.round(Cursor.event.clientY - rect.top / (rect.bottom - rect.top) * DeviceSvc.canvas.width) - 5;
        };

        Cursor.prototype.draw = function() {
          return DeviceSvc.ctx.drawImage(AssetsSvc.cursor, x, y);
        };

        return Cursor;

      })();
      return new Cursor();
    }
  ]);

}).call(this);

//# sourceMappingURL=OCursor.js.map
;(function() {
  angular.module('Services').service('InputSvc', [
    '$rootScope', '$q', 'Particle', function($rootScope, $q, Particle) {
      var Input;
      Input = (function() {
        function Input() {
          var self;
          this.keyState = [];
          this.keyCurrent = [];
          this.keyLast = [];
          this.Keys = {
            'BACKSPACE': 8,
            'COMMA': 188,
            'DELETE': 46,
            'DOWN': 40,
            'END': 35,
            'ENTER': 13,
            'ESCAPE': 27,
            'HOME': 36,
            'LEFT': 37,
            'NUMPAD_ADD': 107,
            'NUMPAD_DECIMAL': 110,
            'NUMPAD_DIVIDE': 111,
            'NUMPAD_ENTER': 108,
            'NUMPAD_MULTIPLY': 106,
            'NUMPAD_SUBTRACT': 109,
            'PAGE_DOWN': 34,
            'PAGE_UP': 33,
            'PERIOD': 190,
            'RIGHT': 39,
            'SPACE': 32,
            'TAB': 9,
            'UP': 38,
            'W': 87,
            'S': 83,
            'A': 65,
            'D': 68
          };
          self = this;
          window.addEventListener('keydown', function(ev) {
            self.keyCurrent[ev.which] = true;
            return self.keyState[ev.which] = true;
          });
          window.addEventListener('keyup', function(ev) {
            return self.keyState[ev.which] = false;
          });
        }

        Input.prototype.update = function() {
          this.keyLast = this.keyCurrent;
          this.keyCurrent = this.keyState;
          return void 0;
        };

        Input.prototype.isKeyDown = function(key) {
          return !!this.keyCurrent[key];
        };

        Input.prototype.isKeyTriggered = function(key) {
          return !!this.keyCurrent[key] && !this.keyLast[key];
        };

        Input.prototype.isKeyReleased = function(key) {
          return !this.keyCurrent[key] && !!this.keyLast[key];
        };

        return Input;

      })();
      return new Input();
    }
  ]);

}).call(this);

//# sourceMappingURL=OInput.js.map
;var World = function () {
    this.player = new Player(_PlayerConfig);
    this.camera = new Camera(this.player, 1);
};

World.entities = [];
World.tiles = [];

World.prototype = {
    initialize: function () {
        var _map = {
            sprite: {
                "src": "images/tiles/G000M800.BMP",
                "tileW": 128,
                "tileL": 128
            },
            tiles: []

        };
        Game.server.loadWorld(0, 0, function () {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                _map.tiles = eval(xmlhttp.responseText);
                World.loadMap(_map);
            }
        });
    },
    update: function () {
        this.player.update();
        this.camera.update(this.player);
        for (var i = 0; i < World.tiles.length; i++) {
            World.tiles[i].update();
        }
        for (var i = 0; i < World.entities.length; i++) {
            World.entities[i].update();
        }
    },
    draw: function (context) {
        for (var i = 0; i < World.tiles.length; i++) {
            World.tiles[i].draw(context);
        }
        for (var i = 0; i < World.entities.length; i++) {
            World.entities[i].draw(context);
        }
        this.player.draw(context);
    }
};

World.loadMap = function (map) {
    this.map = map;
    this.map.sprite.image = new Image();
    this.map.sprite.image.src = this.map.sprite.src;
    for (var tile in this.map.tiles) {
        World.tiles.push(new Tile(this.map.tiles[tile].x,
                        this.map.tiles[tile].y, this.map.tiles[tile].id,
                        this.map.tiles[tile].type, this.map.sprite));
    }
};


World.getRegion = function () {


};;function Tile(left, top, id, type, sprite) {
    this.sprite = sprite;
    this.left = left;
    this.top = top;
    this.w = sprite.tileW;
    this.l = sprite.tileL;
    this.id = id;
    this.type = type;
    this.sourceX = 0;
    this.sourceY = 0;
}
;

Tile.prototype.update = function () {
    this.posX = this.left * this.w + (TwoD.screen.world.camera.x * -2) + (TwoD.screen.width / 2) - (this.w / 2);
    this.posY = this.top * this.l + (TwoD.screen.world.camera.y * -2) + (TwoD.screen.height / 2) - (this.l / 2);
    this.zoomW = this.w / TwoD.screen.world.camera.zoom;
    this.zoomL = this.l / TwoD.screen.world.camera.zoom;
};

Tile.prototype.draw = function (ctx) {
    ctx.drawImage(this.sprite.image, this.sourceX, this.sourceY, this.w, this.l, this.posX, this.posY, this.zoomW, this.zoomL);
};
;(function() {
  angular.module('Factories').factory('Emitter', [
    '$rootScope', '$q', 'Particle', function($rootScope, $q, Particle) {
      var Emitter;
      return Emitter = (function() {
        function Emitter(position, velocity, spread) {
          this.position = position;
          this.velocity = velocity;
          this.spread = spread != null ? spread : Math.PI / 32;
          this.drawColor = "#999";
        }

        Emitter.prototype.emitParticle = function() {
          var angle, magnitude, p, position, velocity;
          angle = this.velocity.getAngle() + this.spread - (Math.random() * this.spread * 2);
          magnitude = this.velocity.getMagnitude();
          position = new Vector(this.position.x, this.position.y);
          velocity = Vector.fromAngle(angle, magnitude);
          p = new Particle(position, velocity);
          return p;
        };

        return Emitter;

      })();
    }
  ]);

  angular.module('Services').service('EmitterSvc', [
    '$rootScope', '$q', 'Particle', function($rootScope, $q) {
      var emitters;
      return emitters = this.emitters = [];
    }
  ]);

}).call(this);

//# sourceMappingURL=OEmitter.js.map
;(function() {
  angular.module('Factories').factory('Field', [
    '$rootScope', '$q', 'Particle', function($rootScope, $q) {
      var Field;
      Field = (function() {
        function Field(point, mass) {
          this.position = point;
          this.setMass(mass);
        }

        Field.prototype.setMass = function(mass) {
          this.mass = mass != null ? mass : 100;
          this.drawColor = this.mass < 0 ? "#f00" : "#0f0";
          return Field;
        };

        return Field;

      })();
      return Field;
    }
  ]);

}).call(this);

//# sourceMappingURL=OField.js.map
;(function() {
  angular.module('Factories').factory('Particle', [
    '$rootScope', '$q', function($rootScope, $q) {
      var Particle;
      Particle = function(point, velocity, acceleration) {
        this.position = point || new Vector(0, 0);
        this.velocity = velocity || new Vector(0, 0);
        this.acceleration = acceleration || new Vector(0, 0);
        return void 0;
      };
      Particle.prototype.move = function() {
        this.velocity.add(this.acceleration);
        return this.position.add(this.velocity);
      };
      Particle.prototype.submitToFields = function(fields) {
        var field, force, totalAccelerationX, totalAccelerationY, vectorX, vectorY, _i, _len, _results;
        totalAccelerationX = 0;
        totalAccelerationY = 0;
        _results = [];
        for (_i = 0, _len = fields.length; _i < _len; _i++) {
          field = fields[_i];
          vectorX = field.position.x - this.position.x;
          vectorY = field.position.y - this.position.y;
          force = field.mass / Math.pow(vectorX * vectorX + vectorY * vectorY, 1.5);
          totalAccelerationX += vectorX * force;
          totalAccelerationY += vectorY * force;
          _results.push(this.acceleration = new Vector(totalAccelerationX, totalAccelerationY));
        }
        return _results;
      };
      return Particle;
    }
  ]);

  angular.module('Services').service('ParticleSvc', [
    '$q', '$rootScope', '$location', 'EmitterSvc', 'DeviceSvc', function($q, $rootScope, $location, EmitterSvc, DeviceSvc) {
      var emissionRate, fields, maxParticles, particleSize, particles;
      particles = this.particles = [];
      fields = this.fields = [];
      particleSize = this.particleSize = 1;
      maxParticles = this.maxParticles = 4000;
      emissionRate = this.emissionRate = 4;
      this.DrawParticles = function() {
        var col1, col2, col3, particle, position, _i, _len, _results;
        col1 = Math.floor(Math.random() * 255) + 0;
        col2 = Math.floor(Math.random() * 255) + 0;
        col3 = Math.floor(Math.random() * 255) + 0;
        DeviceSvc.ctx.fillStyle = "rgb(" + col1.toString() + ',' + col2.toString() + ',' + col3.toString() + ')';
        _results = [];
        for (_i = 0, _len = particles.length; _i < _len; _i++) {
          particle = particles[_i];
          position = particle.position;
          _results.push(DeviceSvc.ctx.fillRect(position.x, position.y, this.particleSize, this.particleSize));
        }
        return _results;
      };
      this.PlotParticles = function(boundsX, boundsY) {
        var currentParticles, particle, pos, _i, _len;
        currentParticles = [];
        for (_i = 0, _len = particles.length; _i < _len; _i++) {
          particle = particles[_i];
          pos = particle.position;
          if (pos.x < 0 || pos.x > boundsX || pos.y < 0 || pos.y > boundsY) {
            continue;
          }
          particle.submitToFields(fields);
          particle.move();
          currentParticles.push(particle);
        }
        return particles = currentParticles;
      };
      this.AddNewParticles = function() {
        var emitter, error, j, _i, _len, _ref, _results;
        if (particles.length > maxParticles) {
          return;
        }
        _ref = EmitterSvc.emitters;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          emitter = _ref[_i];
          _results.push((function() {
            var _j, _results1;
            _results1 = [];
            for (j = _j = 0; 0 <= emissionRate ? _j <= emissionRate : _j >= emissionRate; j = 0 <= emissionRate ? ++_j : --_j) {
              try {
                _results1.push(particles.push(emitter.emitParticle()));
              } catch (_error) {
                error = _error;
                _results1.push((function() {
                  debugger;
                })());
              }
            }
            return _results1;
          })());
        }
        return _results;
      };
      return void 0;
    }
  ]);

}).call(this);

//# sourceMappingURL=OParticle.js.map
;(function() {


}).call(this);

//# sourceMappingURL=assets.js.map
;angular.module('Controllers')
    .controller('MainController', ['$scope', '$filter', 'Particle', 'ParticleSvc', 'Emitter', 'Field', 'EmitterSvc', 'DeviceSvc', 'CursorSvc', function ($scope, $filter, Particle, ParticleSvc, Emitter, Field, EmitterSvc, DeviceSvc, CursorSvc) {

        //globals 
        var Game = window.Game = {};
        var ctx = DeviceSvc.ctx;
        var c = DeviceSvc.canvas;
        Game.fps = 60;
        Game.maxFrameSkip = 10;
        Game.skipTicks = 1000 / Game.fps;
        Game.width = c.width;
        Game.height = c.height;

        var objectSize = 3; // drawSize of emitter/field
        // `object` is a field or emitter, something that has a drawColor and position
        function drawCircle(object) {
            ctx.fillStyle = object.drawColor;
            ctx.beginPath();
            ctx.arc(object.position.x, object.position.y, objectSize, 0, Math.PI * 2);
            ctx.closePath();
            ctx.fill();
        }
        var midX = c.width / 2;
        var midY = c.height / 2;


        EmitterSvc.emitters = [
          new Emitter(new Vector(midX - 150, midY), Vector.fromAngle(6, 2))
        ];

        ParticleSvc.fields.push(new Field(new Vector(midX - 100, midY + 20), 150))
        ParticleSvc.fields.push(new Field(new Vector(midX - 300, midY + 20), 100))
        ParticleSvc.fields.push(new Field(new Vector(midX - 200, midY - 40), -20))
        ParticleSvc.fields.push(new Field(new Vector(midX, midY + 20), -20))

        function drawMyName() {
            DeviceSvc.ctx.fillStyle = "rgb(0,0,0)";

            ctx.font = "30pt serif";
            ctx.fillText("Bryan Arbelo", midX + 150, midY);
            ctx.font = "10pt serif";
            ctx.fillText("Hope you like my angular.js + game engine on coffee script", midX + 150, midY + 100);
            ctx.fillText("and the use of google's free hosting and dropbox's storage :)", midX + 150, midY + 114);

        }

        //THERE IS NO WHILE!!
        //clear canvas
        function clear() {
            ctx.clearRect(0, 0, c.width, c.height);
        }

        Game.pause = function () {
            this.paused = (this.paused) ? false : true;
        };

        Game.clear = function () {
            ctx.clearRect(0, 0, c.width, c.height);
        }
        /*
         * Runs the actual loop inside browser
         */

        function loop() {
            clear();
            update();
            draw();
            queue();
        }

        function clear() {
            ctx.clearRect(0, 0, c.width, c.height);

        }

        function update() {
            ParticleSvc.AddNewParticles();
            ParticleSvc.PlotParticles(c.width, c.height);

        }

        function draw() {
            clear();
            ParticleSvc.DrawParticles();
            ParticleSvc.fields.forEach(drawCircle);
            EmitterSvc.emitters.forEach(drawCircle);
            drawMyName();
            CursorSvc.draw();
        }

        function queue() {
            CursorSvc.update();
            window.requestAnimationFrame(loop);
        }

        loop();

    }]);;angular.module('Directives')

    .directive('btn', ['$timeout', function($timeout) {
        return {
            restrict: 'C',
            link: function(scope, element, attrs) {
                var tooltipTimer;
                element.on('mouseenter', function() {
                    tooltipTimer = $timeout(function() {
                        element.addClass('tooltip-show');
                        $timeout(function() {
                            element.addClass('tooltip-animate');
                        }, 50);
                    }, 200);
                });
                element.on('mouseleave', function() {
                    $timeout.cancel(tooltipTimer);
                    element.removeClass('tooltip-show tooltip-animate');
                });
            }
        }
    }])

    .directive('tooltip', function() {
        return {
            restrict: 'A',
            replace: true,
            transclude: true,
            templateUrl: 'tooltip.html',
            link: function(scope, element, attrs) {

            }
        };
    });;angular.module('Factories')

    .factory('Manager', ['$rootScope', '$q', 'FileType', function($rootScope, $q, fileTypeFactory) {
        return {
            addFile: {},
            addProject: {},

            applicationScope: undefined,

            currentPage: 'default',
            currentTeam: undefined,
            currentUser: undefined,
            currentViewMode: undefined,

            editFile: undefined,
            editProject: undefined,
            editUser: undefined,

            headerContextual: {
                display: {
                    current: undefined,
                    items: []
                },
                displayCache: {},
                endDatePicker: undefined,
                filter: false,
                filterFunction: window.Slic.K,
                projects: [],
                projectsShow: false,
                projectStatuses: {
                    items: []
                },
                title: undefined,
                titleLink: '#',
                titleType: undefined,
                tags: [],
                tagCategories: [],
                tagsMerged: [],
                tagsInput: undefined,
                tagCategoriesShow: false,
                tagsCache: {},
                sort: {
                    current: undefined,
                    items: []
                },
                sortCache: {},
                users: [],
                usersShow: false
            },

            project: undefined,

            message: {
                show: false,
                type: 'simple',
                text: undefined,
                display: {},
                showMessage: function(msg) {
                    this.show = true;
                    this.text = msg;
                }
            },

            salesforce: window.Slic !== undefined ? window.Slic.Salesforce : {},

            sidebar: {
                drawer: false,
                drawerItems: [],
                items: [],
                navItems: {},
                scrollable: undefined,
                show: false
            },

            settings: {
                sidebar: {
                    pinned: false
                },
                viewModes: {
                    assets: 'expanded',
                    projects: 'expanded',
                    people: 'expanded',
                    personas: 'expanded'                }
            },

            teams: [],
            teamsLoaded: jQuery.Deferred(),

            $html: $('html,body'),
            $pageWrapper: $('#page-wrapper')
        };
    }])

    .factory('DataTemplates', function() {
        return {
            fileUpload: {
                baseUrl: window.Slic !== undefined ? window.Slic.Salesforce.baseUrl : '/',
                focus: false,
                id: undefined,
                imageOnly: false,
                name: undefined,
                onBlur: function() {},
                onUploadChange: function() {},
                required: false,
                server: false,
                sizeLimitTip: true,
                sizeLimitMessage: false,
                sizeLimitError: false,
                sizeLimitSolution: true,
                status: undefined,
                title: undefined,
                type: undefined,
                uploadEntity: 'File',
                uploadOnly: false,
                url: undefined,
                update: false,
                reset: function() {
                    angular.forEach(['id', 'name', 'status', 'title', 'type', 'url'], function(key) {
                        this[key] = undefined;
                    }, this);
                    angular.forEach(['server', 'sizeLimitMessage', 'update'], function(key) {
                        this[key] = false;
                    }, this);
                }
            },
            headerContextualTab: {
                filter: true,
                sort: true,
                viewModes: true,
                active: false
            },
            sidebarNavItem: {
                active: false,
                action: function() {},
                actionSecondary: function() {},
                actionSecondaryIcon: 'icon-breadcrumb',
                count: undefined,
                drawerItems: undefined,
                icon: undefined,
                label: undefined,
                link: undefined
            },
            sidebarDrawerItem: {
                id: undefined,
                label: undefined,
                link: undefined,
                hasItems: false,
                items: undefined,
                showItems: false
            }
        };
    })

    .factory('Utilities', ['$filter', '$route', '$location', 'Manager', function($filter, $route, $location, Manager) {

        function PromiseQueue(scope, queue) {
            this.scope = scope;
            angular.forEach(queue, function(promise) {
                promise.resolve(this.scope);
            }, this);
            queue = [];
        }

            PromiseQueue.prototype.push = function(promise) {
                promise.resolve(this.scope);
            };

        return {

            /**
             * applyRouteToTabs
             *
             * @param {Object} scope - Angular Scope
             * @param {Array} tabs - array of tabs
             * @param {String} defaultTab - the default tab to call if no route was matched
             * @return {Object} currentTab
             */

            applyRouteToTabs: function(params) {

                var defaults = {
                    history: true
                };

                params = angular.extend(defaults, params);

                var path        = $location.path().replace(/^\//, '');
                    path        = path === '' ? null : path;
                var currentTab  = $filter('getById')(params.tabs, path);

                // Get the default tab is no tab was matched by the route
                if (!currentTab) {
                    currentTab = $filter('getById')(params.tabs, params.defaultTab);
                    if (!currentTab) { throw new Error('Tab not found and no default was specified'); }
                }

                if (params.scope.currentTab === currentTab) return;

                // Save the current tags for this tab
                if (Manager.headerContextual.currentTab) {
                    Manager.headerContextual.sortCache[Manager.headerContextual.currentTab.id] = angular.copy(Manager.headerContextual.sort);
                    Manager.headerContextual.tagsCache[Manager.headerContextual.currentTab.id] = angular.copy(Manager.headerContextual.tags);
                }

                // Clear the tags or get them from the cache
                Manager.headerContextual.sort = angular.copy(Manager.headerContextual.sortCache[currentTab.id]) || Manager.headerContextual.sort;
                Manager.headerContextual.tags = angular.copy(Manager.headerContextual.tagsCache[currentTab.id]) || [];

                // Deactivate tabs
                angular.forEach(params.tabs, function(tab) {
                    tab.active = false;
                });

                // Active the current tab
                currentTab.active = true;

                // View Modes
                this.setCurrentViewMode(currentTab);

                // Call the method
                try { currentTab.action.call(); } catch(e) {}

                // Update the factory
                Manager.currentPage = currentTab.id;

                // Save the tab to the scope
                params.scope.currentTab = Manager.headerContextual.currentTab = currentTab;

                return currentTab;

            },

            setCurrentViewMode: function(tab) {
                if (Manager.settings.viewModes[tab.id]) {
                    Manager.currentViewMode = Manager.settings.viewModes[tab.id];
                }
            },

            getValueFromKeys: function(obj, keys) {
                keys = keys.split('.');
                while (keys.length > 1) {
                    obj = obj[keys.shift()];
                }
                return obj[keys.shift()];
            },

            loadScript: function(src, callback) {
                var deferred    = jQuery.Deferred();
                var body        = document.getElementsByTagName('body')[0];
                var script      = document.createElement('script');

                script.type     = 'text/javascript';
                script.src      = src;
                script.async    = true;
                script.onload   = function() { deferred.resolve(); };

                body.appendChild(script);

                return deferred;
            },

            PromiseQueue: PromiseQueue,

            safeApply: function($scope, fn) {
                var phase = $scope.$root.$$phase;
                if(phase == '$apply' || phase == '$digest') {
                    if (fn) {
                        $scope.$eval(fn);
                    }
                } else {
                    if (fn) {
                        $scope.$apply(fn);
                    } else {
                        $scope.$apply();
                    }
                }
            },

            scrollTop: function(duration) {
                duration = duration === undefined ? 400 : duration;
                Manager.$html.animate({ scrollTop: 0 }, { duration: duration });
            },

            setValueFromKeys: function (obj, keys, value) {
                keys = keys.split('.');
                while (keys.length > 1) {
                    obj = obj[keys.shift()];
                }
                obj[keys.shift()] = value;
            },

            styleString: function(styles) {
                var styleString = '';
                var style;
                for (style in styles) {
                    styleString += style + ':' + styles[style] + ';';
                }
                return styleString;
            },
            unescape : function(string){
              if(string != "" && string != null){
                string = string.replace(/&#39;/g, "'");
                string = string.replace(/&amp;#39;/g, "'");
                string = string.replace(/&quot;/g, '"');
                string = string.replace(/&amp;/g, "&");
                string = string.replace(/&gt;/g, ">");
                string = string.replace(/&lt;/g, "<");
              }
              return string;
            }

        };
    }])

    .factory('FileType', ['$filter', function($filter) {

        var types = [{
            label: 'Vector',
            extensions: ['ai', 'eps', 'ait', 'svg', 'svgs'],
            styles: {
                'background-color': '#FFBE55'
            }
        },{
            label: 'Adobe Photoshop',
            extensions: ['psd', 'pdb'],
            styles: {
                'background-color': '#7ED0FC'
            }
        },{
            label: 'Adobe PDF',
            extensions: ['pdf'],
            styles: {
                'background-color': '#D82610'
            }
        },{
            label: 'Adobe Flash',
            extensions: ['fla', 'flv', 'swf', 'xfl', 'as', 'jsfl', 'asc', 'f4v'],
            styles: {
                'background-color': '#FA3725'
            }
        },{
            label: 'Adobe Premiere',
            extensions: ['prproj'],
            styles: {
                'background-color': '#E58AF9'
            }
        },{
            label: 'Adobe Indesign',
            extensions: ['indd', 'indl', 'indt', 'indp', 'inx', 'idml', 'xqx'],
            styles: {
                'background-color': '#F66FB8'
            }
        },{
            label: 'Adobe After Effects',
            extensions: 'aep',
            styles: {
                'background-color': '#E58AF9'
            }
        },{
            label: 'Sketch',
            extensions: 'sketch',
            styles: {
                'background-color': '#BF8FF9'
            }
        },{
            label: 'Microsoft Word',
            extensions: ['doc', 'docx', 'dot', 'dotx'],
            styles: {
                'background-color': '#14A9DA'
            }
        },{
            label: 'Microsoft Excel',
            extensions: ['xls', 'xlsx', 'csv', 'xlt', 'xltx', 'xml'],
            styles: {
                'background-color': '#45B058'
            }
        },{
            label: 'Microsoft PowerPoint',
            extensions: ['pptx', 'ppt', 'potx', 'pot'],
            styles: {
                'background-color': '#E34221'
            }
        },{
            label: 'Visio',
            extensions: ['vsd', 'vss', 'vst', 'vsw', 'vsdx', 'vssx', 'vstx'],
            styles: {
                'background-color': '#496AB3'
            }
        },{
            label: 'Axure',
            extensions: ['rp'],
            styles: {
                'background-color': '#1AB6D9'
            }
        },{
            label: 'OmniGraffle',
            extensions: ['graffle'],
            styles: {
                'background-color': '#26C587'
            }
        },{
            label: 'Keynote',
            extensions: ['key'],
            styles:  {
                'background-color': '#F2B854'
            }
        },{
            label: 'Pages',
            extensions: ['pages'],
            styles: {
                'background-color': '#2C2181'
            }
        },{
            label: 'Numbers',
            extensions: ['numbers'],
            styles: {
                'background-color': '#19A13B'
            }
        },{
            label: 'Final Cut Pro',
            extensions: ['fcp'],
            styles: {
                'background-color': '#5096D6'
            }
        },{
            label: 'Motion',
            extensions: ['motn'],
            styles: {
                'background-color': '#45BFBF'
            }
        },{
            label: 'Garage Band',
            extensions: ['band'],
            styles: {
                'background-color': '#F9CB4B'
            }
        },{
            label: 'Balsamiq',
            extensions: ['bmml'],
            styles: {
                'background-color': '#760209'
            }
        },{
            label: 'Audio',
            extensions: ['wav', 'mp3', 'wma', 'm4a', 'm4p', 'aac', 'alac'],
            styles: {
                'background-color': '#379FD3'
            }
        },{
            label: 'Video',
            extensions: ['mpg', 'mpeg', 'mov', 'qt', 'avi', 'dv', 'dvi', 'flv', 'mp4', 'm2v', 'm4v', 'wmv'],
            styles: {
                'background-color': '#8E4C9E'
            }
        },{
            label: 'Image',
            extensions: ['jpg', 'jpeg', 'jfif', 'png', 'tiff', 'tif', 'gif', 'bmp', 'pict', 'raw', 'ico'],
            styles: {
                'background-color': '#49C9A7'
            }
        },{
            label: 'Code',
            extensions: ['html', 'htm', 'css', 'sass', 'scss', 'less', 'js', 'coffee', 'php', 'hbs'],
            styles: {
                'background-color': '#505050'
            }
        },{
            label: 'Text',
            extensions: ['txt', 'rtf'],
            styles: {
                'background-color': '#B58D61'
            }
        },{
            label: 'Program',
            extensions: ['dmg', 'exe'],
            styles: {
                'background-color': '#C7C9CA'
            }
        },{
            label: 'Font',
            extensions: ['ttf', 'otf'],
            styles: {
                'background-color': '#AEB0B3'
            }
        },{
            label: 'Zip',
            extensions: ['zip', 'zipx'],
            styles: {
                'background-color': '#97999C'
            }
        }];

        var sites = [{
            labe: 'General URL',
            type: 'url',
            styles: {
                'background': 'url(../../img/icon-url.png) center no-repeat',
                'background-color': '#3ABAE9',
                'text-indent': '-1000px'
            }
        },{
            label: 'Google Document',
            pattern: /docs\.google\.com.*document/,
            type: 'google-doc',
            group: 'google-drive',
            styles: {
                'background': 'url(../../img/icon-google-doc.png) center no-repeat',
                'background-color': '#3C8CEA',
                'text-indent': '-1000px'
            }
        },{
            label: 'Google Spreadsheet',
            pattern: /docs\.google\.com.*spreadsheet/,
            type: 'google-spreadsheet',
            group: 'google-drive',
            styles: {
                'background': 'url(../../img/icon-google-spreadsheet.png) center no-repeat',
                'background-color': '#20A971',
                'text-indent': '-1000px'
            }
        },{
            label: 'Google Presentation',
            pattern: /docs\.google\.com.*presentation/,
            type: 'google-presentation',
            group: 'google-drive',
            styles: {
                'background': 'url(../../img/icon-google-presentation.png) center no-repeat',
                'background-color': '#F8BE46',
                'text-indent': '-1000px'
            }
        },{
            label: 'Solidify',
            pattern: /solidifyapp\.com/,
            type: 'slfy',
            group: 'zurb',
            styles: {
                'background': 'url(../../img/icon-solidify.png) center no-repeat',
                'background-color': '#CD135C',
                'text-indent': '-1000px'
            }
        },{
            label: 'Influence',
            pattern: /influenceapp\.com/,
            type: 'infl',
            group: 'zurb',
            styles: {
                'background': 'url(../../img/icon-influence.png) center no-repeat',
                'background-color': '#16AEBE',
                'text-indent': '-1000px'
            }
        },{
            label: 'Verify',
            pattern: /verifyapp\.com/,
            type: 'vrfy',
            group: 'zurb',
            styles: {
                'background': 'url(../../img/icon-verify.png) center no-repeat',
                'background-color': '#B2D448',
                'text-indent': '-1000px'
            }
        },{
            label: 'Notable',
            pattern: /notableapp\.com/,
            type: 'ntbl',
            group: 'zurb',
            styles: {
                'background': 'url(../../img/icon-notable.png) center no-repeat',
                'background-color': '#FEB043',
                'text-indent': '-1000px'
            }
        },{
            label: 'Dropbox',
            pattern: /dropbox\.com/,
            type: 'drbx',
            styles: {
                'background': 'url(../../img/icon-dropbox.png) center no-repeat',
                'background-color': '#3ABAE9',
                'text-indent': '-1000px'
            }
        },{
            label: 'Youtube',
            pattern: /youtube\.com/,
            type: 'tube',
            styles: {
                'background': 'url(../../img/icon-youtube.png) center no-repeat',
                'background-color': '#D6423C',
                'text-indent': '-1000px'
            }
        },{
            label: 'Vimeo',
            pattern: /vimeo\.com/,
            type: 'vmeo',
            styles: {
                'background': 'url(../../img/icon-vimeo.png) center no-repeat',
                'background-color': '#4AC7FD',
                'text-indent': '-1000px'
            }
        },{
            label: 'Flickr',
            pattern: /flickr\.com/,
            type: 'flkr',
            styles: {
                'background': 'url(../../img/icon-flickr.png) center no-repeat',
                'background-color': '#f1f1f1',
                'text-indent': '-1000px'
            }
        },{
            label: 'Dribbble',
            pattern: /dribbble\.com/,
            type: 'drbl',
            styles: {
                'background': 'url(../../img/icon-dribbble.png) center no-repeat',
                'background-color': '#F56398',
                'text-indent': '-1000px'
            }
        },{
            label: 'Twitter',
            pattern: /twitter\.com/,
            type: 'twtr',
            styles: {
                'background': 'url(../../img/icon-twitter.png) center no-repeat',
                'background-color': '#00D4FA',
                'text-indent': '-1000px'
            }
        },{
            label: 'Instagram',
            pattern: /instagram\.com/,
            type: 'inst',
            styles: {
                'background': 'url(../../img/icon-instagram.png) center no-repeat',
                'background-color': '#5589AA',
                'text-indent': '-1000px'
            }
        },{
            label: 'Github',
            pattern: /git/,
            type: 'gh',
            styles: {
                'background': 'url(../../img/icon-github.png) center no-repeat',
                'background-color': '#555555',
                'text-indent': '-1000px'
            }
        },{
            label: 'Proto',
            pattern: /proto/,
            type: 'prto',
            styles: {
                'background': 'url(../../img/icon-salesforce.png) center no-repeat',
                'background-color': '#027BD2',
                'text-indent': '-1000px'
            }
        },{
            label: 'Asana',
            pattern: /asana\.com/,
            type: 'asna',
            styles: {
                'background': 'url(../../img/icon-asana.png) center no-repeat',
                'background-color': '#15A2DA',
                'text-indent': '-1000px'
            }
        },{
            label: 'Basecamp',
            pattern: /basecamp\.com/,
            type: 'base',
            styles: {
                'background': 'url(../../img/icon-basecamp.png) center no-repeat',
                'background-color': '#77CA8C',
                'text-indent': '-1000px'
            }
        },{
            label: 'Delicious',
            pattern: /delicious\.com/,
            type: 'deli',
            styles: {
                'background': 'url(../../img/icon-delicious.png) center no-repeat',
                'background-color': '#285da7',
                'text-indent': '-1000px'
            }
        },{
            label: 'Google Plus',
            pattern: /plus\.google\.com/,
            type: 'g+',
            styles: {
                'background': 'url(../../img/icon-google.png) center no-repeat',
                'background-color': '#DE4436',
                'text-indent': '-1000px'
            }
        },{
            label: 'Pinterest',
            pattern: /pinterest\.com/,
            type: 'pint',
            styles: {
                'background': 'url(../../img/icon-pinterest.png) center no-repeat',
                'background-color': '#C93339',
                'text-indent': '-1000px'
            }
        },{
            label: 'Kontiki',
            pattern: /videocenter\.kontiki\.com/,
            type: 'ktik',
            styles: {
                'background': 'url(../../img/icon-kontiki.png) center no-repeat',
                'background-color': '#25a7d4',
                'text-indent': '-1000px'
            }
        },{
            label: 'Facebook',
            pattern: /facebook\.com/,
            type: 'fb',
            styles: {
                'background': 'url(../../img/icon-facebook.png) center no-repeat',
                'background-color': '#43609c',
                'text-indent': '-1000px'
            }
        },{
            label: 'Flinto',
            pattern: /flinto\.com/,
            type: 'flto',
            styles: {
                'background': 'url(../../img/icon-flinto.png) center no-repeat',
                'background-color': '#333940',
                'text-indent': '-1000px'
            }
        }];

        var releases = [{
            label: "170 (Spring '11)",
            dateRange: moment().range(moment('7/30/2010'), moment('12/3/2010'))
        },{
            label: "172 (Summer '11)",
            dateRange: moment().range(moment('12/6/2010'), moment('3/31/2011'))
        },{
            label: "174 (Winter '12)",
            dateRange: moment().range(moment('3/31/2011'), moment('7/22/2011'))
        },{
            label: "176 (Spring '12)",
            dateRange: moment().range(moment('7/22/2011'), moment('11/18/2011'))
        },{
            label: "178 (Summer '12)",
            dateRange: moment().range(moment('11/18/2011'), moment('3/29/2012'))
        },{
            label: "180 (Winter '13)",
            dateRange: moment().range(moment('3/30/2012'), moment('7/26/2012'))
        },{
            label: "182 (Spring '13)",
            dateRange: moment().range(moment('7/27/2012'), moment('11/15/2012'))
        },{
            label: "184 (Summer '13)",
            dateRange: moment().range(moment('11/16/2012'), moment('3/28/2013'))
        },{
            label: "186 (Winter '14)",
            dateRange: moment().range(moment('3/29/2013'), moment('7/25/2013'))
        },{
            label: "188 (Spring '14)",
            dateRange: moment().range(moment('7/26/2013'), moment('11/14/2013'))
        },{
            label: "190 (Summer '14)",
            dateRange: moment().range(moment('11/22/2013'), moment('3/27/2014'))
        },{
            label: "192 (Winter '15)",
            dateRange: moment().range(moment('3/28/2014'), moment('7/31/2014'))
        },{
            label: "194 (Spring '15)",
            dateRange: moment().range(moment('8/1/2014'), moment('11/20/2014'))
        },{
            label: "196 (Summer '15)",
            dateRange: moment().range(moment('11/21/2014'), moment('3/26/2015'))
        },{
            label: "198 (Winter '16)",
            dateRange: moment().range(moment('3/27/2015'), moment('7/30/2015'))
        },{
            label: "200 (Spring '16)",
            dateRange: moment().range(moment('7/31/2015'), moment('11/19/2015'))
        },{
            label: "202 (Summer '16)",
            dateRange: moment().range(moment('11/20/2015'), moment('3/31/2016'))
        },{
            label: "204 (Winter '17)",
            dateRange: moment().range(moment('4/1/2016'), moment('7/28/2016'))
        },{
            label: "206 (Spring '17)",
            dateRange: moment().range(moment('7/29/2016'), moment('11/17/2016'))
        },{
            label: "208 (Summer '17)",
            dateRange: moment().range(moment('11/18/2016'), moment('3/30/2017'))
        },{
            label: "210 (Winter '18)",
            dateRange: moment().range(moment('3/31/2017'), moment('7/27/2017'))
        }];

        var styleString = '';
        var styleTag = document.createElement('style');
            styleTag.type = 'text/css';

        angular.forEach(types, function(type) {
            angular.forEach(type.extensions, function(extension) {
                styleString += '[data-content-type="'+ extension +'"],';
            });
            styleString = styleString.replace(/,$/g, ' {');
            angular.forEach(type.styles, function(value, property) {
                value = value.replace(/\.\.\/\.\./, window.Slic.Salesforce.assetsURL);
                styleString += '' + property + ':' + value + ';';
            });
            styleString += '}';
        });

        angular.forEach(sites, function(site) {
            styleString += '[data-content-type="'+ site.type +'"] {';
            angular.forEach(site.styles, function(value, property) {
                value = value.replace(/\.\.\/\.\./, window.Slic.Salesforce.assetsURL);
                styleString += '' + property + ':' + value + ';';
            });
            styleString += '}';
        });

        styleTag.innerHTML = styleString;
        document.head.appendChild(styleTag);

        return {
            types: types,
            sites: sites,
            releases: releases,
        };

    }])

    .factory('AutoTag', ['$filter', 'FileType', function($filter, FileType) {
        return function(params) {
            return function() {
                var findTag, addTag, checkFileForTag, checkDateForTag;
                findTag = function(label) {
                    return $filter('filter')(params.tagsMerged, { Title__c: label })[0];
                };
                addTag = function(newTag) {
                    var i, tag;
                    for (i = 0; i < params.tags.length; i++) {
                        tag = params.tags[i];
                        if (tag.Id === newTag.Id) return;
                    }
                    params.tags.push(newTag);
                };
                checkFileForTag = function(fileUpload) {
                    var i, site, type, extension;
                    if ('url' === fileUpload.type) {
                        for (i = 0; i < FileType.sites.length; i++) {
                            site = FileType.sites[i];
                            if (site.pattern && fileUpload.url.match(site.pattern)) {
                                addTag(findTag(site.label));
                                break;
                            }
                        }
                    }
                    if ('upload' === fileUpload.type) {
                        extension = fileUpload.name.split('.');
                        extension = extension[extension.length - 1];
                        for (i = 0; i < FileType.types.length; i++) {
                            type = FileType.types[i];
                            if (type.extensions.indexOf(extension) !== -1) {
                                addTag(findTag(type.label));
                                break;
                            }
                        }
                    }
                };
                checkDateForTag = function(moment) {
                    angular.forEach(FileType.releases, function(release) {
                        if (release.dateRange.contains(moment)) {
                            addTag(findTag(release.label));
                        }
                    });
                };
                params.callback.call(this, findTag, addTag, checkFileForTag, checkDateForTag);
            };
        };
    }]);
;angular.module('Filters')
    
    ////////////////////////////////////////////////////////////
    // Utility
    ////////////////////////////////////////////////////////////

    .filter('backgroundImage', function() {
        return function(url, type) {
            type = type === undefined ? 'object' : type;
            if (type === 'string') {
                return 'background-image: url(' + url + ');';
            } else {
                return {
                    'background-image': 'url(' + url + ')'
                };
            }
        };
    })

    .filter('date', function() {
        return function(input) {
            return input ? moment(input).format('MMM DD, YYYY') : input;
        };
    })

    .filter('getById', function() {
        return function(input, id) {
            var i = 0, len = input.length;
            for (; i < len; i++) {
                if (input[i].id === id) {
                    return input[i];
                }
            }
            return null;
        };
    })

    .filter('markdown', function() {
        return function(input) {
            return input ? markdown.toHTML(input) : '';
        };
    })

    .filter('newlines', function() {
        return function(input) {
            return input !== null ? input.replace(/\n/g, '<br/>') : '';
        };
    })

    .filter('rendition', function() {
        var sizes = {
            small: 'THUMB120BY90',
            medium: 'THUMB240BY180',
            large: 'THUMB720BY480'
        };
        return function(id, size, defaultImg) {
            size = size === undefined ? 'medium' : size;
            if (id !== null) {
                return {
                    'background-image': 'url(/sfc/servlet.shepherd/version/renditionDownload?rendition=' + sizes[size] + '&versionId=' + id + ')'
                };
            } else {
                return {};
            }
        };
    })

    .filter('styleString', ['Utilities', function(Utilities) {
        return function(styleObject) {
            return Utilities.styleString(styleObject);
        };
    }])

    .filter('url', function() {
        return function(url) {
            if (url) {
                return url.match(/^http(s)?:\/\//) ? url : 'http://' + url;
            }
            return url;
        };
    });;angular.module('Services')
  .service('Helper', ['$q', '$rootScope', '$location', 'CompanyFactory', 'StaffFactory', 'CredentialsFactory', 'InsuranceFactory', function ($q, $rootScope, $location, CompanyFactory, StaffFactory, CredentialsFactory, InsuranceFactory) {

      this.setCompanyInfo = function (appId, secureCode) {
          var deferred = $q.defer();

          // Load company information
          var companyInfo;
          companyInfo = CompanyFactory.getCompanyInfo(appId, secureCode);
          companyInfo.then(function (response) {
              $rootScope.global.company = response;
              deferred.resolve();
          });

          return deferred.promise;
      }

      this.setStaffInfo = function(appId, secureCode) {
          var deferred = $q.defer();

          // Load staff information
          var staffInfo;
          staffInfo = StaffFactory.getStaffInfo(appId, secureCode);
          staffInfo.then(function (response) {
              $rootScope.global.staffs = response;
              deferred.resolve();
          });

          return deferred.promise;
      }

      this.setCredentialsInfo = function(appId, secureCode) {
          var deferred = $q.defer();

          // Load staff information
          var credentialsInfo;
          credentialsInfo = CredentialsFactory.getCredentialsInfo(appId, secureCode);
          credentialsInfo.then(function (response) {
              $rootScope.global.credentials = response;
              
              deferred.resolve();
          });

          return deferred.promise;
      }

      this.setInsuranceInfo = function(appId, secureCode) {
          var deferred = $q.defer();

          // Load staff information
          var insuranceInfo;
          insuranceInfo = InsuranceFactory.getInsuranceInfo(appId, secureCode);
          insuranceInfo.then(function (response) {
              $rootScope.global.insurance = response;
              deferred.resolve();
          });

          return deferred.promise;
      }

      this.goToLocation = function(page, appId, secureCode) {
          $location.path('/' + page + '/' + appId + '/' + secureCode);
      }

      this.getLocation = function() {
        return $location.path().split('/')[1];
      }

      this.resetPropertiesOf = function (objectToReset) {
          for (var property in objectToReset) {
              if (objectToReset.hasOwnProperty(property)) {
                  if (typeof (property) == 'null')
                      objectToReset[property] = {};
                  if (typeof (property) == 'boolean')
                      objectToReset[property] = false;
                  if (typeof (property) == 'number')
                      objectToReset[property] = 0;
                  if (typeof (property) == 'string')
                      objectToReset[property] = "";
              }
          }
      }

      this.clone = function (obj) {
          if (null == obj || "object" != typeof obj) return obj;
          var copy = obj.constructor();
          for (var attr in obj) {
              if (obj.hasOwnProperty(attr)) copy[attr] = obj[attr];
          }
          return copy;
      }


  }]);
