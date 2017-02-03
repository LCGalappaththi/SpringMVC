<%@ page import="java.io.OutputStream" %>
<%@ page import="java.sql.Blob" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <style>
        #img {
            height: 200px;
            width: 200px;
        }
    </style>
</head>
<body>

<h1>ybgyuyftvtffy</h1>
<div id="img" >
    <%
        Blob image;
        byte[] imgData;
        try {
            image = (Blob) request.getAttribute("image");
            imgData = image.getBytes(1, (int) image.length());
// display the image
            response.setContentType("image/gif");
            OutputStream o = response.getOutputStream();
            o.write(imgData);
            o.write(22);
            o.flush();
            o.close();
        } catch (Exception e) {
            out.println("Unable To Display image");
            out.println("Image Display Error=" + e.getMessage());
            return;
        }
    %>
</div>
</body>
</html>


