package org.abc.serviceImpl;

import ballerina.net.http;
import org.abc.db as dbops;
import org.abc.util;

public function getUserProfile (http:Request req) (http:Response res) {

    res = {};
    http:Session sesn = req.getSession();
    //println(sesn.getId());
    if (sesn != null) {
        var clientID, er = (string)sesn.getAttribute("clientid");
        var id, _ = <int>clientID;
        //int clientID = 1076699776;
        println(er);
        println("Client ID : ");
        println(clientID);
        var pl, err = dbops:getUserInfoWithID(id);
        println(pl);
        println(err);
        //pl = pl[0];
        if (err == null) {
            res.setStatusCode(200);
            res.setJsonPayload(pl);
        } else {
            res.setStatusCode(500);
        }
    } else {
        res.setStatusCode(403);
    }
    return res;
}