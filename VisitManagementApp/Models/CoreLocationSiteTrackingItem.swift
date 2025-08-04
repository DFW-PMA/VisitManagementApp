//
//  CoreLocationSiteTrackingItem.swift
//  VisitManagementApp
//
//  Created by JustMacApps.net on 05/09/2024.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftData

@Model
final class CoreLocationSiteTrackingItem:Identifiable, DataItem
{

    @Transient
    struct ClassInfo
    {
        static let sClsId        = "CoreLocationSiteTrackingItem"
        static let sClsVers      = "v1.0101"
        static let sClsDisp      = sClsId+"(.swift).("+sClsVers+"):"
        static let sClsCopyRight = "Copyright (C) JustMacApps 2023-2025. All Rights Reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
    }

    // 'Internal' Trace flag(s):

    @Transient private 
    var bInternalTraceFlag:Bool                   = false
    @Transient private 
    var bInternalHomeLocTraceFlag:Bool            = true

    // Item Data field(s):
    
    @Attribute(.unique) public
    var id                                        = UUID()

    var dateCLLocationTimestamp:Date              = Date()

    var dblCLLocationLatitude:Double              = 0.0
    var dblCLLocationLongitude:Double             = 0.0

    var sCLLocationAddress:String                 = ""

    @Transient
    var dictCurrentLocation:[String:Any]          = [String:Any]()

    // Item (not-@Transient) 'computed' field(s):

    var sId:String
    {
        return String(describing:self.id).stripOptionalStringWrapper()
    }
    
    var sTimestamp:String
    {
        let dtFormatterDateStamp:DateFormatter = DateFormatter()

        dtFormatterDateStamp.locale     = Locale(identifier: "en_US")
        dtFormatterDateStamp.timeZone   = TimeZone.current
    //  dtFormatterDateStamp.dateFormat = "yyyy-MM-dd hh:mm:ss.SSS"
        dtFormatterDateStamp.dateFormat = "yyyy-MM-dd hh:mm:ss"

        let sFormattedTimestamp:String  = "\(dtFormatterDateStamp.string(from:self.timestamp))"

        return sFormattedTimestamp
    }

    // Item (@Transient) 'computed' field(s):

    @Transient
    var sCLLocationLatitude:String
    {
        return "\(self.dblCLLocationLatitude)"
    }
    @Transient
    var sCLLocationLongitude:String
    {
        return "\(self.dblCLLocationLongitude)"
    }

    @Transient
    var sCLLocationLatitudeAsKey:String
    {
        return String(format:"%.5f", self.dblCLLocationLatitude)
    }
    @Transient
    var sCLLocationLongitudeAsKey:String
    {
        return String(format:"%.5f", self.dblCLLocationLongitude)
    }
    @Transient
    var sCLLocationAddressAsKey:String
    {
        return self.sCLLocationAddress
    }

    @Transient
    var clLocationCoordinate2D:CLLocationCoordinate2D
    {
        return CLLocationCoordinate2D(latitude: self.dblCLLocationLatitude, 
                                      longitude:self.dblCLLocationLongitude)
    }

    @Transient
    var mapCoordinateRegion:MKCoordinateRegion
    {
        return MKCoordinateRegion(center:self.clLocationCoordinate2D,               
                                    span:MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta:0.05))
    }

    @Transient
    var mapPosition:MapCameraPosition
    {
        return MapCameraPosition.region(self.mapCoordinateRegion)
    }

    @Transient
    var jmAppDelegateVisitor:JmAppDelegateVisitor = JmAppDelegateVisitor.ClassSingleton.appDelegateVisitor

    init(timestamp:Date = Date(), latitude:Double = 0.000000, longitude:Double = 0.000000, address:String = "", dictCurrentLocation:[String:Any] = [String:Any]()) 
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        self.id                      = UUID()

        self.dateCLLocationTimestamp = timestamp

        self.dblCLLocationLatitude   = latitude
        self.dblCLLocationLongitude  = longitude

        self.sCLLocationAddress      = address

        self.dictCurrentLocation     = dictCurrentLocation

        // Exit...

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of init(iStatusItemMenuOrdinal:String, timestamp:Date = Date(), sStatusItemMenuTitle:String = "", sStatusItemMenuText:String = "").

//  private func xcgLogMsg(_ sMessage:String)
//  {
//
//      let dtFormatterDateStamp:DateFormatter = DateFormatter()
//
//      dtFormatterDateStamp.locale     = Locale(identifier: "en_US")
//      dtFormatterDateStamp.timeZone   = TimeZone.current
//      dtFormatterDateStamp.dateFormat = "yyyy-MM-dd hh:mm:ss.SSS"
//
//      let dateStampNow:Date = .now
//      let sDateStamp:String = ("\(dtFormatterDateStamp.string(from:dateStampNow)) >> ")
//
//      print("\(sDateStamp)\(sMessage)")
//
//      // Exit:
//
//      return
//
//  }   // End of private func xcgLogMsg().

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
        asToString.append("'bClsFileLog': [\(ClassInfo.bClsFileLog)],")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'self.bInternalTraceFlag': [\(String(describing: self.bInternalTraceFlag))],")
        asToString.append("'self.bInternalCLLocationTraceFlag': [\(String(describing: self.bInternalCLLocationTraceFlag))],")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'self.id': (\(self.id)),")
        asToString.append("'self.timestamp': [\(String(describing: self.timestamp))],")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'self.iStatusItemMenuOrdinal': (\(self.iStatusItemMenuOrdinal)),")
        asToString.append("'self.sStatusItemMenuTitle': [\(String(describing: self.sStatusItemMenuTitle))],")
        asToString.append("'self.sStatusItemMenuText': [\(String(describing: self.sStatusItemMenuText))],")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'self.sId': [\(String(describing: self.sId))],")
        asToString.append("'self.sTimestamp': [\(String(describing: self.sTimestamp))],")
        asToString.append("'self.sStatusItemMenuOrdinal': [\(String(describing: self.sStatusItemMenuOrdinal))],")
        asToString.append("],")
        asToString.append("]")



        var bInternalTraceFlag:Bool                   = false
        var bInternalCLLocationTraceFlag:Bool            = true

        var id                                        = UUID()
        var dateCLLocationTimestamp:Date              = Date()

        var dblCLLocationLatitude:Double              = 0.0
        var dblCLLocationLongitude:Double             = 0.0

        var sCLLocationAddress:String                 = ""

        var dictCurrentLocation:[String:Any]          = [String:Any]()

        var sId:String
        var sTimestamp:String

        var sCLLocationLatitude:String
        var sCLLocationLongitude:String
        var sCLLocationLatitudeAsKey:String
        var sCLLocationLongitudeAsKey:String
        var sCLLocationAddressAsKey:String
        var clLocationCoordinate2D:CLLocationCoordinate2D
        var mapCoordinateRegion:MKCoordinateRegion
        var mapPosition:MapCameraPosition






        let sContents:String = "{"+(asToString.joined(separator: ""))+"}"

        return sContents

    }   // End of public func toString().

    func validate() throws 
    {

    //  guard !sTID.isEmpty 
    //  else { throw ValidationError.invalidID }

    }   // End of func validate() throws.

    func isLogicallyEqual(to other:StatusItemMenuItem)->Bool 
    {

        if (self.sStatusItemMenuTitle.count < 1 &&
            self.sStatusItemMenuText.count  < 1)
        {
            return false
        }
        
        if (self.sStatusItemMenuTitle.lowercased() != other.sStatusItemMenuTitle.lowercased())
        {
            return false
        }
        
        if (self.sStatusItemMenuText.lowercased() != other.sStatusItemMenuText.lowercased())
        {
            return false
        }
        
        return true

    //  return (self.sStatusItemMenuText.lowercased() == other.sStatusItemMenuText.lowercased())

    }   // End of func isLogicallyEqual(to other:StatusItemMenuItem)->Bool.

    func update(from other:StatusItemMenuItem) 
    {

        return self.overlayStatusItemMenuItemWithAnotherStatusItemMenuItem(statusItemMenuItem:other)

    }   // End of func update(from other:StatusItemMenuItem).

    func overlayStatusItemMenuItemWithAnotherStatusItemMenuItem(statusItemMenuItem:StatusItemMenuItem)
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Finish the 'overlay' update of field(s)...

        self.timestamp              = statusItemMenuItem.timestamp

        self.iStatusItemMenuOrdinal = statusItemMenuItem.iStatusItemMenuOrdinal
        self.sStatusItemMenuTitle   = statusItemMenuItem.sStatusItemMenuTitle
        self.sStatusItemMenuText    = statusItemMenuItem.sStatusItemMenuText

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of func overlayStatusItemMenuItemWithAnotherStatusItemMenuItem(statusItemMenuItem:StatusItemMenuItem).

    public func displayDataItemToLog()
    {

        return self.displayStatusItemMenuItemToLog()

    }   // End of public func displayDataItemToLog().

    public func displayStatusItemMenuItemToLog()
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Display the field(s) of this item to the Log...

        self.xcgLogMsg("\(sCurrMethodDisp) 'self.id'                     is [\(self.id)]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'self.sId'                    is [\(self.sId)]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'self.timestamp'              is [\(self.timestamp)]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'self.iStatusItemMenuOrdinal' is (\(self.iStatusItemMenuOrdinal))...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'self.sStatusItemMenuTitle'   is [\(self.sStatusItemMenuTitle)]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'self.sStatusItemMenuText'    is [\(self.sStatusItemMenuText)]...")

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of public func displayStatusItemMenuItemToLog().
    
    // Required method by the protocol 'Comparable'...

    static func < (lhs:StatusItemMenuItem, rhs:StatusItemMenuItem)->Bool
    {
        
        return lhs.iStatusItemMenuOrdinal < rhs.iStatusItemMenuOrdinal
    //  return lhs.timestamp < rhs.timestamp
        
    }   // End of static func < (lhs:StatusItemMenuItem, rhs:StatusItemMenuItem)->Bool.
    
    // Required method by the protocol 'Comparable'...
    //     (Also need == for classes)
    
    static func == (lhs:StatusItemMenuItem, rhs:StatusItemMenuItem)->Bool
    {
        
        return lhs.iStatusItemMenuOrdinal == rhs.iStatusItemMenuOrdinal
    //  return lhs.timestamp == rhs.timestamp
        
    }   // End of static func == (lhs:StatusItemMenuItem, rhs:StatusItemMenuItem)->Bool.
    
}   // End of @model final class CoreLocationSiteTrackingItem:Identifiable, DataItem.

