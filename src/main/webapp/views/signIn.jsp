<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>SignIn</title>
    <meta charset="utf-8">
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
    <script src="${pageContext.request.contextPath}/resources/jquery/jquery-3.1.1.min.js"></script>

    <script type="text/javascript">
        var latLng;
        var map;
        var marker;
        var validEmail = 0;

        function checkUser(str) {
            if (str.length == 0) {
                document.getElementById("valid").innerHTML = "";
                return;
            } else {
                if (str.length < 6) {
                    document.getElementById("valid").style.color = "red";
                    document.getElementById("valid").innerHTML = "<- too short";
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

        function checkEmail(str) {
            if (str.length == 0) {
                document.getElementById("validEmail").innerHTML = "";
                return;
            } else {
                if (!/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(str)) {
                    document.getElementById("validEmail").style.color = "red";
                    document.getElementById("validEmail").innerHTML = "<- Invalid Email";
                    document.getElementById("emailBtn").style.display = "none";
                    validEmail = 0;
                } else {
                    document.getElementById("validEmail").style.color = "blue";
                    document.getElementById("validEmail").innerHTML = "<- Valid Email";
                    document.getElementById("emailBtn").style.display = "initial";
                    validEmail = 1;
                }
            }
        }

        function sendEmail() {
            var code;
            var email = document.getElementById("emailtxt").value;
            var name = document.getElementById("name").value;
            if (validEmail == 1) {
                document.getElementById("emailBtn").disabled = true;
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function () {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        if (xmlhttp.responseText == "sent_failed") {
                            document.getElementById("validEmail").style.color = "red";
                            document.getElementById("validEmail").innerHTML = "<-Check Email and Try again";
                            document.getElementById("email_verified").value = "false";
                            document.getElementById("emailBtn").disabled = false;
                        } else {
                            code = prompt("Please enter the confirmation code that we have sent to you(If you are not recieved with our email check  again)", "");

                            if (code == xmlhttp.responseText) {
                                document.getElementById("validEmail").style.color = "blue";
                                document.getElementById("validEmail").innerHTML = "Email Verified";
                                document.getElementById("email_verified").value = "true";
                                document.getElementById("emailtxt").readOnly = true;//disable the email input
                                document.getElementById("emailBtn").style.display = "none";
                            } else {
                                document.getElementById("validEmail").style.color = "red";
                                document.getElementById("validEmail").innerHTML = "Verification Failed";
                                document.getElementById("email_verified").value = "false";
                                document.getElementById("emailBtn").disabled = false;
                                while (true) {
                                    if (confirm('Wrong code!!! Do You Want To Enter code Again?')) {
                                        code = prompt("Please enter the confirmation code that we have sent to you(If you are not recieved with our email check  again)", "");
                                        if (code == xmlhttp.responseText) {
                                            document.getElementById("validEmail").style.color = "blue";
                                            document.getElementById("validEmail").innerHTML = "Email Verified";
                                            document.getElementById("emailtxt").readOnly = true;//disable the email input
                                            document.getElementById("emailBtn").style.display = "none";
                                            document.getElementById("email_verified").value = "true";
                                            break;
                                        }
                                    } else {
                                        break;
                                    }
                                }
                            }
                        }
                    }
                };
                xmlhttp.open("GET", "email?email=" + email + "&name=" + name, true);
                xmlhttp.send();
            }
        }

        function clear() {
            document.getElementById("msg").innerHTML = "&nbsp;";
        }

        function showText() {
            document.getElementById("emailBtn").style.display = "none";
            navigator.geolocation.getCurrentPosition(initialize);
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
            initialize(position);
        }

        function initialize(position) {
            latLng = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
            map = new google.maps.Map(document.getElementById('mapCanvas'), {
                zoom: 12,
                center: latLng,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            });
            marker = new google.maps.Marker({
                position: latLng,
                title: 'Drag this to your location',
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
                document.getElementById("current").disabled = false;
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
        <div class="panel-heading"><h1>Facilitator SignIn Page</h1>
            <h2 id="msg">${msg}</h2></div>
        <div class="panel-body">
            <form class="form-horizontal" method="GET" action="/add">

                <div class="form-group">
                    <label class="control-label col-sm-2">Username:</label>
                    <div class="col-sm-6">
                        <input type="text" class="form-control" name="username" placeholder="Enter Username"
                               onblur="checkUser(this.value)"
                               onkeyup="checkUser(this.value)"/>
                        <label id="valid"></label></br>
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label col-sm-2">Password:</label>
                    <div class="col-sm-6">
                        <input type="password" id="passBox" class="form-control" name="password"
                               placeholder="Enter Password"/>
                        <input type="checkbox"
                               onclick="if(this.checked)passBox.type='text';else passBox.type='password';"/> show
                        characters
                        <br>
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label col-sm-2">Retype Password:</label>
                    <div class="col-sm-6">
                        <input type="password" id="repassBox" class="form-control" name="passwordConfirm"
                               placeholder="Re-type Password"/>
                        <input type="checkbox"
                               onclick="if(this.checked)repassBox.type='text';else repassBox.type='password';"/> show
                        characters
                        <br>
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label col-sm-2">Name:</label>
                    <div class="col-sm-6">
                        <input id="name" type="text" class="form-control" name="name" placeholder="Enter Name"/><br>
                    </div>
                </div>

                <input id="email_verified" type="hidden" name="emailVerified"/>
                <div class="form-group">
                    <label class="control-label col-sm-2">Email:</label>
                    <div class="col-sm-6">
                        <input id="emailtxt" type="text" class="form-control" name="email" placeholder="Enter Email"
                               onblur="checkEmail(this.value)" onkeyup="checkEmail(this.value)"/>
                        <label id="validEmail"></label>
                        <button id="emailBtn" type="button" class="btn btn-primary" onclick="sendEmail()">Send
                            Verification Code
                        </button>
                        <br>
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label col-sm-2">Address:</label>
                    <div class="col-sm-6">
                        <input type="text" class="form-control" name="address" placeholder="Enter Address"/><br>
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label col-sm-2">ContactNo 1:</label>
                    <div class="col-sm-6">
                        <input type="text" class="form-control" name="contact1" placeholder="Enter Contact 1"/><br>
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label col-sm-2">ContactNo 2:</label>
                    <div class="col-sm-6">
                        <input type="text" class="form-control" name="contact2" placeholder="Enter Contact 2"/><br>
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label col-sm-2">ContactNo 3:</label>
                    <div class="col-sm-6">
                        <input type="text" class="form-control" name="contact3" placeholder="Enter Contact 3"/><br>
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label col-sm-2">Type:</label>
                    <div class="col-sm-6">
                        <input type="text" class="form-control" name="type" placeholder="Enter Type"/><br>
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label col-sm-2">Longitude:</label>
                    <div class="col-sm-6">
                        <input type="text" class="form-control" id="longi" name="longitude"/><br>
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label col-sm-2">Latitude:</label>
                    <div class="col-sm-6">
                        <input type="text" class="form-control" id="lati" name="latitude"/><br>
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label col-sm-2"></label>
                    <button id="current" onclick="getCurrent()" class="btn btn-primary">Get Current Location</button>
                </div>

                <div class="form-group">
                    <label class="control-label col-sm-2">Pick Location:</label>
                    <div id="mapCanvas"></div>
                </div>

                <div class="form-group">
                    <label class="control-label col-sm-2"></label>
                    <div id="infoPanel">
                        <b>Marker status:</b>
                        <div id="markerStatus"><i>Click and drag the marker.</i></div>
                        <b>Current position:</b>
                        <div id="info"></div>
                        <b>Closest matching address:</b>
                        <div id="address"></div>
                    </div>
                </div>

                <div class="form-group">
                    <div class="col-sm-offset-2 col-sm-10">
                        <input type="submit" class="btn btn-success" value="Submit"/>
                    </div>
                </div>

            </form>
        </div>
    </div>
</div>
</body>

<div id="footer">
    <%@ include file="fragments/footer.jspf" %>
</div>

</html>
