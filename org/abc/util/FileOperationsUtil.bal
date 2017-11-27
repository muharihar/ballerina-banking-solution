
package org.abc.util;
import ballerina.file;
import ballerina.log;
import ballerina.io;
import org.abc as cons;
import ballerina.util;
import org.abc.db as dbOps;


string[] acceptedContentTypes = ["application/pdf","text/csv","text/plain","application/msword","multipart/form-data","image/jpeg"];

public function checkContentType(string contentType) (boolean) {
    int arrayLength = lengthof acceptedContentTypes;
    int i = 0;
    boolean status;
    while (i < arrayLength) {
        if (acceptedContentTypes[i].equalsIgnoreCase(contentType)) {
            status = true;
            break;
        }
        i = i + 1;
    }
    return status;
}

public function writeToFile(blob content,string contentType,string userid) (error err) {
    //endpoint<ftp:FTPClient> fileEp { create ftp:FTPClient();}
    string extension;
    //string pathToFile = "ftp://kieth:keith123@10.100.5.128:21/testDir/file";
    string pathToFile = "/home/erandi/Documents/Ballerina/connector-file/filelocation/";
    if (contentType.equalsIgnoreCase("application/pdf")) {
        extension = cons:TYPE_PDF;
    } else if (contentType.equalsIgnoreCase("text/csv")) {
        extension = cons:TYPE_CSV;
    } else if (contentType.equalsIgnoreCase("text/plain")) {
        extension = cons:TYPE_TEXT;
    } else if (contentType.equalsIgnoreCase("application/msword")) {
        extension = cons:TYPE_DOC;
    } else if (contentType.equalsIgnoreCase("multipart/form-data")) {
        extension = cons:TYPE_PDF;
    } else if (contentType.equalsIgnoreCase("image/jpeg")) {
        extension = cons:TYPE_JPG;
    } else {
        extension = "not found";
    }
    pathToFile = pathToFile + userid + extension;
    println(pathToFile);
    file:File newFile = {path:pathToFile};
    println(newFile.path);
    
    try {
        println("a");
        //fileEp.createFile(newFile, false);
        var result,eA,eIO = newFile.createNewFile();
        if (eA == null && eIO == null) {
            io:ByteChannel channel = newFile.openChannel("w");
            //file:File newFileR = {path:"/home/erandi/Documents/Ballerina/connector-file/filelocation/test/Sample-dco.doc"};
            //io:ByteChannel channelR = newFileR.openChannel("r");
            //var bytes,numberOfBytesRead = channelR.readBytes(30000);
            //println(numberOfBytesRead);
            int numberOfBytesWritten = channel.writeBytes(content,0);
            println(numberOfBytesWritten);
        }
        println(result);
        println("b");
        //fileEp.write(content, newFile);
    }
    catch(error ex) {
        println("d");
        log:printErrorCause("error log with cause",ex);
        err = ex;
        println(err.msg);
    }finally {
    }
    return ;
}
public function encryptBlobContent(blob toEncrypt) (blob encrypted,error e) {
    string blobContent;
    try {
        blobContent = toEncrypt.toString("UTF-8");
        string encodedString = util:base64Encode(blobContent);
        encrypted = encodedString.toBlob("UTF-8");
    }
    catch(error err) {
        e = err;
    }
    return ;
}
function decryptBlobContent(blob toDecrypt) (blob decrypted,error e) {
    string blobContent;
    try {
        blobContent = toDecrypt.toString("UTF-8");
        string decodedString = util:base64Decode(blobContent);
        decrypted = decodedString.toBlob("UTF-8");
    }
    catch(error err) {
        e = err;
    }
    return ;
}
function readFromFile(string filename)(blob, error) {
    blob content;
    error eb;
    string pathToFile = "/home/erandi/Documents/Ballerina/connector-file/filelocation/";
    pathToFile = pathToFile + filename;
    
    file:File readFile = {path:pathToFile};
    boolean isExist = readFile.exists();
    if (isExist){
        io:ByteChannel channel = readFile.openChannel("r");
        var bytes,numberOfBytesRead = channel.readBytes(3000000);
        println(numberOfBytesRead);
    }
    return content, eb;
}


public function writeToCSV (int[] accNo) {
    //TODO - write to csv and pdf
    json payload;
    error e;
    payload, e = dbOps:getTransactionHistoryDb(accNo);
    string textdb = payload.toString();
    string text = "my name is dilini";
    io:CharacterChannel destinationChannel = getFileCharacterChannel("./sampleResponse.pdf", "w", "UTF-8");
    var var1 = destinationChannel.writeCharacters(text,0);
}

function getFileCharacterChannel (string filePath, string permission, string encoding)
(io:CharacterChannel) {
    file:File src = {path:filePath};
    io:ByteChannel channel = src.openChannel(permission);
    io:CharacterChannel characterChannel = channel.toCharacterChannel(encoding);
    return characterChannel;
}


public function writeToPDF (int[] accNo) {

    json payload;
    error e;
    payload, e = dbOps:getTransactionHistoryDb(accNo);
    string textdb = payload.toString();
    string text = "my name is dilini";
    blob content = text.toBlob("UTF-8");
    io:ByteChannel destinationChannel = getFileByteChannel("./sampleResponse.pdf", "w", "UTF-8");
    var var1 = destinationChannel.writeBytes(content, 0);
}

function getFileByteChannel (string filePath, string permission, string encoding)
(io:ByteChannel) {
    file:File src = {path:filePath};
    io:ByteChannel channel = src.openChannel(permission);
    return channel;
}