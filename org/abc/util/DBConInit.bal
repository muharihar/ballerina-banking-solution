package org.abc.util;

import ballerina.data.sql;
import ballerina.os;


function init() (sql:ClientConnector connInit){
    string mysqlHostName = "192.168.48.209";
    int mysqlPort = 3306;
    string mysqlDatabase = "Bank";
    string mysqlUserName = "root";
    string mysqlPassword = "root";
    map props = {verifyServerCertificate:false,useSSL:false};
 
    sql:ConnectionProperties propertiesInit = {maximumPoolSize:5, connectionTimeout:300000, datasourceProperties:props};
    connInit = create sql:ClientConnector( sql:DB.MYSQL, mysqlHostName, mysqlPort, mysqlDatabase, mysqlUserName, mysqlPassword, propertiesInit);
    return;
}

