package services;

import ballerina.net.http;
import org.abc.serviceImpl as serImpl;

@http:configuration {
    basePath:"/file"
}
service<http> FileService {
    
    @http:resourceConfig {
        methods:["POST"],
        path:"/createFile/{userid}"
    }
    resource createFileResource (http:Request req,http:Response res, string userid) {
        http:Response newRes = {};
        var t, v = req.getHeader("Content-Type");
        println(t);
        newRes = serImpl:processPayload(req, userid);
        _ = res.forward(newRes);
    }
}