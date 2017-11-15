package tests;

import org.abc.util as utils;
import ballerina.test;

function testscheduledTaskAppointment_ValidCron () {
    string returnValue = utils:scheduledTaskAppointment("0/20 * * * * ?");
    test:assertStringEquals(returnValue,"Success","Assert Failure");
    println("testscheduledTaskAppointment_ValidCron completed \n");
}

function testscheduledTaskAppointment_invalidCron () {
    //COMMENTED TO DUE A BUG IN TESTARINA
    //string returnValue = utils:scheduledTaskAppointment("");
    //test:assertStringEquals(returnValue,"CronExpression '' is invalid.", "Assert Failure");
    //println("testscheduledTaskAppointment_invalidCron completed");

}