# ballerina-banking-solution

An POC online banking system done with ballerina. This only contains the backend server.


## How to deploy

1. Setup ballerina Runtime. (Refer https://github.com/ballerinalang/ballerina)
2. Add the MYSQL driver to Ballerina Runtime.
3. Execute DB script on top of MySQL : (resources/db-schema.sql)
4. Deploy WSO2 Identity server. (This is used for User Management)
5. Add relevant URLs (DB/ IS) in ballerina.conf file.
6. Add CORS headers if necessary in ServiceApi.bal
7. Start Ballerina Server.
8. You can deploy the UI component referring (https://github.com/yasassri/online-banking-ui)