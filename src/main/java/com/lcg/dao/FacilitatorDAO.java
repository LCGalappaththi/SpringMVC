package com.lcg.dao;

import com.lcg.models.Facilitator;

import javax.sql.DataSource;
import java.sql.SQLException;
import java.util.List;

public interface FacilitatorDAO {
    public void setDataSource(DataSource ds);

    public boolean addFacilitator(Facilitator facilitator);

    public Facilitator getFacilitatorLogin(String username);

    public Facilitator getFacilitatorDetails(String facilitatorId);

    public boolean deleteFacilitator(String username);

    public boolean updateFacilitator(Facilitator facilitator);

    public List<Facilitator> listFacilitators();

    public String getLastId() throws SQLException, ClassNotFoundException;

}