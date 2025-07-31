//
//  ParsePFCscDataItem.swift
//  VisitManagementApp
//
//  Created by JustMacApps.net on 05/09/2024.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
import SwiftUI
import MapKit
import ParseCore

class ParsePFCscDataItem: NSObject, Identifiable
{

    struct ClassInfo
    {
        
        static let sClsId        = "ParsePFCscDataItem"
        static let sClsVers      = "v1.1001"
        static let sClsDisp      = sClsId+"(.swift).("+sClsVers+"):"
        static let sClsCopyRight = "Copyright (C) JustMacApps 2023-2025. All Rights Reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }

    // Item Data field(s):
    
    var id                                        = UUID()

    var pfCscObjectClonedFrom:ParsePFCscDataItem? = nil 
    var pfCscObjectClonedTo:ParsePFCscDataItem?   = nil 

    var idPFCscObject:Int                         = 0

    // ------------------------------------------------------------------------------------------
    //  'pfCscObject' is [<CSC: 0x301e16700, objectId: qpp1fxx68P, localId: (null)> 
    //  {
    //      name        = "Office Ernesto";
    //      lastLocDate = "11/14/24";
    //      lastLocTime = "4:15\U202fPM";
    //      latitude    = "32.83285140991211";
    //      longitude   = "-97.071533203125";
    //  }]...
    // ------------------------------------------------------------------------------------------

    var pfCscObject:PFObject?                     = nil

    // ----------------------------------------------------------------------------------------------------------------
    //  TYPE of 'pfCscObject'                 is [PFObject]         - value is [<CSC: 0x302ee1080, objectId: ...
    //  TYPE of 'pfCscObject.parseClassName'  is [String]           - value is [CSC]...
    //  TYPE of 'pfCscObject.objectId'        is [Optional<String>] - value is [Optional("dztxUrBZLr")]...
    //  TYPE of 'pfCscObject.createdAt'       is [Optional<Date>]   - value is [Optional(2024-11-13 17:13:57 +0000)]...
    //  TYPE of 'pfCscObject.updatedAt'       is [Optional<Date>]   - value is [Optional(2024-11-14 22:30:00 +0000)]...
    //  TYPE of 'pfCscObject.acl'             is [Optional<PFACL>]  - value is [nil]...
    //  TYPE of 'pfCscObject.isDataAvailable' is [Bool]             - value is [true]...
    //  TYPE of 'pfCscObject.isDirty'         is [Bool]             - value is [false]...
    //  TYPE of 'pfCscObject.allKeys'         is [Array<String>]    - value is [["lastLocTime", "latitude", ...
    // ----------------------------------------------------------------------------------------------------------------

    // Item 'discrete' field(s):

    var sPFCscParseClassName:String               = ""
    var sPFCscParseObjectId:String?               = nil
    var datePFCscParseCreatedAt:Date?             = nil
    var datePFCscParseUpdatedAt:Date?             = nil
    var aclPFCscParse:PFACL?                      = nil
    var bPFCscParseIsDataAvailable:Bool           = false
    var bPFCscParseIdDirty:Bool                   = false
    var sPFCscParseAllKeys:[String]               = []

    // ----------------------------------------------------------------------------------------------------------------
    //     TYPE of 'pfCscObject[name]'        is [Optional<Any>] - value is [Optional(Mihal Lasky)]...
    //     TYPE of 'pfCscObject[lastLocDate]' is [Optional<Any>] - value is [Optional(11/14/24)]...
    //     TYPE of 'pfCscObject[lastLocTime]' is [Optional<Any>] - value is [Optional(4:30 PM)]...
    //     TYPE of 'pfCscObject[latitude]'    is [Optional<Any>] - value is [Optional(32.77201080322266)]...
    //     TYPE of 'pfCscObject[longitude]'   is [Optional<Any>] - value is [Optional(-96.5831298828125)]...
    // ----------------------------------------------------------------------------------------------------------------

    // Item 'keyed' field(s):

    var sPFCscParseName:String                    = "-N/A-"
    var sPFCscParseLastLocDate:String             = "-N/A-"
    var sPFCscParseLastLocTime:String             = "-N/A-"
    var sPFCscParseLastLatitude:String            = "-N/A-"
    var sPFCscParseLastLongitude:String           = "-N/A-"

    // ----------------------------------------------------------------------------------------------------------------
    //  TYPE of 'pfCscObjectLatitude'         is [Optional<Any>] - value is [Optional(32.77201080322266)]...
    //  TYPE of 'pfCscObjectLongitude'        is [Optional<Any>] - value is [Optional(-96.5831298828125)]...
    //  TYPE of 'sPFCscObjectLatitude'        is [String]        - value is [32.77201080322266]...
    //  TYPE of 'sPFCscObjectLongitude'       is [String]        - value is [-96.5831298828125]...
    //  TYPE of 'dblPFCscObjectLatitude'      is [Double]        - value is [32.77201080322266]...
    //  TYPE of 'dblPFCscObjectLongitude'     is [Double]        - value is [-96.5831298828125]...
    //  TYPE of 'dblConvertedLatitude'        is [Double]        - value is [32.77201080322266]...
    //  TYPE of 'dblConvertedLongitude'       is [Double]        - value is [-96.5831298828125]...
    //  TYPE of 'sCurrentLocationName'        is [String]        - value is [-N/A-]...
    //  TYPE of 'sCurrentCity'                is [String]        - value is [-N/A-]...
    // ----------------------------------------------------------------------------------------------------------------

    // Item 'calculated'/'converted'/'look-up'/'computed' field(s):

    var sPFTherapistParseTID:String               = ""

    var pfCscObjectLatitude:Any?                  = nil
    var pfCscObjectLongitude:Any?                 = nil

    var sPFCscObjectLatitude:String               = "0.00000"
    var sPFCscObjectLongitude:String              = "0.00000"

    var dblPFCscObjectLatitude:Double             = 0.00000
    var dblPFCscObjectLongitude:Double            = 0.00000

    var dblConvertedLatitude:Double               = 0.00000
    var dblConvertedLongitude:Double              = 0.00000

    // Item address 'lookup' flag(s) and field(s):

    var bCurrentAddessLookupScheduled:Bool        = false
    var bCurrentAddessLookupComplete:Bool         = false

    var sCurrentLocationName:String               = ""
    var sCurrentCity:String                       = ""
    var sCurrentCountry:String                    = ""
    var sCurrentPostalCode:String                 = ""
    var sCurrentTimeZone:String                   = ""

    // Item coordinate and position 'computed' field(s):

    var clLocationCoordinate2D:CLLocationCoordinate2D
    {

        return CLLocationCoordinate2D(latitude: self.dblConvertedLatitude, 
                                      longitude:self.dblConvertedLongitude)

    }

    var mapCoordinateRegion:MKCoordinateRegion
    {

        return MKCoordinateRegion(center:self.clLocationCoordinate2D,               
                                    span:MKCoordinateSpan(latitudeDelta: 0.05, 
                                                          longitudeDelta:0.05))

    }

    var mapPosition:MapCameraPosition
    {

        return MapCameraPosition.region(self.mapCoordinateRegion)

    }

    // App Data field(s):

    var jmAppDelegateVisitor:JmAppDelegateVisitor = JmAppDelegateVisitor.ClassSingleton.appDelegateVisitor
    
    override init()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        super.init()

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

    //  self.pfCscObjectClonedFrom = nil 
    //  self.pfCscObjectClonedTo   = nil 

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of override init().

    convenience init(pfCscDataItem:ParsePFCscDataItem)
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
  
        self.init()
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter is 'pfCscDataItem' is [\(pfCscDataItem)]...")

        // Finish the 'convenience' setup of field(s)...

        self.init(bDeepCopyIsAnOverlay:false, pfCscDataItem:pfCscDataItem)

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return
  
    }   // End of convenience init(pfCscDataItem:ParsePFCscDataItem).

    convenience init(bDeepCopyIsAnOverlay:Bool, pfCscDataItem:ParsePFCscDataItem)
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
  
        self.init()
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter is 'pfCscDataItem' is [\(pfCscDataItem)]...")

        // Finish the 'convenience' setup of field(s)...

        self.overlayPFCscDataItemWithAnotherPFCscDataItem(pfCscDataItem:pfCscDataItem)

        if (bDeepCopyIsAnOverlay == false)
        {
        
            self.pfCscObjectClonedFrom          = pfCscDataItem 
            self.pfCscObjectClonedTo            = self 

        //  pfCscDataItem.pfCscObjectClonedFrom = nil
            pfCscDataItem.pfCscObjectClonedTo   = self
        
        }

        // Check if the 'current' Location data copied was 'blank'...

        if (self.sCurrentLocationName.count < 1 ||
            self.sCurrentCity.count         < 1)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) Intermediate <dup copy 'init'> <PFCsc> - Copied 'self.sCurrentLocationName' is [\(self.sCurrentLocationName)] and 'self.sCurrentCity' is [\(self.sCurrentCity)] - 1 or both are 'blank' - 'pfCscDataItem.sCurrentLocationName' is [\(pfCscDataItem.sCurrentLocationName)] and 'pfCscDataItem.sCurrentCity' is [\(pfCscDataItem.sCurrentCity)] - Warning!")
        
        }

        // Trace the 'clone' From/To fields in both objects...

        self.xcgLogMsg("\(sCurrMethodDisp) Intermediate <dup copy 'init'> <PFCsc> - From/To 'self.pfCscObjectClonedFrom' is [\(String(describing: self.pfCscObjectClonedFrom))] and 'self.pfCscObjectClonedTo' is [\(String(describing: self.pfCscObjectClonedTo))] - 'pfCscDataItem.pfCscObjectClonedFrom' is [\(String(describing: pfCscDataItem.pfCscObjectClonedFrom))] and 'pfCscDataItem.pfCscObjectClonedTo' is [\(String(describing: pfCscDataItem.pfCscObjectClonedTo))]...")

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return
  
    }   // End of convenience init(bDeepCopyIsAnOverlay:Bool, pfCscDataItem:ParsePFCscDataItem).

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
        asToString.append("'self': [\(String(describing: self))],")
        asToString.append("'id': [\(String(describing: self.id))],")
        asToString.append("'pfCscObjectClonedFrom': [\(String(describing: self.pfCscObjectClonedFrom))],")
        asToString.append("'pfCscObjectClonedTo': [\(String(describing: self.pfCscObjectClonedTo))],")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'idPFCscObject': [\(String(describing: self.idPFCscObject))],")

    //  asToString.append("'pfCscObject': [\(String(describing: self.pfCscObject))],")

        if (self.pfCscObject == nil)
        {
            asToString.append("'pfCscObject': [-nil-],")
        }
        else
        {
            asToString.append("'pfCscObject': [-available-],")
        }

        asToString.append("],")
        asToString.append("[")
        asToString.append("'sPFCscParseClassName': [\(String(describing: self.sPFCscParseClassName))],")
        asToString.append("'sPFCscParseObjectId': [\(String(describing: self.sPFCscParseObjectId))],")
        asToString.append("'datePFCscParseCreatedAt': [\(String(describing: self.datePFCscParseCreatedAt))],")
        asToString.append("'datePFCscParseUpdatedAt': [\(String(describing: self.datePFCscParseUpdatedAt))],")
        asToString.append("'aclPFCscParse': [\(String(describing: self.aclPFCscParse))],")
        asToString.append("'bPFCscParseIsDataAvailable': [\(String(describing: self.bPFCscParseIsDataAvailable))],")
        asToString.append("'bPFCscParseIdDirty': [\(String(describing: self.bPFCscParseIdDirty))],")
        asToString.append("'sPFCscParseAllKeys': [\(String(describing: self.sPFCscParseAllKeys))],")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'sPFCscParseName': [\(String(describing: self.sPFCscParseName))],")
        asToString.append("'sPFCscParseLastLocDate': [\(String(describing: self.sPFCscParseLastLocDate))],")
        asToString.append("'sPFCscParseLastLocTime': [\(String(describing: self.sPFCscParseLastLocTime))],")
        asToString.append("'sPFCscParseLastLatitude': [\(String(describing: self.sPFCscParseLastLatitude))],")
        asToString.append("'sPFCscParseLastLongitude': [\(String(describing: self.sPFCscParseLastLongitude))],")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'sPFTherapistParseTID': [\(String(describing: self.sPFTherapistParseTID))],")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'pfCscObjectLatitude': [\(String(describing: self.pfCscObjectLatitude))],")
        asToString.append("'pfCscObjectLongitude': [\(String(describing: self.pfCscObjectLongitude))],")
        asToString.append("'sPFCscObjectLatitude': [\(String(describing: self.sPFCscObjectLatitude))],")
        asToString.append("'sPFCscObjectLongitude': [\(String(describing: self.sPFCscObjectLongitude))],")
        asToString.append("'dblPFCscObjectLatitude': [\(String(describing: self.dblPFCscObjectLatitude))],")
        asToString.append("'dblPFCscObjectLongitude': [\(String(describing: self.dblPFCscObjectLongitude))],")
        asToString.append("'dblConvertedLatitude': [\(String(describing: self.dblConvertedLatitude))],")
        asToString.append("'dblConvertedLongitude': [\(String(describing: self.dblConvertedLongitude))],")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'bCurrentAddessLookupScheduled': [\(String(describing: self.bCurrentAddessLookupScheduled))],")
        asToString.append("'bCurrentAddessLookupComplete': [\(String(describing: self.bCurrentAddessLookupComplete))],")
        asToString.append("'sCurrentLocationName': [\(String(describing: self.sCurrentLocationName))],")
        asToString.append("'sCurrentCity': [\(String(describing: self.sCurrentCity))],")
        asToString.append("'sCurrentCountry': [\(String(describing: self.sCurrentCountry))],")
        asToString.append("'sCurrentPostalCode': [\(String(describing: self.sCurrentPostalCode))],")
        asToString.append("'sCurrentTimeZone': [\(String(describing: self.sCurrentTimeZone))],")
    //  asToString.append("],")
    //  asToString.append("[")
    //  asToString.append("'jmAppDelegateVisitor': [\(self.jmAppDelegateVisitor.toString())]")
        asToString.append("],")
        asToString.append("]")

        let sContents:String = "{"+(asToString.joined(separator: ""))+"}"

        return sContents

    }   // End of public func toString().

    public func displayParsePFCscDataItemToLog(cDisplayItem:Int = 0)
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Display the various field(s) of this object in the Log...

        self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'self'                          is [\(String(describing: self))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'id'                            is [\(String(describing: self.id))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'pfCscObjectClonedFrom'         is [\(String(describing: self.pfCscObjectClonedFrom))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'pfCscObjectClonedTo'           is [\(String(describing: self.pfCscObjectClonedTo))]...")

        self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'idPFCscObject'                 is [\(String(describing: self.idPFCscObject))]...")

    //  self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'pfCscObject'                   is [\(String(describing: self.pfCscObject))]...")

        if (self.pfCscObject == nil)
        {
            self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'pfCscObject'                   is [-nil-]...")
        }
        else
        {
            self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'pfCscObject'                   is [-available-]...")
        }

        self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'sPFCscParseClassName'          is [\(String(describing: self.sPFCscParseClassName))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'sPFCscParseObjectId'           is [\(String(describing: self.sPFCscParseObjectId))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'datePFCscParseCreatedAt'       is [\(String(describing: self.datePFCscParseCreatedAt))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'datePFCscParseUpdatedAt'       is [\(String(describing: self.datePFCscParseUpdatedAt))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'aclPFCscParse'                 is [\(String(describing: self.aclPFCscParse))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'bPFCscParseIsDataAvailable'    is [\(String(describing: self.bPFCscParseIsDataAvailable))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'bPFCscParseIdDirty'            is [\(String(describing: self.bPFCscParseIdDirty))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'sPFCscParseAllKeys'            is [\(String(describing: self.sPFCscParseAllKeys))]...")

        self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'sPFCscParseName'               is [\(String(describing: self.sPFCscParseName))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'sPFCscParseLastLocDate'        is [\(String(describing: self.sPFCscParseLastLocDate))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'sPFCscParseLastLocTime'        is [\(String(describing: self.sPFCscParseLastLocTime))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'sPFCscParseLastLatitude'       is [\(String(describing: self.sPFCscParseLastLatitude))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'sPFCscParseLastLongitude'      is [\(String(describing: self.sPFCscParseLastLongitude))]...")

        self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'sPFTherapistParseTID'          is [\(String(describing: self.sPFTherapistParseTID))]...")

        self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'pfCscObjectLatitude'           is [\(String(describing: self.pfCscObjectLatitude))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'pfCscObjectLongitude'          is [\(String(describing: self.pfCscObjectLongitude))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'sPFCscObjectLatitude'          is [\(String(describing: self.sPFCscObjectLatitude))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'sPFCscObjectLongitude'         is [\(String(describing: self.sPFCscObjectLongitude))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'dblPFCscObjectLatitude'        is [\(String(describing: self.dblPFCscObjectLatitude))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'dblPFCscObjectLongitude'       is [\(String(describing: self.dblPFCscObjectLongitude))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'dblConvertedLatitude'          is [\(String(describing: self.dblConvertedLatitude))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'dblConvertedLongitude'         is [\(String(describing: self.dblConvertedLongitude))]...")

        self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'bCurrentAddessLookupScheduled' is [\(String(describing: self.bCurrentAddessLookupScheduled))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'bCurrentAddessLookupComplete'  is [\(String(describing: self.bCurrentAddessLookupComplete))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'sCurrentLocationName'          is [\(String(describing: self.sCurrentLocationName))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'sCurrentCity'                  is [\(String(describing: self.sCurrentCity))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'sCurrentCountry'               is [\(String(describing: self.sCurrentCountry))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'sCurrentPostalCode'            is [\(String(describing: self.sCurrentPostalCode))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) #(\(cDisplayItem).\(self.idPFCscObject)): 'sCurrentTimeZone'              is [\(String(describing: self.sCurrentTimeZone))]...")

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of public func displayParsePFCscDataItemToLog().

    public func constructParsePFCscDataItemFromPFObject(idPFCscObject:Int = 0, pfCscObject:PFObject)
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'self' is [\(String(describing: self))] - parameter 'idPFCscObject' is (\(idPFCscObject)) - 'pfCscObject' is [\(String(describing: pfCscObject))]...")

        // Assign the various field(s) of this object from the supplied PFObject...

        self.idPFCscObject                 = idPFCscObject                                                             
        self.pfCscObject                   = pfCscObject                                                             
        
        self.sPFCscParseClassName          = pfCscObject.parseClassName
    //  if pfCscObject.objectId != nil && pfCscObject.objectId?.count ?? <#default value#> > 0 { self.sPFCscParseObjectId = pfCscObject.objectId } else { self.sPFCscParseObjectId = "" }
        self.sPFCscParseObjectId           = pfCscObject.objectId  != nil ? pfCscObject.objectId!  : ""
        self.datePFCscParseCreatedAt       = pfCscObject.createdAt != nil ? pfCscObject.createdAt! : nil
        self.datePFCscParseUpdatedAt       = pfCscObject.updatedAt != nil ? pfCscObject.updatedAt! : nil
        self.aclPFCscParse                 = pfCscObject.acl
        self.bPFCscParseIsDataAvailable    = pfCscObject.isDataAvailable
        self.bPFCscParseIdDirty            = pfCscObject.isDirty
        self.sPFCscParseAllKeys            = pfCscObject.allKeys

        self.sPFCscParseName               = String(describing: pfCscObject.object(forKey:"name")!)
        self.sPFCscParseLastLocDate        = String(describing: (pfCscObject.object(forKey:"lastLocDate") ?? ""))
        self.sPFCscParseLastLocTime        = String(describing: (pfCscObject.object(forKey:"lastLocTime") ?? "")).lowercased()
        self.sPFCscParseLastLatitude       = String(describing: (pfCscObject.object(forKey:"latitude")    ?? ""))
        self.sPFCscParseLastLongitude      = String(describing: (pfCscObject.object(forKey:"longitude")   ?? ""))

        self.sPFTherapistParseTID          = ""
        
        self.pfCscObjectLatitude           = (pfCscObject.object(forKey:"latitude"))  != nil ? pfCscObject.object(forKey:"latitude")  : nil
        self.pfCscObjectLongitude          = (pfCscObject.object(forKey:"longitude")) != nil ? pfCscObject.object(forKey:"longitude") : nil
        self.sPFCscObjectLatitude          = String(describing: self.pfCscObjectLatitude!)
        self.sPFCscObjectLongitude         = String(describing: self.pfCscObjectLongitude!)
        self.dblPFCscObjectLatitude        = Double(self.sPFCscObjectLatitude)  ?? 0.0
        self.dblPFCscObjectLongitude       = Double(self.sPFCscObjectLongitude) ?? 0.0
        self.dblConvertedLatitude          = Double(String(describing: pfCscObject.object(forKey:"latitude")!))  ?? 0.0
        self.dblConvertedLongitude         = Double(String(describing: pfCscObject.object(forKey:"longitude")!)) ?? 0.0
        
        self.bCurrentAddessLookupScheduled = false
        self.bCurrentAddessLookupComplete  = false

        self.sCurrentLocationName          = ""
        self.sCurrentCity                  = ""
        self.sCurrentCountry               = ""
        self.sCurrentPostalCode            = ""
        self.sCurrentTimeZone              = ""

        self.resolveLocationAndAddress()

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of public func constructParsePFCscDataItemFromPFObject(idPFCscObject:Int, pfCscObject:PFObject).

    public func overlayPFCscDataItemWithAnotherPFCscDataItem(pfCscDataItem:ParsePFCscDataItem)
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
  
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'self' is [\(String(describing: self))] - parameter is 'pfCscDataItem' is [\(pfCscDataItem)]...")

        // Finish the 'overlay' update of field(s)...

        self.idPFCscObject                  = pfCscDataItem.idPFCscObject               

    //  'Object' From/To update does NOT occur in an 'overlay'...
    //
    //  if (bDeepCopyIsAnOverlay == false)
    //  {
    //  
    //      self.pfCscObjectClonedFrom          = pfCscDataItem 
    //      self.pfCscObjectClonedTo            = nil 
    //
    //      pfCscDataItem.pfCscObjectClonedFrom = nil
    //      pfCscDataItem.pfCscObjectClonedTo   = self
    //  
    //  }
    //
    //  self.pfCscObjectClonedFrom          = pfCscDataItem 
    //  self.pfCscObjectClonedTo            = nil 
    //
    //  pfCscDataItem.pfCscObjectClonedFrom = nil
    //  pfCscDataItem.pfCscObjectClonedTo   = self

        self.pfCscObject                    = pfCscDataItem.pfCscObject                 
        
        self.sPFCscParseClassName           = pfCscDataItem.sPFCscParseClassName        
        self.sPFCscParseObjectId            = pfCscDataItem.sPFCscParseObjectId         
        self.datePFCscParseCreatedAt        = pfCscDataItem.datePFCscParseCreatedAt     
        self.datePFCscParseUpdatedAt        = pfCscDataItem.datePFCscParseUpdatedAt     
        self.aclPFCscParse                  = pfCscDataItem.aclPFCscParse               
        self.bPFCscParseIsDataAvailable     = pfCscDataItem.bPFCscParseIsDataAvailable  
        self.bPFCscParseIdDirty             = pfCscDataItem.bPFCscParseIdDirty          
        self.sPFCscParseAllKeys             = pfCscDataItem.sPFCscParseAllKeys          
        
        self.sPFCscParseName                = pfCscDataItem.sPFCscParseName             
        self.sPFCscParseLastLocDate         = pfCscDataItem.sPFCscParseLastLocDate      
        self.sPFCscParseLastLocTime         = pfCscDataItem.sPFCscParseLastLocTime      
        self.sPFCscParseLastLatitude        = pfCscDataItem.sPFCscParseLastLatitude     
        self.sPFCscParseLastLongitude       = pfCscDataItem.sPFCscParseLastLongitude    
        
        self.pfCscObjectLatitude            = pfCscDataItem.pfCscObjectLatitude         
        self.pfCscObjectLongitude           = pfCscDataItem.pfCscObjectLongitude        
        self.sPFCscObjectLatitude           = pfCscDataItem.sPFCscObjectLatitude        
        self.sPFCscObjectLongitude          = pfCscDataItem.sPFCscObjectLongitude       
        self.dblPFCscObjectLatitude         = pfCscDataItem.dblPFCscObjectLatitude      
        self.dblPFCscObjectLongitude        = pfCscDataItem.dblPFCscObjectLongitude     

        let dblPreviousLatitude:Double      = self.dblConvertedLatitude
        let dblPreviousLongitude:Double     = self.dblConvertedLongitude
        let dblCurrentLatitude:Double       = pfCscDataItem.dblConvertedLatitude
        let dblCurrentLongitude:Double      = pfCscDataItem.dblConvertedLongitude

        self.dblConvertedLatitude           = pfCscDataItem.dblConvertedLatitude        
        self.dblConvertedLongitude          = pfCscDataItem.dblConvertedLongitude       

        self.sPFTherapistParseTID           = pfCscDataItem.sPFTherapistParseTID        

        // If 'self' (current) does NOT have 'important' location data, then copy all of it...

        if (self.sCurrentLocationName.count < 1 ||
            self.sCurrentCity.count         < 1)
        {
        
            self.sCurrentLocationName           = pfCscDataItem.sCurrentLocationName        
            self.sCurrentCity                   = pfCscDataItem.sCurrentCity                
            self.sCurrentCountry                = pfCscDataItem.sCurrentCountry             
            self.sCurrentPostalCode             = pfCscDataItem.sCurrentPostalCode          
            self.sCurrentTimeZone               = pfCscDataItem.sCurrentTimeZone            

            self.bCurrentAddessLookupScheduled  = pfCscDataItem.bCurrentAddessLookupScheduled
            self.bCurrentAddessLookupComplete   = pfCscDataItem.bCurrentAddessLookupComplete
        
        }
        else
        {

            // 'self' (current) has location data, then use latitude/longitude changes to determine the update...

        //  let bLocationLatitudeHasChanged:Bool  = (abs(self.dblConvertedLatitude  - pfCscDataItem.dblConvertedLatitude)  <= .ulpOfOne)
        //  let bLocationLongitudeHasChanged:Bool = (abs(self.dblConvertedLongitude - pfCscDataItem.dblConvertedLongitude) <= .ulpOfOne)

            let bLocationLatitudeHasChanged:Bool  = (abs(dblPreviousLatitude  - dblCurrentLatitude)  > (3 * .ulpOfOne))
            let bLocationLongitudeHasChanged:Bool = (abs(dblPreviousLongitude - dblCurrentLongitude) > (3 * .ulpOfOne))

            if (bLocationLatitudeHasChanged  == true ||
                bLocationLongitudeHasChanged == true)
            {
            
                self.sCurrentLocationName           = pfCscDataItem.sCurrentLocationName        
                self.sCurrentCity                   = pfCscDataItem.sCurrentCity                
                self.sCurrentCountry                = pfCscDataItem.sCurrentCountry             
                self.sCurrentPostalCode             = pfCscDataItem.sCurrentPostalCode          
                self.sCurrentTimeZone               = pfCscDataItem.sCurrentTimeZone            

                self.bCurrentAddessLookupScheduled  = pfCscDataItem.bCurrentAddessLookupScheduled
                self.bCurrentAddessLookupComplete   = pfCscDataItem.bCurrentAddessLookupComplete

                self.xcgLogMsg("\(sCurrMethodDisp) Intermediate <dup 'overlay'> <PFCsc> <location check> - Copied address data since 'bLocationLatitudeHasChanged' is [\(bLocationLatitudeHasChanged)] and/or 'bLocationLongitudeHasChanged' is [\(bLocationLongitudeHasChanged)] <location changed>...")
                self.xcgLogMsg("\(sCurrMethodDisp) Intermediate <dup 'overlay'> <PFCsc> <location check> - Location is [\(dblCurrentLatitude),\(dblCurrentLongitude)] and was [\(dblPreviousLatitude),\(dblPreviousLongitude)]...")

                if (self.sCurrentLocationName.count < 1 ||
                    self.sCurrentCity.count         < 1)
                {
                
                    self.bCurrentAddessLookupScheduled  = false
                    self.bCurrentAddessLookupComplete   = false
                
                }
            
            }
            else
            {
            
                self.xcgLogMsg("\(sCurrMethodDisp) Intermediate <dup 'overlay'> <PFCsc> <location check> - Skipped copying address data since 'bLocationLatitudeHasChanged' is [\(bLocationLatitudeHasChanged)] and 'bLocationLongitudeHasChanged' is [\(bLocationLongitudeHasChanged)] <location has NOT changed>...")
            
            }

        }
        
        // Check if the 'current' Location data copied was 'blank'...

        if (self.sCurrentLocationName.count < 1 ||
            self.sCurrentCity.count         < 1)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) Intermediate <dup 'overlay'> <PFCsc> - Copied 'self.sCurrentLocationName' is [\(self.sCurrentLocationName)] and 'self.sCurrentCity' is [\(self.sCurrentCity)] - 1 or both are 'blank' - 'pfCscDataItem.sCurrentLocationName' is [\(pfCscDataItem.sCurrentLocationName)] and 'pfCscDataItem.sCurrentCity' is [\(pfCscDataItem.sCurrentCity)] - Warning!")

            self.resolveLocationAndAddress()

        }

        // Trace the 'clone' From/To fields in both objects...

        self.xcgLogMsg("\(sCurrMethodDisp) Intermediate <dup 'overlay'> <PFCsc> - From/To 'self.pfCscObjectClonedFrom' is [\(String(describing: self.pfCscObjectClonedFrom))] and 'self.pfCscObjectClonedTo' is [\(String(describing: self.pfCscObjectClonedTo))] - 'pfCscDataItem.pfCscObjectClonedFrom' is [\(String(describing: pfCscDataItem.pfCscObjectClonedFrom))] and 'pfCscDataItem.pfCscObjectClonedTo' is [\(String(describing: pfCscDataItem.pfCscObjectClonedTo))]...")

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return
  
    }   // End of convenience init(pfCscDataItem:ParsePFCscDataItem).

    public func resolveLocationAndAddress()
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        if (self.bCurrentAddessLookupScheduled == true)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) Intermediate - bypassing the address 'resolve' - 'self.bCurrentAddessLookupScheduled' is [\(self.bCurrentAddessLookupScheduled)]...")

            // Exit:

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return
        
        }

        // Use the Latitude/Longitude values to resolve address...

        if (self.jmAppDelegateVisitor.jmAppCLModelObservable2 != nil)
        {

            let clModelObservable2:CoreLocationModelObservable2 = self.jmAppDelegateVisitor.jmAppCLModelObservable2!

            self.bCurrentAddessLookupScheduled = true
            self.bCurrentAddessLookupComplete  = false
            
        //  let dblDeadlineInterval:Double     = Double((0.5 * Double(self.idPFCscObject)))
        //  let dblDeadlineInterval:Double     = Double((1.2 * Double(self.idPFCscObject)))
        //  let dblDeadlineInterval:Double     = clModelObservable2.requestNextReverseLocationLookupDeadlineInterval()
            let dblDeadlineInterval:Double     = clModelObservable2.requestNextReverseLocationLookupDeadlineInterval(clRevLocType:CLRevLocType.primary)

            DispatchQueue.main.asyncAfter(deadline:(.now() + dblDeadlineInterval))
            {
                self.xcgLogMsg("\(sCurrMethodDisp) #(\(self.idPFCscObject)): <closure> Calling 'updateGeocoderLocation()' with 'self' of [\(String(describing: self))] for Latitude/Longitude of [\(self.dblConvertedLatitude)/\(self.dblConvertedLongitude)] for Therapist [\(self.sPFCscParseName)]...")

                let _ = clModelObservable2.updateGeocoderLocations(requestID: self.idPFCscObject, 
                                                                   latitude:  self.dblConvertedLatitude, 
                                                                   longitude: self.dblConvertedLongitude, 
                                                                   withCompletionHandler:
                                                                       { (requestID:Int, dictCurrentLocation:[String:Any]) in
                                                                           self.handleLocationAndAddressClosureEvent(bIsDownstreamObject:false, requestID:requestID, dictCurrentLocation:dictCurrentLocation)
                                                                       }
                                                                  )
            }

        }
        else
        {

            self.bCurrentAddessLookupScheduled = false
            self.bCurrentAddessLookupComplete  = false

            self.xcgLogMsg("\(sCurrMethodDisp) #(\(self.idPFCscObject)): CoreLocation (service) is NOT available...")

        }

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of public func resolveLocationAndAddress().

    public func handleLocationAndAddressClosureEvent(bIsDownstreamObject:Bool = false, requestID:Int, dictCurrentLocation:[String:Any])
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'self' is [\(String(describing: self))] for Therapist [\(self.sPFCscParseName)] - parameter 'bIsDownstreamObject' is [\(bIsDownstreamObject)] - 'requestID' is [\(requestID)] - 'dictCurrentLocation' is [\(String(describing: dictCurrentLocation))]...")

        // Update the address info for BOTH 'self' and (possibly 'from'/'to')...

        if (dictCurrentLocation.count > 0)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) #(\(requestID)): <closure> Called  'updateGeocoderLocation()' with 'self' of [\(String(describing: self))] for Latitude/Longitude of [\(self.dblConvertedLatitude)/\(self.dblConvertedLongitude)] for Therapist [\(self.sPFCscParseName)] current 'location' [\(String(describing: dictCurrentLocation))]...")

            self.sCurrentLocationName         = String(describing: (dictCurrentLocation["sCurrentLocationName"] ?? ""))
            self.sCurrentCity                 = String(describing: (dictCurrentLocation["sCurrentCity"]         ?? ""))
            self.sCurrentCountry              = String(describing: (dictCurrentLocation["sCurrentCountry"]      ?? ""))
            self.sCurrentPostalCode           = String(describing: (dictCurrentLocation["sCurrentPostalCode"]   ?? ""))
            self.sCurrentTimeZone             = String(describing: (dictCurrentLocation["tzCurrentTimeZone"]    ?? ""))

            self.bCurrentAddessLookupComplete = true

            if (bIsDownstreamObject == false)
            {
            
                if (self.pfCscObjectClonedFrom != nil &&
                    self.pfCscObjectClonedFrom != self)
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) #(\(requestID)): <closure> Calling 'self.pfCscObjectClonedFrom' of [\(String(describing: self.pfCscObjectClonedFrom))] with 'self' of [\(String(describing: self))] for Therapist [\(self.sPFCscParseName)]...")

                    self.pfCscObjectClonedFrom!.handleLocationAndAddressClosureEvent(bIsDownstreamObject:true, requestID:requestID, dictCurrentLocation:dictCurrentLocation)

                    self.xcgLogMsg("\(sCurrMethodDisp) #(\(requestID)): <closure> Called  'self.pfCscObjectClonedFrom' of [\(String(describing: self.pfCscObjectClonedFrom))] with 'self' of [\(String(describing: self))] for Therapist [\(self.sPFCscParseName)]...")

                }

                if (self.pfCscObjectClonedTo != nil &&
                    self.pfCscObjectClonedTo != self)
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) #(\(requestID)): <closure> Calling 'self.pfCscObjectClonedTo' of [\(String(describing: self.pfCscObjectClonedTo))] with 'self' of [\(String(describing: self))] for Therapist [\(self.sPFCscParseName)]...")

                    self.pfCscObjectClonedTo!.handleLocationAndAddressClosureEvent(bIsDownstreamObject:true, requestID:requestID, dictCurrentLocation:dictCurrentLocation)

                    self.xcgLogMsg("\(sCurrMethodDisp) #(\(requestID)): <closure> Called  'self.pfCscObjectClonedTo' of [\(String(describing: self.pfCscObjectClonedTo))] with 'self' of [\(String(describing: self))] for Therapist [\(self.sPFCscParseName)]...")

                }
            
            }
        
        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) #(\(requestID)): Dictionary 'dictCurrentLocation' is 'empty' - bypassing update - Warning!")

            self.bCurrentAddessLookupComplete = false

        }

        self.bCurrentAddessLookupScheduled = false

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of public func handleLocationAndAddressClosureEvent(bIsDownstreamObject:Bool, requestID:Int, dictCurrentLocation:[String:Any]).

}   // End of class ParsePFCscDataItem(NSObject, Identifiable).

