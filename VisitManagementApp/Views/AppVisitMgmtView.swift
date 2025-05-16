//
//  AppVisitMgmtView.swift
//  VisitManagementApp
//
//  Created by Daryl Cox on 12/26/2024.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
import SwiftUI

struct AppVisitMgmtView: View 
{
    
    struct ClassInfo
    {
        
        static let sClsId        = "AppVisitMgmtView"
        static let sClsVers      = "v1.1002"
        static let sClsDisp      = sClsId+"(.swift).("+sClsVers+"):"
        static let sClsCopyRight = "Copyright (C) JustMacApps 2023-2025. All Rights Reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }
    
    // App Data field(s):

//  @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    
//  @StateObject    var jmAppParseCoreManager:JmAppParseCoreManager
    
    @State private  var cAppLogPFDataButtonPresses:Int              = 0
    @State private  var cAppVisitMgmtViewRefreshButtonPresses:Int   = 0
    @State private  var cContentViewAppWorkRouteButtonPresses:Int   = 0
    @State private  var cAppVisitMgmtViewTherapistButtonPresses:Int = 0
    @State private  var cAppVisitMgmtViewPatientButtonPresses:Int   = 0
    @State private  var cAppVisitMgmtViewCoreLocButtonPresses:Int   = 0

    @State private  var isAppLogPFDataViewModal:Bool                = false
    @State private  var isAppWorkRouteViewModal:Bool                = false
    @State private  var isAppDataTherapist1ViewModal:Bool           = false
    @State private  var isAppDataTherapist2ViewModal:Bool           = false
    @State private  var isAppDataTherapist3ViewModal:Bool           = false
    @State private  var isAppDataPatient1ViewModal:Bool             = false
    @State private  var isAppDataPatient2ViewModal:Bool             = false
    @State private  var isAppDataPatient3ViewModal:Bool             = false
    @State private  var isAppDataCoreLocViewModal:Bool              = false

                    var jmAppDelegateVisitor:JmAppDelegateVisitor   = JmAppDelegateVisitor.ClassSingleton.appDelegateVisitor
    @ObservedObject var jmAppParseCoreManager:JmAppParseCoreManager = JmAppParseCoreManager.ClassSingleton.appParseCodeManager
    
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
        
        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):body(some View) \(JmXcodeBuildSettings.jmAppVersionAndBuildNumber)...")
        
        NavigationStack
        {

            VStack
            {

                HStack(alignment:.center)
                {

                    if (AppGlobalInfo.bPerformAppDevTesting == true)
                    {

                        Button
                        {

                            self.cAppLogPFDataButtonPresses += 1

                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):AppVisitMgmtView.Button(Xcode).'Log/Reload Data'.#(\(self.cAppLogPFDataButtonPresses)) pressed...")

                            self.isAppLogPFDataViewModal.toggle()

                        //  self.detailPFCscDataItems()

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

                    }

                    Spacer()

                    Button
                    {

                        self.cAppVisitMgmtViewRefreshButtonPresses += 1

                        let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppVisitMgmtView.Button(Xcode).'Refresh'.#(\(self.cAppVisitMgmtViewRefreshButtonPresses))...")

                    }
                    label:
                    {

                        VStack(alignment:.center)
                        {

                            Label("", systemImage: "arrow.clockwise")
                                .help(Text("'Refresh' App Data Gatherer Screen..."))
                                .imageScale(.large)

                            Text("Refresh - #(\(self.cAppVisitMgmtViewRefreshButtonPresses))...")
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

                    Button
                    {

                        self.cContentViewAppWorkRouteButtonPresses += 1

                        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):ContentView.Button(Xcode).'App WorkRoute'.#(\(self.cContentViewAppWorkRouteButtonPresses))...")

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

                        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):AppVisitMgmtView.Button(Xcode).'Dismiss' pressed...")

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

                Text("")

            //  ScrollView(.vertical)
            //  {

                List
                {

                    Section
                    {

                    //  HStack(alignment:.center)
                    //  {
                    //
                    //      Spacer()
                    //
                    //      Button
                    //      {
                    //
                    //          self.cAppVisitMgmtViewTherapistButtonPresses += 1
                    //
                    //          let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppVisitMgmtView.Button(Xcode).'Therapist Gatherer by TID'.#(\(self.cAppVisitMgmtViewTherapistButtonPresses))...")
                    //
                    //          self.isAppDataTherapist1ViewModal.toggle()
                    //
                    //      }
                    //      label:
                    //      {
                    //
                    //          VStack(alignment:.center)
                    //          {
                    //
                    //              Label("", systemImage: "bed.double")
                    //                  .help(Text("Therapist Data Gatherer #1 by TID Screen..."))
                    //                  .imageScale(.medium)
                    //
                    //              Text("Therapist - Data Gatherer by TID - #(\(self.cAppVisitMgmtViewTherapistButtonPresses))...")
                    //                  .font(.caption2)
                    //
                    //          }
                    //
                    //      }
                    //  #if os(macOS)
                    //      .sheet(isPresented:$isAppDataTherapist1ViewModal, content:
                    //          {
                    //
                    //              AppVisitMgmtTherapist1View()
                    //
                    //          }
                    //      )
                    //  #endif
                    //  #if os(iOS)
                    //      .fullScreenCover(isPresented:$isAppDataTherapist1ViewModal)
                    //      {
                    //
                    //          AppVisitMgmtTherapist1View()
                    //
                    //      }
                    //  #endif
                    //  #if os(macOS)
                    //      .buttonStyle(.borderedProminent)
                    //      .padding()
                    //  //  .background(???.isPressed ? .blue : .gray)
                    //      .cornerRadius(10)
                    //      .foregroundColor(Color.primary)
                    //  #endif
                    //
                    //      Spacer()
                    //
                    //  }
                    //
                    //  HStack(alignment:.center)
                    //  {
                    //
                    //      Spacer()
                    //
                    //      Button
                    //      {
                    //
                    //          self.cAppVisitMgmtViewTherapistButtonPresses += 1
                    //
                    //          let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppVisitMgmtView.Button(Xcode).'Therapist Gatherer by tName'.#(\(self.cAppVisitMgmtViewTherapistButtonPresses))...")
                    //
                    //          self.isAppDataTherapist2ViewModal.toggle()
                    //
                    //      }
                    //      label:
                    //      {
                    //
                    //          VStack(alignment:.center)
                    //          {
                    //
                    //              Label("", systemImage: "bed.double")
                    //                  .help(Text("Therapist Data Gatherer #2 by tName Screen..."))
                    //                  .imageScale(.medium)
                    //
                    //              Text("Therapist - Data Gatherer by tName - #(\(self.cAppVisitMgmtViewTherapistButtonPresses))...")
                    //                  .font(.caption2)
                    //
                    //          }
                    //
                    //      }
                    //  #if os(macOS)
                    //      .sheet(isPresented:$isAppDataTherapist2ViewModal, content:
                    //          {
                    //
                    //              AppVisitMgmtTherapist2View()
                    //
                    //          }
                    //      )
                    //  #endif
                    //  #if os(iOS)
                    //      .fullScreenCover(isPresented:$isAppDataTherapist2ViewModal)
                    //      {
                    //
                    //          AppVisitMgmtTherapist2View()
                    //
                    //      }
                    //  #endif
                    //  #if os(macOS)
                    //      .buttonStyle(.borderedProminent)
                    //      .padding()
                    //  //  .background(???.isPressed ? .blue : .gray)
                    //      .cornerRadius(10)
                    //      .foregroundColor(Color.primary)
                    //  #endif
                    //
                    //      Spacer()
                    //
                    //  }

                        HStack(alignment:.center)
                        {

                            Spacer()

                            Button
                            {

                                self.cAppVisitMgmtViewTherapistButtonPresses += 1

                                let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppVisitMgmtView.Button(Xcode).'Therapist Gatherer by TID or tName'.#(\(self.cAppVisitMgmtViewTherapistButtonPresses))...")

                                self.isAppDataTherapist3ViewModal.toggle()

                            }
                            label:
                            {

                                VStack(alignment:.center)
                                {

                                    Label("", systemImage: "bed.double")
                                        .help(Text("Therapist Data Gatherer #3 by TID or tName Screen..."))
                                        .imageScale(.medium)

                                    Text("Therapist - Data Gatherer by TID or tName - #(\(self.cAppVisitMgmtViewTherapistButtonPresses))...")
                                        .font(.caption2)

                                }

                            }
                        #if os(macOS)
                            .sheet(isPresented:$isAppDataTherapist3ViewModal, content:
                                {

                                    AppVisitMgmtTherapist3View()

                                }
                            )
                        #endif
                        #if os(iOS)
                            .fullScreenCover(isPresented:$isAppDataTherapist3ViewModal)
                            {

                                AppVisitMgmtTherapist3View()

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

                        }

                    }
                    header:
                    {

                        Text("Therapist(s)")
                            .bold()
                            .italic()
                            .underline()
                            .font(.caption)

                    }

                    Section
                    {

                    //  HStack(alignment:.center)
                    //  {
                    //
                    //      Spacer()
                    //
                    //      Button
                    //      {
                    //
                    //          self.cAppVisitMgmtViewPatientButtonPresses += 1
                    //
                    //          let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppVisitMgmtView.Button(Xcode).'Patient Gatherer by PID'.#(\(self.cAppVisitMgmtViewPatientButtonPresses))...")
                    //
                    //          self.isAppDataPatient1ViewModal.toggle()
                    //
                    //      }
                    //      label:
                    //      {
                    //
                    //          VStack(alignment:.center)
                    //          {
                    //
                    //              Label("", systemImage: "person.text.rectangle")
                    //                  .help(Text("Patient Data Gatherer #1 by PID Screen..."))
                    //                  .imageScale(.medium)
                    //
                    //              Text("Patient - Data Gatherer by PID - #(\(self.cAppVisitMgmtViewPatientButtonPresses))...")
                    //                  .font(.caption2)
                    //
                    //          }
                    //
                    //      }
                    //  #if os(macOS)
                    //      .sheet(isPresented:$isAppDataPatient1ViewModal, content:
                    //          {
                    //
                    //              AppVisitMgmtPatient1View()
                    //
                    //          }
                    //      )
                    //  #endif
                    //  #if os(iOS)
                    //      .fullScreenCover(isPresented:$isAppDataPatient1ViewModal)
                    //      {
                    //
                    //          AppVisitMgmtPatient1View()
                    //
                    //      }
                    //  #endif
                    //  #if os(macOS)
                    //      .buttonStyle(.borderedProminent)
                    //      .padding()
                    //  //  .background(???.isPressed ? .blue : .gray)
                    //      .cornerRadius(10)
                    //      .foregroundColor(Color.primary)
                    //  #endif
                    //
                    //      Spacer()
                    //
                    //  }
                    //
                    //  HStack(alignment:.center)
                    //  {
                    //
                    //      Spacer()
                    //
                    //      Button
                    //      {
                    //
                    //          self.cAppVisitMgmtViewPatientButtonPresses += 1
                    //
                    //          let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppVisitMgmtView.Button(Xcode).'Patient Gatherer by Name'.#(\(self.cAppVisitMgmtViewPatientButtonPresses))...")
                    //
                    //          self.isAppDataPatient2ViewModal.toggle()
                    //
                    //      }
                    //      label:
                    //      {
                    //
                    //          VStack(alignment:.center)
                    //          {
                    //
                    //              Label("", systemImage: "person.text.rectangle")
                    //                  .help(Text("Patient Data Gatherer #2 by Name Screen..."))
                    //                  .imageScale(.medium)
                    //
                    //              Text("Patient - Data Gatherer by Name - #(\(self.cAppVisitMgmtViewPatientButtonPresses))...")
                    //                  .font(.caption2)
                    //
                    //          }
                    //
                    //      }
                    //  #if os(macOS)
                    //      .sheet(isPresented:$isAppDataPatient2ViewModal, content:
                    //          {
                    //
                    //              AppVisitMgmtPatient2View()
                    //
                    //          }
                    //      )
                    //  #endif
                    //  #if os(iOS)
                    //      .fullScreenCover(isPresented:$isAppDataPatient2ViewModal)
                    //      {
                    //
                    //          AppVisitMgmtPatient2View()
                    //
                    //      }
                    //  #endif
                    //  #if os(macOS)
                    //      .buttonStyle(.borderedProminent)
                    //      .padding()
                    //  //  .background(???.isPressed ? .blue : .gray)
                    //      .cornerRadius(10)
                    //      .foregroundColor(Color.primary)
                    //  #endif
                    //
                    //      Spacer()
                    //
                    //  }

                        HStack(alignment:.center)
                        {

                            Spacer()

                            Button
                            {

                                self.cAppVisitMgmtViewPatientButtonPresses += 1

                                let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppVisitMgmtView.Button(Xcode).'Patient Gatherer by PID or Name'.#(\(self.cAppVisitMgmtViewPatientButtonPresses))...")

                                self.isAppDataPatient3ViewModal.toggle()

                            }
                            label:
                            {

                                VStack(alignment:.center)
                                {

                                    Label("", systemImage: "person.text.rectangle")
                                        .help(Text("Patient Data Gatherer #3 by PID or Name Screen..."))
                                        .imageScale(.medium)

                                    Text("Patient - Data Gatherer by PID or Name - #(\(self.cAppVisitMgmtViewPatientButtonPresses))...")
                                        .font(.caption2)

                                }

                            }
                        #if os(macOS)
                            .sheet(isPresented:$isAppDataPatient3ViewModal, content:
                                {

                                    AppVisitMgmtPatient3View()

                                }
                            )
                        #endif
                        #if os(iOS)
                            .fullScreenCover(isPresented:$isAppDataPatient3ViewModal)
                            {

                                AppVisitMgmtPatient3View()

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

                        }

                    }
                    header:
                    {

                        Text("Patient(s)")
                            .bold()
                            .italic()
                            .underline()
                            .font(.caption)

                    }

                    Section
                    {

                        HStack(alignment:.center)
                        {

                            Spacer()

                            Text("<under-construction>")
                                .bold()
                                .italic()
                                .underline()
                                .font(.caption)
                            Text(" => DATA Gatherer #3...")
                                .font(.caption)

                            Spacer()

                        }

                    }
                    header:
                    {

                        Text("Schedule(s)")
                            .bold()
                            .italic()
                            .underline()
                            .font(.caption)

                    }

                    Section
                    {

                    //  HStack(alignment:.center)
                    //  {
                    //
                    //      Spacer()
                    //
                    //      Button
                    //      {
                    //
                    //          self.cAppVisitMgmtViewPatientButtonPresses += 1
                    //
                    //          let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppVisitMgmtView.Button(Xcode).'Patient Gatherer by PID'.#(\(self.cAppVisitMgmtViewPatientButtonPresses))...")
                    //
                    //          self.isAppDataPatient1ViewModal.toggle()
                    //
                    //      }
                    //      label:
                    //      {
                    //
                    //          VStack(alignment:.center)
                    //          {
                    //
                    //              Label("", systemImage: "person.text.rectangle")
                    //                  .help(Text("Patient Data Gatherer #1 by PID Screen..."))
                    //                  .imageScale(.medium)
                    //
                    //              Text("Patient - Data Gatherer by PID - #(\(self.cAppVisitMgmtViewPatientButtonPresses))...")
                    //                  .font(.caption2)
                    //
                    //          }
                    //
                    //      }
                    //  #if os(macOS)
                    //      .sheet(isPresented:$isAppDataPatient1ViewModal, content:
                    //          {
                    //
                    //              AppVisitMgmtPatient1View()
                    //
                    //          }
                    //      )
                    //  #endif
                    //  #if os(iOS)
                    //      .fullScreenCover(isPresented:$isAppDataPatient1ViewModal)
                    //      {
                    //
                    //          AppVisitMgmtPatient1View()
                    //
                    //      }
                    //  #endif
                    //  #if os(macOS)
                    //      .buttonStyle(.borderedProminent)
                    //      .padding()
                    //  //  .background(???.isPressed ? .blue : .gray)
                    //      .cornerRadius(10)
                    //      .foregroundColor(Color.primary)
                    //  #endif
                    //
                    //      Spacer()
                    //
                    //  }
                    //
                    //  HStack(alignment:.center)
                    //  {
                    //
                    //      Spacer()
                    //
                    //      Button
                    //      {
                    //
                    //          self.cAppVisitMgmtViewPatientButtonPresses += 1
                    //
                    //          let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppVisitMgmtView.Button(Xcode).'Patient Gatherer by Name'.#(\(self.cAppVisitMgmtViewPatientButtonPresses))...")
                    //
                    //          self.isAppDataPatient2ViewModal.toggle()
                    //
                    //      }
                    //      label:
                    //      {
                    //
                    //          VStack(alignment:.center)
                    //          {
                    //
                    //              Label("", systemImage: "person.text.rectangle")
                    //                  .help(Text("Patient Data Gatherer #2 by Name Screen..."))
                    //                  .imageScale(.medium)
                    //
                    //              Text("Patient - Data Gatherer by Name - #(\(self.cAppVisitMgmtViewPatientButtonPresses))...")
                    //                  .font(.caption2)
                    //
                    //          }
                    //
                    //      }
                    //  #if os(macOS)
                    //      .sheet(isPresented:$isAppDataPatient2ViewModal, content:
                    //          {
                    //
                    //              AppVisitMgmtPatient2View()
                    //
                    //          }
                    //      )
                    //  #endif
                    //  #if os(iOS)
                    //      .fullScreenCover(isPresented:$isAppDataPatient2ViewModal)
                    //      {
                    //
                    //          AppVisitMgmtPatient2View()
                    //
                    //      }
                    //  #endif
                    //  #if os(macOS)
                    //      .buttonStyle(.borderedProminent)
                    //      .padding()
                    //  //  .background(???.isPressed ? .blue : .gray)
                    //      .cornerRadius(10)
                    //      .foregroundColor(Color.primary)
                    //  #endif
                    //
                    //      Spacer()
                    //
                    //  }

                        HStack(alignment:.center)
                        {

                            Spacer()

                            Button
                            {

                                self.cAppVisitMgmtViewCoreLocButtonPresses += 1

                                let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppVisitMgmtView.Button(Xcode).'CoreLoc View'.#(\(self.cAppVisitMgmtViewCoreLocButtonPresses))...")

                                self.isAppDataCoreLocViewModal.toggle()

                            }
                            label:
                            {

                                VStack(alignment:.center)
                                {

                                    Label("", systemImage: "location.viewfinder")
                                        .help(Text("CoreLocation View..."))
                                        .imageScale(.medium)

                                    Text("CoreLoc - Core Location - #(\(self.cAppVisitMgmtViewPatientButtonPresses))...")
                                        .font(.caption2)

                                }

                            }
                        #if os(macOS)
                            .sheet(isPresented:$isAppDataCoreLocViewModal, content:
                                {

                                    AppVisitMgmtCoreLocView()

                                }
                            )
                        #endif
                        #if os(iOS)
                            .fullScreenCover(isPresented:$isAppDataCoreLocViewModal)
                            {

                                AppVisitMgmtCoreLocView()

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

                        }

                    }
                    header:
                    {

                        Text("CoreLoc")
                            .bold()
                            .italic()
                            .underline()
                            .font(.caption)

                    }

                }

            //  }

            }

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
    
}   // End of struct AppVisitMgmtView(View).

#Preview 
{
    
    AppVisitMgmtView()
    
}

