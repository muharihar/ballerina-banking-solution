package org.abc.connectors;

import ballerina.net.http;
import ballerina.util;

public connector GmailConnector (string accessToken) {

    action sendMail (string to, string subject, string from, string messageBody, string cc, string bcc, string id,
                     string threadId) (json responseToSend, http:HttpConnectorError err) {

        endpoint<http:HttpClient> gmailEP {
            init2();
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
        request.setHeader("Authorization", "Bearer " + accessToken);
        request.setHeader("Content-Type", "application/json");
        request.setJsonPayload(sendMailRequest);

        response, err = gmailEP.post(sendMailPath, request);
        responseToSend = response.getJsonPayload();

        return;
    }

}


function init2 () (http:HttpClient gmailEndpoint) {
    string baseURL = "https://www.googleapis.com/gmail";
    gmailEndpoint = create http:HttpClient(baseURL, {});
    return;
}