
package org.abc.serviceImpl;
import ballerina.net.http;
import org.abc.util as utils;
public function processPayload(http:Request req,string userid) (http:Response res) {
    blob requestPayload;
    blob encryptPayload;
    int var1 = 1;
    res = {};
    error eProcessPayload;
    requestPayload = req.getBinaryPayload();
    var headerValue,isExists = req.getHeader("Content-Type");
    var testH, testEH = req.getHeader("Content-Disposition");
    println(testH);
    println(testEH);
    
    if (isExists) {
        boolean st = utils:checkContentType(headerValue);
        
        if (st) {
            encryptPayload,eProcessPayload = utils:encryptBlobContent(requestPayload);
            eProcessPayload = utils:writeToFile(encryptPayload,headerValue, userid);
        } else {
            eProcessPayload = {msg:"The content type is not supported"};
        }
    } else {
        eProcessPayload = {msg:"The header does not exist"};
    }
    
    if (eProcessPayload == null) {
        res.setStringPayload("File created and written");
    } else {
        res.setStringPayload(eProcessPayload.msg);
    }
    return ;
}