package services;

import ballerina.net.http;
import ballerina.log;
import org.abc.util as utils;

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