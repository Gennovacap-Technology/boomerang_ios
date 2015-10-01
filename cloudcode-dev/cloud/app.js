GLOBAL.Parse = require('parse/node').Parse;

Parse.initialize("kb5KPJAtHIlxwXcSXBSsENdU8ysMZ6oTAGYQUZpv", 
	"1B6JVv7sI3Us6gHKoZE50v15HzGAMqXRXFRYA26b",
	"Dk3yH7I4OQoJLwOYOB8dwtWwoqKLaDBE4CwG8Vtw");
Parse.Cloud.useMasterKey();

var express = require('express');

var app = express();

app.use(express.urlencoded());

var relationsController = require('./controllers/relations.js');
var requestsController = require('./controllers/requests.js');

app.post('/relations', relationsController.create);
app.delete('/relations/all', relationsController.deleteAll);

app.post('/requests', requestsController.create);
app.delete('/requests', requestsController.delete);
app.delete('/requests/all', requestsController.deleteAll);

//app.listen();

var server = app.listen(8000, function () {
  var host = server.address().address;
  var port = server.address().port;

  console.log('Listening at http://%s:%s', host, port);
});
