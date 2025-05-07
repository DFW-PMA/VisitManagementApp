//
//  AppVisitMgmtTherapist3View.swift
//  VisitManagementApp
//
//  Created by Daryl Cox on 02/12/2025.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct AppVisitMgmtTherapist3View: View 
{
    
    struct ClassInfo
    {
        
        static let sClsId        = "AppVisitMgmtTherapist3View"
        static let sClsVers      = "v1.0603"
        static let sClsDisp      = sClsId+"(.swift).("+sClsVers+"):"
        static let sClsCopyRight = "Copyright (C) JustMacApps 2023-2025. All Rights Reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }
    
    // 'Internal' Trace flag:

    private 
    var bInternalTraceFlag:Bool                                                        = false

    // App Data field(s):

//  @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode)     var presentationMode
    @Environment(\.openURL)              var openURL
    @Environment(\.openWindow)           var openWindow

    enum FocusedFields
    {
       case therapistTID
       case therapistName
    }
    
    @FocusState  private var focusedField:FocusedFields?

    @State       private var sTherapistTID:String                                      = ""
    @State       private var sTherapistName:String                                     = ""

    @State       private var listSelectableTherapistNames:[AppSearchableTherapistName] = [AppSearchableTherapistName]()

    @State       private var cAppLogPFDataButtonPresses:Int                            = 0
    @State       private var cAppTidScheduleViewButtonPresses:Int                      = 0
    @State       private var cAppVisitMgmtTherapist3ViewRefreshButtonPresses:Int    = 0

    @State       private var isAppLogPFDataViewModal:Bool                              = false
    @State       private var isAppTidScheduleViewModal:Bool                            = false
//  @State       private var isAppTidScheduleViewEnabled:Bool                          = false
    @State       private var isAppRunTherapistLocateByTidShowing:Bool                  = false
    @State       private var isAppTherapistDetailsByTidShowing:Bool                    = false
    @State       private var isAppRunTherapistLocateByTNameShowing:Bool                = false
    @State       private var isAppTherapistDetailsByTNameShowing:Bool                  = false

                         var jmAppDelegateVisitor:JmAppDelegateVisitor                 = JmAppDelegateVisitor.ClassSingleton.appDelegateVisitor
    @ObservedObject      var jmAppParseCoreManager:JmAppParseCoreManager               = JmAppParseCoreManager.ClassSingleton.appParseCodeManager
                         var jmAppParseCoreBkgdDataRepo:JmAppParseCoreBkgdDataRepo     = JmAppParseCoreBkgdDataRepo.ClassSingleton.appParseCodeBkgdDataRepo
                         var appScheduleLoadingAssistant:AppScheduleLoadingAssistant   = AppScheduleLoadingAssistant.ClassSingleton.appScheduleLoadingAssistant
    
    init()
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        }

        // Exit...

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        }

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
        
    //  let listScheduledPatientLocationItems:[ScheduledPatientLocationItem]
    //      = self.getScheduledPatientLocationItemsForTid(sPFTherapistParseTID:sTherapistTID)

    //  NavigationStack
        ScrollView
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

                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):AppVisitMgmtTherapist3View.Button(Xcode).'Log/Reload Data'.#(\(self.cAppLogPFDataButtonPresses)) pressed...")

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

                        self.cAppTidScheduleViewButtonPresses += 1

                        let _ = xcgLogMsg("\(ClassInfo.sClsDisp):AppVisitMgmtTherapist3View.Button(Xcode).'App TID Schedule View'.#(\(self.cAppTidScheduleViewButtonPresses))...")

                        self.isAppTidScheduleViewModal.toggle()

                    }
                    label:
                    {

                        VStack(alignment:.center)
                        {

                            Label("", systemImage: "doc.text.magnifyingglass")
                                .help(Text("App TID/Patient Schedule Viewer"))
                                .imageScale(.large)

                            Text("Schedule Today")
                                .font(.caption)

                        }

                    }
                #if os(macOS)
                    .sheet(isPresented:$isAppTidScheduleViewModal, content:
                        {

                            AppTidScheduleView(listScheduledPatientLocationItems:self.appScheduleLoadingAssistant.getScheduledPatientLocationItemsForTid(sPFTherapistTID:sTherapistTID)
)

                        }
                    )
                #elseif os(iOS)
                    .fullScreenCover(isPresented:$isAppTidScheduleViewModal)
                    {

                        AppTidScheduleView(listScheduledPatientLocationItems:self.appScheduleLoadingAssistant.getScheduledPatientLocationItemsForTid(sPFTherapistTID:sTherapistTID)
)

                    }
                #endif
                #if os(macOS)
                    .buttonStyle(.borderedProminent)
                    .padding()
                //  .background(???.isPressed ? .blue : .gray)
                    .cornerRadius(10)
                    .foregroundColor(Color.primary)
                #endif
                    .padding()
                //  .onAppear
                //  {
                //      if (self.sTherapistTID.count                > 0 &&
                //          listScheduledPatientLocationItems.count > 0)
                //      {
                //          self.isAppTidScheduleViewEnabled = true
                //      }
                //      else
                //      {
                //          self.isAppTidScheduleViewEnabled = false
                //      }
                //  }
                //  .disabled(!self.appScheduleLoadingAssistant.bScheduledPatientLocationItemsAreAvaiable)

                    Spacer()

                    Button
                    {

                        self.cAppVisitMgmtTherapist3ViewRefreshButtonPresses += 1

                        let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppVisitMgmtTherapist3View.Button(Xcode).'Refresh'.#(\(self.cAppVisitMgmtTherapist3ViewRefreshButtonPresses))...")

                    }
                    label:
                    {

                        VStack(alignment:.center)
                        {

                            Label("", systemImage: "arrow.clockwise")
                                .help(Text("'Refresh' App Data Gatherer Therapist Screen..."))
                                .imageScale(.large)

                            Text("Refresh - #(\(self.cAppVisitMgmtTherapist3ViewRefreshButtonPresses))...")
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

                        let _ = xcgLogMsg("\(ClassInfo.sClsDisp):AppVisitMgmtTherapist3View.Button(Xcode).'Dismiss' pressed...")

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

                VStack(alignment:.center)
                {

                    Divider()

                //  Text(" - - - - - - - - - - - - - - - - - - - - ")
                //      .font(.caption2) 
                //      .frame(maxWidth:.infinity, alignment:.center)
                //
                //  HStack
                //  {
                //
                //      Button
                //      {
                //
                //          let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtTherapist3View.Button(Xcode).'Locate the Therapist by TID'...")
                //
                //          self.sTherapistName = self.locateAppTherapistNamebyTid(sTherapistTID:sTherapistTID)
                //
                //          self.isAppRunTherapistLocateByTidShowing.toggle()
                //
                //      }
                //      label:
                //      {
                //
                //          HStack(alignment:.center)
                //          {
                //
                //              Spacer()
                //
                //              Label("", systemImage: "figure.run.circle")
                //                  .help(Text("Locate the Therapist by TID..."))
                //                  .imageScale(.small)
                //
                //              Text("==> Locate Therapist by TID")
                //                  .bold()
                //                  .font(.caption2)
                //                  .foregroundColor(.red)
                //
                //              Spacer()
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
                //  //  .padding()
                //
                //  }
                //
                //  HStack
                //  {
                //
                //      Button
                //      {
                //
                //          let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtTherapist3View.Button(Xcode).'Locate the Therapist by tName'...")
                //
                //          self.sTherapistTID = self.locateAppTherapistTIDByTName(sTherapistName:self.sTherapistName)
                //
                //          self.isAppRunTherapistLocateByTNameShowing.toggle()
                //
                //      }
                //      label:
                //      {
                //
                //          HStack(alignment:.center)
                //          {
                //
                //              Spacer()
                //
                //              Label("", systemImage: "figure.run.circle")
                //                  .help(Text("Locate the Therapist by tName..."))
                //                  .imageScale(.small)
                //
                //              Text("=> Locate Therapist by tName")
                //                  .bold()
                //                  .font(.caption2)
                //                  .foregroundColor(.red)
                //
                //              Spacer()
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
                //  //  .padding()
                //
                //  }
                //
                //  Text(" - - - - - - - - - - - - - - - - - - - - ")
                //      .font(.caption2) 
                //      .frame(maxWidth:.infinity, alignment:.center)

                }

                HStack()
                {

                //  Text("===> Therapists' TID: ")
                //      .font(.caption) 
                //
                //  Text("\(sTherapistTID)")
                //      .font(.caption) 
                //      .onChange(of:self.sTherapistName)
                //      {
                //          let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onChange #1 - 'self.sTherapistName' is [\(self.sTherapistName)] - clearing the 'sTherapistTID' field...")
                //
                //          self.sTherapistTID = ""
                //      }

                    Text("=> Enter the Therapists' TID: ")
                        .font(.caption) 
                        .foregroundColor(.red)

                    TextField("Therapist TID...", text:$sTherapistTID)
                        .font(.caption) 
                    #if os(iOS)
                        .keyboardType(.numberPad)
                    #endif
                        .onAppear
                        {
                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onAppear #1 - 'self.sTherapistTID' is [\(self.sTherapistTID)]...")

                            if (self.sTherapistTID.count < 1)
                            {
                                self.sTherapistName = ""
                            //  self.appScheduleLoadingAssistant.clearScheduledPatientLocationItems()
                            }

                        //  self.sTherapistName = ""
                            focusedField        = .therapistTID
                        }
                        .onChange(of:self.sTherapistName)
                        {
                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onChange #1 - 'self.sTherapistName' is [\(self.sTherapistName)] - clearing the 'sTherapistTID' field...")
                    
                        //  self.sTherapistTID  = self.locateAppTherapistTIDByTName(sTherapistName:self.sTherapistName)
                        //  self.sTherapistTID  = ""
                        //  listScheduledPatientLocationItems:[ScheduledPatientLocationItem]
                        //      = self.getScheduledPatientLocationItemsForTid(sPFTherapistParseTID:sTherapistTID)
                        //  let _ = self.appScheduleLoadingAssistant.getScheduledPatientLocationItemsForTid(sPFTherapistTID:sTherapistTID)
                        }
                        .onSubmit
                        {
                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onSubmit #1 - 'self.sTherapistTID' is [\(self.sTherapistTID)] - locating the 'sTherapistName' field...")
                    
                            self.sTherapistName = self.locateAppTherapistNamebyTid(sTherapistTID:sTherapistTID)
                            focusedField        = .therapistTID
                        //  listScheduledPatientLocationItems:[ScheduledPatientLocationItem] 
                        //      = self.getScheduledPatientLocationItemsForTid(sPFTherapistParseTID:sTherapistTID)
                        //  let _ = self.appScheduleLoadingAssistant.getScheduledPatientLocationItemsForTid(sPFTherapistTID:sTherapistTID)
                        }
                        .onReceive(Just(sTherapistTID))
                        { newValue in
                            let filteredValue = newValue.filter { "-0123456789".contains($0) }
                            if (filteredValue != newValue)
                            {
                                self.sTherapistTID = filteredValue
                            }
                        }
                        .focused($focusedField, equals:.therapistTID)

                    Spacer()

                    if (self.sTherapistTID.count    > 0 &&
                        (self.sTherapistName.count  > 0 &&
                         self.sTherapistName       != "-N/A-"))
                    {

                        Button
                        {

                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtTherapist3View.Button(Xcode).'Therapist Detail(s) by TID'...")

                            self.isAppTherapistDetailsByTNameShowing.toggle()

                        }
                        label:
                        {

                            VStack(alignment:.center)
                            {

                                Label("", systemImage: "doc.questionmark")
                                    .help(Text("Show Therapist Detail(s) by TID..."))
                                    .imageScale(.medium)

                                HStack(alignment:.center)
                                {

                                    Spacer()

                                    Text("Details...")
                                        .font(.caption2)

                                    Spacer()

                                }

                            }

                        }
                    #if os(macOS)
                        .sheet(isPresented:$isAppTherapistDetailsByTNameShowing, content:
                        {

                            AppVisitMgmtTherapist1DetailsView(sTherapistTID:$sTherapistTID)

                        })
                    #endif
                    #if os(iOS)
                        .fullScreenCover(isPresented:$isAppTherapistDetailsByTNameShowing)
                        {

                            AppVisitMgmtTherapist1DetailsView(sTherapistTID:$sTherapistTID)

                        }
                    #endif
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
                    
                    }

            //      Button
            //      {
            //
            //          let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtTherapist3View.Button(Xcode).'Locate the Therapist by TID'...")
            //
            //          self.sTherapistName = self.locateAppTherapistNamebyTid(sTherapistTID:sTherapistTID)
            //
            //          self.isAppRunTherapistLocateByTidShowing.toggle()
            //
            //      }
            //      label:
            //      {
            //
            //          VStack(alignment:.center)
            //          {
            //
            //              Label("", systemImage: "figure.run.circle")
            //                  .help(Text("Locate the Therapist by TID..."))
            //                  .imageScale(.small)
            //
            //              Text("Locate TID")
            //                  .bold()
            //                  .font(.caption2)
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

                    Button
                    {

                        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtTherapist3View.Button(Xcode).'Therapist TID delete'...")

                        self.sTherapistName = ""
                        self.sTherapistTID  = ""
                        focusedField        = .therapistTID

                        self.appScheduleLoadingAssistant.clearScheduledPatientLocationItems()

                    }
                    label:
                    {

                        VStack(alignment:.center)
                        {

                            Label("", systemImage: "delete.left")
                                .help(Text("Delete the Therapist TID..."))
                                .imageScale(.medium)

                            HStack(alignment:.center)
                            {

                                Spacer()

                                Text("Delete TID")
                                    .font(.caption2)

                                Spacer()

                            }

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

                }

                HStack()
                {

                    Text("=> Enter the Therapists' Name: ")
                        .font(.caption) 
                        .foregroundColor(.red)

                    TextField("Therapist tName...", text:$sTherapistName)
                        .italic()
                        .font(.caption) 
                        .disableAutocorrection(true)
                        .focused($focusedField, equals:.therapistName)
                        .onAppear
                        {
                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onAppear #2 - 'self.sTherapistTID' is [\(self.sTherapistTID)] - 'self.sTherapistName' is [\(self.sTherapistName)]...")

                        //  self.sTherapistName = ""
                        //  self.sTherapistTID  = ""
                            focusedField        = .therapistName
                        }
                        .onChange(of: self.sTherapistName)
                        {
                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onChange #2 - 'self.sTherapistTID' is [\(self.sTherapistTID)] - 'self.sTherapistName' is [\(self.sTherapistName)]...")

                            self.updateSelectableTherapistNamesList(sSearchValue:self.sTherapistName)
                            focusedField        = .therapistName

                            if (self.sTherapistName.count < 1)
                            {
                                self.sTherapistTID = ""
                            }
                        }
                        .onSubmit
                        {
                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onSubmit #2 - 'self.sTherapistName' is [\(self.sTherapistName)] - locating the 'sTherapistTID' field...")

                            self.sTherapistTID  = self.locateAppTherapistTIDByTName(sTherapistName:self.sTherapistName)
                            focusedField        = .therapistName
                        //  listScheduledPatientLocationItems:[ScheduledPatientLocationItem]
                        //      = self.getScheduledPatientLocationItemsForTid(sPFTherapistParseTID:sTherapistTID)
                        //  let _ = self.appScheduleLoadingAssistant.getScheduledPatientLocationItemsForTid(sPFTherapistTID:sTherapistTID)
                        }

                    Spacer()

                //  if (self.sTherapistTID.count    > 0 &&
                //      (self.sTherapistName.count  > 0 &&
                //       self.sTherapistName       != "-N/A-"))
                //  {
                //
                //      Button
                //      {
                //
                //          let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtTherapist3View.Button(Xcode).'Therapist Detail(s) by tName'...")
                //
                //          self.isAppTherapistDetailsByTNameShowing.toggle()
                //
                //      }
                //      label:
                //      {
                //
                //          VStack(alignment:.center)
                //          {
                //
                //              Label("", systemImage: "doc.questionmark")
                //                  .help(Text("Show Therapist Detail(s) by tName..."))
                //                  .imageScale(.medium)
                //
                //              HStack(alignment:.center)
                //              {
                //
                //                  Spacer()
                //
                //                  Text("Therapist Details...")
                //                      .font(.caption2)
                //
                //                  Spacer()
                //
                //              }
                //
                //          }
                //
                //      }
                //  #if os(macOS)
                //      .sheet(isPresented:$isAppTherapistDetailsByTNameShowing, content:
                //      {
                //
                //          AppVisitMgmtTherapist1DetailsView(sTherapistTID:$sTherapistTID)
                //
                //      })
                //  #endif
                //  #if os(iOS)
                //      .fullScreenCover(isPresented:$isAppTherapistDetailsByTNameShowing)
                //      {
                //
                //          AppVisitMgmtTherapist1DetailsView(sTherapistTID:$sTherapistTID)
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
                //      .padding()
                //  
                //  }

                    Button
                    {

                        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtTherapist3View.Button(Xcode).'Locate the Therapist by TID or tName'...")

                        if (self.sTherapistTID.count > 0)
                        {
                            self.sTherapistName = self.locateAppTherapistNamebyTid(sTherapistTID:sTherapistTID)
                        //  listScheduledPatientLocationItems:[ScheduledPatientLocationItem]
                        //      = self.getScheduledPatientLocationItemsForTid(sPFTherapistParseTID:sTherapistTID)
                        //  let _ = self.appScheduleLoadingAssistant.getScheduledPatientLocationItemsForTid(sPFTherapistTID:sTherapistTID)
                        }
                        else
                        {
                            if (self.sTherapistName.count > 0)
                            {
                                self.sTherapistTID = self.locateAppTherapistTIDByTName(sTherapistName:self.sTherapistName)
                            //  listScheduledPatientLocationItems:[ScheduledPatientLocationItem]
                            //      = self.getScheduledPatientLocationItemsForTid(sPFTherapistParseTID:sTherapistTID)
                            //  let _ = self.appScheduleLoadingAssistant.getScheduledPatientLocationItemsForTid(sPFTherapistTID:sTherapistTID)
                            }
                        }

                        self.isAppRunTherapistLocateByTNameShowing.toggle()

                    }
                    label:
                    {

                        VStack(alignment:.center)
                        {

                            Label("", systemImage: "figure.run.circle")
                                .help(Text("Locate the Therapist by TID or tName..."))
                                .imageScale(.small)

                            Text("Locate")
                                .bold()
                                .font(.caption2)

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
                    
                    Button
                    {

                        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtTherapist3View.Button(Xcode).'Therapist tName delete'...")

                        self.sTherapistName = ""
                        self.sTherapistTID  = ""
                        focusedField        = .therapistName

                        self.appScheduleLoadingAssistant.clearScheduledPatientLocationItems()

                    }
                    label:
                    {

                        VStack(alignment:.center)
                        {

                            Label("", systemImage: "delete.left")
                                .help(Text("Delete the Therapist tName..."))
                                .imageScale(.medium)

                            HStack(alignment:.center)
                            {

                                Spacer()

                                Text("Delete Name")
                                    .font(.caption2)

                                Spacer()

                            }

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

                }

                Text("")
                    .font(.caption2)
                    .onAppear
                    {

                        listSelectableTherapistNames = [AppSearchableTherapistName]()

                        listSelectableTherapistNames.append(AppSearchableTherapistName(sTherapistTName:"...placeholder...", sTherapistTID:"-1"))

                    }

                List(listSelectableTherapistNames, id:\.id)
                { appSearchableTherapistName in

                //  Text(appSearchableTherapistName.sTherapistTName)
                    Text("\(appSearchableTherapistName.sTherapistTName) - \(appSearchableTherapistName.sTherapistTID)")
                        .onTapGesture
                        {
                            self.sTherapistName = appSearchableTherapistName.sTherapistTName
                            self.sTherapistTID  = self.locateAppTherapistTIDByTName(sTherapistName:self.sTherapistName)
                            focusedField        = .therapistName
                        //  listScheduledPatientLocationItems:[ScheduledPatientLocationItem]
                        //      = self.getScheduledPatientLocationItemsForTid(sPFTherapistParseTID:sTherapistTID)
                        //  let _ = self.appScheduleLoadingAssistant.getScheduledPatientLocationItemsForTid(sPFTherapistTID:sTherapistTID)
                        }

                }
                .scaledToFill()
                .font(.caption) 
            //  .frame(maxHeight:250)

            }

            Spacer()

        }
        .padding()
        
    }

//  private func getScheduledPatientLocationItemsForTid(sPFTherapistParseTID:String = "")->[ScheduledPatientLocationItem]
//  {
//
//      let sCurrMethod:String = #function
//      let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
//      
//      self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'sPFTherapistParseTID' is [\(sPFTherapistParseTID)]...")
//
//      // Use the TherapistName in the PFCscDataItem to lookup any ScheduledPatientLocationItem(s)...
//
//      var listScheduledPatientLocationItems:[ScheduledPatientLocationItem] = []
//      let jmAppParseCoreManager:JmAppParseCoreManager                      = JmAppParseCoreManager.ClassSingleton.appParseCodeManager
//
//      if (sPFTherapistParseTID.count > 0)
//      {
//
//          if (jmAppParseCoreManager.dictSchedPatientLocItems.count > 0)
//          {
//
//              listScheduledPatientLocationItems = jmAppParseCoreManager.dictSchedPatientLocItems[sPFTherapistParseTID] ?? []
//
//          }
//
//      }
//      
//      // Exit...
//
//      self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'listScheduledPatientLocationItems' is [\(listScheduledPatientLocationItems)]...")
//
//      return listScheduledPatientLocationItems
//
//  }   // End of private func getScheduledPatientLocationItemsForTid(sPFTherapistParseTID:String = "")->[ScheduledPatientLocationItem].

    private func locateAppTherapistNamebyTid(sTherapistTID:String = "")->String
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'sTherapistTID' is [\(sTherapistTID)]...")

        }

        // Locate the Therapist 'name' by TID...

        var sTherapistName:String = self.jmAppParseCoreBkgdDataRepo.convertTidToTherapistName(sPFTherapistParseTID:sTherapistTID)

        if (sTherapistName.count < 1)
        {
        
            sTherapistName = "-N/A-"
        
        }

        // Exit...

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'sTherapistName' is [\(sTherapistName)] - 'sTherapistTID' is [\(sTherapistTID)]...")

        }
  
        return sTherapistName
  
    }   // End of private func locateAppTherapistNamebyTid(sTherapistTID:String)->String.

    private func locateAppTherapistTIDByTName(sTherapistName:String = "")->String
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'sTherapistName' is [\(sTherapistName)]...")

        }

        // Locate the Therapist TID by 'name'...

        var sTherapistTID:String = self.jmAppParseCoreManager.convertTherapistNameToTid(sPFTherapistParseName:sTherapistName)

        if (sTherapistTID.count < 1)
        {
        
            sTherapistTID = ""
        //  sTherapistTID = "-1"
        
        }

        // Exit...

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'sTherapistName' is [\(sTherapistName)] - 'sTherapistTID' is [\(sTherapistTID)]...")

        }
  
        return sTherapistTID
  
    }   // End of private func locateAppTherapistTIDByTName(sTherapistName:String)->String.

    private func updateSelectableTherapistNamesList(sSearchValue:String = "")
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'sSearchValue' is [\(sSearchValue)]...")

        }

        // Update the 'selectable' Therapist 'name(s)' list from the 'sSearchValue' criteria...

        if (sSearchValue.isEmpty)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) Intermediate #1 - parameter 'sSearchValue' is an empty 'string' - unable to update the 'selectable' item(s) - Warning!")
            
            // Exit:

            if (self.bInternalTraceFlag == true)
            {

                self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            }

            return
        
        }

        // var dictPFTherapistFileItems:[Int:ParsePFTherapistFileItem] = [Int:ParsePFTherapistFileItem]()

        if (self.jmAppParseCoreManager.dictPFTherapistFileItems.count < 1)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) Intermediate #2 - 'self.jmAppParseCoreManager.dictPFTherapistFileItems' is an empty 'dictionary' - unable to update the 'selectable' item(s) - Warning!")
            
            // Exit:

            if (self.bInternalTraceFlag == true)
            {

                self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            }

            return
        
        }

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Intermediate #3 - 'sSearchValue' is [\(sSearchValue)] - 'self.jmAppParseCoreManager.dictPFTherapistFileItems' contains (\(self.jmAppParseCoreManager.dictPFTherapistFileItems.count)) item(s)...")

        }

        self.listSelectableTherapistNames = [AppSearchableTherapistName]()

        var cTherapistNames:Int           = 0
        var cSelectableTherapistNames:Int = 0
        let sSearchValueLow:String        = sSearchValue.lowercased()
        
        // var dictPFTherapistFileItems:[Int:ParsePFTherapistFileItem] = [Int:ParsePFTherapistFileItem]()

        for (iPFTherapistParseTID, pfTherapistFileItem) in self.jmAppParseCoreManager.dictPFTherapistFileItems
        {

            cTherapistNames += 1

            if (iPFTherapistParseTID < 0)
            {

                self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cTherapistNames)) 'iPFTherapistParseTID' - the 'tid' field is less than 0 - Warning!")

                continue

            }

            let sTherapistTID:String       = ("\(pfTherapistFileItem.iPFTherapistFileTID)")
            let sTherapistTName:String     = pfTherapistFileItem.sPFTherapistFileName
            let sTherapistTNameLow:String  = sTherapistTName.lowercased()
            let sTherapistTNameNoWS:String = pfTherapistFileItem.sPFTherapistFileNameNoWS

            if (sTherapistTNameLow.contains(sSearchValueLow)  == true ||
                sTherapistTNameNoWS.contains(sSearchValueLow) == true)
            {
            
                self.listSelectableTherapistNames.append(AppSearchableTherapistName(sTherapistTName:sTherapistTName, sTherapistTID:sTherapistTID))

                cSelectableTherapistNames += 1

                if (self.bInternalTraceFlag == true)
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) #(\(cTherapistNames)): 'sTherapistTName' of [\(sTherapistTName)] - 'sTherapistTID' is [\(sTherapistTID)] contains the 'sSearchValue' of [\(sSearchValue)] - adding to the 'selectable' list...")

                }

            }

        }

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Intermediate #3 - added (\(cSelectableTherapistNames)) names(s) to the 'selectable' list of (\(self.listSelectableTherapistNames.count)) item(s)...")

        }

        // Exit:

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        }

        return

    }   // End of private func updateSelectableTherapistNamesList(sSearchValue:String).

}   // End of struct AppVisitMgmtTherapist3View(View).

#Preview 
{
    
    AppVisitMgmtTherapist3View()
    
}

