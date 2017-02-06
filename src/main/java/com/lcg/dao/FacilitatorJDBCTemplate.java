package com.lcg.dao;

import com.lcg.models.Facilitator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import javax.sql.DataSource;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@Service
public class FacilitatorJDBCTemplate implements FacilitatorDAO {
    private DataSource dataSource;
    private JdbcTemplate jdbcTemplateObject;

    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
        this.jdbcTemplateObject = new JdbcTemplate(dataSource);
    }

    public boolean addFacilitator(Facilitator facilitator) {
        try {
            String SQL = "insert into facilitator (username,password,facilitatorId,facilitatorName,email,facilitatorAddress,facilitatorType,longitude,latitude) values (?,?,?,?,?,?,?,?,?)";
            jdbcTemplateObject.update(SQL, facilitator.getUsername(), facilitator.getPassword(), facilitator.getFacilitatorId(), facilitator.getName(), facilitator.getEmail(), facilitator.getAddress(), facilitator.getType(), facilitator.getLongitude(), facilitator.getLatitude());
            SQL = "insert into facilitatorcontactno (facilitatorId,contactNo) values (?,?)";
            if (!facilitator.getContact1().isEmpty())
                jdbcTemplateObject.update(SQL, facilitator.getFacilitatorId(), facilitator.getContact1());
            if (!facilitator.getContact2().isEmpty())
                jdbcTemplateObject.update(SQL, facilitator.getFacilitatorId(), facilitator.getContact2());
            if (!facilitator.getContact3().isEmpty())
                jdbcTemplateObject.update(SQL, facilitator.getFacilitatorId(), facilitator.getContact3());
            return true;
        } catch (Exception e) {

            return false;
        }
    }

    public Facilitator getFacilitatorLogin(String username) {
        String SQL = "select * from facilitator where username=?";
        try {
            Facilitator facilitator = jdbcTemplateObject.queryForObject(SQL, new Object[]{username}, new FacilitatorMapper());
            return facilitator;
        } catch (Exception e) {
            return new Facilitator();
        }

    }

    public Facilitator getFacilitatorDetails(String facilitatorId) {
        String SQL = "select * from facilitator where facilitatorId=?";
        Facilitator facilitator = jdbcTemplateObject.queryForObject(SQL, new Object[]{facilitatorId}, new FacilitatorMapper());
        SQL = "select contactNo from facilitatorcontactno where facilitatorId=?";
        List<Map<String, Object>> contacts = jdbcTemplateObject.queryForList(SQL, new Object[]{facilitatorId});
        if (!contacts.isEmpty()) {
            if (contacts.size() == 1)
                facilitator.setContact1(contacts.get(0).get("contactNo").toString());
            if (contacts.size() == 2) {
                facilitator.setContact1(contacts.get(0).get("contactNo").toString());
                facilitator.setContact2(contacts.get(1).get("contactNo").toString());
            }
            if (contacts.size() == 3) {
                facilitator.setContact1(contacts.get(0).get("contactNo").toString());
                facilitator.setContact2(contacts.get(1).get("contactNo").toString());
                facilitator.setContact3(contacts.get(2).get("contactNo").toString());
            }
        }
        return facilitator;


    }

    public boolean deleteFacilitator(String facilitatorId) {
        try {
            String SQL = "delete from facilitatorcontactno where facilitatorId=?";
            jdbcTemplateObject.update(SQL, facilitatorId);
            SQL = "delete from facilitator where facilitatorId=?";
            jdbcTemplateObject.update(SQL, facilitatorId);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    public boolean updateFacilitator(Facilitator facilitator) {
        try {
            String SQL = "update facilitator set username=?,password=?,facilitatorName=?,email=?,facilitatorAddress=?,facilitatorType=?,longitude=?,latitude=? where facilitatorId = ?";
            jdbcTemplateObject.update(SQL, facilitator.getUsername(), facilitator.getPassword(), facilitator.getName(), facilitator.getEmail(), facilitator.getAddress(), facilitator.getType(), facilitator.getLongitude(), facilitator.getLatitude(), facilitator.getFacilitatorId());
            SQL = "delete from facilitatorcontactno where facilitatorId=?";
            jdbcTemplateObject.update(SQL, facilitator.getFacilitatorId());
            SQL = "insert into facilitatorcontactno  (contactNo,facilitatorId) values(?,?)";
            if (!facilitator.getContact1().isEmpty())
                jdbcTemplateObject.update(SQL, facilitator.getContact1(), facilitator.getFacilitatorId());
            if (!facilitator.getContact2().isEmpty())
                jdbcTemplateObject.update(SQL, facilitator.getContact2(), facilitator.getFacilitatorId());
            if (!facilitator.getContact3().isEmpty())
                jdbcTemplateObject.update(SQL, facilitator.getContact3(), facilitator.getFacilitatorId());
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    public List<Facilitator> listFacilitators() {
        String SQL = "select * from facilitator";
        List<Facilitator> facilitators = jdbcTemplateObject.query(SQL, new FacilitatorMapper());
        return facilitators;
    }

    public String getLastId() throws SQLException, ClassNotFoundException {
        String SQL = "select facilitatorId from facilitator order by facilitatorId desc limit 1";
        List<String> strings = (List<String>) jdbcTemplateObject.queryForList(SQL, String.class);
        if (!strings.isEmpty())
            return strings.get(0).toString();
        else
            return "F000000000";
    }

}