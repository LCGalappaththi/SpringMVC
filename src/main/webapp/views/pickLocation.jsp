<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
    <script type="text/javascript" async defer src="http://maps.google.com/maps/api/js?key=AIzaSyARnfrrY6BwdvVAbYDFjmIFEtIoFpjIMYk"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
    <script type="text/javascript">
        var index=0;
        var map;
        var latLng;
        var trafficLayer;
        navigator.geolocation.getCurrentPosition(initialize);

        function initialize(position) {
            latLng = new google.maps.LatLng(position.coords.latitude,position.coords.longitude);

            var destinations=[];
            <c:forEach var="facilitator" items="${coordinates}">
            destinations.push(new google.maps.LatLng(${facilitator.getLatitude()},${facilitator.getLongitude()}));
            </c:forEach>

            trafficLayer = new google.maps.TrafficLayer();
            var service = new google.maps.DistanceMatrixService();
            service.getDistanceMatrix(
                {
                    origins: [latLng],
                    destinations: destinations,
                    travelMode: 'DRIVING',
                    unitSystem: google.maps.UnitSystem.METRIC,
                    avoidHighways: true,
                    avoidTolls: true,
                }, callback);

             map = new google.maps.Map(document.getElementById('mapCanvas'), {
                zoom: 9,
                center: latLng,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            });
            var marker = new google.maps.Marker({
                position: latLng,
                title: "You Are Here",
                map: map,
                draggable: false
            });

            var infowindow = new google.maps.InfoWindow({
                content: "You Are Here"
            });

            infowindow.open(map, marker);

        }


        function callback(response, status) {
            var destin;
            var infowindow;
            directionsDisplay = new google.maps.DirectionsRenderer({suppressMarkers: true});
            var directionsService = new google.maps.DirectionsService;
            if (status == 'OK') {
                var origins = response.originAddresses;
                var destinations = response.destinationAddresses;
                var minimum=parseFloat(response.rows[0].elements[0].distance.text.replace("km",""));
                for (var i = 0; i < origins.length; i++) {
                    var results = response.rows[i].elements;

                    for (var j = 0; j < results.length; j++) {
                        var element = results[j];
                        var distance = element.distance.text;
                        var duration = element.duration.text;
                        var from = origins[i];
                        var to = destinations[j];
                        if(minimum>parseFloat(distance.replace("km",""))){
                            minimum = parseFloat(distance.replace("km",""));
                            index=j;
                        }
                    }
                }
                var count=0;
                <c:forEach var="facilitator" items="${coordinates}">
                destin = new google.maps.LatLng(${facilitator.getLatitude()},${facilitator.getLongitude()});
                if(index==count){
                    var marker = new google.maps.Marker({
                        position: destin,
                        title: "${facilitator.getName()}",
                        map: map,
                        animation: google.maps.Animation.BOUNCE,         //nearest facilitator will bounce
                        facilitator:"${facilitator.getFacilitatorId()}", //custom attribute
                        draggable: false
                    });
                     infowindow = new google.maps.InfoWindow({
                        content:"<span style='color:red'><b>Nearest Facilitator:</b></span><br/>${facilitator.getName()}"
                    });

                    directionsDisplay.setMap(map);
                    calculateAndDisplayRoute(directionsService, directionsDisplay,latLng,destin);

                }else{
                    var marker = new google.maps.Marker({
                        position: destin,
                        title: "${facilitator.getName()}",
                        map: map,
                        facilitator:"${facilitator.getFacilitatorId()}", //custom attribute
                        draggable: false
                    });
                     infowindow = new google.maps.InfoWindow({
                        content: "${facilitator.getName()}"
                    });
                }


                infowindow.open(map, marker);

                marker.addListener('click', function() {
                    window.open("/selectedFacilitator/"+this.facilitator,"MsgWindow", "width=1000, height=600");
                });
                count++;
                </c:forEach>

            }
        }

        function calculateAndDisplayRoute(directionsService,directionsDisplay,origin,destination) {
            directionsService.route({
                origin: origin,              //my location
                destination: destination,  // facilitator location
                travelMode: google.maps.TravelMode.DRIVING,
                avoidHighways: true
            }, function(response, status) {
                if (status == 'OK') {
                    directionsDisplay.setDirections(response);
                } else {
                    window.alert('Directions request failed due to ' + status);
                }
            });
        }

        function handleLocationError(browserHasGeolocation,infoWindow, pos) {
            infoWindow.setPosition(pos);
            infoWindow.setContent(browserHasGeolocation ?
                'Error: The Geolocation service failed.' :
                'Error: Your browser doesn\'t support geolocation.');
        }

        function enableTraffic() {
            if(document.getElementById("t").innerHTML=="Don't Show Traffic"){
                trafficLayer.setMap(null);
                document.getElementById("t").innerHTML="Show Traffic";
            }else{
                trafficLayer.setMap(map);
                document.getElementById("t").innerHTML="Don't Show Traffic";
            }
        }

    </script>

    <style>
        #mapCanvas {
            width: 1000px;
            height: 800px;
        }
        #floating-panel {
            position: absolute;
            top: 10px;
            left: 25%;
            z-index: 5;
            background-color: #fff;
            padding: 5px;
            border: 1px solid #999;
            text-align: center;
            font-family: 'Roboto','sans-serif';
            line-height: 30px;
            padding-left: 10px;
        }
    </style>
</head>
<body>
<div id="floating-panel">
    <button id="traffic" onclick="enableTraffic()"><b id="t">Show Traffic</b></button>
</div>
<div id="mapCanvas"></div>
</body>
</html>
