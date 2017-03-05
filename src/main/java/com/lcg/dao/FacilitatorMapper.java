package com.lcg.dao;

import com.lcg.models.Facilitator;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class FacilitatorMapper implements RowMapper<Facilitator> {
    public Facilitator mapRow(ResultSet rs,int rowNum) throws SQLException {
        Facilitator facilitator=new Facilitator();
        facilitator.setUsername(rs.getString("username"));
        facilitator.setPassword(rs.getString("password"));
        facilitator.setFacilitatorId(rs.getString("facilitatorId"));
        facilitator.setName(rs.getString("facilitatorName"));
        facilitator.setAddress(rs.getString("facilitatorAddress"));
        facilitator.setType(rs.getString("facilitatorType"));
        facilitator.setLongitude(rs.getString("longitude"));
        facilitator.setLatitude(rs.getString("latitude"));
        facilitator.setImage(rs.getBlob("image"));
        facilitator.setEmail(rs.getString("email"));
        facilitator.setNoOfWorklines(rs.getInt("noOfWorklines"));
        return facilitator;
    }
}
