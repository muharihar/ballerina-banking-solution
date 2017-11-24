package org.abc.util;

import org.abc.db as dbOps;
import ballerina.io;
import ballerina.file;

public function getAccountBalanceByAccNumber (string accNo) {
    //Following converts the string input to int
    var accNumber, error_accNo = <int>accNo;
    return;
}

public function getAccountHistoryUtil (json payload
) (json data, error e) {
    int lengthOfJson;
    int i = 0;
    lengthOfJson = lengthof payload;
    int[] accNos = [];
    TypeConversionError ex;
    while (i < lengthOfJson) {
        json j = payload[i].acc_no;
        var accN = payload[i].acc_no.toString();
        accNos[i], ex = <int>accN;
        i = i + 1;
    }
    data, e = dbOps:getTransactionHistoryDb(accNos);
    return; }


public function writeToCSV (int[] accNo) {

    json payload;
    error e;
    payload, e = dbOps:getTransactionHistoryDb(accNo);
    string textdb = payload.toString();
    string[] text = ["my name is dilini"];
    // blob content = text.toBlob("UTF-16");
    io:TextRecordChannel destinationChannel = getFileCharacterChannel("./sampleResponse.pdf", "w", "UTF-8");
    //io:ByteChannel destinationChannel = getFileCharacterChannel("./sampleResponse.pdf", "w", "UTF-8");
    var var1 = destinationChannel.writeTextRecord(text);
    println("ssddddwww" + var1);
}

function getFileCharacterChannel (string filePath, string permission, string encoding)
(io:CharacterChannel) {
    file:File src = {path:filePath};
    io:ByteChannel channel = src.openChannel(permission);
    io:CharacterChannel characterChannel = channel.toCharacterChannel(encoding);
    return characterChannel;
   // return channel;
}


public function writeToPDF (int[] accNo) {

    json payload;
    error e;
    payload, e = dbOps:getTransactionHistoryDb(accNo);
    string textdb = payload.toString();
    string text = "my name is dilini";
    blob content = text.toBlob("UTF-8");
    //io:CharacterChannel destinationChannel = getFileCharacterChannel("./sampleResponse.pdf", "w", "UTF-8");
    io:ByteChannel destinationChannel = getFileCharacterChannel("./sampleResponse.pdf", "w", "UTF-8");
    var var1 = destinationChannel.writeBytes(content, 0);
    println("ssddddwww" + var1);
}