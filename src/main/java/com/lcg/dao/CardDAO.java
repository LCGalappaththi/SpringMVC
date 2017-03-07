package com.lcg.dao;


import com.lcg.models.Card;

import javax.sql.DataSource;

public interface CardDAO {
    public void setDataSource(DataSource ds);

    public boolean validateCard(Card card);

    public boolean doPayment();
}
