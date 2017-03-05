<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>Your Details</title>
    <script type="text/javascript">
        function clear() {
            document.getElementById("msg").innerHTML = "&nbsp;";
        }

        function showText() {
            setTimeout(clear, 3000);
        }

    </script>

</head>

<div id="header">
    <%@ include file="fragments/header.jspf" %>
</div>

<body onload="showText()">
<div class="container">
    <div class="panel panel-primary">
        <div class="panel-heading"><h1 style="display: inline;">Hello ${loggedUserName}</h1>
            <h2 id="msg">${msg}</h2></div>
        <div class="panel-body">


            <h1>--------------------------------Your details----------------------------</h1>

            <h2>Name :${details.getName()}</h2>
            <h2>Address:${details.getAddress()}</h2>
            <h2>Email :${details.getEmail()}</h2>
            <h2>Facilitator Type:${details.getType()}</h2>

            <h2>Image:<img width="200" height="200" src="/showImage?usr=${details.getUsername()}" alt="Image"/></h2>

            <form action="/logout" method="POST">
                <input type="submit" class="btn btn-primary" value="Logout"/>
            </form>

            <form action="/update" method="POST">
                <input type="submit" class="btn btn-success" value="Change Details"/>
            </form>

            <form action="/maps" method="POST">
                <input type="submit" class="btn btn-primary" value="show me in map"/>
            </form>

        </div>
    </div>
</div>

</body>

<div id="footer">
    <%@ include file="fragments/footer.jspf" %>
</div>

</html>
