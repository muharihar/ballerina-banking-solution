package org.abc.serviceImpl;

import ballerina.net.http;
import org.abc.util;

public function handleLogin (http:Request req) (http:Response res) {

    res = {};
    map formParams = req.getFormParams();
    var userName, _ = (string)formParams["username"];
    var passwd, _ = (string)formParams["password"];

    if (userName != "" && passwd != "") {
        http:Session sesn = req.createSessionIfAbsent();
        var userId, err = util:loginUser(userName, passwd);
        println("userId==");
        println(userId);
        println("Error==");
        println(err);
        if (err == null) {
            sesn.setAttribute("clientid",userId);
            res.setStatusCode(200);
        } else {
            // Un authorized
            res.setStatusCode(403);
        }
    } else {
        // No pass word Provided
        res.setStatusCode(403);
    }
    return res;
}