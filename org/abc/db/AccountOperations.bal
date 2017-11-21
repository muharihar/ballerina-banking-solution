package org.abc.db;
import ballerina.data.sql;


public function getTransactionHistoryDb (int[] accNo) (json data, error er) {
    endpoint <sql:ClientConnector> ep{
        initDb();}

    sql:Parameter[] parameters = [];
    TypeConversionError eb;
    string transaction_history = "select transaction_date as Transaction_Date, transaction_amount as Amount_Transferred, (select utlity_provider_name from Utility_Provider WHERE Transactions.utility_provider_id = Utility_Provider.utility_provider_id) as Utility_Provider_Name, (select to_acc_number from Pay_Orders WHERE Transactions.pay_order_id = Pay_Orders.pay_order_id) as Beneficiary_Acc_No, acc_number as From_Account_No, (select currency_name from Currency WHERE Transactions.currency_id = Currency.currency_id) as Currency from Transactions where acc_number in (?)";
    try {
        sql:Parameter para1 = {sqlType:"integer", value:accNo, direction:0};
        parameters = [para1];
        datatable dt = ep.select(transaction_history, parameters);
        data, eb = <json>dt;
    } catch (error e) {
        er = e;
    }
    return;
}