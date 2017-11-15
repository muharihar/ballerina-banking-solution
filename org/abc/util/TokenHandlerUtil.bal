package org.abc.util;

import ballerina.log;

public function getOTPForUSer (string accNo) (string generatedOTP, string userID,  error err) {
    //Following converts the string input to int
    var accNumber, error_accNo = <int>accNo;

    //Checks whether an error has resulted in the above conversion.
    if (error_accNo != null) {
        error er_accNo = (error)error_accNo;
        log:printErrorCause("getOTPForUSer:error in obtaining Account Number:", er_accNo);
        err = {msg:"getOTPForUSer:error occured when evaluating payload"};
    }
    else {
        //Calls the function that retrieves user id for a given account number
        var userid, er = getUserID(accNumber);
        if (er != null) {
            log:printErrorCause("getOTPForUSer:error on obtaining userid", er);
            err = {msg:"getOTPForUSer:error occured when obtaining userid from database"};
        }
        else {
            //Checks token existance from database, at the same time returns the created date of token if exists
            var tokenExist, createdDate, et = checkTokenExistance(userid);
            if (et != null) {
                log:printErrorCause("getOTPForUSer:error on obtaining details on token details", et);
                err = {msg:"getOTPForUSer:error occured when obtaining token details from database"};
            }
            else {
                if (tokenExist) {
                    //Checks the token validity if exists
                    boolean tokenValidity = checkTokenValidity(createdDate);
                    if (tokenValidity) {
                        err = {msg:"getOTPForUSer:otp still active for user"};
                    }
                    else {
                        //Generates token if expired and inserts to database
                        generatedOTP = generateOTP(userid);
                        insertGenToken(userid, generatedOTP);
                    }
                }
                else {
                    //Generates token if token does not exist
                    generatedOTP = generateOTP(userid);
                    insertGenToken(userid, generatedOTP);
                    userID = <string>userid;
                }
            }
        }
    }
    return;
}

function main(string[] args) {
   var a,b,c = getOTPForUSer("114565473");
    println(a);
    println(b);
    println(c);
}


public function scheduledTaskTimer(){

    function () returns (error) onTriggerFunction = cleanupOTP;
    function (error e) onErrorFunction = cleanupError;
    var taskId, schedulerError = task:scheduleTimer(onTriggerFunction,
                                                    onErrorFunction, {delay:500, interval:60000});
    if (schedulerError != null) {
        println("Timer scheduling failed: " + schedulerError.msg) ;
    } else {
        println("Task ID:" + taskId);
    }

}


public function scheduledTaskAppointment (string cron) (string msg) {

    string appTid;

    //runs every 40 seconds
    //string cron = "0/40 * * * * ?";
    function () returns (error) onTriggerFunction;
    function (error) onErrorFunction;
    onTriggerFunction = cleanupOTP;
    onErrorFunction = cleanupError;

    try{
        appTid, _ = task:scheduleAppointment(onTriggerFunction, onErrorFunction, cron);
        msg = "Success";
    }catch(error e){
        log:printErrorCause("Scheduled Task Appointment failure", e);
        msg = "Fail";
        println(e.msg);
    }
    return;
}


function cleanupError(error e) {
    print("[ERROR] OTP cleanup failed");
    println(e);
}

