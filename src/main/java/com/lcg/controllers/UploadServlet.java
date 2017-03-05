package com.lcg.controllers;

import com.lcg.models.Facilitator;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Properties;


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
        Facilitator facilitator = (Facilitator) request.getSession().getAttribute("facilitator");
        String facilitatorId = facilitator.getFacilitatorId();
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
        if (filePart.getSize() != 0) {
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
                    try {
                        signedInEmail(facilitator);
                    } catch (Exception e) {
                        System.out.println(e);
                    }
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
        } else {
            try {
                // connects to the database
                DriverManager.registerDriver(new com.mysql.jdbc.Driver());
                conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
                File image;
                if (facilitator.getType().equalsIgnoreCase("garage"))
                    image = new File("C:/SpringMVC/garage.jpg");
                else
                    image = new File("C:/SpringMVC/service.jpg");
                FileInputStream fis = new FileInputStream(image);

                String sql = "UPDATE facilitator SET image=? where facilitatorId=?";
                PreparedStatement statement = conn.prepareStatement(sql);

                statement.setString(2, facilitatorId);
                statement.setBlob(1, fis);
                statement.executeUpdate();
                try {
                    signedInEmail(facilitator);
                } catch (Exception e) {
                    System.out.println(e);
                }
                request.getServletContext().getRequestDispatcher("/views/login.jsp").forward(request, response);
            } catch (Exception e) {

            }
        }
    }

    public void signedInEmail(Facilitator f) throws Exception {
        String email = f.getEmail();
        String name = f.getName();
        try {
            String host = "smtp.gmail.com";
            String Password = "morafit14";
            String from = "morateamexception@gmail.com";
            String toAddress = email.trim();  //Receiver’s email id
            Properties props = System.getProperties();
            props.put("mail.smtp.host", host);
            props.put("mail.smtps.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");

            Session session1 = Session.getInstance(props, null);

            MimeMessage message = new MimeMessage(session1);

            message.setFrom(new InternetAddress(from));

            message.setRecipients(Message.RecipientType.TO, toAddress);

            BodyPart messageBodyPart = new MimeBodyPart();

            try {
                message.setSubject("Account Created Successfully!!!");
            } catch (MessagingException e) {
                e.printStackTrace();
            }

            messageBodyPart.setContent("<h1>Hello " + name + "</h1><h2> Your Account Is Created(Updated) Successfully </h2><h2> Now You can enter Your Garage services and details</h2><hr><h3>by Team Exception</h3>", "text/html");

            Multipart multipart = new MimeMultipart();

            multipart.addBodyPart(messageBodyPart);

            messageBodyPart = new MimeBodyPart();

            message.setContent(multipart);

            try {
                Transport tr = session1.getTransport("smtps");
                tr.connect(host, from, Password);
                tr.sendMessage(message, message.getAllRecipients());
                tr.close();
            } catch (Exception sfe) {

            }

        } catch (Exception e) {
            e.printStackTrace();

        }

    }

}




