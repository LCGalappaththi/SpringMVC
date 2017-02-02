package com.lcg.controllers;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;


@WebServlet("/uploadServlet")
@MultipartConfig(maxFileSize = 16177215)    // upload file's size up to 16MB
public class UploadServlet extends HttpServlet {

    // database connection settings
    private String dbURL = "jdbc:mysql://localhost:3306/teamexception";
    private String dbUser = "root";
    private String dbPass = "";

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {
        // gets values of text fields

        String facilitatorId = request.getSession().getAttribute("facilitatorId").toString();
        InputStream inputStream = null; // input stream of the upload file

        // obtains the upload file part in this multipart request
        Part filePart = request.getPart("file");
        if (filePart != null) {
            // prints out some information for debugging
            System.out.println(filePart.getName());
            System.out.println(filePart.getSize());
            System.out.println(filePart.getContentType());

            // obtains input stream of the upload file
            inputStream = filePart.getInputStream();
        }

        Connection conn = null; // connection to the database

        try {
            // connects to the database
            DriverManager.registerDriver(new com.mysql.jdbc.Driver());
            conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

            // constructs SQL statement
            String sql = "UPDATE facilitator SET image=? where facilitatorId=?";
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setString(2, facilitatorId);


            if (inputStream != null) {
                // fetches input stream of the upload file for the blob column
                statement.setBlob(1, inputStream);
            }

            // sends the statement to the database server
            int row = statement.executeUpdate();
            if (row > 0) {
                System.out.println("ok");
                request.getServletContext().getRequestDispatcher("/views/login.jsp").forward(request, response);
            }
        } catch (SQLException ex) {
            System.out.println("error");
            ex.printStackTrace();
            request.setAttribute("msg", "upload failed");
            request.getServletContext().getRequestDispatcher("/views/upload.jsp").forward(request, response);
        } finally {
            if (conn != null) {
                // closes the database connection
                try {
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }

    }

}
