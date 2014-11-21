Input = function () {
    this.keyState = [];
    this.keyCurrent = [];
    this.keyLast = [];
    var self = this;

    window.addEventListener('keydown', function (ev) {
        self.keyCurrent[ev.which] = true;
        self.keyState[ev.which] = true;
    });
    window.addEventListener('keyup', function (ev) {
        self.keyState[ev.which] = false;
    });
};

Input.prototype.update = function () {
    this.keyLast = this.keyCurrent;
    this.keyCurrent = this.keyState;
};

// test if a key is currently being pressed
Input.prototype.isKeyDown = function (key) {
    return !!this.keyCurrent[key];
};

// test if a key has been pressed this frame
Input.prototype.isKeyTriggered = function (key) {
    return !!this.keyCurrent[key] && !this.keyLast[key];
};

// test if a key has been pressed last frame
Input.prototype.isKeyReleased = function (key) {
    return !this.keyCurrent[key] && !!this.keyLast[key];
};

var Keys = {
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