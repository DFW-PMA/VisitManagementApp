//
//  ParsePFBackupFileItem.swift
//  VisitManagementApp
//
//  Created by JustMacApps.net on 04/14/2025.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
import SwiftUI
import MapKit
import ParseCore

class ParsePFBackupFileItem: NSObject, Identifiable
{

    struct ClassInfo
    {
        
        static let sClsId        = "ParsePFBackupFileItem"
        static let sClsVers      = "v1.0401"
        static let sClsDisp      = sClsId+"(.swift).("+sClsVers+"):"
        static let sClsCopyRight = "Copyright (C) JustMacApps 2023-2025. All Rights Reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }

    // 'Internal' Trace flag:

    private 
    var bInternalTraceFlag:Bool                             = false

    // Item Data field(s):
    
    var id                                                  = UUID()

    var pfBackupFileObjectClonedFrom:ParsePFBackupFileItem? = nil 
    var pfBackupFileObjectClonedTo:ParsePFBackupFileItem?   = nil 

    // ------------------------------------------------------------------------------------------
    //  'pfBackupFileObject' is [<CSC: 0x301e16700, objectId: qpp1fxx68P, localId: (null)> 
    //  {
    //      name        = "Office Ernesto";
    //      lastLocDate = "11/14/24";
    //      lastLocTime = "4:15\U202fPM";
    //      latitude    = "32.83285140991211";
    //      longitude   = "-97.071533203125";
    //  }]...
    // ------------------------------------------------------------------------------------------

    var pfBackupFilePFObject:PFObject?                      = nil

    // ----------------------------------------------------------------------------------------------------------------
    //  TYPE of 'pfBackupFileObject'                 is [PFObject]         - value is [<CSC: 0x302ee1080, objectId: ...
    //  TYPE of 'pfBackupFileObject.parseClassName'  is [String]           - value is [CSC]...
    //  TYPE of 'pfBackupFileObject.objectId'        is [Optional<String>] - value is [Optional("dztxUrBZLr")]...
    //  TYPE of 'pfBackupFileObject.createdAt'       is [Optional<Date>]   - value is [Optional(2024-11-13 17:13:57 +0000)]...
    //  TYPE of 'pfBackupFileObject.updatedAt'       is [Optional<Date>]   - value is [Optional(2024-11-14 22:30:00 +0000)]...
    //  TYPE of 'pfBackupFileObject.acl'             is [Optional<PFACL>]  - value is [nil]...
    //  TYPE of 'pfBackupFileObject.isDataAvailable' is [Bool]             - value is [true]...
    //  TYPE of 'pfBackupFileObject.isDirty'         is [Bool]             - value is [false]...
    //  TYPE of 'pfBackupFileObject.allKeys'         is [Array<String>]    - value is [["lastLocTime", "latitude", ...
    // ----------------------------------------------------------------------------------------------------------------

    // Item 'discrete' field(s):

    var sPFBackupFileParseClassName:String                  = ""
    var sPFBackupFileParseObjectId:String?                  = nil
    var datePFBackupFileParseCreatedAt:Date?                = nil
    var datePFBackupFileParseUpdatedAt:Date?                = nil
    var aclPFBackupFileParse:PFACL?                         = nil
    var bPFBackupFileParseIsDataAvailable:Bool              = false
    var bPFBackupFileParseIdDirty:Bool                      = false
    var sPFBackupFileParseAllKeys:[String]                  = []

    // ----------------------------------------------------------------------------------------------------------------
    //     TYPE of 'pfBackupFileObject[name]'        is [Optional<Any>] - value is [Optional(Mihal Lasky)]...
    //     TYPE of 'pfBackupFileObject[lastLocDate]' is [Optional<Any>] - value is [Optional(11/14/24)]...
    //     TYPE of 'pfBackupFileObject[lastLocTime]' is [Optional<Any>] - value is [Optional(4:30 PM)]...
    //     TYPE of 'pfBackupFileObject[latitude]'    is [Optional<Any>] - value is [Optional(32.77201080322266)]...
    //     TYPE of 'pfBackupFileObject[longitude]'   is [Optional<Any>] - value is [Optional(-96.5831298828125)]...
    // ----------------------------------------------------------------------------------------------------------------

    // Item 'keyed' field(s):

    var sTid:String                                         = "-1" // From 'PFQuery::BackupVisit["tidString"]'
    var iTid:Int                                            = -1   // From 'PFQuery::BackupVisit["tid"]'

    var sPid:String                                         = "-1" // Converted from 'iPid <Int>'...
    var iPid:Int                                            = -1   // From 'PFQuery::BackupVisit["pid"]' <Int>

    var sLastVDate:String                                   = ""   // From 'PFQuery::BackupVisit["VDate"]'
    var sLastVDateType:String                               = "-1" // From 'PFQuery::BackupVisit["type"]'
    var iLastVDateType:Int                                  = -1   // Converted from 'sLastVDateType <String>'...
    var sLastVDateLatitude:String                           = ""   // From 'PFQuery::BackupVisit["lat"]'
    var sLastVDateLongitude:String                          = ""   // From 'PFQuery::BackupVisit["long"]'
    var sLastVDateAddress:String                            = ""   // From 'PFQuery::BackupVisit["address"]'

    // ----------------------------------------------------------------------------------------------------------------
    //  TYPE of 'pfBackupFileObjectLatitude'     is [Optional<Any>] - value is [Optional(32.77201080322266)]...
    //  TYPE of 'pfBackupFileObjectLongitude'    is [Optional<Any>] - value is [Optional(-96.5831298828125)]...
    //  TYPE of 'sPFBackupFileObjectLatitude'    is [String]        - value is [32.77201080322266]...
    //  TYPE of 'sPFBackupFileObjectLongitude'   is [String]        - value is [-96.5831298828125]...
    //  TYPE of 'dblPFBackupFileObjectLatitude'  is [Double]        - value is [32.77201080322266]...
    //  TYPE of 'dblPFBackupFileObjectLongitude' is [Double]        - value is [-96.5831298828125]...
    //  TYPE of 'dblConvertedLatitude'           is [Double]        - value is [32.77201080322266]...
    //  TYPE of 'dblConvertedLongitude'          is [Double]        - value is [-96.5831298828125]...
    //  TYPE of 'sCurrentLocationName'           is [String]        - value is [-N/A-]...
    //  TYPE of 'sCurrentCity'                   is [String]        - value is [-N/A-]...
    // ----------------------------------------------------------------------------------------------------------------

    // Item 'calculated'/'converted'/'look-up'/'computed' field(s):

    var pfBackupFileObjectLatitude:Any?                     = nil
    var pfBackupFileObjectLongitude:Any?                    = nil

    var sPFBackupFileObjectLatitude:String                  = "0.00000"
    var sPFBackupFileObjectLongitude:String                 = "0.00000"

    var dblPFBackupFileObjectLatitude:Double                = 0.00000
    var dblPFBackupFileObjectLongitude:Double               = 0.00000

    var dblConvertedLatitude:Double                         = 0.00000
    var dblConvertedLongitude:Double                        = 0.00000

    // Item address 'lookup' flag(s) and field(s):

    var bCurrentAddessLookupScheduled:Bool                  = false
    var bCurrentAddessLookupComplete:Bool                   = false

    var sCurrentLocationName:String                         = ""
    var sCurrentCity:String                                 = ""
    var sCurrentCountry:String                              = ""
    var sCurrentPostalCode:String                           = ""
    var sCurrentTimeZone:String                             = ""

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

    var jmAppDelegateVisitor:JmAppDelegateVisitor           = JmAppDelegateVisitor.ClassSingleton.appDelegateVisitor
    
    override init()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        super.init()

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of override init().

    convenience init(pfBackupVisit:PFObject)
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
  
        self.init()
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Finish the 'convenience' setup of field(s)...

        self.updateParsePFBackupFileItemFromPFBackupVisit(pfBackupVisit:pfBackupVisit)

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return
  
    }   // End of convenience init(pfBackupVisit:PFObject).

    convenience init(pfBackupFileItem:ParsePFBackupFileItem)
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
  
        self.init()
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Finish the 'convenience' setup of field(s)...

        self.init(bDeepCopyIsAnOverlay:false, pfBackupFileItem:pfBackupFileItem)

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return
  
    }   // End of convenience init(pfBackupFileItem:ParsePFBackupFileItem).

    convenience init(bDeepCopyIsAnOverlay:Bool, pfBackupFileItem:ParsePFBackupFileItem)
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
  
        self.init()
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Finish the 'convenience' setup of field(s)...

        self.overlayPFBackupFileItemWithAnotherPFBackupFileItem(pfBackupFileItem:pfBackupFileItem)

        if (bDeepCopyIsAnOverlay == false)
        {
        
            self.pfBackupFileObjectClonedFrom             = pfBackupFileItem 
            self.pfBackupFileObjectClonedTo               = self 

        //  pfBackupFileItem.pfBackupFileObjectClonedFrom = nil
            pfBackupFileItem.pfBackupFileObjectClonedTo   = self
        
        }

        // Check if the 'current' Location data copied was 'blank'...

        if (self.sCurrentLocationName.count < 1 ||
            self.sCurrentCity.count         < 1)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) Intermediate <dup copy 'init'> <PFBackupFile> - Copied 'self.sCurrentLocationName' is [\(self.sCurrentLocationName)] and 'self.sCurrentCity' is [\(self.sCurrentCity)] - 1 or both are 'blank' - 'PFBackupFileItem.sCurrentLocationName' is [\(pfBackupFileItem.sCurrentLocationName)] and 'PFBackupFileItem.sCurrentCity' is [\(pfBackupFileItem.sCurrentCity)] - Warning!")
        
        }

        // Trace the 'clone' From/To fields in both objects...

        self.xcgLogMsg("\(sCurrMethodDisp) Intermediate <dup copy 'init'> <PFBackupFile> - From/To 'self.pfBackupFileObjectClonedFrom' is [\(String(describing: self.pfBackupFileObjectClonedFrom))] and 'self.pfBackupFileObjectClonedTo' is [\(String(describing: self.pfBackupFileObjectClonedTo))] - 'PFBackupFileItem.pfBackupFileObjectClonedFrom' is [\(String(describing: pfBackupFileItem.pfBackupFileObjectClonedFrom))] and 'PFBackupFileItem.pfBackupFileObjectClonedTo' is [\(String(describing: pfBackupFileItem.pfBackupFileObjectClonedTo))]...")

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return
  
    }   // End of convenience init(bDeepCopyIsAnOverlay:Bool, pfBackupFileItem:ParsePFBackupFileItem).

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
        asToString.append("'pfBackupFileObjectClonedFrom': [\(String(describing: self.pfBackupFileObjectClonedFrom))],")
        asToString.append("'pfBackupFileObjectClonedTo': [\(String(describing: self.pfBackupFileObjectClonedTo))],")
        asToString.append("],")
        asToString.append("[")

    //  asToString.append("'pfBackupFilePFObject': [\(String(describing: self.pfBackupFilePFObject))],")

        if (self.pfBackupFilePFObject == nil)
        {
            asToString.append("'pfBackupFilePFObject': [-nil-],")
        }
        else
        {
            asToString.append("'pfBackupFilePFObject': [-available-],")
        }

        asToString.append("],")
        asToString.append("[")
        asToString.append("'sPFBackupFileParseClassName': [\(String(describing: self.sPFBackupFileParseClassName))],")
        asToString.append("'sPFBackupFileParseObjectId': [\(String(describing: self.sPFBackupFileParseObjectId))],")
        asToString.append("'datePFBackupFileParseCreatedAt': [\(String(describing: self.datePFBackupFileParseCreatedAt))],")
        asToString.append("'datePFBackupFileParseUpdatedAt': [\(String(describing: self.datePFBackupFileParseUpdatedAt))],")
        asToString.append("'aclPFBackupFileParse': [\(String(describing: self.aclPFBackupFileParse))],")
        asToString.append("'bPFBackupFileParseIsDataAvailable': [\(String(describing: self.bPFBackupFileParseIsDataAvailable))],")
        asToString.append("'bPFBackupFileParseIdDirty': [\(String(describing: self.bPFBackupFileParseIdDirty))],")
        asToString.append("'sPFBackupFileParseAllKeys': [\(String(describing: self.sPFBackupFileParseAllKeys))],")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'sTid': [\(String(describing: self.sTid))],")
        asToString.append("'iTid': (\(String(describing: self.iTid))),")
        asToString.append("'sPid': [\(String(describing: self.sPid))],")
        asToString.append("'iPid': (\(String(describing: self.iPid))),")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'sLastVDate': [\(String(describing: self.sLastVDate))],")
        asToString.append("'sLastVDateType': [\(String(describing: self.sLastVDateType))],")
        asToString.append("'iLastVDateType': (\(String(describing: self.iLastVDateType))),")
        asToString.append("'sLastVDateLatitude': [\(String(describing: self.sLastVDateLatitude))],")
        asToString.append("'sLastVDateLongitude': [\(String(describing: self.sLastVDateLongitude))],")
        asToString.append("'sLastVDateAddress': [\(String(describing: self.sLastVDateAddress))],")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'pfBackupFileObjectLatitude': [\(String(describing: self.pfBackupFileObjectLatitude))],")
        asToString.append("'pfBackupFileObjectLongitude': [\(String(describing: self.pfBackupFileObjectLongitude))],")
        asToString.append("'sPFBackupFileObjectLatitude': [\(String(describing: self.sPFBackupFileObjectLatitude))],")
        asToString.append("'sPFBackupFileObjectLongitude': [\(String(describing: self.sPFBackupFileObjectLongitude))],")
        asToString.append("'dblPFBackupFileObjectLatitude': [\(String(describing: self.dblPFBackupFileObjectLatitude))],")
        asToString.append("'dblPFBackupFileObjectLongitude': [\(String(describing: self.dblPFBackupFileObjectLongitude))],")
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

    public func displayParsePFBackupFileItemToLog()
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Display the various field(s) of this object in the Log...

        self.xcgLogMsg("\(sCurrMethodDisp) 'self'                              is [\(String(describing: self))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'id'                                is [\(String(describing: self.id))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'pfBackupFileObjectClonedFrom'      is [\(String(describing: self.pfBackupFileObjectClonedFrom))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'pfBackupFileObjectClonedTo'        is [\(String(describing: self.pfBackupFileObjectClonedTo))]...")

    //  self.xcgLogMsg("\(sCurrMethodDisp) 'pfBackupFilePFObject'              is [\(String(describing: self.pfBackupFilePFObject))]...")

        if (self.pfBackupFilePFObject == nil)
        {
            self.xcgLogMsg("\(sCurrMethodDisp) 'pfBackupFilePFObject':             is [-nil-]...")
        }
        else
        {
            self.xcgLogMsg("\(sCurrMethodDisp) 'pfBackupFilePFObject':             is [-available-]...")
        }

        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFBackupFileParseClassName'       is [\(String(describing: self.sPFBackupFileParseClassName))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFBackupFileParseObjectId'        is [\(String(describing: self.sPFBackupFileParseObjectId))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'datePFBackupFileParseCreatedAt'    is [\(String(describing: self.datePFBackupFileParseCreatedAt))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'datePFBackupFileParseUpdatedAt'    is [\(String(describing: self.datePFBackupFileParseUpdatedAt))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'aclPFBackupFileParse'              is [\(String(describing: self.aclPFBackupFileParse))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'bPFBackupFileParseIsDataAvailable' is [\(String(describing: self.bPFBackupFileParseIsDataAvailable))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'bPFBackupFileParseIdDirty'         is [\(String(describing: self.bPFBackupFileParseIdDirty))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFBackupFileParseAllKeys'         is [\(String(describing: self.sPFBackupFileParseAllKeys))]...")

        self.xcgLogMsg("\(sCurrMethodDisp) 'sTid'                              is [\(String(describing: self.sTid))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'iTid'                              is (\(String(describing: self.iTid)))...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPid'                              is [\(String(describing: self.sPid))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'iPid'                              is (\(String(describing: self.iPid)))...")

        self.xcgLogMsg("\(sCurrMethodDisp) 'sLastVDate'                        is [\(String(describing: self.sLastVDate))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sLastVDateType'                    is [\(String(describing: self.sLastVDateType))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'iLastVDateType'                    is (\(String(describing: self.iLastVDateType)))...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sLastVDateLatitude'                is [\(String(describing: self.sLastVDateLatitude))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sLastVDateLongitude'               is [\(String(describing: self.sLastVDateLongitude))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sLastVDateAddress'                 is [\(String(describing: self.sLastVDateAddress))]...")

        self.xcgLogMsg("\(sCurrMethodDisp) 'pfBackupFileObjectLatitude'        is [\(String(describing: self.pfBackupFileObjectLatitude))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'pfBackupFileObjectLongitude'       is [\(String(describing: self.pfBackupFileObjectLongitude))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFBackupFileObjectLatitude'       is [\(String(describing: self.sPFBackupFileObjectLatitude))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFBackupFileObjectLongitude'      is [\(String(describing: self.sPFBackupFileObjectLongitude))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'dblPFBackupFileObjectLatitude'     is [\(String(describing: self.dblPFBackupFileObjectLatitude))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'dblPFBackupFileObjectLongitude'    is [\(String(describing: self.dblPFBackupFileObjectLongitude))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'dblConvertedLatitude'              is [\(String(describing: self.dblConvertedLatitude))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'dblConvertedLongitude'             is [\(String(describing: self.dblConvertedLongitude))]...")

        self.xcgLogMsg("\(sCurrMethodDisp) 'bCurrentAddessLookupScheduled'     is [\(String(describing: self.bCurrentAddessLookupScheduled))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'bCurrentAddessLookupComplete'      is [\(String(describing: self.bCurrentAddessLookupComplete))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sCurrentLocationName'              is [\(String(describing: self.sCurrentLocationName))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sCurrentCity'                      is [\(String(describing: self.sCurrentCity))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sCurrentCountry'                   is [\(String(describing: self.sCurrentCountry))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sCurrentPostalCode'                is [\(String(describing: self.sCurrentPostalCode))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sCurrentTimeZone'                  is [\(String(describing: self.sCurrentTimeZone))]...")

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of public func displayParsePFBackupFileItemToLog().

    public func updateParsePFBackupFileItemFromPFBackupVisit(pfBackupVisit:PFObject)
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'self' is [\(String(describing: self))]...")

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Parameter 'pfBackupVisit' is [\(String(describing: pfBackupVisit))]...")

        }

        // Assign the various field(s) of this object from the supplied PFObject...

        self.pfBackupFilePFObject              = pfBackupVisit                 

        self.sPFBackupFileParseClassName       = pfBackupVisit.parseClassName
        self.sPFBackupFileParseObjectId        = pfBackupVisit.objectId  != nil ? pfBackupVisit.objectId!  : ""
        self.datePFBackupFileParseCreatedAt    = pfBackupVisit.createdAt != nil ? pfBackupVisit.createdAt! : nil
        self.datePFBackupFileParseUpdatedAt    = pfBackupVisit.updatedAt != nil ? pfBackupVisit.updatedAt! : nil
        self.aclPFBackupFileParse              = pfBackupVisit.acl
        self.bPFBackupFileParseIsDataAvailable = pfBackupVisit.isDataAvailable
        self.bPFBackupFileParseIdDirty         = pfBackupVisit.isDirty
        self.sPFBackupFileParseAllKeys         = pfBackupVisit.allKeys

        self.sTid                              = String(describing: (pfBackupVisit.object(forKey:"tidString") ?? "-1"))
        self.iTid                              = Int(String(describing: (pfBackupVisit.object(forKey:"tid")   ?? "-1"))) ?? -2
        self.iPid                              = Int(String(describing: (pfBackupVisit.object(forKey:"pid")   ?? "-1"))) ?? -2
        self.sPid                              = "\(self.iPid)"

        self.sLastVDate                        = String(describing: (pfBackupVisit.object(forKey:"VDate")   ?? ""))
        self.sLastVDateType                    = String(describing: (pfBackupVisit.object(forKey:"type")    ?? "-1"))
        self.iLastVDateType                    = Int(self.sLastVDateType)!
        self.sLastVDateAddress                 = String(describing: (pfBackupVisit.object(forKey:"address") ?? ""))
        self.sLastVDateLatitude                = String(describing: (pfBackupVisit.object(forKey:"lat")     ?? ""))
        self.sLastVDateLongitude               = String(describing: (pfBackupVisit.object(forKey:"long")    ?? ""))

        self.pfBackupFileObjectLatitude        = (pfBackupVisit.object(forKey:"lat"))  != nil ? pfBackupVisit.object(forKey:"lat")  : nil
        self.pfBackupFileObjectLongitude       = (pfBackupVisit.object(forKey:"long")) != nil ? pfBackupVisit.object(forKey:"long") : nil
        self.sPFBackupFileObjectLatitude       = String(describing: (self.pfBackupFileObjectLatitude  ?? "0.0000"))
        self.sPFBackupFileObjectLongitude      = String(describing: (self.pfBackupFileObjectLongitude ?? "0.0000"))
        self.dblPFBackupFileObjectLatitude     = Double(self.sPFBackupFileObjectLatitude)  ?? 0.0
        self.dblPFBackupFileObjectLongitude    = Double(self.sPFBackupFileObjectLongitude) ?? 0.0
        self.dblConvertedLatitude              = Double(String(describing: (self.pfBackupFileObjectLatitude  ?? "0.0000"))) ?? 0.0
        self.dblConvertedLongitude             = Double(String(describing: (self.pfBackupFileObjectLongitude ?? "0.0000"))) ?? 0.0
        
        self.bCurrentAddessLookupScheduled     = false
        self.bCurrentAddessLookupComplete      = false

        self.sCurrentLocationName              = ""
        self.sCurrentCity                      = ""
        self.sCurrentCountry                   = ""
        self.sCurrentPostalCode                = ""
        self.sCurrentTimeZone                  = ""

        self.resolveLocationAndAddress()

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of public func updateParsePFBackupFileItemFromPFBackupVisit(pfBackupVisit:PFObject).

    public func updateParsePFBackupFileItemFromPFBackupVisitIfNewer(pfBackupVisit:PFObject)
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'self' is [\(String(describing: self))]...")

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Parameter 'pfBackupVisit' is [\(String(describing: pfBackupVisit))]...")

        }

        // Create a 'pfBackupFileItem' object from the supplied PFObject...

        let pfBackupFileItem:ParsePFBackupFileItem = ParsePFBackupFileItem(pfBackupVisit:pfBackupVisit)

        self.updateParsePFBackupFileItemFromPFBackupVisitIfNewer(pfBackupFileItem:pfBackupFileItem)

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of public func updateParsePFBackupFileItemFromPFBackupVisitIfNewer(pfBackupVisit:PFObject).

    public func updateParsePFBackupFileItemFromPFBackupVisitIfNewer(pfBackupFileItem:ParsePFBackupFileItem)
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'self' is [\(String(describing: self))]...")

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Parameter 'pfBackupFileItem' is [\(String(describing: pfBackupFileItem))]...")

        }

        // If there is no supplied Date value, then just return...

        if (pfBackupFileItem.sLastVDate.count < 1)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) The created 'pfBackupFileItem' object has a 'sLastVDate' of [\(String(describing: pfBackupFileItem.sLastVDate))] that is an 'empty' string - unable to compare dates - Warning!")

            // Exit:

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return
        
        }
        
        // if the current (self) Data is an 'empty' string, then update this object from the created one...

        if (self.sLastVDate.count < 1)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) The current 'self' object has a 'sLastVDate' of [\(String(describing: self.sLastVDate))] that is an 'empty' string - updating from the supplied object...")

            self.overlayPFBackupFileItemWithAnotherPFBackupFileItem(pfBackupFileItem:pfBackupFileItem)

            // Exit:

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return
        
        }

        // Both objects' have a date, convert both date string(s) to date objects for comparison...

        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat        = "yyyy-MM-dd"

        guard let dateSuppliedLastVDate:Date = dateFormatter.date(from:pfBackupFileItem.sLastVDate)
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) The supplied 'pfBackupFileItem' object has a 'sLastVDate' of [\(String(describing: pfBackupFileItem.sLastVDate))] string that failed to convert to a date - unable to compare dates - Warning!")

            // Exit:

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return

        }

        guard let dateCurrentLastVDate:Date = dateFormatter.date(from:self.sLastVDate)
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) The current 'self' object has a 'sLastVDate' of [\(String(describing: self.sLastVDate))] string that failed to convert to a date - updating from the created object...")

            self.overlayPFBackupFileItemWithAnotherPFBackupFileItem(pfBackupFileItem:pfBackupFileItem)

            // Exit:

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return

        }

        // Both objects' have a date, if the date of this Visit is newer than the one in this object, then update this object from it...

        if (dateSuppliedLastVDate > dateCurrentLastVDate)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) The supplied date 'dateSuppliedLastVDate' of [\(String(describing: dateSuppliedLastVDate))] is greater (newer) than the current date 'dateCurrentLastVDate' of [\(String(describing: dateCurrentLastVDate))] - updating from the supplied object...")

            self.overlayPFBackupFileItemWithAnotherPFBackupFileItem(pfBackupFileItem:pfBackupFileItem)
        
        }
        else
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) The supplied date 'dateSuppliedLastVDate' of [\(String(describing: dateSuppliedLastVDate))] is NOT greater (newer) than the current date 'dateCurrentLastVDate' of [\(String(describing: dateCurrentLastVDate))] - bypassing updating from the supplied object...")
        
        }

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of public func updateParsePFBackupFileItemFromPFBackupVisitIfNewer(pfBackupFileItem:ParsePFBackupFileItem).

    public func overlayPFBackupFileItemWithAnotherPFBackupFileItem(pfBackupFileItem:ParsePFBackupFileItem)
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
  
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'self' is [\(String(describing: self))]...")

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Parameter 'pfBackupFileItem' is [\(String(describing: pfBackupFileItem))]...")

        }

        // Finish the 'overlay' update of field(s)...

    //  'Object' From/To update does NOT occur in an 'overlay'...
    //
    //  if (bDeepCopyIsAnOverlay == false)
    //  {
    //  
    //      self.pfBackupFileObjectClonedFrom             = pfBackupFileItem 
    //      self.pfBackupFileObjectClonedTo               = nil 
    //
    //      pfBackupFileItem.pfBackupFileObjectClonedFrom = nil
    //      pfBackupFileItem.pfBackupFileObjectClonedTo   = self
    //  
    //  }

        self.pfBackupFilePFObject              = pfBackupFileItem.pfBackupFilePFObject
        
        self.sPFBackupFileParseClassName       = pfBackupFileItem.sPFBackupFileParseClassName        
        self.sPFBackupFileParseObjectId        = pfBackupFileItem.sPFBackupFileParseObjectId         
        self.datePFBackupFileParseCreatedAt    = pfBackupFileItem.datePFBackupFileParseCreatedAt     
        self.datePFBackupFileParseUpdatedAt    = pfBackupFileItem.datePFBackupFileParseUpdatedAt     
        self.aclPFBackupFileParse              = pfBackupFileItem.aclPFBackupFileParse               
        self.bPFBackupFileParseIsDataAvailable = pfBackupFileItem.bPFBackupFileParseIsDataAvailable  
        self.bPFBackupFileParseIdDirty         = pfBackupFileItem.bPFBackupFileParseIdDirty          
        self.sPFBackupFileParseAllKeys         = pfBackupFileItem.sPFBackupFileParseAllKeys          
        
        self.sTid                              = pfBackupFileItem.sTid
        self.iTid                              = pfBackupFileItem.iTid
        self.sPid                              = pfBackupFileItem.sPid
        self.iPid                              = pfBackupFileItem.iPid
                                                                                      
        self.sLastVDate                        = pfBackupFileItem.sLastVDate
        self.sLastVDateType                    = pfBackupFileItem.sLastVDateType
        self.iLastVDateType                    = pfBackupFileItem.iLastVDateType
        self.sLastVDateLatitude                = pfBackupFileItem.sLastVDateLatitude
        self.sLastVDateLongitude               = pfBackupFileItem.sLastVDateLongitude
        self.sLastVDateAddress                 = pfBackupFileItem.sLastVDateAddress

        self.pfBackupFileObjectLatitude        = pfBackupFileItem.pfBackupFileObjectLatitude         
        self.pfBackupFileObjectLongitude       = pfBackupFileItem.pfBackupFileObjectLongitude        
        self.sPFBackupFileObjectLatitude       = pfBackupFileItem.sPFBackupFileObjectLatitude        
        self.sPFBackupFileObjectLongitude      = pfBackupFileItem.sPFBackupFileObjectLongitude       
        self.dblPFBackupFileObjectLatitude     = pfBackupFileItem.dblPFBackupFileObjectLatitude      
        self.dblPFBackupFileObjectLongitude    = pfBackupFileItem.dblPFBackupFileObjectLongitude     

        let dblPreviousLatitude:Double         = self.dblConvertedLatitude
        let dblPreviousLongitude:Double        = self.dblConvertedLongitude
        let dblCurrentLatitude:Double          = pfBackupFileItem.dblConvertedLatitude
        let dblCurrentLongitude:Double         = pfBackupFileItem.dblConvertedLongitude

        self.dblConvertedLatitude              = pfBackupFileItem.dblConvertedLatitude        
        self.dblConvertedLongitude             = pfBackupFileItem.dblConvertedLongitude

        // If 'self' (current) does NOT have 'important' location data, then copy all of it...

        if (self.sCurrentLocationName.count < 1 ||
            self.sCurrentCity.count         < 1)
        {
        
            self.sCurrentLocationName          = pfBackupFileItem.sCurrentLocationName        
            self.sCurrentCity                  = pfBackupFileItem.sCurrentCity                
            self.sCurrentCountry               = pfBackupFileItem.sCurrentCountry             
            self.sCurrentPostalCode            = pfBackupFileItem.sCurrentPostalCode          
            self.sCurrentTimeZone              = pfBackupFileItem.sCurrentTimeZone            

            self.bCurrentAddessLookupScheduled = pfBackupFileItem.bCurrentAddessLookupScheduled
            self.bCurrentAddessLookupComplete  = pfBackupFileItem.bCurrentAddessLookupComplete
        
        }
        else
        {

            // 'self' (current) has location data, then use latitude/longitude changes to determine the update...

        //  let bLocationLatitudeHasChanged:Bool  = (abs(self.dblConvertedLatitude  - PFBackupFileItem.dblConvertedLatitude)  <= .ulpOfOne)
        //  let bLocationLongitudeHasChanged:Bool = (abs(self.dblConvertedLongitude - PFBackupFileItem.dblConvertedLongitude) <= .ulpOfOne)

            let bLocationLatitudeHasChanged:Bool  = (abs(dblPreviousLatitude  - dblCurrentLatitude)  > (3 * .ulpOfOne))
            let bLocationLongitudeHasChanged:Bool = (abs(dblPreviousLongitude - dblCurrentLongitude) > (3 * .ulpOfOne))

            if (bLocationLatitudeHasChanged  == true ||
                bLocationLongitudeHasChanged == true)
            {
            
                self.sCurrentLocationName          = pfBackupFileItem.sCurrentLocationName        
                self.sCurrentCity                  = pfBackupFileItem.sCurrentCity                
                self.sCurrentCountry               = pfBackupFileItem.sCurrentCountry             
                self.sCurrentPostalCode            = pfBackupFileItem.sCurrentPostalCode          
                self.sCurrentTimeZone              = pfBackupFileItem.sCurrentTimeZone            

                self.bCurrentAddessLookupScheduled = pfBackupFileItem.bCurrentAddessLookupScheduled
                self.bCurrentAddessLookupComplete  = pfBackupFileItem.bCurrentAddessLookupComplete

                self.xcgLogMsg("\(sCurrMethodDisp) Intermediate <dup 'overlay'> <PFBackupFile> <location check> - Copied address data since 'bLocationLatitudeHasChanged' is [\(bLocationLatitudeHasChanged)] and/or 'bLocationLongitudeHasChanged' is [\(bLocationLongitudeHasChanged)] <location changed>...")
                self.xcgLogMsg("\(sCurrMethodDisp) Intermediate <dup 'overlay'> <PFBackupFile> <location check> - Location is [\(dblCurrentLatitude),\(dblCurrentLongitude)] and was [\(dblPreviousLatitude),\(dblPreviousLongitude)]...")

                if (self.sCurrentLocationName.count < 1 ||
                    self.sCurrentCity.count         < 1)
                {
                
                    self.bCurrentAddessLookupScheduled = false
                    self.bCurrentAddessLookupComplete  = false
                
                }
            
            }
            else
            {
            
                self.xcgLogMsg("\(sCurrMethodDisp) Intermediate <dup 'overlay'> <PFBackupFile> <location check> - Skipped copying address data since 'bLocationLatitudeHasChanged' is [\(bLocationLatitudeHasChanged)] and 'bLocationLongitudeHasChanged' is [\(bLocationLongitudeHasChanged)] <location has NOT changed>...")
            
            }

        }
        
        // Check if the 'current' Location data copied was 'blank'...

        if (self.sCurrentLocationName.count < 1 ||
            self.sCurrentCity.count         < 1)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) Intermediate <dup 'overlay'> <PFBackupFile> - Copied 'self.sCurrentLocationName' is [\(self.sCurrentLocationName)] and 'self.sCurrentCity' is [\(self.sCurrentCity)] - 1 or both are 'blank' - 'pfBackupFileItem.sCurrentLocationName' is [\(pfBackupFileItem.sCurrentLocationName)] and 'pfBackupFileItem.sCurrentCity' is [\(pfBackupFileItem.sCurrentCity)] - Warning!")

            self.resolveLocationAndAddress()

        }

        // Trace the 'clone' From/To fields in both objects...

        self.xcgLogMsg("\(sCurrMethodDisp) Intermediate <dup 'overlay'> <PFBackupFile> - From/To 'self.pfBackupFileObjectClonedFrom' is [\(String(describing: self.pfBackupFileObjectClonedFrom))] and 'self.pfBackupFileObjectClonedTo' is [\(String(describing: self.pfBackupFileObjectClonedTo))] - 'pfBackupFileItem.pfBackupFileObjectClonedFrom' is [\(String(describing: pfBackupFileItem.pfBackupFileObjectClonedFrom))] and 'PFBackupFileItem.pfBackupFileObjectClonedTo' is [\(String(describing: pfBackupFileItem.pfBackupFileObjectClonedTo))]...")

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return
  
    }   // End of overlayPFBackupFileItemWithAnotherPFBackupFileItem(pfBackupFileItem:ParsePFBackupFileItem).

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
            
        //  let dblDeadlineInterval:Double     = Double((0.5 * Double(self.idpfBackupFileObject)))
        //  let dblDeadlineInterval:Double     = Double((1.2 * Double(self.idpfBackupFileObject)))
        //  let dblDeadlineInterval:Double     = clModelObservable2.requestNextReverseLocationLookupDeadlineInterval()
            let dblDeadlineInterval:Double     = clModelObservable2.requestNextReverseLocationLookupDeadlineInterval(clRevLocType:CLRevLocType.primary)

            DispatchQueue.main.asyncAfter(deadline:(.now() + dblDeadlineInterval))
            {
                self.xcgLogMsg("\(sCurrMethodDisp) #(1): <closure> Calling 'updateGeocoderLocation()' with 'self' of [\(String(describing: self))] for Latitude/Longitude of [\(self.dblConvertedLatitude)/\(self.dblConvertedLongitude)] for Therapist [\(self.sTid)]...")

                let _ = clModelObservable2.updateGeocoderLocations(requestID: 1,
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

            self.xcgLogMsg("\(sCurrMethodDisp) #(1): CoreLocation (service) is NOT available...")

        }

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of public func resolveLocationAndAddress().

    public func handleLocationAndAddressClosureEvent(bIsDownstreamObject:Bool = false, requestID:Int, dictCurrentLocation:[String:Any])
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'self' is [\(String(describing: self))] for Therapist [\(self.sTid)] - parameter 'bIsDownstreamObject' is [\(bIsDownstreamObject)] - 'requestID' is [\(requestID)] - 'dictCurrentLocation' is [\(String(describing: dictCurrentLocation))]...")

        // Update the address info for BOTH 'self' and (possibly 'from'/'to')...

        if (dictCurrentLocation.count > 0)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) #(\(requestID)): <closure> Called  'updateGeocoderLocation()' with 'self' of [\(String(describing: self))] for Latitude/Longitude of [\(self.dblConvertedLatitude)/\(self.dblConvertedLongitude)] for Therapist [\(self.sTid)] current 'location' [\(String(describing: dictCurrentLocation))]...")

            self.sCurrentLocationName = String(describing: (dictCurrentLocation["sCurrentLocationName"] ?? ""))
            self.sCurrentCity         = String(describing: (dictCurrentLocation["sCurrentCity"]         ?? ""))
            self.sCurrentCountry      = String(describing: (dictCurrentLocation["sCurrentCountry"]      ?? ""))
            self.sCurrentPostalCode   = String(describing: (dictCurrentLocation["sCurrentPostalCode"]   ?? ""))
            self.sCurrentTimeZone     = String(describing: (dictCurrentLocation["tzCurrentTimeZone"]    ?? ""))

            self.bCurrentAddessLookupComplete = true

            if (bIsDownstreamObject == false)
            {
            
                if (self.pfBackupFileObjectClonedFrom != nil &&
                    self.pfBackupFileObjectClonedFrom != self)
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) #(\(requestID)): <closure> Calling 'self.pfBackupFileObjectClonedFrom' of [\(String(describing: self.pfBackupFileObjectClonedFrom))] with 'self' of [\(String(describing: self))] for Therapist [\(self.sTid)]...")

                    self.pfBackupFileObjectClonedFrom!.handleLocationAndAddressClosureEvent(bIsDownstreamObject:true, requestID:requestID, dictCurrentLocation:dictCurrentLocation)

                    self.xcgLogMsg("\(sCurrMethodDisp) #(\(requestID)): <closure> Called  'self.pfBackupFileObjectClonedFrom' of [\(String(describing: self.pfBackupFileObjectClonedFrom))] with 'self' of [\(String(describing: self))] for Therapist [\(self.sTid)]...")

                }

                if (self.pfBackupFileObjectClonedTo != nil &&
                    self.pfBackupFileObjectClonedTo != self)
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) #(\(requestID)): <closure> Calling 'self.pfBackupFileObjectClonedTo' of [\(String(describing: self.pfBackupFileObjectClonedTo))] with 'self' of [\(String(describing: self))] for Therapist [\(self.sTid)]...")

                    self.pfBackupFileObjectClonedTo!.handleLocationAndAddressClosureEvent(bIsDownstreamObject:true, requestID:requestID, dictCurrentLocation:dictCurrentLocation)

                    self.xcgLogMsg("\(sCurrMethodDisp) #(\(requestID)): <closure> Called  'self.pfBackupFileObjectClonedTo' of [\(String(describing: self.pfBackupFileObjectClonedTo))] with 'self' of [\(String(describing: self))] for Therapist [\(self.sTid)]...")

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

}   // End of class ParsePFBackupFileItem(NSObject, Identifiable).

