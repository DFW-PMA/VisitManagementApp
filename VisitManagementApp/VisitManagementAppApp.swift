//
//  VisitManagementAppApp.swift
//  VisitManagementApp
//
//  Created by Daryl Cox on 07/19/2024.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftData

@main
struct VisitManagementAppApp: App 
{
    
    struct ClassInfo
    {
        
        static let sClsId        = "VisitManagementAppApp"
        static let sClsVers      = "v1.2307"
        static let sClsDisp      = sClsId+".("+sClsVers+"): "
        static let sClsCopyRight = "Copyright (C) JustMacApps 2023-2025. All Rights Reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }

    // AppDelegate:
    //     (NOTE: This causes the AppDelegate class to instantiate
    //            - use this ONLY once in an App or it will cause multiple instantiation(s) of AppDelegate...

#if os(macOS)
    @NSApplicationDelegateAdaptor(VisitManagementAppNSAppDelegate.self)
    var appDelegate
#elseif os(iOS)
    @UIApplicationDelegateAdaptor(VisitManagementAppUIAppDelegate.self)
    var appDelegate
#endif

    // App Data field(s):

                    let sAppBundlePath:String                       = Bundle.main.bundlePath

    @State          var uuid4ForcingViewRefresh:UUID                = UUID()

                    var appGlobalInfo:AppGlobalInfo                 = AppGlobalInfo.ClassSingleton.appGlobalInfo
                    var jmAppDelegateVisitor:JmAppDelegateVisitor   = JmAppDelegateVisitor.ClassSingleton.appDelegateVisitor
    @ObservedObject var jmAppParseCoreManager:JmAppParseCoreManager = JmAppParseCoreManager.ClassSingleton.appParseCodeManager

    @State private  var appGlobalDeviceType:AppGlobalDeviceType     = AppGlobalDeviceType.appGlobalDeviceUndefined
    
    init()
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        _appGlobalDeviceType   = State(initialValue:appGlobalInfo.iGlobalDeviceType)
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Exit...

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of init().

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

    var body: some Scene 
    {
        
        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):body(some Scene) - 'sAppBundlePath' is [\(sAppBundlePath)]...")
        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):body(some Scene) - 'appGlobalDeviceType' is (\(String(describing:appGlobalDeviceType)))...")
        
        WindowGroup
        {
            
            AppAuthenticateView(uuid4ForcingViewRefresh:$uuid4ForcingViewRefresh)
                .id(uuid4ForcingViewRefresh)                    // This is the key to forcing a complete 'refresh'...
                .navigationTitle(AppGlobalInfo.sGlobalInfoAppId)
                .onOpenURL(perform:
                { url in
                    self.xcgLogMsg("\(ClassInfo.sClsDisp):AuthenticateView.onOpenURL() performed for the URL of [\(url)]...")
                })
                .environment(\.appGlobalDeviceType, appGlobalDeviceType)
            
        }
        .handlesExternalEvents(matching: [])
#if os(macOS)
        .commands
        {
            
            AppInfoCommands()
            
            HelpCommands()
            
        }
#endif
        
#if os(macOS)
        Settings
        {
            
            SettingsSingleView()
            
        }
#endif
        
#if os(macOS)
        // This is the Window to diaplay the AppWorkRouteView...this works from MacOS...
        
        Window("AppWorkRoute", id:"AppWorkRouteView")
        {
            
            AppWorkRouteView()
            
        }
        
        // This is the Window to diaplay the AppWorkRouteMapView...this works from MacOS...
        
        WindowGroup("AppWorkRouteMap", id:"AppWorkRouteMapView", for: UUID.self)
        { $uuid in
            
            AppWorkRouteMapView(parsePFCscDataItem:jmAppParseCoreManager.locatePFCscDataItemByID(id:uuid ?? UUID()))
            
        }

        Window("AppSchedPatLoc", id:"AppSchedPatLocView")
        {
            
            AppSchedPatLocView()
            
        }
        
    //  // This is the Window to diaplay the AppSchedPatLocMapView...this works from MacOS...
    //  
    //  WindowGroup("AppSchedPatLocMap", id:"AppSchedPatLocMapView", for: UUID.self)
    //  { $uuid in
    //      
    //      AppSchedPatLocMapView(parsePFCscDataItem:jmAppParseCoreManager.locatePFCscDataItemByID(id:uuid ?? UUID()))
    //      
    //  }

        // This is the Window to diaplay the AppTidScheduleView...this works from MacOS...

        Window("AppTidSchedule", id:"AppTidScheduleView")
        {

            AppTidScheduleView(listScheduledPatientLocationItems: [])

        }

        // This is the Window to diaplay the AppWorkRouteView...this works from MacOS...

        Window("AppVisitMgmt", id:"AppVisitMgmtView")
        {

            AppVisitMgmtView()

        }

        // This is the Window to diaplay the AppVisitMgmtCoreLocMapView...this works from MacOS...
        
        Window("AppVisitMgmtCoreLocMap", id: "AppVisitMgmtCoreLocMapView")
        {
            AppVisitMgmtCoreLocMapContainer()
        }
        
    //  Window("AppVisitMgmtCoreLocMap", id: "AppVisitMgmtCoreLocMapView", for: [String: String].self)
    //  { dictBinding in
    //          AppVisitMgmtCoreLocMapView(sCoreLocLatLong:dictBinding.wrappedValue["sCoreLocLatLong"] ?? "0.000000,0.000000",
    //                                     sCoreLocAddress:dictBinding.wrappedValue["sCoreLocAddress"] ?? "-N/A-")
    //  }
#endif
        
    }
    
}   // End of struct VisitManagementAppApp(App). 

