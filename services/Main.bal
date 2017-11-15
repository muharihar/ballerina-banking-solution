package services;

import ballerina.net.http;
import ballerina.log;
import org.abc.util as utils;
import org.abc.connectors as conn;

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
                println(result);
                res.setJsonPayload(result);
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