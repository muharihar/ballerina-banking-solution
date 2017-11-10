package org.abc.util;

import ballerina.log;

public function getOTPForUSer (string accNo) (string generatedOTP, error err) {
    var accNumber, error_accNo = <int>accNo;
    string status;

    if (error_accNo != null) {
        error er_accNo = (error)error_accNo;
        log:printErrorCause("getOTPForUSer:error in obtaining Account Number:", er_accNo);
        err = {msg:"getOTPForUSer:error occured when evaluating payload"};
    }
    else {
        var userid, er = getUserID(accNumber);
        if (er != null) {
            log:printErrorCause("getOTPForUSer:error on obtaining userid", er);
            err = {msg:"getOTPForUSer:error occured when obtaining userid from database"};
        }
        else {
            var tokenExist, createdDate, otpid, et = checkTokenExistance(userid);
            println("a" + createdDate);
            if (et != null) {
                log:printErrorCause("getOTPForUSer:error on obtaining details on token details", et);
                err = {msg:"getOTPForUSer:error occured when obtaining token details from database"};
            }
            else {
                if (tokenExist) {
                    boolean tokenValidity = checkTokenValidity(createdDate);
                    if (tokenValidity) {
                        err = {msg:"getOTPForUSer:otp still active for user"};
                    }
                    else{
                        generatedOTP = generateOTP(userid);
                        insertGenToken(userid, generatedOTP);
                    }
                }
                else {
                    generatedOTP = generateOTP(userid);
                    insertGenToken(userid, generatedOTP);
                }
            }
        }
    }
    return;

}