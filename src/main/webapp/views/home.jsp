<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Home</title>
    <style type="text/css">
        input, select {
            margin: 0px 0px 20px 10px;
        }

        button {
            background-color: #4CAF50;
            border: none;
            color: white;
            padding: 15px 32px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            margin: 4px 2px;
            cursor: pointer;
        }

        button:hover {
            background-color: #008CBA;
            color: white;
        }

        h1 {
            color: blue;
        }
    </style>

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
            <h1>Choose Your Option</h1>
            <form class="form-horizontal" method="POST" action="/login">
                <div class="form-group">
                    <div class="col-sm-offset-2 col-sm-10">
                        <button style="width: 80%; padding-right: 10%; padding-left: 10%;" type="submit"
                                class="btn btn-success"><h1>Login</h1></button>
                    </div>
                </div>
            </form>

            <form class="form-horizontal" method="POST" action="/signIn">
                <div class="form-group">
                    <div class="col-sm-offset-2 col-sm-10">
                        <button style="width: 80%; padding-right: 10%; padding-left: 10%;" type="submit"
                                class="btn btn-primary"><h1>Signin</h1></button>
                    </div>
                </div>
            </form>

            <br>
            <br>
            <br>

        </div>
    </div>
</div>
</body>

<div id="footer">
    <%@ include file="fragments/footer.jspf" %>
</div>

</html>
