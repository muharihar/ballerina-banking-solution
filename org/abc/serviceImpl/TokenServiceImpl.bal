package org.abc.serviceImpl;

import org.abc.db as dboperations;
import ballerina.net.http;

public function checkTokenValidity (http:Request req) (http:Response res) {

    res = {};
    map formParams = req.getFormParams();
    var token, _ = (string)formParams["token"];
    println(token);
    int userID = dboperations:isTokenValid(token);
    println(userID);
     //If token is valid then create a session and return the session
    if (userID != 0) {
        http:Session sesn = req.createSessionIfAbsent();
        println("Created session : ");
        println(sesn.getId());
        //println("Existing Session : ");
        //println(req.getSession());
        sesn.setAttribute("clientid", userID);
        var att, _ = (int)sesn.getAttribute("clientid");
        res.setStatusCode(200);
    } else {
        println("Error Invalid Token, Please add a correct Token");
        res.setStatusCode(403);
    }
    return res;
}

