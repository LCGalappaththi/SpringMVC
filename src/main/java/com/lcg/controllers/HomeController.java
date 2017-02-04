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

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Blob;
import java.sql.SQLException;
import java.util.List;

@Controller
public class HomeController {
    @Autowired
    private FacilitatorJDBCTemplate context;
    @Autowired
    private Facilitator facilitator;

    @RequestMapping(value = "home", method = RequestMethod.GET)
    public String home() {
        return "home";
    }

    @RequestMapping(value = "showImage", method = RequestMethod.GET)
    public String image(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws SQLException, IOException {
        Blob image = context.getFacilitatorLogin(request.getParameter("usr")).getImage();
        model.addAttribute("image", image);
        return "showImage";
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
        return "test";
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

        if (context.updateFacilitator(facilitator)) {
            model.put("msg", "Details Updated Succesfully!!!");
            return "login";
        } else {
            model.put("msg", "Update failed!!!");
            showUpdate(request, model);
            return "update";
        }

    }

    @RequestMapping(value = "add", method = RequestMethod.GET)
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

        if (context.addFacilitator(facilitator)) {
            request.getSession().setAttribute("facilitatorId", id);
            model.put("msg", "Details added successfully Upload a Photo here!!!");
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
