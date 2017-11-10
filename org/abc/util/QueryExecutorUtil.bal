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
    string query_account = "SELECT user_id FROM Account WHERE acc_number=?";

    try {
        //Obtaining user id from the database by passing the account no
        sql:Parameter para1 = {sqlType:"integer", value:accountNumber, direction:0};
        parameters = [para1];
        datatable dt = ep.select(query_account, parameters);
        while (dt.hasNext()) {
            any dataStruct = dt.getNext();
            tg, ex = (beans:TokenGen)dataStruct;
            if (ex == null) {
                userID = tg.user_id;
            }
            else {
                log:printErrorCause("TokenGen:error in struct casting", (error)ex);
                break;
            }
        }
    } catch (error e) {
        err = e;
    }
    return;
}

function checkTokenExistance (int userID) (boolean exist, string otpCreatedTime, error err) {
    endpoint<sql:ClientConnector> ep {
        init();
    }
    sql:Parameter[] parameters = [];
    string query_tokenInfo = "SELECT otp_id, created_date FROM OTP_Info WHERE user_id=?";
    TypeCastError ex;
    beans:TokenValidity tv;
    exist = false;

    try {
        //Checking token existence against user id in database
        sql:Parameter para1 = {sqlType:"integer", value:userID, direction:0};
        parameters = [para1];
        datatable dt = ep.select(query_tokenInfo, parameters);

        while (dt.hasNext()) {
            exist = true;
            any dataStruct = dt.getNext();
            tv, ex = (beans:TokenValidity)dataStruct;
            println("c");
            if (ex != null) {
                log:printErrorCause("TokenGen:error in struct casting", (error)ex);
                println("d");
            }
            else {
                println("e");
                println(tv.created_date);
                otpCreatedTime = tv.created_date;
            }
        }
    } catch (error e) {
        err = e;
    }
    return;
}

function insertGenToken (int userid, string token) {
    endpoint<sql:ClientConnector> ep {
        init();
    }
    error err;
    sql:Parameter[] parameters = [];
    string query_tokenInfo = "INSERT INTO OTP_Info (otp_id, created_date, user_id) VALUES (?, ?, ?)";
    Time currentTimestamp = currentTime();

    try {
        //Inserting generated token to database
        sql:Parameter para1 = {sqlType:"varchar", value:token, direction:0};
        sql:Parameter para2 = {sqlType:"timestamp", value:currentTimestamp, direction:0};
        sql:Parameter para3 = {sqlType:"integer", value:userid, direction:0};
        parameters = [para1, para2, para3];
        var count, ids = ep.updateWithGeneratedKeys(query_tokenInfo, parameters, null);
    } catch (error e) {
        err = e;
    }
}


