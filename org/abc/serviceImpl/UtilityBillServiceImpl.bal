package org.abc.serviceImpl;

import ballerina.net.http;
import org.abc.util as utils;

public function payUtilityBills (http:Request req) (http:Response res) {
    res = {};
    TypeConversionError err;
    int acc;
    float amt;

    map formParams = req.getFormParams();
    var account, _ = (string)formParams["fromacc"];
    acc, err = <int> account;
    var billNo, _ = (string)formParams["billno"];
    var provider, _ = (string)formParams["provider"];
    var amount, _ = (string)formParams["amount"];
    amt, err = <float>amount;

    json resJ;
    //json reqJ = req.getJsonPayload();
    //var account, _ = <int> reqJ.account.toString();
    //string billNo = reqJ.billNo.toString();
    //string provider = reqJ.provider.toString();
    //var amount, _ = (float) reqJ.amount;

    var result, ex = utils:utilityBillPaymentRequest(acc, billNo, provider, amt);
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