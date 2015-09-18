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
      response.success();
    }
  });
});

Parse.Cloud.afterSave("Request", function(request, response) {
  if (request.object.isNew()) {
      // Let new object go through
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
        if (object.get("type") == "bang" && object.get("fromUserRead") == true) {
          object.destroy({
            success: function(myObject) {
             response.success();
            },
            error: function(myObject, error) {
              response.error(error);
            }
          });
        } else if (object.get("type") == "hook" && object.get("fromUserRead") == true && object.get("toUserRead") == true) {
          object.destroy({
            success: function(myObject) {
             response.success();
            },
            error: function(myObject, error) {
              response.error(error);
            }
          });
        }
      }
    },
    error: function(error) {
      response.success();
    }
  });
});