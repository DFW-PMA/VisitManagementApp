//
//  AppScheduleLoadingAssistant.swift
//  VisitManagementApp
//
//  Created by JustMacApps.net on 02/14/2025.
//  Copyright © 2023-2025 JustMacApps. All rights reserved.
//

import Foundation
import SwiftUI

//public class AppScheduleLoadingAssistant: NSObject, ObservableObject
public class AppScheduleLoadingAssistant: NSObject
{
    
    struct ClassInfo
    {
        
        static let sClsId          = "AppScheduleLoadingAssistant"
        static let sClsVers        = "v1.0501"
        static let sClsDisp        = sClsId+"(.swift).("+sClsVers+"):"
        static let sClsCopyRight   = "Copyright (C) JustMacApps 2023-2025. All Rights Reserved."
        static let bClsTrace       = true
        static let bClsFileLog     = true
        
    }

    struct ClassSingleton
    {
        static 
        var appScheduleLoadingAssistant:AppScheduleLoadingAssistant           = AppScheduleLoadingAssistant()
    }

    // 'Internal' Trace flag:

    private 
    var bInternalTraceFlag:Bool                                               = false

    // App Data field(s):

                    var bScheduledPatientLocationItemsAreAvaiable:Bool        = false

                    var sScheduledPatientLocationItemsTID:String              = ""

                    var listScheduledPatientLocationItems:[ScheduledPatientLocationItem]
                                                                              = [ScheduledPatientLocationItem]()

                    var dictOfSortedSchedPatientLocItems:[String:[ScheduledPatientLocationItem]]
                                                                              = [String:[ScheduledPatientLocationItem]]()

                    var cTotalScheduledPatientVisits:Int                      = 0
                    var cTotalTidsOnWorkRoute:Int                             = 0
                    var cTotalTidsOnWorkRouteToday:Int                        = 0

                    var jmAppDelegateVisitor:JmAppDelegateVisitor             = JmAppDelegateVisitor.ClassSingleton.appDelegateVisitor
                    var jmAppParseCoreManager:JmAppParseCoreManager           = JmAppParseCoreManager.ClassSingleton.appParseCodeManager
                    var jmAppParseCoreBkgdDataRepo:JmAppParseCoreBkgdDataRepo = JmAppParseCoreBkgdDataRepo.ClassSingleton.appParseCodeBkgdDataRepo

    private override init()
    {

    //  let sCurrMethod:String = #function
    //  let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        super.init()

    //  self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Exit...

    //  self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of private override init().

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
        asToString.append("'bScheduledPatientLocationItemsAreAvaiable': [\(String(describing: self.bScheduledPatientLocationItemsAreAvaiable))],")
        asToString.append("'sScheduledPatientLocationItemsTID': [\(String(describing: self.sScheduledPatientLocationItemsTID))],")
    //  asToString.append("'listScheduledPatientLocationItems': [\(String(describing: self.listScheduledPatientLocationItems))],")
        asToString.append("'listScheduledPatientLocationItems.count': (\(String(describing: self.listScheduledPatientLocationItems.count))),")
        asToString.append("],")
        asToString.append("[")
    //  asToString.append("'dictOfSortedSchedPatientLocItems': [\(String(describing: self.dictOfSortedSchedPatientLocItems))],")
        asToString.append("'dictOfSortedSchedPatientLocItems.count': (\(String(describing: self.dictOfSortedSchedPatientLocItems.count))),")
        asToString.append("'cTotalScheduledPatientVisits': (\(String(describing: self.cTotalScheduledPatientVisits))),")
        asToString.append("'cTotalTidsOnWorkRoute': (\(String(describing: self.cTotalTidsOnWorkRoute))),")
        asToString.append("'cTotalTidsOnWorkRouteToday': (\(String(describing: self.cTotalTidsOnWorkRouteToday))),")
        asToString.append("],")
        asToString.append("]")

        let sContents:String = "{"+(asToString.joined(separator: ""))+"}"

        return sContents

    }   // End of public func toString().

    public func clearScheduledPatientLocationItems()
    {
  
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Clear the ScheduledPatientLocationItems field(s)...

        self.bScheduledPatientLocationItemsAreAvaiable = false
        self.sScheduledPatientLocationItemsTID         = ""
        self.listScheduledPatientLocationItems         = [ScheduledPatientLocationItem]()
        
        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'self.bScheduledPatientLocationItemsAreAvaiable' is [\(self.bScheduledPatientLocationItemsAreAvaiable)] - 'self.sScheduledPatientLocationItemsTID' is [\(self.sScheduledPatientLocationItemsTID)] - 'self.listScheduledPatientLocationItems' has #(\(self.listScheduledPatientLocationItems.count)) item(s)...")
  
        return
  
    }   // End of public func clearScheduledPatientLocationItems().

    func getScheduledPatientLocationItemsForTid(sPFTherapistTID:String = "")->[ScheduledPatientLocationItem]
    {
  
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'sPFTherapistTID' is [\(sPFTherapistTID)]...")

        // If we have ScheduledPatientLocation item(s) and the TIDs match, then just return...

        if (self.listScheduledPatientLocationItems.count  > 0 &&
            self.sScheduledPatientLocationItemsTID       == sPFTherapistTID)
        {
        
            self.bScheduledPatientLocationItemsAreAvaiable = true

            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'self.bScheduledPatientLocationItemsAreAvaiable' is [\(self.bScheduledPatientLocationItemsAreAvaiable)] - 'self.sScheduledPatientLocationItemsTID' is [\(self.sScheduledPatientLocationItemsTID)] - 'self.listScheduledPatientLocationItems' has #(\(self.listScheduledPatientLocationItems.count)) item(s)...")

            return self.listScheduledPatientLocationItems

        }

        // Use the TherapistTID to lookup any ScheduledPatientLocationItem(s)...

        self.sScheduledPatientLocationItemsTID = ""
        self.listScheduledPatientLocationItems = [ScheduledPatientLocationItem]()

        if (sPFTherapistTID.count > 0)
        {

            if (self.jmAppParseCoreManager.dictSchedPatientLocItems.count > 0)
            {

                self.listScheduledPatientLocationItems = self.jmAppParseCoreManager.dictSchedPatientLocItems[sPFTherapistTID] ?? []

            }

        }

        if (self.listScheduledPatientLocationItems.count > 0)
        {
        
            self.sScheduledPatientLocationItemsTID         = sPFTherapistTID
            self.bScheduledPatientLocationItemsAreAvaiable = true
        
        }
        else
        {
        
            self.sScheduledPatientLocationItemsTID         = ""
            self.bScheduledPatientLocationItemsAreAvaiable = false
        
        }
        
        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'self.bScheduledPatientLocationItemsAreAvaiable' is [\(self.bScheduledPatientLocationItemsAreAvaiable)] - 'self.sScheduledPatientLocationItemsTID' is [\(self.sScheduledPatientLocationItemsTID)] - 'self.listScheduledPatientLocationItems' has #(\(self.listScheduledPatientLocationItems.count)) item(s)...")
  
        return self.listScheduledPatientLocationItems
  
    }   // End of func getScheduledPatientLocationItemsForTid(sPFTherapistTID:String = "")->[ScheduledPatientLocationItem].

    func getScheduledPatientLocationItemsForTherapistName(sPFTherapistName:String = "")->[ScheduledPatientLocationItem]
    {
  
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'sPFTherapistName' is [\(sPFTherapistName)]...")

        // If the TherapistName is empty, return an empty list...

        self.sScheduledPatientLocationItemsTID = ""
        self.listScheduledPatientLocationItems = [ScheduledPatientLocationItem]()

        if (sPFTherapistName.count < 1)
        {
        
            self.bScheduledPatientLocationItemsAreAvaiable = false

            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'self.bScheduledPatientLocationItemsAreAvaiable' is [\(self.bScheduledPatientLocationItemsAreAvaiable)] - 'self.sScheduledPatientLocationItemsTID' is [\(self.sScheduledPatientLocationItemsTID)] - 'self.listScheduledPatientLocationItems' has #(\(self.listScheduledPatientLocationItems.count)) item(s)...")

            return self.listScheduledPatientLocationItems
        
        }
        
        // Locate the Therapist TID by 'name'...

        let sTherapistTID:String = self.jmAppParseCoreManager.convertTherapistNameToTid(sPFTherapistParseName:sPFTherapistName)

        if (sTherapistTID.count < 1)
        {
        
            self.bScheduledPatientLocationItemsAreAvaiable = false

            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'self.bScheduledPatientLocationItemsAreAvaiable' is [\(self.bScheduledPatientLocationItemsAreAvaiable)] - 'self.sScheduledPatientLocationItemsTID' is [\(self.sScheduledPatientLocationItemsTID)] - 'self.listScheduledPatientLocationItems' has #(\(self.listScheduledPatientLocationItems.count)) item(s)...")

            return self.listScheduledPatientLocationItems

        }

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting via return 'self.getScheduledPatientLocationItemsForTid(sPFTherapistTID:)'...")
  
        return self.getScheduledPatientLocationItemsForTid(sPFTherapistTID:sTherapistTID)
  
    }   // End of func getScheduledPatientLocationItemsForTherapistName(sPFTherapistName:String = "")->[ScheduledPatientLocationItem]

    public func clearSortedScheduledPatientLocationItems()
    {
  
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Clear the SortedScheduledPatientLocationItems field(s)...

        self.dictOfSortedSchedPatientLocItems = [String:[ScheduledPatientLocationItem]]()
        self.cTotalScheduledPatientVisits     = 0
        self.cTotalTidsOnWorkRoute            = 0
        self.cTotalTidsOnWorkRouteToday       = 0
        
        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'self' is [\(self.toString())]...")
  
        return
  
    }   // End of public func clearSortedScheduledPatientLocationItems().

    func loadSortedScheduledPatientLocationItemsAsTNamesList(dictSchedPatientLocItems:[String:[ScheduledPatientLocationItem]])->[String]
    {
  
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Load the SortedScheduledPatientLocationItems dictionary...

        var listSortedScheduledPatientLocationItemsTNames:[String] = [String]()

        let _ = self.loadSortedScheduledPatientLocationItems(dictSchedPatientLocItems:dictSchedPatientLocItems)

        if (self.dictOfSortedSchedPatientLocItems.count < 1)
        {
        
            // Exit...

            self.countSortedScheduledPatientLocationItems()

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - Nothing to load - 'self.dictOfSortedSchedPatientLocItems' has #(\(self.dictOfSortedSchedPatientLocItems.count)) item(s)...")

            return listSortedScheduledPatientLocationItemsTNames
        
        }

        for (_, listScheduledPatientLocationItems) in self.dictOfSortedSchedPatientLocItems
        {

            listSortedScheduledPatientLocationItemsTNames.append(listScheduledPatientLocationItems[0].sTName)
            
        }

        listSortedScheduledPatientLocationItemsTNames.sort
        { (sTherapistTName1, sTherapistTName2) in

            //  Compare for Sort: '<' sorts 'ascending' and '>' sorts 'descending'...

            return sTherapistTName1 < sTherapistTName2

        }

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'listSortedScheduledPatientLocationItemsTNames' has #(\(listSortedScheduledPatientLocationItemsTNames.count)) item(s)...")
  
        return listSortedScheduledPatientLocationItemsTNames
  
    }   // End of func loadSortedScheduledPatientLocationItemsAsTNamesList(dictSchedPatientLocItems:[String:[ScheduledPatientLocationItem]])->[String].

    func loadSortedScheduledPatientLocationItemsAsTIDList(dictSchedPatientLocItems:[String:[ScheduledPatientLocationItem]])->[String]
    {
  
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Load the SortedScheduledPatientLocationItems dictionary...

        var listSortedScheduledPatientLocationItemsTIDs:[String] = [String]()

        let _ = self.loadSortedScheduledPatientLocationItems(dictSchedPatientLocItems:dictSchedPatientLocItems)

        if (self.dictOfSortedSchedPatientLocItems.count < 1)
        {
        
            // Exit...

            self.countSortedScheduledPatientLocationItems()

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - Nothing to load - 'self.dictOfSortedSchedPatientLocItems' has #(\(self.dictOfSortedSchedPatientLocItems.count)) item(s)...")

            return listSortedScheduledPatientLocationItemsTIDs
        
        }

    //  listSortedScheduledPatientLocationItemsTIDs = self.dictOfSortedSchedPatientLocItems.keys
        
        for (sTherapistTIDKey, _) in self.dictOfSortedSchedPatientLocItems
        {
            
            listSortedScheduledPatientLocationItemsTIDs.append(sTherapistTIDKey)
            
        }

        listSortedScheduledPatientLocationItemsTIDs.sort
        { (sTherapistTID1, sTherapistTID2) in

            //  Compare for Sort: '<' sorts 'ascending' and '>' sorts 'descending'...

            return sTherapistTID1 < sTherapistTID2

        }

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'self.listSortedScheduledPatientLocationItemsTIDs' has #(\(listSortedScheduledPatientLocationItemsTIDs.count)) item(s)...")
  
        return listSortedScheduledPatientLocationItemsTIDs
  
    }   // End of func loadSortedScheduledPatientLocationItems(dictSchedPatientLocItems::[String:[ScheduledPatientLocationItem]])->[String].

    func loadSortedScheduledPatientLocationItems(dictSchedPatientLocItems:[String:[ScheduledPatientLocationItem]])->[String:[ScheduledPatientLocationItem]]
    {
  
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Load the SortedScheduledPatientLocationItems dictionary...

        self.dictOfSortedSchedPatientLocItems = [String:[ScheduledPatientLocationItem]]()

        self.countSortedScheduledPatientLocationItems()

        if (dictSchedPatientLocItems.count < 1)
        {
        
            // Exit...

        //  self.countSortedScheduledPatientLocationItems()

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - Nothing to load - 'self.dictOfSortedSchedPatientLocItems' has #(\(self.dictOfSortedSchedPatientLocItems.count)) item(s)...")

            return self.dictOfSortedSchedPatientLocItems
        
        }

        var dictOfSortedSchedPatientLocItems:[String:[ScheduledPatientLocationItem]]
            = [String:[ScheduledPatientLocationItem]]()
        var dictOfFilteredSchedPatientLocItems:[String:[ScheduledPatientLocationItem]]
            = [String:[ScheduledPatientLocationItem]]()

        var cSchedPatientLocItems:Int = 0 

        for (sKeyTherapistTID, listScheduledPatientLocationItems) in dictSchedPatientLocItems
        {

            cSchedPatientLocItems    += 1
            let sTherapistTID:String  = sKeyTherapistTID

            if (sTherapistTID.count < 1)
            {

                if (self.bInternalTraceFlag == true)
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) <dictionary loading> skipping object #(\(cSchedPatientLocItems)) - the 'sTherapistTID' <key> field is nil - Warning!")

                }

                continue

            }

            if (listScheduledPatientLocationItems.count < 1)
            {

                if (self.bInternalTraceFlag == true)
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) <dictionary loading> skipping object #(\(cSchedPatientLocItems)) - the 'listScheduledPatientLocationItems' <value> field has a count of #(\(listScheduledPatientLocationItems.count)) that is less than 1 - Warning!")

                }

                continue

            }

            if (listScheduledPatientLocationItems.count == 1)
            {

                if (listScheduledPatientLocationItems[0].iPid                  < 1 ||
                    listScheduledPatientLocationItems[0].sVDate.count          < 1 ||
                    listScheduledPatientLocationItems[0].sVDateStartTime.count < 1)
                {
                
                    if (self.bInternalTraceFlag == true)
                    {

                        self.xcgLogMsg("\(sCurrMethodDisp) <dictionary loading> skipping object #(\(cSchedPatientLocItems)) - the ONLY 'listScheduledPatientLocationItem[0]' <value> appears to be a 'placeholder'...")

                    }

                    continue
                
                }

            }

            dictOfFilteredSchedPatientLocItems[sTherapistTID] = listScheduledPatientLocationItems

            if (self.bInternalTraceFlag == true)
            {

                self.xcgLogMsg("\(sCurrMethodDisp) <dictionary loading> added object #(\(cSchedPatientLocItems)) of (\(listScheduledPatientLocationItems.count)) 'listScheduledPatientLocationItems' keyed by 'sTherapistTID' of [\(sTherapistTID)] to the 'filtered' dictionary of item(s)...")

            }

        }

        if (dictOfFilteredSchedPatientLocItems.count > 1)
        {
            
            self.xcgLogMsg("\(sCurrMethodDisp) <dictionary loading> sorting #(\(self.jmAppParseCoreManager.dictSchedPatientLocItems.count)) item(s) in the dictionary of SchedPatientLocItem(s)...")

            let listOfSortedSchedPatientLocItems
                = dictOfFilteredSchedPatientLocItems.sorted(by:
                  { (elementSchedPatientLocItem1, elementSchedPatientLocItem2) in

                      let sTherapistName1:String          = elementSchedPatientLocItem1.value[0].sTherapistName
                      let sTherapistName2:String          = elementSchedPatientLocItem2.value[0].sTherapistName
                      var bTherapistName1IsLessThan2:Bool = false
                      
                      //  Compare for Sort: '<' sorts 'ascending' and '>' sorts 'descending'...

                      bTherapistName1IsLessThan2 = (sTherapistName1 < sTherapistName2)

                      self.xcgLogMsg("\(sCurrMethodDisp) <dictionary loading> returning 'bTherapistName1IsLessThan2' of [\(bTherapistName1IsLessThan2)] for 'sTherapistName1' of [\(sTherapistName1)] less than 'sTherapistName2' of [\(sTherapistName2)]...")

                      return bTherapistName1IsLessThan2  
                  //  return (elementSchedPatientLocItem1.value[0].sTherapistName < elementSchedPatientLocItem2.value[0].sTherapistName)
                  //  return (elementSchedPatientLocItem1.key > elementSchedPatientLocItem2.key)
                  //  return (elementSchedPatientLocItem1.key < elementSchedPatientLocItem2.key)
                      
                  })

            if (self.bInternalTraceFlag == true)
            {

                self.xcgLogMsg("\(sCurrMethodDisp) <dictionary loading> sorted #(\(listOfSortedSchedPatientLocItems.count)) item(s) into a list...")

            }

            for (key, value) in listOfSortedSchedPatientLocItems
            {

                if (key.count < 1)
                {

                    continue

                }

                dictOfSortedSchedPatientLocItems[key] = value

            }
            
        }
        else
        {

            dictOfSortedSchedPatientLocItems = dictOfFilteredSchedPatientLocItems

        }

        self.dictOfSortedSchedPatientLocItems = dictOfSortedSchedPatientLocItems
    //  self.cTotalScheduledPatientVisits     = 0
    //
    //  if (self.dictOfSortedSchedPatientLocItems.count > 0)
    //  {
    //
    //      var cTotalScheduledPatientVisits:Int = 0
    //    
    //      for (_, listScheduledPatientLocationItems) in self.dictOfSortedSchedPatientLocItems
    //      {
    //    
    //          cTotalScheduledPatientVisits += listScheduledPatientLocationItems.count
    //    
    //      }
    //    
    //      self.cTotalScheduledPatientVisits = cTotalScheduledPatientVisits
    //
    //  }

        self.countSortedScheduledPatientLocationItems()
        
        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'self.dictOfSortedSchedPatientLocItems' has #(\(self.dictOfSortedSchedPatientLocItems.count)) item(s)...")
  
        return self.dictOfSortedSchedPatientLocItems
  
    }   // End of func loadSortedScheduledPatientLocationItems(dictSchedPatientLocItems::[String:[ScheduledPatientLocationItem]])->[String:[ScheduledPatientLocationItem]].

    func countSortedScheduledPatientLocationItems()
    {
  
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
        
        // Count item(s) in the SortedScheduledPatientLocationItems dictionary...

        self.cTotalScheduledPatientVisits = 0
        self.cTotalTidsOnWorkRoute        = 0
        self.cTotalTidsOnWorkRouteToday   = 0

        if (self.dictOfSortedSchedPatientLocItems.count > 0)
        {

            var cTotalScheduledPatientVisits:Int = 0
            var cTotalTidsOnWorkRoute:Int        = 0
            var cTotalTidsOnWorkRouteToday:Int   = 0
          
            for (sTherapistTIDKey, listScheduledPatientLocationItems) in self.dictOfSortedSchedPatientLocItems
            {
          
                cTotalScheduledPatientVisits += listScheduledPatientLocationItems.count

                let pfCscObject:ParsePFCscDataItem
                    = self.jmAppParseCoreManager.locatePFCscDataItemByTherapistTID(sTherapistTID:sTherapistTIDKey)

                if (pfCscObject.sPFCscParseLastLocDate.count  > 0       &&
                    pfCscObject.sPFCscParseLastLocDate       != "-N/A-" &&
                    pfCscObject.sPFCscParseLastLocTime.count  > 0       &&
                    pfCscObject.sPFCscParseLastLocTime       != "-N/A-")
                {

                    cTotalTidsOnWorkRoute += 1

                    if (self.isDateInToday(sDateToCheck:pfCscObject.sPFCscParseLastLocDate) == true)
                    {

                        cTotalTidsOnWorkRouteToday += 1

                    }

                }
          
            }
          
            self.cTotalScheduledPatientVisits = cTotalScheduledPatientVisits
            self.cTotalTidsOnWorkRoute        = cTotalTidsOnWorkRoute
            self.cTotalTidsOnWorkRouteToday   = cTotalTidsOnWorkRouteToday

        }

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - <count totals> 'self' is [\(self.toString())]...")
  
        return
  
    }   // End of func countSortedScheduledPatientLocationItems()

    private func isDateInToday(sDateToCheck:String)->Bool
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'sDateToCheck' is [\(sDateToCheck)]...")

        // Check if the supplied Date (string) is 'inToday'...

        var bDateIsInToday:Bool = false

        if (sDateToCheck.count > 0)
        {
        
            let dateFormatterFromString:DateFormatter = DateFormatter()
            dateFormatterFromString.dateFormat        = "M/dd/yy"
            let dateTestIsInToday:Date                = dateFormatterFromString.date(from:sDateToCheck) ?? Calendar.current.date(byAdding: .day, value: -1, to: .now)!
            bDateIsInToday                            = (Calendar.current.isDateInToday(dateTestIsInToday))
        
        }

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'bDateIsInToday' is [\(bDateIsInToday)]...")
  
        return bDateIsInToday

    } // End of private func isDateInToday(dateToCheck:Date)->Bool.
    
}   // End of public class AppScheduleLoadingAssistant.

