//
//  AlarmSwiftDataItem.swift
//  JustAFirstSwiftDataApp1
//
//  Created by Daryl Cox on 12/05/2024.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
import SwiftData

@Model
//NOTE: Do NOT Subclass in this Class - @Model will throw an error about using 'self' before 'super.init()'...
//class AlarmSwiftDataItem: NSObject, Identifiable
public class AlarmSwiftDataItem: Identifiable
{
    
    @Transient
    struct ClassInfo
    {
        
        static let sClsId        = "AlarmSwiftDataItem"
        static let sClsVers      = "v1.1102"
        static let sClsDisp      = sClsId+"(.swift).("+sClsVers+"):"
        static let sClsCopyRight = "Copyright (C) JustMacApps 2023-2025. All Rights Reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }

    @Attribute(.unique) public
    var id:UUID                                   = UUID()
    var sAlarmUUID:String                         = ""

    var dateAlarmCreated:Date                     = Date()
    var dateAlarmUpdated:Date                     = Date()
    var dateAlarmSetFor:Date                      = Date()
    var dateAlarmFires:Date                       = Date()

    var bIsAlarmEnabled:Bool                      = false
    var bIsAlarmSnoozeEnabled:Bool                = false
    var iAlarmSnoozeInterval:Int                  = 9         // Snooze interval: minutes...
    var bIsAlarmRepeatsEnabled:Bool               = false
    var listRepeatOnWeekdays:[Int]                = []

    var idMedia:UUID?                             = nil
    var sMediaRingTone:String                     = "bell"    // Values: 'bell' or 'tickle'...
    var sMediaAlarmTitle:String                   = "Alarm"
    var sMediaAlarmMessage:String                 = "Wake UP!"

    @Transient
    var jmAppDelegateVisitor:JmAppDelegateVisitor = JmAppDelegateVisitor.ClassSingleton.appDelegateVisitor
                                                    // NOTE: The AppDelegateVisitor MUST be wrapped with @Transient
                                                    //       or the compiler will fail this as referencing 'self'
                                                    //       before the 'super.init()' has been invoked...

    init()
    {
        
        self.id                     = UUID()
        self.sAlarmUUID             = self.id.uuidString

        self.dateAlarmCreated       = Date()
        self.dateAlarmUpdated       = Date()
        self.dateAlarmSetFor        = Date()
        self.dateAlarmFires         = Date()

        self.bIsAlarmEnabled        = false
        self.bIsAlarmSnoozeEnabled  = false
        self.iAlarmSnoozeInterval   = 9
        self.bIsAlarmRepeatsEnabled = false
        self.listRepeatOnWeekdays   = []

        self.idMedia                = nil
        self.sMediaRingTone         = "tickle"      // Values: 'bell' or 'tickle'...
        self.sMediaAlarmTitle       = "Alarm"
        self.sMediaAlarmMessage     = "Wake UP!"

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
        asToString.append("'id': [\(String(describing: self.id))],")
        asToString.append("'sAlarmUUID': [\(String(describing: self.sAlarmUUID))],")
        asToString.append("'dateAlarmCreated': [\(String(describing: self.dateAlarmCreated))],")
        asToString.append("'dateAlarmUpdated': [\(String(describing: self.dateAlarmUpdated))],")
        asToString.append("'dateAlarmSetFor': [\(String(describing: self.dateAlarmSetFor))],")
        asToString.append("'dateAlarmFires': [\(String(describing: self.dateAlarmFires))],")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'bIsAlarmEnabled': [\(String(describing: self.bIsAlarmEnabled))],")
        asToString.append("'bIsAlarmSnoozeEnabled': [\(String(describing: self.bIsAlarmSnoozeEnabled))],")
        asToString.append("'iAlarmSnoozeInterval': (\(String(describing: self.iAlarmSnoozeInterval))),")
        asToString.append("'bIsAlarmRepeatsEnabled': [\(String(describing: self.bIsAlarmRepeatsEnabled))],")
        asToString.append("'listRepeatOnWeekdays': [\(String(describing: self.listRepeatOnWeekdays))],")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'idMedia': [\(String(describing: self.idMedia))],")
        asToString.append("'sMediaRingTone': [\(String(describing: self.sMediaRingTone))],")
        asToString.append("'sMediaAlarmTitle': [\(String(describing: self.sMediaAlarmTitle))],")
        asToString.append("'sMediaAlarmMessage': [\(String(describing: self.sMediaAlarmMessage))],")
        asToString.append("],")
        asToString.append("]")

        let sContents:String = "{"+(asToString.joined(separator: ""))+"}"

        return sContents

    }   // End of public func toString().

    public func updateAlarmSwiftDataItemFromAnother(alarmSwiftDataItem:AlarmSwiftDataItem, bCopyAlarmID:Bool = false)
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
      
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'alarmSwiftDataItem' is [\(alarmSwiftDataItem.toString())] - 'bCopyAlarmID' is [\(bCopyAlarmID)]...")
      
        // Update the various field(s) of this object from another 'supplied' object...
      
        if (bCopyAlarmID == true)
        {
      
            self.id                 = alarmSwiftDataItem.id                    
      
        }
      
        self.sAlarmUUID             = self.id.uuidString
                                                                 
        self.dateAlarmCreated       = alarmSwiftDataItem.dateAlarmCreated      
        self.dateAlarmUpdated       = alarmSwiftDataItem.dateAlarmUpdated   
        self.dateAlarmSetFor        = alarmSwiftDataItem.dateAlarmSetFor        
        self.dateAlarmFires         = alarmSwiftDataItem.dateAlarmFires        
                                                                 
        self.bIsAlarmEnabled        = alarmSwiftDataItem.bIsAlarmEnabled       
        self.bIsAlarmSnoozeEnabled  = alarmSwiftDataItem.bIsAlarmSnoozeEnabled 
        self.iAlarmSnoozeInterval   = alarmSwiftDataItem.iAlarmSnoozeInterval 
        self.bIsAlarmRepeatsEnabled = alarmSwiftDataItem.bIsAlarmRepeatsEnabled
        self.listRepeatOnWeekdays   = alarmSwiftDataItem.listRepeatOnWeekdays  
                                                                 
        self.idMedia                = alarmSwiftDataItem.idMedia              
        self.sMediaRingTone         = alarmSwiftDataItem.sMediaRingTone        
        self.sMediaAlarmTitle       = alarmSwiftDataItem.sMediaAlarmTitle      
        self.sMediaAlarmMessage     = alarmSwiftDataItem.sMediaAlarmMessage    
      
        // Exit:
      
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'self' is [\(self.toString())] - 'bCopyAlarmID' was [\(bCopyAlarmID)]...")

        return

    }   // End of public func updateAlarmSwiftDataItemFromAnother(alarmSwiftDataItem:AlarmSwiftDataItem, bCopyAlarmID:Bool).

    public func getAlarmSwiftDataItemShortTitle()->String
    {

    //  let sCurrMethod:String = #function
    //  let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
    //
    //  self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Generate a 'short' AlarmSwiftDataItem 'title'...

        var sAlarmShortTitle:String       = "..."
        let dtFormatterDate:DateFormatter = DateFormatter()
        let dtFormatterTime:DateFormatter = DateFormatter()

        dtFormatterDate.locale            = Locale(identifier: "en_US")
        dtFormatterDate.timeZone          = TimeZone.current
    //  dtFormatterDate.dateFormat        = "yyyy-MM-dd"
    //  dtFormatterDate.dateFormat        = "MM/dd/yyyy"
        dtFormatterDate.dateFormat        = "MM/dd/yy"

        dtFormatterTime.locale            = Locale(identifier: "en_US")
        dtFormatterTime.timeZone          = TimeZone.current
    //  dtFormatterTime.dateFormat        = "hh:mm:ss a"
        dtFormatterTime.dateFormat        = "hh:mm a"

        let sDateAlarmFiresBaseD:String   = dtFormatterDate.string(from: self.dateAlarmFires)
        let sDateAlarmFiresBaseT:String   = dtFormatterTime.string(from: self.dateAlarmFires)

        if (sDateAlarmFiresBaseD.count < 1)
        {

            sAlarmShortTitle = "-undefined-"

        }
        else
        {

        //  let listDateAlarmFiresNoWS:[String]  = sDateAlarmFiresBaseT.components(separatedBy:CharacterSet.whitespacesAndNewlines)
        //  let sDateAlarmFiresUppercased:String = listDateAlarmFiresNoWS.joined(separator:"")
        //  let sDateAlarmFiresLowercased:String = sDateAlarmFiresUppercased.lowercased()

            let sDateAlarmFiresLowercased:String = sDateAlarmFiresBaseT.removeUnwantedCharacters(charsetToRemove:[StringCleaning.removeWhitespacesAndNewlines], bResultIsLowerCased:true)

            sAlarmShortTitle = "\(sDateAlarmFiresBaseD) @ \(sDateAlarmFiresLowercased)"

        }

        // Exit:

    //  self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'sAlarmShortTitle' is [\(sAlarmShortTitle)]...")

        return sAlarmShortTitle

    }   // End of public func getAlarmSwiftDataItemShortTitle()->String.
    
    public func getAlarmSwiftDataItemLongTitle()->String
    {

    //  let sCurrMethod:String = #function
    //  let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
    //
    //  self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Generate a 'long' AlarmSwiftDataItem 'title'...

    //  let sAlarmLongTitle:String = "\(self.sMediaAlarmTitle)::[\(self.getAlarmSwiftDataItemShortTitle())]::[\(self.sMediaAlarmMessage)]"
        let sAlarmLongTitle:String = "<\(self.getAlarmSwiftDataItemShortTitle())>::[\(self.sMediaAlarmTitle)::\(self.sMediaAlarmMessage)]"

        // Exit:

    //  self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'sAlarmLongTitle' is [\(sAlarmLongTitle)]...")

        return sAlarmLongTitle

    }   // End of public func getAlarmSwiftDataItemLongTitle()->String.
    
    public func displayAlarmSwiftDataItemWithLocalStore(bShowLocalStore:Bool=false)
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Display the various field(s) of this object...

        self.xcgLogMsg("\(sCurrMethodDisp) 'id'                     is [\(String(describing: self.id))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sAlarmUUID'             is [\(String(describing: self.sAlarmUUID))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'dateAlarmCreated'       is [\(String(describing: self.dateAlarmCreated))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'dateAlarmUpdated'       is [\(String(describing: self.dateAlarmUpdated))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'dateAlarmSetFor'        is [\(String(describing: self.dateAlarmSetFor))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'dateAlarmFires'         is [\(String(describing: self.dateAlarmFires))]...")

        self.xcgLogMsg("\(sCurrMethodDisp) 'bIsAlarmEnabled'        is [\(String(describing: self.bIsAlarmEnabled))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'bIsAlarmSnoozeEnabled'  is [\(String(describing: self.bIsAlarmSnoozeEnabled))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'iAlarmSnoozeInterval'   is (\(String(describing: self.iAlarmSnoozeInterval)))...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'bIsAlarmRepeatsEnabled' is [\(String(describing: self.bIsAlarmRepeatsEnabled))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'listRepeatOnWeekdays'   is [\(String(describing: self.listRepeatOnWeekdays))]...")

        self.xcgLogMsg("\(sCurrMethodDisp) 'idMedia'                is [\(String(describing: self.idMedia))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sMediaRingTone'         is [\(String(describing: self.sMediaRingTone))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sMediaAlarmTitle'       is [\(String(describing: self.sMediaAlarmTitle))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) 'sMediaAlarmMessage'     is [\(String(describing: self.sMediaAlarmMessage))]...")
        
        // (Optionally) Display the location of the SwiftData 'local' store...

        if (bShowLocalStore == true)
        {

            let urlApp:URL?         = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).last
            let urlDefaultStore:URL = urlApp!.appendingPathComponent("default.store")

            if FileManager.default.fileExists(atPath:urlDefaultStore.path)
            {

                self.xcgLogMsg("\(sCurrMethodDisp) SwiftData 'local' DB is at [\(urlDefaultStore.absoluteString)]...")

            }

        }

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of public func displayAlarmSwiftDataItemWithLocalStore(bShowLocalStore:Bool).
    
}   // End of class AlarmSwiftDataItem(NSObject, Identifiable).
