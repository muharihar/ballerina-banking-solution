package org.abc.connectors;

import ballerina.net.http;
import ballerina.util;
import ballerina.config;

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

    action isExist (string username)(boolean isExist, http:HttpConnectorError err){
        endpoint<http:HttpClient> idp{
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
       response, err = idp.post("/RemoteUserStoreManagerService.RemoteUserStoreManagerServiceHttpsSoap11Endpoint/", request);
       xml rePayload = response.getXmlPayload();
       xml allChildren = rePayload.children();
       xml authResponse = allChildren.selectChildren("isExistingUserResponse");
       xml authResponseChild = authResponse.selectChildren("return");
       string elementTextValue = authResponseChild.getTextValue();
       isExist, _ = <boolean>elementTextValue;
       return;
    }

     action addUser (string username, string password, string userid)(boolean userAdded, http:HttpConnectorError err){endpoint<http:HttpClient>idp{
            init();}
        http:Request request = {};
        string soapAct = "urn:addUser";
        xmlns "http://service.ws.um.carbon.wso2.org" as ser;
        xmlns "http://service.ws.um.carbon.wso2.org" as ns;
        xmlns "http://schemas.xmlsoap.org/soap/envelope/" as soapenv;
        xml payloadToBeSent = xml `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.ws.um.carbon.wso2.org" xmlns:xsd="http://common.mgt.user.carbon.wso2.org/xsd">
   <soapenv:Header/>
   <soapenv:Body>
      <ser:addUser>
         <ser:userName>{{username}}</ser:userName>
         <ser:credential>{{password}}</ser:credential>
         <ser:roleList>user</ser:roleList>
         <ser:claims>
            <xsd:claimURI>http://wso2.org/claims/im</xsd:claimURI>
            <xsd:value>{{userid}}</xsd:value>
         </ser:claims>
         <ser:profileName>default</ser:profileName>
         <ser:requirePasswordChange>false</ser:requirePasswordChange>
      </ser:addUser>
   </soapenv:Body>
</soapenv:Envelope>`;

       request = getRequest(soapAct, payloadToBeSent, authHeader);
       http:Response response = {};
       response, err = idp.post("/RemoteUserStoreManagerService.RemoteUserStoreManagerServiceHttpsSoap11Endpoint/", request);
       int headerValue= response.getStatusCode();
       if (headerValue == 202){
                userAdded = true;
       }
       return;
    }

    action getid (string username)(string userid, http:HttpConnectorError err){endpoint<http:HttpClient>idp{
            init();}
        http:Request request = {};
        string soapAct = "urn:getUserClaimValue";
        xmlns "http://service.ws.um.carbon.wso2.org" as ser;
        xmlns "http://service.ws.um.carbon.wso2.org" as ns;
        xmlns "http://schemas.xmlsoap.org/soap/envelope/" as soapenv;
        xml payloadToBeSent = xml `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.ws.um.carbon.wso2.org">
   <soapenv:Header/>
   <soapenv:Body>
      <ser:getUserClaimValue>
         <ser:userName>{{username}}</ser:userName>
         <ser:claim>http://wso2.org/claims/im</ser:claim>
         <ser:profileName>default</ser:profileName>
      </ser:getUserClaimValue>
   </soapenv:Body>
</soapenv:Envelope>`;

       request = getRequest(soapAct, payloadToBeSent, authHeader);
       http:Response response = {};
       response, err = idp.post("/RemoteUserStoreManagerService.RemoteUserStoreManagerServiceHttpsSoap11Endpoint/", request);
       xml rePayload = response.getXmlPayload();
       xml allChildren = rePayload.children();
       xml authResponse = allChildren.selectChildren("getUserClaimValueResponse");
       xml authResponseChild = authResponse.selectChildren("return");
       string elementTextValue = authResponseChild.getTextValue();
       userid = elementTextValue;
       return;
    }

}
function getEncodedValue(string value1,string value2) (string encodedString) {
    string toEncode = value1 + ":" + value2;
    encodedString = util:base64Encode(toEncode);
    return ;
}
function init() (http:HttpClient idpEndpoint) {
    //string url = "https://192.168.48.209:9443/services";
    string hostname = config:getGlobalValue("idp.host");
    string port = config:getGlobalValue("idp.port");
    string url = string `https://{{hostname}}:{{port}}/services`;
    println(url);
    //string url = "https://localhost:8909/services";
    idpEndpoint = create http:HttpClient(url,{});
    return ;
}
function getRequest(string soapAction, xml payload, string authHeader) (http:Request req){
    req = {};
    req.setHeader("SOAPAction",soapAction);
    req.setHeader("Authorization", "Basic "+ authHeader);
    req.setXmlPayload(payload);
    req.setHeader("Content-Type", "text/xml");
    return req;
}

