package services;

import ballerina.net.http;
import ballerina.log;
import org.abc.util as utils;
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
        var otp, err = utils:getOTPForUSer(accountno);
        if (err == null) {
            valueToReturn = <string>otp;
            res.setStringPayload(valueToReturn);
        }
        else {
            log:printErrorCause("getOTPResource:error in getting token", err);
            valueToReturn = err.msg;
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
        methods:["POST"]
    }
    resource getAccountBalance (http:Request req, http:Response res, string accountno) {
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
        methods:["POST"]
    }
    resource getAccountBalanceByUser (http:Request req, http:Response res) {
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
}