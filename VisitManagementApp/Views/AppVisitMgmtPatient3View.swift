//
//  AppVisitMgmtPatient3View.swift
//  VisitManagementApp
//
//  Created by Daryl Cox on 02/12/2025.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct AppVisitMgmtPatient3View: View 
{
    
    struct ClassInfo
    {
        
        static let sClsId        = "AppVisitMgmtPatient3View"
        static let sClsVers      = "v1.0401"
        static let sClsDisp      = sClsId+"(.swift).("+sClsVers+"):"
        static let sClsCopyRight = "Copyright (C) JustMacApps 2023-2025. All Rights Reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }
    
    // 'Internal' Trace flag:

    private 
    var bInternalTraceFlag:Bool                                                    = false

    // App Data field(s):

//  @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode)     var presentationMode
    @Environment(\.openURL)              var openURL
    @Environment(\.openWindow)           var openWindow

    enum FocusedFields
    {
       case patientPID
       case patientName
    }
    
    @FocusState  private var focusedField:FocusedFields?

    @State       private var sPatientPID:String                                    = ""
    @State       private var sPatientName:String                                   = ""

    @State       private var listSelectablePatientNames:[AppSearchablePatientName] = [AppSearchablePatientName]()

    @State       private var cAppLogPFDataButtonPresses:Int                        = 0
    @State       private var cAppVisitMgmtPatient3ViewRefreshButtonPresses:Int  = 0

    @State       private var isAppLogPFDataViewModal:Bool                          = false
    @State       private var isAppRunPatientLocateByPidShowing:Bool                = false
    @State       private var isAppPatientDetailsByPidShowing:Bool                  = false
    @State       private var isAppRunPatientLocateByNameShowing:Bool               = false
    @State       private var isAppPatientDetailsByNameShowing:Bool                 = false

                         var jmAppDelegateVisitor:JmAppDelegateVisitor             = JmAppDelegateVisitor.ClassSingleton.appDelegateVisitor
    @ObservedObject      var jmAppParseCoreManager:JmAppParseCoreManager           = JmAppParseCoreManager.ClassSingleton.appParseCodeManager
                         var jmAppParseCoreBkgdDataRepo:JmAppParseCoreBkgdDataRepo = JmAppParseCoreBkgdDataRepo.ClassSingleton.appParseCodeBkgdDataRepo
    
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

                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):AppVisitMgmtPatient3View.Button(Xcode).'Log/Reload Data'.#(\(self.cAppLogPFDataButtonPresses)) pressed...")

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

                        self.cAppVisitMgmtPatient3ViewRefreshButtonPresses += 1

                        let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppVisitMgmtPatient3View.Button(Xcode).'Refresh'.#(\(self.cAppVisitMgmtPatient3ViewRefreshButtonPresses))...")

                    }
                    label:
                    {

                        VStack(alignment:.center)
                        {

                            Label("", systemImage: "arrow.clockwise")
                                .help(Text("'Refresh' App VMA Patient Screen..."))
                                .imageScale(.large)

                            Text("Refresh - #(\(self.cAppVisitMgmtPatient3ViewRefreshButtonPresses))...")
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

                        let _ = xcgLogMsg("\(ClassInfo.sClsDisp):AppVisitMgmtPatient3View.Button(Xcode).'Dismiss' pressed...")

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
                //          let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtPatient1View.Button(Xcode).'Locate the Patient by PID'...")
                //
                //          self.sPatientName = self.locateAppPatientNamebyPid(sPatientPID:sPatientPID)
                //
                //          self.isAppRunPatientLocateByPidShowing.toggle()
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
                //                  .help(Text("Locate the Patient by PID..."))
                //                  .imageScale(.small)
                //
                //              Text("==> Locate Patient by PID")
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
                //          let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtPatient3View.Button(Xcode).'Locate the Patient by Name'...")
                //
                //          self.sPatientPID = self.locateAppPatientPIDByName(sPatientName:self.sPatientName)
                //
                //          self.isAppRunPatientLocateByNameShowing.toggle()
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
                //                  .help(Text("Locate the Patient by Name..."))
                //                  .imageScale(.small)
                //
                //              Text("=> Locate Patient by Name")
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

                //  Text("===> Patients' PID: ")
                //      .font(.caption) 
                //
                //  Text("\(sPatientPID)")
                //      .font(.caption) 
                //      .onChange(of:self.sPatientName)
                //      {
                //          let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onChange #1 - 'self.sPatientName' is [\(self.sPatientName)] - clearing the 'sPatientPID' field...")
                //
                //          self.sPatientPID = ""
                //      }

                    Text("=> Enter the Patients' PID: ")
                        .font(.caption) 
                        .foregroundColor(.red)

                    TextField("Patient PID...", text:$sPatientPID)
                        .focused($focusedField, equals:.patientPID)
                        .font(.caption) 
                    #if os(iOS)
                        .keyboardType(.numberPad)
                    #endif
                        .onAppear
                        {
                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onAppear #1 - 'self.sPatientPID' is [\(self.sPatientPID)]...")

                            if (self.sPatientPID.count < 1)
                            {
                                self.sPatientName = ""
                            }

                        //  self.sPatientName = ""
                            focusedField        = .patientPID
                        }
                        .onChange(of:self.sPatientName)
                        {
                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onChange #1 - 'self.sPatientName' is [\(self.sPatientName)] - clearing the 'sPatientPID' field...")
                    
                            self.sPatientPID  = self.locateAppPatientPIDByName(sPatientName:self.sPatientName)
                        //  self.sPatientPID  = ""
                        }
                        .onSubmit
                        {
                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onSubmit #1 - 'self.sPatientPID' is [\(self.sPatientPID)] - locating the 'sPatientName' field...")
                    
                            self.sPatientName = self.locateAppPatientNamebyPid(sPatientPID:sPatientPID)
                            focusedField      = .patientPID
                        }
                        .onReceive(Just(sPatientPID))
                        { newValue in
                            let filteredValue = newValue.filter { "-0123456789".contains($0) }
                            if (filteredValue != newValue)
                            {
                                self.sPatientPID = filteredValue
                            }
                        }

                    Spacer()

                    if (self.sPatientPID.count    > 0 &&
                        (self.sPatientName.count  > 0 &&
                         self.sPatientName       != "-N/A-"))
                    {

                        Button
                        {

                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtPatient3View.Button(Xcode).'Patient Detail(s) by PID'...")

                            self.isAppPatientDetailsByNameShowing.toggle()

                        }
                        label:
                        {

                            VStack(alignment:.center)
                            {

                                Label("", systemImage: "doc.questionmark")
                                    .help(Text("Show Patient Detail(s) by PID..."))
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
                        .sheet(isPresented:$isAppPatientDetailsByNameShowing, content:
                        {

                            AppVisitMgmtPatient1DetailsView(sPatientPID:$sPatientPID)

                        })
                    #endif
                    #if os(iOS)
                        .fullScreenCover(isPresented:$isAppPatientDetailsByNameShowing)
                        {

                            AppVisitMgmtPatient1DetailsView(sPatientPID:$sPatientPID)

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
            //          let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtPatient1View.Button(Xcode).'Locate the Patient by PID'...")
            //
            //          self.sPatientName = self.locateAppPatientNamebyPid(sPatientPID:sPatientPID)
            //
            //          self.isAppRunPatientLocateByPidShowing.toggle()
            //
            //      }
            //      label:
            //      {
            //
            //          VStack(alignment:.center)
            //          {
            //
            //              Label("", systemImage: "figure.run.circle")
            //                  .help(Text("Locate the Patient by PID..."))
            //                  .imageScale(.small)
            //
            //              Text("Locate PID")
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

                        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtPatient1View.Button(Xcode).'Patient PID delete'...")

                        focusedField      = .patientPID
                        self.sPatientName = ""
                        self.sPatientPID  = ""

                    }
                    label:
                    {

                        VStack(alignment:.center)
                        {

                            Label("", systemImage: "delete.left")
                                .help(Text("Delete the Patient PID..."))
                                .imageScale(.medium)

                            HStack(alignment:.center)
                            {

                                Spacer()

                                Text("Delete PID")
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

                    Text("=> Enter the Patients' Name: ")
                        .font(.caption) 
                        .foregroundColor(.red)

                    TextField("Patient Name...", text:$sPatientName)
                        .italic()
                        .font(.caption) 
                        .disableAutocorrection(true)
                        .focused($focusedField, equals:.patientName)
                        .onAppear
                        {
                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onAppear #2 - 'self.sPatientPID' is [\(self.sPatientPID)] - 'self.sPatientName' is [\(self.sPatientName)]...")

                        //  self.sPatientName = ""
                        //  self.sPatientPID  = ""
                            focusedField        = .patientName
                        }
                        .onChange(of: self.sPatientName)
                        {
                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onChange #2 - 'self.sPatientPID' is [\(self.sPatientPID)] - 'self.sPatientName' is [\(self.sPatientName)]...")

                            self.updateSelectablePatientNamesList(sSearchValue:self.sPatientName)
                            focusedField        = .patientName

                            if (self.sPatientName.count < 1)
                            {
                                self.sPatientPID = ""
                            }
                        }
                        .onSubmit
                        {
                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onSubmit #2 - 'self.sPatientName' is [\(self.sPatientName)] - locating the 'sPatientPID' field...")

                            self.sPatientPID  = self.locateAppPatientPIDByName(sPatientName:self.sPatientName)
                            focusedField        = .patientName
                        }

                    Spacer()

                //  if (self.sPatientPID.count    > 0 &&
                //      (self.sPatientName.count  > 0 &&
                //       self.sPatientName       != "-N/A-"))
                //  {
                //
                //      Button
                //      {
                //
                //          let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtPatient3View.Button(Xcode).'Patient Detail(s) by Name'...")
                //
                //          self.isAppPatientDetailsByNameShowing.toggle()
                //
                //      }
                //      label:
                //      {
                //
                //          VStack(alignment:.center)
                //          {
                //
                //              Label("", systemImage: "doc.questionmark")
                //                  .help(Text("Show Patient Detail(s) by Name..."))
                //                  .imageScale(.medium)
                //
                //              HStack(alignment:.center)
                //              {
                //
                //                  Spacer()
                //
                //                  Text("Patient Details...")
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
                //      .sheet(isPresented:$isAppPatientDetailsByNameShowing, content:
                //      {
                //
                //          AppVisitMgmtPatient1DetailsView(sPatientPID:$sPatientPID)
                //
                //      })
                //  #endif
                //  #if os(iOS)
                //      .fullScreenCover(isPresented:$isAppPatientDetailsByNameShowing)
                //      {
                //
                //          AppVisitMgmtPatient1DetailsView(sPatientPID:$sPatientPID)
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

                        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtPatient3View.Button(Xcode).'Locate the Patient by PID or Name'...")

                        if (self.sPatientPID.count > 0)
                        {
                            self.sPatientName = self.locateAppPatientNamebyPid(sPatientPID:sPatientPID)
                        }
                        else
                        {
                            if (self.sPatientName.count > 0)
                            {
                                self.sPatientPID = self.locateAppPatientPIDByName(sPatientName:self.sPatientName)
                            }
                        }

                        self.isAppRunPatientLocateByNameShowing.toggle()

                    }
                    label:
                    {

                        VStack(alignment:.center)
                        {

                            Label("", systemImage: "figure.run.circle")
                                .help(Text("Locate the Patient by PID or Name..."))
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

                        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtPatient3View.Button(Xcode).'Patient Name delete'...")

                        self.sPatientName = ""
                        self.sPatientPID  = ""
                        focusedField        = .patientName

                    }
                    label:
                    {

                        VStack(alignment:.center)
                        {

                            Label("", systemImage: "delete.left")
                                .help(Text("Delete the Patient Name..."))
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

                        listSelectablePatientNames = [AppSearchablePatientName]()

                        listSelectablePatientNames.append(AppSearchablePatientName(sPatientName:"...placeholder...", sPatientPID:"-1"))

                    }

                List(listSelectablePatientNames, id:\.id)
                { appSearchablePatientName in

                //  Text(appSearchablePatientName.sPatientName)
                    Text("\(appSearchablePatientName.sPatientName) - \(appSearchablePatientName.sPatientPID)")
                        .onTapGesture
                        {
                            self.sPatientName = appSearchablePatientName.sPatientName
                            self.sPatientPID  = self.locateAppPatientPIDByName(sPatientName:self.sPatientName)
                            focusedField        = .patientName
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
    
    private func locateAppPatientNamebyPid(sPatientPID:String = "")->String
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'sPatientPID' is [\(sPatientPID)]...")

        }

        // Locate the Patient 'name' by PID...

        var sPatientName:String = self.jmAppParseCoreBkgdDataRepo.convertPidToPatientName(sPFPatientParsePID:sPatientPID)

        if (sPatientName.count < 1)
        {
        
            sPatientName = "-N/A-"
        
        }

        // Exit...

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'sPatientName' is [\(sPatientName)] - 'sPatientPID' is [\(sPatientPID)]...")

        }
  
        return sPatientName
  
    }   // End of private func locateAppPatientNamebyPid(sPatientPID:String)->String.

    private func locateAppPatientPIDByName(sPatientName:String = "")->String
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'sPatientName' is [\(sPatientName)]...")

        }

        // Locate the Patient PID by 'name'...

        var sPatientPID:String = self.jmAppParseCoreManager.convertPatientNameToPid(sPFPatientParseName:sPatientName)

        if (sPatientPID.count < 1)
        {
        
            sPatientPID = ""
        //  sPatientPID = "-1"
        
        }

        // Exit...

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'sPatientName' is [\(sPatientName)] - 'sPatientPID' is [\(sPatientPID)]...")

        }
  
        return sPatientPID
  
    }   // End of private func locateAppPatientPIDByName(sPatientName:String)->String.

    private func updateSelectablePatientNamesList(sSearchValue:String = "")
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'sSearchValue' is [\(sSearchValue)]...")

        }

        // Update the 'selectable' Patient 'name(s)' list from the 'sSearchValue' criteria...

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

        // var dictPFPatientFileItems:[Int:ParsePFPatientFileItem] = [Int:ParsePFPatientFileItem]()

        if (self.jmAppParseCoreManager.dictPFPatientFileItems.count < 1)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) Intermediate #2 - 'self.jmAppParseCoreManager.dictPFPatientFileItems' is an empty 'dictionary' - unable to update the 'selectable' item(s) - Warning!")
            
            // Exit:

            if (self.bInternalTraceFlag == true)
            {

                self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            }

            return
        
        }

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Intermediate #3 - 'sSearchValue' is [\(sSearchValue)] - 'self.jmAppParseCoreManager.dictPFPatientFileItems' contains (\(self.jmAppParseCoreManager.dictPFPatientFileItems.count)) item(s)...")

        }

        self.listSelectablePatientNames = [AppSearchablePatientName]()

        var cPatientNames:Int           = 0
        var cSelectablePatientNames:Int = 0
        let sSearchValueLow:String      = sSearchValue.lowercased()
        
        // var dictPFPatientFileItems:[Int:ParsePFPatientFileItem] = [Int:ParsePFPatientFileItem]()

        for (iPFPatientParsePID, pfPatientFileItem) in self.jmAppParseCoreManager.dictPFPatientFileItems
        {

            cPatientNames += 1

            if (iPFPatientParsePID < 0)
            {

                self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cPatientNames)) 'iPFPatientParsePID' - the 'pid' field is less than 0 - Warning!")

                continue

            }

            let sPatientPID:String      = "\(pfPatientFileItem.iPFPatientFilePID)"
            let sPatientName:String     = pfPatientFileItem.sPFPatientFileName
            let sPatientNameLow:String  = sPatientName.lowercased()
            let sPatientNameNoWS:String = pfPatientFileItem.sPFPatientFileNameNoWS

            if (sPatientNameLow.contains(sSearchValueLow)  == true ||
                sPatientNameNoWS.contains(sSearchValueLow) == true)
            {
            
                self.listSelectablePatientNames.append(AppSearchablePatientName(sPatientName:sPatientName, sPatientPID:sPatientPID))

                cSelectablePatientNames += 1

                if (self.bInternalTraceFlag == true)
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) #(\(cPatientNames)): 'sPatientName' of [\(sPatientName)] - 'sPatientPID' of [\(sPatientPID)] contains the 'sSearchValue' of [\(sSearchValue)] - adding to the 'selectable' list...")

                }
            
            }

        }

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Intermediate #3 - added (\(cSelectablePatientNames)) names(s) to the 'selectable' list of (\(self.listSelectablePatientNames.count)) item(s)...")

        }

        // Exit:

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        }

        return

    }   // End of private func updateSelectablePatientNamesList(sSearchValue:String).

}   // End of struct AppVisitMgmtPatient3View(View).

#Preview 
{
    
    AppVisitMgmtPatient3View()
    
}

