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

public function listPayOrders()(json, error){
    json list;
    error er;
    list, er = dbOps:listPayOrders();
    return list, er;
}


public function payOderScheduleMonthlyTaskTimer () (error err) {
    string appTid;

    //runs every day at 01:00
    string cron = "	0 15 12 1/1 * ? *";
    function () returns (error) onTriggerFunction;
    function (error) onErrorFunction;
    onTriggerFunction = dbOps:executeMonthlyPayOrder;
    onErrorFunction = payOrderError;

    try {
        appTid, _ = task:scheduleAppointment(onTriggerFunction, onErrorFunction, cron);
        println("Success");
    } catch (error e) {
        log:printErrorCause("Scheduled Task Appointment failure", e);
        err = e;

    }
    return;
}

public function payOderScheduleQuartleyTaskTimer () (error err) {
    string appTid;

    //runs every first day once in 3 months
    string cron = "0 0 12 1 1/3 ? *";
    function () returns (error) onTriggerFunction;
    function (error) onErrorFunction;
    onTriggerFunction = dbOps:executeQuartelyPayOrder;
    onErrorFunction = payOrderError;

    try {
        appTid, _ = task:scheduleAppointment(onTriggerFunction, onErrorFunction, cron);
        println("Success");
    } catch (error e) {
        log:printErrorCause("Scheduled Task Appointment failure", e);
        err = e;

    }
    return;
}

public function payOderScheduleYearlyTaskTimer() (error err) {
    string appTid;

    //runs every first day of every year
    string cron = "	0 0 12 1 1 ? *";
    function () returns (error) onTriggerFunction;
    function (error) onErrorFunction;
    onTriggerFunction = dbOps:executeYearlyPayOrder;
    onErrorFunction = payOrderError;

    try {
        appTid, _ = task:scheduleAppointment(onTriggerFunction, onErrorFunction, cron);
        println("Success");
    } catch (error e) {
        log:printErrorCause("Scheduled Task Appointment failure", e);
        err = e;

    }
    return;
}

function payOrderError(error e) {
    print("[ERROR] Pay Order Execution failed");
    println(e);
}