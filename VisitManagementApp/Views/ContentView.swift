//
//  ContentView.swift
//  VisitManagementApp
//
//  Created by Daryl Cox on 07/19/2024.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftData

struct ContentView: View 
{
    
    struct ClassInfo
    {
        
        static let sClsId        = "ContentView"
        static let sClsVers      = "v1.4001"
        static let sClsDisp      = sClsId+"(.swift).("+sClsVers+"):"
        static let sClsCopyRight = "Copyright (C) JustMacApps 2023-2025. All Rights Reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }

    @Environment(\.openWindow)   var openWindow
    @Environment(\.openURL)      var openURL

    // App Data field(s):

    @Binding       var isUserLoggedIn:Bool 
    @Binding       var sLoginUsername:String
    @Binding       var sLoginPassword:String

#if os(iOS)

    @State private var cAppViewSettingsButtonPresses:Int         = 0
    
    @State private var isAppSettingsModal:Bool                   = false

#endif

//  @State private var sTherapistTID:String                      = ""
    
    @State private var cAppLogPFDataButtonPresses:Int            = 0
    @State private var cAppSchedExportViewButtonPresses:Int      = 0
    @State private var cAppSchedExportAuditViewButtonPresses:Int = 0
    @State private var cAppRefreshButtonPresses:Int              = 0
    @State private var cAppDataButtonPresses:Int                 = 0
    @State private var cAppWorkRouteButtonPresses:Int            = 0
    @State private var cAppSchedPatLocButtonPresses:Int          = 0

    @State private var isAppLogPFDataViewModal:Bool              = false
    @State private var isAppSchedExportByTidShowing:Bool         = false
    @State private var isAppSchedExportAuditShowing:Bool         = false
    @State private var isAppDataViewModal:Bool                   = false
    @State private var isAppWorkRouteViewModal:Bool              = false
    @State private var isAppSchedPatLocViewModal:Bool            = false

    @State private var shouldContentViewChange:Bool              = false
    @State private var shouldContentViewShowAlert:Bool           = false

                   var jmAppDelegateVisitor:JmAppDelegateVisitor = JmAppDelegateVisitor.ClassSingleton.appDelegateVisitor
    
    init(isUserLoggedIn: Binding<Bool>, sLoginUsername: Binding<String>, sLoginPassword: Binding<String>)
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        // Handle inbound parameter(s) before any 'self.' references...

        _isUserLoggedIn = isUserLoggedIn
        _sLoginUsername = sLoginUsername
        _sLoginPassword = sLoginPassword

        // Continue with 'init()'...
        
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

    var body: some View 
    {

        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):body(some Scene) \(JmXcodeBuildSettings.jmAppVersionAndBuildNumber)...")
        
        VStack 
        {
            
            HStack
            {

                Button
                {

                    self.cAppSchedExportViewButtonPresses += 1

                    let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppTidScheduleView.Button(Xcode).'Sched Export'.#(\(self.cAppSchedExportViewButtonPresses)) for TID 'self.sTherapistTID' of [-1]...")

                    self.isAppSchedExportByTidShowing.toggle()

                }
                label:
                {

                    VStack(alignment:.center)
                    {

                        Label("", systemImage: "rectangle.expand.vertical")
                            .help(Text("Export the Schedule by TID View..."))
                            .imageScale(.medium)

                        Text("Schedule Export")
                            .font(.caption)

                    }

                }
            #if os(macOS)
                .sheet(isPresented:$isAppSchedExportByTidShowing, content:
                    {

                        AppVisitMgmtSchedule1ExportView(sTherapistTID:"-1")

                    }
                )
            #endif
            #if os(iOS)
                .fullScreenCover(isPresented:$isAppSchedExportByTidShowing)
                {

                    AppVisitMgmtSchedule1ExportView(sTherapistTID:"-1")

                }
            #endif
                .padding()
            #if os(macOS)
                .buttonStyle(.borderedProminent)
                .padding()
            //  .background(???.isPressed ? .blue : .gray)
                .cornerRadius(10)
                .foregroundColor(Color.primary)
            #endif

                Spacer()

                Button
                {

                    self.cAppSchedExportAuditViewButtonPresses += 1

                    let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppTidScheduleView.Button(Xcode).'Audit Sched Export'.#(\(self.cAppSchedExportAuditViewButtonPresses))...")

                    self.isAppSchedExportAuditShowing.toggle()

                }
                label:
                {

                    VStack(alignment:.center)
                    {

                        Label("", systemImage: "checkmark.rectangle")
                            .help(Text("Audit the Schedule Export data..."))
                            .imageScale(.medium)

                        Text("Audit Export")
                            .font(.caption)

                    }

                }
            #if os(macOS)
                .sheet(isPresented:$isAppSchedExportAuditShowing, content:
                    {

                        AppVisitMgmtExportAudit1DetailsView()

                    }
                )
            #endif
            #if os(iOS)
                .fullScreenCover(isPresented:$isAppSchedExportAuditShowing)
                {

                    AppVisitMgmtExportAudit1DetailsView()

                }
            #endif
                .padding()
            #if os(macOS)
                .buttonStyle(.borderedProminent)
                .padding()
            //  .background(???.isPressed ? .blue : .gray)
                .cornerRadius(10)
                .foregroundColor(Color.primary)
            #endif

                Spacer()

                Button
                {

                    self.cAppRefreshButtonPresses += 1

                    let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)ContentView.Button(Xcode).'Refresh'.#(\(self.cAppRefreshButtonPresses))...")

                }
                label:
                {

                    VStack(alignment:.center)
                    {

                        Label("", systemImage: "arrow.clockwise")
                            .help(Text("'Refresh' App Screen..."))
                            .imageScale(.large)

                        Text("Refresh Screen - #(\(self.cAppRefreshButtonPresses))...")
                            .font(.caption)

                    }

                }
            #if os(macOS)
                .buttonStyle(.borderedProminent)
                .padding()
            //  .background(???.isPressed ? .blue : .gray)
                .cornerRadius(10)
                .foregroundColor(Color.primary)
            #endif

                Spacer()

            #if os(iOS)

                Button
                {

                    self.cAppViewSettingsButtonPresses += 1

                    let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)ContentView.Button(Xcode).'Settings'.#(\(self.cAppViewSettingsButtonPresses))...")

                    self.isAppSettingsModal.toggle()

                }
                label:
                {

                    VStack(alignment:.center)
                    {

                        Label("", systemImage: "gearshape")
                            .help(Text("App Settings"))
                            .imageScale(.large)

                        Text("Settings")
                            .font(.caption)

                    }

                }
            #if os(macOS)
                .sheet(isPresented:$isAppSettingsModal, content:
                    {

                        SettingsSingleView()

                    }
                )
            #elseif os(iOS)
                .fullScreenCover(isPresented:$isAppSettingsModal)
                {

                    SettingsSingleView()

                }
            #endif
                .padding()

            #endif

            }
            
            Spacer(minLength:10)

        if #available(iOS 17.0, *)
        {

            Image(ImageResource(name: "Gfx/AppIcon", bundle: Bundle.main))
                .resizable()
                .scaledToFit()
                .containerRelativeFrame(.horizontal)
                    { size, axis in
                        size * 0.15
                    }

        }
        else
        {

            Image(ImageResource(name: "Gfx/AppIcon", bundle: Bundle.main))
                .resizable()
                .scaledToFit()
                .frame(width:75, height: 75, alignment:.center)

        }
            
            Spacer(minLength: 10)
            
            Text("--- [\(AppGlobalInfo.sGlobalInfoAppId)] ---")
                .onReceive(jmAppDelegateVisitor.$isAppDelegateVisitorShowingAlert,
                    perform:
                    { bShow in
                        if (bShow == true)
                        {
                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onReceive #1 - Received a 'show' Alert...")
                            shouldContentViewShowAlert                            = true
                            jmAppDelegateVisitor.isAppDelegateVisitorShowingAlert = false
                        }
                    })
                .alert("\(jmAppDelegateVisitor.sAppDelegateVisitorGlobalAlertMessage ?? "")", isPresented:$shouldContentViewShowAlert)
                {

                    Button("\(jmAppDelegateVisitor.sAppDelegateVisitorGlobalAlertButtonText ?? "")", role:.cancel) { }

                }
            
            Spacer()
            
            Text("\(JmXcodeBuildSettings.jmAppVersionAndBuildNumber)")     // <=== Version...
                .italic()
                .onReceive(jmAppDelegateVisitor.$appDelegateVisitorSwiftViewsShouldChange,
                    perform:
                    { bChange in
                        if (bChange == true)
                        {
                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onReceive #2 - Received a 'view(s)' SHOULD Change...")

                            shouldContentViewChange = true

                            jmAppDelegateVisitor.resetAppDelegateVisitorSignalSwiftViewsShouldChange()
                        }
                    })

            Spacer(minLength: 4)

            Text("\(JmXcodeBuildSettings.jmAppCopyright)")
                .italic()
            
            Spacer()

            HStack(alignment:.center)
            {

                Spacer()

                Button
                {

                    self.cAppLogPFDataButtonPresses += 1

                    let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):ContentView.Button(Xcode).'Log/Reload Data'.#(\(self.cAppLogPFDataButtonPresses)) pressed...")

                    self.isAppLogPFDataViewModal.toggle()

                }
                label:
                {

                    VStack(alignment:.center)
                    {

                        Label("", systemImage: "doc.text.magnifyingglass")
                            .help(Text("Log PFXxxDataItem(s)..."))
                            .imageScale(.small)

                        Text("Log/Reload Data")
                            .font(.caption2)

                    }

                }
            #if os(macOS)
                .sheet(isPresented:$isAppLogPFDataViewModal, content:
                    {

                        AppLogPFDataView()

                    }
                )
            #endif
            #if os(iOS)
                .fullScreenCover(isPresented:$isAppLogPFDataViewModal)
                {

                    AppLogPFDataView()

                }
            #endif
                .padding()
            #if os(macOS)
                .buttonStyle(.borderedProminent)
            //  .background(???.isPressed ? .blue : .gray)
                .cornerRadius(10)
                .foregroundColor(Color.primary)
            #endif

                Spacer()

                Button
                {

                    self.cAppDataButtonPresses += 1

                    let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):ContentView.Button(Xcode).'App Data...'.#(\(self.cAppDataButtonPresses))...")

                    self.isAppDataViewModal.toggle()

                #if os(macOS)
              
                    // Using -> @Environment(\.openWindow)var openWindow and 'openWindow(id:"...")' on MacOS...
                    openWindow(id:"AppVisitMgmtView")
              
                #endif

            //  #if os(macOS)
            //
            //      // Using -> @Environment(\.openWindow)var openWindow and 'openWindow(id:"...")' on MacOS...
            //      openWindow(id:"AppWorkRouteView", value:self.getAppParseCoreManagerInstance())
            //
            //      //  ERROR: Instance method 'callAsFunction(id:value:)' requires that 'JmAppParseCoreManager' conform to 'Encodable'
            //      //  ERROR: Instance method 'callAsFunction(id:value:)' requires that 'JmAppParseCoreManager' conform to 'Decodable'
            //
            //  #endif
            
                }
                label:
                {

                    VStack(alignment:.center)
                    {

                        Label("", systemImage: "swiftdata")
                            .help(Text("App Data"))
                            .imageScale(.large)

                        Text("Data")
                            .font(.caption)

                    }

                }
        //  #if os(macOS)
        //      .sheet(isPresented:$isAppDataViewModal, content:
        //          {
        //
        //              AppVisitMgmtView()
        //
        //          }
        //      )
        //  #endif
            #if os(iOS)
                .fullScreenCover(isPresented:$isAppDataViewModal)
                {

                    AppVisitMgmtView()

                }
            #endif
            #if os(macOS)
                .buttonStyle(.borderedProminent)
                .padding()
            //  .background(???.isPressed ? .blue : .gray)
                .cornerRadius(10)
                .foregroundColor(Color.primary)
            #endif

                Spacer()

                Button
                {

                    self.cAppWorkRouteButtonPresses += 1

                    let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):ContentView.Button(Xcode).'App WorkRoute'.#(\(self.cAppWorkRouteButtonPresses))...")

                    self.isAppWorkRouteViewModal.toggle()

            //  #if os(macOS)
            //
            //      // Using -> @Environment(\.openWindow)var openWindow and 'openWindow(id:"...")' on MacOS...
            //      openWindow(id:"AppWorkRouteView", value:self.getAppParseCoreManagerInstance())
            //
            //      //  ERROR: Instance method 'callAsFunction(id:value:)' requires that 'JmAppParseCoreManager' conform to 'Encodable'
            //      //  ERROR: Instance method 'callAsFunction(id:value:)' requires that 'JmAppParseCoreManager' conform to 'Decodable'
            //
            //  #endif
            //
                }
                label:
                {

                    VStack(alignment:.center)
                    {

                        Label("", systemImage: "wifi.router")
                            .help(Text("App WorkRoute (Location) Information"))
                            .imageScale(.large)

                        Text("WorkRoute")
                            .font(.caption)

                    }

                }
            #if os(macOS)
                .sheet(isPresented:$isAppWorkRouteViewModal, content:
                    {
          
                        AppWorkRouteView()
          
                    }
                )
            #endif
            #if os(iOS)
                .fullScreenCover(isPresented:$isAppWorkRouteViewModal)
                {

                    AppWorkRouteView()

                }
            #endif
            #if os(macOS)
                .buttonStyle(.borderedProminent)
                .padding()
            //  .background(???.isPressed ? .blue : .gray)
                .cornerRadius(10)
                .foregroundColor(Color.primary)
            #endif

                Spacer()

                Button
                {

                    self.cAppSchedPatLocButtonPresses += 1

                    let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):ContentView.Button(Xcode).'App SchedPatLoc'.#(\(self.cAppSchedPatLocButtonPresses))...")

                    self.isAppSchedPatLocViewModal.toggle()

                #if os(macOS)
              
                    // Using -> @Environment(\.openWindow)var openWindow and 'openWindow(id:"...")' on MacOS...
                //  openWindow(id:"AppSchedPatLocView", value:self.getAppParseCoreManagerInstance())
                    openWindow(id:"AppSchedPatLocView")
              
                    //  ERROR: Instance method 'callAsFunction(id:value:)' requires that 'JmAppParseCoreManager' conform to 'Encodable'
                    //  ERROR: Instance method 'callAsFunction(id:value:)' requires that 'JmAppParseCoreManager' conform to 'Decodable'
              
                #endif
              
                }
                label:
                {

                    VStack(alignment:.center)
                    {

                        Label("", systemImage: "list.bullet.rectangle")
                            .help(Text("App SchedPatLoc (Location) Information"))
                            .imageScale(.large)

                        Text("SchedPatLoc")
                            .font(.caption)

                    }

                }
        //  #if os(macOS)
        //      .sheet(isPresented:$isAppSchedPatLocViewModal, content:
        //          {
        //
        //              AppSchedPatLocView()
        //
        //          }
        //      )
        //  #endif
            #if os(iOS)
                .fullScreenCover(isPresented:$isAppSchedPatLocViewModal)
                {

                    AppSchedPatLocView()

                }
            #endif
            #if os(macOS)
                .buttonStyle(.borderedProminent)
                .padding()
            //  .background(???.isPressed ? .blue : .gray)
                .cornerRadius(10)
                .foregroundColor(Color.primary)
            #endif

                Spacer()

                Button
                {
                
                    let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):ContentView.Button(Xcode).'Logout' pressed...")

                    self.sLoginPassword = ""
                    
                    self.isUserLoggedIn.toggle()
                
                }
                label:
                {

                    VStack(alignment:.center)
                    {

                        Label("", systemImage: "person.badge.key")
                            .help(Text("App 'logout'"))
                            .imageScale(.large)

                        Text("Logout")
                            .font(.caption)

                    }

                }
            #if os(macOS)
                .buttonStyle(.borderedProminent)
                .padding()
            //  .background(???.isPressed ? .blue : .gray)
                .cornerRadius(10)
                .foregroundColor(Color.primary)
            #endif
                
                Spacer()

            }
            
            Spacer()

            Text("")            
                .hidden()
                .onAppear(
                    perform:
                    {
                        // Finish App 'initialization'...

                        let _ = self.finishAppInitialization()
                    })
            
        }
        .padding()
        
    }

    private func finishAppInitialization()
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Finish the App 'initialization'...
  
        self.xcgLogMsg("\(ClassInfo.sClsDisp) Invoking the 'jmAppDelegateVisitor.checkAppDelegateVisitorTraceLogFileForSize()'...")

        self.jmAppDelegateVisitor.checkAppDelegateVisitorTraceLogFileForSize()

        self.xcgLogMsg("\(ClassInfo.sClsDisp) Invoked  the 'jmAppDelegateVisitor.checkAppDelegateVisitorTraceLogFileForSize()'...")

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return

    } // End of private func finishAppInitialization().
    
}   // End of struct ContentView(View).

