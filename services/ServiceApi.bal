package services;

import ballerina.net.http;
@http:configuration {
    basePath:"/api",
    allowOrigins:["http://localhost", "http://localhost:4200"],
    allowCredentials:true
}
service<http> api {
    @http:resourceConfig {
        methods:["POST"],
        path:"/getuser"
    }
    resource getuser (http:Request req, http:Response resp) {
        json payload = {
                           "user_id":1034567890,
                           "first_name":"Chathurika",
                           "last_name":"De Silva",
                           "national_id":"867865344V",
                           "birth_date":"1986-07-23",
                           "email":"chathurika@gmail.com",
                           "address":"No.12,Maradana"
                       };
        resp.setJsonPayload(payload);
        resp.send();
    }

    @http:resourceConfig {
        methods:["POST"],
        path:"/token"
    }
    resource tokenInbound (http:Request req, http:Response resp) {
        // Check whether the Token is valid
        // If valid Generate a session and send a 200 to client
        json payload = [{}];
        resp.setStatusCode(200);
        resp.send();
    }

    @http:resourceConfig {
        methods:["POST"],
        path:"/signup"
    }
    resource signupUser (http:Request req, http:Response resp) {

        map params = req.getFormParams();
        println(params);
        println(req);
        json payload = {
                           "user_id":1034567890,
                           "first_name":"Chathurika",
                           "last_name":"De Silva",
                           "national_id":"867865344V",
                           "birth_date":"1986-07-23",
                           "email":"chathurika@gmail.com",
                           "address":"No.12,Maradana"
                       };
        resp.setStatusCode(200);
        resp.send();
    }

    @http:resourceConfig {
        methods:["GET"],
        path:"/logout"
    }
    resource logout (http:Request req, http:Response resp) {
        // Check whether the Token is valid
        // If valid Generate a session and send a 200 to client
        json payload = [{}];
        resp.setStatusCode(200);
        resp.send();
    }
}