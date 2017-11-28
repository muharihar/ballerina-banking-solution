package org.abc.util;

import org.abc.db as dbOps;

public function registerPayOrder (string payAmount, string day, string fromAcNo, string toAcNo, string freq) (error err) {
    float amount;
    int dayOfMonth;
    int fromAccNumber;
    int toAccNumber;
    int frequency;
    TypeConversionError tFromAccNo;
    TypeConversionError tToAccNo;
    TypeConversionError tAmount;
    TypeConversionError tDay;
    error tDayRange;
    error tMonthRange;

    fromAccNumber, tFromAccNo = <int>fromAcNo;
    toAccNumber, tToAccNo = <int>toAcNo;
    amount, tAmount = <float>payAmount;
    dayOfMonth, tDay = <int>day;
    if (freq.equalsIgnoreCase("monthly")) {
        frequency = 12;
        if (dayOfMonth > 28) {
            dayOfMonth = 0;
            tDayRange = {msg:"Payment day cannot be greater than 28th"};
        }
    }
    else if (freq.equalsIgnoreCase("quarterly")) {
        dayOfMonth = 0;
        frequency = 4;
    }
    else if (freq.equalsIgnoreCase("annually")) {
        dayOfMonth = 0;
        frequency = 1;
    }
    else {
        tMonthRange = {msg:"Not a valid frequency. Accepted monthly, quarterly and annually"};
    }
    if (tFromAccNo == null && tToAccNo == null && tAmount == null && tDay == null && tDayRange == null && tMonthRange == null) {
        err = dbOps:insertPayOrderToDb(amount, dayOfMonth, fromAccNumber, toAccNumber, frequency);
    }
    else {
        if (tFromAccNo != null) {
            err = (error)tFromAccNo;
        }
        else if (tToAccNo != null) {
            err = (error)tToAccNo;
        }
        else if (tAmount != null) {
            err = (error)tAmount;
        }
        else if (tDay != null) {
            err = (error)tDay;
        }
        else if (tDayRange != null) {
            err = tDayRange;
        }
        else if (tMonthRange != null) {
            err = tMonthRange;
        }
        else {
            err = {msg:"Unexpected error has occured."};
        }
    }
    return;
}