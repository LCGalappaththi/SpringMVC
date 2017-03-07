package com.lcg.Mappers;

import com.lcg.models.Card;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class CardMapper implements RowMapper<Card> {
    public Card mapRow(ResultSet rs, int rowNum) throws SQLException {
        Card card = new Card();
        card.setCardNumber(rs.getString("cardNo"));
        card.setCvv(rs.getString("cvv"));
        card.setExpireYear(rs.getInt("expireYear"));
        card.setExpireMonth(rs.getInt("expireMonth"));
        card.setOwnerEmail(rs.getString("ownerEmail"));
        card.setOwnerName(rs.getString("ownerName"));
        card.setType(rs.getString("cardType"));
        return card;
    }
}
