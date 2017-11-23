package org.abc.util;

import ballerina.net.http;

public function isSessionVlid (http:Request req) (boolean valid) {

    valid = false;
    http:Session sesn = req.getSession();
    if (sesn != null) {
        valid = true;
    }
    return;
}