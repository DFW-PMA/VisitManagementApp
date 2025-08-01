//
//  SettingsSingleViewCore.swift
//  VisitManagementApp
//
//  Created by JustMacApps.net on 11/25/2024.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import SwiftUI

struct SettingsSingleViewCore: View 
{
    
    struct ClassInfo
    {
        
        static let sClsId        = "SettingsSingleViewCore"
        static let sClsVers      = "v1.2901"
        static let sClsDisp      = sClsId+".("+sClsVers+"): "
        static let sClsCopyRight = "Copyright (C) JustMacApps 2023-2025. All Rights Reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }
    
    // App Data field(s):

//  @Environment(\.dismiss)             var dismiss
    @Environment(\.presentationMode)    var presentationMode
    @Environment(\.openWindow)          var openWindow
    @Environment(\.openURL)             var openURL
    @Environment(\.appGlobalDeviceType) var appGlobalDeviceType

           private var bInternalZipTest:Bool                                 = false

    @State private var cAppLogPFDataButtonPresses:Int                        = 0
    @State private var cContentViewSiteDetailsButtonPresses:Int              = 0
    @State private var cAppZipFileButtonPresses:Int                          = 0
    @State private var cAppCrashButtonPresses:Int                            = 0

    @State private var isAppLogPFDataViewModal:Bool                          = false
    @State private var isAppSiteDetailsViewModal:Bool                        = false
    @State private var isAppZipFileShowing:Bool                              = false
    @State private var isAppCrashShowing:Bool                                = false

#if os(iOS)

    @State private var cAppAboutButtonPresses:Int                            = 0
    @State private var cAppHelpViewButtonPresses:Int                         = 0
    @State private var cAppLogViewButtonPresses:Int                          = 0
    @State private var cContentViewAppDetailsButtonPresses:Int               = 0

    @State private var cAppViewSuspendButtonPresses:Int                      = 0

    @State private var cAppReleaseUpdateButtonPresses:Int                    = 0
    @State private var cAppPreReleaseUpdateButtonPresses:Int                 = 0

    @State private var isAppAboutViewModal:Bool                              = false
    @State private var isAppHelpViewModal:Bool                               = false
    @State private var isAppLogViewModal:Bool                                = false
    @State private var isAppDetailsViewModal:Bool                            = false

    @State private var isAppSuspendShowing:Bool                              = false

#endif
    
    @State private var isAppDownloadReleaseUpdateShowing:Bool                = false
    @State private var isAppDownloadPreReleaseUpdateShowing:Bool             = false

           private var bIsAppUploadUsingLongMsg:Bool                         = false

    @State private var isAppExecutionCurrentShowing:Bool                     = false
    @State private var sAppExecutionCurrentButtonText:String                 = "Share the current App Log with Developers..."
    @State private var sAppExecutionCurrentAlertText:String                  = "Do you want to 'send' the current App LOG data to the Developers?"

    @State private var bWasAppLogFilePresentAtStartup:Bool                   = false
    @State private var bDidAppCrash:Bool                                     = false
    @State private var sAppExecutionPreviousTypeText:String                  = "-N/A-"
    @State private var sAppExecutionPreviousButtonText:String                = "App::-N/A-"
    @State private var sAppExecutionPreviousAlertText:String                 = "Do you want to 'send' the App LOG data?"
    @State private var sAppExecutionPreviousLogToUpload:String               = ""
    @State private var isAppExecutionPreviousShowing:Bool                    = false

                   var jmAppDelegateVisitor:JmAppDelegateVisitor             = JmAppDelegateVisitor.ClassSingleton.appDelegateVisitor
                   var jmAppParseCoreBkgdDataRepo:JmAppParseCoreBkgdDataRepo = JmAppParseCoreBkgdDataRepo.ClassSingleton.appParseCodeBkgdDataRepo
    
    init()
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

//  #if os(iOS)
//
//      // Get some 'internal' Dev Detail(s)...
//
//      bWasAppLogFilePresentAtStartup = checkIfAppLogWasPresent()
//      bDidAppCrash                   = checkIfAppDidCrash()
//
//      if (bDidAppCrash == false)
//      {
//
//          sAppExecutionPreviousTypeText    = "Success"
//          sAppExecutionPreviousButtonText  = "Share the App 'success' Log with Developers..."
//          sAppExecutionPreviousAlertText   = "Do you want to 'send' the App execution 'success' LOG data to the Developers?"
//          sAppExecutionPreviousLogToUpload = AppGlobalInfo.sGlobalInfoAppLastGoodLogFilespec
//
//      }
//      else
//      {
//
//          sAppExecutionPreviousTypeText    = "Crash"
//          sAppExecutionPreviousButtonText  = "Share the App CRASH Log with Developers..."
//          sAppExecutionPreviousAlertText   = "Do you want to 'send' the App execution 'crash' LOG data to the Developers?"
//          sAppExecutionPreviousLogToUpload = AppGlobalInfo.sGlobalInfoAppLastCrashLogFilespec
//
//      }
//
//      self.xcgLogMsg("\(sCurrMethodDisp) Intermediate - 'bDidAppCrash' is [\(bDidAppCrash)]...")
//
//  #endif

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
        
        let _ = self.xcgLogMsg("...'SettingsSingleViewCore(.swift):body' \(JmXcodeBuildSettings.jmAppVersionAndBuildNumber)...")

        Spacer()

        VStack(alignment:.leading)
        {

            Spacer()
                .frame(height:5)
            
        #if os(iOS)
      
            HStack(alignment:.center)
            {
      
                Button
                {
      
                    self.cAppAboutButtonPresses += 1
      
                    let _ = xcgLogMsg("\(ClassInfo.sClsDisp):SettingsSingleViewCore.Button(Xcode).'App About'.#(\(self.cAppAboutButtonPresses))...")
      
                    self.isAppAboutViewModal.toggle()
      
                }
                label:
                {
                    
                    VStack(alignment:.center)
                    {
                        
                        Label("", systemImage: "questionmark.diamond")
                            .help(Text("App About Information"))
                            .imageScale(.large)
                        
                        Text("About")
                            .font(.caption)
                        
                    }
                    
                }
                .fullScreenCover(isPresented:$isAppAboutViewModal)
                {
                
                    AppAboutView()
                
                }
      
                Spacer()
      
                Button
                {
      
                    self.cAppHelpViewButtonPresses += 1
      
                    let _ = xcgLogMsg("\(ClassInfo.sClsDisp):SettingsSingleViewCore.Button(Xcode).'App HelpView'.#(\(self.cAppHelpViewButtonPresses))...")
      
                    self.isAppHelpViewModal.toggle()
      
                }
                label:
                {
                    
                    VStack(alignment:.center)
                    {
                        
                        Label("", systemImage: "questionmark.circle")
                            .help(Text("App HELP Information"))
                            .imageScale(.large)
                        
                        Text("Help")
                            .font(.caption)
                        
                    }
                    
                }
                .fullScreenCover(isPresented:$isAppHelpViewModal)
                {
                
                    HelpBasicView(sHelpBasicContents: jmAppDelegateVisitor.getAppDelegateVisitorHelpBasicContents())
                        .navigationBarBackButtonHidden(true)
                
                }
      
                Spacer()
      
                Button
                {
      
                    self.cAppLogViewButtonPresses += 1
      
                    let _ = xcgLogMsg("\(ClassInfo.sClsDisp):SettingsSingleViewCore.Button(Xcode).'App LogView'.#(\(self.cAppLogViewButtonPresses))...")
      
                    self.isAppLogViewModal.toggle()
      
                }
                label:
                {
                    
                    VStack(alignment:.center)
                    {
                        
                        Label("", systemImage: "doc.text.magnifyingglass")
                            .help(Text("App LOG Viewer"))
                            .imageScale(.large)
                        
                        Text("View Log")
                            .font(.caption)
                        
                    }
                    
                }
                .fullScreenCover(isPresented:$isAppLogViewModal)
                {
                
                    LogFileView()
                
                }
      
                Spacer()

                Button
                {

                    self.cContentViewAppDetailsButtonPresses += 1

                    let _ = xcgLogMsg("\(ClassInfo.sClsDisp):SettingsSingleViewCore in Button(Xcode).'App Details'.#(\(self.cContentViewAppDetailsButtonPresses))...")

                    self.isAppDetailsViewModal.toggle()

                }
                label: 
                {

                    VStack(alignment:.center)
                    {

                        Label("", systemImage: "doc.questionmark")
                            .help(Text("App (Dev) Details"))
                            .imageScale(.large)

                        Text("(Dev) Details")
                            .font(.caption)

                    }

                } 
                .fullScreenCover(isPresented:$isAppDetailsViewModal)
                {

                    AppDetailsView()

                }
                .padding()

                Spacer()
      
                Button
                {
      
                    let _ = xcgLogMsg("\(ClassInfo.sClsDisp):SettingsSingleViewCore.Button(Xcode).'Dismiss' pressed...")
                    
                    self.presentationMode.wrappedValue.dismiss()
                    
                //  dismiss()
      
                }
                label:
                {
                    
                    VStack(alignment:.center)
                    {
                        
                        Label("", systemImage: "xmark.circle")
                            .help(Text("Dismiss this Screen"))
                            .imageScale(.large)
                        
                        Text("Dismiss")
                            .font(.caption)
                        
                    }
                    
                }
      
            }
      
            Spacer()
            
        #endif
      
            VStack(alignment:.center)
            {
      
                HStack(alignment:.center)
                {
      
                    Spacer()
      
                    Text(" - - - - - - - - - - - - - - - ")
                        .bold()
      
                    Spacer()
      
                }
      
                HStack(alignment:.center)
                {
      
                    Spacer()
      
                    VStack(alignment:.center)
                    {
      
                        if #available(iOS 15.0, *) 
                        {
                            Text("Application Setting(s):")
                                .bold()
                                .dynamicTypeSize(.small)
                        }
                        else
                        {
                            Text("Application Setting(s):")
                                .bold()
                        }
      
                    }
      
                    Spacer()
      
                }
      
                HStack(alignment:.center)
                {
      
                    Spacer()
      
                    Text(" - - - - - - - - - - - - - - - ")
                        .bold()
      
                    Spacer()
      
                }
      
            }
      
            Spacer()

        #if os(iOS)

            HStack
            {

                Spacer()

                if (bWasAppLogFilePresentAtStartup == true)
                {

                    Button
                    {

                        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)SettingsSingleViewCore.Button(Xcode).'\(sAppExecutionPreviousButtonText)'...")

                        self.isAppExecutionPreviousShowing.toggle()

                    }
                    label:
                    {

                        VStack(alignment:.center)
                        {

                            Label("", systemImage: "arrow.up.message")
                                .help(Text("'Send' \(sAppExecutionPreviousTypeText) App LOG"))
                                .imageScale(.large)

                            Text("\(sAppExecutionPreviousTypeText) LOG")
                                .font(.caption)

                        }

                    }
                    .alert(sAppExecutionPreviousAlertText, isPresented:$isAppExecutionPreviousShowing)
                    {
                        Button("Cancel", role:.cancel)
                        {
                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp) User pressed 'Cancel' to 'send' the \(sAppExecutionPreviousTypeText) App LOG - resuming...")
                        }
                        Button("Ok", role:.destructive)
                        {
                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp) User pressed 'Ok' to 'send' the \(sAppExecutionPreviousTypeText) App LOG - sending...")

                            self.uploadPreviousAppLogToDevs()
                        }
                    }

                    Spacer()

                }

                if (jmAppDelegateVisitor.bAppDelegateVisitorLogFilespecIsUsable == true)
                {

                    Button
                    {

                        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)SettingsSingleViewCore.Button(Xcode).'\(sAppExecutionCurrentButtonText)'...")

                        self.isAppExecutionCurrentShowing.toggle()

                    }
                    label:
                    {

                        VStack(alignment:.center)
                        {

                            Label("", systemImage: "arrow.up.message")
                                .help(Text("'Send' current App LOG"))
                                .imageScale(.large)

                            Text("Current LOG")
                                .font(.caption)

                        }

                    }
                    .alert(sAppExecutionCurrentAlertText, isPresented:$isAppExecutionCurrentShowing)
                    {
                        Button("Cancel", role:.cancel)
                        {
                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp) User pressed 'Cancel' to 'send' the current App LOG - resuming...")
                        }
                        Button("Ok", role:.destructive)
                        {
                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp) User pressed 'Ok' to 'send' the current App LOG - sending...")

                            self.uploadCurrentAppLogToDevs()
                        }
                    }

                    Spacer()

                }

                Button
                {

                    self.cAppViewSuspendButtonPresses += 1

                    let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)SettingsSingleViewCore.Button(Xcode).'Quit'.#(\(self.cAppViewSuspendButtonPresses))...")

                    self.isAppSuspendShowing.toggle()

                }
                label:
                {

                    VStack(alignment:.center)
                    {

                        Label("", systemImage: "xmark.circle")
                            .help(Text("Suspend this App"))
                            .imageScale(.large)

                        Text("Suspend App")
                            .font(.caption)

                    }

                }
                .alert("Are you sure you want to 'suspend' this App?", isPresented:$isAppSuspendShowing)
                {
                    Button("Cancel", role:.cancel)
                    {
                        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp) User pressed 'Cancel' to 'suspend' the App - resuming...")
                    }
                    Button("Ok", role:.destructive)
                    {
                        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp) User pressed 'Ok' to 'suspend' the App - suspending...")

                        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                    }
                }

                Spacer()

            }

        #endif

            if (AppGlobalInfo.bPerformAppDevTesting == true)
            {
      
                Spacer()
      
                HStack(alignment:.center)
                {
                    Spacer()

                    Button
                    {
                        self.cAppLogPFDataButtonPresses += 1

                        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):SettingsSingleViewCore.Button(Xcode).'Log/Reload Data'.#(\(self.cAppLogPFDataButtonPresses)) pressed...")

                    #if os(iOS)
                        self.isAppLogPFDataViewModal.toggle()
                    #endif
                    #if os(macOS)
                        openWindow(id:"AppLogPFDataView")
                    #endif
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
            //  #if os(macOS)
            //      .sheet(isPresented:$isAppLogPFDataViewModal, content:
            //          {
            //
            //              AppLogPFDataView()
            //
            //          }
            //      )
            //  #endif
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
                        self.cContentViewSiteDetailsButtonPresses += 1

                        let _ = xcgLogMsg("\(ClassInfo.sClsDisp)SettingsSingleViewCore.Button(Xcode).'Site Detail(s)'.#(\(self.cContentViewSiteDetailsButtonPresses))...")

                        self.isAppSiteDetailsViewModal.toggle()
                    }
                    label:
                    {
                        VStack(alignment:.center)
                        {
                            Label("", systemImage: "location.fill.viewfinder")
                                .help(Text("App 'site' Information Screen..."))
                                .imageScale(.large)
                            Text("Site")
                                .font(.caption)
                        }
                    }
                #if os(macOS)
                    .sheet(isPresented:$isAppSiteDetailsViewModal, content:
                        {
                            CoreLocationSiteDetailsView()
                        }
                    )
                #endif
                #if os(iOS)
                    .fullScreenCover(isPresented:$isAppSiteDetailsViewModal)
                    {
                        CoreLocationSiteDetailsView()
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
      
                        self.cAppZipFileButtonPresses += 1
      
                        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)SettingsSingleViewCore.Button(Xcode).'App ZipFile'.#(\(self.cAppZipFileButtonPresses))...")
      
                        self.isAppZipFileShowing.toggle()
      
                    }
                    label:
                    {
      
                        VStack(alignment:.center)
                        {
      
                            Label("", systemImage: "square.resize.down")
                                .help(Text("Test this App creating a ZIP File"))
                                .imageScale(.large)
      
                            Text("Test ZIP File")
                                .font(.caption)
      
                        }
      
                    }
                    .alert("Are you sure you want to TEST this App 'creating' a ZIP File?", isPresented:$isAppZipFileShowing)
                    {
                        Button("Cancel", role:.cancel)
                        {
                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp) User pressed 'Cancel' to 'test' the App ZIP File - resuming...")
                        }
                        Button("Ok", role:.destructive)
                        {
                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp) User pressed 'Ok' to 'test' the App ZIP File - testing...")
      
                            self.uploadCurrentAppLogToDevs()
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
      
            //      Button
            //      {
            //
            //          let _ = xcgLogMsg("\(ClassInfo.sClsDisp):SettingsSingleViewCore.Button(Xcode).'Log TherapistFile' pressed...")
            //
            //          self.detailTherapistFileItems()
            //
            //      }
            //      label:
            //      {
            //
            //          VStack(alignment:.center)
            //          {
            //
            //              Label("", systemImage: "doc.text.magnifyingglass")
            //                  .help(Text("Log TherapistFile Item(s)..."))
            //                  .imageScale(.large)
            //
            //              Text("Log TherapistFile")
            //                  .font(.caption)
            //
            //          }
            //
            //      }
            //  #if os(macOS)
            //      .buttonStyle(.borderedProminent)
            //      .padding()
            //  //  .background(???.isPressed ? .blue : .gray)
            //      .cornerRadius(10)
            //      .foregroundColor(Color.primary)
            //  #endif
            //      .padding()
            //
            //      Spacer()

                    Button
                    {
      
                        self.cAppCrashButtonPresses += 1
      
                        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)SettingsSingleViewCore.Button(Xcode).'App Crash'.#(\(self.cAppCrashButtonPresses))...")
      
                        self.isAppCrashShowing.toggle()
      
                    }
                    label:
                    {
      
                        VStack(alignment:.center)
                        {
      
                            Label("", systemImage: "autostartstop.slash")
                                .help(Text("FORCE this App to CRASH"))
                                .imageScale(.large)
      
                            Text("Force CRASH")
                                .font(.caption)
      
                        }
      
                    }
                    .alert("Are you sure you want to 'crash' this App?", isPresented:$isAppCrashShowing)
                    {
                        Button("Cancel", role:.cancel)
                        {
                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp) User pressed 'Cancel' to 'crash' the App - resuming...")
                        }
                        Button("Ok", role:.destructive)
                        {
                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp) User pressed 'Ok' to 'crash' the App - crashing...")
      
                            fatalError("The User pressed 'Ok' to force an App 'crash'!")
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
      
            }

            if (AppGlobalInfo.bEnableAppReleaseDownloads == true)
            {

            #if os(iOS)

                Spacer()

                VStack(alignment:.center)
                {

                    HStack(alignment:.center)
                    {

                        Spacer()

                        Text(" - - - - - - - - - - - - - - - - - - - - ")
                            .bold()

                        Spacer()

                    }

                    HStack(alignment:.center)
                    {

                        Spacer()

                        Button
                        {

                            self.cAppReleaseUpdateButtonPresses += 1

                            let _ = xcgLogMsg("\(ClassInfo.sClsDisp):SettingsSingleViewCore.Button(Xcode).'App 'download' Release'.#(\(self.cAppReleaseUpdateButtonPresses))...")

                            self.isAppDownloadReleaseUpdateShowing.toggle()

                        }
                        label: 
                        {

                        if #available(iOS 14.0, *) 
                        {

                            VStack(alignment:.center)
                            {

                                Label("", systemImage: "arrow.down.app")
                                    .help(Text("App 'download' RELEASE"))
                                    .imageScale(.large)

                                Text("Download RELEASE")
                                    .font(.caption)

                            }

                        } 
                        else
                        {

                            Text("App 'download' RELEASE")

                        }

                        }
                        .alert("Do you want to 'download' (and install) the App RELEASE?", isPresented:$isAppDownloadReleaseUpdateShowing)
                        {
                            Button("Cancel", role:.cancel)
                            {
                                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp) User pressed 'Cancel' to 'download' the App RELEASE - resuming...")
                            }
                            Button("Ok", role:.destructive)
                            {
                                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp) User pressed 'Ok' to 'download' the App RELEASE - updating...")

                                self.downloadAppReleaseUpdate()

                            }
                        }
                        .padding()

                        Spacer()

                        Button
                        {

                            self.cAppPreReleaseUpdateButtonPresses += 1

                            let _ = xcgLogMsg("\(ClassInfo.sClsDisp):SettingsSingleViewCore.Button(Xcode).'App 'download' Pre-Release'.#(\(self.cAppPreReleaseUpdateButtonPresses))...")

                            self.isAppDownloadPreReleaseUpdateShowing.toggle()

                        }
                        label: 
                        {

                        if #available(iOS 14.0, *) 
                        {

                            VStack(alignment:.center)
                            {

                                Label("", systemImage: "arrow.down.app.fill")
                                    .help(Text("App 'download' Pre-Release"))
                                    .imageScale(.large)

                                Text("Download Pre-Release")
                                    .font(.caption)

                            }

                        } 
                        else 
                        {

                            Text("App 'download' Pre-Release")

                        }

                        }
                        .alert("Do you want to 'download' (and install) the App Pre-Release?", isPresented:$isAppDownloadPreReleaseUpdateShowing)
                        {
                            Button("Cancel", role:.cancel)
                            {
                                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp) User pressed 'Cancel' to 'download' the App Pre-Release - resuming...")
                            }
                            Button("Ok", role:.destructive)
                            {
                                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp) User pressed 'Ok' to 'download' the App Pre-Release - updating...")

                                self.downloadAppPreReleaseUpdate()

                            }
                        }
                        .padding()

                        Spacer()

                    }

                    HStack(alignment:.center)
                    {

                        Spacer()

                        Text(" - - - - - - - - - - - - - - - - - - - - ")
                            .bold()

                        Spacer()

                    }

                }

            #endif

            }

            Text("")            
                .hidden()
                .onAppear(
                    perform:
                    {
                        // Continue App 'initialization'...

                        let _ = self.finishAppInitialization()
                    })

            Spacer()

        }
        .padding()

    }

    private func finishAppInitialization()
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Finish the App 'initialization'...
  
        self.bWasAppLogFilePresentAtStartup = checkIfAppLogWasPresent()
        self.bDidAppCrash                   = checkIfAppDidCrash()
        
        if (self.bDidAppCrash == false)
        {
        
            self.sAppExecutionPreviousTypeText    = "Success"
            self.sAppExecutionPreviousButtonText  = "Share the App 'success' Log with Developers..."
            self.sAppExecutionPreviousAlertText   = "Do you want to 'send' the App execution 'success' LOG data to the Developers?"
            self.sAppExecutionPreviousLogToUpload = AppGlobalInfo.sGlobalInfoAppLastGoodLogFilespec
        
        }
        else
        {
        
            self.sAppExecutionPreviousTypeText    = "Crash"
            self.sAppExecutionPreviousButtonText  = "Share the App CRASH Log with Developers..."
            self.sAppExecutionPreviousAlertText   = "Do you want to 'send' the App execution 'crash' LOG data to the Developers?"
            self.sAppExecutionPreviousLogToUpload = AppGlobalInfo.sGlobalInfoAppLastCrashLogFilespec
        
        }

        self.xcgLogMsg("\(ClassInfo.sClsDisp) Invoking the 'jmAppDelegateVisitor.checkAppDelegateVisitorTraceLogFileForSize()'...")

        self.jmAppDelegateVisitor.checkAppDelegateVisitorTraceLogFileForSize()

        self.xcgLogMsg("\(ClassInfo.sClsDisp) Invoked  the 'jmAppDelegateVisitor.checkAppDelegateVisitorTraceLogFileForSize()'...")

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return

    } // End of private func finishAppInitialization().
    
    private func uploadCurrentAppLogToDevs()
    {
  
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Prepare specifics to 'upload' the AppLog file...

        var urlAppDelegateVisitorLogFilepath:URL?     = nil
        var urlAppDelegateVisitorLogFilespec:URL?     = nil
        var sAppDelegateVisitorLogFilespec:String!    = nil
        var sAppDelegateVisitorLogFilepath:String!    = nil
        var sAppDelegateVisitorLogFilenameExt:String! = nil

        do 
        {

            urlAppDelegateVisitorLogFilepath  = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask ,appropriateFor: nil, create: true)
            urlAppDelegateVisitorLogFilespec  = urlAppDelegateVisitorLogFilepath?.appendingPathComponent(AppGlobalInfo.sGlobalInfoAppLogFilespec)
            sAppDelegateVisitorLogFilespec    = urlAppDelegateVisitorLogFilespec?.path
            sAppDelegateVisitorLogFilepath    = urlAppDelegateVisitorLogFilepath?.path
            sAppDelegateVisitorLogFilenameExt = urlAppDelegateVisitorLogFilespec?.lastPathComponent

            self.xcgLogMsg("[\(sCurrMethodDisp)] 'sAppDelegateVisitorLogFilespec'    (computed) is [\(String(describing: sAppDelegateVisitorLogFilespec))]...")
            self.xcgLogMsg("[\(sCurrMethodDisp)] 'sAppDelegateVisitorLogFilepath'    (resolved #2) is [\(String(describing: sAppDelegateVisitorLogFilepath))]...")
            self.xcgLogMsg("[\(sCurrMethodDisp)] 'sAppDelegateVisitorLogFilenameExt' (computed) is [\(String(describing: sAppDelegateVisitorLogFilenameExt))]...")

        }
        catch
        {

            self.xcgLogMsg("[\(sCurrMethodDisp)] Failed to 'stat' item(s) in the 'path' of [.documentDirectory] - Error: \(error)...")

        }

        // Check that the 'current' App LOG file 'exists'...

        let bIsCurrentAppLogFilePresent:Bool = JmFileIO.fileExists(sFilespec:sAppDelegateVisitorLogFilespec)

        if (bIsCurrentAppLogFilePresent == true)
        {

            self.xcgLogMsg("[\(sCurrMethodDisp)] Preparing to Zip the 'source' filespec ('current' App LOG) of [\(String(describing: sAppDelegateVisitorLogFilespec))]...")

        }
        else
        {

            let sZipFileErrorMsg:String = "Unable to Zip the 'current' App LOG of [\(String(describing: sAppDelegateVisitorLogFilespec))] - the file does NOT Exist - Error!"

            DispatchQueue.main.async
            {

                self.jmAppDelegateVisitor.setAppDelegateVisitorSignalGlobalAlert("Alert::\(sZipFileErrorMsg)",
                                                                                 alertButtonText:"Ok")

            }

            self.xcgLogMsg("[\(sCurrMethodDisp)] \(sZipFileErrorMsg)")

            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return

        }

        // Create the AppLog's 'multipartRequestInfo' object (but WITHOUT any Data (yet))...

        let multipartRequestInfo:MultipartRequestInfo = MultipartRequestInfo()

        multipartRequestInfo.bAppZipSourceToUpload    = false
        multipartRequestInfo.sAppUploadURL            = ""          // "" takes the Upload URL 'default'...
        multipartRequestInfo.sAppUploadNotifyTo       = ""          // This is email notification - "" defaults to all Dev(s)...
        multipartRequestInfo.sAppUploadNotifyCc       = ""          // This is email notification - "" defaults to 'none'...
        multipartRequestInfo.sAppSourceFilespec       = sAppDelegateVisitorLogFilespec
        multipartRequestInfo.sAppSourceFilename       = sAppDelegateVisitorLogFilenameExt
        multipartRequestInfo.sAppZipFilename          = sAppDelegateVisitorLogFilenameExt
        multipartRequestInfo.sAppSaveAsFilename       = sAppDelegateVisitorLogFilenameExt
        multipartRequestInfo.sAppFileMimeType         = "text/plain"

        // Create the AppLog's 'multipartRequestInfo.dataAppFile' object...

        multipartRequestInfo.dataAppFile              = FileManager.default.contents(atPath: sAppDelegateVisitorLogFilespec)

        self.xcgLogMsg("\(sCurrMethodDisp) The 'upload' is using 'multipartRequestInfo' of [\(String(describing: multipartRequestInfo.toString()))]...")

        // Attempting to 'zip' the file (content(s))...

        let multipartZipFileCreator:MultipartZipFileCreator = MultipartZipFileCreator()

        multipartRequestInfo.sAppZipFilename = multipartRequestInfo.sAppSourceFilename

        var urlCreatedZipFile:URL? = multipartZipFileCreator.createTargetZipFileFromSource(multipartRequestInfo:multipartRequestInfo)

        // Check if we actually got the 'target' Zip file created...

        if let urlCreatedZipFile = urlCreatedZipFile 
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Produced a Zip file 'urlCreatedZipFile' of [\(urlCreatedZipFile)]...")

            multipartRequestInfo.sAppZipFilename  = "\(multipartRequestInfo.sAppZipFilename).zip"

        } 
        else 
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Failed to produce a Zip file - the 'target' Zip filename was [\(multipartRequestInfo.sAppZipFilename)] - Error!")

            multipartRequestInfo.sAppZipFilename  = "-N/A-"
            multipartRequestInfo.sAppFileMimeType = "text/plain"
            multipartRequestInfo.dataAppFile      = FileManager.default.contents(atPath: sAppDelegateVisitorLogFilespec)

            self.xcgLogMsg("\(sCurrMethodDisp) Reset the 'multipartRequestInfo' to upload the <raw> file without 'zipping'...")

            urlCreatedZipFile = nil

        }

        // If this is NOT an 'internal' Zip 'test', then send the upload:

        if (bInternalZipTest == false)
        {

            // Send the AppLog as an 'upload' to the Server...

            let multipartRequestDriver:MultipartRequestDriver = MultipartRequestDriver(bGenerateResponseLongMsg:true)

            self.xcgLogMsg("\(sCurrMethodDisp) Using 'multipartRequestInfo' of [\(String(describing: multipartRequestInfo.toString()))]...")
            self.xcgLogMsg("\(sCurrMethodDisp) Calling 'multipartRequestDriver.executeMultipartRequest(multipartRequestInfo:)'...")

            multipartRequestDriver.executeMultipartRequest(multipartRequestInfo:multipartRequestInfo)

            self.xcgLogMsg("\(sCurrMethodDisp) Called  'multipartRequestDriver.executeMultipartRequest(multipartRequestInfo:)'...")

        }

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return
  
    }   // End of private func uploadCurrentAppLogToDevs().

    private func checkIfAppLogWasPresent() -> Bool
    {
  
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
  
        self.xcgLogMsg("\(sCurrMethodDisp) 'jmAppDelegateVisitor' is [\(String(describing: jmAppDelegateVisitor))] - details are [\(jmAppDelegateVisitor.toString())]...")
  
        let bWasAppLogPresentAtStart:Bool = jmAppDelegateVisitor.bWasAppLogFilePresentAtStartup
        
        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'bWasAppLogPresentAtStart' is [\(String(describing: bWasAppLogPresentAtStart))]...")
  
        return bWasAppLogPresentAtStart
  
    }   // End of private func checkIfAppLogWasPresent().

    private func checkIfAppDidCrash() -> Bool
    {
  
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
  
        self.xcgLogMsg("\(sCurrMethodDisp) 'jmAppDelegateVisitor' is [\(String(describing: jmAppDelegateVisitor))] - details are [\(jmAppDelegateVisitor.toString())]...")
  
        let bDidAppCrashOnLastRun:Bool = jmAppDelegateVisitor.bWasAppCrashFilePresentAtStartup
  
        self.xcgLogMsg("\(sCurrMethodDisp) 'bDidAppCrashOnLastRun' is [\(String(describing: bDidAppCrashOnLastRun))]...")
        
        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'bDidAppCrashOnLastRun' is [\(String(describing: bDidAppCrashOnLastRun))]...")
  
        return bDidAppCrashOnLastRun
  
    }   // End of private func checkIfAppDidCrash().

#if os(iOS)

    private func uploadPreviousAppLogToDevs()
    {
  
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Prepare specifics to 'upload' the AppLog file...

        var urlAppDelegateVisitorLogFilepath:URL?     = nil
        var urlAppDelegateVisitorLogFilespec:URL?     = nil
        var sAppDelegateVisitorLogFilespec:String!    = nil
        var sAppDelegateVisitorLogFilepath:String!    = nil
        var sAppDelegateVisitorLogFilenameExt:String! = nil

        do 
        {

            urlAppDelegateVisitorLogFilepath  = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask ,appropriateFor: nil, create: true)
            urlAppDelegateVisitorLogFilespec  = urlAppDelegateVisitorLogFilepath?.appendingPathComponent(sAppExecutionPreviousLogToUpload)
            sAppDelegateVisitorLogFilespec    = urlAppDelegateVisitorLogFilespec?.path
            sAppDelegateVisitorLogFilepath    = urlAppDelegateVisitorLogFilepath?.path
            sAppDelegateVisitorLogFilenameExt = urlAppDelegateVisitorLogFilespec?.lastPathComponent

            self.xcgLogMsg("[\(sCurrMethodDisp)] 'sAppDelegateVisitorLogFilespec'    (computed) is [\(String(describing: sAppDelegateVisitorLogFilespec))]...")
            self.xcgLogMsg("[\(sCurrMethodDisp)] 'sAppDelegateVisitorLogFilepath'    (resolved #2) is [\(String(describing: sAppDelegateVisitorLogFilepath))]...")
            self.xcgLogMsg("[\(sCurrMethodDisp)] 'sAppDelegateVisitorLogFilenameExt' (computed) is [\(String(describing: sAppDelegateVisitorLogFilenameExt))]...")

        }
        catch
        {

            self.xcgLogMsg("[\(sCurrMethodDisp)] Failed to 'stat' item(s) in the 'path' of [.documentDirectory] - Error: \(error)...")

        }

        // Create the AppLog's 'multipartRequestInfo' object (but WITHOUT any Data (yet))...

        let multipartRequestInfo:MultipartRequestInfo = MultipartRequestInfo()

        multipartRequestInfo.bAppZipSourceToUpload    = false
        multipartRequestInfo.sAppUploadURL            = ""          // "" takes the Upload URL 'default'...
        multipartRequestInfo.sAppUploadNotifyTo       = ""          // This is email notification - "" defaults to all Dev(s)...
        multipartRequestInfo.sAppUploadNotifyCc       = ""          // This is email notification - "" defaults to 'none'...
        multipartRequestInfo.sAppSourceFilespec       = sAppDelegateVisitorLogFilespec
        multipartRequestInfo.sAppSourceFilename       = sAppDelegateVisitorLogFilenameExt
        multipartRequestInfo.sAppZipFilename          = sAppDelegateVisitorLogFilenameExt
        multipartRequestInfo.sAppSaveAsFilename       = sAppDelegateVisitorLogFilenameExt
        multipartRequestInfo.sAppFileMimeType         = "text/plain"

        // Create the AppLog's 'multipartRequestInfo.dataAppFile' object...

        multipartRequestInfo.dataAppFile              = FileManager.default.contents(atPath: sAppDelegateVisitorLogFilespec)

        self.xcgLogMsg("\(sCurrMethodDisp) The 'upload' is using 'multipartRequestInfo' of [\(String(describing: multipartRequestInfo.toString()))]...")

        // Send the AppLog as an 'upload' to the Server...

        let multipartRequestDriver:MultipartRequestDriver = MultipartRequestDriver(bGenerateResponseLongMsg:self.bIsAppUploadUsingLongMsg)

        self.xcgLogMsg("\(sCurrMethodDisp) Calling 'multipartRequestDriver.executeMultipartRequest(multipartRequestInfo:)'...")

        multipartRequestDriver.executeMultipartRequest(multipartRequestInfo:multipartRequestInfo)
        
        self.xcgLogMsg("\(sCurrMethodDisp) Called  'multipartRequestDriver.executeMultipartRequest(multipartRequestInfo:)'...")

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return
  
    }   // End of private func uploadPreviousAppLogToDevs().

    private func downloadAppReleaseUpdate()
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Open the URL that will download (and install) the App Release UPDATE...

        let urlToOpen:URL = URL(string:"itms-services://?action=download-manifest&url=https://raw.githubusercontent.com/DFW-PMA/VisitManagementApp/refs/heads/main/VisitManagementApp.plist")!

        self.xcgLogMsg("\(sCurrMethodDisp) Calling 'AppDelegate.openAppSuppliedURL(urlToOpen:)' to download and install the App Release on the URL of [\(urlToOpen)]...")

        self.openAppSuppliedURL(urlToOpen:urlToOpen)

        self.xcgLogMsg("\(sCurrMethodDisp) Called  'AppDelegate.openAppSuppliedURL(urlToOpen:)' to download and install the App Release on the URL of [\(urlToOpen)]...")

        // Suspend this App...

        self.xcgLogMsg("\(sCurrMethodDisp) Suspending this App...")

        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))

        // Exit...

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of private func downloadAppReleaseUpdate().

    private func downloadAppPreReleaseUpdate()
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Open the URL that will download (and install) the App Release UPDATE...

        let urlToOpen:URL = URL(string:"itms-services://?action=download-manifest&url=https://raw.githubusercontent.com/DFW-PMA/VisitManagementApp/refs/heads/main/VisitManagementApp_Pre.plist")!

        self.xcgLogMsg("\(sCurrMethodDisp) Calling 'AppDelegate.openAppSuppliedURL(urlToOpen:)' to download and install the App Pre-Release on the URL of [\(urlToOpen)]...")

        self.openAppSuppliedURL(urlToOpen:urlToOpen)

        self.xcgLogMsg("\(sCurrMethodDisp) Called  'AppDelegate.openAppSuppliedURL(urlToOpen:)' to download and install the App Pre-Release on the URL of [\(urlToOpen)]...")

        // Suspend this App...

        self.xcgLogMsg("\(sCurrMethodDisp) Suspending this App...")

        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))

        // Exit...

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of private func downloadAppPreReleaseUpdate().

#endif

    private func openAppSuppliedURL(urlToOpen:URL)
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'urlToOpen' is [\(urlToOpen)]...")

        // Open the supplied URL...

    #if os(macOS)

        NSWorkspace.shared.open(urlToOpen)

    #elseif os(iOS)

        UIApplication.shared.open(urlToOpen, options: [:], completionHandler: nil)

    #endif

        // Exit...

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of private func openAppSuppliedURL(urlToOpen:URL).

//  private func detailTherapistFileItems()
//  {
//      
//      let sCurrMethod:String = #function
//      let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
//
//      self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
//
//      // Detail all TherapistFile 'item(s)' in the JmAppParseCoreManger of the JmAppDelegateVisitor...
//
//      if (self.jmAppDelegateVisitor.jmAppParseCoreManager != nil)
//      {
//
//          if (self.jmAppDelegateVisitor.jmAppParseCoreManager!.dictPFTherapistFileItems.count > 0)
//          {
//
//              self.xcgLogMsg("\(sCurrMethodDisp) Displaying the 'jmAppParseCoreManager' dictionary of #(\(self.jmAppDelegateVisitor.jmAppParseCoreManager!.dictPFTherapistFileItems.count)) 'dictPFTherapistFileItems' item(s)...")
//
//              var cPFTherapistParseTIDs:Int = 0
//
//              for (iPFTherapistParseTID, pfTherapistFileItem) in self.jmAppDelegateVisitor.jmAppParseCoreManager!.dictPFTherapistFileItems
//              {
//
//                  cPFTherapistParseTIDs += 1
//
//                  if (iPFTherapistParseTID < 0)
//                  {
//
//                      self.xcgLogMsg("\(sCurrMethodDisp) 'jmAppParseCoreManager' Skipping object #(\(cPFTherapistParseTIDs)) 'iPFTherapistParseTID' - the 'tid' field is less than 0 - Warning!")
//
//                      continue
//
//                  }
//
//                  self.xcgLogMsg("\(sCurrMethodDisp) 'jmAppParseCoreManager' For TID [\(iPFTherapistParseTID)] - Displaying 'pfTherapistFileItem' item #(\(cPFTherapistParseTIDs)):")
//
//                  pfTherapistFileItem.displayParsePFTherapistFileItemToLog()
//
//              }
//
//          }
//          else
//          {
//
//              self.xcgLogMsg("\(sCurrMethodDisp) Unable to display the 'jmAppParseCoreManager' dictionary of 'dictPFTherapistFileItems' item(s) - item(s) count is less than 1 - Warning!")
//
//          }
//
//      }
//      else
//      {
//
//          self.xcgLogMsg("\(sCurrMethodDisp) 'jmAppParseCoreManager' is nil - unable to get the dictionary 'dictPFTherapistFileItems' - Error!")
//
//      }
//
//      // Detail all TherapistFile 'item(s)' in the JmAppParseCoreManger of the JmAppDelegateVisitor...
//
//      if (self.jmAppParseCoreBkgdDataRepo.dictPFTherapistFileItems.count > 0)
//      {
//
//          self.xcgLogMsg("\(sCurrMethodDisp) Displaying the 'jmAppParseCoreBkgdDataRepo' dictionary of #(\(self.jmAppParseCoreBkgdDataRepo.dictPFTherapistFileItems.count)) 'dictPFTherapistFileItems' item(s)...")
//
//          var cPFTherapistParseTIDs:Int = 0
//
//          for (iPFTherapistParseTID, pfTherapistFileItem) in self.jmAppParseCoreBkgdDataRepo.dictPFTherapistFileItems
//          {
//
//              cPFTherapistParseTIDs += 1
//
//              if (iPFTherapistParseTID < 0)
//              {
//
//                  self.xcgLogMsg("\(sCurrMethodDisp) 'jmAppParseCoreBkgdDataRepo' Skipping object #(\(cPFTherapistParseTIDs)) 'iPFTherapistParseTID' - the 'tid' field is less than 0 - Warning!")
//
//                  continue
//
//              }
//
//              self.xcgLogMsg("\(sCurrMethodDisp) 'jmAppParseCoreBkgdDataRepo' For TID [\(iPFTherapistParseTID)] - Displaying 'pfTherapistFileItem' item #(\(cPFTherapistParseTIDs)):")
//
//              pfTherapistFileItem.displayParsePFTherapistFileItemToLog()
//
//          }
//
//      }
//      else
//      {
//
//          self.xcgLogMsg("\(sCurrMethodDisp) 'jmAppParseCoreBkgdDataRepo' Unable to display the dictionary of 'dictPFTherapistFileItems' item(s) - item(s) count is less than 1 - Warning!")
//
//      }
//
//      // Exit:
//
//      self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
//
//      return
//
//  }   // End of private func detailTherapistFileItems().

}   // End of struct SettingsSingleViewCore(View). 

#Preview 
{
    
    SettingsSingleViewCore()
    
}

