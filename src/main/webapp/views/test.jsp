<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>Your Details</title>
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
<h1>Your details</h1>
<c:out value="${details.name}"/>
<h2>${details.getPassword()}</h2>
<h2>${details.getName()}</h2>
<h2>${details.getAddress()}</h2>

<form  action="/logout" method="GET">
    <input type="submit" value="Logout"/>
</form>

<form  action="/update" method="GET">
    <input type="submit" value="Change Details"/>
</form>

<form  action="/maps" method="GET">
    <input type="submit" value="show me in map"/>
</form>
</body>
</html>
