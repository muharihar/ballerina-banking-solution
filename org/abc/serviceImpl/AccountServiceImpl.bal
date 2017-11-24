package org.abc.serviceImpl;

import org.abc.util as utils;
import ballerina.net.http;

public function getAccountInfo (http:Request req)(http:Response res) {
    res = {};
    http:Session sesn = req.getSession();
    //println(sesn.getId());
    if (sesn != null) {
        var clientID, er = (string)sesn.getAttribute("clientid");
        var id, _ = <int>clientID;
        var j, ex = utils:getAccountInfoList(id);
        if (ex == null) {
            res.setJsonPayload(j);
        }
    } else {
        res.setStatusCode(403);
    }
    return;
}

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