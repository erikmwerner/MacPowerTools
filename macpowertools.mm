#include "macpowertools.h"
#include <Foundation/Foundation.h> // App Nap API
#import <IOKit/pwr_mgt/IOPMLib.h> // Power Management System API

static id activity; //< keeps track of the activity ID for App Nap control
static IOPMAssertionID assertionID; //< keeps track of the assertion ID for sleep control

/*!
 * \brief disableAppNap begins a latency-critcal activity that prevents
 * App Nap from using timer coalescing on this program.
 * \param reason_string a description of the activity preventing App Nap.
 * This string is used for debugging.
 */
void disableAppNap(const QString reason_string) {
    NSString* nss = [[NSString alloc] initWithUTF8String:reason_string.toUtf8().data()];
    activity = [[NSProcessInfo processInfo] beginActivityWithOptions:NSActivityLatencyCritical | NSActivityUserInitiated
                                                              reason:nss];
}

/*!
 * \brief enableAppNap ends the activity preventing App Nap
 */
void enableAppNap() {
    [[NSProcessInfo processInfo] endActivity:activity];
}

/*!
 * \brief preventSleep sends a request to the power management system
 * to prevent the system from sleeping when idle
 * \param assert_type the assertion type to request from the power management system
 * Use "PreventUserIdleSystemSleep" to prevent system sleep, but allow display sleeping.
 * Use "PreventUserIdleDisplaySleep" to prevent both system and display sleeping (this is the default)
 * \param reason_string a string describing the activity preventing sleep. Max length is 128 characters
 * \return true if the assertion was successfully activated
 */
bool preventSleep(const QString assert_type, const QString reason_string){
    CFStringRef reason_c = reason_string.toCFString();
    CFStringRef assertion_c = assert_type.toCFString();
    IOReturn success = IOPMAssertionCreateWithName(assertion_c,
                                kIOPMAssertionLevelOn, reason_c, &assertionID);
    if (success == kIOReturnSuccess){
        return true;
    } else {
        return false;
    }
}

/*!
 * \brief allowSleep
 * \return true if the assertion was successfully released
 */
bool allowSleep(){
    IOReturn success = IOPMAssertionRelease(assertionID);
    if (success == kIOReturnSuccess){
        return true;
    } else {
        return false;
    }
}
