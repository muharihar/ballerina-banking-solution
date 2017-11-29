package org.abc.util;

import org.abc.db as dbOps;
import ballerina.net.http;
import ballerina.log;
import org.abc.error as bError;
import org.abc;

public function utilityBillPaymentRequest (int account, string billNo, string provider, float amount) (string response, error e) {

    float balance;
    error err;
    bError:BackendError bErr;
    boolean isValid;
    boolean isSuccess;
    int res;
    int res2;

    //validate the bill number
    isValid, e = validateBillNumber(billNo, provider);

    if (e != null) {
        log:printError("Error in UtilityBillPaymentRequest: " + e.msg);

    } else if (isValid) {
        //check if the balance is sufficient
        balance, err, bErr = getBalanceByAccountNumber(account);

        transaction {

            if (balance >= amount) {
                //if balance is sufficient, debit the bank and credit the service provider
                float updateBalance = balance - amount;

                res, err = dbOps:updateAccountBalanceByAccountNo(account, updateBalance);
                //println("accountUpdate " + res);

                isSuccess, e = updateBankOfSP(billNo, amount, provider);
                //println(isSuccess);

                if (res == 0 || err != null) {
                    abort;
                } else if (!isSuccess) {
                    abort;
                } else {
                    //if both requests successful, create a transaction record
                    log:printInfo("Debit and credit to the respective accounts are successful. Now creating a transaction record");
                    res2, err = dbOps:insertTransactions(amount, provider, 0, account, 1);

                    if (err == null) {
                        log:printInfo("Transaction record is created");
                        response = "Transaction is successful";
                    }
                    else {
                        abort;
                    }
                }

            } else {
                e = {msg:"Payment Declined: Insufficient funds in the account"};
            }

        } failed {
            retry 2;

        } aborted {
            log:printError("Transactionn Aborted");
            e = {msg:"Payment Declined: Transaction Aborted"};
        } committed {

        }
    } else {

        e = {msg:"Bill number is invalid"};

    }

    return response, e;
}

function validateBillNumber (string billNo, string provider) (boolean, error) {
    endpoint<http:HttpClient> epDialog {
        initDialog();
    }
    endpoint<http:HttpClient> epMobitel {
        initMobitel();
    }
    endpoint<http:HttpClient> epHSBC {
        initHSBC();
    }

    http:Request request = {};
    http:Response res = {};
    http:HttpConnectorError err;
    error msg;
    boolean isValid;
    TypeConversionError tErr;


    if (provider.equalsIgnoreCase("Dialog")) {

        res, err = epDialog.post("/validate/" + billNo, request);
        if ((error)err == null) {
            isValid, tErr = <boolean>res.getStringPayload();
            log:printInfo("Bill number is verified");
        } else {
            msg = {msg:"Error occurred while validating the bill number"};
        }

    } else if (provider.equalsIgnoreCase("Mobitel")) {

        res, err = epMobitel.post("/validate/" + billNo, request);
        if ((error)err == null) {
            isValid, tErr = <boolean>res.getStringPayload();
            log:printInfo("Bill number is verified");
        } else {
            msg = {msg:"Error occurred while validating the bill number"};
        }

    } else if (provider.equalsIgnoreCase("HSBC")) {

        res, err = epHSBC.post("/validate/" + billNo, request);
        if ((error)err == null) {
            isValid, tErr = <boolean>res.getStringPayload();
            log:printInfo("Bill number is verified");
        } else {
            msg = {msg:"Error occurred while validating the bill number"};
        }

    } else {
        msg = {msg:"Invalid Service Provider"};
    }


    return isValid, msg;

}


function updateBankOfSP (string billNo, float amount, string provider) (boolean, error) {
    endpoint<http:HttpClient> epBank {
        initBankOfDialog();
    }

    http:Request request = {};
    http:Response res = {};
    http:HttpConnectorError err;
    error msg;
    boolean isSuccess;
    TypeConversionError tErr;

    if (provider.equalsIgnoreCase("Dialog")) {

        res, err = epBank.post("/pay/" + billNo + "/" + amount, request);
        if ((error)err == null) {
            isSuccess, tErr = <boolean>res.getStringPayload();

            log:printInfo("Payment to the service providers' bank is successful");
        } else {
            msg = {msg:"Error occurred while making the payment"};
        }

    } else if (provider.equalsIgnoreCase("Mobitel")) {

        res, err = epBank.post("/pay/" + billNo + "/" + amount, request);
        if ((error)err == null) {
            isSuccess, tErr = <boolean>res.getStringPayload();
            log:printInfo("Payment to the service providers' bank is successful");
        } else {
            msg = {msg:"Error occurred while making the payment"};
        }

    } else if (provider.equalsIgnoreCase("HSBC")) {

        res, err = epBank.post("/pay/" + billNo + "/" + amount, request);
        if ((error)err == null) {
            isSuccess, tErr = <boolean>res.getStringPayload();
            log:printInfo("Payment to the service providers' bank is successful");
        } else {
            msg = {msg:"Error occurred while making the payment"};
        }

    } else {
        msg = {msg:"Invalid Service Provider"};
    }


    return isSuccess, msg;
}


function initDialog () (http:HttpClient ep) {
    string baseURL = "http://localhost:8080/RESTfulService/mock/validateBillService";
    ep = create http:HttpClient(baseURL, {});
    return;
}
function initMobitel () (http:HttpClient ep) {
    string baseURL = "http://localhost:8080/RESTfulService/mock/validateBillService";
    ep = create http:HttpClient(baseURL, {});
    return;
}
function initHSBC () (http:HttpClient ep) {
    string baseURL = "http://localhost:8080/RESTfulService/mock/validateBillService";
    ep = create http:HttpClient(baseURL, {});
    return;
}
function initBankOfDialog () (http:HttpClient ep) {
    string baseURL = "http://localhost:8080/RESTfulService/mock/bankService";
    ep = create http:HttpClient(baseURL, {endpointTimeout: 50, retryConfig:{count:3, interval:200}});
    return;
}