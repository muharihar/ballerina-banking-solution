package org.abc.util;

import ballerina.data.sql;
import ballerina.os;


public function init() (sql:ClientConnector connInit){
    string mysqlHostName = os:getEnv("MYSQL_HOSTNAME");
    var mysqlPort, _ = <int>os:getEnv("MYSQL_PORT");
    string mysqlDatabase = os:getEnv("MYSQL_DATABASE");
    string mysqlUserName = os:getEnv("MYSQL_USER");
    string mysqlPassword = os:getEnv("MYSQL_PASSWORD");

    sql:ConnectionProperties propertiesInit = {maximumPoolSize:5, connectionTimeout:300000};
    connInit = create sql:ClientConnector(
    sql:MYSQL, mysqlHostName, mysqlPort, mysqlDatabase, mysqlUserName, mysqlPassword, propertiesInit);
    return;
}

