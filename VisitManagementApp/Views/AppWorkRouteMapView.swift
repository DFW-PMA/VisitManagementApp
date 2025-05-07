//
//  AppWorkRouteMapView.swift
//  VisitManagementApp
//
//  Created by Daryl Cox on 11/18/2024.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import SwiftUI
import MapKit

struct AppWorkRouteMapView: View 
{
    
    struct ClassInfo
    {
        
        static let sClsId        = "AppWorkRouteMapView"
        static let sClsVers      = "v1.1701"
        static let sClsDisp      = sClsId+"(.swift).("+sClsVers+"):"
        static let sClsCopyRight = "Copyright (C) JustMacApps 2023-2025. All Rights Reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }
    
    // App Data field(s):

//  @Environment(\.dismiss)          var dismiss
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme)      var colorScheme

           private  let fMapLatLongTolerance:Double                           = 0.0025

    @State private  var cAppMapTapPresses:Int                                 = 0
    @State private  var cAppTidScheduleViewButtonPresses:Int                  = 0

    @State private  var isAppTidScheduleViewModal:Bool                        = false
    @State private  var isAppMapTapAlertShowing:Bool                          = false
    @State private  var sMapTapMsg:String                                     = ""

    @State          var parsePFCscDataItem:ParsePFCscDataItem

                    var jmAppDelegateVisitor:JmAppDelegateVisitor             = JmAppDelegateVisitor.ClassSingleton.appDelegateVisitor
    @ObservedObject var jmAppParseCoreManager:JmAppParseCoreManager           = JmAppParseCoreManager.ClassSingleton.appParseCodeManager
                    var jmAppParseCoreBkgdDataRepo:JmAppParseCoreBkgdDataRepo = JmAppParseCoreBkgdDataRepo.ClassSingleton.appParseCodeBkgdDataRepo
    
    init(parsePFCscDataItem:ParsePFCscDataItem)
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        // Handle the 'parsePFCscDataItem' parameter...
      
        self._parsePFCscDataItem = State(initialValue: parsePFCscDataItem)

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'parsePFCscDataItem' at [\(parsePFCscDataItem)] value is [\(parsePFCscDataItem.toString())]...")

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
        
        let _ = xcgLogMsg("\(ClassInfo.sClsDisp):body(some View) - Map #(\(parsePFCscDataItem.idPFCscObject)) for [\(parsePFCscDataItem.sPFCscParseName)] - 'colorScheme' is [\(colorScheme)]...")

        if (colorScheme == .dark)
        {
        
            let _ = xcgLogMsg("\(ClassInfo.sClsDisp):body(some View) - Map #(\(parsePFCscDataItem.idPFCscObject)) for [\(parsePFCscDataItem.sPFCscParseName)] - 'colorScheme' is running in 'dark' mode...")
        
        }
        else
        {
        
            let _ = xcgLogMsg("\(ClassInfo.sClsDisp):body(some View) - Map #(\(parsePFCscDataItem.idPFCscObject)) for [\(parsePFCscDataItem.sPFCscParseName)] - 'colorScheme' is running in 'light' mode...")
        
        }

        let sPFTherapistParseTID:String
            = self.convertPFCscDataItemToTid(pfCscDataItem:parsePFCscDataItem)
        let listScheduledPatientLocationItems:[ScheduledPatientLocationItem]
            = self.getScheduledPatientLocationItemsForPFCscDataItem(pfCscDataItem:parsePFCscDataItem)

        let _ = xcgLogMsg("\(ClassInfo.sClsDisp):body(some View) - Map #(\(parsePFCscDataItem.idPFCscObject)) for [\(parsePFCscDataItem.sPFCscParseName)] TID #(\(sPFTherapistParseTID)) Visits #(\(listScheduledPatientLocationItems.count))...")

        GeometryReader
        { proxy in

            ScrollView
            {

                HStack(alignment:.center)
                {

                    Button
                    {

                        self.cAppTidScheduleViewButtonPresses += 1

                        let _ = xcgLogMsg("\(ClassInfo.sClsDisp):AppWorkRouteMapView.Button(Xcode).'App TID Schedule View'.#(\(self.cAppTidScheduleViewButtonPresses))...")

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

                            Text("Map #(\(parsePFCscDataItem.idPFCscObject))::\(parsePFCscDataItem.sPFCscParseName)")
                                .font(.caption)
                                .bold()
                                .italic()
                                .font(.footnote)

                            Spacer()

                        }

                        HStack(alignment:.center)
                        {

                            Spacer()

                            Text("TID #(\(sPFTherapistParseTID)) Visits #(\(listScheduledPatientLocationItems.count))")
                                .font(.caption)
                                .bold()
                                .italic()
                                .font(.footnote)

                            Spacer()

                        }

                        HStack(alignment:.center)
                        {

                            Spacer()

                            Text("\(parsePFCscDataItem.sCurrentLocationName), \(parsePFCscDataItem.sCurrentCity) \(parsePFCscDataItem.sCurrentPostalCode)")
                                .font(.caption)
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

                        HStack(alignment:.center)
                        {

                            Spacer()

                            Text(parsePFCscDataItem.sPFCscParseLastLocDate)
                                .gridColumnAlignment(.center)
                                .font(.caption)
                            Text(" @ ")
                                .gridColumnAlignment(.center)
                                .font(.caption)
                            Text(parsePFCscDataItem.sPFCscParseLastLocTime)
                                .gridColumnAlignment(.center)
                                .font(.caption)

                            Spacer()

                        }

                    }

                    Spacer()

                    Button
                    {

                        let _ = xcgLogMsg("\(ClassInfo.sClsDisp):AppWorkRouteMapView.Button(Xcode).'Dismiss' pressed...")

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

                    let _ = xcgLogMsg("\(ClassInfo.sClsDisp):body(some View).VStack - Map #(\(parsePFCscDataItem.idPFCscObject)) for [\(parsePFCscDataItem.sPFCscParseName)] 'clLocationCoordinate2D' is [\(parsePFCscDataItem.clLocationCoordinate2D)]...")

                    MapReader
                    { proxy in

                        Map(initialPosition:parsePFCscDataItem.mapPosition)
                        {

                            Annotation("+", 
                                       coordinate:parsePFCscDataItem.clLocationCoordinate2D)
                            {

                                Image(systemName:"mappin.and.ellipse")
                                    .help(Text("Therapist 'current' location"))
                                    .imageScale(.large)
                                    .foregroundColor(.red)
                                    .onTapGesture
                                    { position in

                                        self.cAppMapTapPresses   += 1
                                        let sMapTapLogMsg:String  = "Map 'tap' #(\(cAppMapTapPresses)) - \(parsePFCscDataItem.sPFCscParseName) at \(parsePFCscDataItem.sCurrentLocationName),\(parsePFCscDataItem.sCurrentCity) on \(parsePFCscDataItem.sPFCscParseLastLocDate)::\(parsePFCscDataItem.sPFCscParseLastLocTime)"
                                        self.sMapTapMsg           = "\(parsePFCscDataItem.sPFCscParseName) at \(parsePFCscDataItem.sCurrentLocationName),\(parsePFCscDataItem.sCurrentCity) on \(parsePFCscDataItem.sPFCscParseLastLocDate)::\(parsePFCscDataItem.sPFCscParseLastLocTime)"

                                        let _ = xcgLogMsg("\(ClassInfo.sClsDisp):body(some View).MapReader.Map.Therapist.onTapGesture - <Marker> - \(sMapTapLogMsg)...")
                                        let _ = xcgLogMsg("\(ClassInfo.sClsDisp):body(some View).MapReader.Map.Therapist.onTapGesture - <Marker> - \(self.sMapTapMsg)...")
                                      
                                        self.isAppMapTapAlertShowing.toggle()

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
    
    private func convertPFCscDataItemToTid(pfCscDataItem:ParsePFCscDataItem)->String
    {
  
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'pfCscDataItem' is [\(pfCscDataItem)]...")

        // Use the TherapistName in the PFCscDataItem to lookup the 'sPFTherapistParseTID'...

        var sPFTherapistParseTID:String                 = ""
        let jmAppParseCoreManager:JmAppParseCoreManager = JmAppParseCoreManager.ClassSingleton.appParseCodeManager

        if (pfCscDataItem.sPFCscParseName.count > 0)
        {

            sPFTherapistParseTID = jmAppParseCoreManager.convertTherapistNameToTid(sPFTherapistParseName:pfCscDataItem.sPFCscParseName)

            if (sPFTherapistParseTID.count < 1)
            {

                sPFTherapistParseTID = jmAppParseCoreBkgdDataRepo.convertTherapistNameToTid(sPFTherapistParseName:pfCscDataItem.sPFCscParseName)

                if (sPFTherapistParseTID.count < 1)
                {

                    let _ = jmAppParseCoreBkgdDataRepo.deepCopyListPFCscDataItems()
                    let _ = jmAppParseCoreBkgdDataRepo.deepCopyListPFCscNameItems()

                }

            }

        }
        
        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'sPFTherapistParseTID' is [\(sPFTherapistParseTID)]...")
  
        return sPFTherapistParseTID
  
    }   // End of private func convertPFCscDataItemToTid(pfCscDataItem:PFCscDataItem)->String.

    private func getScheduledPatientLocationItemsForTid(sPFTherapistParseTID:String = "")->[ScheduledPatientLocationItem]
    {
  
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'sPFTherapistParseTID' is [\(sPFTherapistParseTID)]...")

        // Use the TherapistName in the PFCscDataItem to lookup any ScheduledPatientLocationItem(s)...

        var listScheduledPatientLocationItems:[ScheduledPatientLocationItem] = []
        let jmAppParseCoreManager:JmAppParseCoreManager                      = JmAppParseCoreManager.ClassSingleton.appParseCodeManager

        if (sPFTherapistParseTID.count > 0)
        {

            if (jmAppParseCoreManager.dictSchedPatientLocItems.count > 0)
            {

                listScheduledPatientLocationItems = jmAppParseCoreManager.dictSchedPatientLocItems[sPFTherapistParseTID] ?? []

            }

        }
        
        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'listScheduledPatientLocationItems' is [\(listScheduledPatientLocationItems)]...")
  
        return listScheduledPatientLocationItems
  
    }   // End of private func getScheduledPatientLocationItemsForTid(sPFTherapistParseTID:String = "")->[ScheduledPatientLocationItem].

    private func getScheduledPatientLocationItemsForPFCscDataItem(pfCscDataItem:ParsePFCscDataItem)->[ScheduledPatientLocationItem]
    {
  
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'pfCscDataItem' is [\(pfCscDataItem)]...")

        // Use the Therapist TID to lookup any ScheduledPatientLocationItem(s)...

        let sPFTherapistParseTID:String
            = self.convertPFCscDataItemToTid(pfCscDataItem:pfCscDataItem)
        let listScheduledPatientLocationItems:[ScheduledPatientLocationItem] 
            = self.getScheduledPatientLocationItemsForTid(sPFTherapistParseTID:sPFTherapistParseTID)

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'listScheduledPatientLocationItems' is [\(listScheduledPatientLocationItems)]...")
  
        return listScheduledPatientLocationItems
  
    }   // End of private func getScheduledPatientLocationItemsForPFCscDataItem(pfCscDataItem:PFCscDataItem)->[ScheduledPatientLocationItem].

}

#Preview 
{
    
    AppWorkRouteMapView(parsePFCscDataItem:ParsePFCscDataItem())
    
}

