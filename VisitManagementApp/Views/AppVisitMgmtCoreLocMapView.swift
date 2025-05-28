//
//  AppVisitMgmtCoreLocMapView.swift
//  VisitManagementApp
//
//  Created by Daryl Cox on 05/18/2025.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import SwiftUI
import MapKit

struct AppVisitMgmtCoreLocMapView:View 
{
    
    struct ClassInfo
    {
        
        static let sClsId        = "AppVisitMgmtCoreLocMapView"
        static let sClsVers      = "v1.0110"
        static let sClsDisp      = sClsId+"(.swift).("+sClsVers+"):"
        static let sClsCopyRight = "Copyright (C) JustMacApps 2023-2025. All Rights Reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }
    
    // 'Internal' Trace flag:

    private 
    var bInternalTraceFlag:Bool                                   = false

    // App Data field(s):

//  @Environment(\.dismiss)             var dismiss
    @Environment(\.presentationMode)    var presentationMode
    @Environment(\.appGlobalDeviceType) var appGlobalDeviceType
    @Environment(\.colorScheme)         var colorScheme

           private  let fMapLatLongTolerance:Double               = 0.0025

    @State private  var sCoreLocLatLong:String

    @State private  var sLocationLatitude:String                  = ""
    @State private  var sLocationLongitude:String                 = ""
    @State private  var sLocationAddress:String                   = ""

                    var clLocationCoordinate2D:CLLocationCoordinate2D
    {
        return CLLocationCoordinate2D(latitude: (Double(String(describing:self.sLocationLatitude))  ?? 0.000000), 
                                      longitude:(Double(String(describing:self.sLocationLongitude)) ?? 0.000000))
    }

    @State private  var isAppMapTapAlertShowing:Bool              = false

    @State private  var sMapTapMsg:String                         = ""

                    var jmAppDelegateVisitor:JmAppDelegateVisitor = JmAppDelegateVisitor.ClassSingleton.appDelegateVisitor
    
    init(sCoreLocLatLong:String, sCoreLocAddress:String)
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        // Handle inbound parameter(s) before any 'self.' references...

        _sCoreLocLatLong    = State(wrappedValue:sCoreLocLatLong)
        _sLocationLatitude  = State(wrappedValue:self.splitCoreLocLatLongToLatitude(sCoreLocLatLong:sCoreLocLatLong))
        _sLocationLongitude = State(wrappedValue:self.splitCoreLocLatLongToLongitude(sCoreLocLatLong:sCoreLocLatLong))
        _sLocationAddress   = State(wrappedValue:sCoreLocAddress)
    //  _sLocationAddress   = State(wrappedValue:self.locateAddressByLatitudeLongitude())

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'sCoreLocLatLong' was [\(sCoreLocLatLong)] and was 'sCoreLocAddress' is [\(sCoreLocAddress)]...")

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
        
        let _ = xcgLogMsg("\(ClassInfo.sClsDisp):body(some View) - Map for CoreLocLatLong (\(self.sCoreLocLatLong)) - 'self.sLocationAddress' is [\(self.sLocationAddress)] - 'colorScheme' is [\(colorScheme)]...")

        if (colorScheme == .dark)
        {
        
            let _ = xcgLogMsg("\(ClassInfo.sClsDisp):body(some View) - Map for CoreLocLatLong (\(self.sCoreLocLatLong)) - 'self.sLocationAddress' is [\(self.sLocationAddress)] - 'colorScheme' is running in 'dark' mode...")
        
        }
        else
        {
        
            let _ = xcgLogMsg("\(ClassInfo.sClsDisp):body(some View) - Map for CoreLocLatLong (\(self.sCoreLocLatLong)) - 'self.sLocationAddress' is [\(self.sLocationAddress)] - 'colorScheme' is running in 'light' mode...")
        
        }

        GeometryReader
        { proxy in

            ScrollView
            {

                HStack(alignment:.center)
                {

                    Spacer()

                    Button
                    {

                        let _ = xcgLogMsg("\(ClassInfo.sClsDisp):AppVisitMgmtCoreLocMapView.Button(Xcode).'Dismiss' pressed...")

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

                    let _ = xcgLogMsg("\(ClassInfo.sClsDisp):body(some View).VStack - Map for CoreLocLatLong(\(self.sCoreLocLatLong)) - 'self.sLocationAddress' is [\(self.sLocationAddress)]...")

                    Text("CoreLoc Lat/Long [\(self.sCoreLocLatLong)] at [\(self.sLocationAddress)]")
                        .font(.footnote)

                    MapReader
                    { proxy in

                        Map
                        {

                            Annotation("+", 
                                       coordinate:self.clLocationCoordinate2D)
                            {
                            
                                Image(systemName:"mappin.and.ellipse")
                                    .help(Text("Location"))
                                    .imageScale(.large)
                                    .foregroundColor(.red)
                                    .onTapGesture
                                    { position in
                            
                                        let sMapTapLogMsg:String = "Map 'tap' CoreLoc Lat/Long [\(self.sCoreLocLatLong)] at [\(self.sLocationAddress)]"
                                        self.sMapTapMsg          = "Lat/Long [\(self.sCoreLocLatLong)] at [\(self.sLocationAddress)]"
                            
                                        let _ = xcgLogMsg("\(ClassInfo.sClsDisp):body(some View).MapReader.Map.onTapGesture - <Marker> - \(sMapTapLogMsg)...")
                                        let _ = xcgLogMsg("\(ClassInfo.sClsDisp):body(some View).MapReader.Map.onTapGesture - <Marker> - \(self.sMapTapMsg)...")
                                      
                                        self.isAppMapTapAlertShowing.toggle()
                            
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
                        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onAppear #2 - 'appGlobalDeviceType' is (\(String(describing:appGlobalDeviceType)))...")

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

    private func splitCoreLocLatLongToLatitude(sCoreLocLatLong:String = "")->String
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter is 'sCoreLocLatLong' is [\(sCoreLocLatLong)]...")

        // Check that the supplied CoreLoc Latitude/Longitude string is valid...

        var sCoreLocLatitude:String  = "0.000000"

        if (sCoreLocLatLong.count  < 1)
        {
        
            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - CoreLocation Lat/Long string was NOT provided - 'sCoreLocLatitude' is [\(sCoreLocLatitude)]...")

            return sCoreLocLatitude

        }

        // Split a supplied CoreLoc Latitude/Longitude string into separate Latitude/Longitude strings...

        let listCoreLocPartitions:[String] = splitCoreLocLatLong(sCoreLocLatLong:sCoreLocLatLong)

        sCoreLocLatitude = listCoreLocPartitions[0]

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'listCoreLocPartitions' is [\(String(describing: listCoreLocPartitions))] and 'sCoreLocLatitude' is [\(sCoreLocLatitude)]...")

        return sCoreLocLatitude

    }   // End of private func private func splitCoreLocLatLongToLatitude(sCoreLocLatLong:String)->String.
    
    private func splitCoreLocLatLongToLongitude(sCoreLocLatLong:String = "")->String
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter is 'sCoreLocLatLong' is [\(sCoreLocLatLong)]...")

        // Check that the supplied CoreLoc Latitude/Longitude string is valid...

        var sCoreLocLongitude:String = "0.000000"

        if (sCoreLocLatLong.count  < 1)
        {
        
            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - CoreLocation Lat/Long string was NOT provided - 'sCoreLocLongitude' is [\(sCoreLocLongitude)]...")

            return sCoreLocLongitude

        }

        // Split a supplied CoreLoc Latitude/Longitude string into separate Latitude/Longitude strings...

        let listCoreLocPartitions:[String] = splitCoreLocLatLong(sCoreLocLatLong:sCoreLocLatLong)

        sCoreLocLongitude = listCoreLocPartitions[1]

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'listCoreLocPartitions' is [\(String(describing: listCoreLocPartitions))] and 'sCoreLocLongitude' is [\(sCoreLocLongitude)]...")

        return sCoreLocLongitude

    }   // End of private func private func splitCoreLocLatLongToLongitude(sCoreLocLatLong:String)->String.
    
    private func splitCoreLocLatLong(sCoreLocLatLong:String = "")->[String]
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter is 'sCoreLocLatLong' is [\(sCoreLocLatLong)]...")

        // Check that the supplied CoreLoc Latitude/Longitude string is valid...

        var sCoreLocLatitude:String  = "0.000000"
        var sCoreLocLongitude:String = "0.000000"

        if (sCoreLocLatLong.count  < 1)
        {
        
            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - CoreLocation Lat/Long string was NOT provided - 'sCoreLocLatitude' is [\(sCoreLocLatitude)] and 'sCoreLocLongitude' is [\(sCoreLocLongitude)]...")

            return [sCoreLocLatitude, sCoreLocLongitude]

        }

        // Split a supplied CoreLoc Latitude/Longitude string into separate Latitude/Longitude strings...

        let listCoreLocPartitions:[String]? = sCoreLocLatLong.leftPartitionStrings(target:",")

        if (listCoreLocPartitions        == nil ||
            listCoreLocPartitions!.count != 3)
        {
        
            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - CoreLocation Lat/Long string was provided but did NOT successfully partition 'listCoreLocPartitions' is [\(String(describing: listCoreLocPartitions))] - 'sCoreLocLatitude' is [\(sCoreLocLatitude)] and 'sCoreLocLongitude' is [\(sCoreLocLongitude)]...")

            return [sCoreLocLatitude, sCoreLocLongitude]
        
        }
        
        sCoreLocLatitude  = listCoreLocPartitions![0]
        sCoreLocLongitude = listCoreLocPartitions![2]

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'listCoreLocPartitions' is [\(String(describing: listCoreLocPartitions))] and 'sCoreLocLatitude' is [\(sCoreLocLatitude)] and 'sCoreLocLongitude' is [\(sCoreLocLongitude)]...")

        return [sCoreLocLatitude, sCoreLocLongitude]

    }   // End of private func splitCoreLocLatLong(sCoreLocLatLong:String)->[String].
    
    private func locateAddressByLatitudeLongitude()->String
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameters are 'self.sLocationLatitude' is (\(self.sLocationLatitude)) - 'self.sLocationLongitude' is (\(self.sLocationLongitude))...")

        // Locate an Address from the Latitude/Longitude coordinates...

        let sLocatedAddress:String = "-N/A-"

        if (self.sLocationLatitude.count  < 1 ||
            self.sLocationLongitude.count < 1)
        {
        
            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - latitude and/or longitude were NOT provided - 'sLocatedAddress' is [\(sLocatedAddress)]...")

            return sLocatedAddress

        }

        // Use the Latitude/Longitude values to resolve address...

        if (self.jmAppDelegateVisitor.jmAppCLModelObservable2 != nil)
        {

            let clModelObservable2:CoreLocationModelObservable2 = self.jmAppDelegateVisitor.jmAppCLModelObservable2!
            let iRequestID:Int                                  = 1
            let dblLocationLatitude:Double                      = Double(self.sLocationLatitude)  ?? 0.0000
            let dblLocationLongitude:Double                     = Double(self.sLocationLongitude) ?? 0.0000

            DispatchQueue.main.async
            {
                self.xcgLogMsg("\(sCurrMethodDisp) <closure> Calling 'updateGeocoderLocation()' for Latitude/Longitude of [\(dblLocationLatitude)/\(dblLocationLongitude)]...")

                let _ = clModelObservable2.updateGeocoderLocations(requestID:iRequestID, 
                                                                   latitude: dblLocationLatitude, 
                                                                   longitude:dblLocationLongitude, 
                                                                   withCompletionHandler:
                                                                       { (requestID:Int, dictCurrentLocation:[String:Any]) in
                                                                           self.handleLocationAndAddressClosureEvent(bIsDownstreamObject:false, requestID:requestID, dictCurrentLocation:dictCurrentLocation)
                                                                       }
                                                                  )
            }

        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) CoreLocation (service) is NOT available...")

        }

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'sLocatedAddress' is [\(sLocatedAddress)]...")
  
        return sLocatedAddress

    } // End of private func locateAddressByLatitudeLongitude()->String.
    
    public func handleLocationAndAddressClosureEvent(bIsDownstreamObject:Bool = false, requestID:Int, dictCurrentLocation:[String:Any])
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'bIsDownstreamObject' is [\(bIsDownstreamObject)] - 'requestID' is [\(requestID)] - 'dictCurrentLocation' is [\(String(describing: dictCurrentLocation))]...")

        // Update the address info...

        if (dictCurrentLocation.count > 0)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) #(\(requestID)): <closure> Called  'updateGeocoderLocation()' a 'location' of [\(String(describing: dictCurrentLocation))]...")

            self.sLocationLatitude  = String(describing: (dictCurrentLocation["dblLatitude"]             ?? "0.000000"))
            self.sLocationLongitude = String(describing: (dictCurrentLocation["dblLongitude"]            ?? "0.000000"))
            self.sLocationAddress   = String(describing: (dictCurrentLocation["sCurrentLocationAddress"] ?? "-N/A-"))

            self.xcgLogMsg("\(sCurrMethodDisp) Updated - 'dictCurrentLocation[\"dblLatitude\"]' is [\(dictCurrentLocation["dblLatitude"])] - 'dictCurrentLocation[\"dblLongitude\"]' is [\(dictCurrentLocation["dblLongitude"])] - 'dictCurrentLocation[\"sCurrentLocationAddress\"]' is [\(dictCurrentLocation["sCurrentLocationAddress"])] ...")
            self.xcgLogMsg("\(sCurrMethodDisp) Updated - 'self.sLocationLatitude' is [\(self.sLocationLatitude)] - 'self.sLocationLongitude' is [\(self.sLocationLongitude)] - 'self.sLocationAddress' is [\(self.sLocationAddress)] ...")
        
        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) #(\(requestID)): Dictionary 'dictCurrentLocation' is 'empty' - bypassing update - Warning!")

        }

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of public func handleLocationAndAddressClosureEvent(bIsDownstreamObject:Bool, requestID:Int, dictCurrentLocation:[String:Any]).

}   // End of struct AppVisitMgmtCoreLocMapView:View.

