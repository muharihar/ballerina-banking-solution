package services;

import ballerina.net.http;
import org.abc.util as utils;
import ballerina.log;

@http:configuration {
    basePath:"/currency"
}
service<http> ABCOnlineBankingCurrencyService {

    @http:resourceConfig {
        methods:["GET"],
            path:"/getExchangeRate/{base}/{to}"
    }
    resource getExchangeRate (http:Request req, http:Response res, string base, string to) {

        var rate, err = utils:getExchangeRate(base,to);
        json response;
        if (err == null) {
            response = {"exchange rate":rate};
            res.setJsonPayload(response);
        }
        else {
            response = {"error":err.msg};
            res.setJsonPayload(response);
        }
        res.send();
    }


    @http:resourceConfig {
        methods:["GET"],
        path:"/getExchangeRateValue/{base}/{to}/{value}"
    }
    resource getExchangeRateValue (http:Request req, http:Response res, string base, string to, string value) {

        var val, _ = <float>value;
        var rate, err = utils:getExchangeRateValue(base,to,val);
        json response;
        if (err == null) {
            response = {"exchange rate value":rate};
            res.setJsonPayload(response);
        }
        else {
            response = {"error":err.msg};
            res.setJsonPayload(response);
        }
        res.send();
    }
}