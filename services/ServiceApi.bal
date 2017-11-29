package services;

import ballerina.net.http;
import org.abc.serviceImpl;

@http:configuration {
    basePath:"/api",
    allowOrigins:["http://localhost", "http://localhost:4200"],
    allowCredentials:true
}
service<http> api {
    @http:resourceConfig {
        methods:["GET"],
        path:"/getuser"
    }
    resource getuser (http:Request req, http:Response resp) {
        //json payload = {
        //                   "user_id":1034567890,
        //                   "first_name":"Chathurika",
        //                   "last_name":"De Silva",
        //                   "national_id":"867865344V",
        //                   "birth_date":"1986-07-23",
        //                   "email":"chathurika@gmail.com",
        //                   "address":"No.12,Maradana"
        //               };
        http:Response beResp = serviceImpl:handleSignup(req);
        _ = resp.forward(beResp);
    }

    @http:resourceConfig {
        methods:["POST"],
        path:"/token"
    }
    resource tokenInbound (http:Request req, http:Response resp) {
        http:Response  beResp = serviceImpl:checkTokenValidity(req);
        _ = resp.forward(beResp);
    }

    @http:resourceConfig {
        methods:["POST","GET"],
        path:"/login"
    }
    resource loginInbound (http:Request req, http:Response resp) {
        http:Response  beResp = serviceImpl:handleLogin(req);
        _ = resp.forward(beResp);
    }

    @http:resourceConfig {
        methods:["POST"],
        path:"/signup"
    }
    resource signupUser (http:Request req, http:Response resp) {
        http:Response r = serviceImpl:addUser(req);
        _ = resp.forward(r);
    }

    @http:resourceConfig {
        methods:["GET"],
        path:"/logout"
    }
    resource logout (http:Request req, http:Response resp) {
        // Check whether the Token is valid
        // If valid Generate a session and send a 200 to client
        http:Response  beResp = serviceImpl:logOut(req);
        _ = resp.forward(beResp);
    }

    @http:resourceConfig {
        methods:["GET"],
        path:"/userprofile"
    }
    resource getUserProfile (http:Request req, http:Response resp) {
        http:Response beResp = serviceImpl:getUserProfile(req);
        _ = resp.forward(beResp);
    }

    @http:resourceConfig {
        methods:["GET"],
        path:"/account/getinfo"
    }
    resource getAccountInfo (http:Request req, http:Response resp) {
        http:Response beResp = serviceImpl:getAccountInfo(req);
        _ = resp.forward(beResp);
    }

    @http:resourceConfig {
        path:"/accounthistory",
        methods:["GET"]
    }
    resource getAccountHistoryResource (http:Request req, http:Response res) {
        http:Response re = {};
        re = serviceImpl:getAccountHistoryByAcc(req);
        _ = res.forward(re);

    }
}