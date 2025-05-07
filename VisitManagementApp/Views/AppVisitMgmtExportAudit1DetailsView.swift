//
//  AppVisitMgmtExportAudit1DetailsView.swift
//  VisitManagementApp
//
//  Created by Daryl Cox on 03/27/2025.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct AppVisitMgmtExportAudit1DetailsView: View 
{
    
    struct ClassInfo
    {
        
        static let sClsId        = "AppVisitMgmtExportAudit1DetailsView"
        static let sClsVers      = "v1.0109"
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

    @State       private var dictAuditExportSchedPatientLocItemsMetrics:[String:String] = [String:String]()

                         var jmAppDelegateVisitor:JmAppDelegateVisitor                  = JmAppDelegateVisitor.ClassSingleton.appDelegateVisitor
                         var jmAppParseCoreManager:JmAppParseCoreManager                = JmAppParseCoreManager.ClassSingleton.appParseCodeManager
                         var jmAppParseCoreBkgdDataRepo:JmAppParseCoreBkgdDataRepo      = JmAppParseCoreBkgdDataRepo.ClassSingleton.appParseCodeBkgdDataRepo
    
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

        //  VStack
            VStack(alignment:.center)
            {

                HStack(alignment:.center)
                {

                    Spacer()

                    Button
                    {

                        let _ = xcgLogMsg("\(ClassInfo.sClsDisp):AppVisitMgmtExportAudit1DetailsView.Button(Xcode).'Dismiss' pressed...")

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

                    Text("DATA Gatherer - 'Audit' Export Schedule")
                        .bold()
                        .font(.caption2) 
                        .frame(maxWidth:.infinity, alignment:.center)

                    Text(" - - - - - - - - - - - - - - - - - - - - ")
                        .font(.caption2) 
                        .frame(maxWidth:.infinity, alignment:.center)

                }

            if (self.dictAuditExportSchedPatientLocItemsMetrics.count > 0)
            {

                let _ = xcgLogMsg("\(ClassInfo.sClsDisp):body(some View) <Diagnostic #1>...")

                ScrollView(.vertical)
                {

                    Grid(alignment:.leadingFirstTextBaseline, horizontalSpacing:10, verticalSpacing:5)
                    {

                        // Column Headings:

                        Divider() 
                            .gridCellUnsizedAxes(.horizontal)

                        GridRow 
                        {

                            Text("Metric")
                                .bold()
                                .underline()
                            Text("Value")
                                .bold()
                                .underline()

                        }
                        .font(.caption) 

                        Divider() 
                            .gridCellUnsizedAxes(.horizontal)

                        // Item Rows:

                        GridRow(alignment:.bottom)
                        {

                            Text("TotalTIDs   ")
                            Text("\(String(describing:(self.dictAuditExportSchedPatientLocItemsMetrics["TotalTIDs"])!.stripOptionalStringWrapper()))")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("TotalTIDsCounted   ")
                            Text("\(String(describing:(self.dictAuditExportSchedPatientLocItemsMetrics["TotalTIDsCounted"])!.stripOptionalStringWrapper()))")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("TotalPatientVisits   ")
                            Text("\(String(describing:(self.dictAuditExportSchedPatientLocItemsMetrics["TotalPatientVisits"])!.stripOptionalStringWrapper()))")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("TotalUniqueTIDs   ")
                            Text("\(String(describing:(self.dictAuditExportSchedPatientLocItemsMetrics["TotalUniqueTIDs"])!.stripOptionalStringWrapper()))")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("TotalUniquePIDs   ")
                            Text("\(String(describing:(self.dictAuditExportSchedPatientLocItemsMetrics["TotalUniquePIDs"])!.stripOptionalStringWrapper()))")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text(" - - - - - ")
                            Text(" ")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("TotalNoLastVDate   ")
                            Text("\(String(describing:(self.dictAuditExportSchedPatientLocItemsMetrics["TotalNoLastVDate"])!.stripOptionalStringWrapper()))")
                                .foregroundStyle((self.dictAuditExportSchedPatientLocItemsMetrics["TotalNoLastVDate"]! == "0") ? .green : .red)

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("TotalNoLastVDateLatitude   ")
                            Text("\(String(describing:(self.dictAuditExportSchedPatientLocItemsMetrics["TotalNoLastVDateLatitude"])!.stripOptionalStringWrapper()))")
                                .foregroundStyle((self.dictAuditExportSchedPatientLocItemsMetrics["TotalNoLastVDateLatitude"]! == "0") ? .green : .red)

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("TotalNoLastVDateLongitude   ")
                            Text("\(String(describing:(self.dictAuditExportSchedPatientLocItemsMetrics["TotalNoLastVDateLongitude"])!.stripOptionalStringWrapper()))")
                                .foregroundStyle((self.dictAuditExportSchedPatientLocItemsMetrics["TotalNoLastVDateLongitude"]! == "0") ? .green : .red)

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("TotalNoLastVDateAddress   ")
                            Text("\(String(describing:(self.dictAuditExportSchedPatientLocItemsMetrics["TotalNoLastVDateAddress"])!.stripOptionalStringWrapper()))")
                                .foregroundStyle((self.dictAuditExportSchedPatientLocItemsMetrics["TotalNoLastVDateAddress"]! == "0") ? .green : .red)

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text(" - - - - - ")
                            Text(" ")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("ScheduleType.PastDate   ")
                            Text("\(String(describing:(self.dictAuditExportSchedPatientLocItemsMetrics["ScheduleType.PastDate"])!.stripOptionalStringWrapper()))")
                                .foregroundStyle((self.dictAuditExportSchedPatientLocItemsMetrics["ScheduleType.PastDate"]! == "0") ? .green : .red)

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("ScheduleType.Scheduled   ")
                            Text("\(String(describing:(self.dictAuditExportSchedPatientLocItemsMetrics["ScheduleType.Scheduled"])!.stripOptionalStringWrapper()))")
                                .foregroundStyle((self.dictAuditExportSchedPatientLocItemsMetrics["ScheduleType.Scheduled"]! != "0") ? .orange : .red)

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("ScheduleType.Done   ")
                            Text("\(String(describing:(self.dictAuditExportSchedPatientLocItemsMetrics["ScheduleType.Done"])!.stripOptionalStringWrapper()))")
                                .foregroundStyle((self.dictAuditExportSchedPatientLocItemsMetrics["ScheduleType.Done"]! != "0") ? .green : .red)

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("ScheduleType.Missed   ")
                            Text("\(String(describing:(self.dictAuditExportSchedPatientLocItemsMetrics["ScheduleType.Missed"])!.stripOptionalStringWrapper()))")
                                .foregroundStyle((self.dictAuditExportSchedPatientLocItemsMetrics["ScheduleType.Missed"]! == "0") ? .green : .red)

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("ScheduleType.DateError   ")
                            Text("\(String(describing:(self.dictAuditExportSchedPatientLocItemsMetrics["ScheduleType.DateError"])!.stripOptionalStringWrapper()))")
                                .foregroundStyle((self.dictAuditExportSchedPatientLocItemsMetrics["ScheduleType.DateError"]! == "0") ? .green : .red)

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("ScheduleType.Undefined   ")
                            Text("\(String(describing:(self.dictAuditExportSchedPatientLocItemsMetrics["ScheduleType.Undefined"])!.stripOptionalStringWrapper()))")
                                .foregroundStyle((self.dictAuditExportSchedPatientLocItemsMetrics["ScheduleType.Undefined"]! == "0") ? .green : .red)

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text(" - - - - - ")
                            Text(" ")

                        }
                        .font(.caption2) 

                        Divider() 
                            .gridCellUnsizedAxes(.horizontal)

                    }
                    .frame(maxWidth:.infinity)

                }

            }
            else
            {

                let _ = xcgLogMsg("\(ClassInfo.sClsDisp):body(some View) <Diagnostic #2>...")

                Divider() 
                    .gridCellUnsizedAxes(.horizontal)

                // Item Rows:

                GridRow(alignment:.bottom)
                {

                    Text("<<< NO Data >>>")
                        .bold()
                        .foregroundStyle(.red)

                }
                .font(.caption2) 

                Divider() 
                    .gridCellUnsizedAxes(.horizontal)

            }

                Spacer()

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
  
        // Finish the App 'initialization'...

        self.xcgLogMsg("\(sCurrMethodDisp) Calling 'self.self.auditExportScheduledPatientLocationItems()'...")

        self.auditExportScheduledPatientLocationItems()

        self.xcgLogMsg("\(sCurrMethodDisp) Called  'self.self.auditExportScheduledPatientLocationItems()'...")

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return

    } // End of private func finishAppInitialization().

    private func auditExportScheduledPatientLocationItems()
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Audit the Scheduled Patient Location item(s)...

        self.xcgLogMsg("\(sCurrMethodDisp) Calling 'self.jmAppParseCoreBkgdDataRepo.auditExportSchedPatientLocItems(bForceApplyOfficeLatLongAddr:false)'...")

        self.dictAuditExportSchedPatientLocItemsMetrics = 
            self.jmAppParseCoreBkgdDataRepo.auditExportSchedPatientLocItems(bForceApplyOfficeLatLongAddr:false)

        self.xcgLogMsg("\(sCurrMethodDisp) Called  'self.jmAppParseCoreBkgdDataRepo.auditExportSchedPatientLocItems(bForceApplyOfficeLatLongAddr:false)'...")

        // Exit...

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of private func auditExportScheduledPatientLocationItems().
    
}   // End of struct AppVisitMgmtExportAudit1DetailsView(View).

