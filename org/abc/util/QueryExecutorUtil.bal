package org.abc.util;

import ballerina.data.sql;
import ballerina.log;
import org.abc.beans as beans;

function getUserID (int accountNumber) (int userID, error err) {
    endpoint<sql:ClientConnector> ep {
        init();
    }

    sql:Parameter[] parameters = [];
    TypeCastError ex;
    beans:TokenGen tg;
    string query = "SELECT user_id from Account WHERE acc_number=?";

    try {
        sql:Parameter para1 = {sqlType:"integer", value:accountNumber, direction:0};
        parameters = [para1];
        datatable dt = ep.select(query, parameters);
        while (dt.hasNext()) {
            any dataStruct = dt.getNext();
            tg, ex = (beans:TokenGen)dataStruct;
            if (ex == null) {
                userID = tg.user_id;
            }
            else {
                log:printErrorCause("TokenGen:error in struct casting", ex);
                break;
            }
        }
    } catch (error e) {
        err = e;
    }
    return;

}