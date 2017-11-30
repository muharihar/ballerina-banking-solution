package org.abc.db;

import ballerina.data.sql;

const int TOKEN_VALIDITY_IN_HOURS = 48;

function isValidTokenExistForUserId (int userID) (boolean exist) {
    endpoint
    <sql:ClientConnector> ep {}
    bind sqlCon with ep;
    return;
}

public function isTokenValid (string token) (int userID) {
    endpoint
    <sql:ClientConnector> ep {}
    bind sqlCon with ep;
    sql:Parameter[] parameters = [];
    // This Qury checks whether the token is valid, if the token is valid it will return the user_id or will return a 0
    string query_tokenInfo = "select if(TIMESTAMPDIFF(HOUR,(SELECT created_date FROM OTP_Info WHERE otp_id=?), now()) < ?, (select user_id from OTP_Info where otp_id = ?), 0) AS user_id;";
    try {
        sql:Parameter para1 = {sqlType:sql:Type.VARCHAR, value:token, direction:sql:Direction.IN};
        sql:Parameter para2 = {sqlType:sql:Type.INTEGER, value:TOKEN_VALIDITY_IN_HOURS, direction:sql:Direction.IN};
        sql:Parameter para3 = {sqlType:sql:Type.VARCHAR, value:token, direction:sql:Direction.IN};

        parameters = [para1, para2, para3];
        datatable dt = ep.select(query_tokenInfo, parameters);

        UserID rs;
        while (dt.hasNext()) {
            //exist = true;
            any dataStruct = dt.getNext();
            TypeCastError e;
            rs, _ = (UserID)dataStruct;
            userID = rs.user_id;
        }
    } catch (error e) {
        println(e);
    }
    return;
}

struct UserID {
    int user_id;
}