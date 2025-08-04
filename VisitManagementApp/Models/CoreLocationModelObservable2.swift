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
        static let sClsVers      = "v1.1803"
        static let sClsDisp      = sClsId+"(.swift).("+sClsVers+"):"
        static let sClsCopyRight = "Copyright (C) JustMacApps 2023-2025. All Rights Reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }

    // Class 'singleton' instance:

    struct ClassSingleton
    {
        static var appCoreLocationModel:CoreLocationModelObservable2 = CoreLocationModelObservable2()
    }

    // 'Internal' Trace flag:

    private 
    var bInternalTraceFlag:Bool                                      = false

    // App Data field(s):

               var cCoreLocationReverseLookupsPrimary:Int            = 0
               var cCoreLocationReverseLookupsSecondary:Int          = 0
               var cCoreLocationReverseLookupsTertiary:Int           = 0
    
               var locationManager:CLLocationManager?                = nil
    @Published var clCurrentLocation:CLLocation?                     = nil       // Contains: Latitude, Longitude...

    @Published var clAuthorizationStatus:CLAuthorizationStatus       = .notDetermined
    @Published var clLocationAccuracy:CLLocationAccuracy             = 0.000000
    @Published var clLocationLastUpdateTimestamp:Date                = Date()
    @Published var clLocationGPSTolerance:Double                     = 1e-10     // GPS location (double) tollerance...

    @Published var bCLLocationUpdateIsPossiblyThrottling:Bool        = false
               var clLocationPendingRequestsTimestamps:[UUID:Date]   = [UUID:Date]()
               var clLocationRequestsResponseTimes:[TimeInterval]    = [TimeInterval]()
               let clLocationMaxResponseTimeHistory:Int              = 20
               let clLocationMaxRequestIsStale:TimeInterval          = 20.0000
    @Published var clLocationRequestAverageResponseTime:TimeInterval = 0.0000
    @Published var cLocationRequestsTotal:Int                        = 0

    @Published var bCLManagerHeadingAvailable:Bool                   = false
    @Published var clCurrentHeading:CLHeading?                       = nil
    @Published var clCurrentHeadingAccuracy:CLLocationDirection      = -1

    @Published var sCurrentLocationName:String                       = "-N/A-"   // This is actually the Street Address (Line #1) <# Street> (i.e. 8908 Michelle Ln)...
    @Published var sCurrentCity:String                               = "-N/A-"   // City (i.e. North Richland Hills)...
    @Published var sCurrentCountry:String                            = "-N/A-"   // Country (i.e. United States)...
    @Published var sCurrentPostalCode:String                         = "-N/A-"   // Zip Code (i.e. 76182) (Zip-5)...
    @Published var tzCurrentTimeZone:TimeZone?                       = nil       // This is TimeZone in English (i.e. 'America/Chicago')...
    @Published var clCurrentRegion:CLRegion?                         = nil       // ???
    @Published var sCurrentSubLocality:String                        = "-N/A-"   // ??? 
    @Published var sCurrentThoroughfare:String                       = "-N/A-"   // Street Name (Michelle Ln)...
    @Published var sCurrentSubThoroughfare:String                    = "-N/A-"   // Address (Building) # (i.e. 8908)...
    @Published var sCurrentAdministrativeArea:String                 = "-N/A-"   // State  (i.e. TX)...
    @Published var sCurrentSubAdministrativeArea:String              = "-N/A-"   // County (i.e. Tarrant County)

    @Published var listCoreLocationSiteItems:[CoreLocationSiteItem]  = [CoreLocationSiteItem]()
                                                                                 // List of the 'current' Location Site Item(s)
                                                                                 //      as CoreLocationSiteItem(s)...
    
               var jmAppDelegateVisitor:JmAppDelegateVisitor?        = nil
                                                                                 // 'jmAppDelegateVisitor' MUST remain declared this way
                                                                                 // as having it reference the 'shared' instance of 
                                                                                 // JmAppDelegateVisitor causes a circular reference
                                                                                 // between the 'init()' methods of the 2 classes...

    // App <global> Message(s) 'stack' cached before XCGLogger is available:

               var listPreXCGLoggerMessages:[String]                 = Array()

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
        asToString.append("'clCurrentLocation': [\(String(describing: self.clCurrentLocation))]")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'clAuthorizationStatus': [\(String(describing: self.clAuthorizationStatus))],")
        asToString.append("'clLocationAccuracy': (\(String(describing: self.clLocationAccuracy))),")
        asToString.append("'clLocationLastUpdateTimestamp': [\(String(describing: self.clLocationLastUpdateTimestamp))],")
        asToString.append("'clLocationGPSTolerance': [\(String(describing: self.clLocationGPSTolerance))],")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'bCLLocationUpdateIsPossiblyThrottling': [\(String(describing: self.bCLLocationUpdateIsPossiblyThrottling))],")
        asToString.append("'clLocationPendingRequestsTimestamps': [\(String(describing: self.clLocationPendingRequestsTimestamps))],")
        asToString.append("'clLocationRequestsResponseTimes': [\(String(describing: self.clLocationRequestsResponseTimes))],")
        asToString.append("'clLocationMaxResponseTimeHistory': (\(String(describing: self.clLocationMaxResponseTimeHistory))),")
        asToString.append("'clLocationMaxRequestIsStale': (\(String(describing: self.clLocationMaxRequestIsStale))),")
        asToString.append("'clLocationRequestAverageResponseTime': (\(String(describing: self.clLocationRequestAverageResponseTime))),")
        asToString.append("'cLocationRequestsTotal': (\(String(describing: self.cLocationRequestsTotal))),")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'bCLManagerHeadingAvailable': [\(String(describing: self.bCLManagerHeadingAvailable))],")
        asToString.append("'clCurrentHeading': [\(String(describing: self.clCurrentHeading))],")
        asToString.append("'clCurrentHeadingAccuracy': [\(String(describing: self.clCurrentHeadingAccuracy))],")
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

    public func startCLLocationUpdateRequest(latitude:Double = 0.000000, longitude:Double = 0.000000, address:String = "")->UUID
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        if (self.bInternalTraceFlag == true)
        {
            self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
        }

        // Record the start of a CLLocation update request...

        self.cLocationRequestsTotal    += 1
        let uuidCLLocationRequest:UUID  = UUID()
        let dateNow:Date                = Date()

        self.clLocationPendingRequestsTimestamps[uuidCLLocationRequest] = dateNow

        // Check for and clean-up any 'stale' CLLocation 'pending' request(s)...

        self.clLocationPendingRequestsTimestamps = 
            self.clLocationPendingRequestsTimestamps.filter
            { _, dateClLocationRequestStart in

                dateNow.timeIntervalSince(dateClLocationRequestStart) < self.clLocationMaxRequestIsStale

            }
 
        // Exit:

        if (self.bInternalTraceFlag == true)
        {
            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'uuidCLLocationRequest' is [\(uuidCLLocationRequest)] - starting 'dateNow' is [\(dateNow)]...")
        }
    
        return uuidCLLocationRequest

    }   // End of public func startCLLocationUpdateRequest()->UUID.

    public func stopCLLocationUpdateRequest(uuidCLLocationRequest:UUID, dictCurrentLocation:[String:Any])->TimeInterval
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        if (self.bInternalTraceFlag == true)
        {
            self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'uuidCLLocationRequest' is [\(uuidCLLocationRequest)]...")
        }

        // Record the stop of a CLLocation update request...

        guard let dateClLocationRequestStart = self.clLocationPendingRequestsTimestamps.removeValue(forKey:uuidCLLocationRequest)
        else { return 0.0000 }
        
        let tiClLocationRequest = Date().timeIntervalSince(dateClLocationRequestStart)

        self.recordCLLocationUpdateResponseTime(tiClLocationRequest:tiClLocationRequest, dictCurrentLocation:dictCurrentLocation)

        // Exit:

        if (self.bInternalTraceFlag == true)
        {
            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'uuidCLLocationRequest' is [\(uuidCLLocationRequest)] - response time 'tiClLocationRequest' is [\(tiClLocationRequest)]...")
        }
    
        return tiClLocationRequest

    }   // End of public func stopCLLocationUpdateRequest(uuidCLLocationRequest:UUID)->TimeInterval.

    private func recordCLLocationUpdateResponseTime(tiClLocationRequest:TimeInterval, dictCurrentLocation:[String:Any])
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        if (self.bInternalTraceFlag == true)
        {
            self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'tiClLocationRequest' is [\(tiClLocationRequest)]...")
        }

        // Record the CLLocation update request 'response' time (interval)...

        self.clLocationRequestsResponseTimes.append(tiClLocationRequest)

        // Keep only a Max # of 'response' times...

        if (self.clLocationRequestsResponseTimes.count > self.clLocationMaxResponseTimeHistory)
        {
            self.clLocationRequestsResponseTimes.removeFirst()
        }

        // If we have any 'response' times, calculate the average 'response' time...

        guard !self.clLocationRequestsResponseTimes.isEmpty 
        else { return }

        self.clLocationRequestAverageResponseTime = 
            (self.clLocationRequestsResponseTimes.reduce(0, +) / Double(self.clLocationRequestsResponseTimes.count))
                
        self.xcgLogMsg("\(sCurrMethodDisp) Intermediate <CLRequest> 'self.clLocationRequestAverageResponseTime' is (\(self.clLocationRequestAverageResponseTime))...")

        // We don't check for 'throttling' unless we have enough 'response' times...

        guard self.clLocationRequestsResponseTimes.count >= 5
        else { return }
        
        // Normal location 'responses' should be < 1 second,
        //     if average 'response' time > 2 seconds, likely throttled...

        self.bCLLocationUpdateIsPossiblyThrottling = self.clLocationRequestAverageResponseTime > 2.0
        
        self.xcgLogMsg("\(sCurrMethodDisp) Intermediate <CLThrottling> #1 'self.bCLLocationUpdateIsPossiblyThrottling' is [\(self.bCLLocationUpdateIsPossiblyThrottling)]...")
        
        // Alternative: Check if recent 'responses' are significantly slower
        //     than earlier ones (indicating progressive throttling)...

        if (self.clLocationRequestsResponseTimes.count >= 10)
        {
            let recentAverage  = (Array(self.clLocationRequestsResponseTimes.suffix(5)).reduce(0, +) / 5.0)
            let earlierAverage = (Array(self.clLocationRequestsResponseTimes.prefix(5)).reduce(0, +) / 5.0)
            
            // If recent responses are 3x slower than earlier ones...

            if (recentAverage > (earlierAverage * 3.0) &&
                recentAverage > 1.0000)
            {
                self.bCLLocationUpdateIsPossiblyThrottling = true

                self.xcgLogMsg("\(sCurrMethodDisp) Intermediate <CLThrottling> #2 'self.bCLLocationUpdateIsPossiblyThrottling' is [\(self.bCLLocationUpdateIsPossiblyThrottling)]...")
            }
        }

        // Exit:

        if (self.bInternalTraceFlag == true)
        {
            self.xcgLogMsg("\(sCurrMethodDisp) Exiting <CLRequest> - recorded response time 'tiClLocationRequest' was [\(tiClLocationRequest)]...")
        }
    
        return

    }   // End of private func recordCLLocationUpdateResponseTime(tiClLocationRequest:TimeInterval).

//  public func recordLastCLLocationUpdate()
//  {
//      
//      let sCurrMethod:String = #function
//      let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
//      
//      if (self.bInternalTraceFlag == true)
//      {
//          self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
//      }
//
//      // Record the 'last' CLLocation update...
//
//      let dateNow:Date = Date()
//
//      self.clLocationUpdateTimestamps.append(dateNow)
//
//      // Keep ONLY the last 10 'update' timestamps...
//
//      if (self.clLocationUpdateTimestamps.count > 10)
//      {
//          self.clLocationUpdateTimestamps.removeFirst()
//      }
//
//      // If we have enough 'update' timestamps, check for 'possible' throttling...
//
//      guard self.clLocationUpdateTimestamps.count >= 3
//      else { return }
//
//      let intervals       = zip(self.clLocationUpdateTimestamps,
//                                self.clLocationUpdateTimestamps.dropFirst()).map { $1.timeIntervalSince($0) }
//      let averageInterval = (intervals.reduce(0, +) / Double(intervals.count))
//      
//      // If average interval is much longer than requested interval (10.0), CLLocation 'updates' might be throttled...
//
//      self.bCLLocationUpdateIsPossiblyThrottling = (averageInterval > 10.0)       // Adjust threshold as needed...
//
//      self.xcgLogMsg("\(sCurrMethodDisp) Intermediate <CLThrottling> 'self.bCLLocationUpdateIsPossiblyThrottling' is [\(self.bCLLocationUpdateIsPossiblyThrottling)]...")
//
//      // Exit:
//
//      if (self.bInternalTraceFlag == true)
//      {
//          self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
//      }
//  
//      return
//
//  } // End of public func recordLastCLLocationUpdate().

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

        let bIsLatitudeNearlyZero:Bool  = self.isDoubleValueNearlyZero(dblValue:latitude)
        let bIsLongitudeNearlyZero:Bool = self.isDoubleValueNearlyZero(dblValue:longitude)

        if (self.bInternalTraceFlag == true)
        {
            self.xcgLogMsg("\(sCurrMethodDisp) <CLRequest> Invoked - 'latitude' is (\(latitude)) <'nearly' Zero [\(bIsLatitudeNearlyZero)]> - 'longitude' is (\(longitude)) <'nearly' Zero [\(bIsLongitudeNearlyZero)]>...")
        }

        // If the Latitude/Longitude values are 'nearly' Zero, then return a 'dummy' dictionary to the completionHandler...

        var bGeocoderSuccessful:Bool = false

        self.clearLastCLLocationSettings()

        if (bIsLatitudeNearlyZero  == true &&
            bIsLongitudeNearlyZero == true)
        {
            // Exit...

            bGeocoderSuccessful = true

        //  OOOPS: There are NO 'requestID' nor 'completionHandler()' parameters in this method...
        //
        //  completionHandler(requestID, self.generateANearlyZeroCurrentLocationDictionary())

            if (self.bInternalTraceFlag == true)
            {
                self.xcgLogMsg("\(sCurrMethodDisp) Exiting <CLRequest> - 'dummy' dictionary - 'bGeocoderSuccessful' is [\(bGeocoderSuccessful)]...")
            }

            return bGeocoderSuccessful
        }

        // Instantiate a CLGeocoder and attempt to convert latitude/longitude into an address...

        let clGeocoder:CLGeocoder      = CLGeocoder()
        let currentLocation:CLLocation = CLLocation(latitude:latitude, longitude:longitude)

        let uuidCLLocationRequest:UUID = self.startCLLocationUpdateRequest(latitude:latitude, longitude:longitude)
        
        clGeocoder.reverseGeocodeLocation(currentLocation, completionHandler: 
            { (placemarks, error) in

            //  let _ = self.stopCLLocationUpdateRequest(uuidCLLocationRequest:uuidCLLocationRequest)

                var dictCurrentLocation:[String:Any]   = [String:Any]()

                dictCurrentLocation["iRequestID"]      = "0"
                dictCurrentLocation["sRequestError"]   = ""
                dictCurrentLocation["sRequestAddress"] = ""
                dictCurrentLocation["dblLatitude"]     = "\(latitude)"
                dictCurrentLocation["dblLongitude"]    = "\(longitude)"

                if error == nil 
                {
                    let firstLocation                  = placemarks?[0]

                    self.clCurrentLocation             = firstLocation?.location
                    self.clCurrentHeadingAccuracy      = self.clCurrentHeading?.headingAccuracy       ?? 0.000000

                    let latitude:Double                = self.clCurrentLocation?.coordinate.latitude  ?? 0.000000
                    let longitude:Double               = self.clCurrentLocation?.coordinate.longitude ?? 0.000000

                    self.sCurrentLocationName          = firstLocation?.name                          ?? "-N/A-"
                    self.sCurrentCity                  = firstLocation?.locality                      ?? "-N/A-"
                    self.sCurrentCountry               = firstLocation?.country                       ?? "-N/A-"
                    self.sCurrentPostalCode            = firstLocation?.postalCode                    ?? "-N/A-"
                    self.tzCurrentTimeZone             = firstLocation?.timeZone
                    self.clCurrentRegion               = firstLocation?.region
                    self.sCurrentSubLocality           = firstLocation?.subLocality                   ?? "-N/A-"
                    self.sCurrentThoroughfare          = firstLocation?.thoroughfare                  ?? "-N/A-"
                    self.sCurrentSubThoroughfare       = firstLocation?.subThoroughfare               ?? "-N/A-"
                    self.sCurrentAdministrativeArea    = firstLocation?.administrativeArea            ?? "-N/A-"
                    self.sCurrentSubAdministrativeArea = firstLocation?.subAdministrativeArea         ?? "-N/A-"

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

                //  if (self.bInternalTraceFlag == true)
                //  {
                        self.xcgLogMsg("\(sCurrMethodDisp) <CLRequestGood> CLGeocoder 'reverseGeocodeLocation()' returned a 'location' of [\(self.sCurrentLocationName)]/[\(self.sCurrentCity)] for 'latitude'/'longitude' of (\(latitude):\(longitude))...")
                //  }
                }
                else 
                {
                    self.xcgLogMsg("\(sCurrMethodDisp) <CLRequestFail> CLGeocoder 'reverseGeocodeLocation()' failed to return a 'location' - Details: [\(String(describing: error))] - Error!")

                    self.clearLastCLLocationSettings()
                }

                // Exit...

            let _ = self.stopCLLocationUpdateRequest(uuidCLLocationRequest:uuidCLLocationRequest, dictCurrentLocation:dictCurrentLocation)

                if (self.bInternalTraceFlag == true)
                {
                    self.xcgLogMsg("\(sCurrMethodDisp) Exiting <CLRequest>...")
                }

                return

            })

        // Exit...

        if (self.bInternalTraceFlag == true)
        {
            self.xcgLogMsg("\(sCurrMethodDisp) Exiting <CLRequest> - returning 'true'...")
        }
    
        return true
        
    }   // End of public func updateGeocoderLocation().

    public func updateGeocoderLocations(requestID:Int = 1, latitude:Double, longitude:Double, withCompletionHandler completionHandler:@escaping(_ requestID:Int, _ dictCurrentLocation:[String:Any])->Void)->Bool
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        let bIsLatitudeNearlyZero:Bool  = self.isDoubleValueNearlyZero(dblValue:latitude)
        let bIsLongitudeNearlyZero:Bool = self.isDoubleValueNearlyZero(dblValue:longitude)

        if (self.bInternalTraceFlag == true)
        {
            self.xcgLogMsg("\(sCurrMethodDisp) <CLRequest> Invoked - 'requestID' is (\(requestID)) - 'latitude' is (\(latitude)) <'nearly' Zero [\(bIsLatitudeNearlyZero)]> - 'longitude' is (\(longitude)) <'nearly' Zero [\(bIsLongitudeNearlyZero)]>...")
        }

        // If the Latitude/Longitude values are 'nearly' Zero, then return a 'dummy' dictionary to the completionHandler...

        var bGeocoderSuccessful:Bool = false

        self.clearLastCLLocationSettings()

        if (bIsLatitudeNearlyZero  == true &&
            bIsLongitudeNearlyZero == true)
        {
            // Exit...

            bGeocoderSuccessful = true

            completionHandler(requestID, self.generateANearlyZeroCurrentLocationDictionary())

            if (self.bInternalTraceFlag == true)
            {
                self.xcgLogMsg("\(sCurrMethodDisp) Exiting <CLRequest> - 'dummy' dictionary - 'bGeocoderSuccessful' is [\(bGeocoderSuccessful)]...")
            }

            return bGeocoderSuccessful
        }

        // Instantiate a CLGeocoder and attempt to convert latitude/longitude into an address...

        let clGeocoder:CLGeocoder      = CLGeocoder()
        let currentLocation:CLLocation = CLLocation(latitude:latitude, longitude:longitude)

        let uuidCLLocationRequest:UUID = self.startCLLocationUpdateRequest(latitude:latitude, longitude:longitude)
        
        clGeocoder.reverseGeocodeLocation(currentLocation, completionHandler: 
            { (placemarks, error) in

            //  let _ = self.stopCLLocationUpdateRequest(uuidCLLocationRequest:uuidCLLocationRequest)

                var dictCurrentLocation:[String:Any]   = [String:Any]()

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

                //  if (self.bInternalTraceFlag == true)
                //  {
                        self.xcgLogMsg("\(sCurrMethodDisp) <CLRequestGood> CLGeocoder 'reverseGeocodeLocation()' returned a 'location' of [\(self.sCurrentLocationName)]/[\(self.sCurrentCity)] for 'latitude'/'longitude' of (\(latitude):\(longitude))...")
                //  }

                    bGeocoderSuccessful = true
                }
                else 
                {
                    self.xcgLogMsg("\(sCurrMethodDisp) <CLRequestFail> CLGeocoder 'reverseGeocodeLocation()' failed to return a 'location' - Details: [\(String(describing: error))] - Error!")

                    self.clearLastCLLocationSettings()

                    dictCurrentLocation["sRequestError"] = "<CLRequestFail> CLGeocoder 'reverseGeocodeLocation()' failed to return a 'location' - Details: [\(String(describing: error))] - Error!"

                    bGeocoderSuccessful = false
                }

                // Exit...

                let _ = self.stopCLLocationUpdateRequest(uuidCLLocationRequest:uuidCLLocationRequest, dictCurrentLocation:dictCurrentLocation)

                completionHandler(requestID, dictCurrentLocation)

                if (self.bInternalTraceFlag == true)
                {
                    self.xcgLogMsg("\(sCurrMethodDisp) Exiting <CLRequest> - 'bGeocoderSuccessful' is [\(bGeocoderSuccessful)]...")
                }

                return 
            })

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
    
        var bGeocoderSuccessful:Bool = false

        // If we don't have an actual address, then just return...

        if (address.count < 1)
        {
            let dictCurrentLocation:[String:Any] = [String:Any]()

            completionHandler(requestID, dictCurrentLocation)

            if (self.bInternalTraceFlag == true)
            {
                self.xcgLogMsg("\(sCurrMethodDisp) Exiting <CLRequestFail> - supplied 'address' is [\(address)] is an empty string - 'bGeocoderSuccessful' is [\(bGeocoderSuccessful)]...")
            }

            return bGeocoderSuccessful
        }

        // Instantiate a CLGeocoder and attempt to convert latitude/longitude into an address...

        self.clearLastCLLocationSettings()
        
        let clGeocoder:CLGeocoder      = CLGeocoder()
    //  let currentLocation:CLLocation = CLLocation(latitude:latitude, longitude:longitude)

        let uuidCLLocationRequest:UUID = self.startCLLocationUpdateRequest(address:address)
        
    //  clGeocoder.reverseGeocodeLocation(currentLocation, completionHandler: 
        clGeocoder.geocodeAddressString(address) 
            { (placemarks, error) in

            //  let _ = self.stopCLLocationUpdateRequest(uuidCLLocationRequest:uuidCLLocationRequest)

                var dictCurrentLocation:[String:Any]   = [String:Any]()

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

                    self.sCurrentLocationName          = firstLocation?.name                          ?? "-N/A-"
                    self.sCurrentCity                  = firstLocation?.locality                      ?? "-N/A-"
                    self.sCurrentCountry               = firstLocation?.country                       ?? "-N/A-"
                    self.sCurrentPostalCode            = firstLocation?.postalCode                    ?? "-N/A-"
                    self.tzCurrentTimeZone             = firstLocation?.timeZone
                    self.clCurrentRegion               = firstLocation?.region
                    self.sCurrentSubLocality           = firstLocation?.subLocality                   ?? "-N/A-"
                    self.sCurrentThoroughfare          = firstLocation?.thoroughfare                  ?? "-N/A-"
                    self.sCurrentSubThoroughfare       = firstLocation?.subThoroughfare               ?? "-N/A-"
                    self.sCurrentAdministrativeArea    = firstLocation?.administrativeArea            ?? "-N/A-"
                    self.sCurrentSubAdministrativeArea = firstLocation?.subAdministrativeArea         ?? "-N/A-"

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

                //  if (self.bInternalTraceFlag == true)
                //  {
                        self.xcgLogMsg("\(sCurrMethodDisp) <CLRequestGood> CLGeocoder 'reverseGeocodeLocation()' returned a 'location' of [\(self.sCurrentLocationName)]/[\(self.sCurrentCity)] for 'latitude'/'longitude' of (\(latitude):\(longitude))...")
                //  }

                    bGeocoderSuccessful = true
                }
                else 
                {
                    self.xcgLogMsg("\(sCurrMethodDisp) <CLRequestFail> CLGeocoder 'reverseGeocodeLocation()' failed to return a 'location' - Details: [\(String(describing: error))] - Error!")

                    self.clearLastCLLocationSettings()

                    dictCurrentLocation["sRequestError"] = "<CLRequestFail> CLGeocoder 'reverseGeocodeLocation()' failed to return a 'location' - Details: [\(String(describing: error))] - Error!"

                    bGeocoderSuccessful = false
                }

                // Exit...

                let _ = self.stopCLLocationUpdateRequest(uuidCLLocationRequest:uuidCLLocationRequest, dictCurrentLocation:dictCurrentLocation)

                completionHandler(requestID, dictCurrentLocation)

                if (self.bInternalTraceFlag == true)
                {
                    self.xcgLogMsg("\(sCurrMethodDisp) Exiting <CLRequest> - 'bGeocoderSuccessful' is [\(bGeocoderSuccessful)]...")
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

        self.listCoreLocationSiteItems = [CoreLocationSiteItem]()
        
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

        self.clLocationAccuracy            = location.horizontalAccuracy
        self.clLocationLastUpdateTimestamp = Date()

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
                self.xcgLogMsg("\(sCurrMethodDisp) <CLRequestFail> Location request failed with error: \(clErr.localizedDescription)...")
            case .headingFailure:
                self.xcgLogMsg("\(sCurrMethodDisp) <CLRequestFail> Heading request failed with error: \(clErr.localizedDescription)...")
            case .rangingUnavailable, .rangingFailure:
                self.xcgLogMsg("\(sCurrMethodDisp) <CLRequestFail> Ranging request failed with error: \(clErr.localizedDescription)...")
            case .regionMonitoringDenied, .regionMonitoringFailure, .regionMonitoringSetupDelayed, .regionMonitoringResponseDelayed:
                self.xcgLogMsg("\(sCurrMethodDisp) <CLRequestFail> Region monitoring request failed with error: \(clErr.localizedDescription)...")
            default:
                self.xcgLogMsg("\(sCurrMethodDisp) <CLRequestFail> Unknown 'location manager' request failed with error: \(clErr.localizedDescription)...")
            }
        }
        else
        {
            self.xcgLogMsg("\(sCurrMethodDisp) <CLRequestFail> Unknown error occurred while handling the 'location manager' request failed with error: \(error.localizedDescription)...")
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

        // Logging for change in CoreLocation 'authorization' status...

        self.clAuthorizationStatus = manager.authorizationStatus
        
        switch self.clAuthorizationStatus
        {
        case .notDetermined:
            self.xcgLogMsg("\(sCurrMethodDisp) <CLAuthChange> <Status> The User has NOT yet determined authorization...")
        case .restricted:
            self.xcgLogMsg("\(sCurrMethodDisp) <CLAuthChange> <Status> Authorization is RESTRICTED by Parental control...")
        case .denied:
            self.xcgLogMsg("\(sCurrMethodDisp) <CLAuthChange> <Status> The User has selected 'Do NOT Allow' (denied)...")
        case .authorizedAlways:
            self.xcgLogMsg("\(sCurrMethodDisp) <CLAuthChange> <Status> The User has changed the selection to 'Always Allow'...")
        case .authorizedWhenInUse:
            self.xcgLogMsg("\(sCurrMethodDisp) <CLAuthChange> <Status> The User has selected 'Allow while Using' or 'Allow Once'...")
            
            self.locationManager?.requestAlwaysAuthorization()
        default:
            self.xcgLogMsg("\(sCurrMethodDisp) <CLAuthChange> <Status> This is the 'default' option...")
        }

        // Reduced accuracy might indicate throttling...

        if manager.accuracyAuthorization == .reducedAccuracy 
        {
            self.xcgLogMsg("\(sCurrMethodDisp) <CLAuthChange> <Accuracy> <CLThrottling> CLLocation 'manager' is indicating 'reduced' accuracy - this indicates 'possible' throttling...")
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

    private func isDoubleValueNearlyZero(dblValue:Double)->Bool
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        if (self.bInternalTraceFlag == true)
        {
            self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'dblValue' is (\(dblValue))...")
        }

        // Determine if the Double value parameter is 'nearly' Zero...
    
        var bIsDoubleValueNearlyZero:Bool = false

        if (abs(dblValue) > self.clLocationGPSTolerance)
        {
            bIsDoubleValueNearlyZero = false
        }
        else
        {
            bIsDoubleValueNearlyZero = true
        }

        // Exit...

        if (self.bInternalTraceFlag == true)
        {
            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'dblValue' was (\(dblValue)) - 'self.clLocationGPSTolerance' is (\(self.clLocationGPSTolerance)) - returning 'bIsDoubleValueNearlyZero' of [\(bIsDoubleValueNearlyZero)]...")
        }
    
        return bIsDoubleValueNearlyZero
        
    }   // End of private func isDoubleValueNearlyZero(dblValue:Double)->Bool.

    private func generateANearlyZeroCurrentLocationDictionary()->[String:Any]
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        if (self.bInternalTraceFlag == true)
        {
            self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
        }

        // Create a few objects for inclusion in the generated dictionary...

        let clCurrentLocation:CLLocation    = CLLocation(coordinate:        CLLocationCoordinate2D(latitude:0.000000, longitude:0.000000),
                                                         altitude:          100.0,
                                                         horizontalAccuracy:5.0,
                                                         verticalAccuracy:  10.0,
                                                         course:            1.0,
                                                         courseAccuracy:    5.0,       // degrees (course accuracy)
                                                         speed:             1.0,
                                                         speedAccuracy:     2.0,       // meters per second (speed accuracy)
                                                         timestamp:         Date())

        let clCurrentHeadingAccuracy:Double = 0.000000


        let clCurrentRegion:CLRegion?       = CLCircularRegion(center:CLLocationCoordinate2D(latitude:0.000000, longitude:0.000000),
                                                               radius:    10.0,
                                                               identifier:"<+0.00000000,-0.00000000> radius 10.0")

        // Generate a 'dictCurrentLocation' for a 'nearly' Zero current location...
    
        var dictCurrentLocation:[String:Any]                 = [String:Any]()

        dictCurrentLocation["iRequestID"]                    = "0"
        dictCurrentLocation["sRequestError"]                 = ""
        dictCurrentLocation["sRequestAddress"]               = ""
        dictCurrentLocation["dblLatitude"]                   = "0.0"
        dictCurrentLocation["dblLongitude"]                  = "0.0"

        dictCurrentLocation["clCurrentLocation"]             = clCurrentLocation
        dictCurrentLocation["clCurrentHeadingAccuracy"]      = clCurrentHeadingAccuracy

        dictCurrentLocation["sCurrentLocationName"]          = "North Atlantic Ocean"         
        dictCurrentLocation["sCurrentCity"]                  = "-N/A-"                 
        dictCurrentLocation["sCurrentCountry"]               = "-N/A-"              
        dictCurrentLocation["sCurrentPostalCode"]            = "-N/A-"           
        dictCurrentLocation["tzCurrentTimeZone"]             = TimeZone.current            
        dictCurrentLocation["clCurrentRegion"]               = clCurrentRegion              
        dictCurrentLocation["sCurrentSubLocality"]           = "-N/A-"          
        dictCurrentLocation["sCurrentThoroughfare"]          = "-N/A-"         
        dictCurrentLocation["sCurrentSubThoroughfare"]       = "-N/A-"      
        dictCurrentLocation["sCurrentAdministrativeArea"]    = "-N/A-"   
        dictCurrentLocation["sCurrentSubAdministrativeArea"] = "-N/A-"
        dictCurrentLocation["sCurrentLocationAddress"]       = "North Atlantic Ocean, -N/A-, -N/A-, -N/A-"         

        // Mirror the 'dummy' dictionary values in 'self.' fields...

        self.clCurrentLocation             = dictCurrentLocation["clCurrentLocation"]             as? CLLocation
        self.clCurrentHeadingAccuracy      = dictCurrentLocation["clCurrentHeadingAccuracy"]      as! CLLocationDirection

        self.sCurrentLocationName          = dictCurrentLocation["sCurrentLocationName"]          as! String
        self.sCurrentCity                  = dictCurrentLocation["sCurrentCity"]                  as! String
        self.sCurrentCountry               = dictCurrentLocation["sCurrentCountry"]               as! String
        self.sCurrentPostalCode            = dictCurrentLocation["sCurrentPostalCode"]            as! String
        self.tzCurrentTimeZone             = dictCurrentLocation["tzCurrentTimeZone"]             as? TimeZone
        self.clCurrentRegion               = dictCurrentLocation["clCurrentRegion"]               as? CLRegion
        self.sCurrentSubLocality           = dictCurrentLocation["sCurrentSubLocality"]           as! String
        self.sCurrentThoroughfare          = dictCurrentLocation["sCurrentThoroughfare"]          as! String
        self.sCurrentSubThoroughfare       = dictCurrentLocation["sCurrentSubThoroughfare"]       as! String
        self.sCurrentAdministrativeArea    = dictCurrentLocation["sCurrentAdministrativeArea"]    as! String
        self.sCurrentSubAdministrativeArea = dictCurrentLocation["sCurrentSubAdministrativeArea"] as! String

        // Exit...

        if (self.bInternalTraceFlag == true)
        {
            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - returning 'dictCurrentLocation' of [\(dictCurrentLocation)]...")
        }
    
        return dictCurrentLocation
        
    }   // End of generateANearlyZeroCurrentLocationDictionary()->[String:Any].

}   // End of class CoreLocationModelObservable2:NSObject, CLLocationManagerDelegate, ObservableObject.

