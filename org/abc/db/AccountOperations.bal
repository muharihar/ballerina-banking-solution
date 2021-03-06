package org.abc.db;
import ballerina.data.sql;
import org.abc as cons;


public function getTransactionHistoryDb (int[] accNo) (json data, error er) {
    endpoint<sql:ClientConnector> ep {}
    bind sqlCon with ep;

    sql:Parameter[] parameters = [];
    TypeConversionError eb;
    string transaction_history = "select transaction_date as Transaction_Date, transaction_amount as Amount_Transferred, (select utlity_provider_name from Utility_Provider WHERE Transactions.utility_provider_id = Utility_Provider.utility_provider_id) as Utility_Provider_Name, (select to_acc_number from Pay_Orders WHERE Transactions.pay_order_id = Pay_Orders.pay_order_id) as Beneficiary_Acc_No, acc_number as From_Account_No, (select currency_name from Currency WHERE Transactions.currency_id = Currency.currency_id) as Currency from Transactions where acc_number in (?)";
    try {
        sql:Parameter para1 = {sqlType:sql:Type.INTEGER, value:accNo, direction:sql:Direction.IN};
        parameters = [para1];
        datatable dt = ep.select(transaction_history, parameters);
        data, eb = <json>dt;
    } catch (error e) {
        er = e;
    }
    return;
}

public function getAccoutsByUserID (int userId) (json data, error er) {
    endpoint<sql:ClientConnector> ep {}
    bind sqlCon with ep;

    sql:Parameter[] parameters = [];
    TypeConversionError eb;
    string accountList = "SELECT Account.acc_number, Account.created_date, Account_Type.account_name, Account_Type.interest_rate, Account.account_status, Account.current_balance FROM Account inner join Account_Type on Account.account_type_id = Account_Type.account_type_id where Account.user_id = ?;";
    try {
        sql:Parameter para1 = {sqlType:sql:Type.INTEGER, value:userId, direction:sql:Direction.IN};
        parameters = [para1];
        datatable dt = ep.select(accountList, parameters);
        data, eb = <json>dt;
    } catch (error e) {
        er = e;
    }
    return;
}

public function updateAccountBalanceByAccountNo (int accountNo, float balance) (int result, error er) {
    endpoint<sql:ClientConnector> ep {}
    bind sqlCon with ep;

    sql:Parameter[] parameters = [];

    string updateBalance = "UPDATE Account SET current_balance=? WHERE acc_number=?";
    try {
        sql:Parameter para1 = {sqlType:sql:Type.FLOAT, value:balance, direction:sql:Direction.IN};
        sql:Parameter para2 = {sqlType:sql:Type.INTEGER, value:accountNo, direction:sql:Direction.IN};
        parameters = [para1, para2];
        result = ep.update(updateBalance, parameters);
    } catch (error e) {
        er = e;
    }
    return;
}

public function insertTransactions (float amount, string provider, int payOrder, int accountNo, int currency) (int result, error er) {
    endpoint<sql:ClientConnector> ep {}
    bind sqlCon with ep;

    sql:Parameter[] parameters = [];
    int providerID;

    if (provider.equalsIgnoreCase("Dialog")) {
        providerID = cons:UTILITY_DIALOG;
    } else if (provider.equalsIgnoreCase("Mobitel")) {
        providerID = cons:UTILITY_MOBITEL;
    } else if (provider.equalsIgnoreCase("HSBC")) {
        providerID = cons:UTILITY_HSBC;
    } else {
        providerID = cons:UTILITY_OTHER;
    }

    Time time = currentTime();

    string insertTrans = "INSERT into Transactions (transaction_amount,transaction_date,utility_provider_id,pay_order_id,acc_number,currency_id) VALUES (?,?,?,?,?,?)";
    try {
        sql:Parameter para1 = {sqlType:sql:Type.FLOAT, value:amount, direction:sql:Direction.IN};
        sql:Parameter para2 = {sqlType:sql:Type.TIMESTAMP, value:time, direction:sql:Direction.IN};
        sql:Parameter para3 = {sqlType:sql:Type.INTEGER, value:providerID, direction:sql:Direction.IN};
        sql:Parameter para4 = {sqlType:sql:Type.INTEGER, value:payOrder, direction:sql:Direction.IN};
        sql:Parameter para5 = {sqlType:sql:Type.INTEGER, value:accountNo, direction:sql:Direction.IN};
        sql:Parameter para6 = {sqlType:sql:Type.INTEGER, value:currency, direction:sql:Direction.IN};

        parameters = [para1, para2, para3, para4, para5, para6];

        result = ep.update(insertTrans, parameters);

    } catch (error e) {
        er = e;
    }
    return;

}