package org.abc.util;

import org.abc.connectors as con;
import ballerina.net.http;

public function signUpUser (string username, string password, string userid) (boolean, error) {
    endpoint<con:IDPConnector> ep {
        create con:IDPConnector();
    }
    boolean userAdded;
    error err;
    http:HttpConnectorError ex;

    var userExist, uExist = ep.isExist(username);
    println(userExist);
    if (uExist == null) {
        if (!userExist) {
            userAdded, ex = ep.addUser(username, password, userid);
            err = (error)ex;
        }
        else {
            err = {msg:"User with username: " + username + " already exists"};
        }
    }
    else {
        err = (error)uExist;
    }
    return userAdded, err;
}

public function loginUser (string username, string password) (string, error) {
    endpoint<con:IDPConnector> ep {
        create con:IDPConnector();
    }
    string userid;
    error err;
    http:HttpConnectorError ex;

    var userAuth, uAuth = ep.authenticate(username, password);
    if (uAuth == null) {
        if (userAuth) {
            userid, ex = ep.getid(username);
            err = (error)ex;
        }
        else {
            err = {msg:"User not authenticated. Please try again"};
        }
    }
    else {
        err = (error)uAuth;
    }
    return userid, err;
}

