package org.abc.util;

import ballerina.util;
import org.abc.beans as beans;

public function generateOTP (int userid) (string generatedOTP) {
    if (userid > 0) {
        string ranNo = util:uuid();
        string uid = <string>userid;
        generatedOTP = ranNo + uid;
    }
    return generatedOTP;
}

public function checkTokenValidity (string tokenCreatedDate) (boolean validity) {
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
