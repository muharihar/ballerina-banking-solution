package org.abc.connectors;

import ballerina.net.http;
import ballerina.util;
import ballerina.config;
import ballerina.log;

string access_token = config:getGlobalValue("gmail_access_token");

public connector GmailConnector () {

    action sendMail (string to, string subject, string from, string messageBody, string cc, string bcc, string id,
                     string threadId) (json responseToSend, http:HttpConnectorError err) {

        endpoint<http:HttpClient> gmailEP {
            init2();
        }

        boolean isExpired;
        error e;
        error eAccess;

        //check if the access token has expired and get a new access token if expired
        isExpired, e = isAccessTokenExpired();

        if (isExpired) {
            access_token, eAccess = getAccessToken();
        } else if (!isExpired) {
            log:printInfo("Access token has not expired");
        } else {
            log:printError("Error: " + e.msg);
        }


        http:Request request = {};
        http:Response response = {};
        string concatRequest = "";

        if (to != "null") {
            concatRequest = concatRequest + "to:" + to + "\n";
        }

        if (subject != "null") {
            concatRequest = concatRequest + "subject:" + subject + "\n";
        }

        if (from != "null") {
            concatRequest = concatRequest + "from:" + from + "\n";
        }

        if (cc != "null") {
            concatRequest = concatRequest + "cc:" + cc + "\n";
        }

        if (bcc != "null") {
            concatRequest = concatRequest + "bcc:" + bcc + "\n";
        }

        if (id != "null") {
            concatRequest = concatRequest + "id:" + id + "\n";
        }

        if (threadId != "null") {
            concatRequest = concatRequest + "threadId:" + threadId + "\n";
        }

        if (messageBody != "null") {
            concatRequest = concatRequest + "\n" + messageBody + "\n";
        }


        string encodedRequest = util:base64encode(concatRequest);
        json sendMailRequest = {"raw":encodedRequest};
        string sendMailPath = "/v1/users/me/messages/send";
        request.setHeader("Authorization", "Bearer " + access_token);
        request.setHeader("Content-Type", "application/json");
        request.setJsonPayload(sendMailRequest);

        if (eAccess == null) {
            log:printInfo("Access token is " + access_token);
            response, err = gmailEP.post(sendMailPath, request);
            responseToSend = response.getJsonPayload();
        }


        return;
    }

}


function init2 () (http:HttpClient gmailEndpoint) {
    string baseURL = "https://www.googleapis.com/gmail";
    gmailEndpoint = create http:HttpClient(baseURL, {});
    return;
}


function getAccessToken () (string, error) {
    endpoint<http:HttpClient> gmailTokenEP {
        create http:HttpClient("https://www.googleapis.com/oauth2/v4", {});
    }

    string refresh_token = config:getGlobalValue("gmail_refresh_token");
    string client_id = config:getGlobalValue("gmail_client_id");
    string client_secret = config:getGlobalValue("gmail_client_secret");

    http:Request request = {};
    http:Response response = {};
    http:HttpConnectorError err;
    error msg;
    string body = "grant_type=refresh_token&client_id=" + client_id + "&client_secret=" + client_secret + "&refresh_token=" + refresh_token;
    request.setStringPayload(body);

    request.setHeader("content-type", "application/x-www-form-urlencoded");

    response, err = gmailTokenEP.post("/token", request);
    json jResponse = response.getJsonPayload();

    try {
        if ((error)err == null) {
            access_token, _ = (string)jResponse.access_token;
            log:printInfo("New access token is generated");
        } else {

            msg = {msg:"Error occurred when sending a request to retrieve the access token"};
        }
    } catch (error e) {
        msg = {msg:"Error getting the access token"};
    }

    return access_token, msg;

}


function isAccessTokenExpired () (boolean, error) {
    endpoint<http:HttpClient> gmailTokenEP {
        create http:HttpClient("https://www.googleapis.com/oauth2/v1", {});
    }

    http:Request request = {};
    http:Response response = {};
    http:HttpConnectorError err;
    error msg;
    string res;
    boolean isExpired = false;


    string body = "access_token=" + access_token;
    request.setStringPayload(body);
    request.setHeader("content-type", "application/x-www-form-urlencoded");

    response, err = gmailTokenEP.post("/tokeninfo", request);
    json jResponse = response.getJsonPayload();

    try {
        if ((error)err == null) {
            //check if an error returns as the response, meaning the token has expired
            res, _ = (string)jResponse.error;
            isExpired = true;
            log:printInfo("Access Token has been expired");
        } else {
            msg = {msg:"Error occurred when sending a request to retrieve the access token"};
        }
    } catch (error e) {
        msg = {msg:"Error getting the access token"};
    }
    println(isExpired);
    return isExpired, msg;
}

