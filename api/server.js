var express = require('express');
var app = express();
var bodyParser = require('body-parser');
var events = require('./routes/event');
var users = require('./routes/user')

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

var mongoose   = require('mongoose');
mongoose.connect('mongodb://localhost:27017/vflyer');

app.use(function(req, res, next) {
    console.log(req.method + " " + req.originalUrl);
    next();
});
app.use('/api/events', events)
app.use('/api/users', users)

app.set('port', process.env.PORT || 8000);

var server = app.listen(app.get('port'), function() {
  console.log('Server listening on port ' + server.address().port);
});
