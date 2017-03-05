<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>Upload Image</title>
</head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script type="text/javascript">
    $(document).ready(function () {
        document.getElementById("upload").disabled = true;
        document.getElementById("file").style.visibility = "hidden";
        $("#uploadBox").change(function () {
            if (document.getElementById("uploadBox").value != "") {
                document.getElementById("upload").disabled = false;
            } else {
                document.getElementById("upload").disabled = true;
            }
        });
    });

</script>

<div id="header">
    <%@ include file="fragments/header.jspf" %>
</div>

<body>
<div class="container">

    <div class="panel panel-primary">
        <div class="panel-heading">
            <h2 id="msg">${msg}</h2></div>

        <div class="panel-body">
            <h2>Your Current Image:<img width="200" height="200" src="/showImage?usr=${facilitator.getUsername()}"
                                        alt="Image"/></h2>

            <h1>If you want to change upload a new one</h1>

            <form class="form-horizontal" action="uploadServlet" method="POST" enctype="multipart/form-data">

                <div class="form-group">
                    <label class="control-label col-sm-2">Image:</label>
                    <div class="col-sm-6">
                        <input type="file" id="uploadBox" class="form-control" name="file" value="" width="100"/>
                    </div>
                </div>

                <div class="form-group">
                    <div class="col-sm-offset-2 col-sm-10">
                        <input type="submit" id="upload" class="btn btn-success" value="Upload Now"/>
                    </div>
                </div>

            </form>

            <form class="form-horizontal" action="/login" method="POST" enctype="multipart/form-data">
                <div class="form-group">
                    <input type="file" class="form-control" name="file"  width="100" id="file"/>
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

