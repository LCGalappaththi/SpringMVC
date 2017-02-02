
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login</title>
    <script type="text/javascript">
        function clear(){
            document.getElementById("msg").innerHTML="&nbsp;";
            document.getElementById("status").innerHTML="&nbsp;";
        }
        function showText(){
            setTimeout(clear,3000);
        }
    </script>
</head>
<body onload="showText()">
<h2 id="msg">${msg}</h2>
<h1>Facilitator Login Page</h1>
<form action="/logged" method="GET">
    <label>Username:</label><input type="text" name="user" placeholder="Enter Username"/><br>
    <label>Password:</label><input type="password" name="pass" placeholder="Enter Password"/><br>
    <input type="submit" value="Login"/>
    <h1 id="status">${status}  ${loggedUser}</h1>
</form>
</body>
</html>
