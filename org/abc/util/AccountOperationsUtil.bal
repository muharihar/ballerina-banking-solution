package org.abc.util;

import org.abc.db as dbOps;
import org.abc;

public function getAccountBalanceByAccNumber (string accNo) {
    //Following converts the string input to int
    var accNumber, error_accNo = <int>accNo;
    return;
}

public function getAccountHistoryUtil (json payload) (json data, error e) {
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
    return;
}

public function getAccountHistoryByAccNo (int accNo) (json data, error e) {
    int[] accNos = [];
    accNos[0] = accNo;
    println(accNo);
    data, e = dbOps:getTransactionHistoryDb(accNos);
    return;
}


public function getAccountInfoList (int userId) (json j, error e) {
    j, e = dbOps:getAccoutsByUserID(userId);
    if (e == null) {
        int l = lengthof j;
        int i = 0;
        while (i < l) {
            var status, err = (int)j[i].account_status;
            if (abc:ACC_STATUS_APPROVAL_PENDING == status) {
                j[i].account_status = "PENDING";
            } else if (abc:ACC_STATUS_ACTIVE == status) {
                j[i].account_status = "ACTIVE";
            } else if (abc:ACC_STATUS_INACTIVE == status) {
                j[i].account_status = "INACTIVE";
            } else if (abc:ACC_STATUS_BLOCKED == status) {
                j[i].account_status = "BLOCKED";
            }
            i = i + 1;
        }
    }
    return;
}
