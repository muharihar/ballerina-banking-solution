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
}