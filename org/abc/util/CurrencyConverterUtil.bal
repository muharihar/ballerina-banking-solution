package org.abc.util;

import ballerina.net.http;
import ballerina.math;
import ballerina.config;

public function getExchangeRate (string base, string to) (float, error) {
    endpoint<http:HttpClient> ep {
        initFixer();
    }
    string access_token = config:getGlobalValue("exchange_rate_access_token");
    http:Request request = {};
    http:Response res = {};
    http:HttpConnectorError ex;
    float rate;
    float ceil;
    json response;
    boolean isSuccess;
    error err;

    res, ex = ep.post("/live?access_key=" + access_token + "&source=" + base + "&currencies=" + to + "&format=1", request);

    if((error )ex == null){
        response = res.getJsonPayload();
        isSuccess, _ = <boolean>response["success"].toString();
        if (isSuccess){
            rate, _= <float>response.quotes[base+to].toString();
            ceil = math:ceil(rate);
        }else{
            err = {msg:response.error["info"].toString()};
        }

        println(response);

    }else{
        err = {msg:"Couldn't retrieve the exchange rates. Please try again later"};
    }

    return ceil, err;
}


public function getExchangeRateValue (string base, string to, float val) (float, error) {
    endpoint<http:HttpClient> ep {
        initFixer();
    }
    string access_token = config:getGlobalValue("exchange_rate_access_token");
    http:Request request = {};
    http:Response res = {};
    http:HttpConnectorError ex;
    float rate;
    float ceil;
    float totVal;
    json response;
    boolean isSuccess;
    error err;

    res, ex = ep.post("/live?access_key=" + access_token + "&source=" + base + "&currencies=" + to + "&format=1", request);

    if((error)ex == null){
        response = res.getJsonPayload();
        isSuccess, _ = <boolean>response["success"].toString();
        if (isSuccess){
            rate, _= <float>response.quotes[base+to].toString();
            ceil = math:ceil(rate);
            totVal = ceil * val;
        }else{
            err = {msg:response.error["info"].toString()};
        }

        println(response);

    }else{
        err = {msg:"Couldn't retrieve the exchange rates. Please try again later"};
    }


    return totVal, err;
}


function initFixer () (http:HttpClient ep) {
    string baseURL = "http://apilayer.net/api";
    ep = create http:HttpClient(baseURL,{});
    return;
}