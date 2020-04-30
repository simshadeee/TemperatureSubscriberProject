<%--
  Created by IntelliJ IDEA.
  User: simringuglani
  Date: 2/13/20
  Time: 10:59 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<html>
  <head>
    <title>Weather!</title>
    <script type="text/javascript" language="javascript" src="functions.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/paho-mqtt/1.0.1/mqttws31.js" type="text/javascript"></script>
    <script>

      var temp='pittsburgh/temperature/*';
      // Create a client instance
      client = new Paho.MQTT.Client('localhost', Number(9002), 'clientId');

      // set callback handlers
      client.onConnectionLost = onConnectionLost;
      client.onMessageArrived = onMessageArrived;

      // called when the client connects
      function updateSubscription(sub) {
        console.log('unsubscribe from ' + temp);
        client.unsubscribe(temp);
        // Once a connection has been made, make a subscription and send a message.
        temp = 'pittsburgh/temperature/' + sub;
        document.getElementById("contentHere").innerHTML = 'Waiting on Updates from new subscription to ' + temp;
        console.log(temp);
        client.subscribe(temp);
      }

      // connect the client
      client.connect({onSuccess:onConnect});

      // called when the client connects
      function onConnect() {
        // Once a connection has been made, make a subscription and send a message.
        console.log("onConnect");
        client.subscribe(temp);
        message = new Paho.MQTT.Message("Please choose a subscription");
        message.destinationName = temp;
        client.send(message);
      }

      // called when the client loses its connection
      function onConnectionLost(responseObject) {
        if (responseObject.errorCode !== 0) {
          console.log("onConnectionLost:"+responseObject.errorMessage);
        }
      }

      // called when a message arrives
      function onMessageArrived(message) {
        console.log("onMessageArrived:"+message.payloadString);
        message = message.payloadString;
        document.getElementById("contentHere").innerHTML = message;
      }

    </script>
  </head>
  <body>
    <div style="align-items: center; top: 60px; right: 0px; width: 100%">
      <h2 style= "text-align: center;">Choose Your Weather Channel</h2>
      <table style="width:40%; outline: midnightblue"; align="center">
        <p style="text-align: center">Which channel would you like to subscribe to?</p>
        <tr style="text-align: center">
          <th>Cold Weather</th>
          <th>Nice Weather</th>
          <th>Hot Weather</th>
          <th>All Weather</th>
        </tr>
        <tr style="text-align: center">
          <td><button onclick="updateSubscription('coldTemps')">Subscribe</button></td>
          <td><button onclick="updateSubscription('niceTemps')">Subscribe</button></td>
          <td><button onclick="updateSubscription('hotTemps')">Subscribe</button></td>
          <td><button onclick="updateSubscription('#')">Subscribe</button></td>
        </tr>
        <br>
        <tr style="text-align: center">
          <td colspan="4" id = "contentHere">This should be the big one. Lets see how big it is</td>
        </tr>
      </table>
    </div>
  </body>
</html>
