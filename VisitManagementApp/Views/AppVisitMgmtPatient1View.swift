//
//  AppVisitMgmtPatient1View.swift
//  VisitManagementApp
//
//  Created by Daryl Cox on 02/05/2025.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct AppVisitMgmtPatient1View: View 
{
    
    struct ClassInfo
    {
        
        static let sClsId        = "AppVisitMgmtPatient1View"
        static let sClsVers      = "v1.0201"
        static let sClsDisp      = sClsId+"(.swift).("+sClsVers+"):"
        static let sClsCopyRight = "Copyright (C) JustMacApps 2023-2025. All Rights Reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }
    
    // App Data field(s):

//  @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode

    enum FocusedFields
    {
       case patientPID
    }
    
    @FocusState private var focusedField:FocusedFields?

    @State      private var sPatientPID:String                                    = ""
    @State      private var sPatientName:String                                   = ""

    @State      private var cAppLogPFDataButtonPresses:Int                        = 0
    @State      private var cAppVisitMgmtPatient1ViewRefreshButtonPresses:Int  = 0

    @State      private var isAppLogPFDataViewModal:Bool                          = false
    @State      private var isAppRunPatientLocateByPidShowing:Bool                = false
    @State      private var isAppPatientDetailsByPidShowing:Bool                  = false

                        var jmAppDelegateVisitor:JmAppDelegateVisitor             = JmAppDelegateVisitor.ClassSingleton.appDelegateVisitor
    @ObservedObject     var jmAppParseCoreManager:JmAppParseCoreManager           = JmAppParseCoreManager.ClassSingleton.appParseCodeManager
                        var jmAppParseCoreBkgdDataRepo:JmAppParseCoreBkgdDataRepo = JmAppParseCoreBkgdDataRepo.ClassSingleton.appParseCodeBkgdDataRepo
    
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

                    if (AppGlobalInfo.bPerformAppDevTesting == true)
                    {

                        Button
                        {

                            self.cAppLogPFDataButtonPresses += 1

                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):AppVisitMgmtPatient1View.Button(Xcode).'Log/Reload Data'.#(\(self.cAppLogPFDataButtonPresses)) pressed...")

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

                        self.cAppVisitMgmtPatient1ViewRefreshButtonPresses += 1

                        let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppVisitMgmtPatient1View.Button(Xcode).'Refresh'.#(\(self.cAppVisitMgmtPatient1ViewRefreshButtonPresses))...")

                    }
                    label:
                    {

                        VStack(alignment:.center)
                        {

                            Label("", systemImage: "arrow.clockwise")
                                .help(Text("'Refresh' App Data Gatherer Patient by PID Screen..."))
                                .imageScale(.large)

                            Text("Refresh - #(\(self.cAppVisitMgmtPatient1ViewRefreshButtonPresses))...")
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

                        let _ = xcgLogMsg("\(ClassInfo.sClsDisp):AppVisitMgmtPatient1View.Button(Xcode).'Dismiss' pressed...")

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

                    Text(" - - - - - - - - - - - - - - - - - - - - ")
                        .font(.caption2) 
                        .frame(maxWidth:.infinity, alignment:.center)

                    HStack
                    {

                        Button
                        {

                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtPatient1View.Button(Xcode).'Locate the Patient by PID'...")

                            self.sPatientName = self.locateAppPatientNamebyPid(sPatientPID:sPatientPID)

                            self.isAppRunPatientLocateByPidShowing.toggle()

                        }
                        label:
                        {

                            HStack(alignment:.center)
                            {

                                Spacer()

                                Label("", systemImage: "figure.run.circle")
                                    .help(Text("Locate the Patient by PID..."))
                                    .imageScale(.small)

                                Text("=> Locate Patient by PID")
                                    .bold()
                                    .font(.caption2)
                                    .foregroundColor(.red)

                                Spacer()

                            }

                        }
                    //  .alert("PID #(\(sPatientPID)) is Patient 'named' [\(sPatientName)]...", 
                    //         isPresented:$isAppRunPatientLocateByPidShowing)
                    //  {
                    //      Button("Ok", role:.cancel)
                    //      {
                    //          let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp) User pressed 'Ok' to 'locate' the Patient by PID...")
                    //      }
                    //  }
                    #if os(macOS)
                        .buttonStyle(.borderedProminent)
                        .padding()
                    //  .background(???.isPressed ? .blue : .gray)
                        .cornerRadius(10)
                        .foregroundColor(Color.primary)
                    #endif
                    //  .padding()

                    }

                    Text(" - - - - - - - - - - - - - - - - - - - - ")
                        .font(.caption2) 
                        .frame(maxWidth:.infinity, alignment:.center)

                }

                HStack()
                {

                    Text("=> Enter the Patients' PID: ")
                        .font(.caption) 
                        .foregroundColor(.red)

                    TextField("Patient PID...", text:$sPatientPID)
                        .font(.caption) 
                    #if os(iOS)
                        .keyboardType(.numberPad)
                    #endif
                        .onSubmit
                        {
                            self.sPatientName = self.locateAppPatientNamebyPid(sPatientPID:sPatientPID)
                            focusedField        = .patientPID
                        }
                        .onReceive(Just(sPatientPID))
                        { newValue in
                            let filteredValue = newValue.filter { "-0123456789".contains($0) }
                            if (filteredValue != newValue)
                            {
                                self.sPatientPID = filteredValue
                            }
                        }
                        .focused($focusedField, equals:.patientPID)
                        .onAppear
                        {
                            self.sPatientName = ""
                            focusedField        = .patientPID
                        }

                    Spacer()

                    Button
                    {

                        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtPatient1View.Button(Xcode).'Patient PID delete'...")

                        self.sPatientName = ""
                        self.sPatientPID  = ""
                        focusedField        = .patientPID

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

                                Text("Delete Patient PID")
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
                    .padding()

                }

                HStack()
                {

                    Text("===> Patients' Name: ")
                        .font(.caption) 

                    Text("\(self.sPatientName)")
                        .italic()
                        .font(.caption) 

                    Spacer()

                    if (self.sPatientPID.count    > 0 &&
                        (self.sPatientName.count  > 0 &&
                         self.sPatientName       != "-N/A-"))
                    {

                        Button
                        {

                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtPatient1View.Button(Xcode).'Patient Detail(s) by PID'...")

                            self.isAppPatientDetailsByPidShowing.toggle()

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

                                    Text("Patient Details...")
                                        .font(.caption2)

                                    Spacer()

                                }

                            }

                        }
                    #if os(macOS)
                        .sheet(isPresented:$isAppPatientDetailsByPidShowing, content:
                        {

                            AppVisitMgmtPatient1DetailsView(sPatientPID:$sPatientPID)

                        })
                    #endif
                    #if os(iOS)
                        .fullScreenCover(isPresented:$isAppPatientDetailsByPidShowing)
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
                        .padding()
                    
                    }
                    
                }

                Spacer()

            }

            Spacer()

        }
        .padding()
        
    }
    
    private func locateAppPatientNamebyPid(sPatientPID:String = "")->String
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'sPatientPID' is [\(sPatientPID)]...")

        // Locate the Patient 'name' by PID...

        var sPatientName:String = self.jmAppParseCoreBkgdDataRepo.convertPidToPatientName(sPFPatientParsePID:sPatientPID)

        if (sPatientName.count < 1)
        {
        
            sPatientName = "-N/A-"
        
        }

        // Exit...

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'sPatientName' is [\(sPatientName)] - 'sPatientPID' is [\(sPatientPID)]...")
  
        return sPatientName
  
    }   // End of private func locateAppPatientNamebyPid(sPatientPID:String)->String.

}   // End of struct AppVisitMgmtPatient1View(View).

#Preview 
{
    
    AppVisitMgmtPatient1View()
    
}

