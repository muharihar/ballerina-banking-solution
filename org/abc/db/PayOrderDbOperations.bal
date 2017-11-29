package org.abc.db;
import ballerina.data.sql;
import ballerina.log;

public function insertPayOrderToDb (float transAmount, int transDay, int fromAccNo, int toAccNo, int frequency) (error er) {
    endpoint<sql:ClientConnector> ep {}
    bind sqlCon with ep;

    sql:Parameter[] parameters = [];
    string payOrder_Insert_Query = "INSERT INTO Pay_Orders (`transaction_amount`, `transaction_date`, `acc_number`, `to_acc_number`, `frequency`) VALUES (?, ?, ?, ?, ?);
";
    try {
        sql:Parameter paraTransAmount = {sqlType:sql:Type.FLOAT, value:transAmount, direction:sql:Direction.IN};
        sql:Parameter paraTransDay = {sqlType:sql:Type.INTEGER, value:transDay, direction:sql:Direction.IN};
        sql:Parameter paraFromAccNo = {sqlType:sql:Type.INTEGER, value:fromAccNo, direction:sql:Direction.IN};
        sql:Parameter paraToAccNo = {sqlType:sql:Type.INTEGER, value:toAccNo, direction:sql:Direction.IN};
        sql:Parameter paraFrequency = {sqlType:sql:Type.INTEGER, value:frequency, direction:sql:Direction.IN};
        parameters = [paraTransAmount, paraTransDay, paraFromAccNo, paraToAccNo, paraFrequency];
        int i = ep.update(payOrder_Insert_Query, parameters);
        if (i == 1) {
            er = {msg:"Pay order registered."};
        }
        else {
            er = {msg:"Pay order not registered."};
        }
    } catch (error e) {
        er = e;
    }
    return;
}

public function executeMonthlyPayOrder () (error err) {
    endpoint<sql:ClientConnector> ep {}
    bind sqlCon with ep;

    sql:Parameter[] parameters = [];
    string selectMonthlyPayOrders = "SELECT * from Pay_Orders WHERE frequency=12";
    string updateAccount = "UPDATE Account SET current_balance=? WHERE acc_number=?";
    string updateTransactions = "INSERT INTO Transactions (transaction_id, transaction_amount, transaction_date, pay_order_id, acc_number, currency_id) VALUES (?,?,?,?,?,1)";

    TypeConversionError eM;
    json monthlyData;
    Time time = currentTime();
    int day = time.day();
    int updatedRowCount_debit;
    int updatedRowCount_credit;

    try {
        datatable dt = ep.select(selectMonthlyPayOrders, parameters);
        monthlyData, eM = <json>dt;
        int length = lengthof monthlyData;
        int i = 0;

        while (i < length) {
            var dateInDb, _ = (int)monthlyData[i].transaction_date;
            if (day == dateInDb) {
                transaction {
                    var payableAmount, _ = (float)monthlyData[i].transaction_amount;
                    var fromAcc, _ = (int)monthlyData[i].acc_number;
                    var toAcc, _ = (int)monthlyData[i].to_acc_number;
                    var currentBalanceFromAcc, ec = getAccountBalance(fromAcc);
                    if (ec == null) {
                        if (currentBalanceFromAcc > payableAmount){
                            float newBalFrom = currentBalanceFromAcc - payableAmount;
                            sql:Parameter paraAccBalFrom = {sqlType:sql:Type.FLOAT, value:newBalFrom, direction:sql:Direction.IN};
                            sql:Parameter paraFromAcc = {sqlType:sql:Type.INTEGER, value:fromAcc, direction:sql:Direction.IN};
                            parameters = [paraAccBalFrom, paraFromAcc];
                            updatedRowCount_credit = ep.update(updateAccount, parameters);
                             }
                        else{
                            abort;
                        }

                    }
                    else {
                        err = ec;
                        log:printErrorCause("Error at getting acc balance", err);
                    }
                    var currentBalanceToAcc, et = getAccountBalance(toAcc);
                    if (et == null) {
                        parameters = [];
                        float newBalTo = currentBalanceToAcc + payableAmount;
                        sql:Parameter paraAccBalTo = {sqlType:sql:Type.FLOAT, value:newBalTo, direction:sql:Direction.IN};
                        sql:Parameter paraToAcc = {sqlType:sql:Type.INTEGER, value:toAcc, direction:sql:Direction.IN};
                        parameters = [paraAccBalTo, paraToAcc];
                        updatedRowCount_debit = ep.update(updateAccount, parameters);
                    }
                    else {
                        err = et;
                        log:printErrorCause("Error at getting acc balance: to Account", err);
                    }
                    if (updatedRowCount_credit != 1 && updatedRowCount_debit != 1) {
                        abort;
                    }
                    else{
                        var maxTransactionID, mErr = getLatestTransactionID();
                        if(mErr == null){
                                parameters = [];

                                var payorderid, _ = (int)monthlyData[i].pay_order_id;
                                sql:Parameter paraTransId = {sqlType:sql:Type.INTEGER, value:maxTransactionID+1, direction:sql:Direction.IN};
                                sql:Parameter paraTransaAmount = {sqlType:sql:Type.FLOAT, value:payableAmount, direction:sql:Direction.IN};
                                sql:Parameter paraTransDate = {sqlType:sql:Type.TIMESTAMP, value:time, direction:sql:Direction.IN};
                                sql:Parameter paraTransPayOrderId = {sqlType:sql:Type.INTEGER, value:payorderid, direction:sql:Direction.IN};
                                sql:Parameter paraAccNo = {sqlType:sql:Type.INTEGER, value:fromAcc, direction:sql:Direction.IN};
                                parameters = [paraTransId, paraTransaAmount, paraTransDate, paraTransPayOrderId, paraAccNo];
                                int insertedRowCount = ep.update(updateTransactions, parameters);
                                if (insertedRowCount != 1){
                                         abort;
                                     }

                            }
                        else{
                            err = mErr;
                            log:printErrorCause("Error getting max transaction id", err);
                        }
                    }

                } failed {
                    retry 3;

                } aborted {
                    log:printInfo("Transaction aborted");

                } committed {
                    log:printInfo("Transaction committed");
                }
            }
            i = i+1;
        }


    } catch (error e) {
        err = e;
    }
    return;
}

function getAccountBalance (int accNo) (float availableBalance, error err) {
    endpoint<sql:ClientConnector> ep {}
    bind sqlCon with ep;

    sql:Parameter[] parameters = [];
    string selectAccBalance = "SELECT current_balance FROM Account WHERE acc_number=?";
    TypeCastError eb;
    try {
        sql:Parameter paraAccNo = {sqlType:sql:Type.INTEGER, value:accNo, direction:sql:Direction.IN};
        parameters = [paraAccNo];
        datatable dt = ep.select(selectAccBalance, parameters);
        var data, em = <json>dt;
        println(data);
        if (em == null) {
            availableBalance, eb = (float)data[0].current_balance;
        }
        else {
            err = (error)em;
        }
    } catch (error e) {
        err = e;
    }
    return;
}

function getLatestTransactionID () (int transactionId, error err) {
    endpoint<sql:ClientConnector> ep {}
    bind sqlCon with ep;

    sql:Parameter[] parameters = [];
    string selectMaxId = "SELECT MAX(transaction_id) AS latest_trans_id FROM Transactions";
    TypeCastError eb;
     try {
        datatable dt = ep.select(selectMaxId, parameters);
        var data, em = <json>dt;
        if (em == null) {
            transactionId, eb = (int)data[0].latest_trans_id;
        }
        else {
            err = (error)em;
        }
    } catch (error e) {
        err = e;
    }
    return;
}
