package com.lcg.controllers;

import com.lcg.dao.FacilitatorJDBCTemplate;
import com.lcg.dao.IdGenerator;
import com.lcg.models.Facilitator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Blob;
import java.sql.SQLException;
import java.util.List;
import java.util.Properties;

@Controller
public class HomeController {
    @Autowired
    private FacilitatorJDBCTemplate context;
    @Autowired
    private Facilitator facilitator;

    @RequestMapping(value = {"/home", "/"}, method = RequestMethod.GET)
    public String home() {
        return "home";
    }

    @RequestMapping(value = "showImage", method = RequestMethod.GET)
    public void image(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        Blob image = context.getFacilitatorLogin(request.getParameter("usr")).getImage();
        byte[] imgData;
        try {
            imgData = image.getBytes(1, (int) image.length());
            OutputStream o = response.getOutputStream();
            response.setContentType("image/gif");
            o.write(imgData);
            o.flush();
            o.close();
        } catch (Exception e) {
            System.out.println("Unable To Display image");
            System.out.println("Image Display Error=" + e.getMessage());
        }
    }

    @RequestMapping(value = "login", method = RequestMethod.GET)
    public String showLogin() {
        return "login";
    }

    @RequestMapping(value = "signIn", method = RequestMethod.GET)
    public String showSignIn() {
        return "signIn";
    }

    @RequestMapping(value = "logged", method = RequestMethod.GET)
    public String logged(HttpServletRequest request, ModelMap model) {
        String user = request.getParameter("user");
        String pass = request.getParameter("pass");
        if (pass.equals(context.getFacilitatorLogin(user).getPassword())) {
            model.put("status", "Successfully logged");
            request.getSession().setAttribute("loggedUserName", context.getFacilitatorLogin(user).getName());
            request.getSession().setAttribute("loggedUserId", context.getFacilitatorLogin(user).getFacilitatorId());
            request.getSession().setAttribute("loggedUserId", context.getFacilitatorLogin(user).getFacilitatorId());
            return "manage";
        } else {
            model.put("status", "wrong credentials");
            return "login";
        }
    }

    @RequestMapping(value = "details", method = RequestMethod.GET)
    public String showDetails(HttpServletRequest request, ModelMap model) {
        String facilitatorId = request.getSession().getAttribute("loggedUserId").toString();
        Facilitator logged = context.getFacilitatorDetails(facilitatorId);
        model.addAttribute("details", logged);
        return "account";
    }

    @RequestMapping(value = "delete", method = RequestMethod.GET)
    public String deleteFacilitator(HttpServletRequest request, ModelMap model) {
        String facilitatorId = request.getSession().getAttribute("loggedUserId").toString();
        if (context.deleteFacilitator(facilitatorId)) {
            request.getSession().removeAttribute("loggedUserName");
            request.getSession().removeAttribute("loggedUserId");
            model.put("msg", "Account Deleted succesfully!!!");
            return "home";
        } else {
            model.put("msg", "Failed to delete account!!!");
            return "manage";
        }
    }

    @RequestMapping(value = "ajax/{q}", method = RequestMethod.GET)
    @ResponseBody
    public String ajaxTest(@PathVariable("q") String user) {
        if (user.equalsIgnoreCase(context.getFacilitatorLogin(user).getUsername()))
            return "<span style='color:red'><- Username Already Exists</span>";
        else
            return "<span style='color:blue'><- OK</span>\n";
    }

    @RequestMapping(value = "email", method = RequestMethod.GET)
    @ResponseBody
    public String email(HttpServletRequest request) throws Exception {
        String email = request.getParameter("email");
        String name = request.getParameter("name");
        String id = IdGenerator.idGenarator("F", context.getLastId());
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

            message.setSubject("Test Email");

            BodyPart messageBodyPart = new MimeBodyPart();

            try {
                message.setSubject("Confirm Email from Team Exception");
            } catch (MessagingException e) {
                e.printStackTrace();
            }

            //messageBodyPart.setText(" Hello "+name+" Your Email Confirmation Code is " + id + " enter this in the confirmation code box ");
            messageBodyPart.setContent("<h1>Hello " + name + "</h1><h2> Your Email Confirmation Code is " + id + "</h2><h2>enter this in the confirmation code box</h2><hr><h3>by Team Exception</h3>", "text/html");

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
                return "sent_failed";
            }

        } catch (Exception e) {
            e.printStackTrace();
            return "sent_failed";
        }
        return id;
    }


    @RequestMapping(value = "update", method = RequestMethod.GET)
    public String showUpdate(HttpServletRequest request, ModelMap model) {
        String facilitatorId = request.getSession().getAttribute("loggedUserId").toString();
        Facilitator logged = context.getFacilitatorDetails(facilitatorId);
        model.addAttribute("details", logged);
        return "update";
    }

    @RequestMapping(value = "updatenow", method = RequestMethod.GET)
    public String UpdateFacilitator(HttpServletRequest request, ModelMap model) throws SQLException, ClassNotFoundException {
        facilitator.setUsername(request.getParameter("username"));
        if (request.getParameter("newPassword").trim().equals(""))
            facilitator.setPassword(request.getParameter("curPass"));
        else
            facilitator.setPassword(request.getParameter("newPassword"));
        facilitator.setFacilitatorId(request.getSession().getAttribute("loggedUserId").toString());
        facilitator.setName(request.getParameter("name"));
        facilitator.setAddress(request.getParameter("address"));
        facilitator.setContact1(request.getParameter("contact1"));
        facilitator.setContact2(request.getParameter("contact2"));
        facilitator.setContact3(request.getParameter("contact3"));
        facilitator.setType(request.getParameter("type"));
        facilitator.setLongitude(request.getParameter("longitude"));
        facilitator.setLatitude(request.getParameter("latitude"));
        if (request.getParameter("emailVerified").equals("true"))
            facilitator.setEmail(request.getParameter("email"));
        else
            facilitator.setEmail("not Verified");

        if (context.updateFacilitator(facilitator)) {
            model.put("msg", "Details Updated Succesfully!!!");
            return "login";
        } else {
            model.put("msg", "Update failed!!!");
            showUpdate(request, model);
            return "update";
        }

    }

    @RequestMapping(value = "add", method = RequestMethod.POST)
    public String addFacilitator(ModelMap model, HttpServletRequest request) throws SQLException, ClassNotFoundException, IOException, ServletException {
        facilitator.setUsername(request.getParameter("username"));
        facilitator.setPassword(request.getParameter("password"));
        String id = IdGenerator.idGenarator("F", context.getLastId());
        facilitator.setFacilitatorId(id);
        facilitator.setName(request.getParameter("name"));
        facilitator.setAddress(request.getParameter("address"));
        facilitator.setContact1(request.getParameter("contact1"));
        facilitator.setContact2(request.getParameter("contact2"));
        facilitator.setContact3(request.getParameter("contact3"));
        facilitator.setType(request.getParameter("type"));
        facilitator.setLongitude(request.getParameter("longitude"));
        facilitator.setLatitude(request.getParameter("latitude"));
        if (request.getParameter("emailVerified").equals("true")) {
            facilitator.setEmail(request.getParameter("email"));
        } else {
            facilitator.setEmail("not Verified");
        }

        if (context.addFacilitator(facilitator)) {
            request.getSession().setAttribute("facilitatorId", id);
            model.put("msg", "Details added successfully Upload a Photo here!!!");
            request.setAttribute("facilitator", facilitator);
            return "upload";
        } else {
            model.put("msg", "signIn failed!!!");
            return "signIn";
        }
    }

    @RequestMapping(value = "logout", method = RequestMethod.GET)
    public String logout(HttpServletRequest request, ModelMap model) {
        request.getSession().removeAttribute("loggedUserName");
        request.getSession().removeAttribute("loggedUserId");
        return "login";
    }

    @RequestMapping(value = "maps", method = RequestMethod.GET)
    public String map(HttpServletRequest request, ModelMap model) {
        Facilitator logged = context.getFacilitatorDetails(request.getSession().getAttribute("loggedUserId").toString());
        model.put("latitude", logged.getLatitude());
        model.put("longitude", logged.getLongitude());
        return "maps";
    }

    @RequestMapping(value = "pickLocation", method = RequestMethod.GET)
    public String pick(HttpServletRequest request, ModelMap model) {
        List<Facilitator> facList = context.listFacilitators();
        model.put("coordinates", facList);
        return "pickLocation";
    }

    @RequestMapping(value = "addService", method = RequestMethod.GET)
    public String newService() {
        return "addNewService";
    }


    @RequestMapping(value = "selectedFacilitator/{selected}", method = RequestMethod.GET)
    public String FacilitatorSelect(@PathVariable("selected") String facilitator, ModelMap model) {
        model.put("selectedFacilitator", facilitator);
        return "facilitatorServices";
    }

    @RequestMapping(value = "addServicesData/{q}", method = RequestMethod.GET)
    public String addServices(@PathVariable("q") String data) {
        String arr[] = data.split(",");
        String serviceName = arr[0];// first two elements servicename and description then sets of 3 elements
        String description = arr[1];
        for (int i = 2; i < arr.length; i++) {
            if ((i - 2) % 3 == 0)
                System.out.println();
            System.out.print(arr[i] + " ");//printing sets
        }
        return "manage";
    }
}
