var greenworks = require('greenworks');

if (greenworks) {
  if (greenworks.initAPI()) {
    function send(data) {
      app.ports.fromGreenworks.send(data);
    }

    app.ports.toGreenworks.subscribe(function (data) {
      switch (data.action) {
        case "getNumberOfPlayers":
          greenworks.getNumberOfPlayers(
            function(num) {
              console.log("ok")
              send({message: "numberOfPlayers", value: num});
            },
            function(err) {
              console.log("err")
              send({message: "numberOfPlayers", value: err});
            }
          );
          break

        default:
          console.log(
            'Greenworks communication error: action "'
            + data.action
            + '" is not supported.'
          );
      }
    });

    greenworks.on('steam-servers-connected', function() {
      send({message: "connected"});
    });

    greenworks.on('steam-servers-disconnected', function() {
      send({message: "disconnected"});
    });

    greenworks.on('steam-server-connect-failure', function() {
      send({message: "connectFailure"});
    });

    greenworks.on('steam-shutdown', function() {
      send({message: "shutdown"});
    });

    send({message: 'greenworks', value: true});

    send({message: "isCloudEnabled", value: greenworks.isCloudEnabled()});

    send({
      message: "isCloudEnabledForUser",
      value: greenworks.isCloudEnabledForUser()
    });
  } else {
    send({message: 'greenworks', value: false});
  }
} else {
  send({message: 'greenworks'});
}
