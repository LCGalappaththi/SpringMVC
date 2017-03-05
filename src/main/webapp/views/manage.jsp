<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Facilitator Manage</title>
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
        <div class="panel-heading"><h1>Facilitator Home Page</h1>
            <h2 id="msg">${msg}</h2></div>
        <div class="panel-body">
            <h1 style="display: inline;">Hello ${loggedUserName} Welcome Back!!!</h1>

            <form action="/logout" class="form-horizontal" method="POST">
                <div class="form-group">
                    <div class="col-sm-offset-2 col-sm-10">
                        <input type="submit" class="btn btn-primary" value="Logout"/>
                    </div>
                </div>
            </form>

            <form action="/details" class="form-horizontal" method="POST">
                <div class="form-group">
                    <div class="col-sm-offset-2 col-sm-10">
                        <input type="submit" class="btn btn-primary" value="My Account"/>
                    </div>
                </div>
            </form>

            <form action="/delete" class="form-horizontal" method="POST">
                <div class="form-group">
                    <div class="col-sm-offset-2 col-sm-10">
                        <input type="submit" class="btn btn-primary" value="Delete Account"/>
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
