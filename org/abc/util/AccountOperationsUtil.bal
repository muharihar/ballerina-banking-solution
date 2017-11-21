package org.abc.util;

import org.abc.db as dbOps;

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

