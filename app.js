var express = require('express');
var https = require('https');
var http = require('http');
var fs = require('fs');
var path = require('path');

var app = express();

app.configure(function () {
    var port = process.env.PORT || 443
    process.env.PWD = process.cwd()
    app.set('port', port);
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(app.router);
    app.use('build', express.static(__dirname + 'build'));
    app.use(express.static(path.join(__dirname, 'assets')));
});

var options = {
    key: fs.readFileSync('ssl/server.key'),
    cert: fs.readFileSync('ssl/server.crt')
};

https.createServer(options, app).listen(app.get('port'), function () {
    console.log('Express server listening on port ' + app.get('port'));
});

app.get('/', function (req, res) {
    console.log("something");
    res.send()
});