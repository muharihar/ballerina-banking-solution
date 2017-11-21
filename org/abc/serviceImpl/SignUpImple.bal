package org.abc.serviceImpl;

import ballerina.net.http;
import org.abc.db as dbops;

public function handleSignup (http:Request req) (http:Response res) {

    res = {};
    http:Session sesn = req.getSession();

    if (sesn != null) {
        var clientID, _ = (int)sesn.getAttribute("clientid");
        println(clientID);
        var pl, err = dbops:getUserInfoWithID(clientID);
        pl = pl[0];
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