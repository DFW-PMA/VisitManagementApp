//
//  AppDevDetailsModelObservable.swift
//  VisitManagementApp
//
//  Created by Daryl Cox on 09/17/2024.
//  Copyright © DFW-PMA 2023-2025. All rights reserved.
//

import Foundation
import SwiftUI

@available(iOS 14.0, *)
class AppDevDetailsModelObservable:NSObject, ObservableObject
{
    
    struct ClassInfo
    {
        
        static let sClsId        = "AppDevDetailsModelObservable"
        static let sClsVers      = "v1.0901"
        static let sClsDisp      = sClsId+"(.swift).("+sClsVers+"):"
        static let sClsCopyRight = "Copyright (C) DFW-PMA 2023-2025. All Rights Reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }

    // Class 'singleton':

    struct ClassSingleton
    {

        static 
        var appDevDetailsModelObservable:AppDevDetailsModelObservable = AppDevDetailsModelObservable()

    }

    // App Data field(s):
    
                                                                      // List of the App 'developer' Detail(s) Item(s)
                                                                      //     as AppDevDetailsItem(s)...
    @Published         var listAppDevDetailsItems:[AppDevDetailsItem] = []

                       var bIsUserBlockedFromFaceId:Bool              = false
                       var sLoginUsername:String                      = ""
                       var sLoginPassword:String                      = ""
                       var sLoginEmail:String                         = ""
    
                       var appGlobalInfo:AppGlobalInfo                = AppGlobalInfo.ClassSingleton.appGlobalInfo
                       var jmAppDelegateVisitor:JmAppDelegateVisitor  = JmAppDelegateVisitor.ClassSingleton.appDelegateVisitor
    
    private override init()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "'"+sCurrMethod+"'"

        super.init()

        self.xcgLogMsg("\(ClassInfo.sClsDisp)\(sCurrMethodDisp) Invoked...")
        
        self.updateAppDevDetailsItemList()

        // Exit...

        self.xcgLogMsg("\(ClassInfo.sClsDisp)\(sCurrMethodDisp) Exiting...")

        return
        
    }   // End of private override init().
    
    private func xcgLogMsg(_ sMessage:String)
    {

        if (self.jmAppDelegateVisitor.bAppDelegateVisitorLogFilespecIsUsable == true)
        {
      
            self.jmAppDelegateVisitor.xcgLogMsg(sMessage)
      
        }
        else
        {
      
            print("\(sMessage)")
      
        }

        // Exit:

        return

    }   // End of private func xcgLogMsg().

    public func toString()->String
    {

        var asToString:[String] = Array()

        asToString.append("[")
        asToString.append("[")
        asToString.append("'sClsId': [\(ClassInfo.sClsId)],")
        asToString.append("'sClsVers': [\(ClassInfo.sClsVers)],")
        asToString.append("'sClsDisp': [\(ClassInfo.sClsDisp)],")
        asToString.append("'sClsCopyRight': [\(ClassInfo.sClsCopyRight)],")
        asToString.append("'bClsTrace': [\(ClassInfo.bClsTrace)],")
        asToString.append("'bClsFileLog': [\(ClassInfo.bClsFileLog)],")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'bIsUserBlockedFromFaceId': [\(String(describing: self.bIsUserBlockedFromFaceId))],")
        asToString.append("'sLoginUsername': [\(String(describing: self.sLoginUsername))],")
        asToString.append("'sLoginPassword': [\(String(describing: self.sLoginPassword))],")
        asToString.append("'sLoginEmail': [\(String(describing: self.sLoginEmail))],")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'listAppDevDetailsItems': [\(String(describing: self.listAppDevDetailsItems))],")
        asToString.append("],")
        asToString.append("]")

        let sContents:String = "{"+(asToString.joined(separator: ""))+"}"

        return sContents

    }   // End of public func toString().

    public func setAppDevDetailsItems(bIsUserBlockedFromFaceId:Bool, sLoginUsername:String, sLoginPassword:String, sLoginEmail:String = "")
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "'"+sCurrMethod+"'"
        
        self.xcgLogMsg("\(ClassInfo.sClsDisp)\(sCurrMethodDisp) Invoked - 'bIsUserBlockedFromFaceId' is [\(bIsUserBlockedFromFaceId)] - 'sLoginUsername' is [\(sLoginUsername)] - 'sLoginPassword' is [\(sLoginPassword)] - 'sLoginEmail' is [\(sLoginEmail)]...")
        
        // Set some 'internal' Dev Detail(s)...

        self.bIsUserBlockedFromFaceId = bIsUserBlockedFromFaceId
        self.sLoginUsername           = sLoginUsername
        self.sLoginPassword           = sLoginPassword
        self.sLoginEmail              = sLoginEmail

        // Exit...

        self.xcgLogMsg("\(ClassInfo.sClsDisp)\(sCurrMethodDisp) Exiting...")
        
        return

    }   // End of public func setAppDevDetailsItems(bIsUserBlockedFromFaceId:Bool, sLoginUsername:String, sLoginPassword:String, sLoginEmail:String).

    public func updateAppDevDetailsItemList()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "'"+sCurrMethod+"'"
        
        self.xcgLogMsg("\(ClassInfo.sClsDisp)\(sCurrMethodDisp) Invoked...")
        
        // Get all the 'internal' Dev Detail(s)...

        self.xcgLogMsg("\(sCurrMethodDisp) 'appGlobalInfo' is [\(String(describing: appGlobalInfo))]...")

        var bAppDevWasTesting:Bool                = AppGlobalInfo.bPerformAppDevTesting
        var bAppDevIsTesting:Bool                 = AppGlobalInfo.bPerformAppDevTesting

        var bAppDevWasUserBlockedFromFaceId:Bool  = self.bIsUserBlockedFromFaceId
        var bAppDevIsUserBlockedFromFaceId:Bool   = self.bIsUserBlockedFromFaceId

        let sAppLastUsername:String               = self.sLoginUsername
        let sAppCurrentUsername:String            = self.sLoginUsername

        let sAppLastPassword:String               = self.sLoginPassword
        let sAppCurrentPassword:String            = self.sLoginPassword

        let sAppLastUserEmail:String              = self.sLoginEmail
        let sAppCurrentUserEmail:String           = self.sLoginEmail

        let sAppUploadNotifyFrom:String           = AppGlobalInfo.sAppUploadNotifyFrom

        let sGlobalAppUptime:String               = appGlobalInfo.sGlobalAppUptime
        let sGlobalSystemUptime:String            = appGlobalInfo.sGlobalSystemUptime

    //  var bObjcAppWasRunAsDev:Bool              = appGlobalInfo.
    //  var bObjcAppWasRunAsAdmin:Bool            = appGlobalInfo.
    //  var bObjcAppWasSuccessfullyLoggedIn:Bool  = appGlobalInfo.
    //
    //  let bObjcAppIsBeingRunAsDev:Bool          = appGlobalInfo.
    //  let bObjcAppIsBeingRunAsAdmin:Bool        = appGlobalInfo.
    //  let bObjcAppHasSuccessfullyLoggedIn:Bool  = appGlobalInfo.
                                                                               
        let sUIDeviceType:String                  = appGlobalInfo.sGlobalDeviceType
        let bGlobalDeviceIsMac:Bool               = appGlobalInfo.bGlobalDeviceIsMac
        let bUIDeviceIsIPad:Bool                  = appGlobalInfo.bGlobalDeviceIsIPad
        let bUIDeviceIsIPhone:Bool                = appGlobalInfo.bGlobalDeviceIsIPhone
        let bUIDeviceIsXcodeSimulator:Bool        = appGlobalInfo.bGlobalDeviceIsXcodeSimulator        
                                                                               
        let sUIDeviceName:String                  = appGlobalInfo.sGlobalDeviceName
        let sUIDeviceSystemName:String            = appGlobalInfo.sGlobalDeviceSystemName
        let sUIDeviceSystemVersion:String         = appGlobalInfo.sGlobalDeviceSystemVersion
        let sUIDeviceModel:String                 = appGlobalInfo.sGlobalDeviceModel
        let sUIDeviceLocalizedModel:String        = appGlobalInfo.sGlobalDeviceLocalizedModel

    #if os(iOS)

        let idiomUIDeviceUserInterfaceIdiom:Int   = appGlobalInfo.iGlobalDeviceUserInterfaceIdiom

    #endif

        self.xcgLogMsg("\(sCurrMethodDisp) 'bAppDevWasTesting'               is [\(String(describing: bAppDevWasTesting))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'bAppDevIsTesting'                is [\(String(describing: bAppDevIsTesting))]...")

        self.xcgLogMsg("\(sCurrMethodDisp) 'bAppDevWasUserBlockedFromFaceId' is [\(String(describing: bAppDevWasUserBlockedFromFaceId))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'bAppDevIsUserBlockedFromFaceId'  is [\(String(describing: bAppDevIsUserBlockedFromFaceId))]...")

        self.xcgLogMsg("\(sCurrMethodDisp) 'sAppLastUsername'                is [\(String(describing: sAppLastUsername))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sAppCurrentUsername'             is [\(String(describing: sAppCurrentUsername))]...")

        self.xcgLogMsg("\(sCurrMethodDisp) 'sAppLastPassword'                is [\(String(describing: sAppLastPassword))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sAppCurrentPassword'             is [\(String(describing: sAppCurrentPassword))]...")

        self.xcgLogMsg("\(sCurrMethodDisp) 'sAppLastUserEmail'               is [\(String(describing: sAppLastUserEmail))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sAppCurrentUserEmail'            is [\(String(describing: sAppCurrentUserEmail))]...")

        self.xcgLogMsg("\(sCurrMethodDisp) 'sAppUploadNotifyFrom'            is [\(String(describing: sAppUploadNotifyFrom))]...")

        self.xcgLogMsg("\(sCurrMethodDisp) 'sGlobalAppUptime'                is [\(String(describing: sGlobalAppUptime))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sGlobalSystemUptime'             is [\(String(describing: sGlobalSystemUptime))]...")

    //  self.xcgLogMsg("\(sCurrMethodDisp) 'bObjcAppWasRunAsDev'             is [\(String(describing: bObjcAppWasRunAsDev))]...")
    //  self.xcgLogMsg("\(sCurrMethodDisp) 'bObjcAppWasRunAsAdmin'           is [\(String(describing: bObjcAppWasRunAsAdmin))]...")
    //  self.xcgLogMsg("\(sCurrMethodDisp) 'bObjcAppWasSuccessfullyLoggedIn' is [\(String(describing: bObjcAppWasSuccessfullyLoggedIn))]...")
    //
    //  self.xcgLogMsg("\(sCurrMethodDisp) 'bObjcAppIsBeingRunAsDev'         is [\(String(describing: bObjcAppIsBeingRunAsDev))]...")
    //  self.xcgLogMsg("\(sCurrMethodDisp) 'bObjcAppIsBeingRunAsAdmin'       is [\(String(describing: bObjcAppIsBeingRunAsAdmin))]...")
    //  self.xcgLogMsg("\(sCurrMethodDisp) 'bObjcAppHasSuccessfullyLoggedIn' is [\(String(describing: bObjcAppHasSuccessfullyLoggedIn))]...")

        self.xcgLogMsg("\(sCurrMethodDisp) 'sUIDeviceType'                   is [\(String(describing: sUIDeviceType))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'bGlobalDeviceIsMac'              is [\(String(describing: bGlobalDeviceIsMac))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'bUIDeviceIsIPad'                 is [\(String(describing: bUIDeviceIsIPad))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'bUIDeviceIsIPhone'               is [\(String(describing: bUIDeviceIsIPhone))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'bUIDeviceIsXcodeSimulator'       is [\(String(describing: bUIDeviceIsXcodeSimulator))]...")

        self.xcgLogMsg("\(sCurrMethodDisp) 'sUIDeviceName'                   is [\(String(describing: sUIDeviceName))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sUIDeviceSystemName'             is [\(String(describing: sUIDeviceSystemName))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sUIDeviceSystemVersion'          is [\(String(describing: sUIDeviceSystemVersion))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sUIDeviceModel'                  is [\(String(describing: sUIDeviceModel))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sUIDeviceLocalizedModel'         is [\(String(describing: sUIDeviceLocalizedModel))]...")

    #if os(iOS)

        self.xcgLogMsg("\(sCurrMethodDisp) 'idiomUIDeviceUserInterfaceIdiom' is [\(String(describing: idiomUIDeviceUserInterfaceIdiom))]...")

    #endif

        // Build the AppDevDetailsItem(s) list...

        self.listAppDevDetailsItems = []

        self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "bAppDevWasTesting",
                                                             sAppDevDetailsItemDesc:    "Was 'dev' Testing?",
                                                             sAppDevDetailsItemValue:   "\(String(describing: bAppDevWasTesting))",
                                                             objAppDevDetailsItemValue: bAppDevWasTesting))

        self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "bAppDevIsTesting",
                                                             sAppDevDetailsItemDesc:    "Is 'dev' Testing?",
                                                             sAppDevDetailsItemValue:   "\(String(describing: bAppDevIsTesting))",
                                                             objAppDevDetailsItemValue: bAppDevIsTesting))
        
        self.xcgLogMsg("\(sCurrMethodDisp) 'bAppDevWasUserBlockedFromFaceId' is [\(String(describing: bAppDevWasUserBlockedFromFaceId))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'bAppDevIsUserBlockedFromFaceId'  is [\(String(describing: bAppDevIsUserBlockedFromFaceId))]...")

        self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "sAppLastUsername",
                                                             sAppDevDetailsItemDesc:    "'last' Username:",
                                                             sAppDevDetailsItemValue:   "\(String(describing: sAppLastUsername))",
                                                             objAppDevDetailsItemValue: sAppLastUsername))

        self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "sAppCurrentUsername",
                                                             sAppDevDetailsItemDesc:    "'current' Username:",
                                                             sAppDevDetailsItemValue:   "\(String(describing: sAppCurrentUsername))",
                                                             objAppDevDetailsItemValue: sAppCurrentUsername))

        self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "sAppLastPassword",
                                                             sAppDevDetailsItemDesc:    "'last' Password:",
                                                             sAppDevDetailsItemValue:   "\(String(describing: sAppLastPassword))",
                                                             objAppDevDetailsItemValue: sAppLastPassword))

        self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "sAppCurrentPassword",
                                                             sAppDevDetailsItemDesc:    "'current' Password:",
                                                             sAppDevDetailsItemValue:   "\(String(describing: sAppCurrentPassword))",
                                                             objAppDevDetailsItemValue: sAppCurrentPassword))

        self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "sAppLastUserEmail",
                                                             sAppDevDetailsItemDesc:    "'last' User Email:",
                                                             sAppDevDetailsItemValue:   "\(String(describing: sAppLastUserEmail))",
                                                             objAppDevDetailsItemValue: sAppLastUserEmail))

        self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "sAppCurrentUserEmail",
                                                             sAppDevDetailsItemDesc:    "'current' User Email:",
                                                             sAppDevDetailsItemValue:   "\(String(describing: sAppCurrentUserEmail))",
                                                             objAppDevDetailsItemValue: sAppCurrentUserEmail))

        self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "sAppUploadNotifyFrom",
                                                             sAppDevDetailsItemDesc:    "'notify' From Email:",
                                                             sAppDevDetailsItemValue:   "\(String(describing: sAppUploadNotifyFrom))",
                                                             objAppDevDetailsItemValue: sAppUploadNotifyFrom))

        self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "sGlobalAppUptime",
                                                             sAppDevDetailsItemDesc:    "'app' Uptime:",
                                                             sAppDevDetailsItemValue:   "\(String(describing: sGlobalAppUptime))",
                                                             objAppDevDetailsItemValue: sGlobalAppUptime))

        self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "sGlobalSystemUptime",
                                                             sAppDevDetailsItemDesc:    "'global' System Uptime:",
                                                             sAppDevDetailsItemValue:   "\(String(describing: sGlobalSystemUptime))",
                                                             objAppDevDetailsItemValue: sGlobalSystemUptime))

    //  self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "bObjcAppWasRunAsDev",
    //                                                       sAppDevDetailsItemDesc:    "Was Run as 'dev'?",
    //                                                       sAppDevDetailsItemValue:   "\(String(describing: bObjcAppWasRunAsDev))",
    //                                                       objAppDevDetailsItemValue: bObjcAppWasRunAsDev))
    //
    //  self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "bObjcAppWasRunAsAdmin",
    //                                                       sAppDevDetailsItemDesc:    "Was Run as 'admin'?",
    //                                                       sAppDevDetailsItemValue:   "\(String(describing: bObjcAppWasRunAsAdmin))",
    //                                                       objAppDevDetailsItemValue: bObjcAppWasRunAsAdmin))
    //
    //  self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "bObjcAppWasSuccessfullyLoggedIn",
    //                                                       sAppDevDetailsItemDesc:    "Was Successfully 'logged' In?",
    //                                                       sAppDevDetailsItemValue:   "\(String(describing: bObjcAppWasSuccessfullyLoggedIn))",
    //                                                       objAppDevDetailsItemValue: bObjcAppWasSuccessfullyLoggedIn))
    //
    //  self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "bObjcAppIsBeingRunAsDev",
    //                                                       sAppDevDetailsItemDesc:    "Running as 'dev'?",
    //                                                       sAppDevDetailsItemValue:   "\(String(describing: bObjcAppIsBeingRunAsDev))",
    //                                                       objAppDevDetailsItemValue: bObjcAppIsBeingRunAsDev))
    //
    //  self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "bObjcAppIsBeingRunAsAdmin",
    //                                                       sAppDevDetailsItemDesc:    "Running as 'admin'?",
    //                                                       sAppDevDetailsItemValue:   "\(String(describing: bObjcAppIsBeingRunAsAdmin))",
    //                                                       objAppDevDetailsItemValue: bObjcAppIsBeingRunAsAdmin))
    //
    //  self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "bObjcAppHasSuccessfullyLoggedIn",
    //                                                       sAppDevDetailsItemDesc:    "Successfully 'logged' In?",
    //                                                       sAppDevDetailsItemValue:   "\(String(describing: bObjcAppHasSuccessfullyLoggedIn))",
    //                                                       objAppDevDetailsItemValue: bObjcAppHasSuccessfullyLoggedIn))

        self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "sUIDeviceType",
                                                             sAppDevDetailsItemDesc:    "Device 'type':",
                                                             sAppDevDetailsItemValue:   "\(String(describing: sUIDeviceType))",
                                                             objAppDevDetailsItemValue: sUIDeviceType))

        self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "bGlobalDeviceIsMac",
                                                             sAppDevDetailsItemDesc:    "Device is 'Mac'?",
                                                             sAppDevDetailsItemValue:   "\(String(describing: bGlobalDeviceIsMac))",
                                                             objAppDevDetailsItemValue: bGlobalDeviceIsMac))

        self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "bUIDeviceIsIPad",
                                                             sAppDevDetailsItemDesc:    "Device is 'iPad'?",
                                                             sAppDevDetailsItemValue:   "\(String(describing: bUIDeviceIsIPad))",
                                                             objAppDevDetailsItemValue: bUIDeviceIsIPad))

        self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "bUIDeviceIsIPhone",
                                                             sAppDevDetailsItemDesc:    "Device is 'iPhone'?",
                                                             sAppDevDetailsItemValue:   "\(String(describing: bUIDeviceIsIPhone))",
                                                             objAppDevDetailsItemValue: bUIDeviceIsIPhone))

        self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "bUIDeviceIsXcodeSimulator",
                                                             sAppDevDetailsItemDesc:    "Device is Xcode 'Simulator'?",
                                                             sAppDevDetailsItemValue:   "\(String(describing: bUIDeviceIsXcodeSimulator))",
                                                             objAppDevDetailsItemValue: bUIDeviceIsXcodeSimulator))

        self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "sUIDeviceName",
                                                             sAppDevDetailsItemDesc:    "Device 'name':",
                                                             sAppDevDetailsItemValue:   "\(String(describing: sUIDeviceName))",
                                                             objAppDevDetailsItemValue: sUIDeviceName))

        self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "sUIDeviceSystemName",
                                                             sAppDevDetailsItemDesc:    "Device System 'name':",
                                                             sAppDevDetailsItemValue:   "\(String(describing: sUIDeviceSystemName))",
                                                             objAppDevDetailsItemValue: sUIDeviceSystemName))

        self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "sUIDeviceSystemVersion",
                                                             sAppDevDetailsItemDesc:    "Device System 'version':",
                                                             sAppDevDetailsItemValue:   "\(String(describing: sUIDeviceSystemVersion))",
                                                             objAppDevDetailsItemValue: sUIDeviceSystemVersion))

        self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "sUIDeviceModel",
                                                             sAppDevDetailsItemDesc:    "Device 'model':",
                                                             sAppDevDetailsItemValue:   "\(String(describing: sUIDeviceModel))",
                                                             objAppDevDetailsItemValue: sUIDeviceModel))

        self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "sUIDeviceLocalizedModel",
                                                             sAppDevDetailsItemDesc:    "Device Localized 'model':",
                                                             sAppDevDetailsItemValue:   "\(String(describing: sUIDeviceLocalizedModel))",
                                                             objAppDevDetailsItemValue: sUIDeviceLocalizedModel))

    #if os(iOS)

        self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "idiomUIDeviceUserInterfaceIdiom",
                                                             sAppDevDetailsItemDesc:    "Device User 'interface' Idiom:",
                                                             sAppDevDetailsItemValue:   "\(String(describing: idiomUIDeviceUserInterfaceIdiom))",
                                                             objAppDevDetailsItemValue: idiomUIDeviceUserInterfaceIdiom))

    #endif

        // Exit...

        self.xcgLogMsg("\(ClassInfo.sClsDisp)\(sCurrMethodDisp) Exiting...")
        
        return

    }   // End of public func updateAppDevDetailsItemList().
    
}   // End of class AppDevDetailsModelObservable:NSObject, ObservableObject.

// ----------------------------------------------------------------------------------------------------------
//
//  NOTE: The version below uses the 'objcVVObjCSwiftEnvBridge'...
//
//  public func updateAppDevDetailsItemList()
//  {
//      
//      let sCurrMethod:String = #function
//      let sCurrMethodDisp    = "'"+sCurrMethod+"'"
//      
//      self.xcgLogMsg("\(ClassInfo.sClsDisp)\(sCurrMethodDisp) Invoked...")
//      
//      // Get all the 'internal' Dev Detail(s)...
//
//      let appDelegate:AppDelegate? = UIApplication.shared.delegate as? AppDelegate
//
//      if (appDelegate == nil) 
//      {
//
//          self.xcgLogMsg("\(sCurrMethodDisp) 'UIApplication.shared.delegate' is [\(String(describing: UIApplication.shared.delegate))] - Error!")
//          self.xcgLogMsg("\(sCurrMethodDisp) exiting...")
//
//          return
//
//      }
//
//      self.xcgLogMsg("\(sCurrMethodDisp) 'UIApplication.shared.delegate' is [\(String(describing: UIApplication.shared.delegate))]...")
//
//      let objcVVObjCSwiftEnvBridge = appDelegate?.getVVObjCSwiftEnvBridge()
//
//      if (objcVVObjCSwiftEnvBridge == nil) 
//      {
//
//          let sErrorMsg:String = "\(sCurrMethodDisp) 'appDelegate._objVVObjCSwiftEnvBridge' is [\(String(describing: objcVVObjCSwiftEnvBridge))] - Fatal Error!"
//
//          self.xcgLogMsg(sErrorMsg)
//          self.xcgLogMsg("\(sCurrMethodDisp) exiting...")
//
//          return
//
//      }
//
//      self.xcgLogMsg("\(sCurrMethodDisp) 'appDelegate._objVVObjCSwiftEnvBridge' is [\(String(describing: objcVVObjCSwiftEnvBridge))]...")
//
//      var bAppDevWasTesting:Bool                = (objcVVObjCSwiftEnvBridge?.getAppDevWasTesting())!
//      var bAppDevIsTesting:Bool                 = (objcVVObjCSwiftEnvBridge?.getAppDevIsTesting())!
//
//      let sAppLastUsername:String               = (objcVVObjCSwiftEnvBridge?.getAppLastUsername())!
//      let sAppCurrentUsername:String            = (objcVVObjCSwiftEnvBridge?.getAppCurrentUsername())!
//
//      let sAppLastUserEmail:String              = (objcVVObjCSwiftEnvBridge?.getAppLastUserEmail())!
//      let sAppCurrentUserEmail:String           = (objcVVObjCSwiftEnvBridge?.getAppCurrentUserEmail())!
//
//      var bObjcAppWasRunAsDev:Bool              = (objcVVObjCSwiftEnvBridge?.getObjCAppWasBeingRunAsDev())!
//      var bObjcAppWasRunAsAdmin:Bool            = (objcVVObjCSwiftEnvBridge?.getObjCAppWasBeingRunAsAdmin())!
//      var bObjcAppWasSuccessfullyLoggedIn:Bool  = (objcVVObjCSwiftEnvBridge?.getObjCAppWasSuccessfullyLoggedIn())!
//
//      let bObjcAppIsBeingRunAsDev:Bool          = (objcVVObjCSwiftEnvBridge?.getObjCAppIsBeingRunAsDev())!            
//      let bObjcAppIsBeingRunAsAdmin:Bool        = (objcVVObjCSwiftEnvBridge?.getObjCAppIsBeingRunAsAdmin())!          
//      let bObjcAppHasSuccessfullyLoggedIn:Bool  = (objcVVObjCSwiftEnvBridge?.getObjCAppHasSuccessfullyLoggedIn())!    
//                                                                                                                      
//      let sUIDeviceType:NSString                = (objcVVObjCSwiftEnvBridge?.getUIDeviceType())! as NSString          
//      let bUIDeviceIsIPad:Bool                  = (objcVVObjCSwiftEnvBridge?.getUIDeviceIsIPad())!                    
//      let bUIDeviceIsIPhone:Bool                = (objcVVObjCSwiftEnvBridge?.getUIDeviceIsIPhone())!                  
//      let bUIDeviceIsXcodeSimulator:Bool        = (objcVVObjCSwiftEnvBridge?.getUIDeviceIsXcodeSimulator())!                  
//                                                                                                                      
//      let sUIDeviceName:NSString                = (objcVVObjCSwiftEnvBridge?.getUIDeviceName())! as NSString          
//      let sUIDeviceSystemName:NSString          = (objcVVObjCSwiftEnvBridge?.getUIDeviceSystemName())! as NSString    
//      let sUIDeviceSystemVersion:NSString       = (objcVVObjCSwiftEnvBridge?.getUIDeviceSystemVersion())! as NSString 
//      let sUIDeviceModel:NSString               = (objcVVObjCSwiftEnvBridge?.getUIDeviceModel())! as NSString         
//      let sUIDeviceLocalizedModel:NSString      = (objcVVObjCSwiftEnvBridge?.getUIDeviceLocalizedModel())! as NSString
//      let idiomUIDeviceUserInterfaceIdiom:Int32 = (objcVVObjCSwiftEnvBridge?.getUIDeviceUserInterfaceIdiom())!
//
//      self.xcgLogMsg("\(sCurrMethodDisp) 'bAppDevWasTesting'               is [\(String(describing: bAppDevWasTesting))]...")
//      self.xcgLogMsg("\(sCurrMethodDisp) 'bAppDevIsTesting'                is [\(String(describing: bAppDevIsTesting))]...")
//
//      self.xcgLogMsg("\(sCurrMethodDisp) 'sAppLastUsername'                is [\(String(describing: sAppLastUsername))]...")
//      self.xcgLogMsg("\(sCurrMethodDisp) 'sAppCurrentUsername'             is [\(String(describing: sAppCurrentUsername))]...")
//
//      self.xcgLogMsg("\(sCurrMethodDisp) 'sAppLastUserEmail'               is [\(String(describing: sAppLastUserEmail))]...")
//      self.xcgLogMsg("\(sCurrMethodDisp) 'sAppCurrentUserEmail'            is [\(String(describing: sAppCurrentUserEmail))]...")
//
//      self.xcgLogMsg("\(sCurrMethodDisp) 'bObjcAppWasRunAsDev'             is [\(String(describing: bObjcAppWasRunAsDev))]...")
//      self.xcgLogMsg("\(sCurrMethodDisp) 'bObjcAppWasRunAsAdmin'           is [\(String(describing: bObjcAppWasRunAsAdmin))]...")
//      self.xcgLogMsg("\(sCurrMethodDisp) 'bObjcAppWasSuccessfullyLoggedIn' is [\(String(describing: bObjcAppWasSuccessfullyLoggedIn))]...")
//
//      self.xcgLogMsg("\(sCurrMethodDisp) 'bObjcAppIsBeingRunAsDev'         is [\(String(describing: bObjcAppIsBeingRunAsDev))]...")
//      self.xcgLogMsg("\(sCurrMethodDisp) 'bObjcAppIsBeingRunAsAdmin'       is [\(String(describing: bObjcAppIsBeingRunAsAdmin))]...")
//      self.xcgLogMsg("\(sCurrMethodDisp) 'bObjcAppHasSuccessfullyLoggedIn' is [\(String(describing: bObjcAppHasSuccessfullyLoggedIn))]...")
//
//      self.xcgLogMsg("\(sCurrMethodDisp) 'sUIDeviceType'                   is [\(String(describing: sUIDeviceType))]...")
//      self.xcgLogMsg("\(sCurrMethodDisp) 'bUIDeviceIsIPad'                 is [\(String(describing: bUIDeviceIsIPad))]...")
//      self.xcgLogMsg("\(sCurrMethodDisp) 'bUIDeviceIsIPhone'               is [\(String(describing: bUIDeviceIsIPhone))]...")
//      self.xcgLogMsg("\(sCurrMethodDisp) 'bUIDeviceIsXcodeSimulator'       is [\(String(describing: bUIDeviceIsXcodeSimulator))]...")
//
//      self.xcgLogMsg("\(sCurrMethodDisp) 'sUIDeviceName'                   is [\(String(describing: sUIDeviceName))]...")
//      self.xcgLogMsg("\(sCurrMethodDisp) 'sUIDeviceSystemName'             is [\(String(describing: sUIDeviceSystemName))]...")
//      self.xcgLogMsg("\(sCurrMethodDisp) 'sUIDeviceSystemVersion'          is [\(String(describing: sUIDeviceSystemVersion))]...")
//      self.xcgLogMsg("\(sCurrMethodDisp) 'sUIDeviceModel'                  is [\(String(describing: sUIDeviceModel))]...")
//      self.xcgLogMsg("\(sCurrMethodDisp) 'sUIDeviceLocalizedModel'         is [\(String(describing: sUIDeviceLocalizedModel))]...")
//      self.xcgLogMsg("\(sCurrMethodDisp) 'idiomUIDeviceUserInterfaceIdiom' is [\(String(describing: idiomUIDeviceUserInterfaceIdiom))]...")
//
//      // Build the AppDevDetailsItem(s) list...
//
//      self.listAppDevDetailsItems = []
//
//      self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "bAppDevWasTesting",
//                                                           sAppDevDetailsItemDesc:    "Was 'dev' Testing?",
//                                                           sAppDevDetailsItemValue:   "\(String(describing: bAppDevWasTesting))",
//                                                           objAppDevDetailsItemValue: bAppDevWasTesting))
//
//      self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "bAppDevIsTesting",
//                                                           sAppDevDetailsItemDesc:    "Is 'dev' Testing?",
//                                                           sAppDevDetailsItemValue:   "\(String(describing: bAppDevIsTesting))",
//                                                           objAppDevDetailsItemValue: bAppDevIsTesting))
//      
//      self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "sAppLastUsername",
//                                                           sAppDevDetailsItemDesc:    "'last' Username:",
//                                                           sAppDevDetailsItemValue:   "\(String(describing: sAppLastUsername))",
//                                                           objAppDevDetailsItemValue: sAppLastUsername))
//
//      self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "sAppCurrentUsername",
//                                                           sAppDevDetailsItemDesc:    "'current' Username:",
//                                                           sAppDevDetailsItemValue:   "\(String(describing: sAppCurrentUsername))",
//                                                           objAppDevDetailsItemValue: sAppCurrentUsername))
//
//      self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "sAppLastUserEmail",
//                                                           sAppDevDetailsItemDesc:    "'last' User Email:",
//                                                           sAppDevDetailsItemValue:   "\(String(describing: sAppLastUserEmail))",
//                                                           objAppDevDetailsItemValue: sAppLastUserEmail))
//
//      self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "sAppCurrentUserEmail",
//                                                           sAppDevDetailsItemDesc:    "'current' User Email:",
//                                                           sAppDevDetailsItemValue:   "\(String(describing: sAppCurrentUserEmail))",
//                                                           objAppDevDetailsItemValue: sAppCurrentUserEmail))
//
//      self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "bObjcAppWasRunAsDev",
//                                                           sAppDevDetailsItemDesc:    "Was Run as 'dev'?",
//                                                           sAppDevDetailsItemValue:   "\(String(describing: bObjcAppWasRunAsDev))",
//                                                           objAppDevDetailsItemValue: bObjcAppWasRunAsDev))
//
//      self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "bObjcAppWasRunAsAdmin",
//                                                           sAppDevDetailsItemDesc:    "Was Run as 'admin'?",
//                                                           sAppDevDetailsItemValue:   "\(String(describing: bObjcAppWasRunAsAdmin))",
//                                                           objAppDevDetailsItemValue: bObjcAppWasRunAsAdmin))
//
//      self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "bObjcAppWasSuccessfullyLoggedIn",
//                                                           sAppDevDetailsItemDesc:    "Was Successfully 'logged' In?",
//                                                           sAppDevDetailsItemValue:   "\(String(describing: bObjcAppWasSuccessfullyLoggedIn))",
//                                                           objAppDevDetailsItemValue: bObjcAppWasSuccessfullyLoggedIn))
//
//      self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "bObjcAppIsBeingRunAsDev",
//                                                           sAppDevDetailsItemDesc:    "Running as 'dev'?",
//                                                           sAppDevDetailsItemValue:   "\(String(describing: bObjcAppIsBeingRunAsDev))",
//                                                           objAppDevDetailsItemValue: bObjcAppIsBeingRunAsDev))
//
//      self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "bObjcAppIsBeingRunAsAdmin",
//                                                           sAppDevDetailsItemDesc:    "Running as 'admin'?",
//                                                           sAppDevDetailsItemValue:   "\(String(describing: bObjcAppIsBeingRunAsAdmin))",
//                                                           objAppDevDetailsItemValue: bObjcAppIsBeingRunAsAdmin))
//
//      self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "bObjcAppHasSuccessfullyLoggedIn",
//                                                           sAppDevDetailsItemDesc:    "Successfully 'logged' In?",
//                                                           sAppDevDetailsItemValue:   "\(String(describing: bObjcAppHasSuccessfullyLoggedIn))",
//                                                           objAppDevDetailsItemValue: bObjcAppHasSuccessfullyLoggedIn))
//
//      self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "sUIDeviceType",
//                                                           sAppDevDetailsItemDesc:    "Device 'type':",
//                                                           sAppDevDetailsItemValue:   "\(String(describing: sUIDeviceType))",
//                                                           objAppDevDetailsItemValue: sUIDeviceType))
//
//      self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "bUIDeviceIsIPad",
//                                                           sAppDevDetailsItemDesc:    "Device is 'iPad'?",
//                                                           sAppDevDetailsItemValue:   "\(String(describing: bUIDeviceIsIPad))",
//                                                           objAppDevDetailsItemValue: bUIDeviceIsIPad))
//
//      self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "bUIDeviceIsIPhone",
//                                                           sAppDevDetailsItemDesc:    "Device is 'iPhone'?",
//                                                           sAppDevDetailsItemValue:   "\(String(describing: bUIDeviceIsIPhone))",
//                                                           objAppDevDetailsItemValue: bUIDeviceIsIPhone))
//
//      self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "bUIDeviceIsXcodeSimulator",
//                                                           sAppDevDetailsItemDesc:    "Device is Xcode 'Simulator'?",
//                                                           sAppDevDetailsItemValue:   "\(String(describing: bUIDeviceIsXcodeSimulator))",
//                                                           objAppDevDetailsItemValue: bUIDeviceIsXcodeSimulator))
//
//      self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "sUIDeviceName",
//                                                           sAppDevDetailsItemDesc:    "Device 'name':",
//                                                           sAppDevDetailsItemValue:   "\(String(describing: sUIDeviceName))",
//                                                           objAppDevDetailsItemValue: sUIDeviceName))
//
//      self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "sUIDeviceSystemName",
//                                                           sAppDevDetailsItemDesc:    "Device System 'name':",
//                                                           sAppDevDetailsItemValue:   "\(String(describing: sUIDeviceSystemName))",
//                                                           objAppDevDetailsItemValue: sUIDeviceSystemName))
//
//      self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "sUIDeviceSystemVersion",
//                                                           sAppDevDetailsItemDesc:    "Device System 'version':",
//                                                           sAppDevDetailsItemValue:   "\(String(describing: sUIDeviceSystemVersion))",
//                                                           objAppDevDetailsItemValue: sUIDeviceSystemVersion))
//
//      self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "sUIDeviceModel",
//                                                           sAppDevDetailsItemDesc:    "Device 'model':",
//                                                           sAppDevDetailsItemValue:   "\(String(describing: sUIDeviceModel))",
//                                                           objAppDevDetailsItemValue: sUIDeviceModel))
//
//      self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "sUIDeviceLocalizedModel",
//                                                           sAppDevDetailsItemDesc:    "Device Localized 'model':",
//                                                           sAppDevDetailsItemValue:   "\(String(describing: sUIDeviceLocalizedModel))",
//                                                           objAppDevDetailsItemValue: sUIDeviceLocalizedModel))
//
//      self.listAppDevDetailsItems.append(AppDevDetailsItem(sAppDevDetailsItemName:    "idiomUIDeviceUserInterfaceIdiom",
//                                                           sAppDevDetailsItemDesc:    "Device User 'interface' Idiom:",
//                                                           sAppDevDetailsItemValue:   "\(String(describing: idiomUIDeviceUserInterfaceIdiom))",
//                                                           objAppDevDetailsItemValue: idiomUIDeviceUserInterfaceIdiom))
//
//      // Exit...
//
//      self.xcgLogMsg("\(ClassInfo.sClsDisp)\(sCurrMethodDisp) Exiting...")
//      
//      return
//
//  }   // End of public func updateAppDevDetailsItemList().
//
// ----------------------------------------------------------------------------------------------------------

