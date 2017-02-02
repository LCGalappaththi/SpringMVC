
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Facilitator Manage</title>
    <script type="text/javascript">
        function clear(){
            document.getElementById("msg").innerHTML="&nbsp;";
        }
        function showText(){
            setTimeout(clear,3000);
        }
    </script>
</head>
<body onload="showText()">
<h2 id="msg">${msg}</h2>
<h1 style="display: inline;">Hello ${loggedUserName}</h1>
<form  action="/logout" method="GET">
    <input type="submit" value="Logout"/>
</form>
<form  action="/details" method="GET">
    <input type="submit" value="My Account"/>
</form>
<form  action="/delete" method="GET">
    <input type="submit" value="Delete Account"/>
</form>
</body>
</html>
