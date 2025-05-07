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

struct AppVisitMgmtSchedule1ExportView: View 
{
    
    struct ClassInfo
    {
        
        static let sClsId        = "AppVisitMgmtSchedule1ExportView"
        static let sClsVers      = "v1.0401"
        static let sClsDisp      = sClsId+"(.swift).("+sClsVers+"):"
        static let sClsCopyRight = "Copyright (C) JustMacApps 2023-2025. All Rights Reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }
    
    // App Data field(s):

//  @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.openURL)          var openURL
    @Environment(\.openWindow)       var openWindow
    
    enum FocusedFields
    {
       case TherapistTID
    }

    @FocusState  private var focusedField:FocusedFields?
    
//  @Binding     private var sTherapistTID:String
    @State       private var sTherapistTID:String

    @State       private var isAppScheduleExportAlertShowing:Bool                  = false
    @State       private var isAppScheduleExportErrorShowing:Bool                  = false

    @State       private var sAppScheduleExportErrorReason:String                  = ""
  
    @State       private var bSelectReportDates:Bool                               = false
    @State       private var dateOfReportStart:Date                                = Calendar.current.date(byAdding:.day, value:-9, to:.now)!
    @State       private var dateOfReportEnd:Date                                  = Calendar.current.date(byAdding:.day, value: 0, to:.now)!

    @State       private var selectedReportValues:SelectedReportValues             = SelectedReportValues(sTherapistTID:               "-1",
                                                                                                          iTherapistTID:               -1,
                                                                                                      //  bRunFullBigTest:             false,
                                                                                                          bSelectReportDates:          false,
                                                                                                          dateOfReportStart:           Date.now,
                                                                                                          dateOfReportEnd:             Date.now,
                                                                                                          sSelectedReportAlertTitle:   "This may take some time. Are you sure?",
                                                                                                          sSelectedReportAlertMessage: "-N/A-")

                         var jmAppDelegateVisitor:JmAppDelegateVisitor             = JmAppDelegateVisitor.ClassSingleton.appDelegateVisitor
                         var jmAppParseCoreManager:JmAppParseCoreManager           = JmAppParseCoreManager.ClassSingleton.appParseCodeManager
                         var jmAppParseCoreBkgdDataRepo:JmAppParseCoreBkgdDataRepo = JmAppParseCoreBkgdDataRepo.ClassSingleton.appParseCodeBkgdDataRepo
    
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

                    Text("DATA Gatherer - Schedule Export by TID")
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

                HStack()
                {

                    Text("::: Therapist: TID #")
                        .font(.caption) 

                    Text("\(self.sTherapistTID)")
                        .italic()
                        .font(.caption) 
                        .foregroundColor(.red)

                    Spacer()

                    if (self.sTherapistTID.count  > 0 &&
                        self.sTherapistTID       != "-1")
                    {
                    
                        Button
                        {

                            let _ = xcgLogMsg("\(ClassInfo.sClsDisp):AppVisitMgmtSchedule1ExportView.Button(Xcode).'ALL Therapist(s)' pressed...")

                            self.sTherapistTID = "-1"

                        }
                        label:
                        {

                            VStack(alignment:.center)
                            {

                                Label("", systemImage: "t.circle")
                                    .help(Text("Select ALL Therapist(s)..."))
                                    .imageScale(.medium)

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

        //  if (self.sTherapistTID.count > 0)
        //  {

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

            //  Spacer()

                ScrollView
                {

                //  Spacer()

                    VStack(alignment:.leading)
                    {

                    //  Text(" - - - - - - - - - - - - - - - - - - - - ")
                    //      .frame(maxWidth:.infinity, alignment:.center)
                    //
                    //  Text("Therapist 'Schedule' Export:")
                    //      .bold()
                    //      .frame(maxWidth:.infinity, alignment:.center)
                    //
                    //  Text(" - - - - - - - - - - - - - - - - - - - - ")
                    //      .frame(maxWidth:.infinity, alignment:.center)

                    //  Spacer()

                    //  HStack()
                    //  {
                    //
                    //      VStack(alignment:.leading)
                    //      {
                    //
                    //          Text("=> Run ALL the BigTest Step(s)? ")
                    //              .foregroundColor(.red)
                    //
                    //          if (bRunFullBigTest)
                    //          {
                    //
                    //              Text("     (BigTest, Supervision, and Facilitated)")
                    //                  .bold()
                    //                  .italic()
                    //                  .foregroundColor(.blue)
                    //                  .font(.footnote)
                    //
                    //          }
                    //          else
                    //          {
                    //
                    //              Text("     (BigTest ONLY...)")
                    //                  .bold()
                    //                  .italic()
                    //                  .foregroundColor(.blue)
                    //                  .font(.footnote)
                    //
                    //          }
                    //
                    //      }
                    //
                    //      Toggle("", isOn:$bRunFullBigTest)
                    //
                    //  }
                    //  .toggleStyle(SwitchToggleStyle())

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
                                .focused($focusedField, equals:.TherapistTID)
                                .onAppear
                                {
                                    let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).AppVisitMgmtSchedule1ExportView.TextField #1 - Received an .onAppear() #1...")

                                //  focusedField = .TherapistTID
                                    focusedField = nil
                                }

                            Spacer()

                            Button
                            {

                                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtSchedule1ExportView.Button(Xcode).'Therapist TID delete'...")

                                self.sTherapistTID = ""
                                focusedField       = .TherapistTID

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

                        Text("")
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

                        Text("")
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

}   // End of struct AppVisitMgmtSchedule1ExportView(View).

