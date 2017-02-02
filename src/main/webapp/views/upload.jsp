
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Upload Image</title>
</head>
<body>
<h2 id="msg">${msg}</h2>
<form action="uploadServlet" method="POST" enctype="multipart/form-data">
    <input type="file" name="file" value="" width="100"/>
    <input type="submit" value="Upload Now" name="submit"/>
</form>
</body>
</html>

