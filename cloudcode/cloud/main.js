Parse.Cloud.beforeSave("Request", function(request, response) {
	if (!request.object.isNew()) {
      // Let existing object updates go through
      response.success();
  }

	var fromQuery = new Parse.Query("Request");

	fromQuery.equalTo("fromUser", request.object.get("fromUser"));
	fromQuery.equalTo("toUser", request.object.get("toUser"));
	fromQuery.equalTo("type", request.object.get("type"));

	var toQuery = new Parse.Query("Request");

	toQuery.equalTo("fromUser", request.object.get("toUser"));
	toQuery.equalTo("toUser", request.object.get("fromUser"));
	toQuery.equalTo("type", request.object.get("type"));

	var mainQuery = Parse.Query.or(fromQuery, toQuery);

	mainQuery.first ({
		success: function(object) {
			if (object) {
				response.error("Request already created.");
			} else {
				response.success();
			}
    },
    error: function(error) {
    	console.log(error.message);
      response.success();
    }
  });
});