//
//  AppSchedPatLocMapView.swift
//  VisitManagementApp
//
//  Created by Daryl Cox on 02/18/2025.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import SwiftUI
import MapKit

struct AppSchedPatLocMapView: View 
{
    
    struct ClassInfo
    {
        
        static let sClsId        = "AppSchedPatLocMapView"
        static let sClsVers      = "v1.0301"
        static let sClsDisp      = sClsId+"(.swift).("+sClsVers+"):"
        static let sClsCopyRight = "Copyright (C) JustMacApps 2023-2025. All Rights Reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }
    
    // 'Internal' Trace flag:

    private 
    var bInternalTraceFlag:Bool                                                 = false

    // App Data field(s):

//  @Environment(\.dismiss)          var dismiss
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme)      var colorScheme

           private  let fMapLatLongTolerance:Double                             = 0.0025

    @State private  var cAppMapTapPresses:Int                                   = 0
    @State private  var cAppTidScheduleViewButtonPresses:Int                    = 0

    @State private  var isAppTidScheduleViewModal:Bool                          = false
    @State private  var isAppMapTapAlertShowing:Bool                            = false
    @State private  var sMapTapMsg:String                                       = ""

    @State private  var sTherapistTID:String

    @State private  var sTherapistName:String                                   = ""

                    var jmAppDelegateVisitor:JmAppDelegateVisitor               = JmAppDelegateVisitor.ClassSingleton.appDelegateVisitor
    @ObservedObject var jmAppParseCoreManager:JmAppParseCoreManager             = JmAppParseCoreManager.ClassSingleton.appParseCodeManager
                    var jmAppParseCoreBkgdDataRepo:JmAppParseCoreBkgdDataRepo   = JmAppParseCoreBkgdDataRepo.ClassSingleton.appParseCodeBkgdDataRepo
                    var appScheduleLoadingAssistant:AppScheduleLoadingAssistant = AppScheduleLoadingAssistant.ClassSingleton.appScheduleLoadingAssistant
    
//  init(sTherapistTID:Binding<String>)
    init(sTherapistTID:String)
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        // Handle inbound parameter(s) before any 'self.' references...
        
        _sTherapistTID = State(wrappedValue:sTherapistTID)

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'sTherapistTID' is [\(sTherapistTID)]...")

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
        
        let _ = xcgLogMsg("\(ClassInfo.sClsDisp):body(some View) - Map for TID #(\(self.sTherapistTID)) - 'colorScheme' is [\(colorScheme)]...")

        if (colorScheme == .dark)
        {
        
            let _ = xcgLogMsg("\(ClassInfo.sClsDisp):body(some View) - Map for TID #(\(self.sTherapistTID)) - 'colorScheme' is running in 'dark' mode...")
        
        }
        else
        {
        
            let _ = xcgLogMsg("\(ClassInfo.sClsDisp):body(some View) - Map for TID #(\(self.sTherapistTID)) - 'colorScheme' is running in 'light' mode...")
        
        }

        let pfCscObject:ParsePFCscDataItem
            = self.jmAppParseCoreManager.locatePFCscDataItemByTherapistTID(sTherapistTID:self.sTherapistTID)
        let listScheduledPatientLocationItems:[ScheduledPatientLocationItem]
            = self.appScheduleLoadingAssistant.dictOfSortedSchedPatientLocItems[self.sTherapistTID] ?? [ScheduledPatientLocationItem]()

        let _ = xcgLogMsg("\(ClassInfo.sClsDisp):body(some View) - Map for TID #(\(self.sTherapistTID)) Visits #(\(listScheduledPatientLocationItems.count))...")

        GeometryReader
        { proxy in

            ScrollView
            {

                HStack(alignment:.center)
                {

                    Button
                    {

                        self.cAppTidScheduleViewButtonPresses += 1

                        let _ = xcgLogMsg("\(ClassInfo.sClsDisp):AppSchedPatLocMapView.Button(Xcode).'App TID Schedule View'.#(\(self.cAppTidScheduleViewButtonPresses))...")

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

                            AppTidScheduleView(listScheduledPatientLocationItems:listScheduledPatientLocationItems)

                        }
                    )
                #elseif os(iOS)
                    .fullScreenCover(isPresented:$isAppTidScheduleViewModal)
                    {

                        AppTidScheduleView(listScheduledPatientLocationItems:listScheduledPatientLocationItems)

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

                    Spacer()

                    VStack
                    {

                        HStack(alignment:.center)
                        {

                            Spacer()

                            Text("Name::\(self.locateAppTherapistNamebyTid(sTherapistTID:self.sTherapistTID))")
                                .font(.caption)
                                .bold()
                                .italic()
                                .font(.footnote)

                            Spacer()

                        }

                        HStack(alignment:.center)
                        {

                            Spacer()

                            Text("TID #(\(self.sTherapistTID)) Visits #(\(listScheduledPatientLocationItems.count))")
                                .font(.caption)
                                .bold()
                                .italic()
                                .font(.footnote)
                            #if os(iOS)
                                .onAppear(
                                    perform:
                                    {
                                        UIApplication.shared.isIdleTimerDisabled = true 
                                    })
                                .onDisappear(
                                    perform:
                                    {
                                        UIApplication.shared.isIdleTimerDisabled = false
                                    })
                            #endif

                            Spacer()

                        }

                    if (pfCscObject.sPFCscParseLastLocDate.count  > 0       &&
                        pfCscObject.sPFCscParseLastLocDate       != "-N/A-" &&
                        pfCscObject.sPFCscParseLastLocTime.count  > 0       &&
                        pfCscObject.sPFCscParseLastLocTime       != "-N/A-")
                    {

                    //  Text("\(pfCscObject.sPFCscParseLastLocDate) @ \(pfCscObject.sPFCscParseLastLocTime)")
                    //      .gridColumnAlignment(.leading)
                    //      .font(.footnote)
                    //      .foregroundStyle((self.isDateInToday(sDateToCheck:pfCscObject.sPFCscParseLastLocDate) == false) ? .red : .primary)

                        HStack(alignment:.center)
                        {
                        
                            Spacer()
                        
                            Text("\(pfCscObject.sCurrentLocationName), \(pfCscObject.sCurrentCity) \(pfCscObject.sCurrentPostalCode)")
                                .font(.caption)
                        
                            Spacer()
                        
                        }
                        
                        HStack(alignment:.center)
                        {
                        
                            Spacer()
                        
                            Text(pfCscObject.sPFCscParseLastLocDate)
                                .gridColumnAlignment(.center)
                                .font(.caption)
                            Text(" @ ")
                                .gridColumnAlignment(.center)
                                .font(.caption)
                            Text(pfCscObject.sPFCscParseLastLocTime)
                                .gridColumnAlignment(.center)
                                .font(.caption)
                        
                            Spacer()
                        
                        }
                        .foregroundStyle((self.isDateInToday(sDateToCheck:pfCscObject.sPFCscParseLastLocDate) == false) ? .red : .primary)

                    }

                    }

                    Spacer()

                    Button
                    {

                        let _ = xcgLogMsg("\(ClassInfo.sClsDisp):AppSchedPatLocMapView.Button(Xcode).'Dismiss' pressed...")

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

                VStack
                {

                    let _ = xcgLogMsg("\(ClassInfo.sClsDisp):body(some View).VStack - Map for TID #(\(self.sTherapistTID))...")

                    MapReader
                    { proxy in

                        Map
                        {

                            if (pfCscObject.sPFCscParseLastLocDate.count  > 0       &&
                                pfCscObject.sPFCscParseLastLocDate       != "-N/A-" &&
                                pfCscObject.sPFCscParseLastLocTime.count  > 0       &&
                                pfCscObject.sPFCscParseLastLocTime       != "-N/A-")
                            {

                                Annotation("+", 
                                           coordinate:pfCscObject.clLocationCoordinate2D)
                                {
                                
                                    Image(systemName:"mappin.and.ellipse")
                                        .help(Text("Therapist 'current' location"))
                                        .imageScale(.large)
                                        .foregroundColor(.red)
                                        .onTapGesture
                                        { position in
                                
                                            self.cAppMapTapPresses   += 1
                                            let sMapTapLogMsg:String  = "Map 'tap' #(\(cAppMapTapPresses)) - \(pfCscObject.sPFCscParseName) at \(pfCscObject.sCurrentLocationName),\(pfCscObject.sCurrentCity) on \(pfCscObject.sPFCscParseLastLocDate)::\(pfCscObject.sPFCscParseLastLocTime)"
                                            self.sMapTapMsg           = "\(pfCscObject.sPFCscParseName) at \(pfCscObject.sCurrentLocationName),\(pfCscObject.sCurrentCity) on \(pfCscObject.sPFCscParseLastLocDate)::\(pfCscObject.sPFCscParseLastLocTime)"
                                
                                            let _ = xcgLogMsg("\(ClassInfo.sClsDisp):body(some View).MapReader.Map.Therapist.onTapGesture - <Marker> - \(sMapTapLogMsg)...")
                                            let _ = xcgLogMsg("\(ClassInfo.sClsDisp):body(some View).MapReader.Map.Therapist.onTapGesture - <Marker> - \(self.sMapTapMsg)...")
                                          
                                            self.isAppMapTapAlertShowing.toggle()
                                
                                        }
                                
                                }

                            }

                            if (listScheduledPatientLocationItems.count > 0)
                            {

                                ForEach(listScheduledPatientLocationItems)
                                { scheduledPatientLocationItem in

                                    Annotation(scheduledPatientLocationItem.sVDateStartTime, 
                                               coordinate:scheduledPatientLocationItem.clLocationCoordinate2DPatLoc)
                                    {

                                        Image(systemName:"cross.case.circle")
                                            .help(Text("Scheduled Patient visit"))
                                            .imageScale(.large)
                                            .foregroundColor(.yellow)
                                            .onTapGesture
                                            { position in

                                                self.cAppMapTapPresses   += 1
                                                let sMapTapLogMsg:String  = "Map 'tap' #(\(cAppMapTapPresses)) - Marker for TID #(\(scheduledPatientLocationItem.sTid)) for PID #(\(scheduledPatientLocationItem.sPid)) Patient [\(scheduledPatientLocationItem.sPtName)] on [\(scheduledPatientLocationItem.sVDate)] at [\(scheduledPatientLocationItem.sVDateStartTime)] at address [\(scheduledPatientLocationItem.sLastVDateAddress)]..."
                                                self.sMapTapMsg           = "\(scheduledPatientLocationItem.sPtName) at \(scheduledPatientLocationItem.sLastVDateAddress) on \(scheduledPatientLocationItem.sVDate)::\(scheduledPatientLocationItem.sVDateStartTime)"

                                                let _ = xcgLogMsg("\(ClassInfo.sClsDisp):body(some View).MapReader.Map.Patient.onTapGesture - <Annotation> - \(sMapTapLogMsg)...")
                                                let _ = xcgLogMsg("\(ClassInfo.sClsDisp):body(some View).MapReader.Map.Patient.onTapGesture - <Annotation> - \(self.sMapTapMsg)...")

                                                self.isAppMapTapAlertShowing.toggle()

                                            }

                                    }

                                }
                            
                            }

                        }
                    #if os(macOS)
                        .mapControls
                        {

                            MapZoomStepper()
                            MapScaleView()

                        }
                    #endif
                    #if os(iOS)
                        .mapControls
                        {

                            MapScaleView()

                        }
                    #endif
                        .alert(self.sMapTapMsg, isPresented:$isAppMapTapAlertShowing)
                        {
                            Button("Ok", role:.cancel)
                            {
                                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).MapReader.Map.onTapGesture User pressed 'Ok' to the Map 'tap' alert...")
                            }
                        }

                    }

                }
                .frame(width: proxy.size.width, height: proxy.size.height, alignment:.center)
                .ignoresSafeArea()

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
    
    private func isDateInToday(sDateToCheck:String)->Bool
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'sDateToCheck' is [\(sDateToCheck)]...")

        // Check if the supplied Date (string) is 'inToday'...

        var bDateIsInToday:Bool = false

        if (sDateToCheck.count > 0)
        {
        
            let dateFormatterFromString:DateFormatter = DateFormatter()
            dateFormatterFromString.dateFormat        = "M/dd/yy"
            let dateTestIsInToday:Date                = dateFormatterFromString.date(from:sDateToCheck) ?? Calendar.current.date(byAdding: .day, value: -1, to: .now)!
            bDateIsInToday                            = (Calendar.current.isDateInToday(dateTestIsInToday))
        
        }

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'bDateIsInToday' is [\(bDateIsInToday)]...")
  
        return bDateIsInToday

    } // End of private func isDateInToday(dateToCheck:Date)->Bool.
    
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

}   // End of struct AppSchedPatLocMapView:(View).

