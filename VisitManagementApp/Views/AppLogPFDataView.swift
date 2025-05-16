//
//  AppLogPFDataView.swift
//  VisitManagementApp
//
//  Created by Daryl Cox on 02/04/2025.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
import SwiftUI

struct AppLogPFDataView: View 
{
    
    struct ClassInfo
    {
        
        static let sClsId        = "AppLogPFDataView"
        static let sClsVers      = "v1.1701"
        static let sClsDisp      = sClsId+"(.swift).("+sClsVers+"):"
        static let sClsCopyRight = "Copyright (C) JustMacApps 2023-2025. All Rights Reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }
    
    // App Data field(s):

//  @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.openWindow)       var openWindow

    @State private  var cAppDataButtonPresses:Int                                 = 0
    @State private  var cAppWorkRouteButtonPresses:Int                            = 0
    
    @State private  var isAppDataViewModal:Bool                                   = false
    @State private  var isAppWorkRouteViewModal:Bool                              = false

    @State private  var cAppLogPFDataLoggingRefreshButtonPresses:Int              = 0
    @State private  var cAppLogPFDataLoggingPFAdminsButtonPresses:Int             = 0
    @State private  var cAppLogPFDataLoggingPFCscButtonPresses:Int                = 0
    @State private  var cAppLogPFDataLoggingPFTherapistNamesButtonPresses:Int     = 0
    @State private  var cAppLogPFDataLoggingPFTherapistFileButtonPresses:Int      = 0
    @State private  var cAppLogPFDataLoggingTherapistXrefButtonPresses:Int        = 0
    @State private  var cAppLogPFDataLoggingPFPatientNamesButtonPresses:Int       = 0
    @State private  var cAppLogPFDataLoggingPFPatientFileButtonPresses:Int        = 0
    @State private  var cAppLogPFDataLoggingPFPatientXrefButtonPresses:Int        = 0
    @State private  var cAppLogPFDataLoggingPatientXrefButtonPresses:Int          = 0
    @State private  var cAppLogPFDataLoggingSchedPatLocButtonPresses:Int          = 0
    @State private  var cAppLogPFDataLoggingExportSchedPatLocButtonPresses:Int    = 0
    @State private  var cAppLogPFDataLoggingExportBackupFileButtonPresses:Int     = 0
    @State private  var cAppLogPFDataLoggingExportLastBackupFileButtonPresses:Int = 0

    @StateObject    var progressTrigger:ProgressOverlayTrigger                    = ProgressOverlayTrigger()

    @State private  var cAppLogPFDataReloadPFAdminsButtonPresses:Int              = 0
    @State private  var cAppLogPFDataReloadPFCscButtonPresses:Int                 = 0
    @State private  var cAppLogPFDataReloadPFTherapistFileButtonPresses:Int       = 0
    @State private  var cAppLogPFDataReloadPFPatientFileButtonPresses:Int         = 0
    @State private  var cAppLogPFDataReloadSchedPatLocButtonPresses:Int           = 0
    @State private  var cAppLogPFDataReloadExportSchedPatLocButtonPresses:Int     = 0
    @State private  var cAppLogPFDataReloadExportBackupFileButtonPresses:Int      = 0
    @State private  var cAppLogPFDataReloadExportLastBackupFileButtonPresses:Int  = 0

                    var jmAppDelegateVisitor:JmAppDelegateVisitor                 = JmAppDelegateVisitor.ClassSingleton.appDelegateVisitor
    @ObservedObject var jmAppParseCoreManager:JmAppParseCoreManager               = JmAppParseCoreManager.ClassSingleton.appParseCodeManager
                    var jmAppParseCoreBkgdDataRepo:JmAppParseCoreBkgdDataRepo     = JmAppParseCoreBkgdDataRepo.ClassSingleton.appParseCodeBkgdDataRepo
    
    init()
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
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
        
        let _ = xcgLogMsg("\(ClassInfo.sClsDisp):body(some View) \(ClassInfo.sClsCopyRight)...")
        
        NavigationStack
        {

            VStack
            {

                HStack(alignment:.center)
                {

                    Button
                    {

                        self.cAppLogPFDataLoggingRefreshButtonPresses += 1

                        let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppLogPFDataView.Button(Xcode).'Refresh'.#(\(self.cAppLogPFDataLoggingRefreshButtonPresses))...")

                    }
                    label:
                    {

                        VStack(alignment:.center)
                        {

                            Label("", systemImage: "arrow.clockwise")
                                .help(Text("'Refresh' App Log/Reload Data Screen..."))
                                .imageScale(.large)

                            Text("Refresh - #(\(self.cAppLogPFDataLoggingRefreshButtonPresses))...")
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
                #if os(iOS)
                    .padding()
                #endif

                    Spacer()

                    Button
                    {

                        self.cAppDataButtonPresses += 1

                        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):AppLogPFDataView.Button(Xcode).'App Data...'.#(\(self.cAppDataButtonPresses))...")

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
                                .help(Text("App Data Gatherer"))
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

                        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):AppLogPFDataView.Button(Xcode).'App WorkRoute'.#(\(self.cAppWorkRouteButtonPresses))...")

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

                        let _ = xcgLogMsg("\(ClassInfo.sClsDisp):AppLogPFDataView.Button(Xcode).'Dismiss' pressed...")

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
                #if os(macOS)
                    .buttonStyle(.borderedProminent)
                    .padding()
                //  .background(???.isPressed ? .blue : .gray)
                    .cornerRadius(10)
                    .foregroundColor(Color.primary)
                #endif
                    .padding()

                }

            //  ScrollView(.vertical)
            //  {

                List
                {

                    Section(header: Text("Data Logging Options:"))
                    {

                        HStack(alignment:.center)
                        {

                            Spacer()

                            Button
                            {

                                self.cAppLogPFDataLoggingPFAdminsButtonPresses += 1

                                let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppLogPFDataView.Button(Xcode).'App Log/Reload Data for PFAdmins'.#(\(self.cAppLogPFDataLoggingPFAdminsButtonPresses))...")

                                self.detailPFAdminsDataItems()

                            }
                            label:
                            {

                                HStack(alignment:.center)
                                {

                                    Spacer()

                                    Label("", systemImage: "arrow.down.square")
                                        .help(Text("Log Data for PFAdmins..."))
                                        .imageScale(.small)

                                    Text("Log Data (PFAdmins) - #(\(self.cAppLogPFDataLoggingPFAdminsButtonPresses))...")
                                        .font(.caption2)

                                    Spacer()

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

                        HStack(alignment:.center)
                        {

                            Spacer()

                            Button
                            {

                                self.cAppLogPFDataLoggingPFCscButtonPresses += 1

                                let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppLogPFDataView.Button(Xcode).'App Log/Reload Data for PFCsc'.#(\(self.cAppLogPFDataLoggingPFCscButtonPresses))...")

                                self.detailPFCscDataItems()

                            }
                            label:
                            {

                                HStack(alignment:.center)
                                {

                                    Spacer()

                                    Label("", systemImage: "arrow.down.square")
                                        .help(Text("Log Data for PFCsc..."))
                                        .imageScale(.small)

                                    Text("Log Data (PFCsc) - #(\(self.cAppLogPFDataLoggingPFCscButtonPresses))...")
                                        .font(.caption2)

                                    Spacer()

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

                        HStack(alignment:.center)
                        {

                            Spacer()

                            Button
                            {

                                self.cAppLogPFDataLoggingPFTherapistNamesButtonPresses += 1

                                let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppLogPFDataView.Button(Xcode).'App Log/Reload Data for PFTherapist (Names)'.#(\(self.cAppLogPFDataLoggingPFTherapistNamesButtonPresses))...")

                                self.detailTherapistNamesList()

                            }
                            label:
                            {

                                HStack(alignment:.center)
                                {

                                    Spacer()

                                    Label("", systemImage: "arrow.down.square")
                                        .help(Text("Log Data for PFTherapist (Names)..."))
                                        .imageScale(.small)

                                    Text("Log Data (PFTherapist) Names - #(\(self.cAppLogPFDataLoggingPFTherapistNamesButtonPresses))...")
                                        .font(.caption2)

                                    Spacer()

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

                        HStack(alignment:.center)
                        {

                            Spacer()

                            Button
                            {

                                self.cAppLogPFDataLoggingPFTherapistFileButtonPresses += 1

                                let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppLogPFDataView.Button(Xcode).'App Log/Reload Data for PFTherapistFile'.#(\(self.cAppLogPFDataLoggingPFTherapistFileButtonPresses))...")

                                self.detailTherapistFileItems()

                            }
                            label:
                            {

                                HStack(alignment:.center)
                                {

                                    Spacer()

                                    Label("", systemImage: "arrow.down.square")
                                        .help(Text("Log Data for PFTherapistFile..."))
                                        .imageScale(.small)

                                    Text("Log Data (PFTherapistFile) - #(\(self.cAppLogPFDataLoggingPFTherapistFileButtonPresses))...")
                                        .font(.caption2)

                                    Spacer()

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

                        HStack(alignment:.center)
                        {

                            Spacer()

                            Button
                            {

                                self.cAppLogPFDataLoggingTherapistXrefButtonPresses += 1

                                let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppLogPFDataView.Button(Xcode).'App Log Dictionary for TherapistXref'.#(\(self.cAppLogPFDataLoggingTherapistXrefButtonPresses))...")

                                self.detailTherapistXrefDict()

                            }
                            label:
                            {

                                HStack(alignment:.center)
                                {

                                    Spacer()

                                    Label("", systemImage: "arrow.down.square")
                                        .help(Text("Log Dictionary for TherapistXref..."))
                                        .imageScale(.small)

                                    Text("Log Dictionary (TherapistXref) - #(\(self.cAppLogPFDataLoggingTherapistXrefButtonPresses))...")
                                        .font(.caption2)

                                    Spacer()

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

                        HStack(alignment:.center)
                        {

                            Spacer()

                            Button
                            {

                                self.cAppLogPFDataLoggingPFPatientNamesButtonPresses += 1

                                let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppLogPFDataView.Button(Xcode).'App Log/Reload Data for PFPatient (Names)'.#(\(self.cAppLogPFDataLoggingPFPatientNamesButtonPresses))...")

                                self.detailPatientNamesList()

                            }
                            label:
                            {

                                HStack(alignment:.center)
                                {

                                    Spacer()

                                    Label("", systemImage: "arrow.down.square")
                                        .help(Text("Log Data for PFPatient (Names)..."))
                                        .imageScale(.small)

                                    Text("Log Data (PFPatient) Names - #(\(self.cAppLogPFDataLoggingPFPatientNamesButtonPresses))...")
                                        .font(.caption2)

                                    Spacer()

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

                        HStack(alignment:.center)
                        {

                            Spacer()

                            Button
                            {

                                self.cAppLogPFDataLoggingPFPatientFileButtonPresses += 1

                                let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppLogPFDataView.Button(Xcode).'App Log/Reload Data for PFPatientFile'.#(\(self.cAppLogPFDataLoggingPFPatientFileButtonPresses))...")

                                self.detailPatientFileItems()

                            }
                            label:
                            {

                                HStack(alignment:.center)
                                {

                                    Spacer()

                                    Label("", systemImage: "arrow.down.square")
                                        .help(Text("Log Data for PFPatientFile..."))
                                        .imageScale(.small)

                                    Text("Log Data (PFPatientFile) - #(\(self.cAppLogPFDataLoggingPFPatientFileButtonPresses))...")
                                        .font(.caption2)

                                    Spacer()

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

                        HStack(alignment:.center)
                        {

                            Spacer()

                            Button
                            {

                                self.cAppLogPFDataLoggingPatientXrefButtonPresses += 1

                                let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppLogPFDataView.Button(Xcode).'App Log Dictionary for PatientXref'.#(\(self.cAppLogPFDataLoggingPatientXrefButtonPresses))...")

                                self.detailPatientXrefDict()

                            }
                            label:
                            {

                                HStack(alignment:.center)
                                {

                                    Spacer()

                                    Label("", systemImage: "arrow.down.square")
                                        .help(Text("Log Dictionary for PatientXref..."))
                                        .imageScale(.small)

                                    Text("Log Dictionary (PatientXref) - #(\(self.cAppLogPFDataLoggingPatientXrefButtonPresses))...")
                                        .font(.caption2)

                                    Spacer()

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

                        HStack(alignment:.center)
                        {

                            Spacer()

                            Button
                            {

                                self.cAppLogPFDataLoggingSchedPatLocButtonPresses += 1

                                let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppLogPFDataView.Button(Xcode).'App Log/Reload Data for SchedPatLoc'.#(\(self.cAppLogPFDataLoggingSchedPatLocButtonPresses))...")

                                self.detailDictSchedPatientLocItems()

                            }
                            label:
                            {

                                HStack(alignment:.center)
                                {

                                    Spacer()

                                    Label("", systemImage: "arrow.down.square")
                                        .help(Text("Log Data for SchedPatLoc..."))
                                        .imageScale(.small)

                                    Text("Log Data (SchedPatLoc) - #(\(self.cAppLogPFDataLoggingSchedPatLocButtonPresses))...")
                                        .font(.caption2)

                                    Spacer()

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

                        HStack(alignment:.center)
                        {

                            Spacer()

                            Button
                            {

                                self.cAppLogPFDataLoggingExportSchedPatLocButtonPresses += 1

                                let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppLogPFDataView.Button(Xcode).'App Log/Reload Data for 'export' SchedPatLoc'.#(\(self.cAppLogPFDataLoggingExportSchedPatLocButtonPresses))...")

                                self.detailDictExportSchedPatientLocItems()

                            }
                            label:
                            {

                                HStack(alignment:.center)
                                {

                                    Spacer()

                                    Label("", systemImage: "arrow.down.square")
                                        .help(Text("Log Data for 'export' SchedPatLoc..."))
                                        .imageScale(.small)

                                    Text("Log Data 'export' (SchedPatLoc) - #(\(self.cAppLogPFDataLoggingExportSchedPatLocButtonPresses))...")
                                        .font(.caption2)

                                    Spacer()

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

                        HStack(alignment:.center)
                        {

                            Spacer()

                            Button
                            {

                                self.cAppLogPFDataLoggingExportBackupFileButtonPresses += 1

                                let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppLogPFDataView.Button(Xcode).'App Log/Reload Data for 'export' BackupFile Item(s)'.#(\(self.cAppLogPFDataLoggingExportBackupFileButtonPresses))...")

                                self.detailDictExportBackupFileItems()

                            }
                            label:
                            {

                                HStack(alignment:.center)
                                {

                                    Spacer()

                                    Label("", systemImage: "arrow.down.square")
                                        .help(Text("Log Data for 'export' BackupFile item(s)..."))
                                        .imageScale(.small)

                                    Text("Log Data 'export' (BackupFile) - #(\(self.cAppLogPFDataLoggingExportBackupFileButtonPresses))...")
                                        .font(.caption2)

                                    Spacer()

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

                        HStack(alignment:.center)
                        {

                            Spacer()

                            Button
                            {

                                self.cAppLogPFDataLoggingExportLastBackupFileButtonPresses += 1

                                let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppLogPFDataView.Button(Xcode).'App Log/Reload Data for 'export' LAST BackupFile Item(s)'.#(\(self.cAppLogPFDataLoggingExportLastBackupFileButtonPresses))...")

                                self.detailDictExportLastBackupFileItems()

                            }
                            label:
                            {

                                HStack(alignment:.center)
                                {

                                    Spacer()

                                    Label("", systemImage: "arrow.down.square")
                                        .help(Text("Log Data for 'export' LAST BackupFile item(s)..."))
                                        .imageScale(.small)

                                    Text("Log Data 'export' LAST (BackupFile) - #(\(self.cAppLogPFDataLoggingExportLastBackupFileButtonPresses))...")
                                        .font(.caption2)

                                    Spacer()

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

                    Section(header: Text("Data Reloading (Cloud) Options:"))
                    {

                        HStack(alignment:.center)
                        {

                            Spacer()

                            Button
                            {

                                self.cAppLogPFDataReloadPFAdminsButtonPresses += 1

                                let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppLogPFDataView.Button(Xcode).'App Reload PFData for PFAdmins'.#(\(self.cAppLogPFDataReloadPFAdminsButtonPresses))...")

                                self.reloadPFAdminsDataItems()

                            }
                            label:
                            {

                                HStack(alignment:.center)
                                {

                                    Spacer()

                                    Label("", systemImage: "icloud.and.arrow.down.fill")
                                        .help(Text("Reload PFData for PFAdmins..."))
                                        .imageScale(.small)

                                    Text("Reload PFData (PFAdmins) - #(\(self.cAppLogPFDataReloadPFAdminsButtonPresses))...")
                                        .font(.caption2)

                                    Spacer()

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

                        HStack(alignment:.center)
                        {

                            Spacer()

                            Button
                            {

                                self.cAppLogPFDataReloadPFCscButtonPresses += 1

                                let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppLogPFDataView.Button(Xcode).'App Reload PFData for PFCsc'.#(\(self.cAppLogPFDataReloadPFCscButtonPresses))...")

                                self.reloadPFCscDataItems()

                            }
                            label:
                            {

                                HStack(alignment:.center)
                                {

                                    Spacer()

                                    Label("", systemImage: "icloud.and.arrow.down.fill")
                                        .help(Text("Reload PFData for PFCsc..."))
                                        .imageScale(.small)

                                    Text("Reload PFData (PFCsc) - #(\(self.cAppLogPFDataReloadPFCscButtonPresses))...")
                                        .font(.caption2)

                                    Spacer()

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

                        HStack(alignment:.center)
                        {

                            Spacer()

                            Button
                            {

                                self.cAppLogPFDataReloadPFTherapistFileButtonPresses += 1

                                let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppLogPFDataView.Button(Xcode).'App Reload PFData for PFTherapistFile'.#(\(self.cAppLogPFDataReloadPFTherapistFileButtonPresses))...")

                                self.progressTrigger.setProgressOverlay(isProgressOverlayOn:true)

                                let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppLogPFDataView.Button(Xcode).'App Reload PFData for PFTherapistFile'.#(\(self.cAppLogPFDataReloadPFTherapistFileButtonPresses)) - 'self.progressTrigger.isProgressOverlayOn' is [\(self.progressTrigger.isProgressOverlayOn)] <should be 'true'>...")

                                DispatchQueue.main.asyncAfter(deadline:(.now() + 0.25)) 
                                {

                                    self.reloadTherapistFileItems()

                                    self.progressTrigger.setProgressOverlay(isProgressOverlayOn:false)

                                    let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppLogPFDataView.Button(Xcode).'App Reload PFData for PFTherapistFile'.#(\(self.cAppLogPFDataReloadPFTherapistFileButtonPresses)) - 'self.progressTrigger.isProgressOverlayOn' is [\(self.progressTrigger.isProgressOverlayOn)] <should be 'false'>...")

                                }

                            }
                            label:
                            {

                                HStack(alignment:.center)
                                {

                                    Spacer()

                                    Label("", systemImage: "icloud.and.arrow.down.fill")
                                        .help(Text("Reload PFData for PFTherapistFile..."))
                                        .imageScale(.small)

                                    Text("Reload PFData (PFTherapistFile) - #(\(self.cAppLogPFDataReloadPFTherapistFileButtonPresses))...")
                                        .font(.caption2)

                                    Spacer()

                                }
                                .progressOverlay(trigger:self.progressTrigger)

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

                        HStack(alignment:.center)
                        {

                            Spacer()

                            Button
                            {

                                self.cAppLogPFDataReloadPFPatientFileButtonPresses += 1

                                let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppLogPFDataView.Button(Xcode).'App Reload PFData for PFPatientFile'.#(\(self.cAppLogPFDataReloadPFPatientFileButtonPresses))...")

                                self.progressTrigger.setProgressOverlay(isProgressOverlayOn:true)

                                let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppLogPFDataView.Button(Xcode).'App Reload PFData for PFPatientFile'.#(\(self.cAppLogPFDataReloadPFPatientFileButtonPresses)) - 'self.progressTrigger.isProgressOverlayOn' is [\(self.progressTrigger.isProgressOverlayOn)] <should be 'true'>...")

                                DispatchQueue.main.asyncAfter(deadline:(.now() + 0.25)) 
                                {

                                    self.reloadPatientFileItems()

                                    self.progressTrigger.setProgressOverlay(isProgressOverlayOn:false)

                                    let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppLogPFDataView.Button(Xcode).'App Reload PFData for PFPatientFile'.#(\(self.cAppLogPFDataReloadPFPatientFileButtonPresses)) - 'self.progressTrigger.isProgressOverlayOn' is [\(self.progressTrigger.isProgressOverlayOn)] <should be 'false'>...")

                                }

                            }
                            label:
                            {

                                HStack(alignment:.center)
                                {

                                    Spacer()

                                    Label("", systemImage: "icloud.and.arrow.down.fill")
                                        .help(Text("Reload PFData for PFPatientFile..."))
                                        .imageScale(.small)

                                    Text("Reload PFData (PFPatientFile) - #(\(self.cAppLogPFDataReloadPFPatientFileButtonPresses))...")
                                        .font(.caption2)

                                    Spacer()

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

                        HStack(alignment:.center)
                        {

                            Spacer()

                            Button
                            {

                                self.cAppLogPFDataReloadSchedPatLocButtonPresses += 1

                                let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppLogPFDataView.Button(Xcode).'App Reload PFData for SchedPatLoc'.#(\(self.cAppLogPFDataReloadSchedPatLocButtonPresses))...")

                                self.reloadDictSchedPatientLocItems()

                            }
                            label:
                            {

                                HStack(alignment:.center)
                                {

                                    Spacer()

                                    Label("", systemImage: "icloud.and.arrow.down.fill")
                                        .help(Text("Reload PFData for SchedPatLoc..."))
                                        .imageScale(.small)

                                    Text("Reload PFData (SchedPatLoc) - #(\(self.cAppLogPFDataReloadSchedPatLocButtonPresses))...")
                                        .font(.caption2)

                                    Spacer()

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

                        HStack(alignment:.center)
                        {

                            Spacer()

                            Button
                            {

                                self.cAppLogPFDataReloadExportSchedPatLocButtonPresses += 1

                                let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppLogPFDataView.Button(Xcode).'App Reload PFData for 'export' SchedPatLoc'.#(\(self.cAppLogPFDataReloadExportSchedPatLocButtonPresses))...")

                                self.reloadDictExportSchedPatientLocItems()

                            }
                            label:
                            {

                                HStack(alignment:.center)
                                {

                                    Spacer()

                                    Label("", systemImage: "icloud.and.arrow.down.fill")
                                        .help(Text("Reload PFData for 'export' SchedPatLoc..."))
                                        .imageScale(.small)

                                    Text("Reload PFData 'export' (SchedPatLoc) - #(\(self.cAppLogPFDataReloadExportSchedPatLocButtonPresses))...")
                                        .font(.caption2)

                                    Spacer()

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

                        HStack(alignment:.center)
                        {

                            Spacer()

                            Button
                            {

                                self.cAppLogPFDataLoggingExportBackupFileButtonPresses += 1

                                let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppLogPFDataView.Button(Xcode).'App Reload PFData for 'export' BackupFIle item(s)'.#(\(self.cAppLogPFDataLoggingExportBackupFileButtonPresses))...")

                                self.reloadDictExportBackupFileItems()

                            }
                            label:
                            {

                                HStack(alignment:.center)
                                {

                                    Spacer()

                                    Label("", systemImage: "icloud.and.arrow.down.fill")
                                        .help(Text("Reload PFData for 'export' BackupFile item(s)..."))
                                        .imageScale(.small)

                                    Text("Reload PFData 'export' (BackupFile) - #(\(self.cAppLogPFDataLoggingExportBackupFileButtonPresses))...")
                                        .font(.caption2)

                                    Spacer()

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

                        HStack(alignment:.center)
                        {

                            Spacer()

                            Button
                            {

                                self.cAppLogPFDataLoggingExportLastBackupFileButtonPresses += 1

                                let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppLogPFDataView.Button(Xcode).'App Reload PFData for 'export' LAST BackupFIle item(s)'.#(\(self.cAppLogPFDataLoggingExportLastBackupFileButtonPresses))...")

                                self.reloadDictExportBackupFileItems()

                            }
                            label:
                            {

                                HStack(alignment:.center)
                                {

                                    Spacer()

                                    Label("", systemImage: "icloud.and.arrow.down.fill")
                                        .help(Text("Reload PFData for 'export' LAST BackupFile item(s)..."))
                                        .imageScale(.small)

                                    Text("Reload PFData 'export' LAST (BackupFile) - #(\(self.cAppLogPFDataLoggingExportLastBackupFileButtonPresses))...")
                                        .font(.caption2)

                                    Spacer()

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

                }

            //  }

            }

        }
        .padding()
        
    }
    
    // 'Logging' Method(s):

    private func detailPFAdminsDataItems()
    {
    
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
    
        // Log BOTH of the ParseCoreManager and ParseCoreBkgdDataRepo PFAdminsDataItem(s)...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Displaying 'jmAppParseCoreManager' #(\(self.jmAppParseCoreManager.dictPFAdminsDataItems.count)) PFAdminsDataItem(s)...")
    
        self.jmAppParseCoreManager.displayDictPFAdminsDataItems()
    
        self.xcgLogMsg("\(sCurrMethodDisp) Displaying 'jmAppParseCoreBkgdDataRepo' #(\(self.jmAppParseCoreBkgdDataRepo.dictPFAdminsDataItems.count)) PFAdminsDataItem(s)...")
    
        self.jmAppParseCoreBkgdDataRepo.displayDictPFAdminsDataItems()
    
        // Exit...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
    
        return
    
    }   // End of private func detailPFAdminsDataItems()

    private func detailPFCscDataItems()
    {
    
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
    
        // Log BOTH of the ParseCoreManager and ParseCoreBkgdDataRepo PFCscDataItem(s)...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Displaying 'jmAppParseCoreManager' #(\(self.jmAppParseCoreManager.listPFCscDataItems.count)) PFCscDataItem(s)...")
    
        self.jmAppParseCoreManager.displayListPFCscDataItems()
    
        self.xcgLogMsg("\(sCurrMethodDisp) Displaying 'jmAppParseCoreBkgdDataRepo' #(\(self.jmAppParseCoreBkgdDataRepo.listPFCscDataItems.count)) PFCscDataItem(s)...")
    
        self.jmAppParseCoreBkgdDataRepo.displayListPFCscDataItems()
    
        // Exit...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
    
        return
    
    }   // End of private func detailPFCscDataItems()

    private func detailTherapistNamesList()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
    
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
    
        // Detail all Therapist 'name(s)' in the dictionary...
    
        if (self.jmAppParseCoreManager.dictPFTherapistFileItems.count < 1)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) Intermediate #1 - 'self.jmAppParseCoreManager.dictPFTherapistFileItems' is an empty 'dictionary' - unable to detail the item(s) - Warning!")
            
            // Exit:
    
            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
    
            return
        
        }
    
        self.xcgLogMsg("\(sCurrMethodDisp) Intermediate #2 - 'self.jmAppParseCoreManager.dictPFTherapistFileItems' contains (\(self.jmAppParseCoreManager.dictPFTherapistFileItems.count)) item(s)...")
    
        var cTherapistNames:Int = 0
        
        for (iPFTherapistParseTID, pfTherapistFileItem) in self.jmAppParseCoreManager.dictPFTherapistFileItems
        {
    
            if (iPFTherapistParseTID < 0)
            {
    
                self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cTherapistNames)) 'iPFTherapistParseTID' - the 'tid' field is less than 0 - Warning!")
    
                continue
    
            }
    
            cTherapistNames += 1
            
            let sTherapistTName:String = pfTherapistFileItem.sPFTherapistFileName
    
            self.xcgLogMsg("\(sCurrMethodDisp) #(\(cTherapistNames)): 'iPFTherapistParseTID' is (\(iPFTherapistParseTID)) - 'sTherapistTName' is [\(sTherapistTName)] - 'pfTherapistFileItem' is [\(pfTherapistFileItem)]...")
    
        }
    
        self.xcgLogMsg("\(sCurrMethodDisp) Intermediate #3 - detailed (\(cTherapistNames)) names(s) in a dictionary of (\(self.jmAppParseCoreManager.dictPFTherapistFileItems.count)) item(s)...")
    
        // Exit:
    
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
    
        return
    
    }   // End of private func detailTherapistNamesList().

    private func detailTherapistFileItems()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Detail all TherapistFile 'item(s)' in the JmAppParseCoreManger of the JmAppDelegateVisitor...

        if (self.jmAppDelegateVisitor.jmAppParseCoreManager != nil)
        {

            if (self.jmAppDelegateVisitor.jmAppParseCoreManager!.dictPFTherapistFileItems.count > 0)
            {

                self.xcgLogMsg("\(sCurrMethodDisp) Displaying the 'jmAppParseCoreManager' dictionary of #(\(self.jmAppDelegateVisitor.jmAppParseCoreManager!.dictPFTherapistFileItems.count)) 'dictPFTherapistFileItems' item(s)...")

                var cPFTherapistParseTIDs:Int = 0

                for (iPFTherapistParseTID, pfTherapistFileItem) in self.jmAppDelegateVisitor.jmAppParseCoreManager!.dictPFTherapistFileItems
                {

                    cPFTherapistParseTIDs += 1

                    if (iPFTherapistParseTID < 0)
                    {

                        self.xcgLogMsg("\(sCurrMethodDisp) 'jmAppParseCoreManager' Skipping object #(\(cPFTherapistParseTIDs)) 'iPFTherapistParseTID' - the 'tid' field is less than 0 - Warning!")

                        continue

                    }

                    self.xcgLogMsg("\(sCurrMethodDisp) 'jmAppParseCoreManager' For TID [\(iPFTherapistParseTID)] - Displaying 'pfTherapistFileItem' item #(\(cPFTherapistParseTIDs)):")

                    pfTherapistFileItem.displayParsePFTherapistFileItemToLog()

                }

            }
            else
            {

                self.xcgLogMsg("\(sCurrMethodDisp) Unable to display the 'jmAppParseCoreManager' dictionary of 'dictPFTherapistFileItems' item(s) - item(s) count is less than 1 - Warning!")

            }

        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) 'jmAppParseCoreManager' is nil - unable to get the dictionary 'dictPFTherapistFileItems' - Error!")

        }

        // Detail all TherapistFile 'item(s)' in the JmAppParseCoreBkgdDataRepo of the JmAppDelegateVisitor...

        if (self.jmAppParseCoreBkgdDataRepo.dictPFTherapistFileItems.count > 0)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Displaying the 'jmAppParseCoreBkgdDataRepo' dictionary of #(\(self.jmAppParseCoreBkgdDataRepo.dictPFTherapistFileItems.count)) 'dictPFTherapistFileItems' item(s)...")

            var cPFTherapistParseTIDs:Int = 0

            for (iPFTherapistParseTID, pfTherapistFileItem) in self.jmAppParseCoreBkgdDataRepo.dictPFTherapistFileItems
            {

                cPFTherapistParseTIDs += 1

                if (iPFTherapistParseTID < 0)
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) 'jmAppParseCoreBkgdDataRepo' Skipping object #(\(cPFTherapistParseTIDs)) 'iPFTherapistParseTID' - the 'tid' field is less than 0 - Warning!")

                    continue

                }

                self.xcgLogMsg("\(sCurrMethodDisp) 'jmAppParseCoreBkgdDataRepo' For TID [\(iPFTherapistParseTID)] - Displaying 'pfTherapistFileItem' item #(\(cPFTherapistParseTIDs)):")

                pfTherapistFileItem.displayParsePFTherapistFileItemToLog()

            }

        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) 'jmAppParseCoreBkgdDataRepo' Unable to display the dictionary of 'dictPFTherapistFileItems' item(s) - item(s) count is less than 1 - Warning!")

        }

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of private func detailTherapistFileItems().

    private func detailTherapistXrefDict()
    {
    
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
    
        // Log BOTH of the ParseCoreManager and ParseCoreBkgdDataRepo 'dictTherapistTidXref(s)'...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Displaying 'jmAppParseCoreManager' #(\(self.jmAppParseCoreManager.dictTherapistTidXref.count)) 'dictTherapistTidXref(s)'...")
    
        self.jmAppParseCoreManager.displayDictTherapistTidXfef()
    
        self.xcgLogMsg("\(sCurrMethodDisp) Displaying 'jmAppParseCoreBkgdDataRepo' #(\(self.jmAppParseCoreBkgdDataRepo.dictTherapistTidXref.count)) 'dictTherapistTidXref(s)'...")
    
        self.jmAppParseCoreBkgdDataRepo.displayDictTherapistTidXfef()
    
        // Exit...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
    
        return
    
    }   // End of private func detailTherapistXrefDict()

    private func detailPatientNamesList()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
    
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
    
        // Detail all Patient 'name(s)' in the dictionary...
    
        if (self.jmAppParseCoreManager.dictPFPatientFileItems.count < 1)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) Intermediate #1 - 'self.jmAppParseCoreManager.dictPFPatientFileItems' is an empty 'dictionary' - unable to detail the item(s) - Warning!")
            
            // Exit:
    
            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
    
            return
        
        }
    
        self.xcgLogMsg("\(sCurrMethodDisp) Intermediate #2 - 'self.jmAppParseCoreManager.dictPFPatientFileItems' contains (\(self.jmAppParseCoreManager.dictPFPatientFileItems.count)) item(s)...")
    
        var cPatientNames:Int = 0
        
        for (iPFPatientParseTID, pfPatientFileItem) in self.jmAppParseCoreManager.dictPFPatientFileItems
        {
    
            if (iPFPatientParseTID < 0)
            {
    
                self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cPatientNames)) 'iPFPatientParseTID' - the 'tid' field is less than 0 - Warning!")
    
                continue
    
            }
    
            cPatientNames += 1
            
            let sPatientTName:String = pfPatientFileItem.sPFPatientFileName
    
            self.xcgLogMsg("\(sCurrMethodDisp) #(\(cPatientNames)): 'iPFPatientParseTID' is (\(iPFPatientParseTID)) - 'sPatientTName' is [\(sPatientTName)] - 'pfPatientFileItem' is [\(pfPatientFileItem)]...")
    
        }
    
        self.xcgLogMsg("\(sCurrMethodDisp) Intermediate #3 - detailed (\(cPatientNames)) names(s) in a dictionary of (\(self.jmAppParseCoreManager.dictPFPatientFileItems.count)) item(s)...")
    
        // Exit:
    
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
    
        return
    
    }   // End of private func detailPatientNamesList().

    private func detailPatientFileItems()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Detail all PatientFile 'item(s)' in the JmAppParseCoreManger of the JmAppDelegateVisitor...

        if (self.jmAppDelegateVisitor.jmAppParseCoreManager != nil)
        {

            if (self.jmAppDelegateVisitor.jmAppParseCoreManager!.dictPFPatientFileItems.count > 0)
            {

                self.xcgLogMsg("\(sCurrMethodDisp) Displaying the 'jmAppParseCoreManager' dictionary of #(\(self.jmAppDelegateVisitor.jmAppParseCoreManager!.dictPFPatientFileItems.count)) 'dictPFPatientFileItems' item(s)...")

                var cPFPatientParsePIDs:Int = 0

                for (iPFPatientParsePID, pfPatientFileItem) in self.jmAppDelegateVisitor.jmAppParseCoreManager!.dictPFPatientFileItems
                {

                    cPFPatientParsePIDs += 1

                    if (iPFPatientParsePID < 0)
                    {

                        self.xcgLogMsg("\(sCurrMethodDisp) 'jmAppParseCoreManager' Skipping object #(\(cPFPatientParsePIDs)) 'iPFPatientParsePID' - the 'pid' field is less than 0 - Warning!")

                        continue

                    }

                    self.xcgLogMsg("\(sCurrMethodDisp) 'jmAppParseCoreManager' For PID [\(iPFPatientParsePID)] - Displaying 'pfPatientFileItem' item #(\(cPFPatientParsePIDs)):")

                    pfPatientFileItem.displayParsePFPatientFileItemToLog()

                }

            }
            else
            {

                self.xcgLogMsg("\(sCurrMethodDisp) Unable to display the 'jmAppParseCoreManager' dictionary of 'dictPFPatientFileItems' item(s) - item(s) count is less than 1 - Warning!")

            }

        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) 'jmAppParseCoreManager' is nil - unable to get the dictionary 'dictPFPatientFileItems' - Error!")

        }

        // Detail all PatientFile 'item(s)' in the JmAppParseCoreBkgdDataRepo of the JmAppDelegateVisitor...

        if (self.jmAppParseCoreBkgdDataRepo.dictPFPatientFileItems.count > 0)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Displaying the 'jmAppParseCoreBkgdDataRepo' dictionary of #(\(self.jmAppParseCoreBkgdDataRepo.dictPFPatientFileItems.count)) 'dictPFPatientFileItems' item(s)...")

            var cPFPatientParsePIDs:Int = 0

            for (iPFPatientParsePID, pfPatientFileItem) in self.jmAppParseCoreBkgdDataRepo.dictPFPatientFileItems
            {

                cPFPatientParsePIDs += 1

                if (iPFPatientParsePID < 0)
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) 'jmAppParseCoreBkgdDataRepo' Skipping object #(\(cPFPatientParsePIDs)) 'iPFPatientParsePID' - the 'pid' field is less than 0 - Warning!")

                    continue

                }

                self.xcgLogMsg("\(sCurrMethodDisp) 'jmAppParseCoreBkgdDataRepo' For PID [\(iPFPatientParsePID)] - Displaying 'pfPatientFileItem' item #(\(cPFPatientParsePIDs)):")

                pfPatientFileItem.displayParsePFPatientFileItemToLog()

            }

        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) 'jmAppParseCoreBkgdDataRepo' Unable to display the dictionary of 'dictPFPatientFileItems' item(s) - item(s) count is less than 1 - Warning!")

        }

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of private func detailPatientFileItems().

    private func detailPatientXrefDict()
    {
    
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
    
        // Log BOTH of the ParseCoreManager and ParseCoreBkgdDataRepo 'dictPatientTidXref(s)'...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Displaying 'jmAppParseCoreManager' #(\(self.jmAppParseCoreManager.dictPatientPidXref.count)) 'dictPatientTidXref(s)'...")
    
        self.jmAppParseCoreManager.displayDictPatientPidXfef()
    
        self.xcgLogMsg("\(sCurrMethodDisp) Displaying 'jmAppParseCoreBkgdDataRepo' #(\(self.jmAppParseCoreBkgdDataRepo.dictPatientPidXref.count)) 'dictPatientPidXref(s)'...")
    
        self.jmAppParseCoreBkgdDataRepo.displayDictPatientPidXfef()
    
        // Exit...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
    
        return
    
    }   // End of private func detailPatientXrefDict()

    private func detailDictSchedPatientLocItems()
    {
    
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
    
        // Log BOTH of the ParseCoreManager and ParseCoreBkgdDataRepo PFSchedPatientLocItems...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Displaying 'jmAppParseCoreManager' #(\(self.jmAppParseCoreManager.dictSchedPatientLocItems.count)) dictionary of ScheduledPatientLocationItem(s)...")
    
        self.jmAppParseCoreManager.displayDictSchedPatientLocItems()
    
        self.xcgLogMsg("\(sCurrMethodDisp) Displaying 'jmAppParseCoreBkgdDataRepo' #(\(self.jmAppParseCoreBkgdDataRepo.dictSchedPatientLocItems.count)) dictionary of ScheduledPatientLocationItem(s)")
    
        self.jmAppParseCoreBkgdDataRepo.displayDictSchedPatientLocItems()
    
        // Exit...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
    
        return
    
    }   // End of private func detailDictSchedPatientLocItems()

    private func detailDictExportSchedPatientLocItems()
    {
    
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
    
        // Log ParseCoreBkgdDataRepo PFSchedPatientLocItems...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Displaying 'jmAppParseCoreBkgdDataRepo' #(\(self.jmAppParseCoreBkgdDataRepo.dictExportSchedPatientLocItems.count)) dictionary of 'export' ScheduledPatientLocationItem(s)")
    
        self.jmAppParseCoreBkgdDataRepo.displayDictExportSchedPatientLocItems()
    
        // Exit...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
    
        return
    
    }   // End of private func detailDictExportSchedPatientLocItems()

    private func detailDictExportBackupFileItems()
    {
    
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
    
        // Log ParseCoreBkgdDataRepo PFBackupFileItems...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Displaying 'jmAppParseCoreBkgdDataRepo' #(\(self.jmAppParseCoreBkgdDataRepo.dictExportBackupFileItems.count)) dictionary of 'export' ScheduledPatientLocationItem(s)")
    
        self.jmAppParseCoreBkgdDataRepo.displayDictExportBackupFileItems()
    
        // Exit...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
    
        return
    
    }   // End of private func detailDictExportBackupFileItems()

    private func detailDictExportLastBackupFileItems()
    {
    
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
    
        // Log ParseCoreBkgdDataRepo LAST PFBackupFileItems...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Displaying 'jmAppParseCoreBkgdDataRepo' #(\(self.jmAppParseCoreBkgdDataRepo.dictExportLastBackupFileItems.count)) dictionary of 'export' ScheduledPatientLocationItem(s)")
    
        self.jmAppParseCoreBkgdDataRepo.displayDictExportLastBackupFileItems()
    
        // Exit...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
    
        return
    
    }   // End of private func detailDictExportLastBackupFileItems()

    // 'Reload' Method(s):

    private func reloadPFAdminsDataItems()
    {
    
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
    
        // Reload the ParseCoreBkgdDataRepo PFAdminsDataItem(s) (deepcopy to ParseCoreManager)...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Calling the 'jmAppParseCoreBkgdDataRepo' method 'getJmAppParsePFQueryForAdmins()' to get a 'authentication' dictionary...")

        let _ = self.jmAppParseCoreBkgdDataRepo.getJmAppParsePFQueryForAdmins(bForceReloadOfPFQuery:true)

        self.xcgLogMsg("\(sCurrMethodDisp) Called  the 'jmAppParseCoreBkgdDataRepo' method 'getJmAppParsePFQueryForAdmins()' to get a 'authentication' dictionary...")

        self.xcgLogMsg("\(sCurrMethodDisp) Displaying 'jmAppParseCoreBkgdDataRepo' #(\(self.jmAppParseCoreBkgdDataRepo.dictPFAdminsDataItems.count)) PFAdminsDataItem(s)...")
    
        self.jmAppParseCoreBkgdDataRepo.displayDictPFAdminsDataItems()
    
        self.xcgLogMsg("\(sCurrMethodDisp) Displaying 'jmAppParseCoreManager' #(\(self.jmAppParseCoreManager.dictPFAdminsDataItems.count)) PFAdminsDataItem(s)...")
    
        self.jmAppParseCoreManager.displayDictPFAdminsDataItems()
    
        // Exit...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
    
        return
    
    }   // End of private func reloadPFAdminsDataItems()

    private func reloadPFCscDataItems()
    {
    
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
    
        self.xcgLogMsg("\(sCurrMethodDisp) Calling the 'jmAppParseCoreBkgdDataRepo' method 'getJmAppParsePFQueryForCSC()' to get a 'location' list...")

        let _ = self.jmAppParseCoreBkgdDataRepo.getJmAppParsePFQueryForCSC()

        self.xcgLogMsg("\(sCurrMethodDisp) Called  the 'jmAppParseCoreBkgdDataRepo' method 'getJmAppParsePFQueryForCSC()' to get a 'location' list...")

        self.xcgLogMsg("\(sCurrMethodDisp) <Timer> Calling the 'jmAppParseCoreBkgdDataRepo' 'deep copy' method...")

        let _ = self.jmAppParseCoreBkgdDataRepo.deepCopyDictPFAdminsDataItems()

        self.xcgLogMsg("\(sCurrMethodDisp) <Timer> Called  the 'jmAppParseCoreBkgdDataRepo' 'deep copy' method...")

        if (self.jmAppParseCoreManager.listPFCscDataItems.count < 1)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) 'jmAppParseCoreManager' has a 'listPFCscDataItems' that is 'empty'...")

        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) 'jmAppParseCoreManager' has a 'listPFCscDataItems' that is [\(String(describing: jmAppDelegateVisitor.jmAppParseCoreManager?.listPFCscDataItems))]...")

            self.xcgLogMsg("\(sCurrMethodDisp) Sorting #(\(self.jmAppParseCoreManager.listPFCscDataItems.count)) Item(s) in the 'jmAppParseCoreManager.listPFCscDataItems' of [\(self.jmAppParseCoreManager.listPFCscDataItems)]...")

            self.jmAppParseCoreManager.listPFCscDataItems.sort
            { (pfCscDataItem1, pfCscDataItem2) in

            //  Compare for Sort: '<' sorts 'ascending' and '>' sorts 'descending'...

            var bIsItem1GreaterThanItem2:Bool = false

            if (pfCscDataItem1.sPFCscParseLastLocDate != pfCscDataItem2.sPFCscParseLastLocDate)
            {
                bIsItem1GreaterThanItem2 = (pfCscDataItem1.sPFCscParseLastLocDate > pfCscDataItem2.sPFCscParseLastLocDate)
            }
            else
            {
            //  bIsItem1GreaterThanItem2:Bool = (pfCscDataItem1.sPFCscParseLastLocTime < pfCscDataItem2.sPFCscParseLastLocTime)
                bIsItem1GreaterThanItem2 = (pfCscDataItem1.sPFCscParseLastLocTime > pfCscDataItem2.sPFCscParseLastLocTime)
            }

            //  self.xcgLogMsg("\(sCurrMethodDisp) Sort <OP> Returning 'bIsItem1GreaterThanItem2' of [\(bIsItem1GreaterThanItem2)] because 'pfCscDataItem1.sPFCscParseLastLocTime' is [\(pfCscDataItem1.sPFCscParseLastLocTime)] and is less than 'pfCscDataItem2.sPFCscParseLastLocTime' is [\(pfCscDataItem2.sPFCscParseLastLocTime)]...")

                return bIsItem1GreaterThanItem2

            }

            self.xcgLogMsg("\(sCurrMethodDisp) Sorted  #(\(self.jmAppParseCoreManager.listPFCscDataItems.count)) Item(s) in the 'jmAppParseCoreManager.listPFCscDataItems' of [\(self.jmAppParseCoreManager.listPFCscDataItems)]...")

        }

        // Exit...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
    
        return
    
    }   // End of private func reloadPFCscDataItems()

    private func reloadTherapistFileItems()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Reload the ParseCoreBkgdDataRepo PFTherapistFileItem(s) (deepcopy to ParseCoreManager)...

    //  self.isAppLogPFDataReloading = true
    //  self.progressTrigger.isProgressOverlayOn = true
    
        self.xcgLogMsg("\(sCurrMethodDisp) Calling the 'jmAppParseCoreBkgdDataRepo' method 'getJmAppParsePFQueryForTherapistFileToAddToAdmins()' to get Therapist dictionaries (TherapistFile, TherapistXref, TherapistNames)...")

        let _ = self.jmAppParseCoreBkgdDataRepo.getJmAppParsePFQueryForTherapistFileToAddToAdmins(bForceReloadOfPFQuery:true)

        self.xcgLogMsg("\(sCurrMethodDisp) Called  the 'jmAppParseCoreBkgdDataRepo' method 'getJmAppParsePFQueryForTherapistFileToAddToAdmins()' to get Therapist dictionaries (TherapistFile, TherapistXref, TherapistNames)...")
        
    //  self.isAppLogPFDataReloading = false
    //  self.progressTrigger.isProgressOverlayOn = false

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of private func reloadTherapistFileItems().

    private func reloadPatientFileItems()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Reload the ParseCoreBkgdDataRepo PFPatientFileItem(s) (deepcopy to ParseCoreManager)...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Calling the 'jmAppParseCoreBkgdDataRepo' method 'gatherJmAppParsePFQueriesForPatientFileInBackground()' to get Patient lists (PatientFile, PatientXref)...")

        let _ = self.jmAppParseCoreBkgdDataRepo.gatherJmAppParsePFQueriesForPatientFileInBackground(bForceReloadOfPFQuery:true)

        self.xcgLogMsg("\(sCurrMethodDisp) Called  the 'jmAppParseCoreBkgdDataRepo' method 'gatherJmAppParsePFQueriesForPatientFileInBackground()' to get Patient lists (PatientFile, PatientXref)...")

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of private func reloadPatientFileItems().

    private func reloadDictSchedPatientLocItems()
    {
    
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Reload the ParseCoreBkgdDataRepo PFSchedPatientLocItem(s) (deepcopy to ParseCoreManager)...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Calling the 'jmAppParseCoreBkgdDataRepo' method 'gatherJmAppParsePFQueriesForScheduledLocationsInBackground()' to get ScheduledPatientLocation item(s)...")

        let _ = self.jmAppParseCoreBkgdDataRepo.gatherJmAppParsePFQueriesForScheduledLocationsInBackground(bForceReloadOfPFQuery:true)

        self.xcgLogMsg("\(sCurrMethodDisp) Called  the 'jmAppParseCoreBkgdDataRepo' method 'gatherJmAppParsePFQueriesForScheduledLocationsInBackground()' to get ScheduledPatientLocation item(s)...")
    
        // Exit...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
    
        return
    
    }   // End of private func reloadDictSchedPatientLocItems()

    private func reloadDictExportSchedPatientLocItems()
    {
    
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Reload the ParseCoreBkgdDataRepo PFSchedPatientLocItems...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Calling the 'jmAppParseCoreBkgdDataRepo' method 'fetchJmAppPFQueriesForPatientCalDayForExport()' to get ScheduledPatientLocation item(s)...")

    //  let _ = self.jmAppParseCoreBkgdDataRepo.fetchJmAppPFQueriesForPatientCalDayForExport(bForceReloadOfPFQuery:true, iTherapistTID:-1, sExportSchedulesStartWeek:String = "", sExportSchedulesEndWeek:String = "")

        self.xcgLogMsg("\(sCurrMethodDisp) Called  the 'jmAppParseCoreBkgdDataRepo' method 'fetchJmAppPFQueriesForPatientCalDayForExport()' to get ScheduledPatientLocation item(s)...")
    
        // Exit...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
    
        return
    
    }   // End of private func reloadDictExportSchedPatientLocItems()

    private func reloadDictExportBackupFileItems()
    {
    
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Reload the ParseCoreBkgdDataRepo PFBackupFileItems...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Calling the 'jmAppParseCoreBkgdDataRepo' method 'fetchJmAppPFQueriesForBackupVisitForExport()' to get ScheduledPatientLocation item(s)...")

    //  let _ = self.jmAppParseCoreBkgdDataRepo.fetchJmAppPFQueriesForBackupVisitForExport(bForceReloadOfPFQuery:true, iTherapistTID:-1, sExportSchedulesStartWeek:String = "", sExportSchedulesEndWeek:String = "")

        self.xcgLogMsg("\(sCurrMethodDisp) Called  the 'jmAppParseCoreBkgdDataRepo' method 'fetchJmAppPFQueriesForBackupVisitForExport()' to get ScheduledPatientLocation item(s)...")
    
        // Exit...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
    
        return
    
    }   // End of private func reloadDictExportBackupFileItems()

    private func reloadDictExportLastBackupFileItems()
    {
    
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Reload the ParseCoreBkgdDataRepo LAST PFBackupFileItems...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Calling the 'jmAppParseCoreBkgdDataRepo' method 'fetchJmAppPFQueriesForBackupVisitForExport()' to get ScheduledPatientLocation item(s)...")

    //  let _ = self.jmAppParseCoreBkgdDataRepo.fetchJmAppPFQueriesForBackupVisitForExport(bForceReloadOfPFQuery:true, iTherapistTID:-1, sExportSchedulesStartWeek:String = "", sExportSchedulesEndWeek:String = "")

        self.xcgLogMsg("\(sCurrMethodDisp) Called  the 'jmAppParseCoreBkgdDataRepo' method 'fetchJmAppPFQueriesForBackupVisitForExport()' to get ScheduledPatientLocation item(s)...")
    
        // Exit...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
    
        return
    
    }   // End of private func reloadDictExportLastBackupFileItems()

}   // End of struct AppLogPFDataView(View).

#Preview 
{
    
    AppLogPFDataView()
    
}

