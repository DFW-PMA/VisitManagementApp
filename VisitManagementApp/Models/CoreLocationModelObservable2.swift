//
//  CoreLocationModelObservable2.swift
//  VisitManagementApp
//
//  Created by Daryl Cox on 11/14/2024.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
import SwiftUI
import CoreLocation

enum CLRevLocType:String, CaseIterable
{
    
    case primary   = "primary"
    case secondary = "secondary"
    case tertiary  = "tertiary"
    
}   // End of enum CLRevLocType(String, CaseIterable).

class CoreLocationModelObservable2:NSObject, CLLocationManagerDelegate, ObservableObject
{
    
    struct ClassInfo
    {
        
        static let sClsId        = "CoreLocationModelObservable2"
        static let sClsVers      = "v1.1201"
        static let sClsDisp      = sClsId+"(.swift).("+sClsVers+"):"
        static let sClsCopyRight = "Copyright (C) JustMacApps 2023-2025. All Rights Reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }

    // Class 'singleton' instance:

    struct ClassSingleton
    {
        static var appCoreLocationModel:CoreLocationModelObservable2
                                                                = CoreLocationModelObservable2()
    }

    // 'Internal' Trace flag:

    private 
    var bInternalTraceFlag:Bool                                 = false

    // App Data field(s):

               var cCoreLocationReverseLookupsPrimary:Int       = 0
               var cCoreLocationReverseLookupsSecondary:Int     = 0
               var cCoreLocationReverseLookupsTertiary:Int      = 0
    
               var locationManager:CLLocationManager?           = nil
    @Published var bCLManagerHeadingAvailable:Bool              = false
    @Published var clCurrentHeading:CLHeading?                  = nil
    @Published var clCurrentHeadingAccuracy:CLLocationDirection = -1
    @Published var clCurrentLocation:CLLocation?                = nil       // Contains: Latitude, Longitude...

    @Published var sCurrentLocationName:String                  = "-N/A-"   // This is actually the Street Address (Line #1) <# Street> (i.e. 8908 Michelle Ln)...
    @Published var sCurrentCity:String                          = "-N/A-"   // City (i.e. North Richland Hills)...
    @Published var sCurrentCountry:String                       = "-N/A-"   // Country (i.e. United States)...
    @Published var sCurrentPostalCode:String                    = "-N/A-"   // Zip Code (i.e. 76182) (Zip-5)...
    @Published var tzCurrentTimeZone:TimeZone?                  = nil       // This is TimeZone in English (i.e. 'America/Chicago')...
    @Published var clCurrentRegion:CLRegion?                    = nil       // ???
    @Published var sCurrentSubLocality:String                   = "-N/A-"   // ??? 
    @Published var sCurrentThoroughfare:String                  = "-N/A-"   // Street Name (Michelle Ln)...
    @Published var sCurrentSubThoroughfare:String               = "-N/A-"   // Address (Building) # (i.e. 8908)...
    @Published var sCurrentAdministrativeArea:String            = "-N/A-"   // State  (i.e. TX)...
    @Published var sCurrentSubAdministrativeArea:String         = "-N/A-"   // County (i.e. Tarrant County)

    @Published var listCoreLocationSiteItems:[CoreLocationSiteItem]
                                                                = [CoreLocationSiteItem]()
                                                                            // List of the 'current' Location Site Item(s)
                                                                            //      as CoreLocationSiteItem(s)...
    
               var jmAppDelegateVisitor:JmAppDelegateVisitor?   = nil
                                                                            // 'jmAppDelegateVisitor' MUST remain declared this way
                                                                            // as having it reference the 'shared' instance of 
                                                                            // JmAppDelegateVisitor causes a circular reference
                                                                            // between the 'init()' methods of the 2 classes...

    // App <global> Message(s) 'stack' cached before XCGLogger is available:

               var listPreXCGLoggerMessages:[String]            = Array()

    private override init()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        super.init()

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
        
        // Exit...

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return
        
    }   // End of private override init().
    
    private func xcgLogMsg(_ sMessage:String)
    {

        if (self.jmAppDelegateVisitor != nil)
        {

            if (self.jmAppDelegateVisitor!.bAppDelegateVisitorLogFilespecIsUsable == true)
            {

                self.jmAppDelegateVisitor!.xcgLogMsg(sMessage)

            }
            else
            {

                print("\(sMessage)")

                self.listPreXCGLoggerMessages.append(sMessage)

            }

        }
        else
        {

            print("\(sMessage)")

            self.listPreXCGLoggerMessages.append(sMessage)

        }

        // Exit:

        return

    }   // End of private func xcgLogMsg(_ sMessage:String).

    public func toString()->String
    {

        var asToString:[String] = Array()

        asToString.append("[")
        asToString.append("[")
        asToString.append("'sClsId': [\(ClassInfo.sClsId)],")
        asToString.append("'sClsVers': [\(ClassInfo.sClsVers)],")
        asToString.append("'sClsDisp': [\(ClassInfo.sClsDisp)],")
        asToString.append("'sClsCopyRight': [\(ClassInfo.sClsCopyRight)],")
        asToString.append("'bClsTrace': [\(ClassInfo.bClsTrace)],")
        asToString.append("'bClsFileLog': [\(ClassInfo.bClsFileLog)]")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'bInternalTraceFlag': [\(String(describing: self.bInternalTraceFlag))],")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'cCoreLocationReverseLookupsPrimary': (\(String(describing: self.cCoreLocationReverseLookupsPrimary))),")
        asToString.append("'cCoreLocationReverseLookupsSecondary': (\(String(describing: self.cCoreLocationReverseLookupsSecondary))),")
        asToString.append("'cCoreLocationReverseLookupsTertiary': (\(String(describing: self.cCoreLocationReverseLookupsTertiary)))")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'locationManager': [\(String(describing: self.locationManager))],")
        asToString.append("'bCLManagerHeadingAvailable': [\(String(describing: self.bCLManagerHeadingAvailable))],")
        asToString.append("'clCurrentHeading': [\(String(describing: self.clCurrentHeading))],")
        asToString.append("'clCurrentHeadingAccuracy': [\(String(describing: self.clCurrentHeadingAccuracy))],")
        asToString.append("'clCurrentLocation': [\(String(describing: self.clCurrentLocation))]")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'sCurrentCity': [\(String(describing: self.sCurrentCity))],")
        asToString.append("'sCurrentCountry': [\(String(describing: self.sCurrentCountry))],")
        asToString.append("'sCurrentPostalCode': [\(String(describing: self.sCurrentPostalCode))],")
        asToString.append("'tzCurrentTimeZone': [\(String(describing: self.tzCurrentTimeZone))],")
        asToString.append("'clCurrentRegion': [\(String(describing: self.clCurrentRegion))],")
        asToString.append("'sCurrentSubLocality': [\(String(describing: self.sCurrentSubLocality))],")
        asToString.append("'sCurrentThoroughfare': [\(String(describing: self.sCurrentThoroughfare))],")
        asToString.append("'sCurrentSubThoroughfare': [\(String(describing: self.sCurrentSubThoroughfare))],")
        asToString.append("'sCurrentAdministrativeArea': [\(String(describing: self.sCurrentAdministrativeArea))],")
        asToString.append("'sCurrentSubAdministrativeArea': [\(String(describing: self.sCurrentSubAdministrativeArea))]")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'listCoreLocationSiteItems': [\(String(describing: self.listCoreLocationSiteItems))]")
        asToString.append("],")
        asToString.append("]")

        let sContents:String = "{"+(asToString.joined(separator: ""))+"}"

        return sContents

    }   // End of public func toString()->String.

    // (Call-back) Method to set the jmAppDelegateVisitor instance...

    public func setJmAppDelegateVisitorInstance(jmAppDelegateVisitor:JmAppDelegateVisitor)
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - supplied parameter 'jmAppDelegateVisitor' is [\(jmAppDelegateVisitor)]...")

        // Set the AppDelegateVisitor instance...

        self.jmAppDelegateVisitor = jmAppDelegateVisitor
    
        // Spool <any> pre-XDGLogger (via the AppDelegateVisitor) message(s) into the Log...

        if (self.listPreXCGLoggerMessages.count > 0)
        {

            self.xcgLogMsg("")
            self.xcgLogMsg("\(sCurrMethodDisp) <<< === Spooling the JmAppDelegateVisitor.XCGLogger 'pre' Message(s) from CoreLocationModelObservable2 === >>>")

            let sPreXCGLoggerMessages:String = self.listPreXCGLoggerMessages.joined(separator: "\n")

            self.xcgLogMsg(sPreXCGLoggerMessages)

            self.xcgLogMsg("\(sCurrMethodDisp) <<< === Spooled  the JmAppDelegateVisitor.XCGLogger 'pre' Message(s) from CoreLocationModelObservable2 === >>>")
            self.xcgLogMsg("")

        }

        // Finish any 'initialization' work:

        self.xcgLogMsg("\(sCurrMethodDisp)' CoreLocationModel Invoking 'self.runPostInitializationTasks()'...")
    
        self.runPostInitializationTasks()

        self.xcgLogMsg("\(sCurrMethodDisp)' CoreLocationModel Invoked  'self.runPostInitializationTasks()'...")
    
        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'self.jmAppDelegateVisitor' is [\(String(describing: self.jmAppDelegateVisitor))]...")
    
        return

    } // End of public func setJmAppDelegateVisitorInstance(jmAppDelegateVisitor:JmAppDelegateVisitor).

    private func runPostInitializationTasks()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'self' is [\(self)]...")

        // Finish performing any setup with the CoreLocationModel...

        self.locationManager                  = CLLocationManager()
        
        self.locationManager?.delegate        = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.headingFilter   = 0.250000                // Update when 'heading' changes by 1/4th of a degree...
    //  self.locationManager?.headingFilter   = kCLHeadingFilterNone
        
    //  self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.requestAlwaysAuthorization()
        
        self.requestLocationUpdate()

        self.bCLManagerHeadingAvailable       = CLLocationManager.headingAvailable()
        
        if (self.bCLManagerHeadingAvailable == true)
        {

            self.locationManager?.startUpdatingHeading()

        }

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of private func runPostInitializationTasks().

    public func clearLastCLLocationSettings()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        }

        // Clear the 'last' CLLocation setting(s)...

        DispatchQueue.main.async
        {

            self.clCurrentHeading              = nil
            self.clCurrentHeadingAccuracy      = -1
            self.clCurrentLocation             = nil

            self.sCurrentLocationName          = "-N/A-"
            self.sCurrentCity                  = "-N/A-"
            self.sCurrentCountry               = "-N/A-"
            self.sCurrentPostalCode            = "-N/A-"
            self.tzCurrentTimeZone             = nil
            self.clCurrentRegion               = nil
            self.sCurrentSubLocality           = "-N/A-"
            self.sCurrentThoroughfare          = "-N/A-"
            self.sCurrentSubThoroughfare       = "-N/A-"
            self.sCurrentAdministrativeArea    = "-N/A-"
            self.sCurrentSubAdministrativeArea = "-N/A-"

            self.listCoreLocationSiteItems     = [CoreLocationSiteItem]()

        }

        // Exit:

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        }
    
        return

    } // End of public func clearLastCLLocationSettings().

    public func requestNextReverseLocationLookupDeadlineInterval(clRevLocType:CLRevLocType)->Double
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'clRevLocType' is [\(clRevLocType)]...")

        }

        // Generate a 'next' ReverseLocation Dispatch time...

        var cCoreLocationReverseLookup:Int = 0

        switch(clRevLocType)
        {
        case CLRevLocType.primary:
            self.cCoreLocationReverseLookupsPrimary   += 1
            cCoreLocationReverseLookup                 = self.cCoreLocationReverseLookupsPrimary
        case CLRevLocType.secondary:
            self.cCoreLocationReverseLookupsSecondary += 1
            cCoreLocationReverseLookup                 = (20 * self.cCoreLocationReverseLookupsSecondary)
        case CLRevLocType.tertiary:
            self.cCoreLocationReverseLookupsTertiary  += 1
            cCoreLocationReverseLookup                 = (60 * self.cCoreLocationReverseLookupsTertiary)
        }

        let dblDeadlineInterval:Double    = Double((1.3 * Double(cCoreLocationReverseLookup)))

        // Exit...

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting <ReverseLocation 'lookup'> - 'dblDeadlineInterval' is (\(dblDeadlineInterval))...")

        }

        return dblDeadlineInterval
        
    }   // End of public func requestNextReverseLocationLookupDeadlineInterval(clRevLocType:CLRevLocType)->Double.
    
    public func resetNextReverseLocationLookupDeadlineInterval(clRevLocType:CLRevLocType)
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'clRevLocType' is [\(clRevLocType)]...")

        }

        // Generate a 'next' ReverseLocation Dispatch time...

        switch(clRevLocType)
        {
        case CLRevLocType.primary:
            self.cCoreLocationReverseLookupsPrimary   = 0
        case CLRevLocType.secondary:
            self.cCoreLocationReverseLookupsSecondary = 0
        case CLRevLocType.tertiary:
            self.cCoreLocationReverseLookupsTertiary  = 0
        }

        // Exit...

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        }

        return
        
    }   // End of public func resetNextReverseLocationLookupDeadlineInterval(clRevLocType:CLRevLocType).
    
    public func requestLocationUpdate()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        }
        
        DispatchQueue.main.async
        {

            self.locationManager?.requestLocation()

            self.clCurrentHeading         = self.locationManager?.heading
            self.clCurrentHeadingAccuracy = self.clCurrentHeading?.headingAccuracy ?? 0.000000
            
        //  self.locationManager?.startUpdatingLocation()

        }

        // Exit...

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        }

        return
        
    }   // End of public func requestLocationUpdate().
    
    public func stopLocationUpdate()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        }
        
        self.locationManager?.stopUpdatingLocation()
        
        // Exit...

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        }

        return
        
    }   // End of public func stopLocationUpdate().
    
    public func updateGeocoderLocation(latitude:Double, longitude:Double)->Bool
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'latitude' is (\(latitude)) - 'longitude' is (\(longitude))...")

        }

        // Instantiate a CLGeocoder and attempt to convert latitude/longitude into an address...

        self.clearLastCLLocationSettings()
        
        let clGeocoder:CLGeocoder      = CLGeocoder()
        let currentLocation:CLLocation = CLLocation(latitude:latitude, longitude:longitude)
        
        clGeocoder.reverseGeocodeLocation(currentLocation, completionHandler: 
            { (placemarks, error) in

                if error == nil 
                {

                    let firstLocation                  = placemarks?[0]

                    self.clCurrentLocation             = firstLocation?.location
                    self.clCurrentHeadingAccuracy      = self.clCurrentHeading?.headingAccuracy ?? 0.000000
                    self.sCurrentLocationName          = firstLocation?.name                    ?? "-N/A-"
                    self.sCurrentCity                  = firstLocation?.locality                ?? "-N/A-"
                    self.sCurrentCountry               = firstLocation?.country                 ?? "-N/A-"
                    self.sCurrentPostalCode            = firstLocation?.postalCode              ?? "-N/A-"
                    self.tzCurrentTimeZone             = firstLocation?.timeZone
                    self.clCurrentRegion               = firstLocation?.region
                    self.sCurrentSubLocality           = firstLocation?.subLocality             ?? "-N/A-"
                    self.sCurrentThoroughfare          = firstLocation?.thoroughfare            ?? "-N/A-"
                    self.sCurrentSubThoroughfare       = firstLocation?.subThoroughfare         ?? "-N/A-"
                    self.sCurrentAdministrativeArea    = firstLocation?.administrativeArea      ?? "-N/A-"
                    self.sCurrentSubAdministrativeArea = firstLocation?.subAdministrativeArea   ?? "-N/A-"

                    let _ = self.updateCoreLocationSiteItemList()

                    if (self.bInternalTraceFlag == true)
                    {

                        self.xcgLogMsg("\(sCurrMethodDisp) CLGeocoder 'reverseGeocodeLocation()' returned a 'location' of [\(self.sCurrentLocationName)]/[\(self.sCurrentCity)]...")

                    }

                }
                else 
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) CLGeocoder 'reverseGeocodeLocation()' failed to return a 'location' - Details: [\(String(describing: error))] - Error!")

                    self.clearLastCLLocationSettings()

                }

                // Exit...

                if (self.bInternalTraceFlag == true)
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

                }

                return

            }

        )

        // Exit...

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - returning 'true'...")

        }
    
        return true
        
    }   // End of public func updateGeocoderLocations().

    public func updateGeocoderLocations(requestID:Int = 1, latitude:Double, longitude:Double, withCompletionHandler completionHandler:@escaping(_ requestID:Int, _ dictCurrentLocation:[String:Any])->Void)->Bool
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'requestID' is (\(requestID)) - 'latitude' is (\(latitude)) - 'longitude' is (\(longitude))...")

        }
    
        var bGeocoderSuccessful:Bool   = false

        // Instantiate a CLGeocoder and attempt to convert latitude/longitude into an address...

        self.clearLastCLLocationSettings()
        
        let clGeocoder:CLGeocoder      = CLGeocoder()
        let currentLocation:CLLocation = CLLocation(latitude:latitude, longitude:longitude)
        
        clGeocoder.reverseGeocodeLocation(currentLocation, completionHandler: 
            { (placemarks, error) in

                var dictCurrentLocation:[String:Any]   = [:]

                dictCurrentLocation["iRequestID"]      = "\(requestID)"
                dictCurrentLocation["sRequestError"]   = ""
                dictCurrentLocation["sRequestAddress"] = ""
                dictCurrentLocation["dblLatitude"]     = "\(latitude)"
                dictCurrentLocation["dblLongitude"]    = "\(longitude)"

                if error == nil 
                {

                    let firstLocation                  = placemarks?[0]

                    self.clCurrentLocation             = firstLocation?.location
                    self.clCurrentHeadingAccuracy      = self.clCurrentHeading?.headingAccuracy ?? 0.000000
                    self.sCurrentLocationName          = firstLocation?.name                    ?? "-N/A-"
                    self.sCurrentCity                  = firstLocation?.locality                ?? "-N/A-"
                    self.sCurrentCountry               = firstLocation?.country                 ?? "-N/A-"
                    self.sCurrentPostalCode            = firstLocation?.postalCode              ?? "-N/A-"
                    self.tzCurrentTimeZone             = firstLocation?.timeZone
                    self.clCurrentRegion               = firstLocation?.region
                    self.sCurrentSubLocality           = firstLocation?.subLocality             ?? "-N/A-"
                    self.sCurrentThoroughfare          = firstLocation?.thoroughfare            ?? "-N/A-"
                    self.sCurrentSubThoroughfare       = firstLocation?.subThoroughfare         ?? "-N/A-"
                    self.sCurrentAdministrativeArea    = firstLocation?.administrativeArea      ?? "-N/A-"
                    self.sCurrentSubAdministrativeArea = firstLocation?.subAdministrativeArea   ?? "-N/A-"

                    let _ = self.updateCoreLocationSiteItemList()

                    dictCurrentLocation["clCurrentLocation"]             = self.clCurrentLocation
                    dictCurrentLocation["clCurrentHeadingAccuracy"]      = self.clCurrentHeadingAccuracy

                    dictCurrentLocation["sCurrentLocationName"]          = self.sCurrentLocationName         
                    dictCurrentLocation["sCurrentCity"]                  = self.sCurrentCity                 
                    dictCurrentLocation["sCurrentCountry"]               = self.sCurrentCountry              
                    dictCurrentLocation["sCurrentPostalCode"]            = self.sCurrentPostalCode           
                    dictCurrentLocation["tzCurrentTimeZone"]             = self.tzCurrentTimeZone            
                    dictCurrentLocation["clCurrentRegion"]               = self.clCurrentRegion              
                    dictCurrentLocation["sCurrentSubLocality"]           = self.sCurrentSubLocality          
                    dictCurrentLocation["sCurrentThoroughfare"]          = self.sCurrentThoroughfare         
                    dictCurrentLocation["sCurrentSubThoroughfare"]       = self.sCurrentSubThoroughfare      
                    dictCurrentLocation["sCurrentAdministrativeArea"]    = self.sCurrentAdministrativeArea   
                    dictCurrentLocation["sCurrentSubAdministrativeArea"] = self.sCurrentSubAdministrativeArea

                    var sLocationAddress:String = ""
                    let sStreetAddress:String   = String(describing: (dictCurrentLocation["sCurrentLocationName"]       ?? ""))
                    let sCity:String            = String(describing: (dictCurrentLocation["sCurrentCity"]               ?? ""))
                    let sState:String           = String(describing: (dictCurrentLocation["sCurrentAdministrativeArea"] ?? ""))
                    let sZipCode:String         = String(describing: (dictCurrentLocation["sCurrentPostalCode"]         ?? ""))

                    if (sStreetAddress.count < 1 ||
                        sCity.count          < 1)
                    {

                        sLocationAddress = "-N/A-"

                    }
                    else
                    {

                        sLocationAddress = "\(sStreetAddress), \(sCity), \(sState), \(sZipCode)"

                    }

                    dictCurrentLocation["sCurrentLocationAddress"] = sLocationAddress         

                    if (self.bInternalTraceFlag == true)
                    {

                        self.xcgLogMsg("\(sCurrMethodDisp) CLGeocoder 'reverseGeocodeLocation()' returned a 'location' of [\(self.sCurrentLocationName)]/[\(self.sCurrentCity)]...")

                    }

                    bGeocoderSuccessful = true

                }
                else 
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) CLGeocoder 'reverseGeocodeLocation()' failed to return a 'location' - Details: [\(String(describing: error))] - Error!")

                    self.clearLastCLLocationSettings()

                    dictCurrentLocation["sRequestError"] = "CLGeocoder 'reverseGeocodeLocation()' failed to return a 'location' - Details: [\(String(describing: error))] - Error!"

                    bGeocoderSuccessful = false

                }

                // Exit...

                completionHandler(requestID, dictCurrentLocation)

                if (self.bInternalTraceFlag == true)
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'bGeocoderSuccessful' is [\(bGeocoderSuccessful)]...")

                }

                return

            }

        )

        // Exit...

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - returning 'true'...")

        }
    
        return true
        
    }   // End of public func updateGeocoderLocations(requestID:Int, latitude:Double, longitude:Double, withCompletionHandler completionHandler:@escaping(_ requestID:Int, _ dictCurrentLocation:[String:Any])->Void)->Bool

    public func updateGeocoderFromAddress(requestID:Int = 1, address:String = "", withCompletionHandler completionHandler:@escaping(_ requestID:Int, _ dictCurrentLocation:[String:Any])->Void)->Bool
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'requestID' is (\(requestID)) - 'address' is [\(address)]...")

        }
    
        var bGeocoderSuccessful:Bool   = false

        // If we don't have an actual address, then just return...

        if (address.count < 1)
        {
        
            let dictCurrentLocation:[String:Any] = [:]

            completionHandler(requestID, dictCurrentLocation)

            if (self.bInternalTraceFlag == true)
            {

                self.xcgLogMsg("\(sCurrMethodDisp) Exiting - supplied 'address' is [\(address)] is an empty string - 'bGeocoderSuccessful' is [\(bGeocoderSuccessful)]...")

            }

            return bGeocoderSuccessful
        
        }

        // Instantiate a CLGeocoder and attempt to convert latitude/longitude into an address...

        self.clearLastCLLocationSettings()
        
        let clGeocoder:CLGeocoder      = CLGeocoder()
    //  let currentLocation:CLLocation = CLLocation(latitude:latitude, longitude:longitude)
        
    //  clGeocoder.reverseGeocodeLocation(currentLocation, completionHandler: 
        clGeocoder.geocodeAddressString(address) 
            { (placemarks, error) in

                var dictCurrentLocation:[String:Any]   = [:]

                dictCurrentLocation["iRequestID"]      = "\(requestID)"
                dictCurrentLocation["sRequestError"]   = ""
                dictCurrentLocation["sRequestAddress"] = "\(address)"

                if error == nil 
                {

                    let firstLocation                  = placemarks?[0]

                    self.clCurrentLocation             = firstLocation?.location
                    self.clCurrentHeadingAccuracy      = self.clCurrentHeading?.headingAccuracy       ?? 0.000000

                    let latitude:Double                = self.clCurrentLocation?.coordinate.latitude  ?? 0.000000
                    let longitude:Double               = self.clCurrentLocation?.coordinate.longitude ?? 0.000000

                    self.sCurrentLocationName          = firstLocation?.name                    ?? "-N/A-"
                    self.sCurrentCity                  = firstLocation?.locality                ?? "-N/A-"
                    self.sCurrentCountry               = firstLocation?.country                 ?? "-N/A-"
                    self.sCurrentPostalCode            = firstLocation?.postalCode              ?? "-N/A-"
                    self.tzCurrentTimeZone             = firstLocation?.timeZone
                    self.clCurrentRegion               = firstLocation?.region
                    self.sCurrentSubLocality           = firstLocation?.subLocality             ?? "-N/A-"
                    self.sCurrentThoroughfare          = firstLocation?.thoroughfare            ?? "-N/A-"
                    self.sCurrentSubThoroughfare       = firstLocation?.subThoroughfare         ?? "-N/A-"
                    self.sCurrentAdministrativeArea    = firstLocation?.administrativeArea      ?? "-N/A-"
                    self.sCurrentSubAdministrativeArea = firstLocation?.subAdministrativeArea   ?? "-N/A-"

                    let _ = self.updateCoreLocationSiteItemList()

                    dictCurrentLocation["dblLatitude"]                   = "\(latitude)"
                    dictCurrentLocation["dblLongitude"]                  = "\(longitude)"

                    dictCurrentLocation["clCurrentLocation"]             = self.clCurrentLocation
                    dictCurrentLocation["clCurrentHeadingAccuracy"]      = self.clCurrentHeadingAccuracy

                    dictCurrentLocation["sCurrentLocationName"]          = self.sCurrentLocationName         
                    dictCurrentLocation["sCurrentCity"]                  = self.sCurrentCity                 
                    dictCurrentLocation["sCurrentCountry"]               = self.sCurrentCountry              
                    dictCurrentLocation["sCurrentPostalCode"]            = self.sCurrentPostalCode           
                    dictCurrentLocation["tzCurrentTimeZone"]             = self.tzCurrentTimeZone            
                    dictCurrentLocation["clCurrentRegion"]               = self.clCurrentRegion              
                    dictCurrentLocation["sCurrentSubLocality"]           = self.sCurrentSubLocality          
                    dictCurrentLocation["sCurrentThoroughfare"]          = self.sCurrentThoroughfare         
                    dictCurrentLocation["sCurrentSubThoroughfare"]       = self.sCurrentSubThoroughfare      
                    dictCurrentLocation["sCurrentAdministrativeArea"]    = self.sCurrentAdministrativeArea   
                    dictCurrentLocation["sCurrentSubAdministrativeArea"] = self.sCurrentSubAdministrativeArea

                    var sLocationAddress:String = ""
                    let sStreetAddress:String   = String(describing: (dictCurrentLocation["sCurrentLocationName"]       ?? ""))
                    let sCity:String            = String(describing: (dictCurrentLocation["sCurrentCity"]               ?? ""))
                    let sState:String           = String(describing: (dictCurrentLocation["sCurrentAdministrativeArea"] ?? ""))
                    let sZipCode:String         = String(describing: (dictCurrentLocation["sCurrentPostalCode"]         ?? ""))

                    if (sStreetAddress.count < 1 ||
                        sCity.count          < 1)
                    {

                        sLocationAddress = "-N/A-"

                    }
                    else
                    {

                        sLocationAddress = "\(sStreetAddress), \(sCity), \(sState), \(sZipCode)"

                    }

                    dictCurrentLocation["sCurrentLocationAddress"] = sLocationAddress         

                    if (self.bInternalTraceFlag == true)
                    {

                        self.xcgLogMsg("\(sCurrMethodDisp) CLGeocoder 'reverseGeocodeLocation()' returned a 'location' of [\(self.sCurrentLocationName)]/[\(self.sCurrentCity)]...")

                    }

                    bGeocoderSuccessful = true

                }
                else 
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) CLGeocoder 'reverseGeocodeLocation()' failed to return a 'location' - Details: [\(String(describing: error))] - Error!")

                    self.clearLastCLLocationSettings()

                    dictCurrentLocation["sRequestError"] = "CLGeocoder 'reverseGeocodeLocation()' failed to return a 'location' - Details: [\(String(describing: error))] - Error!"

                    bGeocoderSuccessful = false

                }

                // Exit...

                completionHandler(requestID, dictCurrentLocation)

                if (self.bInternalTraceFlag == true)
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'bGeocoderSuccessful' is [\(bGeocoderSuccessful)]...")

                }

                return

            }

        // Exit...

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - returning 'true'...")

        }
    
        return true
        
    }   // End of public func public func updateGeocoderFromAddress(requestID:Int = 1, address:String = "", withCompletionHandler completionHandler:@escaping(_ requestID:Int, _ dictCurrentLocation:[String:Any])->Void)->Bool.

    public func updateCoreLocationSiteItemList()->Bool
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        }
    
        // Build the CoreLocationSiteItem(s) list...

        self.listCoreLocationSiteItems = []
        
        self.listCoreLocationSiteItems.append(CoreLocationSiteItem(sCLSiteItemName:   "Location",
                                                               //  sCLSiteItemDesc:   "(Latitude,Longitude)",
                                                                   sCLSiteItemDesc:   "\(String(describing:self.clCurrentLocation))",
                                                                   sCLSiteItemValue:  "\(String(describing:self.clCurrentLocation))",
                                                                   objCLSiteItemValue:self.clCurrentLocation))

        self.listCoreLocationSiteItems.append(CoreLocationSiteItem(sCLSiteItemName:   "Location Accuracy",
                                                                   sCLSiteItemDesc:   "\(String(describing:self.clCurrentHeadingAccuracy))",
                                                                   sCLSiteItemValue:  "\(String(describing:self.clCurrentHeadingAccuracy))",
                                                                   objCLSiteItemValue:self.clCurrentHeadingAccuracy))

        self.listCoreLocationSiteItems.append(CoreLocationSiteItem(sCLSiteItemName:   "Street Address",
                                                                   sCLSiteItemDesc:   "\(String(describing:self.sCurrentLocationName))"))

        self.listCoreLocationSiteItems.append(CoreLocationSiteItem(sCLSiteItemName:   "City",
                                                                   sCLSiteItemDesc:   "\(String(describing:self.sCurrentCity))"))

        self.listCoreLocationSiteItems.append(CoreLocationSiteItem(sCLSiteItemName:   "Zip Code",
                                                                   sCLSiteItemDesc:   "\(String(describing:self.sCurrentPostalCode))"))

        self.listCoreLocationSiteItems.append(CoreLocationSiteItem(sCLSiteItemName:   "County",
                                                                   sCLSiteItemDesc:   "\(String(describing:self.sCurrentSubAdministrativeArea))"))

        self.listCoreLocationSiteItems.append(CoreLocationSiteItem(sCLSiteItemName:   "State",
                                                                   sCLSiteItemDesc:   "\(String(describing:self.sCurrentAdministrativeArea))"))

        self.listCoreLocationSiteItems.append(CoreLocationSiteItem(sCLSiteItemName:   "TimeZone",
                                                                   sCLSiteItemDesc:   "\(String(describing:(self.tzCurrentTimeZone ?? TimeZone(abbreviation:"CST"))))",
                                                                   sCLSiteItemValue:  "\(String(describing:(self.tzCurrentTimeZone ?? TimeZone(abbreviation:"CST"))))",
                                                                   objCLSiteItemValue:self.tzCurrentTimeZone))

        self.listCoreLocationSiteItems.append(CoreLocationSiteItem(sCLSiteItemName:   "Country",
                                                                   sCLSiteItemDesc:   "\(String(describing:self.sCurrentCountry))"))

        self.listCoreLocationSiteItems.append(CoreLocationSiteItem(sCLSiteItemName:   "Street Name",
                                                                   sCLSiteItemDesc:   "\(String(describing:self.sCurrentThoroughfare))"))

        self.listCoreLocationSiteItems.append(CoreLocationSiteItem(sCLSiteItemName:   "Building #",
                                                                   sCLSiteItemDesc:   "\(String(describing:self.sCurrentSubThoroughfare))"))

        self.listCoreLocationSiteItems.append(CoreLocationSiteItem(sCLSiteItemName:   "Sub Locality",
                                                                   sCLSiteItemDesc:   "\(String(describing:self.sCurrentSubLocality))"))

        self.listCoreLocationSiteItems.append(CoreLocationSiteItem(sCLSiteItemName:   "Region",
                                                               //  sCLSiteItemDesc:   "-N/A-",
                                                                   sCLSiteItemDesc:   "\(String(describing:self.clCurrentRegion))",
                                                                   sCLSiteItemValue:  "\(String(describing:self.clCurrentRegion))",
                                                                   objCLSiteItemValue:self.clCurrentRegion))

        // Exit...

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        }
    
        return true

    }   // End of public func updateCoreLocationSiteItemList()->Bool.
    
    func locationManager(_ manager:CLLocationManager, didUpdateHeading heading:CLHeading)
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        }
        
        self.clCurrentHeading         = heading
        self.clCurrentHeadingAccuracy = self.clCurrentHeading?.headingAccuracy ?? 0.000000
        
        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("headingAccuracy: [\(self.clCurrentHeadingAccuracy)], magneticHeading: [[\(self.clCurrentHeading!.magneticHeading)], trueHeading: [\(self.clCurrentHeading!.trueHeading)], timestamp: [\(self.clCurrentHeading!.timestamp)]...")

        }
        
        // Exit...

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        }

        return
        
    }   // End of func locationManager(_ manager:CLLocationManager, didUpdateHeading heading:CLHeading).
    
    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations:[CLLocation])
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        }
        
        guard let location = locations.last
        else { return }
        
        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")

        }
        
        // Exit...

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        }
    
        return
        
    }   // End of func locationManager(_ manager:CLLocationManager, didUpdateLocations locations:[CLLocation]).
    
    func locationManager(_ manager:CLLocationManager, didFailWithError error:Error)
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
        
        self.locationManager?.stopUpdatingLocation()
        
        if let clErr = error as? CLError
        {
            
            switch clErr.code
            {
                
            case .locationUnknown, .denied, .network:
                
                self.xcgLogMsg("\(sCurrMethodDisp) Location request failed with error: \(clErr.localizedDescription)...")
                
            case .headingFailure:
                
                self.xcgLogMsg("\(sCurrMethodDisp) Heading request failed with error: \(clErr.localizedDescription)...")
                
            case .rangingUnavailable, .rangingFailure:
                
                self.xcgLogMsg("\(sCurrMethodDisp) Ranging request failed with error: \(clErr.localizedDescription)...")
                
            case .regionMonitoringDenied, .regionMonitoringFailure, .regionMonitoringSetupDelayed, .regionMonitoringResponseDelayed:
                
                self.xcgLogMsg("\(sCurrMethodDisp) Region monitoring request failed with error: \(clErr.localizedDescription)...")
                
            default:
                
                self.xcgLogMsg("\(sCurrMethodDisp) Unknown 'location manager' request failed with error: \(clErr.localizedDescription)...")
                
            }
            
        }
        else
        {
            
            self.xcgLogMsg("\(sCurrMethodDisp) Unknown error occurred while handling the 'location manager' request failed with error: \(error.localizedDescription)...")
            
        }
        
        // Exit...

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return
        
    }   // End of func locationManager(_ manager:CLLocationManager, didFailWithError error:Error).
    
    func locationManagerDidChangeAuthorization(_ manager:CLLocationManager)
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
        
        switch manager.authorizationStatus
        {
            
        case .notDetermined:
            
            self.xcgLogMsg("\(sCurrMethodDisp) The User has NOT yet determined authorization...")
            
        case .restricted:
            
            self.xcgLogMsg("\(sCurrMethodDisp) Authorization is RESTRICTED by Parental control...")
            
        case .denied:
            
            self.xcgLogMsg("\(sCurrMethodDisp) The User has selected 'Do NOT Allow' (denied)...")
            
        case .authorizedAlways:
            
            self.xcgLogMsg("\(sCurrMethodDisp) The User has changed the selection to 'Always Allow'...")
            
        case .authorizedWhenInUse:
            
            self.xcgLogMsg("\(sCurrMethodDisp) The User has selected 'Allow while Using' or 'Allow Once'...")
            
            self.locationManager?.requestAlwaysAuthorization()
            
        default:
            
            self.xcgLogMsg("\(sCurrMethodDisp) This is the 'default' option...")
            
        }
        
        // Exit...

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return
        
    }   // End of func locationManagerDidChangeAuthorization(_ manager:CLLocationManager).

    func locationManagerShouldDisplayHeadingCalibration(_ manager:CLLocationManager)->Bool
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
        
        // Exit - returning 'true' to show the 'heading' Calibration when needed...

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return true
        
    }   // End of func locationManagerShouldDisplayHeadingCalibration(_ manager:CLLocationManager)->Bool.

}   // End of class CoreLocationModelObservable2:NSObject, CLLocationManagerDelegate, ObservableObject.

