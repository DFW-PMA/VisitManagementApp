//
//  ParsePFPatientFileItem.swift
//  VisitManagementApp
//
//  Created by JustMacApps.net on 01/31/2025.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
import SwiftUI
import MapKit
import ParseCore

class ParsePFPatientFileItem: NSObject, Identifiable
{

    struct ClassInfo
    {
        
        static let sClsId        = "ParsePFPatientFileItem"
        static let sClsVers      = "v1.1101"
        static let sClsDisp      = sClsId+"(.swift).("+sClsVers+"):"
        static let sClsCopyRight = "Copyright (C) JustMacApps 2023-2025. All Rights Reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }

    // 'Internal' Trace flag:

    private 
    var bInternalTraceFlag:Bool                                   = false

    // Item Data field(s):
    
    var id                                                        = UUID()
    var idPFPatientFileObject:Int                                 = 0

    var pfPatientFileObjectClonedFrom:ParsePFPatientFileItem?     = nil 
    var pfPatientFileObjectClonedTo:ParsePFPatientFileItem?       = nil 

    // ------------------------------------------------------------------------------------------
    //  'pfPatientFileObject' is [<CSC: 0x301e16700, objectId: qpp1fxx68P, localId: (null)> 
    //  {
    //  }]...
    // ------------------------------------------------------------------------------------------

    var pfPatientFileObject:PFObject?                             = nil

    // ----------------------------------------------------------------------------------------------------------------
    //  TYPE of 'pfPatientFileObject'                 is [PFObject]         - value is [<CSC: 0x302ee1080, objectId: ...
    //  TYPE of 'pfPatientFileObject.parseClassName'  is [String]           - value is [PatientFile]...
    //  TYPE of 'pfPatientFileObject.objectId'        is [Optional<String>] - value is [Optional("dztxUrBZLr")]...
    //  TYPE of 'pfPatientFileObject.createdAt'       is [Optional<Date>]   - value is [Optional(2024-11-13 17:13:57 +0000)]...
    //  TYPE of 'pfPatientFileObject.updatedAt'       is [Optional<Date>]   - value is [Optional(2024-11-14 22:30:00 +0000)]...
    //  TYPE of 'pfPatientFileObject.acl'             is [Optional<PFACL>]  - value is [nil]...
    //  TYPE of 'pfPatientFileObject.isDataAvailable' is [Bool]             - value is [true]...
    //  TYPE of 'pfPatientFileObject.isDirty'         is [Bool]             - value is [false]...
    //  TYPE of 'pfPatientFileObject.allKeys'         is [Array<String>]    - value is [["lastLocTime", "latitude", ...
    // ----------------------------------------------------------------------------------------------------------------

    // Item 'discrete' field(s):

    var sPFPatientFileClassName:String                          = ""
    var sPFPatientFileObjectId:String?                          = nil
    var datePFPatientFileCreatedAt:Date?                        = nil
    var datePFPatientFileUpdatedAt:Date?                        = nil
    var aclPFPatientFile:PFACL?                                 = nil
    var bPFPatientFileIsDataAvailable:Bool                      = false
    var bPFPatientFileIdDirty:Bool                              = false
    var listPFPatientFileAllKeys:[String]                       = []

    // ----------------------------------------------------------------------------------------------------------
    // "ID"           : NumberInt(12524),
    // "name"         : "Zuniga ,Santino Alfredo",
    // "firstName"    : "Santino",
    // "lastName"     : "Alfredo Zuniga",
    // "emerContacts" : ["Ophelia Vargas","mother","","6822469838","","","","","","","",""],
    // "histLoc1"     : [32.80673599243164,-96.68681335449219],
    // ----------------------------------------------------------------------------------------------------------

    // Item 'keyed' field(s):

    var iPFPatientFilePID:Int                                   = -1         // 'pfPatientFileObject[ID]'
    var sPFPatientFileName:String                               = "-N/A-"    // 'pfPatientFileObject[name]' (last, first middle)
    var sPFPatientFileNameNoWS:String                           = "-N/A-"    // 'sPFPatientFileName' (lowercased - no whitespace/newline/illegal/punc). 
    var sPFPatientFileFirstName:String                          = "-N/A-"    // 'pfPatientFileObject[firstName]' (first)
    var sPFPatientFileLastName:String                           = "-N/A-"    // 'pfPatientFileObject[lastName]' (<middle> last)
    var sPFPatientFileEmerContacts:String                       = ""         // 'pfPatientFileObject[emerContacts]' <list>
    var sPFPatientFileHomeLoc:String                            = ""         // 'pfPatientFileObject[histLoc1]' [latitude,longitude]
    var sPFPatientFileDOB:String                                = ""         // 'pfPatientFileObject[DOB]' (Date Of Birth)

    // ----------------------------------------------------------------------------------------------------------
    //  --- Pass #2 ---
    //
    //  "realPatient": 1,
    //  "langPreference": "english",
    //  "onHold": 0,
    //  "onHoldDate": "",
    //  "parent": "Ophelia Vargas ",
    //  "parentID": 238,
    //
    // ----------------------------------------------------------------------------------------------------------

    var bPFPatientFileIsRealPatient:Bool                        = false      // 'pfPatientFileObject[realPatient]'
    var sPFPatientFileLanguagePref:String                       = "-N/A-"    // 'pfPatientFileObject[langPreference]'
    var bPFPatientFileIsOnHold:Bool                             = false      // 'pfPatientFileObject[onHold]'
    var sPFPatientFileOnHoldDate:String                         = "-N/A-"    // 'pfPatientFileObject[onHoldDate]'
    var sPFPatientFileParentName:String                         = "-N/A-"    // 'pfPatientFileObject[parent]'
    var sPFPatientFileParentID:String                           = "-N/A-"    // 'pfPatientFileObject[parentID]'

    // ----------------------------------------------------------------------------------------------------------
    //  --- Pass #2 ---
    //
    //  "sid": 31,
    //  "sidName": "Rebecca Hill",
    //  "supervisedVisits": " 4/30/24  5/2/24 ",
    //  "toSuper": 0,
    //
    // ----------------------------------------------------------------------------------------------------------

    var iPFPatientFileSID:Int                                   = -1         // 'pfPatientFileObject[sid]'
    var sPFPatientFileSidName:String                            = "-N/A-"    // 'pfPatientFileObject[sidName]'
    var sPFPatientFileSupervisedVisits:String                   = "-N/A-"    // 'pfPatientFileObject[supervisedVisits]'
    var bPFPatientFileIsToSuper:Bool                            = false      // 'pfPatientFileObject[toSuper]'

    // ----------------------------------------------------------------------------------------------------------
    //  --- Pass #2 ---
    //
    //  "authBegin": "9/16/24",
    //  "authEnd": "3/14/25",
    //  "startAuthBegin": "9/16/24",
    //  "startAuthEnd": "3/14/25",
    //  "currentAuthBegin": "9/16/24",
    //  "currentAuthEnd": "3/14/25",
    //  "expectedFreq": 2,
    //  "expectedVisits": 40,
    //  "firstVisitDate": "7/7/17",
    //  "lastVisitDate": "1/28/25",
    //  "lastEvalDate": "8/21/24",
    //  "lastDrVisit": "11/19/22",
    //  "newVisitCount": 35,
    //  "numVisitsDone": 2,
    //  "totalAuthdVisits": 52,
    //  "totalNumMVs": 97,
    //  "visitCount": 35,
    //  "visitCount2": 0,
    // ----------------------------------------------------------------------------------------------------------

    var sPFPatientFileAuthBegin:String                          = "-N/A-"    // 'pfPatientFileObject[authBegin]'
    var sPFPatientFileAuthEnd:String                            = "-N/A-"    // 'pfPatientFileObject[authEnd]'
    var sPFPatientFileStartAuthBegin:String                     = "-N/A-"    // 'pfPatientFileObject[startAuthBegin]'
    var sPFPatientFileStartAuthEnd:String                       = "-N/A-"    // 'pfPatientFileObject[startAuthEnd]'
    var sPFPatientFileCurrentAuthBegin:String                   = "-N/A-"    // 'pfPatientFileObject[currentAuthBegin]'
    var sPFPatientFileCurrentAuthEnd:String                     = "-N/A-"    // 'pfPatientFileObject[currentAuthEnd]'
    var iPFPatientFileExpectedFrequency:Int                     = -1         // 'pfPatientFileObject[expectedFreq]'
    var iPFPatientFileExpectedVisits:Int                        = -1         // 'pfPatientFileObject[expectedVisits]'
    var sPFPatientFileFirstVisitDate:String                     = "-N/A-"    // 'pfPatientFileObject[firstVisitDate]'
    var sPFPatientFileLastVisitDate:String                      = "-N/A-"    // 'pfPatientFileObject[lastVisitDate]'
    var sPFPatientFileLastEvalDate:String                       = "-N/A-"    // 'pfPatientFileObject[lastEvalDate]'
    var sPFPatientFileLastDrVisitDate:String                    = "-N/A-"    // 'pfPatientFileObject[lastDrVisit]'
    var iPFPatientFileNewVisitCount:Int                         = -1         // 'pfPatientFileObject[newVisitCount]'
    var iPFPatientFileNumberOfVisitsDone:Int                    = -1         // 'pfPatientFileObject[numVisitsDone]'
    var iPFPatientFileTotalAuthorizedVisits:Int                 = -1         // 'pfPatientFileObject[totalAuthdVisits]'
    var iPFPatientFileTotalNumberOfMissedVisits:Int             = -1         // 'pfPatientFileObject[totalNumMVs]'
    var iPFPatientFileVisitCount:Int                            = -1         // 'pfPatientFileObject[visitCount]'
    var iPFPatientFileVisitCount2:Int                           = -1         // 'pfPatientFileObject[visitCount2]'

    // ----------------------------------------------------------------------------------------------------------
    //  --- Pass #3 ---
    //
    //  "DME": "None",
    //  "allergies": "Insect bites, seasonal",
    //  "behavObs": "Pt is pleasant and cooperates with consistent positive reinforcement, redirection and parent interaction.",
    //  "currentDiet": "Regular solids and thin liquids",
    //  "currentFreqs": ["2","0","0","0","0","0","0","0","0"],
    //  "currentTIDs": ["115","31","9","9","9","9","9","9","9"],
    //  "discharged": 0,
    //  "evalMeds": "Methylphenidate, Clonidine",
    //  "haveAdminVisits": false,
    //  "haveMissedVisits": false,
    //  "holdReason": 10,
    //  "makeupsAllowed": false,
    //  "medNumber": 3295,
    //  "noPreSigRequired": false,
    //  "pertinentHist": "Pt is a 10 year old male with a history of a speech and ...",
    //  "primaryIns": 3,
    //  "readyForSuper": true,
    //  "registeredNames": ["Ophelia*8/6/24","ophelia*6/11/24"],
    //  "safeties": "Pt\u2019s communication deficits adversely impact his ability to ...",
    //  "secondaryIns": 0,
    //  "startTFreqs": ["2","0","0","0","0","0","0","0","0"],
    //  "startTIDs": ["115","31","9","9","9","9","9","9","9"],
    //  "treatmentDX": "F80.2",
    //  "type": 2,
    //  "visitsDone": [
    //      "1/27/25 115 Allison Wurz Phone 5:00\u202fPM 32.672853 -97.448343",
    //      "1/28/25 115 Allison Wurz Phone 6:00\u202fPM 32.672873 -97.448384"
    //  ]
    // ----------------------------------------------------------------------------------------------------------

    var sPFPatientFileDME:String                                = "-N/A-"    // 'pfPatientFileObject[DME]'
    var sPFPatientFileAlergies:String                           = "-N/A-"    // 'pfPatientFileObject[allergies]'
    var sPFPatientFileBehaviorObs:String                        = "-N/A-"    // 'pfPatientFileObject[behavObs]'
    var sPFPatientFileCurrentDiet:String                        = "-N/A-"    // 'pfPatientFileObject[currentDiet]'
    var sPFPatientFileCurrentFrequencies:String                 = "-N/A-"    // 'pfPatientFileObject[currentFreqs]' (see 'sPFPatientFileEmerContacts')
    var sPFPatientFileCurrentTIDs:String                        = "-N/A-"    // 'pfPatientFileObject[currentTIDs]'  (see 'sPFPatientFileEmerContacts')
    var bPFPatientFileIsDischarged:Bool                         = false      // 'pfPatientFileObject[discharged]'
    var sPFPatientFileEvalMeds:String                           = "-N/A-"    // 'pfPatientFileObject[evalMeds]'
    var bPFPatientFileHaveAdminVisits:Bool                      = false      // 'pfPatientFileObject[haveAdminVisits]'
    var bPFPatientFileHaveMissedVisits:Bool                     = false      // 'pfPatientFileObject[haveMissedVisits]'
    var iPFPatientFileHoldReason:Int                            = -1         // 'pfPatientFileObject[holdReason]'
    var bPFPatientFileMakeupsAllowed:Bool                       = false      // 'pfPatientFileObject[makeupsAllowed]'
    var iPFPatientFileMedNumber:Int                             = -1         // 'pfPatientFileObject[medNumber]'
    var bPFPatientFileNoPreSigRequired:Bool                     = false      // 'pfPatientFileObject[noPreSigRequired]'
    var sPFPatientFilePertinentHistory:String                   = "-N/A-"    // 'pfPatientFileObject[pertinentHist]'
    var iPFPatientFilePrimaryIns:Int                            = -1         // 'pfPatientFileObject[primaryIns]'
    var bPFPatientFileReadyForSuper:Bool                        = false      // 'pfPatientFileObject[readyForSuper]'
    var sPFPatientFileRegisteredNames:String                    = "-N/A-"    // 'pfPatientFileObject[registeredNames]'
    var sPFPatientFileSafeties:String                           = "-N/A-"    // 'pfPatientFileObject[safeties]'
    var iPFPatientFileSecondaryIns:Int                          = -1         // 'pfPatientFileObject[secondaryIns]'
    var sPFPatientFileStartTIDFrequencies:String                = "-N/A-"    // 'pfPatientFileObject[startTFreqs]'  (see 'sPFPatientFileEmerContacts')
    var sPFPatientFileStartTIDs:String                          = "-N/A-"    // 'pfPatientFileObject[startTIDs]'    (see 'sPFPatientFileEmerContacts')
    var sPFPatientFileTreatmentDX:String                        = "-N/A-"    // 'pfPatientFileObject[treatmentDX]'
    var iPFPatientFileType:Int                                  = -1         // 'pfPatientFileObject[type]'
    var sPFPatientFileVisitsDone:String                         = "-N/A-"    // 'pfPatientFileObject[visitsDone]'

    // ----------------------------------------------------------------------------------------------------------------
    //  TYPE of 'pfPatientFileObjectLatitude'     is [Optional<Any>] - value is [Optional(32.77201080322266)]...
    //  TYPE of 'pfPatientFileObjectLongitude'    is [Optional<Any>] - value is [Optional(-96.5831298828125)]...
    //  TYPE of 'sPFPatientFileObjectLatitude'    is [String]        - value is [32.77201080322266]...
    //  TYPE of 'sPFPatientFileObjectLongitude'   is [String]        - value is [-96.5831298828125]...
    //  TYPE of 'dblPFPatientFileObjectLatitude'  is [Double]        - value is [32.77201080322266]...
    //  TYPE of 'dblPFPatientFileObjectLongitude' is [Double]        - value is [-96.5831298828125]...
    //  TYPE of 'dblConvertedLatitude'            is [Double]        - value is [32.77201080322266]...
    //  TYPE of 'dblConvertedLongitude'           is [Double]        - value is [-96.5831298828125]...
    //  TYPE of 'sHomeLocLocationName'            is [String]        - value is [-N/A-]...
    //  TYPE of 'sHomeLocCity'                    is [String]        - value is [-N/A-]...
    // ----------------------------------------------------------------------------------------------------------------

    // Item 'calculated'/'converted'/'looked'-up/'computed' field(s):

    var pfPatientFileObjectLatitude:Any?                          = nil
    var pfPatientFileObjectLongitude:Any?                         = nil

    var sPFPatientFileObjectLatitude:String                       = "0.0"
    var sPFPatientFileObjectLongitude:String                      = "0.0"

    var dblPFPatientFileObjectLatitude:Double                     = 0.0
    var dblPFPatientFileObjectLongitude:Double                    = 0.0

    var dblConvertedLatitude:Double                               = 0.0
    var dblConvertedLongitude:Double                              = 0.0

    // Item address 'lookup'/'reverseLocation' (address) field(s):

    var bHomeLocAddessLookupScheduled:Bool                        = false
    var bHomeLocAddessLookupComplete:Bool                         = false

    var sHomeLocLocationName:String                               = ""
    var sHomeLocCity:String                                       = ""
    var sHomeLocCountry:String                                    = ""
    var sHomeLocPostalCode:String                                 = ""
    var sHomeLocTimeZone:String                                   = ""

    var clLocationCoordinate2D:CLLocationCoordinate2D
    {

        return CLLocationCoordinate2D(latitude:self.dblConvertedLatitude, longitude:self.dblConvertedLongitude)

    }

    var mapCoordinateRegion:MKCoordinateRegion
    {

        return MKCoordinateRegion(center:self.clLocationCoordinate2D,               
                                    span:MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta:0.05))

    }

    var mapPosition:MapCameraPosition
    {

        return MapCameraPosition.region(self.mapCoordinateRegion)

    }

    // App Data field(s):

    var jmAppDelegateVisitor:JmAppDelegateVisitor                 = JmAppDelegateVisitor.ClassSingleton.appDelegateVisitor
    
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

    convenience init(pfPatientFileItem:ParsePFPatientFileItem)
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
  
        self.init()
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'pfPatientFileItem' is [\(pfPatientFileItem)]...")

        // Finish the 'convenience' setup of field(s)...

        self.init(bDeepCopyIsAnOverlay:false, pfPatientFileItem:pfPatientFileItem)

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return
  
    }   // End of convenience init(pfPatientFileItem:ParsePFPatientFileItem).

    convenience init(bDeepCopyIsAnOverlay:Bool, pfPatientFileItem:ParsePFPatientFileItem)
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
  
        self.init()
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter is 'pfPatientFileItem' is [\(pfPatientFileItem)]...")

        // Finish the 'convenience' setup of field(s)...

        self.overlayPFPatientFileDataItemWithAnotherPFPatientFileDataItem(pfPatientFileItem:pfPatientFileItem)

        if (bDeepCopyIsAnOverlay == false)
        {
        
            self.pfPatientFileObjectClonedFrom              = pfPatientFileItem 
            self.pfPatientFileObjectClonedTo                = self 

        //  pfPatientFileItem.pfPatientFileObjectClonedFrom = nil
            pfPatientFileItem.pfPatientFileObjectClonedTo   = self
        
        }

        // Check if the 'current' Location data copied was 'blank'...

        if (self.sHomeLocLocationName.count < 1 ||
            self.sHomeLocCity.count         < 1)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) Intermediate <dup copy 'init'> <PFPatientFile> - Copied 'self.sHomeLocLocationName' is [\(self.sHomeLocLocationName)] and 'self.sHomeLocCity' is [\(self.sHomeLocCity)] - 1 or both are 'blank' - 'pfPatientFileItem.sHomeLocLocationName' is [\(pfPatientFileItem.sHomeLocLocationName)] and 'pfPatientFileItem.sHomeLocCity' is [\(pfPatientFileItem.sHomeLocCity)] - Warning!")
        
        }

        // Trace the 'clone' From/To fields in both objects...

        self.xcgLogMsg("\(sCurrMethodDisp) Intermediate <dup copy 'init'> <PFPatientFile> - From/To 'self.pfPatientFileObjectClonedFrom' is [\(String(describing: self.pfPatientFileObjectClonedFrom))] and 'self.pfPatientFileObjectClonedTo' is [\(String(describing: self.pfPatientFileObjectClonedTo))] - 'pfPatientFileItem.pfPatientFileObjectClonedFrom' is [\(String(describing: pfPatientFileItem.pfPatientFileObjectClonedFrom))] and 'pfPatientFileItem.pfPatientFileObjectClonedTo' is [\(String(describing: pfPatientFileItem.pfPatientFileObjectClonedTo))]...")

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return
  
    }   // End of convenience init(bDeepCopyIsAnOverlay:Bool, pfPatientFileItem:ParsePFPatientFileItem).

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
        asToString.append("'bInternalTraceFlag': [\(String(describing: self.bInternalTraceFlag))],")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'id': [\(String(describing: self.id))],")
        asToString.append("'idPFPatientFileObject': [\(String(describing: self.idPFPatientFileObject))],")
        asToString.append("'pfPatientFileObjectClonedFrom': [\(String(describing: self.pfPatientFileObjectClonedFrom))],")
        asToString.append("'pfPatientFileObjectClonedTo': [\(String(describing: self.pfPatientFileObjectClonedTo))],")

        if (pfPatientFileObject == nil)
        {
            asToString.append("'pfPatientFileObject': [-nil-],")
        }
        else
        {
            asToString.append("'pfPatientFileObject': [-available-],")
        }

        asToString.append("],")
        asToString.append("[")
        asToString.append("'sPFPatientFileClassName': [\(String(describing: self.sPFPatientFileClassName))],")
        asToString.append("'sPFPatientFileObjectId': [\(String(describing: self.sPFPatientFileObjectId))],")
        asToString.append("'datePFPatientFileCreatedAt': [\(String(describing: self.datePFPatientFileCreatedAt))],")
        asToString.append("'datePFPatientFileUpdatedAt': [\(String(describing: self.datePFPatientFileUpdatedAt))],")
        asToString.append("'aclPFPatientFile': [\(String(describing: self.aclPFPatientFile))],")
        asToString.append("'bPFPatientFileIsDataAvailable': [\(String(describing: self.bPFPatientFileIsDataAvailable))],")
        asToString.append("'bPFPatientFileIdDirty': [\(String(describing: self.bPFPatientFileIdDirty))],")
        asToString.append("'listPFPatientFileAllKeys': [\(String(describing: self.listPFPatientFileAllKeys))],")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'iPFPatientFilePID': (\(String(describing: self.iPFPatientFilePID))),")
        asToString.append("'sPFPatientFileName': [\(String(describing: self.sPFPatientFileName))],")
        asToString.append("'sPFPatientFileNameNoWS': [\(String(describing: self.sPFPatientFileNameNoWS))],")
        asToString.append("'sPFPatientFileFIrstName': [\(String(describing: self.sPFPatientFileFirstName))],")
        asToString.append("'sPFPatientFileLastName': [\(String(describing: self.sPFPatientFileLastName))],")
        asToString.append("'sPFPatientFileEmerContacts': [\(String(describing: self.sPFPatientFileEmerContacts))],")
        asToString.append("'sPFPatientFileHomeLoc': [\(String(describing: self.sPFPatientFileHomeLoc))],")
        asToString.append("'sPFPatientFileDOB': [\(String(describing: self.sPFPatientFileDOB))],")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'bPFPatientFileIsRealPatient': [\(String(describing: self.bPFPatientFileIsRealPatient))],")
        asToString.append("'sPFPatientFileLanguagePref': [\(String(describing: self.sPFPatientFileLanguagePref))],")
        asToString.append("'bPFPatientFileIsOnHold': [\(String(describing: self.bPFPatientFileIsOnHold))],")
        asToString.append("'sPFPatientFileOnHoldDate': [\(String(describing: self.sPFPatientFileOnHoldDate))],")
        asToString.append("'sPFPatientFileParentName': [\(String(describing: self.sPFPatientFileParentName))],")
        asToString.append("'sPFPatientFileParentID': [\(String(describing: self.sPFPatientFileParentID))],")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'iPFPatientFileSID': (\(String(describing: self.iPFPatientFileSID))),")
        asToString.append("'sPFPatientFileSidName': [\(String(describing: self.sPFPatientFileSidName))],")
        asToString.append("'sPFPatientFileSupervisedVisits': [\(String(describing: self.sPFPatientFileSupervisedVisits))],")
        asToString.append("'bPFPatientFileIsToSuper': [\(String(describing: self.bPFPatientFileIsToSuper))],")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'sPFPatientFileAuthBegin': [\(String(describing: self.sPFPatientFileAuthBegin))],")
        asToString.append("'sPFPatientFileAuthEnd': [\(String(describing: self.sPFPatientFileAuthEnd))],")
        asToString.append("'sPFPatientFileStartAuthBegin': [\(String(describing: self.sPFPatientFileStartAuthBegin))],")
        asToString.append("'sPFPatientFileStartAuthEnd': [\(String(describing: self.sPFPatientFileStartAuthEnd))],")
        asToString.append("'sPFPatientFileCurrentAuthBegin': [\(String(describing: self.sPFPatientFileCurrentAuthBegin))],")
        asToString.append("'sPFPatientFileCurrentAuthEnd': [\(String(describing: self.sPFPatientFileCurrentAuthEnd))],")
        asToString.append("'iPFPatientFileExpectedFrequency': (\(String(describing: self.iPFPatientFileExpectedFrequency))),")
        asToString.append("'iPFPatientFileExpectedVisits': (\(String(describing: self.iPFPatientFileExpectedVisits))),")
        asToString.append("'sPFPatientFileFirstVisitDate': [\(String(describing: self.sPFPatientFileFirstVisitDate))],")
        asToString.append("'sPFPatientFileLastVisitDate': [\(String(describing: self.sPFPatientFileLastVisitDate))],")
        asToString.append("'sPFPatientFileLastEvalDate': [\(String(describing: self.sPFPatientFileLastEvalDate))],")
        asToString.append("'sPFPatientFileLastDrVisitDate': [\(String(describing: self.sPFPatientFileLastDrVisitDate))],")
        asToString.append("'iPFPatientFileNewVisitCount': (\(String(describing: self.iPFPatientFileNewVisitCount))),")
        asToString.append("'iPFPatientFileNumberOfVisitsDone': (\(String(describing: self.iPFPatientFileNumberOfVisitsDone))),")
        asToString.append("'iPFPatientFileTotalAuthorizedVisits': (\(String(describing: self.iPFPatientFileTotalAuthorizedVisits))),")
        asToString.append("'iPFPatientFileTotalNumberOfMissedVisits': (\(String(describing: self.iPFPatientFileTotalNumberOfMissedVisits))),")
        asToString.append("'iPFPatientFileVisitCount': (\(String(describing: self.iPFPatientFileVisitCount))),")
        asToString.append("'iPFPatientFileVisitCount2': (\(String(describing: self.iPFPatientFileVisitCount2))),")
        asToString.append("],")
        asToString.append("[")

        asToString.append("'sPFPatientFileDME': [\(String(describing: self.sPFPatientFileDME))],")
        asToString.append("'sPFPatientFileAlergies': [\(String(describing: self.sPFPatientFileAlergies))],")
        asToString.append("'sPFPatientFileBehaviorObs': [\(String(describing: self.sPFPatientFileBehaviorObs))],")
        asToString.append("'sPFPatientFileCurrentDiet': [\(String(describing: self.sPFPatientFileCurrentDiet))],")
        asToString.append("'sPFPatientFileCurrentFrequencies': [\(String(describing: self.sPFPatientFileCurrentFrequencies))],")
        asToString.append("'sPFPatientFileCurrentTIDs': [\(String(describing: self.sPFPatientFileCurrentTIDs))],")
        asToString.append("'bPFPatientFileIsDischarged': [\(String(describing: self.bPFPatientFileIsDischarged))],")
        asToString.append("'sPFPatientFileEvalMeds': [\(String(describing: self.sPFPatientFileEvalMeds))],")
        asToString.append("'bPFPatientFileHaveAdminVisits': [\(String(describing: self.bPFPatientFileHaveAdminVisits))],")
        asToString.append("'bPFPatientFileHaveMissedVisits': [\(String(describing: self.bPFPatientFileHaveMissedVisits))],")
        asToString.append("'iPFPatientFileHoldReason': (\(String(describing: self.iPFPatientFileHoldReason))),")
        asToString.append("'bPFPatientFileMakeupsAllowed': [\(String(describing: self.bPFPatientFileMakeupsAllowed))],")
        asToString.append("'iPFPatientFileMedNumber': (\(String(describing: self.iPFPatientFileMedNumber))),")
        asToString.append("'bPFPatientFileNoPreSigRequired': [\(String(describing: self.bPFPatientFileNoPreSigRequired))],")
        asToString.append("'sPFPatientFilePertinentHistory': [\(String(describing: self.sPFPatientFilePertinentHistory))],")
        asToString.append("'iPFPatientFilePrimaryIns': (\(String(describing: self.iPFPatientFilePrimaryIns))),")
        asToString.append("'bPFPatientFileReadyForSuper': [\(String(describing: self.bPFPatientFileReadyForSuper))],")
        asToString.append("'sPFPatientFileRegisteredNames': [\(String(describing: self.sPFPatientFileRegisteredNames))],")
        asToString.append("'sPFPatientFileSafeties': [\(String(describing: self.sPFPatientFileSafeties))],")
        asToString.append("'iPFPatientFileSecondaryIns': (\(String(describing: self.iPFPatientFileSecondaryIns))),")
        asToString.append("'sPFPatientFileStartTIDFrequencies': [\(String(describing: self.sPFPatientFileStartTIDFrequencies))],")
        asToString.append("'sPFPatientFileStartTIDs': [\(String(describing: self.sPFPatientFileStartTIDs))],")
        asToString.append("'sPFPatientFileTreatmentDX': [\(String(describing: self.sPFPatientFileTreatmentDX))],")
        asToString.append("'iPFPatientFileType': (\(String(describing: self.iPFPatientFileType))),")
        asToString.append("'sPFPatientFileVisitsDone': [\(String(describing: self.sPFPatientFileVisitsDone))],")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'pfPatientFileObjectLatitude': [\(String(describing: self.pfPatientFileObjectLatitude))],")
        asToString.append("'pfPatientFileObjectLongitude': [\(String(describing: self.pfPatientFileObjectLongitude))],")
        asToString.append("'sPFPatientFileObjectLatitude': [\(String(describing: self.sPFPatientFileObjectLatitude))],")
        asToString.append("'sPFPatientFileObjectLongitude': [\(String(describing: self.sPFPatientFileObjectLongitude))],")
        asToString.append("'dblPFPatientFileObjectLatitude': [\(String(describing: self.dblPFPatientFileObjectLatitude))],")
        asToString.append("'dblPFPatientFileObjectLongitude': [\(String(describing: self.dblPFPatientFileObjectLongitude))],")
        asToString.append("'dblConvertedLatitude': [\(String(describing: self.dblConvertedLatitude))],")
        asToString.append("'dblConvertedLongitude': [\(String(describing: self.dblConvertedLongitude))],")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'bHomeLocAddessLookupScheduled': [\(String(describing: self.bHomeLocAddessLookupScheduled))],")
        asToString.append("'bHomeLocAddessLookupComplete': [\(String(describing: self.bHomeLocAddessLookupComplete))],")
        asToString.append("'sHomeLocLocationName': [\(String(describing: self.sHomeLocLocationName))],")
        asToString.append("'sHomeLocCity': [\(String(describing: self.sHomeLocCity))],")
        asToString.append("'sHomeLocCountry': [\(String(describing: self.sHomeLocCountry))],")
        asToString.append("'sHomeLocPostalCode': [\(String(describing: self.sHomeLocPostalCode))],")
        asToString.append("'sHomeLocTimeZone': [\(String(describing: self.sHomeLocTimeZone))],")
    //  asToString.append("],")
    //  asToString.append("[")
    //  asToString.append("'jmAppDelegateVisitor': [\(self.jmAppDelegateVisitor.toString())]")
        asToString.append("],")
        asToString.append("]")

        let sContents:String = "{"+(asToString.joined(separator: ""))+"}"

        return sContents

    }   // End of public func toString().

    public func displayParsePFPatientFileItemToLog()
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Display the various field(s) of this object in the Log...

        self.xcgLogMsg("\(sCurrMethodDisp) 'self'                                    is [\(String(describing: self))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'bInternalTraceFlag'                      is [\(String(describing: self.bInternalTraceFlag))]...")

        self.xcgLogMsg("\(sCurrMethodDisp) 'id'                                      is [\(String(describing: self.id))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'idPFPatientFileObject'                   is [\(String(describing: self.idPFPatientFileObject))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'pfPatientFileObjectClonedFrom'           is [\(String(describing: self.pfPatientFileObjectClonedFrom))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'pfPatientFileObjectClonedTo'             is [\(String(describing: self.pfPatientFileObjectClonedTo))]...")

    //  self.xcgLogMsg("\(sCurrMethodDisp) 'pfPatientFileObject'                     is [\(String(describing: self.pfPatientFileObject))]...")

        if (self.pfPatientFileObject == nil)
        {
            self.xcgLogMsg("\(sCurrMethodDisp) 'pfPatientFileObject'                     is [-nil-]...")
        }
        else
        {
            self.xcgLogMsg("\(sCurrMethodDisp) 'pfPatientFileObject'                     is [-available-]...")
        }

        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileClassName'                 is [\(String(describing: self.sPFPatientFileClassName))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileObjectId'                  is [\(String(describing: self.sPFPatientFileObjectId))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'datePFPatientFileCreatedAt'              is [\(String(describing: self.datePFPatientFileCreatedAt))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'datePFPatientFileUpdatedAt'              is [\(String(describing: self.datePFPatientFileUpdatedAt))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'aclPFPatientFile'                        is [\(String(describing: self.aclPFPatientFile))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'bPFPatientFileIsDataAvailable'           is [\(String(describing: self.bPFPatientFileIsDataAvailable))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'bPFPatientFileIdDirty'                   is [\(String(describing: self.bPFPatientFileIdDirty))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'listPFPatientFileAllKeys'                is [\(String(describing: self.listPFPatientFileAllKeys))]...")

        self.xcgLogMsg("\(sCurrMethodDisp) 'iPFPatientFilePID'                       is (\(String(describing: self.iPFPatientFilePID)))...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileName'                      is [\(String(describing: self.sPFPatientFileName))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileNameNoWS'                  is [\(String(describing: self.sPFPatientFileNameNoWS))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileFirstName'                 is [\(String(describing: self.sPFPatientFileFirstName))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileLastName'                  is [\(String(describing: self.sPFPatientFileLastName))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileEmerContacts'              is [\(String(describing: self.sPFPatientFileEmerContacts))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileHomeLoc'                   is [\(String(describing: self.sPFPatientFileHomeLoc))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileDOB'                       is [\(String(describing: self.sPFPatientFileDOB))]...")

        self.xcgLogMsg("\(sCurrMethodDisp) 'bPFPatientFileIsRealPatient'             is [\(String(describing: self.bPFPatientFileIsRealPatient))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileLanguagePref'              is [\(String(describing: self.sPFPatientFileLanguagePref))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'bPFPatientFileIsOnHold'                  is [\(String(describing: self.bPFPatientFileIsOnHold))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileOnHoldDate'                is [\(String(describing: self.sPFPatientFileOnHoldDate))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileParentName'                is [\(String(describing: self.sPFPatientFileParentName))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileParentID'                  is [\(String(describing: self.sPFPatientFileParentID))]...")

        self.xcgLogMsg("\(sCurrMethodDisp) 'iPFPatientFileSID'                       is (\(String(describing: self.iPFPatientFileSID)))...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileSidName'                   is [\(String(describing: self.sPFPatientFileSidName))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileSupervisedVisits'          is [\(String(describing: self.sPFPatientFileSupervisedVisits))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'bPFPatientFileIsToSuper'                 is [\(String(describing: self.bPFPatientFileIsToSuper))]...")

        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileAuthBegin'                 is [\(String(describing: self.sPFPatientFileAuthBegin))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileAuthEnd'                   is [\(String(describing: self.sPFPatientFileAuthEnd))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileStartAuthBegin'            is [\(String(describing: self.sPFPatientFileStartAuthBegin))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileStartAuthEnd'              is [\(String(describing: self.sPFPatientFileStartAuthEnd))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileCurrentAuthBegin'          is [\(String(describing: self.sPFPatientFileCurrentAuthBegin))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileCurrentAuthEnd'            is [\(String(describing: self.sPFPatientFileCurrentAuthEnd))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'iPFPatientFileExpectedFrequency'         is (\(String(describing: self.iPFPatientFileExpectedFrequency)))...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'iPFPatientFileExpectedVisits'            is (\(String(describing: self.iPFPatientFileExpectedVisits)))...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileFirstVisitDate'            is [\(String(describing: self.sPFPatientFileFirstVisitDate))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileLastVisitDate'             is [\(String(describing: self.sPFPatientFileLastVisitDate))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileLastEvalDate'              is [\(String(describing: self.sPFPatientFileLastEvalDate))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileLastDrVisitDate'           is [\(String(describing: self.sPFPatientFileLastDrVisitDate))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'iPFPatientFileNewVisitCount'             is (\(String(describing: self.iPFPatientFileNewVisitCount)))...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'iPFPatientFileNumberOfVisitsDone'        is (\(String(describing: self.iPFPatientFileNumberOfVisitsDone)))...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'iPFPatientFileTotalAuthorizedVisits'     is (\(String(describing: self.iPFPatientFileTotalAuthorizedVisits)))...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'iPFPatientFileTotalNumberOfMissedVisits' is (\(String(describing: self.iPFPatientFileTotalNumberOfMissedVisits)))...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'iPFPatientFileVisitCount'                is (\(String(describing: self.iPFPatientFileVisitCount)))...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'iPFPatientFileVisitCount2'               is (\(String(describing: self.iPFPatientFileVisitCount2)))...")

        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileDME'                       is [\(String(describing: self.sPFPatientFileDME))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileAlergies'                  is [\(String(describing: self.sPFPatientFileAlergies))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileBehaviorObs'               is [\(String(describing: self.sPFPatientFileBehaviorObs))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileCurrentDiet'               is [\(String(describing: self.sPFPatientFileCurrentDiet))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileCurrentFrequencies'        is [\(String(describing: self.sPFPatientFileCurrentFrequencies))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileCurrentTIDs'               is [\(String(describing: self.sPFPatientFileCurrentTIDs))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'bPFPatientFileIsDischarged'              is [\(String(describing: self.bPFPatientFileIsDischarged))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileEvalMeds'                  is [\(String(describing: self.sPFPatientFileEvalMeds))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'bPFPatientFileHaveAdminVisits'           is [\(String(describing: self.bPFPatientFileHaveAdminVisits))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'bPFPatientFileHaveMissedVisits'          is [\(String(describing: self.bPFPatientFileHaveMissedVisits))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'iPFPatientFileHoldReason'                is (\(String(describing: self.iPFPatientFileHoldReason)))...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'bPFPatientFileMakeupsAllowed'            is [\(String(describing: self.bPFPatientFileMakeupsAllowed))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'iPFPatientFileMedNumber'                 is (\(String(describing: self.iPFPatientFileMedNumber)))...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'bPFPatientFileNoPreSigRequired'          is [\(String(describing: self.bPFPatientFileNoPreSigRequired))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFilePertinentHistory'          is [\(String(describing: self.sPFPatientFilePertinentHistory))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'iPFPatientFilePrimaryIns'                is (\(String(describing: self.iPFPatientFilePrimaryIns)))...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'bPFPatientFileReadyForSuper'             is [\(String(describing: self.bPFPatientFileReadyForSuper))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileRegisteredNames'           is [\(String(describing: self.sPFPatientFileRegisteredNames))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileSafeties'                  is [\(String(describing: self.sPFPatientFileSafeties))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'iPFPatientFileSecondaryIns'              is (\(String(describing: self.iPFPatientFileSecondaryIns)))...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileStartTIDFrequencies'       is [\(String(describing: self.sPFPatientFileStartTIDFrequencies))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileStartTIDs'                 is [\(String(describing: self.sPFPatientFileStartTIDs))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileTreatmentDX'               is [\(String(describing: self.sPFPatientFileTreatmentDX))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'iPFPatientFileType'                      is (\(String(describing: self.iPFPatientFileType)))...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileVisitsDone'                is [\(String(describing: self.sPFPatientFileVisitsDone))]...")

        self.xcgLogMsg("\(sCurrMethodDisp) 'pfPatientFileObjectLatitude'             is [\(String(describing: self.pfPatientFileObjectLatitude))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'pfPatientFileObjectLongitude'            is [\(String(describing: self.pfPatientFileObjectLongitude))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileObjectLatitude'            is [\(String(describing: self.sPFPatientFileObjectLatitude))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPFPatientFileObjectLongitude'           is [\(String(describing: self.sPFPatientFileObjectLongitude))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'dblPFPatientFileObjectLatitude'          is [\(String(describing: self.dblPFPatientFileObjectLatitude))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'dblPFPatientFileObjectLongitude'         is [\(String(describing: self.dblPFPatientFileObjectLongitude))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'dblConvertedLatitude'                    is [\(String(describing: self.dblConvertedLatitude))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'dblConvertedLongitude'                   is [\(String(describing: self.dblConvertedLongitude))]...")

        self.xcgLogMsg("\(sCurrMethodDisp) 'bHomeLocAddessLookupScheduled'           is [\(String(describing: self.bHomeLocAddessLookupScheduled))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'bHomeLocAddessLookupComplete'            is [\(String(describing: self.bHomeLocAddessLookupComplete))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sHomeLocLocationName'                    is [\(String(describing: self.sHomeLocLocationName))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sHomeLocCity'                            is [\(String(describing: self.sHomeLocCity))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sHomeLocCountry'                         is [\(String(describing: self.sHomeLocCountry))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sHomeLocPostalCode'                      is [\(String(describing: self.sHomeLocPostalCode))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sHomeLocTimeZone'                        is [\(String(describing: self.sHomeLocTimeZone))]...")

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of public func displayParsePFPatientFileItemToLog().

    public func constructParsePFPatientFileItemFromPFObject(idPFPatientFileObject:Int = 1, pfPatientFileObject:PFObject)
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

    //  self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'idPFPatientFileObject' is (\(idPFPatientFileObject)) - 'pfPatientFileObject' is [\(pfPatientFileObject)]...")
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'idPFPatientFileObject' is (\(idPFPatientFileObject)) - 'pfPatientFileObject'...")

        // Assign the various field(s) of this object from the supplied PFObject...

        self.idPFPatientFileObject                   = idPFPatientFileObject

        self.pfPatientFileObjectClonedFrom           = nil 
        self.pfPatientFileObjectClonedTo             = nil 

        self.pfPatientFileObject                     = pfPatientFileObject                                                             
        
        self.sPFPatientFileClassName                 = pfPatientFileObject.parseClassName
        self.sPFPatientFileObjectId                  = pfPatientFileObject.objectId  != nil ? pfPatientFileObject.objectId!  : ""
        self.datePFPatientFileCreatedAt              = pfPatientFileObject.createdAt != nil ? pfPatientFileObject.createdAt! : nil
        self.datePFPatientFileUpdatedAt              = pfPatientFileObject.updatedAt != nil ? pfPatientFileObject.updatedAt! : nil
        self.aclPFPatientFile                        = pfPatientFileObject.acl
        self.bPFPatientFileIsDataAvailable           = pfPatientFileObject.isDataAvailable
        self.bPFPatientFileIdDirty                   = pfPatientFileObject.isDirty
        self.listPFPatientFileAllKeys                = pfPatientFileObject.allKeys

        self.iPFPatientFilePID                       = Int(String(describing: (pfPatientFileObject.object(forKey:"ID")               ?? "-1"))) ?? -2
        self.sPFPatientFileName                      = String(describing: (pfPatientFileObject.object(forKey:"name")                 ?? ""))

    //  var csUnwantedDelimiters:CharacterSet        = CharacterSet()
    //
    //  csUnwantedDelimiters = csUnwantedDelimiters.union(CharacterSet.illegalCharacters)
    //  csUnwantedDelimiters = csUnwantedDelimiters.union(CharacterSet.whitespacesAndNewlines)
    //  csUnwantedDelimiters = csUnwantedDelimiters.union(CharacterSet.punctuationCharacters)
    //
    //  let sPFPatientFileNameLower:String           = self.sPFPatientFileName.lowercased()
    //  let listPFPatientFileNameLowerNoWS:[String]  = sPFPatientFileNameLower.components(separatedBy:csUnwantedDelimiters)
    //  let sPFPatientFileNameLowerNoWS:String       = listPFPatientFileNameLowerNoWS.joined(separator:"")

    //  self.sPFPatientFileNameNoWS                  = self.sPFPatientFileName.removeUnwantedCharacters(charsetToRemove:[StringCleaning.removeAll], bResultIsLowerCased:true)
        self.sPFPatientFileFirstName                 = String(describing: (pfPatientFileObject.object(forKey:"firstName")            ?? ""))
        self.sPFPatientFileLastName                  = String(describing: (pfPatientFileObject.object(forKey:"lastName")             ?? ""))

        if (bInternalTraceFlag == true)
        {

            let objPFPatientFileLastName             = pfPatientFileObject.object(forKey:"lastName")
            let typeOfObjPFPatientFileLastName       = type(of:objPFPatientFileLastName)
            let sTypeOfObjPFPatientFileLastName      = self.getMetaTypeStringForObject(object:objPFPatientFileLastName as Any)

            self.xcgLogMsg("\(sCurrMethodDisp) <PFOuery Data Probe> - 'typeOfObjPFPatientFileLastName' is [\(typeOfObjPFPatientFileLastName)] and 'sTypeOfObjPFPatientFileLastName' is [\(sTypeOfObjPFPatientFileLastName)] for 'objPFPatientFileLastName' is [\(String(describing: objPFPatientFileLastName))]...")

        }

        if (self.sPFPatientFileName.count < 1)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) <PFOuery Data Probe> - 'self.sPFPatientFileName' of [\(self.sPFPatientFileName)] is empty in the Database - attempting to use 'lastName,firstName'...")

            if (self.sPFPatientFileLastName.count  > 0 &&
                self.sPFPatientFileFirstName.count > 0)
            {
            
                self.sPFPatientFileName = "\(self.sPFPatientFileLastName),\(self.sPFPatientFileFirstName)"

                self.xcgLogMsg("\(sCurrMethodDisp) <PFOuery Data Probe> - 'self.sPFPatientFileLastName' is [\(self.sPFPatientFileLastName)] and 'self.sPFPatientFileFirstName' of [\(self.sPFPatientFileFirstName)] - set 'self.sPFPatientFileName' to [\(self.sPFPatientFileName)]...")
            
            }
        
        }

        self.sPFPatientFileNameNoWS                  = self.sPFPatientFileName.removeUnwantedCharacters(charsetToRemove:[StringCleaning.removeAll], bResultIsLowerCased:true)

        self.sPFPatientFileHomeLoc                   = String(describing: (pfPatientFileObject.object(forKey:"histLoc1")             ?? ""))

        if (bInternalTraceFlag == true)
        {

            let objPFPatientFileHomeLoc              = pfPatientFileObject.object(forKey:"histLoc1")
            let typeOfObjPFPatientFileHomeLoc        = type(of:objPFPatientFileHomeLoc)
            let sTypeOfObjPFPatientFileHomeLoc       = self.getMetaTypeStringForObject(object:objPFPatientFileHomeLoc as Any)

            self.xcgLogMsg("\(sCurrMethodDisp) <PFOuery Data Probe> - 'typeOfObjPFPatientFileHomeLoc' is [\(typeOfObjPFPatientFileHomeLoc)] and 'sTypeOfObjPFPatientFileHomeLoc' is [\(sTypeOfObjPFPatientFileHomeLoc)] for 'objPFPatientFileHomeLoc' is [\(String(describing: objPFPatientFileHomeLoc))]...")

        }

        self.convertPFPatientFileHomeLocToLatitudeLongitude()

        self.sPFPatientFileEmerContacts              = String(describing: (pfPatientFileObject.object(forKey:"emerContacts")         ?? ""))

        let objPFPatientFileEmerContacts             = pfPatientFileObject.object(forKey:"emerContacts")
        let sTypeOfObjPFPatientFileEmerContacts      = self.getMetaTypeStringForObject(object:objPFPatientFileEmerContacts as Any)

        if (bInternalTraceFlag == true)
        {

            let typeOfObjPFPatientFileEmerContacts   = type(of:objPFPatientFileEmerContacts)

            self.xcgLogMsg("\(sCurrMethodDisp) <PFOuery Data Probe> - 'typeOfObjPFPatientFileEmerContacts' is [\(typeOfObjPFPatientFileEmerContacts)] and 'sTypeOfObjPFPatientFileEmerContacts' is [\(sTypeOfObjPFPatientFileEmerContacts)] for 'objPFPatientFileEmerContacts' is [\(String(describing: objPFPatientFileEmerContacts))]...")

        }

    //  if (sTypeOfObjPFPatientFileEmerContacts == "List")
    //  {
    //
    //      let listObjPFPatientFileEmerContacts:[String] = objPFPatientFileEmerContacts as! [String]
    //      var listPatFileEmerContacts:[String]          = [String]()
    //  
    //      for sCurrPatientFileEmerContact in listObjPFPatientFileEmerContacts
    //      {
    //
    //          if (sCurrPatientFileEmerContact.count > 1)
    //          {
    //
    //              if (Double(sCurrPatientFileEmerContact) != nil)
    //              {
    //              
    //                  listPatFileEmerContacts.append(self.formatPhoneNumber(sPhoneNumber:sCurrPatientFileEmerContact))
    //              
    //              }
    //              else
    //              {
    //
    //                  listPatFileEmerContacts.append(sCurrPatientFileEmerContact)
    //
    //              }
    //          
    //          }
    //
    //      }
    //
    //      self.sPFPatientFileEmerContacts = listPatFileEmerContacts.joined(separator:",")
    //  
    //  }

        let objPFPatientFileEmerContacts2            = pfPatientFileObject.object(forKey:"emerContacts")
        self.sPFPatientFileEmerContacts              = self.reducePFObjectListOfStrings(object:                       objPFPatientFileEmerContacts2 as Any,
                                                                                        listStringsToRemove:          [""],
                                                                                        bFormatNumericsAsPhoneNumbers:true)

        self.sPFPatientFileDOB                       = String(describing: (pfPatientFileObject.object(forKey:"DOB")                  ?? ""))

        self.bPFPatientFileIsRealPatient             = Bool(truncating: (Int(String(describing: (pfPatientFileObject.object(forKey:"realPatient") ?? "0"))) ?? 0) as NSNumber)
        self.sPFPatientFileLanguagePref              = String(describing: (pfPatientFileObject.object(forKey:"langPreference")       ?? ""))
        self.bPFPatientFileIsOnHold                  = Bool(truncating: (Int(String(describing: (pfPatientFileObject.object(forKey:"onHold")      ?? "0"))) ?? 0) as NSNumber)
        self.sPFPatientFileOnHoldDate                = String(describing: (pfPatientFileObject.object(forKey:"onHoldDate")           ?? ""))
        self.sPFPatientFileParentName                = String(describing: (pfPatientFileObject.object(forKey:"parent")               ?? ""))
        self.sPFPatientFileParentID                  = String(describing: (pfPatientFileObject.object(forKey:"parentID")             ?? ""))

        self.iPFPatientFileSID                       = Int(String(describing: (pfPatientFileObject.object(forKey:"sid")              ?? "-1"))) ?? -2
        self.sPFPatientFileSidName                   = String(describing: (pfPatientFileObject.object(forKey:"sidName")              ?? ""))
        self.sPFPatientFileSupervisedVisits          = String(describing: (pfPatientFileObject.object(forKey:"supervisedVisits")     ?? ""))
        self.bPFPatientFileIsToSuper                 = Bool(truncating: (Int(String(describing: (pfPatientFileObject.object(forKey:"toSuper")     ?? "0"))) ?? 0) as NSNumber)

        self.sPFPatientFileAuthBegin                 = String(describing: (pfPatientFileObject.object(forKey:"authBegin")            ?? ""))
        self.sPFPatientFileAuthEnd                   = String(describing: (pfPatientFileObject.object(forKey:"authEnd")              ?? ""))
        self.sPFPatientFileStartAuthBegin            = String(describing: (pfPatientFileObject.object(forKey:"startAuthBegin")       ?? ""))
        self.sPFPatientFileStartAuthEnd              = String(describing: (pfPatientFileObject.object(forKey:"startAuthEnd")         ?? ""))
        self.sPFPatientFileCurrentAuthBegin          = String(describing: (pfPatientFileObject.object(forKey:"currentAuthBegin")     ?? ""))
        self.sPFPatientFileCurrentAuthEnd            = String(describing: (pfPatientFileObject.object(forKey:"currentAuthEnd")       ?? ""))
        self.iPFPatientFileExpectedFrequency         = Int(String(describing: (pfPatientFileObject.object(forKey:"expectedFreq")     ?? "-1"))) ?? -2
        self.iPFPatientFileExpectedVisits            = Int(String(describing: (pfPatientFileObject.object(forKey:"expectedVisits")   ?? "-1"))) ?? -2
        self.sPFPatientFileFirstVisitDate            = String(describing: (pfPatientFileObject.object(forKey:"firstVisitDate")       ?? ""))
        self.sPFPatientFileLastVisitDate             = String(describing: (pfPatientFileObject.object(forKey:"lastVisitDate")        ?? ""))
        self.sPFPatientFileLastEvalDate              = String(describing: (pfPatientFileObject.object(forKey:"lastEvalDate")         ?? ""))
        self.sPFPatientFileLastDrVisitDate           = String(describing: (pfPatientFileObject.object(forKey:"lastDrVisit")          ?? ""))
        self.iPFPatientFileNewVisitCount             = Int(String(describing: (pfPatientFileObject.object(forKey:"newVisitCount")    ?? "-1"))) ?? -2
        self.iPFPatientFileNumberOfVisitsDone        = Int(String(describing: (pfPatientFileObject.object(forKey:"numVisitsDone")    ?? "-1"))) ?? -2
        self.iPFPatientFileTotalAuthorizedVisits     = Int(String(describing: (pfPatientFileObject.object(forKey:"totalAuthdVisits") ?? "-1"))) ?? -2
        self.iPFPatientFileTotalNumberOfMissedVisits = Int(String(describing: (pfPatientFileObject.object(forKey:"totalNumMVs")      ?? "-1"))) ?? -2
        self.iPFPatientFileVisitCount                = Int(String(describing: (pfPatientFileObject.object(forKey:"visitCount")       ?? "-1"))) ?? -2
        self.iPFPatientFileVisitCount2               = Int(String(describing: (pfPatientFileObject.object(forKey:"visitCount2")      ?? "-1"))) ?? -2

        self.sPFPatientFileDME                       = String(describing: (pfPatientFileObject.object(forKey:"DME")          ?? ""))
        self.sPFPatientFileAlergies                  = String(describing: (pfPatientFileObject.object(forKey:"allergies")          ?? ""))
        self.sPFPatientFileBehaviorObs               = String(describing: (pfPatientFileObject.object(forKey:"behavObs")          ?? ""))
        self.sPFPatientFileCurrentDiet               = String(describing: (pfPatientFileObject.object(forKey:"currentDiet")          ?? ""))

        let objPFPatientFileCurrentFrequencies       = pfPatientFileObject.object(forKey:"currentFreqs")
        self.sPFPatientFileCurrentFrequencies        = self.reducePFObjectListOfStrings(object:                       objPFPatientFileCurrentFrequencies as Any,
                                                                                        listStringsToRemove:          ["","0"],
                                                                                        bFormatNumericsAsPhoneNumbers:false)

        let objPFPatientFileCurrentTIDs              = pfPatientFileObject.object(forKey:"currentTIDs")
        self.sPFPatientFileCurrentTIDs               = self.reducePFObjectListOfStrings(object:                       objPFPatientFileCurrentTIDs as Any,
                                                                                        listStringsToRemove:          ["","9"],
                                                                                        bFormatNumericsAsPhoneNumbers:false)

        self.bPFPatientFileIsDischarged              = Bool(truncating: (Int(String(describing: (pfPatientFileObject.object(forKey:"discharged")       ?? "0"))) ?? 0) as NSNumber)
        self.sPFPatientFileEvalMeds                  = String(describing: (pfPatientFileObject.object(forKey:"evalMeds") ?? ""))
        self.bPFPatientFileHaveAdminVisits           = Bool(truncating: (Int(String(describing: (pfPatientFileObject.object(forKey:"haveAdminVisits")  ?? "0"))) ?? 0) as NSNumber)
        self.bPFPatientFileHaveMissedVisits          = Bool(truncating: (Int(String(describing: (pfPatientFileObject.object(forKey:"haveMissedVisits") ?? "0"))) ?? 0) as NSNumber)
        self.iPFPatientFileHoldReason                = Int(String(describing: (pfPatientFileObject.object(forKey:"holdReason") ?? "-1"))) ?? -2
        self.bPFPatientFileMakeupsAllowed            = Bool(truncating: (Int(String(describing: (pfPatientFileObject.object(forKey:"makeupsAllowed")   ?? "0"))) ?? 0) as NSNumber)
        self.iPFPatientFileMedNumber                 = Int(String(describing: (pfPatientFileObject.object(forKey:"medNumber")  ?? "-1"))) ?? -2
        self.bPFPatientFileNoPreSigRequired          = Bool(truncating: (Int(String(describing: (pfPatientFileObject.object(forKey:"noPreSigRequired") ?? "0"))) ?? 0) as NSNumber)


        self.sPFPatientFilePertinentHistory          = String(describing: (pfPatientFileObject.object(forKey:"pertinentHist")    ?? ""))
        self.iPFPatientFilePrimaryIns                = Int(String(describing: (pfPatientFileObject.object(forKey:"primaryIns")   ?? "-1"))) ?? -2
        self.bPFPatientFileReadyForSuper             = Bool(truncating: (Int(String(describing: (pfPatientFileObject.object(forKey:"readyForSuper") ?? "0"))) ?? 0) as NSNumber)

        let objPFPatientFileRegisteredNames          = pfPatientFileObject.object(forKey:"registeredNames")
        self.sPFPatientFileRegisteredNames           = self.reducePFObjectListOfStrings(object:                       objPFPatientFileRegisteredNames as Any,
                                                                                        listStringsToRemove:          [""],
                                                                                        bFormatNumericsAsPhoneNumbers:false)

        self.sPFPatientFileSafeties                  = String(describing: (pfPatientFileObject.object(forKey:"safeties")         ?? ""))
        self.iPFPatientFileSecondaryIns              = Int(String(describing: (pfPatientFileObject.object(forKey:"secondaryIns") ?? "-1"))) ?? -2

        let objPFPatientFileStartTIDFrequencies      = pfPatientFileObject.object(forKey:"startTFreqs")
        self.sPFPatientFileStartTIDFrequencies       = self.reducePFObjectListOfStrings(object:                       objPFPatientFileStartTIDFrequencies as Any,
                                                                                        listStringsToRemove:          ["","0"],
                                                                                        bFormatNumericsAsPhoneNumbers:false)

        let objPFPatientFileStartTIDs                = pfPatientFileObject.object(forKey:"startTIDs")
        self.sPFPatientFileStartTIDs                 = self.reducePFObjectListOfStrings(object:                       objPFPatientFileStartTIDs as Any,
                                                                                        listStringsToRemove:          ["","9"],
                                                                                        bFormatNumericsAsPhoneNumbers:false)

        self.sPFPatientFileTreatmentDX               = String(describing: (pfPatientFileObject.object(forKey:"treatmentDX") ?? ""))
        self.iPFPatientFileType                      = Int(String(describing: (pfPatientFileObject.object(forKey:"type")    ?? "-1"))) ?? -2
        self.sPFPatientFileVisitsDone                = String(describing: (pfPatientFileObject.object(forKey:"visitsDone")  ?? ""))

        self.bHomeLocAddessLookupScheduled           = false
        self.bHomeLocAddessLookupComplete            = false
      
        self.sHomeLocLocationName                    = ""
        self.sHomeLocCity                            = ""
        self.sHomeLocCountry                         = ""
        self.sHomeLocPostalCode                      = ""
        self.sHomeLocTimeZone                        = ""

        self.resolveLocationAndAddress()
      
        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of public func constructParsePFPatientFileItemFromPFObject(pfPatientFileObject:PFObject).

    private func overlayPFPatientFileDataItemWithAnotherPFPatientFileDataItem(pfPatientFileItem:ParsePFPatientFileItem)
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Finish the 'overlay' update of field(s)...

        self.idPFPatientFileObject                   = pfPatientFileItem.idPFPatientFileObject

        // 'Object' From/To update does NOT occur in an 'overlay'...

    //  self.pfPatientFileObjectClonedFrom           = nil 
    //  self.pfPatientFileObjectClonedTo             = nil 

        self.pfPatientFileObject                     = pfPatientFileItem.pfPatientFileObject

        self.sPFPatientFileClassName                 = pfPatientFileItem.sPFPatientFileClassName
        self.sPFPatientFileObjectId                  = pfPatientFileItem.sPFPatientFileObjectId
        self.datePFPatientFileCreatedAt              = pfPatientFileItem.datePFPatientFileCreatedAt
        self.datePFPatientFileUpdatedAt              = pfPatientFileItem.datePFPatientFileUpdatedAt
        self.aclPFPatientFile                        = pfPatientFileItem.aclPFPatientFile
        self.bPFPatientFileIsDataAvailable           = pfPatientFileItem.bPFPatientFileIsDataAvailable
        self.bPFPatientFileIdDirty                   = pfPatientFileItem.bPFPatientFileIdDirty
        self.listPFPatientFileAllKeys                = pfPatientFileItem.listPFPatientFileAllKeys
        
        self.iPFPatientFilePID                       = pfPatientFileItem.iPFPatientFilePID
        self.sPFPatientFileName                      = pfPatientFileItem.sPFPatientFileName
        self.sPFPatientFileNameNoWS                  = pfPatientFileItem.sPFPatientFileNameNoWS
        self.sPFPatientFileFirstName                 = pfPatientFileItem.sPFPatientFileFirstName
        self.sPFPatientFileLastName                  = pfPatientFileItem.sPFPatientFileLastName
        self.sPFPatientFileEmerContacts              = pfPatientFileItem.sPFPatientFileEmerContacts
        self.sPFPatientFileHomeLoc                   = pfPatientFileItem.sPFPatientFileHomeLoc
        self.sPFPatientFileDOB                       = pfPatientFileItem.sPFPatientFileDOB
        
        self.bPFPatientFileIsRealPatient             = pfPatientFileItem.bPFPatientFileIsRealPatient
        self.sPFPatientFileLanguagePref              = pfPatientFileItem.sPFPatientFileLanguagePref 
        self.bPFPatientFileIsOnHold                  = pfPatientFileItem.bPFPatientFileIsOnHold     
        self.sPFPatientFileOnHoldDate                = pfPatientFileItem.sPFPatientFileOnHoldDate   
        self.sPFPatientFileParentName                = pfPatientFileItem.sPFPatientFileParentName   
        self.sPFPatientFileParentID                  = pfPatientFileItem.sPFPatientFileParentID     

        self.iPFPatientFileSID                       = pfPatientFileItem.iPFPatientFileSID
        self.sPFPatientFileSidName                   = pfPatientFileItem.sPFPatientFileSidName 
        self.sPFPatientFileSupervisedVisits          = pfPatientFileItem.sPFPatientFileSupervisedVisits 
        self.bPFPatientFileIsToSuper                 = pfPatientFileItem.bPFPatientFileIsToSuper     

        self.sPFPatientFileAuthBegin                 = pfPatientFileItem.sPFPatientFileAuthBegin                
        self.sPFPatientFileAuthEnd                   = pfPatientFileItem.sPFPatientFileAuthEnd                  
        self.sPFPatientFileStartAuthBegin            = pfPatientFileItem.sPFPatientFileStartAuthBegin           
        self.sPFPatientFileStartAuthEnd              = pfPatientFileItem.sPFPatientFileStartAuthEnd             
        self.sPFPatientFileCurrentAuthBegin          = pfPatientFileItem.sPFPatientFileCurrentAuthBegin         
        self.sPFPatientFileCurrentAuthEnd            = pfPatientFileItem.sPFPatientFileCurrentAuthEnd           
        self.iPFPatientFileExpectedFrequency         = pfPatientFileItem.iPFPatientFileExpectedFrequency        
        self.iPFPatientFileExpectedVisits            = pfPatientFileItem.iPFPatientFileExpectedVisits           
        self.sPFPatientFileFirstVisitDate            = pfPatientFileItem.sPFPatientFileFirstVisitDate           
        self.sPFPatientFileLastVisitDate             = pfPatientFileItem.sPFPatientFileLastVisitDate            
        self.sPFPatientFileLastEvalDate              = pfPatientFileItem.sPFPatientFileLastEvalDate             
        self.sPFPatientFileLastDrVisitDate           = pfPatientFileItem.sPFPatientFileLastDrVisitDate          
        self.iPFPatientFileNewVisitCount             = pfPatientFileItem.iPFPatientFileNewVisitCount            
        self.iPFPatientFileNumberOfVisitsDone        = pfPatientFileItem.iPFPatientFileNumberOfVisitsDone       
        self.iPFPatientFileTotalAuthorizedVisits     = pfPatientFileItem.iPFPatientFileTotalAuthorizedVisits    
        self.iPFPatientFileTotalNumberOfMissedVisits = pfPatientFileItem.iPFPatientFileTotalNumberOfMissedVisits
        self.iPFPatientFileVisitCount                = pfPatientFileItem.iPFPatientFileVisitCount               
        self.iPFPatientFileVisitCount2               = pfPatientFileItem.iPFPatientFileVisitCount2              

        self.sPFPatientFileDME                       = pfPatientFileItem.sPFPatientFileDME                
        self.sPFPatientFileAlergies                  = pfPatientFileItem.sPFPatientFileAlergies           
        self.sPFPatientFileBehaviorObs               = pfPatientFileItem.sPFPatientFileBehaviorObs        
        self.sPFPatientFileCurrentDiet               = pfPatientFileItem.sPFPatientFileCurrentDiet        
        self.sPFPatientFileCurrentFrequencies        = pfPatientFileItem.sPFPatientFileCurrentFrequencies 
        self.sPFPatientFileCurrentTIDs               = pfPatientFileItem.sPFPatientFileCurrentTIDs        
        self.bPFPatientFileIsDischarged              = pfPatientFileItem.bPFPatientFileIsDischarged       
        self.sPFPatientFileEvalMeds                  = pfPatientFileItem.sPFPatientFileEvalMeds           
        self.bPFPatientFileHaveAdminVisits           = pfPatientFileItem.bPFPatientFileHaveAdminVisits    
        self.bPFPatientFileHaveMissedVisits          = pfPatientFileItem.bPFPatientFileHaveMissedVisits   
        self.iPFPatientFileHoldReason                = pfPatientFileItem.iPFPatientFileHoldReason         
        self.bPFPatientFileMakeupsAllowed            = pfPatientFileItem.bPFPatientFileMakeupsAllowed     
        self.iPFPatientFileMedNumber                 = pfPatientFileItem.iPFPatientFileMedNumber          
        self.bPFPatientFileNoPreSigRequired          = pfPatientFileItem.bPFPatientFileNoPreSigRequired   
        self.sPFPatientFilePertinentHistory          = pfPatientFileItem.sPFPatientFilePertinentHistory   
        self.iPFPatientFilePrimaryIns                = pfPatientFileItem.iPFPatientFilePrimaryIns         
        self.bPFPatientFileReadyForSuper             = pfPatientFileItem.bPFPatientFileReadyForSuper      
        self.sPFPatientFileRegisteredNames           = pfPatientFileItem.sPFPatientFileRegisteredNames    
        self.sPFPatientFileSafeties                  = pfPatientFileItem.sPFPatientFileSafeties           
        self.iPFPatientFileSecondaryIns              = pfPatientFileItem.iPFPatientFileSecondaryIns       
        self.sPFPatientFileStartTIDFrequencies       = pfPatientFileItem.sPFPatientFileStartTIDFrequencies
        self.sPFPatientFileStartTIDs                 = pfPatientFileItem.sPFPatientFileStartTIDs          
        self.sPFPatientFileTreatmentDX               = pfPatientFileItem.sPFPatientFileTreatmentDX        
        self.iPFPatientFileType                      = pfPatientFileItem.iPFPatientFileType               
        self.sPFPatientFileVisitsDone                = pfPatientFileItem.sPFPatientFileVisitsDone         

        self.pfPatientFileObjectLatitude             = pfPatientFileItem.pfPatientFileObjectLatitude
        self.pfPatientFileObjectLongitude            = pfPatientFileItem.pfPatientFileObjectLongitude
        self.sPFPatientFileObjectLatitude            = pfPatientFileItem.sPFPatientFileObjectLatitude
        self.sPFPatientFileObjectLongitude           = pfPatientFileItem.sPFPatientFileObjectLongitude
        self.dblPFPatientFileObjectLatitude          = pfPatientFileItem.dblPFPatientFileObjectLatitude
        self.dblPFPatientFileObjectLongitude         = pfPatientFileItem.dblPFPatientFileObjectLongitude

        let dblPreviousLatitude:Double               = self.dblConvertedLatitude
        let dblPreviousLongitude:Double              = self.dblConvertedLongitude
        let dblHomeLocLatitude:Double                = pfPatientFileItem.dblConvertedLatitude
        let dblHomeLocLongitude:Double               = pfPatientFileItem.dblConvertedLongitude

        self.dblConvertedLatitude                    = pfPatientFileItem.dblConvertedLatitude
        self.dblConvertedLongitude                   = pfPatientFileItem.dblConvertedLongitude
        
        // If 'self' (current) does NOT have 'important' location data, then copy all of it...

        if (self.sHomeLocLocationName.count < 1 ||
            self.sHomeLocCity.count         < 1)
        {
        
            self.sHomeLocLocationName          = pfPatientFileItem.sHomeLocLocationName        
            self.sHomeLocCity                  = pfPatientFileItem.sHomeLocCity                
            self.sHomeLocCountry               = pfPatientFileItem.sHomeLocCountry             
            self.sHomeLocPostalCode            = pfPatientFileItem.sHomeLocPostalCode          
            self.sHomeLocTimeZone              = pfPatientFileItem.sHomeLocTimeZone            

            self.bHomeLocAddessLookupScheduled = pfPatientFileItem.bHomeLocAddessLookupScheduled
            self.bHomeLocAddessLookupComplete  = pfPatientFileItem.bHomeLocAddessLookupComplete
        
        }
        else
        {

            // 'self' (HomeLoc) has location data, then use latitude/longitude changes to determine the update...

            let bLocationLatitudeHasChanged:Bool  = (abs(dblPreviousLatitude  - dblHomeLocLatitude)  > (3 * .ulpOfOne))
            let bLocationLongitudeHasChanged:Bool = (abs(dblPreviousLongitude - dblHomeLocLongitude) > (3 * .ulpOfOne))

            if (bLocationLatitudeHasChanged  == true ||
                bLocationLongitudeHasChanged == true)
            {
            
                self.sHomeLocLocationName          = pfPatientFileItem.sHomeLocLocationName        
                self.sHomeLocCity                  = pfPatientFileItem.sHomeLocCity                
                self.sHomeLocCountry               = pfPatientFileItem.sHomeLocCountry             
                self.sHomeLocPostalCode            = pfPatientFileItem.sHomeLocPostalCode          
                self.sHomeLocTimeZone              = pfPatientFileItem.sHomeLocTimeZone            

                self.bHomeLocAddessLookupScheduled = pfPatientFileItem.bHomeLocAddessLookupScheduled
                self.bHomeLocAddessLookupComplete  = pfPatientFileItem.bHomeLocAddessLookupComplete

                self.xcgLogMsg("\(sCurrMethodDisp) Intermediate <dup 'overlay'> <PFPatientFile> <location check> - Copied address data since 'bLocationLatitudeHasChanged' is [\(bLocationLatitudeHasChanged)] and/or 'bLocationLongitudeHasChanged' is [\(bLocationLongitudeHasChanged)] <location changed>...")
                self.xcgLogMsg("\(sCurrMethodDisp) Intermediate <dup 'overlay'> <PFPatientFile> <location check> - Location is [\(dblHomeLocLatitude),\(dblHomeLocLongitude)] and was [\(dblPreviousLatitude),\(dblPreviousLongitude)]...")

                if (self.sHomeLocLocationName.count < 1 ||
                    self.sHomeLocCity.count         < 1)
                {
                
                    self.bHomeLocAddessLookupScheduled  = false
                    self.bHomeLocAddessLookupComplete   = false
                
                }
            
            }
            else
            {
            
                self.xcgLogMsg("\(sCurrMethodDisp) Intermediate <dup 'overlay'> <PFPatientFile> <location check> - Skipped copying address data since 'bLocationLatitudeHasChanged' is [\(bLocationLatitudeHasChanged)] and 'bLocationLongitudeHasChanged' is [\(bLocationLongitudeHasChanged)] <location has NOT changed>...")
            
            }

        }
        
        // Check if the 'HomeLoc' Location data copied was 'blank'...

        if (self.sHomeLocLocationName.count < 1 ||
            self.sHomeLocCity.count         < 1)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) Intermediate <dup 'overlay'> <PFPatientFile> - Copied 'self.sHomeLocLocationName' is [\(self.sHomeLocLocationName)] and 'self.sHomeLocCity' is [\(self.sHomeLocCity)] - 1 or both are 'blank' - 'pfPatientFileItem.sHomeLocLocationName' is [\(pfPatientFileItem.sHomeLocLocationName)] and 'pfPatientFileItem.sHomeLocCity' is [\(pfPatientFileItem.sHomeLocCity)] - Warning!")

            self.resolveLocationAndAddress()

        }

        // Trace the 'clone' From/To fields in both objects...

        self.xcgLogMsg("\(sCurrMethodDisp) Intermediate <dup 'overlay'> <PFPatientFile> - From/To 'self.pfPatientFileObjectClonedFrom' is [\(String(describing: self.pfPatientFileObjectClonedFrom))] and 'self.pfPatientFileObjectClonedTo' is [\(String(describing: self.pfPatientFileObjectClonedTo))] - 'pfPatientFileItem.pfPatientFileObjectClonedFrom' is [\(String(describing: pfPatientFileItem.pfPatientFileObjectClonedFrom))] and 'pfPatientFileItem.pfPatientFileObjectClonedTo' is [\(String(describing: pfPatientFileItem.pfPatientFileObjectClonedTo))]...")

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of private func overlayPFPatientFileDataItemWithAnotherPFPatientFileDataItem(pfPatientFileItem:ParsePFPatientFileItem)

    private func convertPFPatientFileHomeLocToLatitudeLongitude()
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        var asToString:[String] = Array()

        asToString.append("[")

        // Convert the 'HomeLoc' field into Latitude/Longitude...

        asToString.append("\(sCurrMethodDisp) 'self.sPFPatientFileHomeLoc' is [\(self.sPFPatientFileHomeLoc)]...")

    //  let listHomeLocNoWS:[String]  = self.sPFPatientFileHomeLoc.components(separatedBy:CharacterSet.whitespacesAndNewlines)
    //
    //  asToString.append("\(sCurrMethodDisp) 'listHomeLocNoWS' is [\(listHomeLocNoWS)]...")
    //
    //  let sHomeLocNoWS:String = listHomeLocNoWS.joined(separator:"")
    //
    //  asToString.append("\(sCurrMethodDisp) 'sHomeLocNoWS' is [\(sHomeLocNoWS)]...")
    //
    //  var csHomeLocDelimiters1:CharacterSet = CharacterSet()
    //
    //  csHomeLocDelimiters1.insert(charactersIn: "<>")
    //
    //  let listHomeLocCleaned1:[String] = sHomeLocNoWS.components(separatedBy:csHomeLocDelimiters1)
    //
    //  asToString.append("\(sCurrMethodDisp) 'listHomeLocCleaned1' is [\(listHomeLocCleaned1)]...")
    //
    //  let sHomeLocCleaned1:String = listHomeLocCleaned1.joined(separator:"")
    //
    //  asToString.append("\(sCurrMethodDisp) 'sHomeLocCleaned1' is [\(sHomeLocCleaned1)]...")

        let sHomeLocCleaned1:String = self.sPFPatientFileHomeLoc.removeUnwantedCharacters(charsetToRemove:[StringCleaning.removeWhitespacesAndNewlines], sExtraCharacters:"<>,", bResultIsLowerCased:true)
        
        asToString.append("\(sCurrMethodDisp) 'sHomeLocCleaned1' is [\(sHomeLocCleaned1)]...")
      
        var csHomeLocDelimiters2:CharacterSet = CharacterSet()
      
        csHomeLocDelimiters2.insert(charactersIn: ",")

        let listHomeLocCleaned2:[String] = sHomeLocCleaned1.components(separatedBy:csHomeLocDelimiters2)

        asToString.append("\(sCurrMethodDisp) 'listHomeLocCleaned2' is [\(listHomeLocCleaned2)]...")

    //  var csHomeLocDelimiters3:CharacterSet = CharacterSet()
    //
    //  csHomeLocDelimiters3.insert(charactersIn: ":")

        if (listHomeLocCleaned2.count < 1)
        {
            
            asToString.append("\(sCurrMethodDisp) 'listHomeLocCleaned2' has a count of (\(listHomeLocCleaned2.count)) which is less than 1 - Error!")
            
        }
        else
        {
            
            asToString.append("\(sCurrMethodDisp) 'listHomeLocCleaned2' has a count of (\(listHomeLocCleaned2.count)) which is equal to or greater than 1 - continuing...")
            
            var dictHomeLocCleaned2:[String:String] = [String:String]()
            var cHomeLocWork:Int                    = 0
            
            for sHomeLocWork:String in listHomeLocCleaned2
            {
                
            //  if (sHomeLocWork.count < 1)
            //  {
            //      
            //      continue
            //      
            //  }
                
                cHomeLocWork += 1
                
                asToString.append("\(sCurrMethodDisp) #(\(cHomeLocWork)): 'sHomeLocWork' is [\(sHomeLocWork)]...")
                
            //  let listHomeLocWorkCleaned:[String] = sHomeLocWork.components(separatedBy:csHomeLocDelimiters3)
            //
            //  asToString.append("\(sCurrMethodDisp) #(\(cHomeLocWork)): 'listHomeLocWorkCleaned' is [\(listHomeLocWorkCleaned)]...")

                var sHomeLocKey:String   = ""
                var sHomeLocValue:String = ""
                
                if (cHomeLocWork == 1)
                {
                
                    sHomeLocKey   = "latitude"
                    sHomeLocValue = sHomeLocWork
                
                }
                
                if (cHomeLocWork == 2)
                {
                
                    sHomeLocKey   = "longitude"
                    sHomeLocValue = sHomeLocWork
                
                }
                
                dictHomeLocCleaned2[sHomeLocKey] = sHomeLocValue
                
                asToString.append("\(sCurrMethodDisp) #(\(cHomeLocWork)): Added a key 'sHomeLocKey' of [\(sHomeLocKey)] with a value 'sHomeLocValue' of [\(sHomeLocValue)] to the dictionary 'dictHomeLocCleaned2'...")
                
            }
                 
            asToString.append("\(sCurrMethodDisp) The dictionary 'dictHomeLocCleaned2' is [\(dictHomeLocCleaned2)]...")
            
            let sHomeLocLatitude:String  = dictHomeLocCleaned2["latitude"]  ?? "0.0000"
            let sHomeLocLongitude:String = dictHomeLocCleaned2["longitude"] ?? "0.0000"
            
            asToString.append("\(sCurrMethodDisp) 'sHomeLocLatitude'  is [\(sHomeLocLatitude)]...")
            asToString.append("\(sCurrMethodDisp) 'sHomeLocLongitude' is [\(sHomeLocLongitude)]...")

            self.pfPatientFileObjectLatitude     = sHomeLocLatitude
            self.pfPatientFileObjectLongitude    = sHomeLocLongitude
            self.sPFPatientFileObjectLatitude    = String(describing: pfPatientFileObjectLatitude!)
            self.sPFPatientFileObjectLongitude   = String(describing: pfPatientFileObjectLongitude!)
            self.dblPFPatientFileObjectLatitude  = Double(sPFPatientFileObjectLatitude)        ?? 0.0000
            self.dblPFPatientFileObjectLongitude = Double(sPFPatientFileObjectLongitude)       ?? 0.0000
            self.dblConvertedLatitude            = Double(String(describing: sHomeLocLatitude))  ?? 0.0000
            self.dblConvertedLongitude           = Double(String(describing: sHomeLocLongitude)) ?? 0.0000
            
            asToString.append("\(sCurrMethodDisp) 'pfPatientFileObjectLatitude'     is [\(String(describing: pfPatientFileObjectLatitude))]...")
            asToString.append("\(sCurrMethodDisp) 'pfPatientFileObjectLongitude'    is [\(String(describing: pfPatientFileObjectLongitude))]...")
            asToString.append("\(sCurrMethodDisp) 'sPFPatientFileObjectLatitude'    is [\(sPFPatientFileObjectLatitude)]...")
            asToString.append("\(sCurrMethodDisp) 'sPFPatientFileObjectLongitude'   is [\(sPFPatientFileObjectLongitude)]...")
            asToString.append("\(sCurrMethodDisp) 'dblPFPatientFileObjectLatitude'  is [\(dblPFPatientFileObjectLatitude)]...")
            asToString.append("\(sCurrMethodDisp) 'dblPFPatientFileObjectLongitude' is [\(dblPFPatientFileObjectLongitude)]...")
            asToString.append("\(sCurrMethodDisp) 'dblConvertedLatitude'            is [\(dblConvertedLatitude)]...")
            asToString.append("\(sCurrMethodDisp) 'dblConvertedLongitude'           is [\(dblConvertedLongitude)]...")
            
        }

        // If we have an 'Internal' Trace flag, then output all the captured log messages...

        if (bInternalTraceFlag == true)
        {

            let sContents:String = "{"+(asToString.joined(separator: ""))+"}"

            self.xcgLogMsg("\(sCurrMethodDisp) Accumulated 'sContents' is [\(sContents)]...")

        }

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of private func convertPFPatientFileHomeLocToLatitudeLongitude().

    public func resolveLocationAndAddress()
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

    //  // Check if the Patient is 'NOT Active', if so, bypass address/location resolve...
    //
    //  if (self.bPFPatientFileNotActive == true)
    //  {
    //
    //      self.xcgLogMsg("\(sCurrMethodDisp) Intermediate - bypassing the address 'resolve' - 'self.bPFPatientFileNotActive' is [\(self.bPFPatientFileNotActive)]...")
    //
    //      // Exit:
    //
    //      self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
    //
    //      return
    //  }

        // Check if address 'lookup' has already been scheduled, if so, bypass address/location resolve...

        if (self.bHomeLocAddessLookupScheduled == true)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) Intermediate - bypassing the address 'resolve' - 'self.bHomeLocAddessLookupScheduled' is [\(self.bHomeLocAddessLookupScheduled)]...")

            // Exit:

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return
        
        }

        // Use the Latitude/Longitude values to resolve address...

        if (self.jmAppDelegateVisitor.jmAppCLModelObservable2 != nil)
        {

        //  let clModelObservable2:CoreLocationModelObservable2 = self.jmAppDelegateVisitor.jmAppCLModelObservable2!

            self.bHomeLocAddessLookupScheduled = true
            self.bHomeLocAddessLookupComplete  = false
            
        //  let dblDeadlineInterval:Double     = clModelObservable2.requestNextReverseLocationLookupDeadlineInterval(clRevLocType:CLRevLocType.tertiary)
        //
        //  DispatchQueue.main.asyncAfter(deadline:(.now() + dblDeadlineInterval))
        //  {
        //      self.xcgLogMsg("\(sCurrMethodDisp) #(\(self.idPFPatientFileObject)): <closure> Calling 'updateGeocoderLocation()' with 'self' of [\(String(describing: self))] for Latitude/Longitude of [\(self.dblConvertedLatitude)/\(self.dblConvertedLongitude)] for Therapist [\(self.sPFPatientFileName)]...")
        //
        //      let _ = clModelObservable2.updateGeocoderLocations(requestID: self.idPFPatientFileObject, 
        //                                                         latitude:  self.dblConvertedLatitude, 
        //                                                         longitude: self.dblConvertedLongitude, 
        //                                                         withCompletionHandler:
        //                                                             { (requestID:Int, dictCurrentLocation:[String:Any]) in
        //                                                                 self.handleLocationAndAddressClosureEvent(bIsDownstreamObject:false, requestID:requestID, dictCurrentLocation:dictCurrentLocation)
        //                                                             }
        //                                                        )
        //  }

        }
        else
        {

            self.bHomeLocAddessLookupScheduled = false
            self.bHomeLocAddessLookupComplete  = false

            self.xcgLogMsg("\(sCurrMethodDisp) #(\(self.idPFPatientFileObject)): CoreLocation (service) is NOT available...")

        }

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of public func resolveLocationAndAddress().

    public func handleLocationAndAddressClosureEvent(bIsDownstreamObject:Bool = false, requestID:Int, dictCurrentLocation:[String:Any])
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

    //  self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'self' is [\(String(describing: self))] for Therapist [\(self.idPFPatientFileObject)] - parameter 'bIsDownstreamObject' is [\(bIsDownstreamObject)] - 'requestID' is [\(requestID)] - 'dictCurrentLocation' is [\(String(describing: dictCurrentLocation))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - for Therapist [\(self.idPFPatientFileObject)] - parameter 'bIsDownstreamObject' is [\(bIsDownstreamObject)]...")

        // Update the address info for BOTH 'self' and (possibly 'from'/'to')...

        if (dictCurrentLocation.count > 0)
        {
        
        //  self.xcgLogMsg("\(sCurrMethodDisp) #(\(requestID)): <closure> Called  'updateGeocoderLocation()' with 'self' of [\(String(describing: self))] for Latitude/Longitude of [\(self.dblConvertedLatitude)/\(self.dblConvertedLongitude)] for Therapist [\(self.sPFPatientFileName)] current 'location' [\(String(describing: dictCurrentLocation))]...")

            self.sHomeLocLocationName = String(describing: (dictCurrentLocation["sCurrentLocationName"] ?? ""))
            self.sHomeLocCity         = String(describing: (dictCurrentLocation["sCurrentCity"]         ?? ""))
            self.sHomeLocCountry      = String(describing: (dictCurrentLocation["sCurrentCountry"]      ?? ""))
            self.sHomeLocPostalCode   = String(describing: (dictCurrentLocation["sCurrentPostalCode"]   ?? ""))
            self.sHomeLocTimeZone     = String(describing: (dictCurrentLocation["tzCurrentTimeZone"]    ?? ""))

            self.bHomeLocAddessLookupComplete = true

            if (bIsDownstreamObject == false)
            {
            
                if (self.pfPatientFileObjectClonedFrom != nil &&
                    self.pfPatientFileObjectClonedFrom != self)
                {

                //  self.xcgLogMsg("\(sCurrMethodDisp) #(\(requestID)): <closure> Calling 'self.pfPatientFileObjectClonedFrom' of [\(String(describing: self.pfPatientFileObjectClonedFrom))] with 'self' of [\(String(describing: self))] for Therapist [\(self.sPFPatientFileName)]...")

                    self.pfPatientFileObjectClonedFrom!.handleLocationAndAddressClosureEvent(bIsDownstreamObject:true, requestID:requestID, dictCurrentLocation:dictCurrentLocation)

                //  self.xcgLogMsg("\(sCurrMethodDisp) #(\(requestID)): <closure> Called  'self.pfPatientFileObjectClonedFrom' of [\(String(describing: self.pfPatientFileObjectClonedFrom))] with 'self' of [\(String(describing: self))] for Therapist [\(self.sPFPatientFileName)]...")

                }

                if (self.pfPatientFileObjectClonedTo != nil &&
                    self.pfPatientFileObjectClonedTo != self)
                {

                //  self.xcgLogMsg("\(sCurrMethodDisp) #(\(requestID)): <closure> Calling 'self.pfPatientFileObjectClonedTo' of [\(String(describing: self.pfPatientFileObjectClonedTo))] with 'self' of [\(String(describing: self))] for Therapist [\(self.sPFPatientFileName)]...")

                    self.pfPatientFileObjectClonedTo!.handleLocationAndAddressClosureEvent(bIsDownstreamObject:true, requestID:requestID, dictCurrentLocation:dictCurrentLocation)

                //  self.xcgLogMsg("\(sCurrMethodDisp) #(\(requestID)): <closure> Called  'self.pfPatientFileObjectClonedTo' of [\(String(describing: self.pfPatientFileObjectClonedTo))] with 'self' of [\(String(describing: self))] for Therapist [\(self.sPFPatientFileName)]...")

                }
            
            }
        
        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) #(\(requestID)): Dictionary 'dictCurrentLocation' is 'empty' - bypassing update - Warning!")

            self.bHomeLocAddessLookupComplete = false

        }

        self.bHomeLocAddessLookupScheduled = false

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of public func handleLocationAndAddressClosureEvent(bIsDownstreamObject:Bool, requestID:Int, dictCurrentLocation:[String:Any]).

    private func getMetaTypeStringForObject(object:Any)->String
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        if (bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter - 'object' is [\(object)]...")

        }

        var sValueTypeOf:String = "-undefined-"

        switch (object)
        {
            case is Int:
                sValueTypeOf = "Int"
            case is Double:
                sValueTypeOf = "Double"
            case is String:
                sValueTypeOf = "String"
            case is NSArray, is [AnyObject]:
                sValueTypeOf = "List"
            case is NSDictionary, is Dictionary<AnyHashable, Any>:
                sValueTypeOf = "Dictionary"
            default:
                sValueTypeOf = "-unmatched-"
        }

        if (bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Supplied object is 'typeOf' [\(String(describing: type(of: object)))]/[\(sValueTypeOf)]...")

        }

        // Exit:

        if (bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'sValueTypeOf' is [\(sValueTypeOf)]...")

        }

        return sValueTypeOf

    } // End of private func getMetaTypeStringForObject(object:Any)->String.

    private func formatPhoneNumber(sPhoneNumber:String = "")->String
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        if (bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'sPhoneNumber' is [\(sPhoneNumber)]...")

        }

        // Format the supplied Phone #...

        var sPhoneNumberFormatted:String = ""
        
        if (sPhoneNumber.count < 1)
        {
            
            // Exit...

            if (bInternalTraceFlag == true)
            {

                self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'sPhoneNumber' is [\(sPhoneNumber)] - 'sPhoneNumberFormatted' is [\(sPhoneNumberFormatted)]...")

            }

            return sPhoneNumberFormatted
            
        }
        
        let sPhoneNumberMask:String              = "(XXX) XXX-XXXX"
        let sPhoneNumberCleaned:String           = sPhoneNumber.components(separatedBy:CharacterSet.decimalDigits.inverted).joined()
        var siPhoneNumberStartIndex:String.Index = sPhoneNumberCleaned.startIndex
        let eiPhoneNumberEndIndex:String.Index   = sPhoneNumberCleaned.endIndex
        
        for chCurrentNumber in sPhoneNumberMask where siPhoneNumberStartIndex < eiPhoneNumberEndIndex
        {
            
            if chCurrentNumber == "X"
            {
                
                sPhoneNumberFormatted.append(sPhoneNumberCleaned[siPhoneNumberStartIndex])
                
                siPhoneNumberStartIndex = sPhoneNumberCleaned.index(after:siPhoneNumberStartIndex)
                
            }
            else
            {
                
                sPhoneNumberFormatted.append(chCurrentNumber)
                
            }
            
        }

        // Exit...

        if (bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'sPhoneNumber' is [\(sPhoneNumber)] - 'sPhoneNumberFormatted' is [\(sPhoneNumberFormatted)]...")

        }
  
        return sPhoneNumberFormatted
        
    }   // End of private func formatPhoneNumber(sPhoneNumber:String)->String

    private func reducePFObjectListOfStrings(object:Any, listStringsToRemove:[String] = [""], bFormatNumericsAsPhoneNumbers:Bool = false)->String
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        if (bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter - 'object' is [\(object)] - 'listStringsToRemove' is [\(listStringsToRemove)] - 'bFormatNumericsAsPhoneNumbers' is [\(bFormatNumericsAsPhoneNumbers)]...")

        }

        // Process the supplied 'object' as a List of String(s) to reduce...

        var sReducedListOfStrings:String = ""
        let sTypeOfObjectToReduce:String = self.getMetaTypeStringForObject(object:object as Any)

        if (bInternalTraceFlag == true)
        {

            let typeOfObjectToReduce = type(of:object)

            self.xcgLogMsg("\(sCurrMethodDisp) <PFOuery Data Probe> - 'typeOfObjectToReduce' is [\(typeOfObjectToReduce)] and 'sTypeOfObjectToReduce' is [\(sTypeOfObjectToReduce)] for 'object' is [\(String(describing: object))]...")

        }

        if (sTypeOfObjectToReduce == "List")
        {

            guard let listObjectToReduce:[String] = (object as? [String]) else { return String(describing:object) }

            var listOfReducedStrings:[String]     = [String]()
        
            for sCurrentStringInList:String in listObjectToReduce
            {

                if (sCurrentStringInList.count > 1)
                {
                    
                    var sCurrentStringInListTrimmed:String = sCurrentStringInList.trimmingCharacters(in:.whitespacesAndNewlines)
                    
                //  self.xcgLogMsg("\(sCurrMethodDisp) <ListOfStrings reduction> - 'sCurrentStringInList' is [\(sCurrentStringInList)] and 'sCurrentStringInListTrimmed' is [\(sCurrentStringInListTrimmed)]...")
 
                    if (sCurrentStringInListTrimmed.count < 1)
                    {
                    
                        sCurrentStringInListTrimmed = ""
                    
                    }
                    
                    if (listStringsToRemove.count > 0 &&
                        listStringsToRemove.contains(sCurrentStringInListTrimmed))
                    {
                    
                        continue
                    
                    }
                        
                    if (bFormatNumericsAsPhoneNumbers == true)
                    {
                    
                        if (Double(sCurrentStringInList) != nil)
                        {

                            listOfReducedStrings.append(self.formatPhoneNumber(sPhoneNumber:sCurrentStringInListTrimmed))

                        }
                        else
                        {

                            listOfReducedStrings.append(sCurrentStringInListTrimmed)

                        }
                    
                    }
                    else
                    {

                        listOfReducedStrings.append(sCurrentStringInListTrimmed)

                    }
                
                }

            }

            sReducedListOfStrings = listOfReducedStrings.joined(separator:",")
        
        }
        else
        {

            sReducedListOfStrings = String(describing:object)

        }

        // Exit:

        if (bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'sReducedListOfStrings' is [\(sReducedListOfStrings)]...")

        }

        return sReducedListOfStrings

    } // End of private func reducePFObjectListOfStrings(object:Any, listStringsToRemove:[String], bFormatNumericsAsPhoneNumbers:Bool)->String.

}   // End of class ParsePFPatientFileItem(NSObject, Identifiable).

