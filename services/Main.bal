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
        path:"/test/"
    }
    resource getTestResource (http:Request req, http:Response res) {
        endpoint<conn:IDPConnector> idpEp {
        }
        conn:IDPConnector idpCon = create conn:IDPConnector();
        bind idpCon with idpEp;
        var re, _ = idpEp.authenticateUser("admin", "admin");
        println(re);

    }

     @http:resourceConfig {
        methods:["POST"],
        path:"/getinfo/customer"
    }
    resource getAllCustomerInfoResource (http:Request req, http:Response res) {
        string valueToReturn;
        var result, err = utils:getCustomerInfo();
        if (err == null) {
            println(result);
            res.setJsonPayload(result);
        }
        else {
            log:printErrorCause("getOTPResource:error in getting token", err);
            valueToReturn = err.msg;
            res.setStringPayload(valueToReturn);
        }
        res.send();
    }
}