package services;

import ballerina.net.http;
import org.abc.serviceImpl;

@http:configuration {
    basePath:"/",
    allowOrigins:["http://localhost", "http://localhost:4200"],
    allowCredentials:true
}
service<http> api {
    @http:resourceConfig {
        methods:["GET"],
        path:"/api/getuser"
    }
    resource getuser (http:Request req, http:Response resp) {
        http:Response beResp = serviceImpl:handleSignup(req);
        _ = resp.forward(beResp);
    }

    @http:resourceConfig {
        methods:["POST"],
        path:"/api/token"
    }
    resource tokenInbound (http:Request req, http:Response resp) {
        http:Response  beResp = serviceImpl:checkTokenValidity(req);
        _ = resp.forward(beResp);
    }

    @http:resourceConfig {
        methods:["POST","GET"],
        path:"/api/login"
    }
    resource loginInbound (http:Request req, http:Response resp) {
        http:Response  beResp = serviceImpl:handleLogin(req);
        _ = resp.forward(beResp);
    }

    @http:resourceConfig {
        methods:["POST"],
        path:"/api/signup"
    }
    resource signupUser (http:Request req, http:Response resp) {
        http:Response r = serviceImpl:addUser(req);
        _ = resp.forward(r);
    }

    @http:resourceConfig {
        methods:["GET"],
        path:"/api/logout"
    }
    resource logout (http:Request req, http:Response resp) {
        // Check whether the Token is valid
        // If valid Generate a session and send a 200 to client
        http:Response  beResp = serviceImpl:logOut(req);
        _ = resp.forward(beResp);
    }

    @http:resourceConfig {
        methods:["GET"],
        path:"/api/userprofile"
    }
    resource getUserProfile (http:Request req, http:Response resp) {
        http:Response beResp = serviceImpl:getUserProfile(req);
        _ = resp.forward(beResp);
    }

    @http:resourceConfig {
        methods:["GET"],
        path:"/api/account/getinfo"
    }
    resource getAccountInfo (http:Request req, http:Response resp) {
        http:Response beResp = serviceImpl:getAccountInfo(req);
        _ = resp.forward(beResp);
    }

    @http:resourceConfig {
        path:"/api/accounthistory",
        methods:["GET"]
    }
    resource getAccountHistoryResource (http:Request req, http:Response res) {
        http:Response re = {};
        re = serviceImpl:getAccountHistoryByAcc(req);
        _ = res.forward(re);

    }

    @http:resourceConfig {
        path:"/api/payorder/add",
        methods:["POST"]
    }
    resource addPayorder (http:Request req, http:Response res) {
        http:Response re = {};
        re = serviceImpl:addPayOrder(req);
        _ = res.forward(re);

    }

    @http:resourceConfig {
        path:"/api/payorder/get",
        methods:["GET"]
    }
    resource getPayorder (http:Request req, http:Response res) {
        http:Response re = {};
        re = serviceImpl:getPayOrders(req);
        _ = res.forward(re);
    }

    @http:resourceConfig {
        methods:["POST"],
        path:"/api/payutilitybill"
    }
    resource payUtilityBills (http:Request req, http:Response resp) {
        //sample payload
        //json j = {"account":114565456, "billNo":"0771162518", "provider":"Dialog", "amount":3240.50};

        http:Response beResp = serviceImpl:payUtilityBills(req);
        _ = resp.forward(beResp);
    }
}