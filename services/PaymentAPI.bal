package services;

import ballerina.net.http;
import org.abc.serviceImpl;

@http:configuration {
    basePath:"/"
}
service<http> PaymentAPI {
    @http:resourceConfig {
        methods:["POST"],
        path:"/payutilitybill"
    }
    resource getuser (http:Request req, http:Response resp) {
        //sample payload
        //json j = {"account":114565456, "billNo":"0771162518", "provider":"Dialog", "amount":3240.50};

        http:Response beResp = serviceImpl:payUtilityBills(req);
        _ = resp.forward(beResp);
    }

}
