import org.abc.db as dboperations;
import org.abc.error;
import ballerina.net.http;

function checkTokenValidity(http:Request req,string token)(json msg,http:Session sesn) {
  
  int userID = dboperations:isTokenValid(token);
  // If token is valid then create a session and return the session
  if (userID == 1) {
      sessn =  req.createSessionIfAbsent();
      sessn.setAttribute("RH", "RH02");
  } else {
      throw e;
  }
  json re = {userid:userID};
  return re;
}

