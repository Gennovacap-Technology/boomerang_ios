var Request = Parse.Object.extend('Request');

exports.create = function(req, res) {
	console.log("Creating request");

	var request = new Request();

	var fromUser = new Parse.User();
	fromUser.id = req.body.fromUser;

	request.set('fromUser', fromUser);

	var toUser = new Parse.User();
	toUser.id = req.body.toUser;

	request.set('toUser', toUser);

	request.set('fromUserRead', req.body.fromUserRead === 'true');
	request.set('toUserRead', req.body.toUserRead === 'true');
	request.set('type', req.body.type);
	request.set('accepted', req.body.accepted === 'true');

	request.save().then(function(httpResponse) {
		console.log('Success saving request')
		res.status(200).send('Success saving request');
	},
	function(error) {
		console.log('Failed saving request: ' + error.message);
		res.status(500).send('Failed saving request: ' + error.message);
	}); 
}

exports.delete = function(req, res) {
	console.log('Deleting request');

	var request = new Request();
	var query = new Parse.Query(Request);

	var fromUser = new Parse.User();
	fromUser.id = req.body.fromUser;

	query.equalTo('fromUser', fromUser);

	var toUser = new Parse.User();
	toUser.id = req.body.toUser;

	query.equalTo('toUser', toUser);

	query.equalTo('type', req.body.type);

	query.find().then(function(results) {
		for (var i in results) {
	  	results[i].destroy({
				success: function() {	},
				error: function(error) {
					console.log(error);
				}
			});
		}

		console.log('Success deleting request');
		res.status(201).send('Success deleting request');
	},
	function(error) {
		console.log('Failed deleting request: ' + error.message);
		res.status(500).send('Failed deleting request: ' + error.message);
	}); 
}

exports.deleteAll = function(req, res) {
	console.log('Deleting all requests');

	var request = new Request();
	var query = new Parse.Query(Request);

	query.find().then(function(results) {
		for (var i in results) {
	  	results[i].destroy({
				success: function() {	},
				error: function(error) {
					console.log('Failed deleting request: ' + error.message);
					res.status(500).send('Failed deleting request: ' + error.message);
				}
			});
		}

		console.log('Success deleting request');
		res.status(201).send('Success deleting request');
	},
	function(error) {
		console.log('Failed deleting request: ' + error.message);
		res.status(500).send('Failed deleting request: ' + error.message);
	}); 
}
