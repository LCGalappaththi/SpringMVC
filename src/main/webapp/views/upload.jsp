<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>Upload Image</title>
</head>

<div id="header">
    <%@ include file="fragments/header.jspf" %>
</div>

<body>
<div class="container">

    <div class="panel panel-primary">
        <div class="panel-heading">
            <h2 id="msg">${msg}</h2></div>

        <div class="panel-body">

            <form class="form-horizontal" action="uploadServlet" method="POST" enctype="multipart/form-data">

                <div class="form-group">
                    <label class="control-label col-sm-2">Image:</label>
                    <div class="col-sm-6">
                        <input type="file" class="form-control" name="file" value="" width="100"/>
                    </div>
                </div>

                <div class="form-group">
                    <div class="col-sm-offset-2 col-sm-10">
                        <input type="submit" class="btn btn-success" value="Upload Now"/>
                    </div>
                </div>

            </form>

            <form class="form-horizontal" action="/login" method="GET">
                <div class="form-group">
                    <div class="col-sm-offset-2 col-sm-10">
                        <input type="submit" class="btn btn-primary" value="Skip this step"/>
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

