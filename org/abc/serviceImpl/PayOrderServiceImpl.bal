package org.abc.serviceImpl;

import org.abc.util as utils;
import ballerina.net.http;

public function addPayOrder (http:Request req) (http:Response res) {
    res = {};
    http:Session sesn = req.getSession();
    //println(sesn.getId());
    if (sesn != null) {
        map formParams = req.getFormParams();
        var payAmmount, err1 = (string)formParams["ammount"];
        var fromAc, err2 = (string)formParams["fromacc"];
        var toAcc, err3 = (string)formParams["toacc"];
        var freq, err4 = (string)formParams["freq"];
        var day, err5 = (string)formParams["day"];
        println(formParams);
        //string payAmount, string day, string fromAcNo, string toAcNo, string freq
        var ex = utils:registerPayOrder(payAmmount, day, fromAc, toAcc, freq);
        if (ex == null) {
            res.setStatusCode(200);
        } else {
            print(ex);
            res.setStatusCode(500);
        }
    } else {
        res.setStatusCode(403);
    }
    return;
}

public function getPayOrders (http:Request req) (http:Response res) {
    res = {};
    http:Session sesn = req.getSession();
    if (sesn != null) {
        var clientID, er = (string)sesn.getAttribute("clientid");
        var id, _ = <int>clientID;
        var j, ex = utils:listPayOrders(id);
        if (ex == null) {
            res.setStatusCode(200);
            res.setJsonPayload(j);
        } else {
            print(ex);
            res.setStatusCode(500);
        }
    } else {
        res.setStatusCode(403);
    }
    return;
}