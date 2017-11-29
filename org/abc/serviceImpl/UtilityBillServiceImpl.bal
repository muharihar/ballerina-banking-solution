package org.abc.serviceImpl;

import ballerina.net.http;
import org.abc.util as utils;

public function payUtilityBills (http:Request req) (http:Response res) {
    res = {};

    map formParams = req.getFormParams();
    var account, _ = (int)formParams["fromacc"];
    var billNo, _ = (string)formParams["billno"];
    var provider, _ = (string)formParams["provider"];
    var amount, _ = (float)formParams["amount"];


    json resJ;
    //json reqJ = req.getJsonPayload();
    //var account, _ = <int> reqJ.account.toString();
    //string billNo = reqJ.billNo.toString();
    //string provider = reqJ.provider.toString();
    //var amount, _ = (float) reqJ.amount;

    var result, ex = utils:utilityBillPaymentRequest(account, billNo, provider, amount);
    if (ex == null) {
        resJ = {"result":result};
        res.setJsonPayload(resJ);
    }
    else {
        resJ = {"error":ex.msg};
        res.setJsonPayload(resJ);
    }
    return;
}