//
//  ScheduledPatientLocationItem.swift
//  JustAFirstSwiftDataApp1
//
//  Created by Daryl Cox on 12/04/2024.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
import ParseCore

class ScheduledPatientLocationItem: NSObject, Identifiable, ObservableObject
{
    
    struct ClassInfo
    {
        
        static let sClsId        = "ScheduledPatientLocationItem"
        static let sClsVers      = "v1.2103"
        static let sClsDisp      = sClsId+"(.swift).("+sClsVers+"):"
        static let sClsCopyRight = "Copyright (C) JustMacApps 2023-2025. All Rights Reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }

    // 'Internal' Trace flag:

    private 
    var bInternalTraceFlag:Bool                             = false

    // Item Data field(s):
    
    var id:UUID
//  var id:UUID                                             = UUID()
//  { get: }

    var idSchedPatLocObject:Int                             = 0

    var schedPatLocClonedFrom:ScheduledPatientLocationItem? = nil 
    var schedPatLocClonedTo:ScheduledPatientLocationItem?   = nil 

    var sTid:String                                         = "-1" // From 'PFAdminsSwiftDataItem' <String>
                                                                   // -OR- 'PFQuery::TherapistFile["ID"]'
                                                                   // -OR- 'PFQuery::PatientCalDay["tid"]'
    var iTid:Int                                            = -1   // Converted from 'sTid <String>'...
    var sTName:String                                       = ""   // From 'PFQuery::PatientCalDay["tName"]'
    var sTherapistName:String                               = ""   // From 'PFQuery::TherapistFile["name"]' 

    var sPid:String                                         = "-1" // From 'PFQuery::PatientCalDay["pid"]' <Int>
    var iPid:Int                                            = -1   // Converted from 'sPid <String>'...
    var sPtName:String                                      = ""   // From 'PFQuery::PatientCalDay["ptName"]'
    var sPatientDOB:String                                  = ""   // From 'PFQuery::PatientFile["DOB"]' (Date Of Birth)
    var iPatientPrimaryIns:Int                              = -1   // 'pfPatientFileObject[primaryIns]'
    var iPatientSecondaryIns:Int                            = -1   // 'pfPatientFileObject[secondaryIns]'

    var sVDate:String                                       = ""   // From 'PFQuery::PatientCalDay["VDate"]'
    var sVDateStartTime:String                              = ""   // From 'PFQuery::PatientCalDay["startTime"]'
    var sVDateStartTime24h:String                           = ""   // Converted from 'sVDateStartTime'
    var iVDateStartTime24h:Int                              = 0    // Converted from 'sVDateStartTime24h'

    var sLastVDate:String                                   = ""   // From 'PFQuery::BackupVisit["VDate"]'
    var sLastVDateType:String                               = "-1" // From 'PFQuery::BackupVisit["type"]'
    var iLastVDateType:Int                                  = -1   // Converted from 'sLastVDateType <String>'...
    var sLastVDateLatitude:String                           = ""   // From 'PFQuery::BackupVisit["lat"]'
    var sLastVDateLongitude:String                          = ""   // From 'PFQuery::BackupVisit["long"]'
    var sLastVDateAddress:String                            = ""   // From 'PFQuery::BackupVisit["address"]'

    var clLocationCoordinate2DPatLoc:CLLocationCoordinate2D
    {

        return CLLocationCoordinate2D(latitude:  Double(self.sLastVDateLatitude)  ?? 0.0,
                                      longitude: Double(self.sLastVDateLongitude) ?? 0.0)

    }

    var sVDateAddressOrLatLong:String
    {

        if (self.sLastVDateAddress.count  < 1       ||
            self.sLastVDateAddress       == ""      ||
            self.sLastVDateAddress       == "-N/A-" ||
            self.sLastVDateAddress       == ",,,"   ||
            self.sLastVDateAddress       == ", , , ")
        {

            return ("\(self.sLastVDateLatitude), \(self.sLastVDateLongitude)")

        }
        else
        {

            return (self.sLastVDateAddress)

        }

    }

    var sVDateShortDisplay:String
    {

        if (self.sVDate.count < 1)
        {
        
            return self.sVDate
        
        }
        
        let strategyVDate                  = Date.ParseStrategy(format:  "\(year:.defaultDigits)-\(month:.twoDigits)-\(day:.twoDigits)", 
                                                                timeZone:.current)
        let dateVDate:Date                 = try! Date(self.sVDate, strategy:strategyVDate)
        let dtFormatterVDate:DateFormatter = DateFormatter()

        dtFormatterVDate.locale            = Locale(identifier: "en_US")
        dtFormatterVDate.timeZone          = TimeZone.current
        dtFormatterVDate.dateFormat        = "M/dd/yy"

        return "\(dtFormatterVDate.string(from:dateVDate))"

    }

    var scheduleType:ScheduleType                           = ScheduleType.undefined

    var colorOfItem:Color                                   = Color.primary

    var jmAppDelegateVisitor:JmAppDelegateVisitor           = JmAppDelegateVisitor.ClassSingleton.appDelegateVisitor

    override init()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.id = UUID()

        super.init()

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of override init().

    convenience init(scheduledPatientLocationItem:ScheduledPatientLocationItem)
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
  
        self.init()
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Finish the 'convenience' setup of field(s)...

        self.init(bDeepCopyIsAnOverlay:false, scheduledPatientLocationItem:scheduledPatientLocationItem)

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return
  
    }   // End of convenience init(scheduledPatientLocationItem:ScheduledPatientLocationItem).

    convenience init(bDeepCopyIsAnOverlay:Bool, scheduledPatientLocationItem:ScheduledPatientLocationItem)
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
  
        self.init()
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Finish the 'convenience' setup of field(s)...

        self.overlayScheduledPatientLocationItemWithAnotherScheduledPatientLocationItem(scheduledPatientLocationItem:scheduledPatientLocationItem)

        if (bDeepCopyIsAnOverlay == false)
        {
        
            self.schedPatLocClonedFrom                         = scheduledPatientLocationItem
            self.schedPatLocClonedFrom                         = self

        //  scheduledPatientLocationItem.schedPatLocClonedFrom = nil
            scheduledPatientLocationItem.schedPatLocClonedFrom = self
        
        }

    //  // Check if the 'current' Location data copied was 'blank'...
    //
    //  if (self.sHomeLocLocationName.count < 1 ||
    //      self.sHomeLocCity.count         < 1)
    //  {
    //  
    //      self.xcgLogMsg("\(sCurrMethodDisp) Intermediate <dup copy 'init'> <ScheduledPatientLocationItem> - Copied 'self.sHomeLocLocationName' is [\(self.sHomeLocLocationName)] and 'self.sHomeLocCity' is [\(self.sHomeLocCity)] - 1 or both are 'blank' - 'pfTherapistFileItem.sHomeLocLocationName' is [\(pfTherapistFileItem.sHomeLocLocationName)] and 'pfTherapistFileItem.sHomeLocCity' is [\(pfTherapistFileItem.sHomeLocCity)] - Warning!")
    //  
    //  }
    //
    //  // Trace the 'clone' From/To fields in both objects...
    //
    //  self.xcgLogMsg("\(sCurrMethodDisp) Intermediate <dup copy 'init'> <ScheduledPatientLocationItem> - From/To 'self.pfTherapistFileObjectClonedFrom' is [\(String(describing: self.pfTherapistFileObjectClonedFrom))] and 'self.pfTherapistFileObjectClonedTo' is [\(String(describing: self.pfTherapistFileObjectClonedTo))] - 'pfTherapistFileItem.pfTherapistFileObjectClonedFrom' is [\(String(describing: pfTherapistFileItem.pfTherapistFileObjectClonedFrom))] and 'pfTherapistFileItem.pfTherapistFileObjectClonedTo' is [\(String(describing: pfTherapistFileItem.pfTherapistFileObjectClonedTo))]...")

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return
  
    }   // End of convenience init(bDeepCopyIsAnOverlay:Bool, scheduledPatientLocationItem:ScheduledPatientLocationItem).

    convenience init(pfTherapistFileItem:PFObject)
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
  
        self.init()
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Finish the 'convenience' setup of field(s)...

        self.updateScheduledPatientLocationItemFromPFTherapistFile(pfTherapistFileItem:pfTherapistFileItem)

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return
  
    }   // End of convenience init(pfTherapistFileItem:PFObject).

    convenience init(pfPatientCalDayItem:PFObject)
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
  
        self.init()
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Finish the 'convenience' setup of field(s)...

        self.updateScheduledPatientLocationItemFromPFPatientCalDay(pfPatientCalDayItem:pfPatientCalDayItem)

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return
  
    }   // End of convenience init(pfPatientCalDayItem:PFObject).

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
        asToString.append("'idSchedPatLocObject': [\(String(describing: self.idSchedPatLocObject))],")
        asToString.append("'schedPatLocClonedFrom': [\(String(describing: self.schedPatLocClonedFrom))],")
        asToString.append("'schedPatLocClonedTo': [\(String(describing: self.schedPatLocClonedTo))],")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'sTid': [\(String(describing: self.sTid))],")
        asToString.append("'iTid': (\(String(describing: self.iTid))),")
        asToString.append("'sTName': [\(String(describing: self.sTName))],")
        asToString.append("'sTherapistName': [\(String(describing: self.sTherapistName))],")
        asToString.append("'sPid': [\(String(describing: self.sPid))],")
        asToString.append("'iPid': (\(String(describing: self.iPid))),")
        asToString.append("'sPtName': [\(String(describing: self.sPtName))],")
        asToString.append("'sPatientDOB': [\(String(describing: self.sPatientDOB))],")
        asToString.append("'iPatientPrimaryIns': (\(String(describing: self.iPatientPrimaryIns))),")
        asToString.append("'iPatientSecondaryIns': (\(String(describing: self.iPatientSecondaryIns))),")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'sVDate': [\(String(describing: self.sVDate))],")
        asToString.append("'sVDateStartTime': [\(String(describing: self.sVDateStartTime))],")
        asToString.append("'sVDateStartTime24h': [\(String(describing: self.sVDateStartTime24h))],")
        asToString.append("'iVDateStartTime24h': (\(String(describing: self.iVDateStartTime24h))),")
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
        asToString.append("'clLocationCoordinate2DPatLoc': [\(String(describing: self.clLocationCoordinate2DPatLoc))],")
        asToString.append("'sVDateAddressOrLatLong': [\(String(describing: self.sVDateAddressOrLatLong))],")
        asToString.append("'sVDateShortDisplay': [\(String(describing: self.sVDateShortDisplay))],")
        asToString.append("'scheduleType': [\(String(describing: self.scheduleType))],")
        asToString.append("'colorOfItem': [\(String(describing: self.colorOfItem))],")
    //  asToString.append("],")
    //  asToString.append("[")
    //  asToString.append("'jmAppDelegateVisitor': [\(self.jmAppDelegateVisitor)],")
        asToString.append("],")
        asToString.append("]")

        let sContents:String = "{"+(asToString.joined(separator: ""))+"}"

        return sContents

    }   // End of public func toString().

    public func getScheduledPatientLocationItemId()->UUID
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'self.id' is [\(self.id)]...")

        return self.id

    }   // End of public func getScheduledPatientLocationItemId()->UUID.

    public func displayScheduledPatientLocationItemToLog()
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Display the various field(s) of this object...

        self.xcgLogMsg("\(sCurrMethodDisp) 'self'                  is [\(String(describing: self))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'id'                    is [\(String(describing: self.id))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'idSchedPatLocObject'   is [\(String(describing: self.idSchedPatLocObject))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'schedPatLocClonedFrom' is [\(String(describing: self.schedPatLocClonedFrom))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'schedPatLocClonedTo'   is [\(String(describing: self.schedPatLocClonedTo))]...")

        self.xcgLogMsg("\(sCurrMethodDisp) 'sTid'                  is [\(String(describing: self.sTid))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'iTid'                  is (\(String(describing: self.iTid)))...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sTName'                is [\(String(describing: self.sTName))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sTherapistName'        is [\(String(describing: self.sTherapistName))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPid'                  is [\(String(describing: self.sPid))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'iPid'                  is (\(String(describing: self.iPid)))...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPtName'               is [\(String(describing: self.sPtName))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sPatientDOB'           is [\(String(describing: self.sPatientDOB))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'iPatientPrimaryIns'    is (\(String(describing: self.iPatientPrimaryIns)))...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'iPatientSecondaryIns'  is (\(String(describing: self.iPatientSecondaryIns)))...")

        self.xcgLogMsg("\(sCurrMethodDisp) 'sVDate'                is [\(String(describing: self.sVDate))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sVDateStartTime'       is [\(String(describing: self.sVDateStartTime))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sVDateStartTime24h'    is [\(String(describing: self.sVDateStartTime24h))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'iVDateStartTime24h'    is (\(String(describing: self.iVDateStartTime24h)))...")

        self.xcgLogMsg("\(sCurrMethodDisp) 'sLastVDate'            is [\(String(describing: self.sLastVDate))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sLastVDateType'        is [\(String(describing: self.sLastVDateType))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'iLastVDateType'        is (\(String(describing: self.iLastVDateType)))...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sLastVDateLatitude'    is [\(String(describing: self.sLastVDateLatitude))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sLastVDateLongitude'   is [\(String(describing: self.sLastVDateLongitude))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sLastVDateAddress'     is [\(String(describing: self.sLastVDateAddress))]...")

        self.xcgLogMsg("\(sCurrMethodDisp) 'scheduleType'          is [\(String(describing: self.scheduleType))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'colorOfItem'           is [\(String(describing: self.colorOfItem))]...")

        var bDoBothVDatesMatch:Bool = false

        if (self.sVDate.count      > 0 &&
            self.sLastVDate.count  > 0 &&
            self.sVDate           == self.sLastVDate)
        {
        
            bDoBothVDatesMatch = true
        
        }
        
    //  self.xcgLogMsg("\(sCurrMethodDisp) - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ")
    //  self.xcgLogMsg("\(sCurrMethodDisp) <VDate-comparison> 'sVDate' of [\(String(describing: self.sVDate))] matched to 'sLastVDate' of [\(String(describing: self.sLastVDate))] - 'bDoBothVDatesMatch' is [\(bDoBothVDatesMatch)]...")
        self.xcgLogMsg("\(sCurrMethodDisp) = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ")

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of public func displayScheduledPatientLocationItemToLog().

    public func overlayScheduledPatientLocationItemWithAnotherScheduledPatientLocationItem(scheduledPatientLocationItem:ScheduledPatientLocationItem)
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
  
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Parameter 'scheduledPatientLocationItem' is [\(scheduledPatientLocationItem)]...")

        }

        // Finish the 'convenience' setup of field(s)...

        self.idSchedPatLocObject                           = scheduledPatientLocationItem.idSchedPatLocObject 

    //  // 'Object' From/To update does NOT occur in an 'overlay'...
    //
    //  self.schedPatLocClonedFrom                         = scheduledPatientLocationItem 
    //  self.schedPatLocClonedTo                           = nil 
    //
    //  scheduledPatientLocationItem.schedPatLocClonedFrom = nil
    //  scheduledPatientLocationItem.schedPatLocClonedTo   = self

        self.sTid                                          = scheduledPatientLocationItem.sTid               
        self.iTid                                          = scheduledPatientLocationItem.iTid               
        self.sTName                                        = scheduledPatientLocationItem.sTName             
        self.sTherapistName                                = scheduledPatientLocationItem.sTherapistName     
                                                                                                             
        self.sPid                                          = scheduledPatientLocationItem.sPid               
        self.iPid                                          = scheduledPatientLocationItem.iPid               
        self.sPtName                                       = scheduledPatientLocationItem.sPtName            
        self.sPatientDOB                                   = scheduledPatientLocationItem.sPatientDOB            
        self.iPatientPrimaryIns                            = scheduledPatientLocationItem.iPatientPrimaryIns            
        self.iPatientSecondaryIns                          = scheduledPatientLocationItem.iPatientSecondaryIns            
                                                                                                             
        self.sVDate                                        = scheduledPatientLocationItem.sVDate             
        self.sVDateStartTime                               = scheduledPatientLocationItem.sVDateStartTime    
        self.sVDateStartTime24h                            = scheduledPatientLocationItem.sVDateStartTime24h
        self.iVDateStartTime24h                            = scheduledPatientLocationItem.iVDateStartTime24h
                                                                                                             
        self.sLastVDate                                    = scheduledPatientLocationItem.sLastVDate         
        self.sLastVDateType                                = scheduledPatientLocationItem.sLastVDateType     
        self.iLastVDateType                                = scheduledPatientLocationItem.iLastVDateType     
        self.sLastVDateLatitude                            = scheduledPatientLocationItem.sLastVDateLatitude 
        self.sLastVDateLongitude                           = scheduledPatientLocationItem.sLastVDateLongitude
        self.sLastVDateAddress                             = scheduledPatientLocationItem.sLastVDateAddress  

        self.scheduleType                                  = scheduledPatientLocationItem.scheduleType  
        self.colorOfItem                                   = scheduledPatientLocationItem.colorOfItem  

        // Check if the 'current' Location data copied was 'blank'...

        if (self.sLastVDateAddress.count   < 1 ||
            self.sLastVDateLatitude.count  < 1 ||
            self.sLastVDateLongitude.count < 1)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) Intermediate <dup copy> <SchedPatLoc> - Copied 'self.sLastVDateAddress' is [\(self.sLastVDateAddress)] and 'self.sLastVDateLatitude' is [\(self.sLastVDateLatitude)] and 'self.sLastVDateLongitude' is [\(self.sLastVDateLongitude)] - 1 or all 3 are 'blank' - 'scheduledPatientLocationItem.sLastVDateAddress' is [\(scheduledPatientLocationItem.sLastVDateAddress)] and 'scheduledPatientLocationItem.sLastVDateLatitude' is [\(scheduledPatientLocationItem.sLastVDateLatitude)] and 'scheduledPatientLocationItem.sLastVDateLongitude' is [\(scheduledPatientLocationItem.sLastVDateLongitude)] - Warning!")
        
        }

        // Trace the 'clone' From/To fields in both objects...

        self.xcgLogMsg("\(sCurrMethodDisp) Intermediate <dup copy> <SchedPatLoc> - From/To 'self.schedPatLocClonedFrom' is [\(String(describing: self.schedPatLocClonedFrom))] and 'self.schedPatLocClonedTo' is [\(String(describing: self.schedPatLocClonedTo))] - 'scheduledPatientLocationItem.schedPatLocClonedFrom' is [\(String(describing: scheduledPatientLocationItem.schedPatLocClonedFrom))] and 'scheduledPatientLocationItem.schedPatLocClonedTo' is [\(String(describing: scheduledPatientLocationItem.schedPatLocClonedTo))]...")

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return
  
    }   // End of public func overlayScheduledPatientLocationItemWithAnotherScheduledPatientLocationItem(scheduledPatientLocationItem:ScheduledPatientLocationItem).
    
    public func updateScheduledPatientLocationItemFromPFTherapistFile(pfTherapistFileItem:PFObject)
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Parameter 'pfTherapistFileItem.ID' is [\(String(describing: pfTherapistFileItem.object(forKey:"ID")))]...")

        }

        // Handle the 'update' (setup) of field(s)...

        if (self.sTid.count  < 1 ||
            self.sTid       == "-1")
        {

            self.sTid = String(describing: (pfTherapistFileItem.object(forKey:"ID") ?? "-1"))
            self.iTid = Int(self.sTid)!

        }
  
        self.sTherapistName = String(describing: (pfTherapistFileItem.object(forKey:"name") ?? ""))

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return
  
    }   // End of public func updateScheduledPatientLocationItemFromPFTherapistFile(pfTherapistFileItem:PFObject).

    public func updateScheduledPatientLocationItemFromPFTherapistFile(pfTherapistFileItem:ParsePFTherapistFileItem)
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Parameter 'pfTherapistFileItem.iPFTherapistFileTID' is [\(String(describing: pfTherapistFileItem.iPFTherapistFileTID))]...")

        }

        // Handle the 'update' (setup) of field(s)...

        if (self.sTid.count  < 1 ||
            self.sTid       == "-1")
        {

            self.sTid = String(describing: pfTherapistFileItem.iPFTherapistFileTID)
            self.iTid = pfTherapistFileItem.iPFTherapistFileTID

        }
  
        self.sTherapistName = pfTherapistFileItem.sPFTherapistFileName

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return
  
    }   // End of public func updateScheduledPatientLocationItemFromPFTherapistFile(pfTherapistFileItem:PFObject).

    public func updateScheduledPatientLocationItemFromPFPatientFile(pfPatientFileItem:PFObject)
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Parameter 'pfPatientFileItem.ID' is [\(String(describing: pfPatientFileItem.object(forKey:"ID")))]...")

        }

        // Handle the 'update' (setup) of field(s)...

        self.sPatientDOB          = String(describing: (pfPatientFileItem.object(forKey:"DOB") ?? ""))
        self.iPatientPrimaryIns   = Int(String(describing: (pfPatientFileItem.object(forKey:"primaryIns")   ?? "-1"))) ?? -2
        self.iPatientSecondaryIns = Int(String(describing: (pfPatientFileItem.object(forKey:"secondaryIns") ?? "-1"))) ?? -2

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return
  
    }   // End of public func updateScheduledPatientLocationItemFromPFPatientFile(pfPatientFileItem:PFObject).

    public func updateScheduledPatientLocationItemFromPFPatientFile(pfPatientFileItem:ParsePFPatientFileItem)
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Parameter 'pfPatientFileItem.idPFPatientFileObject' is [\(String(describing: pfPatientFileItem.idPFPatientFileObject))]...")

        }

        // Handle the 'update' (setup) of field(s)...

        self.sPatientDOB          = pfPatientFileItem.sPFPatientFileDOB
        self.iPatientPrimaryIns   = pfPatientFileItem.iPFPatientFilePrimaryIns
        self.iPatientSecondaryIns = pfPatientFileItem.iPFPatientFileSecondaryIns

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return
  
    }   // End of public func updateScheduledPatientLocationItemFromPFPatientFile(pfPatientFileItem:PFObject).

    public func updateScheduledPatientLocationItemFromPFPatientCalDay(pfPatientCalDayItem:PFObject)
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
  
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Parameter 'pfPatientCalDayItem.tid' is [\(String(describing: pfPatientCalDayItem.object(forKey:"tid")))]...")

        }

        // Handle the 'update' (setup) of field(s)...

        if (self.sTid.count  < 1 ||
            self.sTid       == "-1")
        {

            self.sTid = String(describing: (pfPatientCalDayItem.object(forKey:"tid") ?? "-1"))
            self.iTid = Int(self.sTid)!

        }
  
        self.sTName  = String(describing: (pfPatientCalDayItem.object(forKey:"tName")  ?? ""))

        self.sPid    = String(describing: (pfPatientCalDayItem.object(forKey:"pid")    ?? "-1"))
        self.iPid    = Int(self.sPid)!
        self.sPtName = String(describing: (pfPatientCalDayItem.object(forKey:"ptName") ?? ""))

        self.sVDate  = String(describing: (pfPatientCalDayItem.object(forKey:"VDate")  ?? ""))

        // Pull and 'clean' the 'startTime' value...

        let sVDateStartTimeBase:String = String(describing: (pfPatientCalDayItem.object(forKey:"startTime") ?? ""))

        if (sVDateStartTimeBase.count < 1)
        {

            self.sVDateStartTime = ""

        }
        else
        {

        //  let listVDateStartTimeBase:[String]  = sVDateStartTimeBase.components(separatedBy:CharacterSet.illegalCharacters)
        //  let sVDateStartTimeBaseJoined:String = listVDateStartTimeBase.joined(separator:"")
        //  let listVDateStartTimeNoWS:[String]  = sVDateStartTimeBaseJoined.components(separatedBy:CharacterSet.whitespacesAndNewlines)
        //  let sVDateStartTimeUppercased:String = listVDateStartTimeNoWS.joined(separator:"")
        //
        //  self.sVDateStartTime = sVDateStartTimeUppercased.lowercased()

            self.sVDateStartTime = sVDateStartTimeBase.removeUnwantedCharacters(charsetToRemove:[StringCleaning.removeIllegal, StringCleaning.removeWhitespacesAndNewlines], bResultIsLowerCased:true)

            self.xcgLogMsg("\(sCurrMethodDisp) Cleaning - 'self.sVDateStartTime' is [\(self.sVDateStartTime)] <no illegal, no WS, lowercased>...")

        }

        // Convert the VDate 'startTime' from 12-hour to 24-hour (String and Int <for Sort>)...

        if (self.sVDateStartTime.count < 1)
        {

            self.sVDateStartTime24h = ""
            self.iVDateStartTime24h = 0

        }
        else
        {

            (self.sVDateStartTime24h, self.iVDateStartTime24h) = self.convertVDateStartTimeTo24Hour(sVDateStartTime:self.sVDateStartTime)

            self.xcgLogMsg("\(sCurrMethodDisp) Cleaning - 'self.sVDateStartTime24h' is [\(self.sVDateStartTime24h)] - 'self.iVDateStartTime24h' is (\(self.iVDateStartTime24h))...")

        }
  
        // Test this item for Visit occurance...

        self.testScheduledPatientLocationItemForVisitOccurance()

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return
  
    }   // End of public func updateScheduledPatientLocationItemFromPFPatientCalDay(pfPatientCalDayItem:PFObject).

    public func updateScheduledPatientLocationItemFromPFBackupVisit(pfBackupVisit:PFObject)
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
  
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Parameter 'pfBackupVisit.VDate' is [\(String(describing: pfBackupVisit.object(forKey:"VDate")))] <for 'tid' of [\(String(describing: pfBackupVisit.object(forKey:"tid")))]>...")

        }

        // Handle the 'update' (setup) of field(s)...
  
        self.sLastVDate          = String(describing: (pfBackupVisit.object(forKey:"VDate")   ?? ""))
        self.sLastVDateType      = String(describing: (pfBackupVisit.object(forKey:"type")    ?? "-1"))
        self.iLastVDateType      = Int(self.sLastVDateType)!
        self.sLastVDateAddress   = String(describing: (pfBackupVisit.object(forKey:"address") ?? ""))
        self.sLastVDateLatitude  = String(describing: (pfBackupVisit.object(forKey:"lat")     ?? ""))
        self.sLastVDateLongitude = String(describing: (pfBackupVisit.object(forKey:"long")    ?? ""))

        // Test this item for Visit occurance...

        self.testScheduledPatientLocationItemForVisitOccurance()

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return
  
    }   // End of public func updateScheduledPatientLocationItemFromPFBackupVisit(pfBackupVisit:PFObject).

    public func updateScheduledPatientLocationItemFromPFBackupVisitItem(pfBackupFileItem:ParsePFBackupFileItem)
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
  
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Parameter 'pfBackupFileItem.VDate' is [\(String(describing: pfBackupFileItem.sLastVDate))] <for 'tid' of [\(String(describing: pfBackupFileItem.sTid))]>...")

        }

        // Handle the 'update' (setup) of field(s)...
  
        self.sLastVDate          = pfBackupFileItem.sLastVDate         
        self.sLastVDateType      = pfBackupFileItem.sLastVDateType     
        self.iLastVDateType      = pfBackupFileItem.iLastVDateType     
        self.sLastVDateAddress   = pfBackupFileItem.sLastVDateAddress  
        self.sLastVDateLatitude  = pfBackupFileItem.sLastVDateLatitude 
        self.sLastVDateLongitude = pfBackupFileItem.sLastVDateLongitude

        // Test this item for Visit occurance...

        self.testScheduledPatientLocationItemForVisitOccurance()

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return
  
    }   // End of public func updateScheduledPatientLocationItemFromPFBackupVisitItem(pfBackupFileItem:ParsePFBackupFileItem).

    public func convertVDateStartTimeTo24Hour(sVDateStartTime:String)->(String, Int)
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'sVDateStartTime' is [\(sVDateStartTime)]...")

        // Convert the VDate 'startTime' from 12-hour to 24-hour time...

        var sVDateStartTime24h:String = ""
        var iVDateStartTime24h:Int    = 0
        
        if (sVDateStartTime.count < 1)
        {

            // Exit:

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'sVDateStartTime24h' is [\(sVDateStartTime24h)] - 'iVDateStartTime24h' is [\(iVDateStartTime24h)]...")

            return (sVDateStartTime24h, iVDateStartTime24h)
            
        }
        
        var bVDateStartTimeIsPM:Bool = false

        if sVDateStartTime.hasSuffix("pm")
        {
            
            bVDateStartTimeIsPM = true
            
        }
        else
        {
            
            bVDateStartTimeIsPM = false
            
        }

        var csStartTimeDelimiters:CharacterSet = CharacterSet()

        csStartTimeDelimiters.insert(charactersIn:":amp")

        let listVDateStartTime:[String] = sVDateStartTime.components(separatedBy:csStartTimeDelimiters)
        let sVDateStartTimeHH:String    = listVDateStartTime[0]
        let sVDateStartTimeMM:String    = listVDateStartTime[1]
        var iVDateStartTimeHH:Int       = Int(sVDateStartTimeHH) ?? 0

        if (bVDateStartTimeIsPM == true &&
            iVDateStartTimeHH   != 12)
        {

            iVDateStartTimeHH += 12
            
        }

        sVDateStartTime24h = "\(iVDateStartTimeHH):\(sVDateStartTimeMM)"
        iVDateStartTime24h = Int("\(iVDateStartTimeHH)\(sVDateStartTimeMM)") ?? 0

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'sVDateStartTime24h' is [\(sVDateStartTime24h)] - 'iVDateStartTime24h' is (\(iVDateStartTime24h))...")

        return (sVDateStartTime24h, iVDateStartTime24h)

    }   // End of convertVDateStartTimeTo24Hour(sVDateStartTime:String)->(String, Int).
    
    public func isVDateInPast(sVDate:String)->Bool
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'sVDate' is [\(sVDate)]...")

        // Convert the VDate string into a Date and compare with 'today'...

        var bIsVDateInPast:Bool = false

        if (sVDate.count < 1)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) Parameter 'sVDate' of [\(sVDate)] is an 'empty' string - Error!")

            // Exit:

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'bIsVDateInPast' is [\(bIsVDateInPast)]...")

            return bIsVDateInPast
        
        }

        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat        = "yyyy-MM-dd"

        guard let dateVDate:Date = dateFormatter.date(from:sVDate)
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Parameter 'sVDate' of [\(sVDate)] is an 'invalid' format - Error!")

            // Exit:

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'bIsVDateInPast' is [\(bIsVDateInPast)]...")

            return bIsVDateInPast

        }

        let bIsVDateToday:Bool = Calendar.current.isDateInToday(dateVDate)

        if (bIsVDateToday == true)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) Parameter 'sVDate' of [\(sVDate)] is 'today'...")

            // Exit:

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'bIsVDateInPast' is [\(bIsVDateInPast)]...")

            return bIsVDateInPast
        
        }

        let dateToday:Date = Date()

        bIsVDateInPast = (dateToday > dateVDate)

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'bIsVDateInPast' is [\(bIsVDateInPast)]...")

        return bIsVDateInPast

    }   // End of isVDateInPast(sVDate:String)->Bool.
    
    public func isVDateToday(sVDate:String)->Bool
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'sVDate' is [\(sVDate)]...")

        // Convert the VDate string into a Date and compare with the calendar...

        var bIsVDateToday:Bool = false

        if (sVDate.count < 1)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) Parameter 'sVDate' of [\(sVDate)] is an 'empty' string - Error!")

            // Exit:

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'bIsVDateToday' is [\(bIsVDateToday)]...")

            return bIsVDateToday
        
        }

        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat        = "yyyy-MM-dd"

        guard let dateVDate:Date = dateFormatter.date(from:sVDate)
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Parameter 'sVDate' of [\(sVDate)] is an 'invalid' format - Error!")

            // Exit:

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'bIsVDateToday' is [\(bIsVDateToday)]...")

            return bIsVDateToday

        }

        bIsVDateToday = Calendar.current.isDateInToday(dateVDate)

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'bIsVDateToday' is [\(bIsVDateToday)]...")

        return bIsVDateToday

    }   // End of isVDateToday(sVDate:String)->Bool.
    
    public func testScheduledPatientLocationItemForVisitOccurance()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
  
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'self' is [\(self.toString())]...")

        // Test this item for Visit occurance...

        // --------------------------------------------------------------------------------------------------
        //  case undefined = "Undefined" -> Color.primary
        //  case pastdate  = "PastDate"  -> Color.yellow
        //  case scheduled = "Scheduled" -> Color.orange
        //  case done      = "Done"      -> Color.green
        //  case dateError = "DateError" -> Color.purple
        //  case missed    = "Missed"    -> Color.red
        // --------------------------------------------------------------------------------------------------

        // Determine some settings about the Dates and their values...

        let bIsVDateAvailable:Bool          = (self.sVDate.count     > 0)
        let bIsLastVDateAvailable:Bool      = (self.sLastVDate.count > 0)
        let bBothVDatesAreNotAvailable:Bool = (bIsVDateAvailable == false && bIsLastVDateAvailable == false)
        let bBothVDatesAreAvailable:Bool    = (bIsVDateAvailable == true  && bIsLastVDateAvailable == true)
        let bDoBothVDatesMatch:Bool         = (bBothVDatesAreAvailable == true && self.sVDate == self.sLastVDate)

        if (self.bInternalTraceFlag == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) <Visit-Occurance> 'sVDate' of [\(String(describing: self.sVDate))] matched to 'sLastVDate' of [\(String(describing: self.sLastVDate))]...")
            self.xcgLogMsg("\(sCurrMethodDisp) <Visit-Occurance> 'bIsVDateAvailable' is [\(bIsVDateAvailable)]...")
            self.xcgLogMsg("\(sCurrMethodDisp) <Visit-Occurance> 'bIsLastVDateAvailable' is [\(bIsLastVDateAvailable)]...")
            self.xcgLogMsg("\(sCurrMethodDisp) <Visit-Occurance> 'bBothVDatesAreNotAvailable' is [\(bBothVDatesAreNotAvailable)]...")
            self.xcgLogMsg("\(sCurrMethodDisp) <Visit-Occurance> 'bBothVDatesAreAvailable' is [\(bBothVDatesAreAvailable)]...")
            self.xcgLogMsg("\(sCurrMethodDisp) <Visit-Occurance> 'bDoBothVDatesMatch' is [\(bDoBothVDatesMatch)]...")

        }

        // If there is NO 'sVDate', then we have NO data to compare...

        if (bIsVDateAvailable == false)
        {
        
            self.scheduleType = ScheduleType.undefined
            self.colorOfItem  = Color.primary
            
            self.xcgLogMsg("\(sCurrMethodDisp) <Visit-Occurance> 'sVDate' of [\(String(describing: self.sVDate))] - Nothing to compare - type values set to defaults - 'self.scheduleType' is [\(self.scheduleType)] - 'self.colorOfItem' is [\(self.colorOfItem)]...")
        
            // Exit:

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return

        }

        // If BOTH the 'sVDate' and 'sLastVDate' strings are empty, then we have NO data to compare...

        if (bBothVDatesAreNotAvailable == true)
        {
        
            self.scheduleType = ScheduleType.undefined
            self.colorOfItem  = Color.primary
            
            self.xcgLogMsg("\(sCurrMethodDisp) <Visit-Occurance> 'sVDate' of [\(String(describing: self.sVDate))] matched to 'sLastVDate' of [\(String(describing: self.sLastVDate))] - BOTH value(s) are empty strings - type values set to defaults - 'self.scheduleType' is [\(self.scheduleType)] - 'self.colorOfItem' is [\(self.colorOfItem)]...")
        
            // Exit:

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return

        }

        // If we have a 'sVDate' (from 'PFCalDay') <scheduled visit> 
        // AND a 'sLastVDate' (from 'PFBackupVisit') <visit HAS been done>,
        // then check if the Dates match...

        if (bDoBothVDatesMatch == true)
        {

            self.scheduleType = ScheduleType.done
            self.colorOfItem  = Color.green
            
            self.xcgLogMsg("\(sCurrMethodDisp) <Visit-Occurance> 'sVDate' of [\(String(describing: self.sVDate))] matched to 'sLastVDate' of [\(String(describing: self.sLastVDate))] - BOTH value(s) match - visit is 'done' - 'self.scheduleType' is [\(self.scheduleType)] - 'self.colorOfItem' is [\(self.colorOfItem)]...")
        
            // Exit:

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return

        }

        // Calculate if VDate and LastVDate are 'today' or are 'past' dates...

        let bIsVDateToday:Bool      = self.isVDateToday(sVDate:self.sVDate)
        let bIsVDateInPast:Bool     = self.isVDateInPast(sVDate:self.sVDate)
    //  let bIsLastVDateToday:Bool  = self.isVDateToday(sVDate:self.sLastVDate)
        let bIsLastVDateInPast:Bool = self.isVDateInPast(sVDate:self.sLastVDate)

        // Both Dates don't match, but if we have them both then it's 'done' but Date 'error'...

        if (bDoBothVDatesMatch      == false &&
            bBothVDatesAreAvailable == true)
        {

            // If VDate is a 'past' date...

            if (bIsVDateInPast == true)
            {

                self.scheduleType = ScheduleType.pastdate
                self.colorOfItem  = Color.yellow

                self.xcgLogMsg("\(sCurrMethodDisp) <Visit-Occurance> 'sVDate' of [\(String(describing: self.sVDate))] is a 'past' Date - 'self.scheduleType' is [\(self.scheduleType)] - 'self.colorOfItem' is [\(self.colorOfItem)]...")

                // Exit:

                self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

                return

            }

            // If VDate is NOT 'today' and NOT a 'past' Date, then it's a future date so leave it as 'scheduled'...

            if (bIsVDateInPast == false &&
                bIsVDateToday  == false)
            {

                self.scheduleType = ScheduleType.scheduled
                self.colorOfItem  = Color.orange

                self.xcgLogMsg("\(sCurrMethodDisp) <Visit-Occurance> 'sVDate' of [\(String(describing: self.sVDate))] is NOt 'today' and is NOT a 'past' Date - setting as 'scheduled' <upcoming> - 'self.scheduleType' is [\(self.scheduleType)] - 'self.colorOfItem' is [\(self.colorOfItem)]...")

                // Exit:

                self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

                return

            }

            // If VDate is 'today' and LastVDate is a 'past' date...

            if (bIsVDateToday      == true &&
                bIsLastVDateInPast == true)
            {

            //  self.scheduleType = ScheduleType.scheduled
            //  self.colorOfItem  = Color.orange
              
                self.xcgLogMsg("\(sCurrMethodDisp) <Visit-Occurance> 'sVDate' of [\(String(describing: self.sVDate))] is 'today' but 'sLastVDate' of [\(String(describing: self.sLastVDate))] is a 'past' Date - moving to next check for Time of the visit...")
            //  self.xcgLogMsg("\(sCurrMethodDisp) <Visit-Occurance> 'sVDate' of [\(String(describing: self.sVDate))] is 'today' but 'sLastVDate' of [\(String(describing: self.sLastVDate))] is a 'past' Date - setting as 'scheduled' <upcoming> - 'self.scheduleType' is [\(self.scheduleType)] - 'self.colorOfItem' is [\(self.colorOfItem)]...")
            //
            //  // Exit:
            //
            //  self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
            //
            //  return

            }
            else
            {

                self.scheduleType = ScheduleType.dateError
                self.colorOfItem  = Color.purple

                self.xcgLogMsg("\(sCurrMethodDisp) <Visit-Occurance> 'sVDate' of [\(String(describing: self.sVDate))] matched to 'sLastVDate' of [\(String(describing: self.sLastVDate))] - BOTH value(s) are available but the Dates do NOT match - visit is 'done' but with Date 'error' - 'self.scheduleType' is [\(self.scheduleType)] - 'self.colorOfItem' is [\(self.colorOfItem)]...")

                // Exit:

                self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

                return

            }

        }

        // If VDate is a 'past' date...

        if (bIsVDateInPast == true)
        {

            self.scheduleType = ScheduleType.pastdate
            self.colorOfItem  = Color.yellow
            
            self.xcgLogMsg("\(sCurrMethodDisp) <Visit-Occurance> 'sVDate' of [\(String(describing: self.sVDate))] is a 'past' Date - 'self.scheduleType' is [\(self.scheduleType)] - 'self.colorOfItem' is [\(self.colorOfItem)]...")
        
            // Exit:

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return

        }

        // If VDate is NOT 'today' (and it's NOT a 'past' Date), then simply mark it 'scheduled'...

        if (bIsVDateToday == false)
        {

            self.scheduleType = ScheduleType.scheduled
            self.colorOfItem  = Color.orange
            
            self.xcgLogMsg("\(sCurrMethodDisp) <Visit-Occurance> 'sVDate' of [\(String(describing: self.sVDate))] is NOT a 'past' Date but NOT 'today' - leaving as 'scheduled' - 'self.scheduleType' is [\(self.scheduleType)] - 'self.colorOfItem' is [\(self.colorOfItem)]...")
        
            // Exit:

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return

        }

        // VDate is 'today', now check the scheduled time to make sure we have a 'time' to work with...

        if (self.sVDateStartTime24h.count < 1)
        {
        
            self.scheduleType = ScheduleType.scheduled
            self.colorOfItem  = Color.orange
            
            self.xcgLogMsg("\(sCurrMethodDisp) <Visit-Occurance> 'sVDate' of [\(String(describing: self.sVDate))] 'today' but 'self.sVDateStartTime24h' is an 'empty string - leaving as a 'scheduled' viait - 'self.scheduleType' is [\(self.scheduleType)] - 'self.colorOfItem' is [\(self.colorOfItem)] - Error!")
        
            // Exit:

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return
        
        }

        // VDate is 'today', now check the scheduled time vs current time 
        // to determine if it's still to happen or a missed visit...

        let sVDateTime:String           = "\(self.sVDate) \(self.sVDateStartTime24h)"

        self.xcgLogMsg("\(sCurrMethodDisp) <Visit-Occurance> 'sVDateTime' is [\(String(describing: sVDateTime))]...")

        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat        = "yyyy-MM-dd HH:mm"

        guard let dateVDateTime:Date = dateFormatter.date(from:sVDateTime)
        else
        {

            self.scheduleType = ScheduleType.scheduled
            self.colorOfItem  = Color.orange

            self.xcgLogMsg("\(sCurrMethodDisp) <Visit-Occurance> 'sVDateTime' of [\(String(describing: sVDateTime))] is an 'invalid' format - leaving as a 'scheduled' viait - 'self.scheduleType' is [\(self.scheduleType)] - 'self.colorOfItem' is [\(self.colorOfItem)] - Error!")

            // Exit:

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return

        }

        let dateVDateTimePlus1Hour:Date = Calendar.current.date(byAdding:.hour, value:1, to:dateVDateTime)!
        let dateTodayNow:Date           = Date()

        if (dateVDateTimePlus1Hour < dateTodayNow)
        {

            self.scheduleType = ScheduleType.missed
            self.colorOfItem  = Color.red

            self.xcgLogMsg("\(sCurrMethodDisp) <Visit-Occurance> 'dateVDateTimePlus1Hour' of [\(String(describing: dateVDateTimePlus1Hour))] is less than 'dateTodayNow' of [\(String(describing: dateTodayNow))] - setting this as a 'missed' viait - 'self.scheduleType' is [\(self.scheduleType)] - 'self.colorOfItem' is [\(self.colorOfItem)] - Error!")
        
        }
        else
        {

            self.scheduleType = ScheduleType.scheduled
            self.colorOfItem  = Color.orange

            self.xcgLogMsg("\(sCurrMethodDisp) <Visit-Occurance> 'dateVDateTimePlus1Hour' of [\(String(describing: dateVDateTimePlus1Hour))] is NOT less than 'dateTodayNow' of [\(String(describing: dateTodayNow))] - leaving this as a 'scheduled' viait - 'self.scheduleType' is [\(self.scheduleType)] - 'self.colorOfItem' is [\(self.colorOfItem)] - Error!")
        
        }

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return
  
    }   // End of public func testScheduledPatientLocationItemForVisitOccurance().

}   // End of class ScheduledPatientLocationItem(NSObject, Identifiable).

