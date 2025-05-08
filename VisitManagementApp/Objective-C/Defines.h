//
//  Defines.h
//  VisitVerify
//
//  Created by Tony Aguinaga on 9/8/14.
//  Copyright (c) 2014 Tony Aguinaga. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DefinesObjCOverrides.h"

//  RequestSyncVC
#define RETRIEVE_PW_URL @"https://prdbapp.appspot.com/webapi/therapists/username/USERNAME?apiKey=j8DP61HkQLLZD9puLNGJ"
#define RETRIEVE_PATIENTS_URL @"https://prdbapp.appspot.com/webapi/therapists/TID/patients1?apiKey=j8DP61HkQLLZD9puLNGJ"
#define RETRIEVE_SINGLE_PATIENT_URL @"https://prdbapp.appspot.com/webapi/patients/PID?apiKey=j8DP61HkQLLZD9puLNGJ"
#define RETRIEVE_DC_INFO_URL @"https://prdbapp.appspot.com/webapi/patients/PID/dischargeinfo?apiKey=j8DP61HkQLLZD9puLNGJ"
#define RETRIEVE_ALL_PATIENTS_URL @"https://prdbapp.appspot.com/webapi/patients?apiKey=j8DP61HkQLLZD9puLNGJ"
#define RETRIEVE_ADDRESSES_URL @"http://prdbapp.appspot.com/webapi/patients/PID/addresses?apiKey=j8DP61HkQLLZD9puLNGJ"
#define RETRIEVE_ADDRESS_HISTORY_URL @"http://prdbapp.appspot.com/webapi/patients/PID/addresses2?apiKey=j8DP61HkQLLZD9puLNGJ"
#define RETRIEVE_THERAPIST_URL @"https://prdbapp.appspot.com/webapi/therapists/TID?apiKey=j8DP61HkQLLZD9puLNGJ"
#define RETRIEVE_ADMIN_URL @"https://prdbapp.appspot.com/webapi/therapists/TID?apiKey=j8DP61HkQLLZD9puLNGJ"

#define RETRIEVE_THERAPISTS_URL @"https://prdbapp.appspot.com/webapi/therapists?apiKey=j8DP61HkQLLZD9puLNGJ"
#define RETRIEVE_DOCTOR_URL @"https://prdbapp.appspot.com/webapi/doctors/DID?apiKey=j8DP61HkQLLZD9puLNGJ"
#define RETRIEVE_SUPERVISORS_URL @"https://prdbapp.appspot.com/webapi/therapists/supervisors?apiKey=j8DP61HkQLLZD9puLNGJ"
#define RETRIEVE_SUPERVISORS_ASSISTANTS_URL @"https://prdbapp.appspot.com/webapi/therapists/SID/assistants?apiKey=j8DP61HkQLLZD9puLNGJ"
#define RETRIEVE_ASSISTANTS_INTERNS_URL @"https://prdbapp.appspot.com/webapi/therapists/TID/assistantsinterns?apiKey=j8DP61HkQLLZD9puLNGJ"
#define RETRIEVE_RATES_URL @"https://prdbapp.appspot.com/webapi/therapists/TID/rates?apiKey=j8DP61HkQLLZD9puLNGJ"
#define RETRIEVE_PREEMP_URL @"https://prdbapp.appspot.com/webapi/therapists/TID/preemptivevisit?apiKey=j8DP61HkQLLZD9puLNGJ"
#define RETRIEVE_MILEAGE_URL @"https://prdbapp.appspot.com/webapi/therapists/TID/mileage?apiKey=j8DP61HkQLLZD9puLNGJ"

#define RETRIEVE_INSURANCE_URL @"https://prdbapp.appspot.com/webapi/insurances/PID/new?apiKey=j8DP61HkQLLZD9puLNGJ"
//#define RETRIEVE_INSURANCE_URL @"https://prdbapp.appspot.com/webapi/insurances/test/PID?apiKey=j8DP61HkQLLZD9puLNGJ"

#define RETRIEVE_ALL_INSURANCES_BY_DATE_URL @"https://prdbapp.appspot.com/webapi/insurances/new/DATE/?apiKey=j8DP61HkQLLZD9puLNGJ"

#define RETRIEVE_TEST_INSURANCE_URL @"https://prdbapp.appspot.com/webapi/insurances/test/PID?apiKey=j8DP61HkQLLZD9puLNGJ"

#define RETRIEVE_EVAL_INSURANCE_URL @"https://prdbapp.appspot.com/webapi/insurances/eval/PID?apiKey=j8DP61HkQLLZD9puLNGJ"

#define RETRIEVE_HOLDS_URL @"https://prdbapp.appspot.com/webapi/patients/PID/holdinfo?apiKey=j8DP61HkQLLZD9puLNGJ"

#define RETRIEVE_AUTH_CODE_URL @"https://prdbapp.appspot.com/webapi/insurances/PID?apiKey=j8DP61HkQLLZD9puLNGJ"

#define RETRIEVE_DR_LIST @"https://prdbapp.appspot.com/webapi/doctors?apiKey=j8DP61HkQLLZD9puLNGJ"

#define RETRIEVE_CLINIC_LIST @"https://prdbapp.appspot.com/webapi/clinics?apiKey=j8DP61HkQLLZD9puLNGJ"


#define POST_VISIT_URL @"https://prdbapp.appspot.com/webapi/visits/"
#define LOGIN_URL @"https://prdbapp.appspot.com/index.jsp"
//LOGIN PARAMS
//  username tony   password tony1234
#define CONFIRM_URL @"https://prdbapp.appspot.com/confirm-login.jsp"
//CONFIRM PARAMS
//  temppassword    1234tony
#define ADMIN_URL @"https://prdbapp.appspot.com/admin.jsp"
//#define POST_VISIT_URL @"https://prdbapp.appspot.com/addVisit.jsp"

// New API key under preferredtherapyservices@gmail.com
#define GOOGLE_API_KEY @"AIzaSyB9F8zNmIxX3y8wwZCiY2ltz1VXi6N0UFM"

#define GOOGLE_GEOCODING_API_KEY @"AIzaSyB9F8zNmIxX3y8wwZCiY2ltz1VXi6N0UFM"

#define GOOGLE_GEOCODE @"https://maps.googleapis.com/maps/api/geocode/json?sensor=false&address=SEARCHADDRESS&key=APIKEY"

#define RETRIEVE_ACTIONS @"https://prdbapp.appspot.com/webapi/patients/actions?apiKey=j8DP61HkQLLZD9puLNGJ"

#define FCM_SERVER_KEY @"AAAACJ9h4Zg:APA91bEQTWn4Sbx_W7tQd9ncD9-IyDSp6OJGEOkjCmLUQ-GVxtIyZbrJOkcErFma4kZYPctH3NX82meoiPDDLCclkbzxpofLfACP8u6Jg4_QDERK_heZcW4ofeEMABNYSy2TcNaQKRN0"
//#define FCM_SERVER_KEY @"AIzaSyAFGa-0dAANXFhpY3QJOpVc3TY17vLDE2I"

#define RETRIEVE_POSTED_VISITS_SINCE @"https://prdbapp.appspot.com/webapi/visits/20220707?apiKey=j8DP61HkQLLZD9puLNGJ"
#define RETRIEVE_POSTED_MTGS_SINCE @"https://prdbapp.appspot.com/webapi/visits/meeting/20220707?apiKey=j8DP61HkQLLZD9puLNGJ"

#define RETRIEVE_ALL_PORTAL_LOGINS_FROM_DATABASE @"https://prdbapp.appspot.com/webapi/parents/patientdetails?apiKey=j8DP61HkQLLZD9puLNGJ"

#define ASST_STEP_PROGRESS      1.0/10.0
#define SUPER_STEP_PROGRESS     1.0/13.0
#define MISSED_STEP_PROGRESS    1.0/4.0

//#define HIDE_PUSHES
//////////
//  RequestSync
#define UPDATE_NUMBER   279.147
#define UPDATE_STRING   @"279.147"

//#define   DISPLAY_PATIENTS_DATABASE

//#define IGNORE_SCHEDULE_EMAIL
//#define TESTING_LIMITS
//////////

//  PDFRenderer
#define SYS_FONT_9          [UIFont systemFontOfSize:9.0]
#define SYS_FONT_10         [UIFont systemFontOfSize:10.0]
#define SYS_FONT_BOLD_10    [UIFont boldSystemFontOfSize:10.0]
#define SYS_FONT_12         [UIFont systemFontOfSize:12.0]
#define SYS_FONT_BOLD_12    [UIFont boldSystemFontOfSize:12.0]

#define PTS_NAME            @"Preferred Therapy Services"
#define PTS_PHONE           @"817-508-0030"
#define PTS_FAX             @"1-877-267-4771"
#define PTS_ADDRESS         @"2509 Bedford Rd, Bedford, TX 76021"
#define PTS_STREET          @"2509 Bedford Rd"
#define PTS_CITY            @"Bedford"
#define PTS_STATE           @"TX"
#define PTS_ZIP             @"76021"

#define PTS_TPI             @"196586501"
#define PTS_TAX_ID          @"26-1619040"
#define PTS_NPI             @"1982876595"
#define PTS_TAXONOMY        @"251E00000X"
#define PTS_BENEFIT_CODE    @"CCP"

#define PTS_ST_PROCEDURE_CODE   @"92507 - GN"
#define PTS_PT_PROCEDURE_CODE   @"97110, 97112, 97116, 97530 - GP"
#define PTS_OT_PROCEDURE_CODE   @"97530, 97110, 97112, 97116 - GO"

#define PTS_ST_THMP_CODE   @" / S9152"
#define PTS_PT_THMP_CODE   @" / 97002"
#define PTS_OT_THMP_CODE   @" / 97004"

#define PTS_ST_EVAL_PROC_CODE   @"S9152"


#define THERAPIST_PASSWORD      "Attachment$"
///////////////////////


//  TherapistListVC
//#define HIDE_NON_THERAPISTS
//////////////////

//  VisitsVC
//#define ALWAYS_ALLOW_VISITS
//#define IGNORE_THERAPIST_LOCS

//#define TEST_COVIDPT_QUESTIONS
#ifdef TEST_COVIDPT_QUESTIONS
#define COVID_TEST_DATE @"2025-04-11"
#endif

#define TESTING_THERAPISTS

////////////////

//  VisitLocator
//#define SHORT_VISITS
/////////////////

//  NotesVC and VisitsVC and AddVisitVC
#define COVID_19
///////////////
///

//  PDFs
//#define ON_BAD_SIMULATOR

// PatientsVC
//#define PHYSICAL_THERAPIST
//#define IGNORE_MISSING_VISITS
#define DELETE_FIN_N_DEL
//#define NO_DELETION
//#define SKIP_COVID_QUESTIONS
//#define TEST_AUTOGEN_DC_SUMMARIES
//#define POST_DCS_AS_ERIC
//#define TEST_OLD_CLOSEOUT
//#define TEST_LOCK_POINT
////////////////

// AddVisitsVC
#define IGNORE_ORDERS
//#define SET_VERBAL_CONFIRMATION
///////////////

// TherapistListVC
//#define DATABASE_ERROR_TEST
//#define DONT_SEND_REPORT_EMAIL
////////////

// SignatureVC
//#define SKIP_SIG_NAME
///////////////

//#define SET_VERBAL_CONFIRMATION
///////////////

//  RequestSyncVC
//#define TEST_NETWORK_ERROR
//#define NETWORK_ERROR_ALLOWED
//#define DISPLAY_PATIENTS_DATABASE
//#define CRASH_LOG
//#define SYNC_ALL_MAIN_PATIENTS_ALWAYS
//#define USE_BACKGROUND_SYNC
//#define ALWAYS_READY_FOR_SUPER


//GoogleMapVC
//#define GEN_REPORT
/////////////

// Notes
//#define ONE_T_DX
///////////////

// For posting old Missed Visits
//#define ALLOW_POSTING_OF_OLD_MVs
///////////////

//#define IGNORE_SWIFT_CONTROL

#define MAX_SECONDS_UNTIL_LOGIN_FORCED 20

@interface Defines : NSObject

@end










