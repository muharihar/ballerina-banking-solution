package services;

import ballerina.net.http;
import org.abc.util as utils;
import ballerina.log;

@http:configuration {
    basePath:"/api/currency",
    allowOrigins:["http://localhost", "http://localhost:4200"],
    allowCredentials:true
}
service<http> ABCOnlineBankingCurrencyService {

    @http:resourceConfig {
        methods:["GET"],
        path:"/getExchangeRate/{base}/{to}"
    }
    resource getExchangeRate (http:Request req, http:Response res, string base, string to) {

        var rate, err = utils:getExchangeRate(base, to);
        json response;
        if (err == null) {
            response = {"exchangeRate":rate};
            res.setJsonPayload(response);
        }
        else {
            response = {"error":err.msg};
            res.setJsonPayload(response);
        }
        _ = res.send();
    }


    @http:resourceConfig {
        methods:["GET"],
        path:"/getExchangeRateValue/{base}/{to}/{value}"
    }
    resource getExchangeRateValue (http:Request req, http:Response res, string base, string to, string value) {

        var val, _ = <float>value;
        var rate, err = utils:getExchangeRateValue(base, to, val);
        json response;
        if (err == null) {
            response = {"exchangeRateValue":rate};
            res.setJsonPayload(response);
        }
        else {
            response = {"error":err.msg};
            res.setJsonPayload(response);
        }
        _ = res.send();
    }
}