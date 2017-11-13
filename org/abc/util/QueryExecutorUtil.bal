package org.abc.util;

import ballerina.data.sql;
import ballerina.log;
import org.abc.beans as beans;
import org.abc.error as bError;
import ballerina.math;

public function getBalanceByAccountNumber (int accountNumber) (float balance, error err, bError:BackendError bErr)
{endpoint
 <sql:ClientConnector> ep {
     create sql:ClientConnector(sql:MYSQL, "192.168.48.209", 3306, "Bank", "root", "root", {maximumPoolSize:1});}
 sql:Parameter[] parameters = [];
 TypeCastError ex;
 boolean b = true;
 beans:AccountBalance bal;
 string query = "SELECT current_balance from Account WHERE acc_number=?";

 try {
     sql:Parameter para1 = {sqlType:"integer", value:accountNumber, direction:0};
     parameters = [para1];
     datatable dt = ep.select(query, parameters);
     while (dt.hasNext()) {
         b = false;
         any dataStruct = dt.getNext();
         println(dataStruct);

         bal, ex = (beans:AccountBalance)dataStruct;
         if (ex == null) {
             balance = bal.current_balance;
             println(balance);
         }
         else {
             log:printErrorCause("AccountBalance:error in struct casting", (error)ex);
             break;
         }
     }

     if (b) {
         bErr = {status_code:402, error_message:"Invalid account number"};

     }
 } catch (error e) {
     err = e;
 }
 return;
}


public function getBalanceByUser (int userid) (json balance, error err, bError:BackendError bErr)
{endpoint
 <sql:ClientConnector> ep {
     create sql:ClientConnector(sql:MYSQL, "192.168.48.209", 3306, "Bank", "root", "root", {maximumPoolSize:5});}
 sql:Parameter[] parameters = [];
 TypeCastError ex;
 TypeConversionError er;
 string query = "SELECT acc_number, current_balance from Account WHERE user_id=?";

 try {
     sql:Parameter para1 = {sqlType:"integer", value:userid, direction:0};
     parameters = [para1];
     datatable dt = ep.select(query, parameters);
     balance, er = <json>dt;
     println(balance);

 }
 catch (error e) {
     err = e;
 }
 return;
}



public function cleanupOTP () (error err)
{endpoint
 <sql:ClientConnector> ep {
     create sql:ClientConnector(sql:MYSQL, "192.168.48.209", 3306, "Bank", "root", "root", {maximumPoolSize:5});}
 sql:Parameter[] parameters = [];

 Time time = currentTime();
 Time tmSub = time.subtractDuration(0, 0, 1, 0, 0, 0, 0);
 println("After subtract duration: " + tmSub.toString());


 string query = "delete from OTP_Info where created_date < ?";

 try {
     sql:Parameter para1 = {sqlType:"timestamp", value:tmSub, direction:0};
     parameters = [para1];
     int dt = ep.update(query, parameters);
     println(dt);
     ep.close();

 }
 catch (error e) {
     e = {msg:"Cleanup error"};
     err = e;
 }

 return;
}
