package org.abc.util;

import ballerina.math;
import ballerina.log;
import ballerina.task;

int count;

function generateOTP (int userid) (string generatedOTP) {
    int randomNo;

    randomNo = math:randomInRange(1001, 99999999);
    string ranNo = <string>randomNo;
    string uid = <string>userid;
    generatedOTP = ranNo + uid;
    return generatedOTP;
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

