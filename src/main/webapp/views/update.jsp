<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Update Details</title>
    <style>
        #mapCanvas {
            width: 500px;
            height: 400px;
            float: left;
        }

        #infoPanel {
            float: left;
            margin-left: 10px;
        }

        #infoPanel div {
            margin-bottom: 5px;
        }

    </style>
    <script type="text/javascript"
            src="http://maps.google.com/maps/api/js?key=AIzaSyARnfrrY6BwdvVAbYDFjmIFEtIoFpjIMYk"></script>
    <script type="text/javascript">
        var latLng;
        var map;
        var marker;

        function checkUser(str) {
            if (str.length == 0) {
                document.getElementById("valid").innerHTML = "";
                return;
            } else {
                if (str.length < 6) {
                    document.getElementById("valid").style.color = "red";
                    document.getElementById("valid").innerHTML = "<- too short";
                    plate = 0;
                } else {
                    var xmlhttp = new XMLHttpRequest();
                    xmlhttp.onreadystatechange = function () {
                        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                            document.getElementById("valid").innerHTML = xmlhttp.responseText;
                        }
                    };
                    xmlhttp.open("GET", "ajax/" + str, true);
                    xmlhttp.send();
                }
            }
        }

        function clear() {
            document.getElementById("msg").innerHTML = "&nbsp;";
        }

        function showText() {
            document.getElementById("previous").disabled = true;
            setTimeout(clear, 3000);
        }

        var geocoder = new google.maps.Geocoder();

        function geocodePosition(pos) {
            geocoder.geocode({
                latLng: pos
            }, function (responses) {
                if (responses && responses.length > 0) {
                    updateMarkerAddress(responses[0].formatted_address);
                } else {
                    updateMarkerAddress('Cannot determine address at this location.');
                }
            });
        }

        function updateMarkerStatus(str) {
            document.getElementById('markerStatus').innerHTML = str;
        }

        function updateMarkerPosition(latLng) {
            document.getElementById('info').innerHTML = [
                latLng.lat(),
                latLng.lng()
            ].join(', ');
            document.getElementById('lati').value = latLng.lat();
            document.getElementById('longi').value = latLng.lng();
        }

        function updateMarkerAddress(str) {
            document.getElementById('address').innerHTML = str;
        }

        function getCurrent() {
            document.getElementById("previous").disabled = false;
            document.getElementById("current").disabled = true;
            navigator.geolocation.getCurrentPosition(showCurrent);
        }

        function showCurrent(position) {
            var current = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
            map = new google.maps.Map(document.getElementById('mapCanvas'), {
                zoom: 12,
                center: current,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            });
            if (marker && marker.setMap) {
                marker.setMap(null);
            }
            marker = new google.maps.Marker({
                position: current,
                title: 'Your Location',
                map: map,
                draggable: true
            });
            updateMarkerPosition(current);
            geocodePosition(current);

        }


        function initialize() {
            document.getElementById("previous").disabled = true;
            document.getElementById("current").disabled = false;
            latLng = new google.maps.LatLng(${details.getLatitude()}, ${details.getLongitude()});
            map = new google.maps.Map(document.getElementById('mapCanvas'), {
                zoom: 12,
                center: latLng,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            });
            marker = new google.maps.Marker({
                position: latLng,
                title: 'Your Location',
                map: map,
                draggable: true
            });

            // Update current position info.
            updateMarkerPosition(latLng);
            geocodePosition(latLng);

            // Add dragging event listeners.
            google.maps.event.addListener(marker, 'dragstart', function () {
                updateMarkerAddress('Dragging...');
            });

            google.maps.event.addListener(marker, 'drag', function () {
                updateMarkerStatus('Dragging...');
                updateMarkerPosition(marker.getPosition());
            });

            google.maps.event.addListener(marker, 'dragend', function () {
                updateMarkerStatus('Drag ended');
                geocodePosition(marker.getPosition());
            });
        }

        // Onload handler to fire off the app.
        google.maps.event.addDomListener(window, 'load', initialize);
    </script>
</head>

<div id="header">
    <%@ include file="fragments/header.jspf" %>
</div>

<body onload="showText()">
<div class="container">
    <div class="panel panel-primary">
        <div class="panel-heading"><h1> Hello ${loggedUserName} Update your Details</h1>
            <h2 id="msg">${msg}</h2></div>
        <div class="panel-body">
            <form class="form-horizontal" action="/updatenow" method="GET">

                <div class="form-group">
                    <label class="control-label col-sm-2">Username:</label>
                    <div class="col-sm-6">
                        <input type="text" class="form-control" name="username" onblur="checkUser(this.value)"
                               onkeyup="checkUser(this.value)" value="${details.getUsername()}"/>
                        <label id="valid"></label><br>
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label col-sm-2">Password:</label>
                    <div class="col-sm-6">
                        <input type="password" class="form-control" name="password"
                               value="${details.getPassword()}"/><br>
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label col-sm-2">Retype Password:</label>
                    <div class="col-sm-6">
                        <input type="password" class="form-control" name="passwordConfirm"
                               placeholder="Re-type Password"/><br>
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label col-sm-2">Name:</label>
                    <div class="col-sm-6">
                        <input type="text" class="form-control" name="name" value="${details.getName()}"/><br>
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label col-sm-2">Address:</label>
                    <div class="col-sm-6">
                        <input type="text" class="form-control" name="address" value="${details.getAddress()}"/><br>
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label col-sm-2">ContactNo 1:</label>
                    <div class="col-sm-6">
                        <input type="text" class="form-control" name="contact1" value="${details.getContact1()}"/><br>
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label col-sm-2">ContactNo 2:</label>
                    <div class="col-sm-6">
                        <input type="text" class="form-control" name="contact2"
                               value="${details.getContact2()}"/><br>
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label col-sm-2">ContactNo 3:</label>
                    <div class="col-sm-6">
                        <input type="text" class="form-control" name="contact3"
                               value="${details.getContact3()}"/><br>
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label col-sm-2">Type:</label>
                    <div class="col-sm-6">
                        <input type="text" class="form-control" name="type" value="${details.getType()}"/><br>
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label col-sm-2">Longitude:</label>
                    <div class="col-sm-6">
                        <input type="text" id="longi" class="form-control" name="longitude"
                               value="${details.getLongitude()}"/><br>
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label col-sm-2">Latitude:</label>
                    <div class="col-sm-6">
                        <input type="text" id="lati" class="form-control" name="latitude"
                               value="${details.getLatitude()}"/><br>
                    </div>
                </div>

                <div class="form-group">
                    <div class="col-sm-offset-2 col-sm-10">
                        <input type="submit" class="btn btn-success" value="Update details"/>
                    </div>
                </div>
            </form>

            <form class="form-horizontal" action="/logout" method="GET">
                <input type="submit" class="btn btn-primary" value="Logout"/>
            </form>

            <div id="floating-panel">
                <button id="current" onclick="getCurrent()">Get Current Location</button>
                <button id="previous" onclick="initialize()">Get Previous Location</button>
            </div>

            <div id="mapCanvas"></div>

            <div id="infoPanel">
                <b>Marker status:</b>
                <div id="markerStatus"><i>Click and drag the marker.</i></div>
                <b>Current position:</b>
                <div id="info"></div>
                <b>Closest matching address:</b>
                <div id="address"></div>
            </div>

        </div>
    </div>
</div>
</body>

<div id="footer">
    <%@ include file="fragments/footer.jspf" %>
</div>

</html>