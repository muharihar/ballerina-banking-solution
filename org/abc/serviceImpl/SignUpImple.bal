package org.abc.serviceImpl;

import ballerina.net.http;
import org.abc.db as dbops;
import org.abc.util;

public function handleSignup (http:Request req) (http:Response res) {

    res = {};
    http:Session sesn = req.getSession();
    if (sesn != null) {
        var clientID, _ = (int)sesn.getAttribute("clientid");
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

public function addUser (http:Request req) (http:Response res) {

    res = {};
    http:Session sesn = req.getSession();
    if (sesn != null) {

        map formParams = req.getFormParams();
        var username, err1 = (string)formParams["username"];
        var passwd, err2 = (string)formParams["password"];
        println("XXXXX");
        if (err1 == null || err2 == null) {
            //println("Username : " + username + " Password : " + passwd + );
            var clientid , _ = (int)sesn.getAttribute("clientid");
            println("Username : " + username + " Password : " + passwd + " Client ID : " +<string>clientid);
            var bool, e = util:signUpUser(username, passwd, <string>clientid);
            if (e == null && bool) {
                res.setStatusCode(200);
            } else {
                // Generate an Error
            }
        } else {
            // This means that the username and creds are not available
        }
    } else {
        // Invalid session so, send an error
        res.setStatusCode(403);
    }
    return;
}