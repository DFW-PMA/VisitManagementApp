//
//  AppVisitMgmtSchedule1ExportView.swift
//  VisitManagementApp
//
//  Created by Daryl Cox on 04/10/2025.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

private struct SelectedReportValues:Identifiable
{

    var id:String
    {
        sTherapistTID
    }

    var sTherapistTID:String      
    var iTherapistTID:Int
                                
//  var bRunFullBigTest:Bool 

    var bSelectReportDates:Bool 
    var dateOfReportStart:Date  
    var dateOfReportEnd:Date    

    var sSelectedReportAlertTitle:String
    var sSelectedReportAlertMessage:String

}

struct AppVisitMgmtSchedule1ExportView:View 
{
    
    struct ClassInfo
    {
        
        static let sClsId        = "AppVisitMgmtSchedule1ExportView"
        static let sClsVers      = "v1.0601"
        static let sClsDisp      = sClsId+"(.swift).("+sClsVers+"):"
        static let sClsCopyRight = "Copyright (C) JustMacApps 2023-2025. All Rights Reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }
    
    // 'Internal' Trace flag:

    private 
    var bInternalTraceFlag:Bool                                                        = false

    // App Data field(s):

//  @Environment(\.dismiss)          var dismiss
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.openURL)          var openURL
    @Environment(\.openWindow)       var openWindow
    
    enum FocusedFields
    {
       case therapistTID
       case therapistName
    }

    @FocusState  private var focusedField:FocusedFields?
    
//  @Binding     private var sTherapistTID:String
    @State       private var sTherapistTID:String
    @State       private var sTherapistName:String                                     = ""

    @State       private var listSelectableTherapistNames:[AppSearchableTherapistName] = [AppSearchableTherapistName]()

//  @State       private var isAppRunTherapistLocateByTNameShowing:Bool                = false
    @State       private var isAppScheduleExportAlertShowing:Bool                      = false
    @State       private var isAppScheduleExportErrorShowing:Bool                      = false

    @State       private var sAppScheduleExportErrorReason:String                      = ""
  
    @State       private var bSelectReportDates:Bool                                   = false
    @State       private var dateOfReportStart:Date                                    = Calendar.current.date(byAdding:.day, value:-9, to:.now)!
    @State       private var dateOfReportEnd:Date                                      = Calendar.current.date(byAdding:.day, value: 0, to:.now)!

    @State       private var selectedReportValues:SelectedReportValues                 = SelectedReportValues(sTherapistTID:               "-1",
                                                                                                              iTherapistTID:               -1,
                                                                                                          //  bRunFullBigTest:             false,
                                                                                                              bSelectReportDates:          false,
                                                                                                              dateOfReportStart:           Date.now,
                                                                                                              dateOfReportEnd:             Date.now,
                                                                                                              sSelectedReportAlertTitle:   "This may take some time. Are you sure?",
                                                                                                              sSelectedReportAlertMessage: "-N/A-")

                         var jmAppDelegateVisitor:JmAppDelegateVisitor                 = JmAppDelegateVisitor.ClassSingleton.appDelegateVisitor
                         var jmAppParseCoreManager:JmAppParseCoreManager               = JmAppParseCoreManager.ClassSingleton.appParseCodeManager
                         var jmAppParseCoreBkgdDataRepo:JmAppParseCoreBkgdDataRepo     = JmAppParseCoreBkgdDataRepo.ClassSingleton.appParseCodeBkgdDataRepo
    
    init(sTherapistTID:String)
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        // Handle the 'sTherapistTID' parameter...

    //  _sTherapistTID = sTherapistTID
        _sTherapistTID = State(wrappedValue:sTherapistTID)

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'sTherapistTID' is [\(sTherapistTID)]...")

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
        let _ = xcgLogMsg("\(ClassInfo.sClsDisp):body(some View) <Diagnostic #1> - 'self.sTherapistTID' is [\(self.sTherapistTID)]...")

        NavigationStack
        {

            VStack
            {

                HStack(alignment:.center)
                {

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

                        let _ = xcgLogMsg("\(ClassInfo.sClsDisp):AppVisitMgmtSchedule1ExportView.Button(Xcode).'Dismiss' pressed...")

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

                    Text("VMA - Schedule Export by TID")
                        .bold()
                        .font(.caption2) 
                        .frame(maxWidth:.infinity, alignment:.center)
                        .alert("App \(self.sAppScheduleExportErrorReason)", isPresented:$isAppScheduleExportErrorShowing)
                        {
                            Button("Ok", role:.cancel) 
                            { 
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }

                    Text(" - - - - - - - - - - - - - - - - - - - - ")
                        .font(.caption2) 
                        .frame(maxWidth:.infinity, alignment:.center)

                }

                let _ = xcgLogMsg("\(ClassInfo.sClsDisp):body(some View) <Diagnostic #2> - 'self.sTherapistTID' is [\(self.sTherapistTID)]...")

                HStack
                {

                    Button
                    {

                        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtSchedule1ExportView in Button(Xcode).'Export the Schedule' for TID 'self.sTherapistTID' of [\(self.sTherapistTID)]...")

                        self.generateAppTidSchedulesExportSelectedDetails()

                        self.isAppScheduleExportAlertShowing.toggle()

                    }
                    label:
                    {

                        VStack(alignment:.center)
                        {

                            Label("", systemImage: "figure.run.circle")
                                .help(Text("Export the Schedule(s) for the Therapist(s)..."))
                                .imageScale(.large)

                            HStack(alignment:.center)
                            {

                                Spacer()

                                Text("=> Export the Schedule(s)...")
                                    .font(.caption)
                                    .foregroundColor(.red)

                                Spacer()

                            }

                        }

                    }
                    .alert(selectedReportValues.sSelectedReportAlertTitle,
                           isPresented:$isAppScheduleExportAlertShowing,
                           presenting: selectedReportValues)
                    { selected in

                        Button("Cancel", role:.cancel)
                        {
                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp) User pressed 'Cancel' to 'export' the TID Schedule(s) - resuming...")
                        }
                        Button("Ok")
                        {

                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp) User pressed 'Ok' to 'export' the TID Schedule(s) - running...")

                            let bExportOk:Bool = self.runAppTidSchedulesExport()

                            if (bExportOk == false)
                            {
                            
                                self.isAppScheduleExportErrorShowing.toggle()
                            
                            }
                            else
                            {
                            
                                self.presentationMode.wrappedValue.dismiss()
                            
                            }

                        }

                    }
                    message:
                    { selected in

                        Text(selected.sSelectedReportAlertMessage)

                    }
                    .padding()

                }

                HStack()
                {

                    Text("::: Therapist: TID #")
                        .font(.caption2) 

                    Text("\(self.sTherapistTID)")
                        .italic()
                        .font(.caption2) 
                        .foregroundColor(.red)

                    Spacer()

                    if (self.sTherapistTID.count  > 0 &&
                        self.sTherapistTID       != "-1")
                    {
                    
                        Button
                        {

                            let _ = xcgLogMsg("\(ClassInfo.sClsDisp):AppVisitMgmtSchedule1ExportView.Button(Xcode).'ALL Therapist(s)' pressed...")

                            self.sTherapistTID  = "-1"
                            self.sTherapistName = ""
                            focusedField        = nil
                        //  focusedField        = .therapistTID

                        }
                        label:
                        {

                            VStack(alignment:.center)
                            {

                                Label("", systemImage: "t.circle")
                                    .help(Text("Set ALL Therapist(s)..."))
                                    .imageScale(.small)

                                Text("ALL Therapists")
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
                        .padding()
                    
                    }

                }

                HStack()
                {

                    Text("::: Therapist: Name ")
                        .font(.caption2) 

                    Text("\(self.sTherapistName)")
                        .italic()
                        .font(.caption2) 
                        .foregroundColor(.red)

                    Spacer()

                }

                ScrollView
                {

                    VStack(alignment:.leading)
                    {

                        HStack()
                        {

                            Text("=> Current Report Date(s): ")
                                .foregroundColor(.red)
                                .italic()

                            Text("'Start' [\(generateAppTidSchedulesExportSelectedStartDate())]/'End' [\(generateAppTidSchedulesExportSelectedEndDate())]")

                        }
                        .font(.footnote)

                        HStack()
                        {

                            Text("=> Enable the 'selection' of Report 'Start'/'End' Date(s)? ")
                                .foregroundColor(.red)

                            Toggle("", isOn:$bSelectReportDates)

                        }
                        .font(.footnote)
                        .toggleStyle(SwitchToggleStyle())

                    if (bSelectReportDates)
                    {

                    //  Text("")
                        Text("=> Select the Report 'Start' Date: ")
                            .foregroundColor(.red)
                            .disabled(!bSelectReportDates)
                            .font(.footnote)

                        HStack(alignment:.center)
                        {

                            Spacer()

                            DatePicker("", selection:$dateOfReportStart, displayedComponents:[.date])
                                .datePickerStyle(.graphical)
                                .disabled(!bSelectReportDates)

                            Spacer()

                        }
                        .font(.footnote)

                    //  Text("")
                        Text("=> Select the Report 'End'   Date: ")
                            .foregroundColor(.red)
                            .disabled(!bSelectReportDates)
                            .font(.footnote)

                        HStack(alignment:.center)
                        {

                            Spacer()

                            DatePicker("", selection:$dateOfReportEnd, displayedComponents:[.date])
                                .datePickerStyle(.graphical)
                                .disabled(!bSelectReportDates)

                            Spacer()

                        }
                        .font(.footnote)

                    }

                        HStack()
                        {

                            VStack(alignment:.leading)
                            {

                                Text("=> Enter the Therapists' TID: ")
                                    .foregroundColor(.red)

                                Text("     (-1 for All)")
                                    .bold()
                                    .italic()
                                    .foregroundColor(.blue)
                                    .font(.footnote)

                            }

                            TextField("TherapistTID...", text:$sTherapistTID)
                            #if os(iOS)
                                .keyboardType(.numberPad)
                            #endif
                                .onReceive(Just(sTherapistTID))
                                { newValue in
                                    let filteredValue = newValue.filter { "-0123456789".contains($0) }
                                    if (filteredValue != newValue)
                                    {
                                        self.sTherapistTID = filteredValue
                                    }
                                }
                                .focused($focusedField, equals:.therapistTID)
                                .onAppear
                                {
                                    let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).AppVisitMgmtSchedule1ExportView.TextField #1 - Received an .onAppear() #1...")

                                //  focusedField = .therapistTID
                                    focusedField = nil
                                }

                            Spacer()

                            Button
                            {

                                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtSchedule1ExportView.Button(Xcode).'Therapist TID delete'...")

                                self.sTherapistTID  = ""
                                self.sTherapistName = ""
                                focusedField        = .therapistTID

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
                        .font(.footnote)

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
                                    focusedField        = nil
                                //  focusedField        = .therapistName
                                }
                                .onChange(of: self.sTherapistName)
                                {
                                    let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onChange #2 - 'self.sTherapistTID' is [\(self.sTherapistTID)] - 'self.sTherapistName' is [\(self.sTherapistName)]...")

                                    self.updateSelectableTherapistNamesList(sSearchValue:self.sTherapistName)

                                    if (self.sTherapistName.count < 1)
                                    {
                                        self.sTherapistName = ""

                                        if (self.sTherapistTID != "-1")
                                        {
                                            self.sTherapistTID  = ""
                                        }
                                    }

                                    focusedField        = .therapistName
                                }
                                .onSubmit
                                {
                                    let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onSubmit #2 - 'self.sTherapistName' is [\(self.sTherapistName)] - locating the 'sTherapistTID' field...")

                                    self.sTherapistTID  = self.locateAppTherapistTIDByTName(sTherapistName:self.sTherapistName)
                                    focusedField        = nil
                                //  focusedField        = .therapistName
                                }

                            Spacer()

                            Button
                            {

                                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtTherapist3View.Button(Xcode).'Locate the Therapist by TID or tName'...")

                                if (self.sTherapistTID.count > 0)
                                {
                                    self.sTherapistName = self.locateAppTherapistNamebyTid(sTherapistTID:sTherapistTID)
                                }
                                else
                                {
                                    if (self.sTherapistName.count > 0)
                                    {
                                        self.sTherapistTID = self.locateAppTherapistTIDByTName(sTherapistName:self.sTherapistName)
                                    }
                                }

                            //  self.isAppRunTherapistLocateByTNameShowing.toggle()

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

                            //  self.appScheduleLoadingAssistant.clearScheduledPatientLocationItems()

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

                            Text("\(appSearchableTherapistName.sTherapistTName) - \(appSearchableTherapistName.sTherapistTID)")
                                .onTapGesture
                                {
                                    self.sTherapistName = appSearchableTherapistName.sTherapistTName
                                    self.sTherapistTID  = self.locateAppTherapistTIDByTName(sTherapistName:self.sTherapistName)
                                    focusedField        = nil
                                //  focusedField        = .therapistName
                                }

                        }
                        .scaledToFill()
                        .font(.caption) 
                    //  .frame(maxHeight:250)

                    }

                }

        //  }
        //  else
        //  {
        //
        //      let _ = xcgLogMsg("\(ClassInfo.sClsDisp):body(some View) <Diagnostic #3> - 'self.sTherapistTID' is [\(self.sTherapistTID)]...")
        //
        //      Divider() 
        //
        //      HStack()
        //      {
        //
        //          Spacer()
        //
        //          Text("<<< NO Data >>> ")
        //              .bold()
        //              .underline()
        //          Text("Therapist TID #(\(self.sTherapistTID))")
        //              .italic()
        //
        //          Spacer()
        //
        //      }
        //      .font(.footnote)
        //
        //      Divider() 
        //
        //  }

            }

            Spacer()

            Text("")            
                .hidden()
                .onAppear(
                    perform:
                    {
                        // Continue App 'initialization'...

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
  
    //  // Get some 'internal' Dev Detail(s)...
    //
    //  bIsObjcAppRunningOniPad         = self.checkIfAppIsRunningOniPad()
    //  bIsObjcAppRunningAsDev          = self.checkIfAppIsRunningAsDev()
    //  bIsObjcAppRunningAsAdmin        = self.checkIfAppIsRunningAsAdmin()
    //  bObjcAppHasSuccessfullyLoggedIn = self.checkIfAppHasSuccessfullyLoggedIn()

        // Set the initial Report 'start'/'end' Date(s)...

        var tiPrevSaturday:TimeInterval = 0.0
        var tiNextSaturday:TimeInterval = 0.0

        let _ = Calendar.current.nextWeekend(startingAfter:.now,
                                             start:        &dateOfReportStart,
                                             interval:     &tiPrevSaturday,
                                             direction:    .backward)

        let _ = Calendar.current.nextWeekend(startingAfter:.now,
                                             start:        &dateOfReportEnd,
                                             interval:     &tiNextSaturday,
                                             direction:    .forward)

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return

    } // End of private func finishAppInitialization().

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

    func generateAppTidSchedulesExportSelectedDetails()
    {
  
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
  
        // Trace the 'input' Data field value(s)...

        self.xcgLogMsg("\(sCurrMethodDisp) 'sTherapistTID'             is [\(String(describing: self.sTherapistTID))]...")
    //  self.xcgLogMsg("\(sCurrMethodDisp) 'bRunFullBigTest'           is [\(String(describing: self.bRunFullBigTest))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'bSelectReportDates'        is [\(String(describing: self.bSelectReportDates))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'dateOfReportStart' <entry> is [\(String(describing: self.dateOfReportStart))] <raw>...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'dateOfReportEnd'   <entry> is [\(String(describing: self.dateOfReportEnd))] <raw>...")

        // Generate the 'using' Report 'detail(s)' field(s)...

        let iTherapistTID:Int = Int(self.sTherapistTID) ?? -1

        self.xcgLogMsg("\(sCurrMethodDisp) 'iTherapistTID'             is (\(String(describing: iTherapistTID)))...")

        var dateOfCurrentReportStart:Date = Date.now
        var dateOfCurrentReportEnd:Date   = Date.now

        if (self.bSelectReportDates == false)
        {

            // Set the initial Report 'start'/'end' Date(s)...

            var tiPrevSaturday:TimeInterval = 0.0
            var tiNextSaturday:TimeInterval = 0.0

            let _ = Calendar.current.nextWeekend(startingAfter:.now,
                                                 start:        &dateOfCurrentReportStart,
                                                 interval:     &tiPrevSaturday,
                                                 direction:    .backward)

            let _ = Calendar.current.nextWeekend(startingAfter:.now,
                                                 start:        &dateOfCurrentReportEnd,
                                                 interval:     &tiNextSaturday,
                                                 direction:    .forward)

        }
        else
        {

            dateOfCurrentReportStart = self.dateOfReportStart
            dateOfCurrentReportEnd   = self.dateOfReportEnd

        }

        let dtFormatterDate:DateFormatter = DateFormatter()

        dtFormatterDate.locale     = Locale(identifier: "en_US")
        dtFormatterDate.timeZone   = TimeZone.current
    //  dtFormatterDate.dateFormat = "MM/dd/yy"
        dtFormatterDate.dateFormat = "yyyy-MM-dd"
        
        let sCurrentReportDateStart:String = dtFormatterDate.string(from: dateOfCurrentReportStart)
        let sCurrentReportDateEnd:String   = dtFormatterDate.string(from: dateOfCurrentReportEnd)

        self.xcgLogMsg("\(sCurrMethodDisp) 'sCurrentReportDateStart'   is [\(String(describing: sCurrentReportDateStart))] <formatted>...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sCurrentReportDateEnd'     is [\(String(describing: sCurrentReportDateEnd))] <formatted>...")

        var sCurrentReportDetails:String  = "-N/A-"

        if (self.bSelectReportDates == false)
        {

            sCurrentReportDetails = "Export: Schedule(s) for TherapistTID (\(iTherapistTID)) using 'default' Date(s) from [\(sCurrentReportDateStart)] to [\(sCurrentReportDateEnd)]."

        }
        else
        {

            sCurrentReportDetails = "Export: Schedule(s) for TherapistTID (\(iTherapistTID)) using 'selected' Date(s) from [\(sCurrentReportDateStart)] to [\(sCurrentReportDateEnd)]."

        }

        self.xcgLogMsg("\(sCurrMethodDisp) Generating a Report with a 'selected' Detail(s) message of [\(sCurrentReportDetails)]...")

        // Generate the 'selected' Report Detail(s) object...

        self.selectedReportValues = SelectedReportValues(sTherapistTID:               self.sTherapistTID,
                                                         iTherapistTID:               iTherapistTID,
                                                     //  bRunFullBigTest:             self.bRunFullBigTest,
                                                         bSelectReportDates:          self.bSelectReportDates,
                                                         dateOfReportStart:           dateOfCurrentReportStart,
                                                         dateOfReportEnd:             dateOfCurrentReportEnd,
                                                         sSelectedReportAlertTitle:   "This may take some time. Are you sure?",
                                                         sSelectedReportAlertMessage: sCurrentReportDetails)

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return
  
    }   // End of generateAppTidSchedulesExportSelectedDetails().

    func runAppTidSchedulesExport()->Bool
    {
  
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
  
        // Trace the 'selected' Report Data field value(s)...

        self.xcgLogMsg("\(sCurrMethodDisp) 'selectedReportValues.sTherapistTID'      is [\(String(describing: selectedReportValues.sTherapistTID))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'selectedReportValues.iTherapistTID'      is (\(String(describing: selectedReportValues.iTherapistTID)))...")
    //  self.xcgLogMsg("\(sCurrMethodDisp) 'selectedReportValues.bRunFullBigTest'    is [\(String(describing: selectedReportValues.bRunFullBigTest))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'selectedReportValues.bSelectReportDates' is [\(String(describing: selectedReportValues.bSelectReportDates))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'selectedReportValues.dateOfReportStart'  is [\(String(describing: selectedReportValues.dateOfReportStart))] <raw>...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'selectedReportValues.dateOfReportEnd'    is [\(String(describing: selectedReportValues.dateOfReportEnd))] <raw>...")

        let dtFormatterDate:DateFormatter = DateFormatter()

        dtFormatterDate.locale     = Locale(identifier: "en_US")
        dtFormatterDate.timeZone   = TimeZone.current
    //  dtFormatterDate.dateFormat = "MM/dd/yy"
        dtFormatterDate.dateFormat = "yyyy-MM-dd"
    //  dtFormatterDate.dateFormat = "YYYY-MM-DD"
    //  dtFormatterDate.dateFormat = "MMMM dd, yyyy"
        
        let sCurrentDateStart:String = dtFormatterDate.string(from: selectedReportValues.dateOfReportStart)
        let sCurrentDateEnd:String   = dtFormatterDate.string(from: selectedReportValues.dateOfReportEnd)

        self.xcgLogMsg("\(sCurrMethodDisp) <calculated> 'sCurrentDateStart'          is [\(String(describing: sCurrentDateStart))] <formatted>...")
        self.xcgLogMsg("\(sCurrMethodDisp) <calculated> 'sCurrentDateEnd'            is [\(String(describing: sCurrentDateEnd))] <formatted>...")

        // Execute the 'export' of TID Schedule(s)...

        self.xcgLogMsg("\(sCurrMethodDisp) Calling 'self.jmAppParseCoreBkgdDataRepo.gatherJmAppPFQueriesForScheduledLocationsForExport(bForceReloadOfPFQuery:true, iTherapistTID:(\(Int32(selectedReportValues.iTherapistTID))), sExportSchedulesStartWeek:[\(sCurrentDateStart)], sExportSchedulesEndWeek:[\(sCurrentDateEnd)]'...")
      
        let bDataCreationOk:Bool = self.jmAppParseCoreBkgdDataRepo.gatherJmAppPFQueriesForScheduledLocationsForExport(bForceReloadOfPFQuery:true, iTherapistTID:selectedReportValues.iTherapistTID, sExportSchedulesStartWeek:sCurrentDateStart, sExportSchedulesEndWeek:sCurrentDateEnd)
      
        self.xcgLogMsg("\(sCurrMethodDisp) Called  'self.jmAppParseCoreBkgdDataRepo.gatherJmAppPFQueriesForScheduledLocationsForExport(bForceReloadOfPFQuery:true, iTherapistTID:(\(Int32(selectedReportValues.iTherapistTID))), sExportSchedulesStartWeek:[\(sCurrentDateStart)], sExportSchedulesEndWeek:[\(sCurrentDateEnd)]'...")
      
        if (bDataCreationOk == false)
        {
      
            self.sAppScheduleExportErrorReason = "'export' Data creation failed - Error!"
        
            // Exit...
      
            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - \(self.sAppScheduleExportErrorReason)")
      
            return false
        
        }

        self.xcgLogMsg("\(sCurrMethodDisp) Calling 'self.jmAppParseCoreBkgdDataRepo.exportJmAppPFQueriesForScheduledLocations()'...")

        let bDataConversionAndUploadOk:Bool = self.jmAppParseCoreBkgdDataRepo.exportJmAppPFQueriesForScheduledLocations()

        self.xcgLogMsg("\(sCurrMethodDisp) Called  'self.jmAppParseCoreBkgdDataRepo.exportJmAppPFQueriesForScheduledLocations()'...")

        if (bDataConversionAndUploadOk == false)
        {

            self.sAppScheduleExportErrorReason = "'export' Data conversion and upload failed - Error!"
        
            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - \(self.sAppScheduleExportErrorReason)")

            return false
        
        }

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return true
  
    }   // End of runAppTidSchedulesExport()->Bool.

    func generateAppTidSchedulesExportSelectedStartDate()->String
    {
  
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
  
        // Trace the 'input' Data field value(s)...

        self.xcgLogMsg("\(sCurrMethodDisp) 'sTherapistTID'             is [\(String(describing: self.sTherapistTID))]...")

        let iTherapistTID:Int = Int(self.sTherapistTID) ?? -1

        self.xcgLogMsg("\(sCurrMethodDisp) 'iTherapistTID'             is (\(String(describing: iTherapistTID)))...")
    //  self.xcgLogMsg("\(sCurrMethodDisp) 'bRunFullBigTest'           is [\(String(describing: self.bRunFullBigTest))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'bSelectReportDates'        is [\(String(describing: self.bSelectReportDates))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'dateOfReportStart' <entry> is [\(String(describing: self.dateOfReportStart))] <raw>...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'dateOfReportEnd'   <entry> is [\(String(describing: self.dateOfReportEnd))] <raw>...")

        // Generate the 'using' Report 'detail(s)' field(s)...

        var dateOfCurrentReportStart:Date = Date.now
        var dateOfCurrentReportEnd:Date   = Date.now

        if (self.bSelectReportDates == false)
        {

            // Set the initial Report 'start'/'end' Date(s)...

            var tiPrevSaturday:TimeInterval = 0.0
            var tiNextSaturday:TimeInterval = 0.0

            let _ = Calendar.current.nextWeekend(startingAfter:.now,
                                                 start:        &dateOfCurrentReportStart,
                                                 interval:     &tiPrevSaturday,
                                                 direction:    .backward)

            let _ = Calendar.current.nextWeekend(startingAfter:.now,
                                                 start:        &dateOfCurrentReportEnd,
                                                 interval:     &tiNextSaturday,
                                                 direction:    .forward)

        }
        else
        {

            dateOfCurrentReportStart = self.dateOfReportStart
            dateOfCurrentReportEnd   = self.dateOfReportEnd

        }

        let dtFormatterDate:DateFormatter = DateFormatter()

        dtFormatterDate.locale     = Locale(identifier: "en_US")
        dtFormatterDate.timeZone   = TimeZone.current
        dtFormatterDate.dateFormat = "yyyy-MM-dd"
        
        let sCurrentReportDateStart:String = dtFormatterDate.string(from: dateOfCurrentReportStart)
        let sCurrentReportDateEnd:String   = dtFormatterDate.string(from: dateOfCurrentReportEnd)

        self.xcgLogMsg("\(sCurrMethodDisp) 'sCurrentReportDateStart'   is [\(String(describing: sCurrentReportDateStart))] <formatted>...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sCurrentReportDateEnd'     is [\(String(describing: sCurrentReportDateEnd))] <formatted>...")

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'sCurrentReportDateStart' is [\(sCurrentReportDateStart)]...")
  
        return sCurrentReportDateStart
  
    }   // End of generateAppTidSchedulesExportSelectedStartDate().

    func generateAppTidSchedulesExportSelectedEndDate()->String
    {
  
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
  
        // Trace the 'input' Data field value(s)...

        self.xcgLogMsg("\(sCurrMethodDisp) 'sTherapistTID'             is [\(String(describing: self.sTherapistTID))]...")

        let iTherapistTID:Int = Int(self.sTherapistTID) ?? -1

        self.xcgLogMsg("\(sCurrMethodDisp) 'iTherapistTID'             is (\(String(describing: iTherapistTID)))...")
    //  self.xcgLogMsg("\(sCurrMethodDisp) 'bRunFullBigTest'           is [\(String(describing: self.bRunFullBigTest))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'bSelectReportDates'        is [\(String(describing: self.bSelectReportDates))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'dateOfReportStart' <entry> is [\(String(describing: self.dateOfReportStart))] <raw>...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'dateOfReportEnd'   <entry> is [\(String(describing: self.dateOfReportEnd))] <raw>...")

        // Generate the 'using' Report 'detail(s)' field(s)...

        var dateOfCurrentReportStart:Date = Date.now
        var dateOfCurrentReportEnd:Date   = Date.now

        if (self.bSelectReportDates == false)
        {

            // Set the initial Report 'start'/'end' Date(s)...

            var tiPrevSaturday:TimeInterval = 0.0
            var tiNextSaturday:TimeInterval = 0.0

            let _ = Calendar.current.nextWeekend(startingAfter:.now,
                                                 start:        &dateOfCurrentReportStart,
                                                 interval:     &tiPrevSaturday,
                                                 direction:    .backward)

            let _ = Calendar.current.nextWeekend(startingAfter:.now,
                                                 start:        &dateOfCurrentReportEnd,
                                                 interval:     &tiNextSaturday,
                                                 direction:    .forward)

        }
        else
        {

            dateOfCurrentReportStart = self.dateOfReportStart
            dateOfCurrentReportEnd   = self.dateOfReportEnd

        }

        let dtFormatterDate:DateFormatter = DateFormatter()

        dtFormatterDate.locale     = Locale(identifier: "en_US")
        dtFormatterDate.timeZone   = TimeZone.current
        dtFormatterDate.dateFormat = "yyyy-MM-dd"
        
        let sCurrentReportDateStart:String = dtFormatterDate.string(from: dateOfCurrentReportStart)
        let sCurrentReportDateEnd:String   = dtFormatterDate.string(from: dateOfCurrentReportEnd)

        self.xcgLogMsg("\(sCurrMethodDisp) 'sCurrentReportDateStart'   is [\(String(describing: sCurrentReportDateStart))] <formatted>...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sCurrentReportDateEnd'     is [\(String(describing: sCurrentReportDateEnd))] <formatted>...")

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'sCurrentReportDateEnd' is [\(sCurrentReportDateEnd)]...")
  
        return sCurrentReportDateEnd
  
    }   // End of generateAppTidSchedulesExportSelectedEndDate().

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

}   // End of struct AppVisitMgmtSchedule1ExportView:View.

