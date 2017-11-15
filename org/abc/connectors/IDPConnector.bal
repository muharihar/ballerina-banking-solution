package org.abc.connectors;import ballerina.net.http;import ballerina.util;
public connector IDPConnector () {
    string authHeader = getEncodedValue("admin","admin");

    action authenticate (string username, string password)(boolean isAuthenticated, http:HttpConnectorError err){endpoint<http:HttpClient>idp{
            init();}
        http:Request request = {};
        string soapAct = "urn:authenticate";
        xmlns "http://service.ws.um.carbon.wso2.org" as ser;
        xmlns "http://service.ws.um.carbon.wso2.org" as ns;
        xmlns "http://schemas.xmlsoap.org/soap/envelope/" as soapenv;
        xml payloadToBeSent = xml `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.ws.um.carbon.wso2.org">
    <soapenv:Header/><soapenv:Body><ser:authenticate><ser:userName>{{username}}</ser:userName><ser:credential>{{password}}</ser:credential></ser:authenticate></soapenv:Body>
</soapenv:Envelope>`;

       request = getRequest(soapAct, payloadToBeSent, authHeader);
       http:Response response = {};
       response, err = idp.post("/RemoteUserStoreManagerService.RemoteUserStoreManagerServiceHttpsSoap11Endpoint/", request);
       xml rePayload = response.getXmlPayload();
       xml allChildren = rePayload.children();
       xml authResponse = allChildren.selectChildren("authenticateResponse");
       xml authResponseChild = authResponse.selectChildren("return");
       string elementTextValue = authResponseChild.getTextValue();
       isAuthenticated, _ = <boolean>elementTextValue;
       return;
    }

    action isExist (string username)(boolean isExist, http:HttpConnectorError err){endpoint<http:HttpClient>idp{
            init();}
        http:Request request = {};
        string soapAct = "urn:isExistingUser";
        xmlns "http://service.ws.um.carbon.wso2.org" as ser;
        xmlns "http://service.ws.um.carbon.wso2.org" as ns;
        xmlns "http://schemas.xmlsoap.org/soap/envelope/" as soapenv;
        xml payloadToBeSent = xml `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.ws.um.carbon.wso2.org">
   <soapenv:Header/>
   <soapenv:Body>
      <ser:isExistingUser>
         <ser:userName>{{username}}</ser:userName>
      </ser:isExistingUser>
   </soapenv:Body>
</soapenv:Envelope>`;

       request = getRequest(soapAct, payloadToBeSent, authHeader);
       http:Response response = {};
       response, err = idp.post("/RmoteUserStoreManagerService.RemoteUserStoreManagerServiceHttpsSoap11Endpoint/", request);
       xml rePayload = response.getXmlPayload();
       xml allChildren = rePayload.children();
       xml authResponse = allChildren.selectChildren("isExistingUserResponse");
       xml authResponseChild = authResponse.selectChildren("return");
       string elementTextValue = authResponseChild.getTextValue();
       isExist, _ = <boolean>elementTextValue;
       return;
    }

     action addUser (string username)(boolean isExist, http:HttpConnectorError err){endpoint<http:HttpClient>idp{
            init();}
        http:Request request = {};
        string soapAct = "urn:isExistingUser";
        xmlns "http://service.ws.um.carbon.wso2.org" as ser;
        xmlns "http://service.ws.um.carbon.wso2.org" as ns;
        xmlns "http://schemas.xmlsoap.org/soap/envelope/" as soapenv;
        xml payloadToBeSent = xml `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.ws.um.carbon.wso2.org">
   <soapenv:Header/>
   <soapenv:Body>
      <ser:isExistingUser>
         <ser:userName>{{username}}</ser:userName>
      </ser:isExistingUser>
   </soapenv:Body>
</soapenv:Envelope>`;

       request = getRequest(soapAct, payloadToBeSent, authHeader);
       http:Response response = {};
       response, err = idp.post("/RmoteUserStoreManagerService.RemoteUserStoreManagerServiceHttpsSoap11Endpoint/", request);
       xml rePayload = response.getXmlPayload();
       xml allChildren = rePayload.children();
       xml authResponse = allChildren.selectChildren("isExistingUserResponse");
       xml authResponseChild = authResponse.selectChildren("return");
       string elementTextValue = authResponseChild.getTextValue();
       isExist, _ = <boolean>elementTextValue;
       return;
    }
}
function getEncodedValue(string value1,string value2) (string encodedString) {
    string toEncode = value1 + ":" + value2;
    encodedString = util:base64encode(toEncode);
    return ;
}
function init() (http:HttpClient idpEndpoint) {
    string url = "https://localhost:9443/services";
    idpEndpoint =
    create http:HttpClient(url,{});
    return ;
}
function getRequest(string soapAction, xml payload, string authHeader) (http:Request req){
    req = {};
    println(soapAction);
    req.setHeader("SOAPAction",soapAction);
    req.setHeader("Authorization", "Basic "+ authHeader);
    println("1");
    req.setXmlPayload(payload);
    req.setHeader("Content-Type", "text/xml");
    return req;
}

