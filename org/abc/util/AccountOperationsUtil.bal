package org.abc.util;

import ballerina.log;

function getOTPForUSer(string accNo)(string generatedOTP, error err){
    var accNo, error_accNo = <int>accNo;

    if(error_accNo!=null){
        log:printErrorCause("getOTPForUSer:error in obtaining Account Number:", error_accNo);
        err = {msg: "getOTPForUSer:error occured when evaluating payload"};
    }
    else{
        var userid, er = getUserID(accNo);
        if (er != null){
            log:printErrorCause("getOTPForUSer:error on obtaining userid", er);
            err = {msg: "getOTPForUSer:error occured when obtaining userid from database"};
        }
        else{
            generatedOTP = generateOTP(userid);
        }
    }
    return;

}