
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
            h1{
                color:blue;
            }
        </style>
        <script type="text/javascript">
            function loadPage(option){
                if(option==1){
                    window.open("/login","MsgWindow", "width=1000, height=600");
                }else
                    window.open("/signIn","MsgWindow", "width=1000, height=600");
            }

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
    <h1>Facilitator Home Page</h1>
    <button onclick="loadPage(1)" id="logInBtn">
        <h2>Log In</h2>
    </button>
    <button onclick="loadPage(2)" id="signInBtn">
        <h2>Sign In</h2>
    </button>
    <br>
    <br>
    <br>
    <h1>Choose Your Option</h1>
    </body>
    </html>
