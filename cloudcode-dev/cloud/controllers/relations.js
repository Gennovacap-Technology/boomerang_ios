exports.create = function(req, res) {
	Parse.Cloud.useMasterKey();

	console.log("Creating relation");

	var fromUserQuery = new Parse.Query(Parse.User);
	var toUserQuery = new Parse.Query(Parse.User);

	fromUserQuery.get(req.body.fromUser).then(function(fromUser) {
		toUserQuery.get(req.body.toUser).then(function(toUser) {

			var fromRelation = fromUser.relation(req.body.type);
			fromRelation.add(toUser);

			var toRelation = toUser.relation(req.body.type);
			toRelation.add(fromUser);

			fromUser.save();
			toUser.save();

			console.log('Success saving relation');
			res.send('Success saving relation');
		}, function(error) {
			console.log('Failed finding toUser: ' + error.message);
			res.status(500).send('Failed finding toUser: ' + error.message);
		});

	}, function(error) {
		console.log('Failed finding fromUser: ' + error.message);
		res.status(500).send('Failed finding fromUser: ' + error.message);
	});
}

exports.deleteAll = function(req, res) {
	Parse.Cloud.useMasterKey();
	console.log("Deleting all relations");

	var queryUsers = new Parse.Query(Parse.User);

	queryUsers.find({
	  success: function(users) { 
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

			console.log("All relations deleted");
			res.status(201).send('Success removing relations');
	  }, 
	  error:function(error) {
	  	console.log('Failed removing relations: ' + error.message);
	    res.status(500).send('Failed removing relations: ' + error.message);
	  }
	});
}