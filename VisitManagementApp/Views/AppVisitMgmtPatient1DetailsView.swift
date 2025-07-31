//
//  AppVisitMgmtPatient1DetailsView.swift
//  VisitManagementApp
//
//  Created by Daryl Cox on 02/05/2025.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

enum PIDType: String, CaseIterable
{
    
    case patient = "patient"
    case parent  = "parent"
//  case mentor  = "mentor"
    
}   // End of enum PIDType(String, CaseIterable).

struct AppVisitMgmtPatient1DetailsView: View 
{
    
    struct ClassInfo
    {
        
        static let sClsId        = "AppVisitMgmtPatient1DetailsView"
        static let sClsVers      = "v1.1501"
        static let sClsDisp      = sClsId+"(.swift).("+sClsVers+"):"
        static let sClsCopyRight = "Copyright (C) JustMacApps 2023-2025. All Rights Reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }
    
    // App Data field(s):

//  @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode

    @Binding     private var sPatientPID:String

    @State       private var sPatientName:String                                     = ""
    @State       private var pfPatientFileItem:ParsePFPatientFileItem?               = nil

    @State       private var sSupervisorTID:String                                   = ""
    @State       private var sSupervisorName:String                                  = ""

    @State       private var cAppTidScheduleViewButtonPresses:Int                    = 0

    @State       private var isAppTidScheduleViewModal:Bool                          = false
//  @State       private var isAppTidScheduleViewEnabled:Bool                        = false
    @State       private var isAppSupervisorDetailsByTIDShowing:Bool                 = false

    @State       private var sTherapistTID:String                                    = ""
    @State       private var sTherapistName:String                                   = ""

    @State       private var isAppTherapistDetailsByTIDShowing:Bool                  = false

    @State       private var sStartTherapistTID:String                               = ""
    @State       private var sStartTherapistName:String                              = ""

    @State       private var isAppStartTherapistDetailsByTIDShowing:Bool             = false

    @State       private var pfTherapistFileItem:ParsePFTherapistFileItem?           = nil

                         var jmAppDelegateVisitor:JmAppDelegateVisitor               = JmAppDelegateVisitor.ClassSingleton.appDelegateVisitor
    @ObservedObject      var jmAppParseCoreManager:JmAppParseCoreManager             = JmAppParseCoreManager.ClassSingleton.appParseCodeManager
                         var jmAppParseCoreBkgdDataRepo:JmAppParseCoreBkgdDataRepo   = JmAppParseCoreBkgdDataRepo.ClassSingleton.appParseCodeBkgdDataRepo
                         var appScheduleLoadingAssistant:AppScheduleLoadingAssistant = AppScheduleLoadingAssistant.ClassSingleton.appScheduleLoadingAssistant
    
    init(sPatientPID:Binding<String>)
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        // Handle the 'sPatientPID' parameter...

        _sPatientPID = sPatientPID

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
        
    //  let listScheduledPatientLocationItems:[ScheduledPatientLocationItem]
    //      = self.getScheduledPatientLocationItemsForTid(sPFTherapistParseTID:sTherapistTID)

        NavigationStack
        {

            VStack
            {

                HStack(alignment:.center)
                {

                    Button
                    {

                        self.cAppTidScheduleViewButtonPresses += 1

                        let _ = xcgLogMsg("\(ClassInfo.sClsDisp):AppVisitMgmtPatient1DetailsView.Button(Xcode).'App TID Schedule View'.#(\(self.cAppTidScheduleViewButtonPresses))...")

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

                        //  AppTidScheduleView(listScheduledPatientLocationItems:listScheduledPatientLocationItems)
                            AppTidScheduleView(listScheduledPatientLocationItems:self.appScheduleLoadingAssistant.getScheduledPatientLocationItemsForTid(sPFTherapistTID:sTherapistTID))

                        }
                    )
                #elseif os(iOS)
                    .fullScreenCover(isPresented:$isAppTidScheduleViewModal)
                    {

                    //  AppTidScheduleView(listScheduledPatientLocationItems:listScheduledPatientLocationItems)
                        AppTidScheduleView(listScheduledPatientLocationItems:self.appScheduleLoadingAssistant.getScheduledPatientLocationItemsForTid(sPFTherapistTID:sTherapistTID))

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
                //  .disabled(!self.isAppTidScheduleViewEnabled)

                    Spacer()

                    Button
                    {
                        let _ = xcgLogMsg("\(ClassInfo.sClsDisp):AppVisitMgmtView.Button(Xcode).'Sync Data' pressed...")

                        self.syncPFDataItems()
                    }
                    label:
                    {
                        VStack(alignment:.center)
                        {
                            Label("", systemImage: "doc.text.magnifyingglass")
                                .help(Text("Sync PFQuery Data Item(s)..."))
                                .imageScale(.medium)
                            Text("Sync Data")
                                .font(.footnote)
                        }
                    }
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

                        let _ = xcgLogMsg("\(ClassInfo.sClsDisp):AppVisitMgmtPatient1DetailsView.Button(Xcode).'Dismiss' pressed...")

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

                    Text("VMA - Patient Details by PID/Name")
                        .bold()
                        .font(.caption2) 
                        .frame(maxWidth:.infinity, alignment:.center)

                    Text(" - - - - - - - - - - - - - - - - - - - - ")
                        .font(.caption2) 
                        .frame(maxWidth:.infinity, alignment:.center)

                }

                HStack
                {

                    Text("::: Patients' PID: ")
                        .font(.caption) 
                        .onAppear
                        {

                            self.sPatientName = self.locateAppPatientNamebyPid(pidType:PIDType.patient, sPatientPID:self.sPatientPID)

                        }

                    Text("\(self.sPatientPID)")
                        .italic()
                        .font(.caption) 
                        .foregroundColor(.red)

                    Spacer()

                }

                HStack
                {

                    Text("Patients' Name: ")
                        .font(.caption) 

                    Text("\(self.sPatientName)")
                        .italic()
                        .font(.caption) 
                        .foregroundColor(.red)

                    Spacer()

                }

            if (self.pfPatientFileItem != nil)
            {
            
                ScrollView(.vertical)
                {

                    Grid(alignment:.leadingFirstTextBaseline, horizontalSpacing:5, verticalSpacing: 3)
                    {

                        // Column Headings:

                        Divider() 

                        GridRow 
                        {

                            Text("Item")
                                .bold()
                                .underline()
                            Text("Value")
                                .bold()
                                .underline()

                        }
                        .font(.caption) 

                        Divider() 

                        // Item Rows:

                    //  GridRow(alignment:.bottom)
                    //  {
                    //
                    //      Text("Patients' Phone #")
                    //      Text("\(self.formatPhoneNumber(sPhoneNumber:self.pfPatientFileItem!.sPFPatientFilePhone))")
                    //  //  Text("\(self.pfPatientFileItem!.sPFPatientFilePhone)")
                    //
                    //  }
                    //  .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' First Name")
                            Text("\(self.pfPatientFileItem!.sPFPatientFileFirstName)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Last Name")
                            Text("\(self.pfPatientFileItem!.sPFPatientFileLastName)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Emergency Contact(s)")
                            Text("\(self.pfPatientFileItem!.sPFPatientFileEmerContacts)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Home Location (Lat/Long)")
                            Text("\(self.pfPatientFileItem!.sPFPatientFileHomeLoc)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Home Location (Address)")
                            Text("\(self.pfPatientFileItem!.sHomeLocLocationName),\(self.pfPatientFileItem!.sHomeLocCity)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' File 'created at")
                            Text("<\(self.pfPatientFileItem!.datePFPatientFileCreatedAt!, format:Date.FormatStyle(date:.numeric, time:.standard))>")
                                .italic()
                        //  Text("\(String(describing: self.pfPatientFileItem!.datePFPatientFileCreatedAt))")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' File 'updated' at")
                            Text("<\(self.pfPatientFileItem!.datePFPatientFileUpdatedAt!, format:Date.FormatStyle(date:.numeric, time:.standard))>")
                                .italic()
                        //  Text("\(String(describing: self.pfPatientFileItem!.datePFPatientFileUpdatedAt))")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Name (No Whitespace)")

                            if (self.pfPatientFileItem!.sPFPatientFileNameNoWS.count > 0)
                            {
                            
                                Text("\(self.pfPatientFileItem!.sPFPatientFileNameNoWS)")
                            
                            }
                            else
                            {
                            
                                Text("--- Omitted in the Database - Warning! ---")
                                    .foregroundColor(.red)
                            
                            }

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' DOB (Date Of Birth)")
                            Text("\(self.pfPatientFileItem!.sPFPatientFileDOB)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patient is 'Real' Patient?")
                            Text("\(self.pfPatientFileItem!.bPFPatientFileIsRealPatient)")
                                .foregroundStyle((self.pfPatientFileItem!.bPFPatientFileIsRealPatient) ? .red : .primary)

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Language preference")
                            Text("\(self.pfPatientFileItem!.sPFPatientFileLanguagePref)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patient is 'Discharged'?")
                            Text("\(self.pfPatientFileItem!.bPFPatientFileIsDischarged)")
                                .foregroundStyle((self.pfPatientFileItem!.bPFPatientFileIsDischarged) ? .red : .primary)

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patient is 'On Hold'?")
                            Text("\(self.pfPatientFileItem!.bPFPatientFileIsOnHold)")
                                .foregroundStyle((self.pfPatientFileItem!.bPFPatientFileIsOnHold) ? .red : .primary)

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' 'On Hold' Date")
                            Text("\(self.pfPatientFileItem!.sPFPatientFileOnHoldDate)")
                                .foregroundStyle((self.pfPatientFileItem!.sPFPatientFileOnHoldDate.count > 0) ? .red : .primary)

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' 'On Hold' Reason")
                            Text("\(self.pfPatientFileItem!.iPFPatientFileHoldReason)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Parent Name")
                            Text("\(self.pfPatientFileItem!.sPFPatientFileParentName)")

                        }
                        .font(.caption2) 
 
                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Parent ID")
                            Text("\(self.pfPatientFileItem!.sPFPatientFileParentID)")

                        }
                        .font(.caption2) 

                    //  GridRow(alignment:.bottom)
                    //  {
                    //
                    //      Text("Patients' Supervisor (SID)")
                    //      Text("\(self.pfPatientFileItem!.iPFPatientFileSID)")
                    //
                    //  }
                    //  .font(.caption2) 
                    //
                    //  GridRow(alignment:.bottom)
                    //  {
                    //
                    //      Text("Patients' Supervisor Name")
                    //      Text("\(self.pfPatientFileItem!.sPFPatientFileSidName)")
                    //
                    //  }
                    //  .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Current TID(s)")
                            Text("\(self.pfPatientFileItem!.sPFPatientFileCurrentTIDs)")

                        }
                        .font(.caption2) 

                        if (self.pfPatientFileItem!.sPFPatientFileCurrentTIDs.count > 0)
                        {
                        
                            GridRow(alignment:.bottom)
                            {

                                VStack
                                {

                                    Text("Patients' Therapist (TID)")
                                        .onAppear
                                        {

                                            self.sTherapistTID  = self.getFirstTidFromTids(sTherapistTIDs:self.pfPatientFileItem!.sPFPatientFileCurrentTIDs)
                                            self.sTherapistName = self.locateAppTherapistNamebyTid(tidType:TIDType.therapist, sTherapistTID:self.sTherapistTID)

                                        }

                                    Text("")    // ...vertical spacing...
                                    Text("")    // ...vertical spacing...

                                }

                                HStack
                                {

                                    Text("\(self.sTherapistTID) <\(self.sTherapistName)>")

                                    if (self.sTherapistTID.count    > 0 &&
                                        (self.sTherapistName.count  > 0 &&
                                         self.sTherapistName       != "-N/A-"))
                                    {

                                        Button
                                        {

                                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtPatient1DetailsView.Button(Xcode).'Therapist Detail(s) by TID'...")

                                            self.isAppTherapistDetailsByTIDShowing.toggle()

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

                                                    Text("Therapist Details...")
                                                        .font(.caption2)

                                                    Spacer()

                                                }

                                            }

                                        }
                                    #if os(macOS)
                                        .sheet(isPresented:$isAppTherapistDetailsByTIDShowing, content:
                                        {

                                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp) <macOS> Showing 'Therapist Detail(s) by TID' for TID [\(self.sTherapistTID)]...")

                                            AppVisitMgmtTherapist1DetailsView(sTherapistTID:$sTherapistTID)

                                        })
                                    #endif
                                    #if os(iOS)
                                        .fullScreenCover(isPresented:$isAppTherapistDetailsByTIDShowing)
                                        {

                                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp) <iOS> Showing 'Therapist Detail(s) by TID' for TID [\(self.sTherapistTID)]...")

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
                                        .padding()

                                    }
                                    else
                                    {

                                        Spacer()

                                    }

                                }

                            }
                            .font(.caption2) 
                        
                        }

                        GridRow(alignment:.bottom)
                        {

                            VStack
                            {

                                Text("Patients' Supervisor (SID)")
                                Text("")    // ...vertical spacing...
                                Text("")    // ...vertical spacing...

                            }

                            HStack
                            {

                            //  Text("\(self.pfPatientFileItem!.iPFPatientFileSID) <\(self.pfPatientFileItem!.sPFPatientFileSidName)>")
                                Text("\(sSupervisorTID) <\(sSupervisorName)>")
                                    .onAppear
                                    {

                                        self.sSupervisorTID  = "\(self.pfPatientFileItem!.iPFPatientFileSID)"
                                        self.sSupervisorName = self.locateAppTherapistNamebyTid(tidType:TIDType.supervisor, sTherapistTID:"\(self.pfPatientFileItem!.iPFPatientFileSID)")

                                    }

                                if (self.sSupervisorTID.count    > 0 &&
                                    (self.sSupervisorName.count  > 0 &&
                                     self.sSupervisorName       != "-N/A-"))
                                {

                                    Button
                                    {

                                        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtPatient1DetailsView.Button(Xcode).'Supervisor Detail(s) by TID (SID)'...")

                                        self.isAppSupervisorDetailsByTIDShowing.toggle()

                                    }
                                    label:
                                    {

                                        VStack(alignment:.center)
                                        {

                                            Label("", systemImage: "doc.questionmark")
                                                .help(Text("Show Supervisor Detail(s) by TID (SID)..."))
                                                .imageScale(.medium)

                                            HStack(alignment:.center)
                                            {

                                                Spacer()

                                                Text("Supervisor Details...")
                                                    .font(.caption2)

                                                Spacer()

                                            }

                                        }

                                    }
                                #if os(macOS)
                                    .sheet(isPresented:$isAppSupervisorDetailsByTIDShowing, content:
                                    {

                                        AppVisitMgmtTherapist1DetailsView(sTherapistTID:$sSupervisorTID)

                                    })
                                #endif
                                #if os(iOS)
                                    .fullScreenCover(isPresented:$isAppSupervisorDetailsByTIDShowing)
                                    {

                                        AppVisitMgmtTherapist1DetailsView(sTherapistTID:$sSupervisorTID)

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
                                else
                                {

                                    Spacer()

                                }

                            }

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Start TID(s)")
                            Text("\(self.pfPatientFileItem!.sPFPatientFileStartTIDs)")

                        }
                        .font(.caption2) 

                        if (self.pfPatientFileItem!.sPFPatientFileStartTIDs.count > 0)
                        {
                        
                            GridRow(alignment:.bottom)
                            {

                                VStack
                                {

                                    Text("Patients' Start Therapist (TID)")
                                        .onAppear
                                        {

                                            self.sStartTherapistTID  = self.getFirstTidFromTids(sTherapistTIDs:self.pfPatientFileItem!.sPFPatientFileStartTIDs)
                                            self.sStartTherapistName = self.locateAppTherapistNamebyTid(tidType:TIDType.therapist, sTherapistTID:self.sStartTherapistTID)

                                        }

                                    Text("")    // ...vertical spacing...
                                    Text("")    // ...vertical spacing...

                                }

                                HStack
                                {

                                    Text("\(self.sStartTherapistTID) <\(self.sStartTherapistName)>")

                                    if (self.sStartTherapistTID.count    > 0 &&
                                        (self.sStartTherapistName.count  > 0 &&
                                         self.sStartTherapistName       != "-N/A-"))
                                    {

                                        Button
                                        {

                                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtPatient1DetailsView.Button(Xcode).'Start Therapist Detail(s) by TID'...")

                                            self.isAppStartTherapistDetailsByTIDShowing.toggle()

                                        }
                                        label:
                                        {

                                            VStack(alignment:.center)
                                            {

                                                Label("", systemImage: "doc.questionmark")
                                                    .help(Text("Show Start Therapist Detail(s) by TID..."))
                                                    .imageScale(.medium)

                                                HStack(alignment:.center)
                                                {

                                                    Spacer()

                                                    Text("Start Therapist Details...")
                                                        .font(.caption2)

                                                    Spacer()

                                                }

                                            }

                                        }
                                    #if os(macOS)
                                        .sheet(isPresented:$isAppStartTherapistDetailsByTIDShowing, content:
                                        {

                                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp) <macOS> Showing 'Start Therapist Detail(s) by TID' for TID [\(self.sStartTherapistTID)]...")

                                            AppVisitMgmtTherapist1DetailsView(sTherapistTID:$sStartTherapistTID)

                                        })
                                    #endif
                                    #if os(iOS)
                                        .fullScreenCover(isPresented:$isAppStartTherapistDetailsByTIDShowing)
                                        {

                                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp) <iOS> Showing 'Start Therapist Detail(s) by TID' for TID [\(self.sStartTherapistTID)]...")

                                            AppVisitMgmtTherapist1DetailsView(sTherapistTID:$sStartTherapistTID)

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
                                    else
                                    {

                                        Spacer()

                                    }

                                }

                            }
                            .font(.caption2) 
                        
                        }

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Supervised Visits")
                            Text("\(self.pfPatientFileItem!.sPFPatientFileSupervisedVisits)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' is Ready for Supervisor?")
                            Text("\(self.pfPatientFileItem!.bPFPatientFileReadyForSuper)")
                                .foregroundStyle((self.pfPatientFileItem!.bPFPatientFileReadyForSuper) ? .red : .primary)

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' File is 'to' Supervisor?")
                            Text("\(self.pfPatientFileItem!.bPFPatientFileIsToSuper)")
                                .foregroundStyle((self.pfPatientFileItem!.bPFPatientFileIsToSuper) ? .red : .primary)

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Authorization 'begin'")
                            Text("\(self.pfPatientFileItem!.sPFPatientFileAuthBegin)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Authorization 'end'")
                            Text("\(self.pfPatientFileItem!.sPFPatientFileAuthEnd)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Start Authorization 'begin'")
                            Text("\(self.pfPatientFileItem!.sPFPatientFileStartAuthBegin)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Start Authorization 'end'")
                            Text("\(self.pfPatientFileItem!.sPFPatientFileStartAuthEnd)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Current Authorization 'begin'")
                            Text("\(self.pfPatientFileItem!.sPFPatientFileCurrentAuthBegin)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Current Authorization 'end'")
                            Text("\(self.pfPatientFileItem!.sPFPatientFileCurrentAuthEnd)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Expected Frequency")
                            Text("\(self.pfPatientFileItem!.iPFPatientFileExpectedFrequency)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Expected Visits")
                            Text("\(self.pfPatientFileItem!.iPFPatientFileExpectedVisits)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' First Visit Date")
                            Text("\(self.pfPatientFileItem!.sPFPatientFileFirstVisitDate)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Last Visit Date")
                            Text("\(self.pfPatientFileItem!.sPFPatientFileLastVisitDate)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Last Evaluation Date")
                            Text("\(self.pfPatientFileItem!.sPFPatientFileLastEvalDate)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Last Doctor Visit Date")
                            Text("\(self.pfPatientFileItem!.sPFPatientFileLastDrVisitDate)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' NEW Visit Count")
                            Text("\(self.pfPatientFileItem!.iPFPatientFileNewVisitCount)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Number of Visits Done")
                            Text("\(self.pfPatientFileItem!.iPFPatientFileNumberOfVisitsDone)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Total Number of Authorized Visits")
                            Text("\(self.pfPatientFileItem!.iPFPatientFileTotalAuthorizedVisits)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Total Number of Missed Visits")
                            Text("\(self.pfPatientFileItem!.iPFPatientFileTotalNumberOfMissedVisits)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Visit Count")
                            Text("\(self.pfPatientFileItem!.iPFPatientFileVisitCount)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Visit Count #2")
                            Text("\(self.pfPatientFileItem!.iPFPatientFileVisitCount2)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' DME")
                            Text("\(self.pfPatientFileItem!.sPFPatientFileDME)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Alergies")
                            Text("\(self.pfPatientFileItem!.sPFPatientFileAlergies)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Behavior Observations")
                            Text("\(self.pfPatientFileItem!.sPFPatientFileBehaviorObs)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Current Diet")
                            Text("\(self.pfPatientFileItem!.sPFPatientFileCurrentDiet)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Current Frequencies")
                            Text("\(self.pfPatientFileItem!.sPFPatientFileCurrentFrequencies)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Evaluation Meds")
                            Text("\(self.pfPatientFileItem!.sPFPatientFileEvalMeds)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' have Admin Visits?")
                            Text("\(self.pfPatientFileItem!.bPFPatientFileHaveAdminVisits)")
                                .foregroundStyle((self.pfPatientFileItem!.bPFPatientFileHaveAdminVisits) ? .red : .primary)

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' have Missed Visits?")
                            Text("\(self.pfPatientFileItem!.bPFPatientFileHaveMissedVisits)")
                                .foregroundStyle((self.pfPatientFileItem!.bPFPatientFileHaveMissedVisits) ? .red : .primary)

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Makeups Allowed?")
                            Text("\(self.pfPatientFileItem!.bPFPatientFileMakeupsAllowed)")
                                .foregroundStyle((self.pfPatientFileItem!.bPFPatientFileMakeupsAllowed) ? .red : .primary)

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Med Number")
                            Text("\(self.pfPatientFileItem!.iPFPatientFileMedNumber)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' NO Pre Sig required?")
                            Text("\(self.pfPatientFileItem!.bPFPatientFileNoPreSigRequired)")
                                .foregroundStyle((self.pfPatientFileItem!.bPFPatientFileNoPreSigRequired) ? .red : .primary)

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Pertinent History")
                            Text("\(self.pfPatientFileItem!.sPFPatientFilePertinentHistory)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Primary Insurance")
                            Text("\(self.pfPatientFileItem!.iPFPatientFilePrimaryIns)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Secondary Insurance")
                            Text("\(self.pfPatientFileItem!.iPFPatientFileSecondaryIns)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Registered Names")
                            Text("\(self.pfPatientFileItem!.sPFPatientFileRegisteredNames)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Safeties")
                            Text("\(self.pfPatientFileItem!.sPFPatientFileSafeties)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Start TID Frequencies")
                            Text("\(self.pfPatientFileItem!.sPFPatientFileStartTIDFrequencies)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Treatment DX")
                            Text("\(self.pfPatientFileItem!.sPFPatientFileTreatmentDX)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' TYPE")
                            Text("\(self.pfPatientFileItem!.iPFPatientFileType)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Patients' Visits Done")
                            Text("\(self.pfPatientFileItem!.sPFPatientFileVisitsDone)")

                        }
                        .font(.caption2) 

                        Divider() 

                    }

                }

            }
            else
            {

                Divider() 

                // Item Rows:

                GridRow(alignment:.bottom)
                {

                    Text("<<< NO Data >>>")
                    Text("Patient PID #(\(self.sPatientPID))")
                        .italic()

                }
                .font(.caption2) 

                Divider() 

            }

                Spacer()

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

    private func locateAppPatientNamebyPid(pidType:PIDType, sPatientPID:String = "")->String
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'pidType' is [\(pidType)] - 'sPatientPID' is [\(sPatientPID)]...")

        // Locate the Patient 'name' by PID...

        var sPatientName:String = ""

        if (sPatientPID.count > 0)
        {
        
            sPatientName = self.jmAppParseCoreManager.convertPidToPatientName(sPFPatientParsePID:sPatientPID)

            let iPatientPID:Int = Int(sPatientPID)!

            if (iPatientPID >= 0)
            {

                if (pidType == PIDType.patient)
                {
                
                    self.pfPatientFileItem = self.jmAppParseCoreManager.dictPFPatientFileItems[iPatientPID]

                    self.xcgLogMsg("\(sCurrMethodDisp) Intermediate - 'self.pfPatientFileItem' is [\(String(describing: self.pfPatientFileItem))]...")
                
                }
                else
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) Intermediate - bypassing the setting of 'self.pfPatientFileItem' - 'pidType' of [\(pidType)] is NOT PIDType.patient...")

                }

            }
            else
            {
            
                self.xcgLogMsg("\(sCurrMethodDisp) Intermediate - bypassing the setting of 'self.pfPatientFileItem' - 'iPatientPID' of (\(iPatientPID)) is less than Zero...")

            }

        }

        if (sPatientName.count < 1)
        {
        
            sPatientName = "-N/A-"
        
        }

        // Exit...

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'sPatientPID' is [\(sPatientPID)] - 'sPatientName' is [\(sPatientName)]...")
  
        return sPatientName
  
    }   // End of private func locateAppPatientNamebyPid(sPatientPID:String)->String.

    private func locateAppTherapistNamebyTid(tidType:TIDType, sTherapistTID:String = "")->String
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'tidType' is [\(tidType)] - 'sTherapistTID' is [\(sTherapistTID)]...")

        // Locate the Therapist 'name' by TID...

        var sTherapistName:String = ""

        if (sTherapistTID.count > 0)
        {
        
            sTherapistName = self.jmAppParseCoreManager.convertTidToTherapistName(sPFTherapistParseTID:sTherapistTID)

            let iTherapistTID:Int = Int(sTherapistTID)!

            if (iTherapistTID >= 0)
            {

                if (tidType == TIDType.therapist)
                {
                
                    self.pfTherapistFileItem = self.jmAppParseCoreManager.dictPFTherapistFileItems[iTherapistTID]

                    self.xcgLogMsg("\(sCurrMethodDisp) Intermediate - 'self.pfTherapistFileItem' is [\(String(describing: self.pfTherapistFileItem))]...")
                
                }
                else
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) Intermediate - bypassing the setting of 'self.pfTherapistFileItem' - 'tidType' of [\(tidType)] is NOT TIDType.therapist...")

                }

            }
            else
            {
            
                self.xcgLogMsg("\(sCurrMethodDisp) Intermediate - bypassing the setting of 'self.pfTherapistFileItem' - 'iTherapistTID' of (\(iTherapistTID)) is less than Zero...")

            }

        }

        if (sTherapistName.count < 1)
        {
        
            sTherapistName = "-N/A-"
        
        }

        // Exit...

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'sTherapistTID' is [\(sTherapistTID)] - 'sTherapistName' is [\(sTherapistName)]...")
  
        return sTherapistName
  
    }   // End of private func locateAppTherapistNamebyTid(sTherapistTID:String)->String.

    private func formatPhoneNumber(sPhoneNumber:String = "")->String
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'sPhoneNumber' is [\(sPhoneNumber)]...")

        // Format the supplied Phone #...

        var sPhoneNumberFormatted:String = ""
        
        if (sPhoneNumber.count < 1)
        {
            
            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'sPhoneNumber' is [\(sPhoneNumber)] - 'sPhoneNumberFormatted' is [\(sPhoneNumberFormatted)]...")

            return sPhoneNumberFormatted
            
        }
        
        let sPhoneNumberMask:String              = "(XXX) XXX-XXXX"
        let sPhoneNumberCleaned:String           = sPhoneNumber.components(separatedBy:CharacterSet.decimalDigits.inverted).joined()
        var siPhoneNumberStartIndex:String.Index = sPhoneNumberCleaned.startIndex
        let eiPhoneNumberEndIndex:String.Index   = sPhoneNumberCleaned.endIndex
        
        for chCurrentNumber in sPhoneNumberMask where siPhoneNumberStartIndex < eiPhoneNumberEndIndex
        {
            
            if chCurrentNumber == "X"
            {
                
                sPhoneNumberFormatted.append(sPhoneNumberCleaned[siPhoneNumberStartIndex])
                
                siPhoneNumberStartIndex = sPhoneNumberCleaned.index(after:siPhoneNumberStartIndex)
                
            }
            else
            {
                
                sPhoneNumberFormatted.append(chCurrentNumber)
                
            }
            
        }

        // Exit...

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'sPhoneNumber' is [\(sPhoneNumber)] - 'sPhoneNumberFormatted' is [\(sPhoneNumberFormatted)]...")
  
        return sPhoneNumberFormatted
        
    }   // End of private func formatPhoneNumber(sPhoneNumber:String)->String

    private func getFirstTidFromTids(sTherapistTIDs:String = "")->String
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'sTherapistTIDs' is [\(sTherapistTIDs)]...")

        // Extract the first TID (string) from a string of TID(s)... 

        var sTherapistTID:String = ""

        if (sTherapistTIDs.count > 0)
        {

            let bTherapistTIDSContainsComma:Bool = sTherapistTIDs.containsString(s:",")

            if (bTherapistTIDSContainsComma == false)
            {
            
                sTherapistTID = sTherapistTIDs
            
            }
            else
            {
            
            //  var listTherapistTIDs:[String]? = sTherapistTIDs.leftPartitionStrings(target:",") ?? nil
                let listTherapistTIDs:[String]? = sTherapistTIDs.leftPartitionStrings(target:",") ?? nil

                if (listTherapistTIDs        != nil &&
                    listTherapistTIDs!.count  > 0)
                {

                    sTherapistTID = listTherapistTIDs![0]

                }
            
            }
        
        }

        // Exit...

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'sTherapistTID' is [\(sTherapistTID)]...")
  
        return sTherapistTID
  
    }   // End of private func getFirstTidFromTids(sTherapistTIDs:String = "")->String.

    private func syncPFDataItems()
    {
  
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // 'sync' (aka, deep copy) the ParseCoreBkgdDataRepo PFCscDataItem(s) to the ParseCoreManager...

        self.xcgLogMsg("\(sCurrMethodDisp) Invoking 'jmAppParseCoreBkgdDataRepo' 'deepCopyDictPFAdminsDataItems()'...")

        let _ = self.jmAppParseCoreBkgdDataRepo.deepCopyDictPFAdminsDataItems()

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked  'jmAppParseCoreBkgdDataRepo' 'deepCopyDictPFAdminsDataItems()'...")

        self.xcgLogMsg("\(sCurrMethodDisp) Invoking 'jmAppParseCoreBkgdDataRepo' 'deepCopyDictTherapistTidXref()'...")

        let _ = self.jmAppParseCoreBkgdDataRepo.deepCopyDictTherapistTidXref()

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked  'jmAppParseCoreBkgdDataRepo' 'deepCopyDictTherapistTidXref()'...")

        self.xcgLogMsg("\(sCurrMethodDisp) Invoking 'jmAppParseCoreBkgdDataRepo' 'deepCopyDictPFTherapistFileItems()'...")

        let _ = self.jmAppParseCoreBkgdDataRepo.deepCopyDictPFTherapistFileItems()

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked  'jmAppParseCoreBkgdDataRepo' 'deepCopyDictPFTherapistFileItems()'...")

        self.xcgLogMsg("\(sCurrMethodDisp) Invoking 'jmAppParseCoreBkgdDataRepo' 'deepCopyDictPatientPidXref()'...")

        let _ = self.jmAppParseCoreBkgdDataRepo.deepCopyDictPatientPidXref()

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked  'jmAppParseCoreBkgdDataRepo' 'deepCopyDictPatientPidXref()'...")

        self.xcgLogMsg("\(sCurrMethodDisp) Invoking 'jmAppParseCoreBkgdDataRepo' 'deepCopyDictPFPatientFileItems()'...")

        let _ = self.jmAppParseCoreBkgdDataRepo.deepCopyDictPFPatientFileItems()

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked  'jmAppParseCoreBkgdDataRepo' 'deepCopyDictPFPatientFileItems()'...")

        self.xcgLogMsg("\(sCurrMethodDisp) Invoking 'jmAppParseCoreBkgdDataRepo' 'deepCopyDictSchedPatientLocItems()'...")

        let _ = self.jmAppParseCoreBkgdDataRepo.deepCopyDictSchedPatientLocItems()

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked  'jmAppParseCoreBkgdDataRepo' 'deepCopyDictSchedPatientLocItems()'...")

        self.xcgLogMsg("\(sCurrMethodDisp) Invoking 'jmAppParseCoreBkgdDataRepo' 'deepCopyListPFCscDataItems()'...")

        let _ = self.jmAppParseCoreBkgdDataRepo.deepCopyListPFCscDataItems()

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked  'jmAppParseCoreBkgdDataRepo' 'deepCopyListPFCscDataItems()'...")

        self.xcgLogMsg("\(sCurrMethodDisp) Invoking 'jmAppParseCoreBkgdDataRepo' 'deepCopyListPFCscNameItems()'...")

        let _ = self.jmAppParseCoreBkgdDataRepo.deepCopyListPFCscNameItems()

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked  'jmAppParseCoreBkgdDataRepo' 'deepCopyListPFCscNameItems()'...")

    //  self.xcgLogMsg("\(sCurrMethodDisp) Invoking 'self.detailPFCscDataItems()'...")
    //
    //  self.detailPFCscDataItems()
    //
    //  self.xcgLogMsg("\(sCurrMethodDisp) Invoked 'self.detailPFCscDataItems()'...")

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return
  
    }   // End of private func syncPFDataItems().

}   // End of struct AppVisitMgmtPatient1DetailsView(View).
