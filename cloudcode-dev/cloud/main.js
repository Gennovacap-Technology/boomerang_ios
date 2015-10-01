require('cloud/app.js');

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

  fromQuery.first().then(function(object) {
    if (object) {
      response.error("Request already sent");
      return;
    }

    return toQuery.first().then(function(object) {
      if (object) {
        response.error("Request already received");
        return;
      } else {
        response.success();
      }
    }, function(error) {
      response.error(error);
    });

  }, function(error) {
    response.error(error);
  });
});

// Push notifications

Parse.Cloud.afterSave("Request", function(request) {

  var query = new Parse.Query("Request");

  query.include("fromUser");
  query.include("toUser");

  query.get(request.object.id).then(function(request) {

    if (request.get("type") == "bangs" &&
      request.get("fromUserRead") == false && 
      request.get("accepted") == true) {

      sendPush(request.get("fromUser"), 
        request.get("fromUser").get("firstName") + " accepted your bang request");
  
    }

    if (request.get("type") == "hooks" &&
        request.get("toUserRead") == false && 
        request.get("accepted") == false) {

      sendPush(request.get("toUser"), 
        request.get("fromUser").get("firstName") + " wants to make love again");
    
    }

    if (request.get("type") == "hooks" &&
        request.get("fromUserRead") == false &&  
        request.get("accepted") == true) {

      sendPush(request.get("fromUser"),
        request.get("toUser").get("firstName") + " accepted make love again");
    
    }

  }, function(error) {
    console.error("Got an error " + error.code + " : " + error.message);
  });

});

function sendPush(user, message) {    
  var queryInst = new Parse.Query(Parse.Installation);
  queryInst.equalTo('user', user);

  Parse.Push.send({
    where: queryInst,
    data: {
      alert: message
    }
  }, {
    success: function() {
      console.log("Push sent");
    },
    error: function(error) {
      console.log("Push error: " + error);
    }
  });
}
