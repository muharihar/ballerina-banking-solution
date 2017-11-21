package org.abc.serviceImpl;

import org.abc.util as utils;
import ballerina.net.http;

public function getAccountHistory (http:Request req) (http:Response res) {
    res = {};
    json reqJ = req.getJsonPayload();
    var resJ, ex = utils:getAccountHistoryUtil(reqJ);
    if (ex == null) {
        res.setJsonPayload(resJ);
    }
    else{
        res.setJsonPayload(ex.msg);
    }
    return;
}