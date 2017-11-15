package org.abc.util;

import ballerina.util;
import org.abc.beans as beans;
import ballerina.math;
import ballerina.log;
import ballerina.task;

int count;

function generateOTP (int userid) (string generatedOTP) {
    if (userid > 0) {
        string ranNo = util:uuid();
        string uid = <string>userid;
        generatedOTP = ranNo + uid;
    }
    return generatedOTP;
}

function checkTokenValidity (string tokenCreatedDate) (boolean validity) {
    Time createdDate = parse(tokenCreatedDate, "yyyy-MM-dd'T'HH:mm:ss.SSSXXX");
    Time currentDate = currentTime();
    int createdDate_inMiliSec = createdDate.time;
    int currentTime_inMiliSec = currentDate.time;
    int difference = currentTime_inMiliSec - createdDate_inMiliSec;
    if (difference > 86400000) {
        validity = false;
    }
    else {
        validity = true;
    }
    return;

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


public function scheduledTaskAppointment(){

    //int app1Count;
    string appTid;
    function () returns (error) onTriggerFunction;
    function (error e) onErrorFunction;
    onTriggerFunction = cleanupOTP;
    onErrorFunction = cleanupError;
    appTid, _ = task:scheduleAppointment(onTriggerFunction, onErrorFunction, "0/40 * * * * ?");

}


function cleanupError(error e) {
    print("[ERROR] OTP cleanup failed");
    println(e);
}

