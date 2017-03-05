<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login</title>
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
        <div class="panel-heading"><h1>Facilitator Login Page</h1>
            <h1 id="msg">${msg} ${status} ${loggedUser}</h1></div>
        <div class="panel-body">
            <form action="/logged" class="form-horizontal" method="POST">
                <div class="form-group">
                    <label class="control-label col-sm-2">Username:</label>
                    <div class="col-sm-6">
                        <input type="text" class="form-control" name="user" placeholder="Enter Username"/><br>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-sm-2">Password:</label>
                    <div class="col-sm-6">
                        <input type="password" class="form-control" name="pass" placeholder="Enter Password"/><br>
                    </div>
                </div>

                <div class="form-group">
                    <div class="col-sm-offset-2 col-sm-10">
                        <button type="submit" class="btn btn-success"><h4>Login>></h4></button>
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
