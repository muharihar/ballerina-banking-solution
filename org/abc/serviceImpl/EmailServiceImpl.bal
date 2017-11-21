package org.abc.serviceImpl;
import org.abc.connectors as conn;

public function sendMail (string sender, string subject, string body) (json res, error err) {
    endpoint<conn:GmailConnector> ep {
        create conn:GmailConnector();
    }

    var mailSent, ex = ep.sendMail(sender, subject, "dilinisg@gmail.com", body, "", "", "", "");

    if (ex == null) {
        res = mailSent;
    }
    else {
        err = (error)ex;
    }

    return;
}
