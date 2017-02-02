
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Geolocation</title>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <meta charset="utf-8">
    <style>
        #map {
            height: 100%;
        }

        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
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

<script>


    function initMap() {
        var map = new google.maps.Map(document.getElementById('map'), {
            center: {lat: -34.397, lng: 150.644},
            zoom: 12
        });

        var infoWindow= new google.maps.InfoWindow({map: map});

        // Try HTML5 geolocation.
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function(position) {
                var pos = {
                    lat: position.coords.latitude,
                    lng: position.coords.longitude
                };
                infoWindow.setPosition(pos);
                infoWindow.setContent('You Are Here');
                map.setCenter(pos);
                directionsDisplay = new google.maps.DirectionsRenderer();
                var directionsService = new google.maps.DirectionsService;
                directionsDisplay.setMap(map);
                calculateAndDisplayRoute(directionsService, directionsDisplay,position.coords.latitude,position.coords.longitude);
                document.getElementById('mode').addEventListener('change', function() {
                    calculateAndDisplayRoute(directionsService, directionsDisplay,position.coords.latitude,position.coords.longitude);
                });
            }, function() {
                handleLocationError(true, infoWindow, map.getCenter());
            });
        } else {
            // Browser doesn't support Geolocation
            handleLocationError(false, infoWindow, map.getCenter());
        }
    }

    function handleLocationError(browserHasGeolocation,infoWindow, pos) {
        infoWindow.setPosition(pos);
        infoWindow.setContent(browserHasGeolocation ?
            'Error: The Geolocation service failed.' :
            'Error: Your browser doesn\'t support geolocation.');
    }

    function calculateAndDisplayRoute(directionsService,directionsDisplay,latitude,longitude) {
        var selectedMode = document.getElementById('mode').value;
        directionsService.route({
            origin: {lat: latitude, lng: longitude},              //my location
            destination: {lat: ${latitude}, lng: ${longitude}},  // facilitator location
            travelMode: google.maps.TravelMode[selectedMode]
        }, function(response, status) {
            if (status == 'OK') {
                directionsDisplay.setDirections(response);
            } else {
                window.alert('Directions request failed due to ' + status);
            }
        });
    }

</script>
<script async defer
        src="https://maps.googleapis.com/maps/api/js?key=AIzaSyARnfrrY6BwdvVAbYDFjmIFEtIoFpjIMYk&callback=initMap">
</script>
<body>
<div id="floating-panel">
    <b>Mode of Travel: </b>
    <select id="mode">
        <option value="DRIVING">Driving</option>
        <option value="WALKING">Walking</option>
        <option value="BICYCLING">Bicycling</option>
        <option value="TRANSIT">Transit</option>
    </select>
</div>
<div id="map"></div>
</body>
</html>