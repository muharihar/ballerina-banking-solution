package tests;

import org.abc.util as utils;
import ballerina.test;

function testGenerateOTP_positiveInteger () {
    string returnValue = utils:generateOTP(500);
    test:assertTrue((!returnValue.equalsIgnoreCase("") && returnValue.contains("500")), "Assert failure.");
}

function testGenerateOTP_negativeInteger () {
    string returnValue = utils:generateOTP(-500);
    test:assertTrue(returnValue.equalsIgnoreCase(""), "Assert failure.");
}

function testGenerateOTP_zero () {
    string returnValue = utils:generateOTP(0);
    test:assertTrue(returnValue.equalsIgnoreCase(""), "Assert failure.");
}

function testCheckTokenValidity_within24Hours(){
    Time time = currentTime();
    Time subsTime = time.subtractDuration(0,0,0,5,0,0,0);
    string createdDate = subsTime.toString();
    boolean result = utils:checkTokenValidity(createdDate);
    test:assertBooleanEquals(result, true, "Assert failure.");
}

function testCheckTokenValidity_pastDate(){
    Time time = currentTime();
    Time subsTime = time.subtractDuration(0,0,5,5,0,0,0);
    string createdDate = subsTime.toString();
    boolean result = utils:checkTokenValidity(createdDate);
    test:assertBooleanEquals(result, false, "Assert failure.");
}



