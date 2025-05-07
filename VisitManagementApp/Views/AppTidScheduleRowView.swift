//
//  AppTidScheduleRowView.swift
//  VisitManagementApp
//
//  Created by Daryl Cox on 02/14/2025.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
import SwiftUI
import MapKit

@available(iOS 14.0, *)
struct AppTidScheduleRowView: View 
{
    
    struct ClassInfo
    {
        
        static let sClsId        = "AppTidScheduleRowView"
        static let sClsVers      = "v1.0301"
        static let sClsDisp      = sClsId+".("+sClsVers+"): "
        static let sClsCopyRight = "Copyright © JustMacApps 2023-2025. All rights reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }

    // App Data field(s):

    @Environment(\.presentationMode)     var presentationMode
    @Environment(\.openURL)              var openURL

    // App Data field(s):

    @ObservedObject    var scheduledPatientLocationItem:ScheduledPatientLocationItem
    @State   private   var sPatientPID:String                          = ""

    @State   private   var isAppPatientDetailsByPidShowing:Bool        = false

                       var jmAppDelegateVisitor:JmAppDelegateVisitor   = JmAppDelegateVisitor.ClassSingleton.appDelegateVisitor
    
    init(scheduledPatientLocationItem:ScheduledPatientLocationItem)
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        // Handle inbound parameter(s) before any 'self.' references...
        
        _sPatientPID                      = State(wrappedValue:scheduledPatientLocationItem.sPid)
        self.scheduledPatientLocationItem = scheduledPatientLocationItem

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'scheduledPatientLocationItem' is [\(scheduledPatientLocationItem)]...")

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

        HStack(alignment:.center)
        {

            Button
            {
        
                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppTidScheduleRowView.Button(Xcode).'Patient Detail(s) by PID' for PID - 'scheduledPatientLocationItem.sPid' is [\(scheduledPatientLocationItem.sPid)]...")
        
                self.isAppPatientDetailsByPidShowing.toggle()
        
            }
            label:
            {
        
                VStack(alignment:.center)
                {
        
                    Label("", systemImage: "doc.questionmark")
                        .help(Text("Show Patient Detail(s) by PID..."))
                        .imageScale(.small)
        
                    Text("\(scheduledPatientLocationItem.sPid)")
                        .font(.caption2)
        
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
        #if os(iOS)
            .padding()
        #endif

            Text(scheduledPatientLocationItem.sPtName)
                .font(.caption)

            Text(scheduledPatientLocationItem.sVDate)
                .font(.caption)

            Text(scheduledPatientLocationItem.sVDateStartTime)
                .font(.caption)

        if (scheduledPatientLocationItem.sLastVDateAddress.count  < 1       ||
            scheduledPatientLocationItem.sLastVDateAddress       == ""      ||
            scheduledPatientLocationItem.sLastVDateAddress       == "-N/A-" ||
            scheduledPatientLocationItem.sLastVDateAddress       == ",,,"   ||
            scheduledPatientLocationItem.sLastVDateAddress       == ", , , ")
        {

            Text("\(scheduledPatientLocationItem.sLastVDateLatitude), \(scheduledPatientLocationItem.sLastVDateLongitude)")
                .font(.caption2)

        }
        else
        {

            Text(scheduledPatientLocationItem.sLastVDateAddress)
                .font(.caption2)

        }

        }

    }
    
}   // End of struct AppTidScheduleRowView(View).

