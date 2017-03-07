package com.lcg.controllers;

import com.lcg.jdbcTemplates.FacilitatorJDBCTemplate;
import com.lcg.models.Card;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping(value = "money", method = RequestMethod.POST)
public class MoneyController {
    @Autowired
    private FacilitatorJDBCTemplate context;
    @Autowired
    private Card card;
}
