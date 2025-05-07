//
//  JmAppUserNotificationManager.swift
//  JmUtils_Library
//
//  Created by Daryl Cox on 11/04/2024.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
import UserNotifications
import AudioToolbox
import AVFoundation

// Implementation class to handle access to the Apple XXUserNotificationCenter.

public class JmAppUserNotificationManager: NSObject, UNUserNotificationCenterDelegate, ObservableObject
{

    struct ClassInfo
    {

        static let sClsId        = "JmAppUserNotificationManager"
        static let sClsVers      = "v1.2701"
        static let sClsDisp      = sClsId+".("+sClsVers+"): "
        static let sClsCopyRight = "Copyright (C) JustMacApps 2023-2025. All Rights Reserved."
        static let bClsTrace     = false
        static let bClsFileLog   = false

    }   // End of struct ClassInfo.

    // Class 'singleton' instance:

    struct ClassSingleton
    {

        static var appUserNotificationManager:JmAppUserNotificationManager         = JmAppUserNotificationManager()

    }

    // App Data field(s):

               public  var bAppIsAuthorizedForUserNotifications:Bool               = false
                       var bAlarmWasAddedToUNUserNotificationCenter:Bool           = false
                       var bWasTestNofificationCreated:Bool                        = false

    @Published         var listPendingNotificationRequests:[UNNotificationRequest] = [UNNotificationRequest]()
    
#if os(iOS)

    public  var jmAppAlarmSoundManager:JmAppAlarmSoundManager?                     = nil

#endif

            var jmAppDelegateVisitor:JmAppDelegateVisitor?                         = nil
                                                                                     // 'jmAppDelegateVisitor' MUST remain declared this way
                                                                                     // as having it reference the 'shared' instance of 
                                                                                     // JmAppDelegateVisitor causes a circular reference
                                                                                     // between the 'init()' methods of the 2 classes...

    // App <global> Message(s) 'stack' cached before XCGLogger is available:

            var listPreXCGLoggerMessages:[String]              = Array()

    // App 'Alarm' Data field(s) for UserNotification 'testing':

    var iAlarmUUID:UUID                                        = UUID()
    var sAlarmUUID:String                                      = ""
    var bAlarmSnoozeEnabled:Bool                               = false
    var bAlarmRepeatsEnabled:Bool                              = true
    var iAlarmSnoozeInterval:Int                               = 1                   // Snooze 'interval' is # of minutes...
    var idMedia:UUID?                                          = nil
    var sAlarmRingtoneName:String                              = "AlarmRingtone"
    var sAlarmContentTitle:String                              = "Alarm"
    var sAlarmContentBody:String                               = "Wake UP!!! This has been a 5th 'test' with 'closure'..."

    private override init()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        super.init()

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'jmAppDelegateVisitor' is [\(String(describing: self.jmAppDelegateVisitor))]...")
        
        // Finish initializing the App 'Alarm' for UserNotification for 'testing'...
        
        self.sAlarmUUID = self.iAlarmUUID.uuidString

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'jmAppDelegateVisitor' is [\(String(describing: self.jmAppDelegateVisitor))]...")

        return

    }   // End of private override init().

    public func terminateAppUserNotifications()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'jmAppDelegateVisitor' is [\(String(describing: self.jmAppDelegateVisitor))]...")

        // If the 'test' Alarm was added to the UNUserNotificationCenter, then remove it...

        if (AppGlobalInfo.bIssueTestAppUserNotifications == true)
        {

            if (self.bWasTestNofificationCreated == true)
            {

                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers:[self.sAlarmUUID])

                self.xcgLogMsg("\(sCurrMethodDisp) 'self.bWasTestNofificationCreated' is [\(self.bWasTestNofificationCreated)] - 'test' UserNotification was added - the Alarm has been 'cancelled'...")

            }
            else
            {

                self.xcgLogMsg("\(sCurrMethodDisp) 'self.bWasTestNofificationCreated' is [\(self.bWasTestNofificationCreated)] - 'test' UserNotification was NOT added - the Alarm 'cancel' has been bypassed...")

            }

            self.bWasTestNofificationCreated = false

        }

        self.xcgLogMsg("\(sCurrMethodDisp) Invoking 'self.getAllPendingUserNotificationEvents()'...")

        let _ = self.getAllPendingUserNotificationEvents()

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked  'self.getAllPendingUserNotificationEvents()'...")

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) 'self.bAppIsAuthorizedForUserNotifications' is [\(self.bAppIsAuthorizedForUserNotifications)]...")
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'jmAppDelegateVisitor' is [\(String(describing: self.jmAppDelegateVisitor))]...")

        return

    }   // End of public func terminateAppUserNotifications().

    private func xcgLogMsg(_ sMessage:String)
    {

        if (self.jmAppDelegateVisitor != nil)
        {

            if (self.jmAppDelegateVisitor!.bAppDelegateVisitorLogFilespecIsUsable == true)
            {

                self.jmAppDelegateVisitor!.xcgLogMsg(sMessage)

            }
            else
            {

                print("\(sMessage)")

                self.listPreXCGLoggerMessages.append(sMessage)

            }

        }
        else
        {

            print("\(sMessage)")

            self.listPreXCGLoggerMessages.append(sMessage)

        }

        // Exit:

        return

    }   // End of private func xcgLogMsg().

    public func toString() -> String
    {

        var asToString:[String] = Array()

        asToString.append("[")
        asToString.append("[")
        asToString.append("'sClsId': [\(ClassInfo.sClsId)],")
        asToString.append("'sClsVers': [\(ClassInfo.sClsVers)],")
        asToString.append("'sClsDisp': [\(ClassInfo.sClsDisp)],")
        asToString.append("'sClsCopyRight': [\(ClassInfo.sClsCopyRight)],")
        asToString.append("'bClsTrace': [\(ClassInfo.bClsTrace)],")
        asToString.append("'bClsFileLog': [\(ClassInfo.bClsFileLog)]")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'bAppIsAuthorizedForUserNotifications': [\(self.bAppIsAuthorizedForUserNotifications)]")
        asToString.append("'bAlarmWasAddedToUNUserNotificationCenter': [\(self.bAlarmWasAddedToUNUserNotificationCenter)]")
        asToString.append("'bWasTestNofificationCreated': [\(self.bWasTestNofificationCreated)]")

    #if os(iOS)

        asToString.append("],")
        asToString.append("[")
        asToString.append("'jmAppAlarmSoundManager': [\(String(describing: self.jmAppAlarmSoundManager))]")

    #endif

        asToString.append("],")
        asToString.append("[")
        asToString.append("'iAlarmUUID': (\(self.iAlarmUUID))")
        asToString.append("'sAlarmUUID': [\(self.sAlarmUUID)]")
        asToString.append("'bAlarmSnoozeEnabled': [\(self.bAlarmSnoozeEnabled)]")
        asToString.append("'bAlarmRepeatsEnabled': [\(self.bAlarmRepeatsEnabled)]")
        asToString.append("'iAlarmSnoozeInterval': (\(self.iAlarmSnoozeInterval))")
        asToString.append("'sAlarmRingtoneName': [\(self.sAlarmRingtoneName)]")
        asToString.append("'sAlarmContentTitle': [\(self.sAlarmContentTitle)]")
        asToString.append("'sAlarmContentBody': [\(self.sAlarmContentBody)]")
        asToString.append("],")
        asToString.append("]")

        let sContents:String = "{"+(asToString.joined(separator: ""))+"}"

        return sContents

    }   // End of public func toString().

    // (Call-back) Method to set the jmAppDelegateVisitor instance...

    public func setJmAppDelegateVisitorInstance(jmAppDelegateVisitor:JmAppDelegateVisitor)
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - supplied parameter 'jmAppDelegateVisitor' is [\(jmAppDelegateVisitor)]...")

        // Set the AppDelegateVisitor instance...

        self.jmAppDelegateVisitor = jmAppDelegateVisitor
    
        // Spool <any> pre-XDGLogger (via the AppDelegateVisitor) message(s) into the Log...

        if (self.listPreXCGLoggerMessages.count > 0)
        {

            self.xcgLogMsg("")
            self.xcgLogMsg("\(sCurrMethodDisp) <<< === Spooling the JmAppDelegateVisitor.XCGLogger 'pre' Message(s) from JmAppUserNotificationManager === >>>")

            let sPreXCGLoggerMessages:String = self.listPreXCGLoggerMessages.joined(separator: "\n")

            self.xcgLogMsg(sPreXCGLoggerMessages)

            self.xcgLogMsg("\(sCurrMethodDisp) <<< === Spooled  the JmAppDelegateVisitor.XCGLogger 'pre' Message(s) from JmAppUserNotificationManager === >>>")
            self.xcgLogMsg("")

        }

        // Finish any 'initialization' work:

        self.xcgLogMsg("\(sCurrMethodDisp) UserNotificationManager Invoking 'self.runPostInitializationTasks()'...")
    
        self.runPostInitializationTasks()

        self.xcgLogMsg("\(sCurrMethodDisp) UserNotificationManager Invoked  'self.runPostInitializationTasks()'...")
    
        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'self.jmAppDelegateVisitor' is [\(String(describing: self.jmAppDelegateVisitor))]...")
    
        return

    } // End of public func setJmAppDelegateVisitorInstance().

    private func runPostInitializationTasks()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'self' is [\(self)]...")

        // Finish performing any setup with the UNUserNotificationCenter...

        self.xcgLogMsg("\(sCurrMethodDisp) Registering 'self' as the UNUserNotificationCenterDelegate to the UNUserNotificationCenter...")

        UNUserNotificationCenter.current().delegate = self

        self.xcgLogMsg("\(sCurrMethodDisp) Registered  'self' as the UNUserNotificationCenterDelegate to the UNUserNotificationCenter...")

        self.xcgLogMsg("\(sCurrMethodDisp) Requesting authorization for UserNotification(s) via 'self.requestUserNotificationAuthorization()'...")

        self.requestUserNotificationAuthorization()

        self.xcgLogMsg("\(sCurrMethodDisp) Requested  authorization for UserNotification(s) via 'self.requestUserNotificationAuthorization()'...")

        self.xcgLogMsg("\(sCurrMethodDisp) Registering the categories for UserNotification(s) via 'self.registerNotificationCategories()'...")

        self.registerUserNotificationCategories()
    
        self.xcgLogMsg("\(sCurrMethodDisp) Registered  the categories for UserNotification(s) via 'self.registerNotificationCategories()'...")

        self.xcgLogMsg("\(sCurrMethodDisp) Invoking 'self.getAllPendingUserNotificationEvents()'...")

        let _ = self.getAllPendingUserNotificationEvents()

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked  'self.getAllPendingUserNotificationEvents()'...")

    #if os(iOS)

        // Setup the JmAppAlarmSoundManager...

        self.xcgLogMsg("\(sCurrMethodDisp) Creating a 'default' JmAppAlarmSoundManager...")

        self.jmAppAlarmSoundManager = JmAppAlarmSoundManager.sharedJmAppAlarmSoundManager

        self.jmAppAlarmSoundManager?.setJmAppDelegateVisitorInstance(jmAppDelegateVisitor:self.jmAppDelegateVisitor!)

        self.xcgLogMsg("\(sCurrMethodDisp) Created  a 'default' JmAppAlarmSoundManager...")

    #endif

    //  // 'audit' all the UserNotification(s) based upon SwiftData item(s)...
    //
    //  self.xcgLogMsg("\(sCurrMethodDisp) Invoking 'self.auditAppSwiftDataItemNotifications()'...")
    //
    //  let _ = self.auditAppSwiftDataItemNotifications()
    //
    //  self.xcgLogMsg("\(sCurrMethodDisp) Invoked  'self.auditAppSwiftDataItemNotifications()'...")

        // Setup a 'default' (testing) UserNotification <maybe>...

        if (AppGlobalInfo.bIssueTestAppUserNotifications == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Creating a 'default' UserNotification(s) <for 'testing'> via 'self.createUserNotificationEvent()'...")

            self.createUserNotificationEvent(createTestNofification:AppGlobalInfo.bIssueTestAppUserNotifications)

            self.xcgLogMsg("\(sCurrMethodDisp) Created  a 'default' UserNotification(s) <for 'testing'> via 'self.createUserNotificationEvent()'...")

        }

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of private func runPostInitializationTasks().

    // Method(s) 'required' by the UNUserNotificationCenter for a 'delegate'...

    public func userNotificationCenter(_ center:UNUserNotificationCenter, willPresent notification:UNNotification, withCompletionHandler completionHandler:@escaping (UNNotificationPresentationOptions)->Void)
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Asks the Delegate how to handle a Notification that arrived while the App was running in the foreground...

        self.xcgLogMsg("\(sCurrMethodDisp) UNUserNotification received while App is in the 'foreground'...")
        
        let userInfo                        = notification.request.content.userInfo
        let sUserNotificationDetails:String = "Notification received for [\(notification)] - 'userInfo' is [\(userInfo)]..."

        self.xcgLogMsg("\(sCurrMethodDisp) \(sUserNotificationDetails)")

        // Signal an 'Alert' for the Notification...

    #if os(iOS)

        if (self.jmAppAlarmSoundManager != nil)
        {

            let sMediaRingTone:String = String(describing: (userInfo["ringtone"] ?? "bell"))

            self.xcgLogMsg("\(sCurrMethodDisp) UNUserNotification is invoking 'jmAppAlarmSoundManager:JmAppAlarmSoundManager?.jmAppAlarmManagerStartPlayingSound()' to play the sound '\(sMediaRingTone).mp3'...")

            self.jmAppAlarmSoundManager?.jmAppAlarmManagerStartPlayingSound(sMediaRingTone)
        //  self.jmAppAlarmSoundManager?.jmAppAlarmManagerStartPlayingSound("bell")

        }

    #endif

        var sNotificationAlertMsg:String = "-N/A-"

        if (AppGlobalInfo.bPerformAppDevTesting           == false ||
            AppGlobalInfo.bIssueShortAppUserNotifications == true)
        {

            sNotificationAlertMsg = "Alarm::\((userInfo["alarmTitle"] ?? "-N-A-")) - \((userInfo["alarmMessage"] ?? ""))..."

            self.xcgLogMsg("\(sCurrMethodDisp) UserNotification received for 'sNotificationAlertMsg' of [\(sNotificationAlertMsg)]...")

        }
        else
        {

            sNotificationAlertMsg = "Alert::App 'Alarm' received - Details are: [\(userInfo)]..."

            self.xcgLogMsg("\(sCurrMethodDisp) UserNotification received for 'sNotificationAlertMsg' of [\(sNotificationAlertMsg)]...")

        }

        var sAlertButtonText2:String = ""

        if (userInfo["bSnoozeEnabled"]         != nil &&
            userInfo["bSnoozeEnabled"] as! Int == 1)
        {

            sAlertButtonText2 = "Snooze"

            self.xcgLogMsg("\(sCurrMethodDisp) <snooze-switch::willPresent> UserNotification - 'userInfo[\"bSnoozeEnabled\"]' is [\(String(describing: userInfo["bSnoozeEnabled"]))] <'1'> - 'sAlertButtonText2' set to [\(sAlertButtonText2)] - 'userInfo' is [\(userInfo)]...")

        }
        else
        {

            sAlertButtonText2 = ""

            self.xcgLogMsg("\(sCurrMethodDisp) <snooze-switch::willPresent> UserNotification - 'userInfo[\"bSnoozeEnabled\"]' is [\(String(describing: userInfo["bSnoozeEnabled"]))] NOT <'1'> - 'sAlertButtonText2' set to [\(sAlertButtonText2)] - 'userInfo' is [\(userInfo)]...")

        }

        DispatchQueue.main.async
        {
      
            self.jmAppDelegateVisitor?.setAppDelegateVisitorSignalCompletionAlert(sNotificationAlertMsg,
                                                                                  alertButtonText1:"Ok", 
                                                                                  alertButtonText2:sAlertButtonText2,
                                                                                  withCompletion1:
                                                                                  {
                                                                                      self.closureHandlePostAppUserNotificationEventAlertTextMsg1(notification:notification)

                                                                                  },
                                                                                  withCompletion2:
                                                                                  {
                                                                                      self.closureHandlePostAppUserNotificationEventAlertTextMsg2(notification:notification)

                                                                                  })
        }

        self.xcgLogMsg("\(sCurrMethodDisp) Triggered an App Notification 'Alert' - Details are: [\(userInfo)]...")
        
        // Exit:
        
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
        
        completionHandler(.list)

        return

    }   // End of public func userNotificationCenter(_ center:UNUserNotificationCenter, willPresent notification:UNNotification, withCompletionHandler completionHandler:@escaping (UNNotificationPresentationOptions)->Void).

    public func userNotificationCenter(_ center:UNUserNotificationCenter, didReceive response:UNNotificationResponse, withCompletionHandler completionHandler:@escaping ()->Void)
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Asks the Delegate to process the User’s Response to a delivered Notification (App was running in the background)...

        self.xcgLogMsg("\(sCurrMethodDisp) UNUserNotification received while App is in the 'background'...")
        
        let notification:UNNotification     = response.notification
        let userInfo                        = notification.request.content.userInfo
        let sUserNotificationDetails:String = "Notification received for [\(response.notification)] - 'userInfo' is [\(userInfo)]..."
        
        self.xcgLogMsg("\(sCurrMethodDisp) \(sUserNotificationDetails)")
        
        // Signal an 'Alert' for the Notification...

    #if os(iOS)

        if (self.jmAppAlarmSoundManager != nil)
        {

            let sMediaRingTone:String = String(describing: (userInfo["ringtone"] ?? "bell"))

            self.xcgLogMsg("\(sCurrMethodDisp) UNUserNotification is invoking 'jmAppAlarmSoundManager:JmAppAlarmSoundManager?.jmAppAlarmManagerStartPlayingSound()' to play the sound '\(sMediaRingTone).mp3'...")

            self.jmAppAlarmSoundManager?.jmAppAlarmManagerStartPlayingSound(sMediaRingTone)
        //  self.jmAppAlarmSoundManager?.jmAppAlarmManagerStartPlayingSound("bell")

        }

    #endif

        var sNotificationAlertMsg:String = "-N/A-"

        if (AppGlobalInfo.bPerformAppDevTesting           == false ||
            AppGlobalInfo.bIssueShortAppUserNotifications == true)
        {

            sNotificationAlertMsg = "Alarm::\((userInfo["alarmTitle"] ?? "-N-A-")) - \((userInfo["alarmMessage"] ?? ""))..."

            self.xcgLogMsg("\(sCurrMethodDisp) UserNotification received for 'sNotificationAlertMsg' of [\(sNotificationAlertMsg)]...")

        }
        else
        {
            
            sNotificationAlertMsg = "Alert::App 'Alarm' received - Details are: [\(userInfo)]..."
            
            self.xcgLogMsg("\(sCurrMethodDisp) UserNotification received for 'sNotificationAlertMsg' of [\(sNotificationAlertMsg)]...")
            
        }

        var sAlertButtonText2:String = ""

        if (userInfo["bSnoozeEnabled"]         != nil &&
            userInfo["bSnoozeEnabled"] as! Int == 1)
        {

            sAlertButtonText2 = "Snooze"

            self.xcgLogMsg("\(sCurrMethodDisp) <snooze-switch::didReceive> UserNotification - 'userInfo[\"bSnoozeEnabled\"]' is [\(String(describing: userInfo["bSnoozeEnabled"]))] <'1'> - 'sAlertButtonText2' set to [\(sAlertButtonText2)] - 'userInfo' is [\(userInfo)]...")

        }
        else
        {

            sAlertButtonText2 = ""

            self.xcgLogMsg("\(sCurrMethodDisp) <snooze-switch::didReceive> UserNotification - 'userInfo[\"bSnoozeEnabled\"]' is [\(String(describing: userInfo["bSnoozeEnabled"]))] NOT <'1'> - 'sAlertButtonText2' set to [\(sAlertButtonText2)] - 'userInfo' is [\(userInfo)]...")

        }

        DispatchQueue.main.async
        {
      
            self.jmAppDelegateVisitor?.setAppDelegateVisitorSignalCompletionAlert(sNotificationAlertMsg,
                                                                                  alertButtonText1:"Ok", 
                                                                                  alertButtonText2:sAlertButtonText2,
                                                                                  withCompletion1:
                                                                                  {
                                                                                      self.closureHandlePostAppUserNotificationEventAlertTextMsg1(notification:notification)

                                                                                  },
                                                                                  withCompletion2:
                                                                                  {
                                                                                      self.closureHandlePostAppUserNotificationEventAlertTextMsg2(notification:notification)

                                                                                  })
        }

        self.xcgLogMsg("\(sCurrMethodDisp) Triggered an App Notification 'Alert' - App is in the 'background' - Details are [\(sNotificationAlertMsg)]...")
        
        // Exit:
        
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        completionHandler()

        return

    }   // End of public func userNotificationCenter(_ center:UNUserNotificationCenter, didReceive response:UNNotificationResponse, withCompletionHandler completionHandler:@escaping ()->Void).

    public func userNotificationCenter(_ center:UNUserNotificationCenter, openSettingsFor:UNNotification?)
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Asks the Delegate to process the User’s Response to a delivered Notification...

        
        // Exit:
        
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
        
        return

    }   // End of public func userNotificationCenter(_ center:UNUserNotificationCenter, openSettingsFor:UNNotification?).

    // Method(s) to request Authorization and register Notification categories...

    private func requestUserNotificationAuthorization()
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'self.bAppIsAuthorizedForUserNotifications' is [\(self.bAppIsAuthorizedForUserNotifications)]...")

        // Request Authorization (from the User) for UserNotification(s)...
        // Note:
        //   The first time your app makes this authorization request, the system prompts
        //   the person to grant or deny the request and records that response. 
        //   Subsequent authorization requests don’t prompt the person.

        self.bAppIsAuthorizedForUserNotifications     = false
        var bWasAppAuthorizationExplicitlyFailed:Bool = false

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
        { (authorized, error) in

            if (authorized) 
            {

                self.xcgLogMsg("\(sCurrMethodDisp) Request for UserNotification(s) was 'authorized' by the User...")

                bWasAppAuthorizationExplicitlyFailed = false

            } 
            else 
            {

                self.xcgLogMsg("\(sCurrMethodDisp) Request for UserNotification(s) was NOT 'authorized' by the User - Warning!")

                bWasAppAuthorizationExplicitlyFailed = true

            }

        }

        if (bWasAppAuthorizationExplicitlyFailed == true)
        {

            self.bAppIsAuthorizedForUserNotifications = false

        }
        else
        {

            self.bAppIsAuthorizedForUserNotifications = true

        }
        
        // Exit:
        
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'self.bAppIsAuthorizedForUserNotifications' is [\(self.bAppIsAuthorizedForUserNotifications)]...")
        
        return

    }   // End of private func requestUserNotificationAuthorization().

    private func registerUserNotificationCategories()
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Register the categories of UserNotification(s)...

        let unAlarmActionAlarm  = UNNotificationAction(identifier:JmAppUserNotificationIdentifiers.sAppNotificationIdentifierActionAlarm, 
                                                       title:     "Alarm!", 
                                                       options:   [.foreground])

        let unAlarmActionStop   = UNNotificationAction(identifier:JmAppUserNotificationIdentifiers.sAppNotificationIdentifierActionStop, 
                                                       title:     "Ok", 
                                                       options:   [.foreground])

        let unAlarmActionSnooze = UNNotificationAction(identifier:JmAppUserNotificationIdentifiers.sAppNotificationIdentifierActionSnooze, 
                                                       title:     "Snooze", 
                                                       options:   [.foreground])

        let unAlarmCategoryAlarm:UNNotificationCategory   = 
                UNNotificationCategory(identifier:                   JmAppUserNotificationIdentifiers.sAppNotificationIdentifierCategoryAlarm, 
                                       actions:                      [unAlarmActionAlarm],
                                       intentIdentifiers:            [],
                                       hiddenPreviewsBodyPlaceholder:"",
                                       options:                      .customDismissAction)

        let unAlarmCategoryStop:UNNotificationCategory   = 
                UNNotificationCategory(identifier:                   JmAppUserNotificationIdentifiers.sAppNotificationIdentifierCategoryStop, 
                                       actions:                      [unAlarmActionAlarm, unAlarmActionStop],
                                       intentIdentifiers:            [],
                                       hiddenPreviewsBodyPlaceholder:"",
                                       options:                      .customDismissAction)

        let unAlarmCategorySnooze:UNNotificationCategory = 
                UNNotificationCategory(identifier:                   JmAppUserNotificationIdentifiers.sAppNotificationIdentifierCategorySnooze, 
                                       actions:                      [unAlarmActionAlarm, unAlarmActionStop, unAlarmActionSnooze],
                                       intentIdentifiers:            [],
                                       hiddenPreviewsBodyPlaceholder:"",
                                       options:                      .customDismissAction)
        
    //  let xxx:UNNotificationCategory = UNNotificationCategory(identifier: <#T##String#>, 
    //                                                          actions:    <#T##[UNNotificationAction]#>, 
    //                                                          intentIdentifiers: <#T##[String]#>, 
    //                                                          hiddenPreviewsBodyPlaceholder: <#T##String?#>, 
    //                                                          categorySummaryFormat: <#T##String?#>, 
    //                                                          options: <#T##UNNotificationCategoryOptions#>)

        self.xcgLogMsg("\(sCurrMethodDisp) Registering the categories for UserNotification(s) via 'UNUserNotificationCenter.current().setNotificationCategories([unAlarmCategoryStop, unAlarmCategorySnooze])'...")

        UNUserNotificationCenter.current().setNotificationCategories([unAlarmCategoryAlarm, unAlarmCategoryStop, unAlarmCategorySnooze])
        
        self.xcgLogMsg("\(sCurrMethodDisp) Registered  the categories for UserNotification(s) via 'UNUserNotificationCenter.current().setNotificationCategories([unAlarmCategoryStop, unAlarmCategorySnooze])'...")

        // Exit:
        
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
        
        return

    }   // End of private func registerUserNotificationCategories().

    // Method(s) for manipulating UserNotification(s)...

    private func createUserNotificationEvent(createTestNofification:Bool=false)
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        if (createTestNofification == true)
        {

            // Create the UserNotification event...

            self.idMedia = UUID()

            let unMutableNotificationContent:UNMutableNotificationContent = UNMutableNotificationContent()

            unMutableNotificationContent.title              = self.sAlarmContentTitle
            unMutableNotificationContent.body               = self.sAlarmContentBody
        //  unMutableNotificationContent.interruptionLevel  = .timeSensitive    // Set as Time 'sensitive' [1, 4, 5] (even in 'Do NOT Disturb')...
            unMutableNotificationContent.interruptionLevel  = .critical
        //  unMutableNotificationContent.attachments        = [UNNotificationAttachment]
            unMutableNotificationContent.userInfo           = ["idNotification"   : self.idMedia!.uuidString,
                                                               "alarmTitle"       : self.sAlarmContentTitle,
                                                               "alarmMessage"     : self.sAlarmContentBody,
                                                               "alarmSetFor"      : String(describing: Date()),
                                                               "alarmFiresOn"     : String(describing: Date()),
                                                               "bAlarmEnabled"    : "true",
                                                               "bSnoozeEnabled"   : self.bAlarmSnoozeEnabled,
                                                               "snoozeInterval"   : "9",
                                                               "bRepeatsEnabled"  : "false",
                                                               "repeatsOnWeekdays": "[]",
                                                               "ringtone"         : self.sAlarmRingtoneName]
            unMutableNotificationContent.categoryIdentifier = 
                (self.bAlarmSnoozeEnabled ? JmAppUserNotificationIdentifiers.sAppNotificationIdentifierCategorySnooze
                                          : JmAppUserNotificationIdentifiers.sAppNotificationIdentifierCategoryAlarm)
        //  unMutableNotificationContent.sound              = UNNotificationSound(named:UNNotificationSoundName("\(self.sAlarmRingtoneName).aiff"))
        //  unMutableNotificationContent.sound              = UNNotificationSound(named:UNNotificationSoundName("\(self.sAlarmRingtoneName).mp3"))
            unMutableNotificationContent.sound              = UNNotificationSound.criticalSoundNamed(UNNotificationSoundName("\(self.sAlarmRingtoneName).mp3"))

            // -----------------------------------------------------------------------------------------------------------------------
            //  NOTE: Prepare Sound Resources
            //
            //  The system sound facility plays custom alert sounds, so they must be in one of the following audio data formats:
            //      Linear PCM
            //      MA4 (IMA/ADPCM)
            //      µLaw
            //      aLaw
            //
            //  You can package the audio data in an aiff, wav, or caf file. Sound files must be less than 30 seconds in length.
            //  If the sound file is longer than 30 seconds, the system plays the default sound instead.
            //
            //  You can use the afconvert command-line tool to convert sounds. For example, to convert the system sound
            //  'Submarine.aiff' to IMA4 audio in a CAF file, use the following command in Terminal:
            //
            //      afconvert /System/Library/Sounds/Submarine.aiff ~/Desktop/sub.caf -d ima4 -f caff -v
            // -----------------------------------------------------------------------------------------------------------------------

            // Create the 'trigger' to set when the UserNotification is sent...

        //  let unNotificationTrigger:UNTimeIntervalNotificationTrigger = 
        //      UNTimeIntervalNotificationTrigger(timeInterval:TimeInterval((self.iAlarmSnoozeInterval * (2 * 60))),
        //                                             repeats:self.bAlarmRepeatsEnabled)
        //
        //  let unNotificationTrigger:UNTimeIntervalNotificationTrigger = 
        //      UNTimeIntervalNotificationTrigger(timeInterval:TimeInterval((self.iAlarmSnoozeInterval * (60 * 60 * 24))),
        //                                             repeats:self.bAlarmRepeatsEnabled)
      
            var dateComponentsDailyAlarm    = DateComponents()
          
        //  dateComponentsDailyAlarm.hour   = 7
        //  dateComponentsDailyAlarm.minute = 45
        //  dateComponentsDailyAlarm.hour   = 20
        //  dateComponentsDailyAlarm.minute = 20
            dateComponentsDailyAlarm.hour   = 5
            dateComponentsDailyAlarm.minute = 25
        //  dateComponentsDailyAlarm.hour   = 20
        //  dateComponentsDailyAlarm.minute = 55
          
            let unNotificationTrigger:UNCalendarNotificationTrigger = 
                UNCalendarNotificationTrigger(dateMatching:dateComponentsDailyAlarm, 
                                                   repeats:self.bAlarmRepeatsEnabled)

            // Create the UserNotification event 'request'...

            let unNotificationRequest:UNNotificationRequest = 
                UNNotificationRequest(identifier:self.idMedia!.uuidString,
                                         content:unMutableNotificationContent,
                                         trigger:unNotificationTrigger)

            // Add the UserNotification event 'request'...

            self.xcgLogMsg("\(sCurrMethodDisp) Adding the UserNotfication 'request' with an Alarm ID of [\(self.sAlarmUUID)] and a Media ID of [\(self.idMedia!.uuidString)] to the 'UNUserNotificationCenter' with a 'trigger:' of [\(unNotificationTrigger)] and 'content:' of [\(unMutableNotificationContent)]...")

            var bWasAppNotificationAddExplicitlyFailed:Bool = false

            UNUserNotificationCenter.current().add(unNotificationRequest) 
            { error in

                if let ex = error 
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) Failed to add the UserNotfication 'request' with an Alarm ID of [\(self.sAlarmUUID)] and a Media ID of [\(self.idMedia!.uuidString)] to the 'UNUserNotificationCenter' - error was [\(ex.localizedDescription)] - Error!")

                    bWasAppNotificationAddExplicitlyFailed = true

                }
                else
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) Added  the UserNotfication 'request' with an Alarm ID of [\(self.sAlarmUUID)] and a Media ID of [\(self.idMedia!.uuidString)] to the 'UNUserNotificationCenter' with a 'trigger:' of [\(unNotificationTrigger)] and 'content:' of [\(unMutableNotificationContent)]...")

                    bWasAppNotificationAddExplicitlyFailed = false

                }

            }

            if (bWasAppNotificationAddExplicitlyFailed == true)
            {

                self.bAlarmWasAddedToUNUserNotificationCenter = false
                self.bWasTestNofificationCreated              = false

            }
            else
            {

                self.bAlarmWasAddedToUNUserNotificationCenter = true
                self.bWasTestNofificationCreated              = true

                self.xcgLogMsg("\(sCurrMethodDisp) Intermediate #1 - appending 'unNotificationRequest' of (\(unNotificationRequest)) to 'self.listPendingNotificationRequests' now containing (\(self.listPendingNotificationRequests.count)) event(s) <was NOT already in list>...")

                self.listPendingNotificationRequests.append(unNotificationRequest)

                self.xcgLogMsg("\(sCurrMethodDisp) Intermediate #1 - appended  'unNotificationRequest' of (\(unNotificationRequest)) to 'self.listPendingNotificationRequests' now containing (\(self.listPendingNotificationRequests.count)) event(s)...")

            }

        }

        self.xcgLogMsg("\(sCurrMethodDisp) Invoking 'self.getAllPendingUserNotificationEvents()'...")

        let _ = self.getAllPendingUserNotificationEvents()

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked  'self.getAllPendingUserNotificationEvents()'...")

        // Exit:
        
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
        
        return

    }   // End of private func createUserNotificationEvent(createTestNofification:Bool).

    public func auditAppSwiftDataItemNotifications()
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
  
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
  
        // If we have a SwiftDataManaager, then 'audit' any 'alarm' item(s)...

        var cAlarmSwiftDataItems:Int = 0

        if (self.jmAppDelegateVisitor?.jmAppSwiftDataManager != nil)
        {
            
            let jmAppSwiftDataManager:JmAppSwiftDataManager = (self.jmAppDelegateVisitor?.jmAppSwiftDataManager!)!
        
            if (jmAppSwiftDataManager.alarmSwiftDataItems.count > 0)
            {
            
                self.xcgLogMsg("\(sCurrMethodDisp) - UserNotification 'audit' of (\(jmAppSwiftDataManager.alarmSwiftDataItems.count)) SwiftData item(s) 'notification(s)'...")
                
                for alarmSwiftDataItem:AlarmSwiftDataItem in jmAppSwiftDataManager.alarmSwiftDataItems
                {

                    cAlarmSwiftDataItems += 1

                    var bNotificationRequestAlreadyInList:Bool = false

                    if (alarmSwiftDataItem.idMedia != nil)
                    {
                    
                        for unNotificationRequestInList in self.listPendingNotificationRequests
                        {

                            if (unNotificationRequestInList.identifier == alarmSwiftDataItem.idMedia!.uuidString)
                            {

                                bNotificationRequestAlreadyInList = true

                                self.xcgLogMsg("\(sCurrMethodDisp) <audit> Intermediate #1 - #(\(cAlarmSwiftDataItems)) - 'alarmSwiftDataItem.idMedia' of [\(String(describing: alarmSwiftDataItem.idMedia))] is already in the list with 'unNotificationRequestInList.identifier' of [\(unNotificationRequestInList.identifier)] ...")

                            }

                        }
                    
                    }

                    if (bNotificationRequestAlreadyInList == false)
                    {

                        if (alarmSwiftDataItem.bIsAlarmEnabled == true)
                        {

                            self.xcgLogMsg("\(sCurrMethodDisp) <audit> Intermediate #1 - #(\(cAlarmSwiftDataItems)) - 'alarmSwiftDataItem.idMedia' of [\(String(describing: alarmSwiftDataItem.idMedia))] is NOT in the list 'unNotificationRequestInList' but is 'enabled' - creating the 'notification' for it...")

                            self.xcgLogMsg("\(sCurrMethodDisp) UserNotification (Create)  'alarm' SwiftData item 'createUserNotificationEventForAlarm(alarmSwiftDataItem:)'...")

                            self.createUserNotificationEventForAlarm(alarmSwiftDataItem:alarmSwiftDataItem)

                            self.xcgLogMsg("\(sCurrMethodDisp) UserNotification (Created) 'alarm' SwiftData item 'createUserNotificationEventForAlarm(alarmSwiftDataItem:)'...")

                        }
                        else
                        {

                            self.xcgLogMsg("\(sCurrMethodDisp) <audit> Intermediate #1 - #(\(cAlarmSwiftDataItems)) - 'alarmSwiftDataItem.idMedia' of [\(String(describing: alarmSwiftDataItem.idMedia))] is NOT in the list 'unNotificationRequestInList' and is NOT 'enabled' - all is good...")

                        }

                    }
                    else
                    {

                        if (alarmSwiftDataItem.bIsAlarmEnabled == true)
                        {

                            self.xcgLogMsg("\(sCurrMethodDisp) <audit> Intermediate #1 - #(\(cAlarmSwiftDataItems)) - 'alarmSwiftDataItem.idMedia' of [\(String(describing: alarmSwiftDataItem.idMedia))] is already in the list 'unNotificationRequestInList' and is 'enabled' - all is good...")

                        }
                        else
                        {

                            self.xcgLogMsg("\(sCurrMethodDisp) <audit> Intermediate #1 - #(\(cAlarmSwiftDataItems)) - 'alarmSwiftDataItem.idMedia' of [\(String(describing: alarmSwiftDataItem.idMedia))] is already in the list 'unNotificationRequestInList' but is NOT 'enabled' - deleting the 'notification' for it...")

                            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers:[alarmSwiftDataItem.idMedia!.uuidString])

                            self.xcgLogMsg("\(sCurrMethodDisp) <audit> Intermediate #1 - UserNotification was 'updated' - removed the Alarm 'alarmSwiftDataItem.idMedia' of [\(String(describing: alarmSwiftDataItem.idMedia))] from the delivered UserNotification request(s)...")

                            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers:[alarmSwiftDataItem.idMedia!.uuidString])

                            self.xcgLogMsg("\(sCurrMethodDisp) <audit> Intermediate #1 - UserNotification was 'updated' - removed the Alarm 'alarmSwiftDataItem.idMedia' of [\(String(describing: alarmSwiftDataItem.idMedia))] from the pending UserNotification request(s)...")

                            DispatchQueue.main.async
                            {

                                self.listPendingNotificationRequests.removeAll
                                    { unNotificationRequestInList in

                                        unNotificationRequestInList.identifier == alarmSwiftDataItem.idMedia!.uuidString

                                    }

                                self.xcgLogMsg("\(sCurrMethodDisp) <audit> Intermediate #1 - 'pending' UserNotification request(s) list was 'updated'...")

                            }

                            alarmSwiftDataItem.idMedia = nil

                        }

                    }

                }

                // If we have UserNotification 'notification(s)', then 'audit' any notification(s) to make sure they have 'alarm' item(s)...

                if (self.listPendingNotificationRequests.count > 0)
                {

                    for unNotificationRequestInList in self.listPendingNotificationRequests
                    {

                        var bNotificationRequestHasAlarmItem:Bool = false

                        for alarmSwiftDataItem:AlarmSwiftDataItem in jmAppSwiftDataManager.alarmSwiftDataItems
                        {

                            if (alarmSwiftDataItem.idMedia != nil)
                            {

                                if (unNotificationRequestInList.identifier == alarmSwiftDataItem.idMedia!.uuidString)
                                {

                                    bNotificationRequestHasAlarmItem = true

                                    self.xcgLogMsg("\(sCurrMethodDisp) <audit> Intermediate #1 - 'alarmSwiftDataItem.idMedia' of [\(String(describing: alarmSwiftDataItem.idMedia))] is already in the list with 'unNotificationRequestInList.identifier' of [\(unNotificationRequestInList.identifier)] ...")

                                }

                            }

                        }

                        if (bNotificationRequestHasAlarmItem == false)
                        {
                        
                            self.xcgLogMsg("\(sCurrMethodDisp) <audit> Intermediate #1 - 'unNotificationRequestInList.identifier' of [\(String(describing: unNotificationRequestInList.identifier))] is in the list 'unNotificationRequestInList' but does NOT have a SwiftData 'alarm' - deleting the 'notification'...")

                            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers:[unNotificationRequestInList.identifier])

                            self.xcgLogMsg("\(sCurrMethodDisp) <audit> Intermediate #1 - UserNotification was 'updated' - removed the Alarm 'unNotificationRequestInList.identifier' of [\(String(describing: unNotificationRequestInList.identifier))] from the delivered UserNotification request(s)...")

                            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers:[unNotificationRequestInList.identifier])

                            self.xcgLogMsg("\(sCurrMethodDisp) <audit> Intermediate #1 - UserNotification was 'updated' - removed the Alarm 'unNotificationRequestInList.identifier' of [\(String(describing: unNotificationRequestInList.identifier))] from the pending UserNotification request(s)...")

                            let sDeletionUUID:String = unNotificationRequestInList.identifier

                            DispatchQueue.main.async
                            {

                                self.listPendingNotificationRequests.removeAll
                                    { unNotificationRequestInList in

                                        unNotificationRequestInList.identifier == sDeletionUUID

                                    }

                                self.xcgLogMsg("\(sCurrMethodDisp) <audit> Intermediate #1 - 'pending' UserNotification request(s) list was 'updated'...")

                            }
                        
                        }

                    }

                }
                else
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) - UserNotification 'audit' of 'notification' item(s) 'notification(s)' was bypassed - the notification(s) list is empty...")

                }

            }
            else
            {
            
                self.xcgLogMsg("\(sCurrMethodDisp) - UserNotification 'audit' of SwiftData item(s) 'notification(s)' was bypassed - SwiftDataManager has a list of 'alarm(s)' that is empty...")
                
            }

        }
        else
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) - UserNotification 'audit' of SwiftData item(s) 'notification(s)' was bypassed - AppDelegateVisitor has NO SwiftDataManager instance...")
        
        }

        // If there were NO 'alarm' SwiftData item(s) audited, then clear all UserNotifiation(s)...

        if (cAlarmSwiftDataItems < 1)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) Invoking 'self.clearAllPendingUserNotificationEvents()'...")

            let _ = self.clearAllPendingUserNotificationEvents()

            self.xcgLogMsg("\(sCurrMethodDisp) Invoked  'self.clearAllPendingUserNotificationEvents()'...")
        
        }
        
        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return
  
    }   // End of public func auditAppSwiftDataItemNotifications().

    public func signalAppSwiftDataItemUpdated(alarmSwiftDataItem:AlarmSwiftDataItem)
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
  
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'alarmSwiftDataItem' is [\(alarmSwiftDataItem)]...")
  
        // If this 'alarm' SwiftData item has an 'idMedia' field that is NOT nil, then remove it from the delivered/pending UserNotification request(s)...

        if (alarmSwiftDataItem.idMedia != nil)
        {

            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers:[alarmSwiftDataItem.idMedia!.uuidString])

            self.xcgLogMsg("\(sCurrMethodDisp) - UserNotification was 'updated' - removed the Alarm 'alarmSwiftDataItem.idMedia' of [\(String(describing: alarmSwiftDataItem.idMedia))] from the delivered UserNotification request(s)...")

            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers:[alarmSwiftDataItem.idMedia!.uuidString])

            self.xcgLogMsg("\(sCurrMethodDisp) - UserNotification was 'updated' - removed the Alarm 'alarmSwiftDataItem.idMedia' of [\(String(describing: alarmSwiftDataItem.idMedia))] from the pending UserNotification request(s)...")

            DispatchQueue.main.async
            {

                self.listPendingNotificationRequests.removeAll
                    { unNotificationRequestInList in

                        unNotificationRequestInList.identifier == alarmSwiftDataItem.idMedia!.uuidString

                    }

                self.xcgLogMsg("\(sCurrMethodDisp) <audit> Intermediate #1 - 'pending' UserNotification request(s) list was 'updated'...")

            }

            alarmSwiftDataItem.idMedia = nil

        }

        // If the 'alarm' is 'enabled, then create the UserNotification for the 'alarm' SwiftData item...

        if (alarmSwiftDataItem.bIsAlarmEnabled == true)
        {
  
            self.xcgLogMsg("\(sCurrMethodDisp) UserNotification (Create)  'alarm' SwiftData item 'createUserNotificationEventForAlarm(alarmSwiftDataItem:)'...")

            self.createUserNotificationEventForAlarm(alarmSwiftDataItem:alarmSwiftDataItem)
      
            self.xcgLogMsg("\(sCurrMethodDisp) UserNotification (Created) 'alarm' SwiftData item 'createUserNotificationEventForAlarm(alarmSwiftDataItem:)'...")

        }

        self.xcgLogMsg("\(sCurrMethodDisp) Invoking 'self.getAllPendingUserNotificationEvents()'...")

        let _ = self.getAllPendingUserNotificationEvents()

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked  'self.getAllPendingUserNotificationEvents()'...")

    // ------------------------------------------------------------------------------------------------------
    // This causes a loop...
    //
    //  // Signal the SwiftDataManger that an item has been updated...
    //
    //  self.jmAppDelegateVisitor?.jmAppSwiftDataManager?.signalAppSwiftDataItemUpdated(alarmSwiftDataItem:alarmSwiftDataItem, 
    //                                                                                  bShowDetailAfterUpdate:false)
    //
    //  self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager has been signalled that SwiftData has been 'updated'...")
    // ------------------------------------------------------------------------------------------------------

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'alarmSwiftDataItem' is [\(alarmSwiftDataItem)]...")
  
        return
  
    }   // End of public func signalAppSwiftDataItemUpdated(alarmSwiftDataItem:AlarmSwiftDataItem).

    private func createUserNotificationEventForAlarm(alarmSwiftDataItem:AlarmSwiftDataItem)
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'alarmSwiftDataItem' is [\(alarmSwiftDataItem)]...")

        // Check the 'alarm' SwiftData item and make sure it is 'enabled'...

        if (alarmSwiftDataItem.bIsAlarmEnabled == false)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) The 'alarm' SwiftData item of [\(String(describing: alarmSwiftDataItem.toString()))] is NOT marked 'enabled' [\(alarmSwiftDataItem.bIsAlarmEnabled)] - bypassing UserNotification for the item...")

            self.bAlarmWasAddedToUNUserNotificationCenter = false

            // Exit:

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'alarmSwiftDataItem' is [\(alarmSwiftDataItem)] - 'bAlarmWasAddedToUNUserNotificationCenter' is [\(self.bAlarmWasAddedToUNUserNotificationCenter)]...")

            return

        }

        // Create the UserNotification event for the supplied 'alarm' SwiftData item...

        alarmSwiftDataItem.idMedia = UUID()

        let unMutableNotificationContent:UNMutableNotificationContent = UNMutableNotificationContent()

        unMutableNotificationContent.title              = alarmSwiftDataItem.sMediaAlarmTitle
        unMutableNotificationContent.body               = alarmSwiftDataItem.sMediaAlarmMessage
        unMutableNotificationContent.interruptionLevel  = .critical
        unMutableNotificationContent.userInfo           = ["idNotification"   : alarmSwiftDataItem.idMedia!.uuidString,
                                                           "alarmTitle"       : alarmSwiftDataItem.sMediaAlarmTitle,
                                                           "alarmMessage"     : alarmSwiftDataItem.sMediaAlarmMessage,
                                                           "alarmSetFor"      : String(describing: alarmSwiftDataItem.dateAlarmSetFor),
                                                           "alarmFiresOn"     : String(describing: alarmSwiftDataItem.dateAlarmFires),
                                                           "bAlarmEnabled"    : alarmSwiftDataItem.bIsAlarmEnabled,
                                                           "bSnoozeEnabled"   : alarmSwiftDataItem.bIsAlarmSnoozeEnabled,
                                                           "snoozeInterval"   : String(describing: alarmSwiftDataItem.iAlarmSnoozeInterval),
                                                           "bRepeatsEnabled"  : alarmSwiftDataItem.bIsAlarmRepeatsEnabled,
                                                           "repeatsOnWeekdays": String(describing: alarmSwiftDataItem.listRepeatOnWeekdays),
                                                           "ringtone"         : alarmSwiftDataItem.sMediaRingTone]
        unMutableNotificationContent.categoryIdentifier = 
            (self.bAlarmSnoozeEnabled ? JmAppUserNotificationIdentifiers.sAppNotificationIdentifierCategorySnooze
                                      : JmAppUserNotificationIdentifiers.sAppNotificationIdentifierCategoryAlarm)
        unMutableNotificationContent.sound              = UNNotificationSound.criticalSoundNamed(UNNotificationSoundName("\(alarmSwiftDataItem.sMediaRingTone).mp3"))

    //  do
    //  {

        let dateComponentsAlarmItem:DateComponents  = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from:alarmSwiftDataItem.dateAlarmFires)
        var dateComponentsAlarmFires:DateComponents = DateComponents()

        dateComponentsAlarmFires.year   = dateComponentsAlarmItem.year   ?? 2025
        dateComponentsAlarmFires.month  = dateComponentsAlarmItem.month  ?? 12
        dateComponentsAlarmFires.day    = dateComponentsAlarmItem.day    ?? 12
        dateComponentsAlarmFires.hour   = dateComponentsAlarmItem.hour   ?? 5
        dateComponentsAlarmFires.minute = dateComponentsAlarmItem.minute ?? 25

        self.xcgLogMsg("\(sCurrMethodDisp) <converted> The UserNotfication 'request' for a Date of 'dateComponentsAlarmFires' of [\(dateComponentsAlarmFires)] from a Date of 'dateComponentsAlarmItem' of [\(dateComponentsAlarmItem)]...")
        
        let unNotificationTrigger:UNCalendarNotificationTrigger = 
            UNCalendarNotificationTrigger(dateMatching:dateComponentsAlarmFires, 
                                               repeats:alarmSwiftDataItem.bIsAlarmRepeatsEnabled)

        // Create the UserNotification event 'request'...

        let unNotificationRequest:UNNotificationRequest = 
            UNNotificationRequest(identifier:alarmSwiftDataItem.idMedia!.uuidString,
                                     content:unMutableNotificationContent,
                                     trigger:unNotificationTrigger)

        // Add the UserNotification event 'request'...

        self.xcgLogMsg("\(sCurrMethodDisp) Adding the UserNotfication 'request' with an Alarm ID of [\(String(describing: alarmSwiftDataItem.sAlarmUUID))] and a Media ID of [\(alarmSwiftDataItem.idMedia!.uuidString)] to the 'UNUserNotificationCenter' with a 'trigger:' of [\(unNotificationTrigger)] and 'content:' of [\(unMutableNotificationContent)]...")

        var bWasAppNotificationAddExplicitlyFailed:Bool = false

        UNUserNotificationCenter.current().add(unNotificationRequest) 
        { error in

            if let ex = error 
            {

                self.xcgLogMsg("\(sCurrMethodDisp) Failed to add the UserNotfication 'request' with an Alarm ID of [\(String(describing: alarmSwiftDataItem.sAlarmUUID))] and a Media ID of [\(alarmSwiftDataItem.idMedia!.uuidString)] to the 'UNUserNotificationCenter' - error was [\(ex.localizedDescription)] - Error!")

                bWasAppNotificationAddExplicitlyFailed = true

            }
            else
            {

                self.xcgLogMsg("\(sCurrMethodDisp) Added  the UserNotfication 'request' with an Alarm ID of [\(String(describing: alarmSwiftDataItem.sAlarmUUID))] and a Media ID of [\(alarmSwiftDataItem.idMedia!.uuidString)] to the 'UNUserNotificationCenter' with a 'trigger:' of [\(unNotificationTrigger)] and 'content:' of [\(unMutableNotificationContent)]...")

                bWasAppNotificationAddExplicitlyFailed = false

            }

        }

        if (bWasAppNotificationAddExplicitlyFailed == true)
        {

            self.bAlarmWasAddedToUNUserNotificationCenter = false

        }
        else
        {

            self.bAlarmWasAddedToUNUserNotificationCenter = true

            self.xcgLogMsg("\(sCurrMethodDisp) Intermediate #1 - appending 'unNotificationRequest' of (\(unNotificationRequest)) to 'self.listPendingNotificationRequests' now containing (\(self.listPendingNotificationRequests.count)) event(s) <was NOT already in list>...")

            self.listPendingNotificationRequests.append(unNotificationRequest)

            self.xcgLogMsg("\(sCurrMethodDisp) Intermediate #1 - appended  'unNotificationRequest' of (\(unNotificationRequest)) to 'self.listPendingNotificationRequests' now containing (\(self.listPendingNotificationRequests.count)) event(s)...")

        }

    //  self.xcgLogMsg("\(sCurrMethodDisp) Invoking 'self.getAllPendingUserNotificationEvents()'...")
    //
    //  let _ = self.getAllPendingUserNotificationEvents()
    //
    //  self.xcgLogMsg("\(sCurrMethodDisp) Invoked  'self.getAllPendingUserNotificationEvents()'...")

    //  }
    //  catch
    //  {
    //      
    //      self.xcgLogMsg("\(sCurrMethodDisp) Add of the UserNotification 'request' with an Alarm ID of [\(String(describing: alarmSwiftDataItem.idMedia))] failed - Details: \(error) - Error!")
    //
    //      self.bAlarmWasAddedToUNUserNotificationCenter = false
    //      
    //  }

        // Exit:
        
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'alarmSwiftDataItem' is [\(alarmSwiftDataItem)] - 'bAlarmWasAddedToUNUserNotificationCenter' is [\(self.bAlarmWasAddedToUNUserNotificationCenter)]...")
        
        return

    }   // End of private func createUserNotificationEvent().

    public func getAllPendingUserNotificationEvents()->[UNNotificationRequest]
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Get ALL 'pending' UserNotification event(s)...

        self.listPendingNotificationRequests = [UNNotificationRequest]()

        self.xcgLogMsg("\(sCurrMethodDisp) Invoking 'UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler:)'...")

        UNUserNotificationCenter.current().getPendingNotificationRequests(
            completionHandler:
                { listNotficationRequests in

                    self.xcgLogMsg("\(sCurrMethodDisp) <closure:completionHandler> Intermediate #1 - adding 'listNotficationRequests' of (\(listNotficationRequests.count)) event(s) to 'self.listPendingNotificationRequests' now containing (\(self.listPendingNotificationRequests.count)) event(s)...")

                //  self.listPendingNotificationRequests.append(contentsOf:listNotficationRequests)

                    var cNotficationRequests:Int = 0

                    for unNotificationRequest in listNotficationRequests
                    {

                        cNotficationRequests += 1

                        var bNotificationRequestAlreadyInList:Bool = false

                        for unNotificationRequestInList in self.listPendingNotificationRequests
                        {

                            if (unNotificationRequestInList.identifier == unNotificationRequest.identifier)
                            {
                            
                                bNotificationRequestAlreadyInList = true
                                
                                self.xcgLogMsg("\(sCurrMethodDisp) <closure:completionHandler> Intermediate #1 - #(\(cNotficationRequests)) - 'unNotificationRequest.identifier' of [\(unNotificationRequest.identifier)] is already in the list with 'unNotificationRequestInList.identifier' of [\(unNotificationRequestInList.identifier)] ...")
                            
                            }

                        }

                        if (bNotificationRequestAlreadyInList == false)
                        {

                            DispatchQueue.main.async
                            {

                                self.xcgLogMsg("\(sCurrMethodDisp) <closure:completionHandler> Intermediate #1 - #(\(cNotficationRequests)) appending 'unNotificationRequest' of (\(unNotificationRequest)) to 'self.listPendingNotificationRequests' now containing (\(self.listPendingNotificationRequests.count)) event(s) <was NOT already in list>...")

                                self.listPendingNotificationRequests.append(unNotificationRequest)

                                self.xcgLogMsg("\(sCurrMethodDisp) <closure:completionHandler> Intermediate #1 - #(\(cNotficationRequests)) appended  'unNotificationRequest' of (\(unNotificationRequest)) to 'self.listPendingNotificationRequests' now containing (\(self.listPendingNotificationRequests.count)) event(s)...")

                            }
                        
                        }
                        else
                        {
                        
                            self.xcgLogMsg("\(sCurrMethodDisp) <closure:completionHandler> Intermediate #1 - #(\(cNotficationRequests)) bypassed appending 'unNotificationRequest' of (\(unNotificationRequest)) to 'self.listPendingNotificationRequests' now containing (\(self.listPendingNotificationRequests.count)) event(s) <WAS already in list>...")
                        
                        }

                    }

                    self.xcgLogMsg("\(sCurrMethodDisp) <closure:completionHandler> Intermediate #1 - updated   'self.listPendingNotificationRequests' now containing (\(self.listPendingNotificationRequests.count)) event(s) from 'listNotficationRequests' of (\(listNotficationRequests.count)) event(s)...")

                    // 'audit' all the UserNotification(s) based upon SwiftData item(s)...

                    self.xcgLogMsg("\(sCurrMethodDisp) Invoking 'self.auditAppSwiftDataItemNotifications()'...")

                    let _ = self.auditAppSwiftDataItemNotifications()

                    self.xcgLogMsg("\(sCurrMethodDisp) Invoked  'self.auditAppSwiftDataItemNotifications()'...")
                
                }
            )

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked  'UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler:)'...")

        // Exit:
        
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'self.listPendingNotificationRequests' is [\(self.listPendingNotificationRequests)]...")
        
        return self.listPendingNotificationRequests

    }   // End of public func getAllPendingUserNotificationEvents().

    public func clearAllPendingUserNotificationEvents()
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Clear ALL 'pending' UserNotification event(s)...

        self.xcgLogMsg("\(sCurrMethodDisp) Invoking 'UNUserNotificationCenter.current().removeAllPendingNotificationRequests()'...")

        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked  'UNUserNotificationCenter.current().removeAllPendingNotificationRequests()'...")

        // Clear ALL 'delivered' UserNotification event(s) (that haven't been cleared)...

        self.xcgLogMsg("\(sCurrMethodDisp) Invoking 'UNUserNotificationCenter.current().removeAllDeliveredNotifications()'...")

        UNUserNotificationCenter.current().removeAllDeliveredNotifications()

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked  'UNUserNotificationCenter.current().removeAllDeliveredNotifications()'...")

    //  // Reload the list of 'pending' Notification event(s)...
    //
    //  self.xcgLogMsg("\(sCurrMethodDisp) Invoking 'self.getAllPendingUserNotificationEvents()'...")
    //
    //  let _ = self.getAllPendingUserNotificationEvents()
    //
    //  self.xcgLogMsg("\(sCurrMethodDisp) Invoked  'self.getAllPendingUserNotificationEvents()'...")

        // Exit:
        
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
        
        return

    }   // End of public func clearAllPendingUserNotificationEvents().

    public func calculateNextDateFromGivenDate(dateOfCurrent:Date, listRepeatOnWeekdays:[Int])->Date?
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'dateOfCurrent' is [\(dateOfCurrent)] - 'listRepeatOnWeekdays' is [\(listRepeatOnWeekdays)]...")

        // Calculate the next Date from the supplied Date given the list of 'repeat' DaysOfWeek...

        var dateOfNextDate:Date? = nil

        if (listRepeatOnWeekdays.count < 1)
        {

            dateOfNextDate = nil

            self.xcgLogMsg("\(sCurrMethodDisp) 'listRepeatOnWeekdays' is 'empty' - NO future 'repeat' days - return value is [\(String(describing: dateOfNextDate))]...")

            // Exit:

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'dateOfNextDate' is [\(String(describing: dateOfNextDate))]...")

            return dateOfNextDate

        }

        let dayNumberCurrent:Int = Calendar.current.component(.weekday, from:dateOfCurrent)

        self.xcgLogMsg("\(sCurrMethodDisp) Intermediate #1 - 'dayNumberCurrent' is (\(dayNumberCurrent)) from 'dateOfCurrent' of [\(dateOfCurrent)]...")

        let iNextDayOfWeek:Int = self.calculateNextDayOfWeek(iCurrentDayOfWeek:dayNumberCurrent, listRepeatOnWeekdays:listRepeatOnWeekdays)

        self.xcgLogMsg("\(sCurrMethodDisp) Intermediate #2 - 'iNextDayOfWeek' is (\(iNextDayOfWeek)) using 'listRepeatOnWeekdays' of [\(listRepeatOnWeekdays)]...")

        if (iNextDayOfWeek < 1)
        {

            dateOfNextDate = nil

            self.xcgLogMsg("\(sCurrMethodDisp) 'iNextDayOfWeek' of (\(iNextDayOfWeek)) is less than 1 - NO future 'repeat' days - return value is [\(String(describing: dateOfNextDate))]...")

            // Exit:

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'dateOfNextDate' is [\(String(describing: dateOfNextDate))]...")

            return dateOfNextDate

        }

        dateOfNextDate = Calendar.current.date(byAdding:.day, value:iNextDayOfWeek, to:dateOfCurrent)!

        self.xcgLogMsg("\(sCurrMethodDisp) Intermediate #3 - 'dateOfNextDate' is [\(String(describing: dateOfNextDate))] from 'dateOfCurrent' of [\(dateOfCurrent)]...")

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'dateOfNextDate' is [\(String(describing: dateOfNextDate))]...")

        return dateOfNextDate

    }   // End of public func calculateNextDateFromGivenDate(dateOfCurrent:Date, listRepeatOnWeekdays:[Int])->Date?.

    public func calculateNextDayOfWeek(iCurrentDayOfWeek:Int, listRepeatOnWeekdays:[Int])->Int
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'iCurrentDayOfWeek' is (\(iCurrentDayOfWeek)) - 'listRepeatOnWeekdays' is [\(listRepeatOnWeekdays)]...")

        // Calculate the number of Day(s) from the current DayOfWeek until the Repeated DayOfWeek...

        var iNextDayOfWeek:Int = 0

        if (iCurrentDayOfWeek < 1)
        {

            iNextDayOfWeek = 0

            self.xcgLogMsg("\(sCurrMethodDisp) 'iCurrentDayOfWeek' is less than 1 - NO future 'repeat' days - return value is [\(iNextDayOfWeek)]...")

            // Exit:

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'iNextDayOfWeek' is (\(iNextDayOfWeek))...")

            return iNextDayOfWeek

        }

        if (listRepeatOnWeekdays.count < 1)
        {

            iNextDayOfWeek = 0

            self.xcgLogMsg("\(sCurrMethodDisp) 'listRepeatOnWeekdays' is 'empty' - NO future 'repeat' days - return value is [\(iNextDayOfWeek)]...")

            // Exit:

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'iNextDayOfWeek' is (\(iNextDayOfWeek))...")

            return iNextDayOfWeek

        }

        var bNextDayOfWeekFound:Bool = false

        for listDayOfWeek:Int in listRepeatOnWeekdays
        {

            if (listDayOfWeek > iCurrentDayOfWeek)
            {

                iNextDayOfWeek      = (listDayOfWeek - iCurrentDayOfWeek)
                bNextDayOfWeekFound = true

                break

            }

        }

        self.xcgLogMsg("\(sCurrMethodDisp) Intermediate #1 - 'bNextDayOfWeekFound' is [\(bNextDayOfWeekFound)] - 'iNextDayOfWeek' is [\(iNextDayOfWeek)]...")

        if (bNextDayOfWeekFound == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) 'bNextDayOfWeekFound' is 'true' - return value is (\(iNextDayOfWeek))...")

            // Exit:

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'iNextDayOfWeek' is (\(iNextDayOfWeek))...")

            return iNextDayOfWeek

        }

        self.xcgLogMsg("\(sCurrMethodDisp) Intermediate #2 - 'bNextDayOfWeekFound' is 'false' - searching for a 'rollover' return value...")

        iNextDayOfWeek      = (listRepeatOnWeekdays[0] + (7 - iCurrentDayOfWeek))
        bNextDayOfWeekFound = true

        self.xcgLogMsg("\(sCurrMethodDisp) Intermediate #3 - 'bNextDayOfWeekFound' is [\(bNextDayOfWeekFound)] - 'iNextDayOfWeek' is [\(iNextDayOfWeek)]...")

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'iNextDayOfWeek' is (\(iNextDayOfWeek))...")

        return iNextDayOfWeek

    }   // End of public func calculateNextDayOfWeek(iCurrentDayOfWeek:Int, listRepeatOnWeekdays:[Int])->Int.

    public func closureHandlePostAppUserNotificationEventAlertTextMsg1(notification:UNNotification)
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'notification' is [\(notification)]...")

        // Handle the 'post' UserNotification event...

        self.handlePostAppUserNotificationEvent(bAppAlarmIsSnooze:false, notification:notification)

        // Exit:
        
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
        
        return

    }   // End of public func closureHandlePostAppUserNotificationEventAlertTextMsg1(notification:UNNotification).

    public func closureHandlePostAppUserNotificationEventAlertTextMsg2(notification:UNNotification)
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'notification' is [\(notification)]...")

        // Handle the 'post' UserNotification event...

        self.handlePostAppUserNotificationEvent(bAppAlarmIsSnooze:true, notification:notification)

        // Exit:
        
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
        
        return

    }   // End of public func closureHandlePostAppUserNotificationEventAlertTextMsg2(notification:UNNotification).

    public func handlePostAppUserNotificationEvent(bAppAlarmIsSnooze:Bool, notification:UNNotification)
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'bAppAlarmIsSnooze' is [\(bAppAlarmIsSnooze)] - 'notification' is [\(notification)]...")

        // Handle the 'post' UserNotification event...

        let userInfo                        = notification.request.content.userInfo
        let sUserNotificationDetails:String = "Notification received for [\(notification)] - 'userInfo' is [\(userInfo)]..."

        self.xcgLogMsg("\(sCurrMethodDisp) UNUserNotification 'withCompletion:' closure is executing - 'sUserNotificationDetails' is [\(sUserNotificationDetails)]...")

    #if os(iOS)

        if (self.jmAppAlarmSoundManager != nil)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) UNUserNotification is invoking 'self.jmAppAlarmSoundManager?.jmAppAlarmManagerStopPlayingSound()' to 'stop' playing the sound...")

            self.jmAppAlarmSoundManager?.jmAppAlarmManagerStopPlayingSound()

        }

    #endif

        let alarmSwiftDataItem:AlarmSwiftDataItem? = 
            self.jmAppDelegateVisitor?.jmAppSwiftDataManager?.locateAppSwiftDataItemAlarmByMediaId(sAlarmSwiftDataItemMediaId:(userInfo["idNotification"] as! String))

        if (alarmSwiftDataItem != nil)
        {

            if (alarmSwiftDataItem!.bIsAlarmSnoozeEnabled  == false &&
                alarmSwiftDataItem!.bIsAlarmRepeatsEnabled == false)
            {

                alarmSwiftDataItem!.bIsAlarmEnabled = false

                self.xcgLogMsg("\(sCurrMethodDisp) UNUserNotification has 'reset' 'alarmSwiftDataItem!.bIsAlarmEnabled' to 'false' - 'alarmSwiftDataItem' is [\(alarmSwiftDataItem!.toString())]...")

            }
            else
            {

                alarmSwiftDataItem!.bIsAlarmEnabled = true

                self.xcgLogMsg("\(sCurrMethodDisp) UNUserNotification has bypassed the 'reset' of 'alarmSwiftDataItem!.bIsAlarmEnabled' to 'false' - 'alarmSwiftDataItem' is [\(alarmSwiftDataItem!.toString())]...")

            }

            // If the 'alarm' is (still) 'enabled', then determine if we're 'snoozing' or 'repeating'...

            if (alarmSwiftDataItem!.bIsAlarmEnabled == true)
            {

                var bAlarmIsJustSnoozing:Bool = false

                if (bAppAlarmIsSnooze                         == true &&
                    alarmSwiftDataItem!.bIsAlarmSnoozeEnabled == true)
                {

                    bAlarmIsJustSnoozing = true
                
                }
                else
                {

                    bAlarmIsJustSnoozing = false

                }

                if (bAlarmIsJustSnoozing == true)
                {
                
                    if (alarmSwiftDataItem!.iAlarmSnoozeInterval > 0)
                    {
                        
                        let dateOfNextAlarm:Date? = Calendar.current.date(byAdding:.minute, value:alarmSwiftDataItem!.iAlarmSnoozeInterval, to:alarmSwiftDataItem!.dateAlarmFires)!

                        self.xcgLogMsg("\(sCurrMethodDisp) Intermediate #1.1 - 'dateOfNextAlarm' is [\(String(describing: dateOfNextAlarm))] from 'dateAlarmFires' of [\(alarmSwiftDataItem!.dateAlarmFires)]...")
                    
                        if (dateOfNextAlarm != nil)
                        {

                            alarmSwiftDataItem!.dateAlarmFires  = dateOfNextAlarm!
                            alarmSwiftDataItem!.bIsAlarmEnabled = true

                        }

                    }
                    else
                    {
                    
                        bAlarmIsJustSnoozing = false

                        self.xcgLogMsg("\(sCurrMethodDisp) Intermediate #1.2 - 'alarm' was 'snoozed' but the 'snooze' interval is less than 1 minute - overriding in favor of 'repeat(s)'...")
                    
                    }
                
                }

                if (bAlarmIsJustSnoozing                       == false &&
                    alarmSwiftDataItem!.bIsAlarmRepeatsEnabled == true)
                {
                
                    // Calculate the (possible) 'next' Date for the Alarm (not 'snoozing but now 'repeating')...

                    if (alarmSwiftDataItem!.listRepeatOnWeekdays.count > 0)
                    {

                    //  let dateOfNextAlarm:Date? = self.calculateNextDateFromGivenDate(dateOfCurrent:       alarmSwiftDataItem!.dateAlarmFires, 
                        let dateOfNextAlarm:Date? = self.calculateNextDateFromGivenDate(dateOfCurrent:       alarmSwiftDataItem!.dateAlarmSetFor, 
                                                                                        listRepeatOnWeekdays:alarmSwiftDataItem!.listRepeatOnWeekdays)

                        self.xcgLogMsg("\(sCurrMethodDisp) Intermediate #1.3 - 'dateOfNextAlarm' is [\(String(describing: dateOfNextAlarm))] from 'alarmSwiftDataItem.dateAlarmFires' of [\(alarmSwiftDataItem!.dateAlarmFires)] using 'alarmSwiftDataItem.listRepeatOnWeekdays' of [\(alarmSwiftDataItem!.listRepeatOnWeekdays)]...")

                        if (alarmSwiftDataItem!.bIsAlarmRepeatsEnabled == true &&
                            dateOfNextAlarm                            != nil)
                        {

                            alarmSwiftDataItem!.dateAlarmSetFor = dateOfNextAlarm!
                            alarmSwiftDataItem!.dateAlarmFires  = dateOfNextAlarm!
                            alarmSwiftDataItem!.bIsAlarmEnabled = true

                        }

                    }
                
                }
                
            }

            alarmSwiftDataItem!.dateAlarmUpdated = Date()

            self.jmAppDelegateVisitor?.jmAppSwiftDataManager?.saveAppSwiftData()

            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager has been signalled to 'save' SwiftData...")

            self.xcgLogMsg("\(sCurrMethodDisp) Invoking 'self.signalAppSwiftDataItemUpdated(alarmSwiftDataItem:)'...")
          
            self.signalAppSwiftDataItemUpdated(alarmSwiftDataItem:alarmSwiftDataItem!)
          
            self.xcgLogMsg("\(sCurrMethodDisp) Invoked  'self.signalAppSwiftDataItemUpdated(alarmSwiftDataItem:)'...")

        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) UNUserNotification could NOT 'reset' the 'alarmSwiftDataItem' since it was 'nil' - Warning!")

        }

        self.xcgLogMsg("\(sCurrMethodDisp) Triggered an App Notification 'Alert' - parameter 'bAppAlarmIsSnooze' was [\(bAppAlarmIsSnooze)] - Details are: [\(userInfo)]...")

        // Exit:
        
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
        
        return

    }   // End of public func handlePostAppUserNotificationEvent(bAppAlarmIsSnooze:Bool, notification:UNNotification).

}   // End of public class JmAppUserNotificationManager.

