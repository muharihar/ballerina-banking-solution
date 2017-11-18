package org.abc.db;

import ballerina.util;
import org.abc.beans ;
import ballerina.log;
import ballerina.data.sql;

const int TOKEN_VALIDITY_IN_HOURS = 48;

function isValidTokenExistForUserId (int userID) (boolean exist) {
    endpoint
    <sql:ClientConnector> ep{
        initDb();}
    sql:Parameter[] parameters = [];
    string query_tokenInfo = "SELECT TIMESTAMPDIFF(HOUR,(SELECT created_date FROM OTP_Info WHERE user_id=?), now()) < ?;";
    TypeCastError ex;
    beans:TokenValidity tv;
    exist = false;

    // try {
    //     //Checking token existence against user id in database
    //     sql:Parameter para1 = {sqlType:"integer", value:userID, direction:0};
    //     parameters = [para1];
    //     datatable dt = ep.select(query_tokenInfo, parameters);

    //     while (dt.hasNext()) {
    //         exist = true;
    //         any dataStruct = dt.getNext();
    //         tv, ex = (beans:TokenValidity)dataStruct;
    //         if (ex != null) {
    //             log:printErrorCause("TokenGen:error in struct casting", (error)ex);
    //         }
    //         else {
    //             //println(tv.created_date);
    //             otpCreatedTime = tv.created_date;
    //         }
    //     }
    // } catch (error e) {
    //     err = e;
    // }
    return;
}

function isTokenValid (string token) (int userID) {
    endpoint
    <sql:ClientConnector> ep{
        initDb();}
    sql:Parameter[] parameters = [];
    // This Qury checks whether the token is valid, if the token is valid it will return the user_id or will return a 0
    string query_tokenInfo = "select if(TIMESTAMPDIFF(HOUR,(SELECT created_date FROM OTP_Info WHERE otp_id=?), now()) < ?, (select user_id from OTP_Info where otp_id = ?), 0) AS user_id;";
    try {
        sql:Parameter para1 = {sqlType:"varchar", value:token, direction:0};
        sql:Parameter para2 = {sqlType:"integer", value:TOKEN_VALIDITY_IN_HOURS, direction:0};
        sql:Parameter para3 = {sqlType:"varchar", value:token, direction:0};

        parameters = [para1,para2,para3];
        datatable dt = ep.select(query_tokenInfo, parameters);

        UserID rs;
        while (dt.hasNext()) {
            //exist = true;
            any dataStruct = dt.getNext();
            println(dataStruct);
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