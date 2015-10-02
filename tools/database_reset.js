var Parse = require('parse/node');

Parse.initialize("kb5KPJAtHIlxwXcSXBSsENdU8ysMZ6oTAGYQUZpv", 
	"1B6JVv7sI3Us6gHKoZE50v15HzGAMqXRXFRYA26b",
	"Dk3yH7I4OQoJLwOYOB8dwtWwoqKLaDBE4CwG8Vtw");
Parse.Cloud.useMasterKey();

var Request = Parse.Object.extend("Request");
var queryRequests = new Parse.Query(Request);

queryRequests.find({
    success:function(results) {
    	console.log("Total of Requests: " + results.length);
    	deleteObjects(results);
    }, 
    error:function(error) {
      console.log("Error when getting requests!");
    }
});

function deleteObjects(objects) {
	for (var i in objects) {
  	objects[i].destroy({
			success: function() {	},
			error: function(error) {
				console.log(error);
			}
		});
	}
}

var queryUsers = new Parse.Query(Parse.User);

queryUsers.find({
  success: function(results) {
    console.log("Total of Users: " + results.length);
    deleteBangRelations(results);
  }, 
  error:function(error) {
    console.log(error);
  }
});

function deleteBangRelations(users) {
	for (var i in users) {
			var user = users[i];
			var relationBangs = user.relation("bangs");
			var relationHooks = user.relation("hooks");

			for (var j in users) {
				relationBangs.remove(users[j]);
				relationHooks.remove(users[j]);
			}

			user.save();
	}
}