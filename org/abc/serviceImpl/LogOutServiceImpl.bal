package org.abc.serviceImpl;

import ballerina.net.http;

public function logOut (http:Request req) (http:Response res) {

    res = {};
    http:Session sesn = req.getSession();

    if (sesn != null) {
       sesn.invalidate();
        res.setStatusCode(200);

    } else {
        res.setStatusCode(500);
    }
    return res;
}