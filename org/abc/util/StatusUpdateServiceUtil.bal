package org.abc.util;

import ballerina.log;


public function approveOrRejectAccounts (json batchStatuses) (string message) {
    // update the db and send an email based on the status of the account

    //sample request:  json batch = [{
    // "accountNo": "114565470",
    // "status": "Approved",
    // "email" : "dilinig@wso2.com"
    // },
    //{
    //"accountNo": "114565471",
    //"status": "Rejected",
    //"email" : "dilinig@wso2.com"
    //}
    //];


    fork {
        worker dbUpdater {

            int[] batchStat;
            error err;
            batchStat, err = updateAccountStatus(batchStatuses);
            batchStat, err -> fork;

        }

        worker emailSender {

            int len = lengthof batchStatuses;
            int i = 0;
            json res;
            error err;

            while (len > i) {

                var id1, _ = (string)batchStatuses[i].accountNo;
                var id, _ = <int>id1;
                var status, _ = (string)batchStatuses[i].status;
                var email, _ = (string)batchStatuses[i].email;

                string successMsg = "Your account has been successfully activated. Account Number is " + id;
                string rejectedMsg = "Your account creation request has been rejected by the bank";

                if (status.equalsIgnoreCase("Approved")) {
                    res, err = sendMail(email, "Account is Approved", successMsg);
                } else {
                    res, err = sendMail(email, "Account is Rejected", rejectedMsg);
                }

                i = i + 1;
            }

            res, err -> fork;


        }

    } join (all) (map results) {
        var resW1, _ = (any[])results["dbUpdater"];
        var batchRes, _ = (int[])resW1[0];
        var dbErr, _ = (string)resW1[1];
        var resW2, _ = (any[])results["emailSender"];
        var emailRes, _ = (json)resW2[0];
        var emailErr, _ = (string)resW1[1];


        if (dbErr != "") {
            log:printError("approveOrRejectAccounts: Error occurred in Batch status update");
            message = "Error occurred in Batch status update";
        } else if (emailErr != "" ){
            log:printInfo("approveOrRejectAccounts: Error occurred when sending emails");
            message = "Error occurred when sending emails";
        } else {
            log:printInfo("approveOrRejectAccounts: Batch status update and sending email operations completed successfully");
            message = "Batch status update and sending email operations completed successfully";
        }

    }

    return;
}

