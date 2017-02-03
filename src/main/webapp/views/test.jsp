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

        function loadImage() {
            window.open("/showImage?usr=${details.getUsername()}", "MsgWindow", "width=1000, height=600");
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


            <h1>---------------------Your details----------------------------</h1>
            <c:out value="${details.name}"/>
            <h2>${details.getPassword()}</h2>
            <h2>${details.getName()}</h2>
            <h2>${details.getAddress()}</h2>
            <h2>${details.getUsername()}</h2>

            <form action="/logout" method="GET">
                <input type="submit" value="Logout"/>
            </form>

            <form action="/update" method="GET">
                <input type="submit" value="Change Details"/>
            </form>

            <form action="/maps" method="GET">
                <input type="submit" value="show me in map"/>
            </form>

            <button  onclick="loadImage()" id="imageBtn">
                <h4>Show Image</h4>
            </button>

        </div>
    </div>
</div>

</body>

<div id="footer">
    <%@ include file="fragments/footer.jspf" %>
</div>

</html>
