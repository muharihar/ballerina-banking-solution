package org.abc.util;

import ballerina.math;
import ballerina.log;

function generateOTP (int userid) (string generatedOTP) {
    int randomNo;

    randomNo = math:randomInRange(1001, 99999999);
    string ranNo = <string>randomNo;
    string uid = <string>userid;
    generatedOTP = ranNo + uid;
    return generatedOTP;
}
