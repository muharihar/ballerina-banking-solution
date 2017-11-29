package org.abc.db;

import ballerina.data.sql;
import ballerina.config;

public sql:ClientConnector sqlCon = initDb();

function initDb() (sql:ClientConnector connInit){
    //string mysqlHostName = "192.168.48.209";
    //int mysqlPort = 3306;
    //string mysqlDatabase = "Bank";
    //string mysqlUserName = "root";
    //string mysqlPassword = "root";
    string mysqlHostName = config:getGlobalValue("database.host");
    var mysqlPort, _ = <int>config:getGlobalValue("database.port");
    string mysqlDatabase = config:getGlobalValue("database.name");
    string mysqlUserName = config:getGlobalValue("database.username");
    string mysqlPassword = config:getGlobalValue("database.password");
    map props = {verifyServerCertificate:false,useSSL:false};
 
    sql:ConnectionProperties propertiesInit = {maximumPoolSize:5, connectionTimeout:300000, datasourceProperties:props};
    connInit = create sql:ClientConnector( sql:DB.MYSQL, mysqlHostName, mysqlPort, mysqlDatabase, mysqlUserName, mysqlPassword, propertiesInit);
    return;
}

