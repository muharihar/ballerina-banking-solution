package services;

import ballerina.net.http;
import ballerina.log;
import org.abc.util as utils;
import org.abc.connectors as conn;
import org.abc.serviceImpl as sImpl;
import ballerina.math;
import ballerina.util;


@http:configuration {
    basePath:"/bank"
}
service<http> ABCOnlineBankingService {

    @http:resourceConfig {
        methods:["GET"],
        path:"/getotp/{accountno}"
    }
    resource getOTPResource (http:Request req, http:Response res, string accountno) {
        string valueToReturn;
        var otp, userid, err = utils:getOTPForUSer(accountno);
        json payload = {"otp":otp, "userid":userid};
        if (err == null) {
            res.setJsonPayload(payload);
        }
        else {
            log:printErrorCause("getOTPResource:error in getting token", err);
            valueToReturn = err.msg;
            res.setStringPayload(valueToReturn);
        }
        res.send();
    }



    @http:resourceConfig {
        methods:["POST"],
        path:"/user/authe"
    }
    resource authenticateUserResource (http:Request req, http:Response res) {
        endpoint<conn:IDPConnector> idpEp {
        }
        conn:IDPConnector idpCon = create conn:IDPConnector();
        bind idpCon with idpEp;
        var re, _ = idpEp.authenticate("admin", "admin");
        println(re);

    }

    @http:resourceConfig {
        methods:["GET"],
        path:"/getinfo/customer/{userid}"
    }
    resource getAllCustomerInfoResource (http:Request req, http:Response res, string userid) {
        var uid, e = <int>userid;
        string valueToReturn;
        if (e == null) {
            var result, err = utils:getCustomerInfo(uid);
            if (err == null) {
                json j = result[0];
                println(result);
                res.setJsonPayload(j);
            }
            else {
                log:printErrorCause("getAllCustomerInfoResource:error in getting token", err);
                valueToReturn = err.msg;
                res.setStringPayload(valueToReturn);
            }
        }
        else {
            log:printErrorCause("getAllCustomerInfoResource:error in the userid", (error)e);
            valueToReturn = e.msg;
            res.setStringPayload(valueToReturn);
        }
        res.send();
    }

}

@http:configuration {
    basePath:"/account"
}
service<http> ABCOnlineBankingAccountService {


    @http:resourceConfig {
        path:"/getAccountBalance/{accountno}",
        methods:["GET"]
    }
    resource getAccountBalance (http:Request req, http:Response res, string accountno) {
        //http://localhost:9090/account/getAccountBalance/114565456
        json valueToReturn;
        int account;
        account, _ = <int>accountno;
        var balance, err, bErr = utils:getBalanceByAccountNumber(account);
        if (err == null && bErr == null) {
            float val = (float)balance;
            float a = (float)math:round(val * 100) / 100;

            valueToReturn = {"accountBalance":a};
            res.setJsonPayload(valueToReturn);

        } else if (bErr != null) {
            valueToReturn = {"error":bErr.error_message};
            res.setJsonPayload(valueToReturn);
        }
        else {
            log:printErrorCause("getAccountBalanceResource:error in getting account balance", err);
            valueToReturn = {"error":err.msg};
            res.setJsonPayload(valueToReturn);
        }
        res.send();
    }



    @http:resourceConfig {
        path:"/getAccountBalanceByUser",
        methods:["GET"]
    }
    resource getAccountBalanceByUser (http:Request req, http:Response res) {
        //http://localhost:9090/account/getAccountBalanceByUser

        json valueToReturn;
        int account;

        //TODO - get the user_id
        int user_id = 1067544678;

        var balance, err, bErr = utils:getBalanceByUser(user_id);
        if (err == null && bErr == null) {
            valueToReturn = (json)balance;
            res.setJsonPayload(valueToReturn);

        } else if (bErr != null) {
            valueToReturn = bErr.error_message;
            res.setJsonPayload(valueToReturn);
        }
        else {
            log:printErrorCause("getAccountBalanceByUserResource:error in getting account balance", err);
            valueToReturn = {"error":err.msg};
            res.setJsonPayload(valueToReturn);
        }

        //utils:scheduledTaskTimer();0/40 * * * * ?
        string msg = utils:scheduledTaskAppointment("0/40 * * * * ?");
        println(msg);

        res.send();
    }



    @http:resourceConfig {
        path:"/newaccount",
        methods:["POST"]
    }
    resource createNewAccount (http:Request req, http:Response res) {
        string valueToReturn;
        int account;

        //TODO - get the user_id
        int user_id = 1067544678;
        map params = req.getQueryParams();
        var accType, _ = (string)params.accountType;
        var accountType, _ = <int>accType;

        var curr, _ = (string)params.currency;
        var currency, _ = <int>curr;



        //TODO - check if the user is valid (isExist)

        var msg, err = utils:createNewAccount(user_id, accountType, currency);
        if (err == null) {
            valueToReturn = msg;
            res.setStringPayload(valueToReturn);

        }
        else {
            log:printErrorCause("newAccount:error creating a new account", err);
            valueToReturn = "New account creation failed. Please try again later";
            res.setStringPayload(valueToReturn);
        }

        res.send();
    }



    @http:resourceConfig {
        path:"/getpendingapprovalaccounts",
        methods:["GET"]
    }
    resource getPendingApprovalAccounts (http:Request req, http:Response res) {
        //http://localhost:9090/account/getpendingapprovalaccounts
        json valueToReturn;
        int account;

        var msg, err = utils:getPendingApprovalAccountList();

        if (err == null) {
            valueToReturn = msg;
            res.setJsonPayload(valueToReturn);
        }
        else {
            log:printErrorCause("GetPendingApprovalAccounts:error retrieving pending approval accounts", err);
            valueToReturn = {"error":err.msg};
            res.setJsonPayload(valueToReturn);
        }

        float val;
        float val2;
        error err2;
        error err1;
        val, err2 = utils:getExchangeRate("USD","LKR");
        val2, err1 = utils:getExchangeRateValue("USD","LKR", 5);
        println(val);
        println(err2);

        println(val2);
        println(err1);

        int[] acc = [114565456];
        utils:writeToCSV(acc);
        println("ss");

        res.send();
    }


    @http:resourceConfig {
        path:"/getaccounthistory",
        methods:["POST"]
    }
    resource getAccountHistoryResource (http:Request req, http:Response res) {
        http:Response re = {};
        re = sImpl:getAccountHistory(req);
        res.forward(re);

    }



}
