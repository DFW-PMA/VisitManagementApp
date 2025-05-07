//
//  JmAppParseCoreBkgdDataRepo.swift
//  JmUtils_Library
//
//  Created by Daryl Cox on 01/16/2025.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
import SwiftData
import ParseCore
import SwiftXLSX

// Implementation class to handle access to the ParseCore 'background' Data (repo).

//@MainActor
public class JmAppParseCoreBkgdDataRepo: NSObject
{

    struct ClassInfo
    {

        static let sClsId        = "JmAppParseCoreBkgdDataRepo"
        static let sClsVers      = "v1.2115"
        static let sClsDisp      = sClsId+".("+sClsVers+"): "
        static let sClsCopyRight = "Copyright (C) JustMacApps 2023-2025. All Rights Reserved."
        static let bClsTrace     = false
        static let bClsFileLog   = false

    }   // End of struct ClassInfo.

    // Class 'singleton' instance:

    struct ClassSingleton
    {

        static var appParseCodeBkgdDataRepo:JmAppParseCoreBkgdDataRepo         = JmAppParseCoreBkgdDataRepo()

    }

    // 'Internal' Trace flag:

    private 
    var bInternalTraceFlag:Bool                                                = false

    // App Data field(s):

    var parseConfig:ParseClientConfiguration?                                  = nil       

    var dictPFAdminsDataItems:[String:ParsePFAdminsDataItem]                   = [String:ParsePFAdminsDataItem]()
                                                                                 // [String:ParsePFAdminsDataItem]
                                                                                 // Key:PFAdminsParseTID(String)

//  var bHasDictTherapistFileItemsBeenDisplayed:Bool                           = false
    var bHasDictTherapistFileItemsBeenDisplayed:Bool                           = true   // Let this fire 'on-demand'...
    var dictPFTherapistFileItems:[Int:ParsePFTherapistFileItem]                = [Int:ParsePFTherapistFileItem]()
                                                                                 // [Int:ParsePFTherapistFileItem]
                                                                                 // Key:Tid(Int) -> TherapistID (Int)

    var dictTherapistTidXref:[String:String]                                   = [String:String]()
                                                                                 // [String:String]
                                                                                 // Key:Tid(String)                               -> TherapistName (String)
                                                                                 // Key:TherapistName(String)                     -> Tid (String)
                                                                                 // Key:TherapistName(String)<lowercased>         -> Tid (String)
                                                                                 // Key:TherapistName(String)<lowercased & NO WS> -> Tid (String)

//  var bHasDictPatientFileItemsBeenDisplayed:Bool                             = false
    var bHasDictPatientFileItemsBeenDisplayed:Bool                             = true   // Let this fire 'on-demand'...
    var dictPFPatientFileItems:[Int:ParsePFPatientFileItem]                    = [Int:ParsePFPatientFileItem]()
                                                                                 // [Int:ParsePFPatientFileItem]
                                                                                 // Key:Pid(Int) -> PatientPid (Int)

    var dictPatientPidXref:[String:String]                                     = [String:String]()
                                                                                 // [String:String]
                                                                                 // Key:Pid(String)                             -> PatientName (String)
                                                                                 // Key:PatientName(String)                     -> Pid (String)
                                                                                 // Key:PatientName(String)<lowercased>         -> Pid (String)
                                                                                 // Key:PatientName(String)<lowercased & NO WS> -> Pid (String)

//  var bNeedFirstPassPFQueriesInBackground:Bool                               = true
    var bNeedFirstPassPFQueriesInBackground:Bool                               = false  // Let this fire from a View...

//  var bHasDictSchedPatientLocItemsBeenDisplayed:Bool                         = false
    var bHasDictSchedPatientLocItemsBeenDisplayed:Bool                         = true   // Let this fire 'on-demand'...
    var dictSchedPatientLocItems:[String:[ScheduledPatientLocationItem]]       = [String:[ScheduledPatientLocationItem]]()
                                                                                 // [String:[ScheduledPatientLocationItem]]
                                                                                 // Key:sPFTherapistParseTID(String)

//  var bHasDictExportSchedPatientLocItemsBeenDisplayed:Bool                   = false
    var bHasDictExportSchedPatientLocItemsBeenDisplayed:Bool                   = true   // Let this fire 'on-demand'...
    var dictExportSchedPatientLocItems:[String:[ScheduledPatientLocationItem]] = [String:[ScheduledPatientLocationItem]]()
                                                                                 // [String:[ScheduledPatientLocationItem]]
                                                                                 // Key:sPFTherapistParseTID(String)

//  var bHasDictExportBackupFileItemsBeenDisplayed:Bool                        = false
    var bHasDictExportBackupFileItemsBeenDisplayed:Bool                        = true   // Let this fire 'on-demand'...
    var dictExportBackupFileItems:[String:[String:ParsePFBackupFileItem]]      = [String:[String:ParsePFBackupFileItem]]()
                                                                                 // [String:[String:ParsePFBackupFileItem]]
                                                                                 // Key #1:"sTherapistTID(String).sPatientPID(String)"
                                                                                 // Key #2:ParsePFBackupFileItem.sLastVDate
                                                                                 // Value :ParsePFBackupFileItem

//  var bHasDictExportLastBackupFileItemsBeenDisplayed:Bool                    = false
    var bHasDictExportLastBackupFileItemsBeenDisplayed:Bool                    = true   // Let this fire 'on-demand'...
    var dictExportLastBackupFileItems:[String:ParsePFBackupFileItem]           = [String:ParsePFBackupFileItem]()
                                                                                 // [String:ParsePFBackupFileItem]
                                                                                 // Key #1:"sTherapistTID(String).sPatientPID(String)"
                                                                                 // Key #2:"sPatientPID(String)"
                                                                                 // Value :ParsePFBackupFileItem

                                                                                 // <<< PFCsc is WorkRoute locations:
    var listPFCscDataItems:[ParsePFCscDataItem]                                = [ParsePFCscDataItem]()
    var listPFCscNameItems:[String]                                            = [String]()

    var jmAppDelegateVisitor:JmAppDelegateVisitor?                             = nil
                                                                                 // 'jmAppDelegateVisitor' MUST remain declared this way
                                                                                 // as having it reference the 'shared' instance of 
                                                                                 // JmAppDelegateVisitor causes a circular reference
                                                                                 // between the 'init()' methods of the 2 classes...
    var jmAppSwiftDataManager:JmAppSwiftDataManager                            = JmAppSwiftDataManager.ClassSingleton.appSwiftDataManager
    var jmAppParseCoreManager:JmAppParseCoreManager                            = JmAppParseCoreManager.ClassSingleton.appParseCodeManager

    // App <global> Message(s) 'stack' cached before XCGLogger is available:

    var  listPreXCGLoggerMessages:[String]                                     = [String]()

    // ------------------------------------------------------------------------------------------------------
    //
    //  Item(s) that would need separate 'tracking' instance from a background thread to the 'main':
    //
    //      self.dictPFAdminsDataItems[]                 -> Admin(s) that can 'log-in'...
    //      self.dictPFTherapistFileItems[]              -> All 'known' Therapist(s)...
    //      self.dictSchedPatientLocItems[]              -> Patient Schedule for the day by Therapist(s)...
    //      self.dictTherapistTidXref[]                  -> Therapist TID/TName cross-reference dictionary...
    //      - - - - -
    //      self.listPFCscDataItems:[ParsePFCscDataItem] -> All 'known' WorkRoute People...
    //      self.listPFCscNameItems:[String]             -> All 'known' WorkRoute People 'name(s)'...
    //
    // ------------------------------------------------------------------------------------------------------

    private override init()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        super.init()

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
        
        // Exit:

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

    }   // End of private func xcgLogMsg().

    public func toString() -> String
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
        asToString.append("'bInternalTraceFlag': [\(String(describing: self.bInternalTraceFlag))]")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'parseConfig': [\(String(describing: self.parseConfig))]")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'dictPFAdminsDataItems': [\(String(describing: self.dictPFAdminsDataItems))]")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'bHasDictTherapistFileItemsBeenDisplayed': [\(String(describing: self.bHasDictTherapistFileItemsBeenDisplayed))]")
        asToString.append("'dictPFTherapistFileItems': [\(String(describing: self.dictPFTherapistFileItems))]")
        asToString.append("'dictTherapistTidXref': [\(String(describing: self.dictTherapistTidXref))]")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'dictPFPatientFileItems': [\(String(describing: self.dictPFPatientFileItems))]")
        asToString.append("'dictPatientPidXref': [\(String(describing: self.dictPatientPidXref))]")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'bNeedFirstPassPFQueriesInBackground': [\(String(describing: self.bNeedFirstPassPFQueriesInBackground))]")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'bHasDictSchedPatientLocItemsBeenDisplayed': [\(String(describing: self.bHasDictSchedPatientLocItemsBeenDisplayed))]")
        asToString.append("'dictSchedPatientLocItems': [\(String(describing: self.dictSchedPatientLocItems))]")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'bHasDictExportSchedPatientLocItemsBeenDisplayed': [\(String(describing: self.bHasDictExportSchedPatientLocItemsBeenDisplayed))]")
        asToString.append("'dictExportSchedPatientLocItems': [\(String(describing: self.dictExportSchedPatientLocItems))]")
        asToString.append("'bHasDictExportBackupFileItemsBeenDisplayed': [\(String(describing: self.bHasDictExportBackupFileItemsBeenDisplayed))]")
        asToString.append("'dictExportBackupFileItems': [\(String(describing: self.dictExportBackupFileItems))]")
        asToString.append("'bHasDictExportLastBackupFileItemsBeenDisplayed': [\(String(describing: self.bHasDictExportLastBackupFileItemsBeenDisplayed))]")
        asToString.append("'dictExportLastBackupFileItems': [\(String(describing: self.dictExportLastBackupFileItems))]")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'listPFCscDataItems': [\(String(describing: self.listPFCscDataItems))] <WorkRoute items>")
        asToString.append("'listPFCscNameItems': [\(String(describing: self.listPFCscNameItems))] <WorkRoute names>")
        asToString.append("],")
        asToString.append("]")

        let sContents:String = "{"+(asToString.joined(separator: ""))+"}"

        return sContents

    }   // End of public func toString().

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
            self.xcgLogMsg("\(sCurrMethodDisp) <<< === Spooling the JmAppDelegateVisitor.XCGLogger 'pre' Message(s) from JmAppParseCoreBkgdDataRepo === >>>")

            let sPreXCGLoggerMessages:String = self.listPreXCGLoggerMessages.joined(separator: "\n")

            self.xcgLogMsg(sPreXCGLoggerMessages)

            self.xcgLogMsg("\(sCurrMethodDisp) <<< === Spooled  the JmAppDelegateVisitor.XCGLogger 'pre' Message(s) from JmAppParseCoreBkgdDataRepo === >>>")
            self.xcgLogMsg("")

        }

        // Finish any 'initialization' work:

        self.xcgLogMsg("\(sCurrMethodDisp) ParseCoreBkgdDataRepo Invoking 'self.runPostInitializationTasks()'...")
    
        self.runPostInitializationTasks()

        self.xcgLogMsg("\(sCurrMethodDisp) ParseCoreBkgdDataRepo Invoked  'self.runPostInitializationTasks()'...")

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'self.jmAppDelegateVisitor' is [\(String(describing: self.jmAppDelegateVisitor))]...")
    
        return

    } // End of public func setJmAppDelegateVisitorInstance().

    private func runPostInitializationTasks()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'self' is [\(self)]...")

        // Finish performing any setup with the ParseCore 'background' Data repo...
        // --------------------------------------------------------------------------------------------------
        // ParseCore doc: -> https://docs.parseplatform.org/ios/guide/
        //
        //     let parseConfig = ParseClientConfiguration {
        //                                                 $0.applicationId = "parseAppId"
        //                                                 $0.clientKey     = "parseClientKey"
        //                                                 $0.server        = "parseServerUrlString"
        //                                                }
        //     Parse.initialize(with: parseConfig)
        // --------------------------------------------------------------------------------------------------

        self.xcgLogMsg("\(sCurrMethodDisp) Creating the ParseCore (Client) 'configuration'...")

        self.parseConfig = ParseClientConfiguration
                               {
                                   $0.applicationId = "VDN7Gs0vvYMg5yokvC4I7Nh521hbm9NF2jluCgW3"
                                   $0.clientKey     = "txwqvA4yxFiShXAiVyY3tMNG00vKpiW6UmdugVnI"
                                   $0.server        = "https://pg-app-1ye5iesplk164f4dsvq8gtaddgv1xc.scalabl.cloud/1/"
                               }

        self.xcgLogMsg("\(sCurrMethodDisp) Passing the ParseCore (Client) 'configuration' on to ParseCore...")

        Parse.initialize(with:self.parseConfig!)

        self.xcgLogMsg("\(sCurrMethodDisp) Passed  the ParseCore (Client) 'configuration' on to ParseCore...")

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of private func runPostInitializationTasks().

    public func getJmAppParsePFQueryForAdmins(bForceReloadOfPFQuery:Bool = false)
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'bForceReloadOfPFQuery' is [\(bForceReloadOfPFQuery)]...")

        // If we already have a dictionary of PFAdmins item(s), then display them and skip the PFQuery...

        if (bForceReloadOfPFQuery == false)
        {
        
            if (self.dictPFAdminsDataItems.count > 0)
            {

                self.xcgLogMsg("\(sCurrMethodDisp) The (existing) dictionary of 'parsePFAdminsDataItem' item(s) has #(\(self.dictPFAdminsDataItems.count)) object(s) - skipping the PFQuery...")
                self.xcgLogMsg("\(sCurrMethodDisp) Displaying the (existing) dictionary of 'parsePFAdminsDataItem' item(s)...")

                for (_, parsePFAdminsDataItem) in self.dictPFAdminsDataItems
                {

                    parsePFAdminsDataItem.displayParsePFAdminsDataItemToLog()

                }

                // ----------------------------------------------------------------------------------------------
                // var dictPFAdminsDataItems:[String:ParsePFAdminsDataItem] = [:]
                //                                                            // [String:ParsePFAdminsDataItem]
                //                                                            // Key:PFAdminsParseTID(String)
                // ----------------------------------------------------------------------------------------------

                // If we have a different # of item(s) then the ParseCoreManager does, then deep copy and update it...

                if (self.jmAppParseCoreManager.dictPFAdminsDataItems.count  < 1 ||
                    self.jmAppParseCoreManager.dictPFAdminsDataItems.count != self.dictPFAdminsDataItems.count)
                {

                    let _ = self.deepCopyDictPFAdminsDataItems()

                }

                // Exit:

                self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

                return

            }
        
        }

        // Issue a PFQuery for the 'Admins' class...

        self.xcgLogMsg("\(sCurrMethodDisp) Calling PFQuery to construct an instance for the 'Admins' class...")

        let pfQueryAdmins:PFQuery = PFQuery(className:"Admins")

        self.xcgLogMsg("\(sCurrMethodDisp) Called  PFQuery to construct an instance for the 'Admins' class...")

        // Set the query parameter(s) and issue the 'find' then (possibly) iterate the result(s)...

        self.xcgLogMsg("\(sCurrMethodDisp) Returned query of 'pfQueryAdmins' is [\(String(describing: pfQueryAdmins))]...")

        do
        {
            
            pfQueryAdmins.whereKeyExists("tid")
            pfQueryAdmins.whereKeyExists("password")
            
            pfQueryAdmins.limit = 1000
            
            let listPFAdminsObjects:[PFObject]? = try pfQueryAdmins.findObjects()
            
            if (listPFAdminsObjects != nil &&
                listPFAdminsObjects!.count > 0)
            {
                
                self.xcgLogMsg("\(sCurrMethodDisp) Parse - query of 'pfQueryAdmins' returned a count of #(\(listPFAdminsObjects!.count)) PFObject(s) for ALL TID(s)...")
                self.xcgLogMsg("\(sCurrMethodDisp) Enumerating the result(s) of query of 'pfQueryAdmins'...")

                var cPFAdminsObjects:Int   = 0
                self.dictPFAdminsDataItems = [:]

                for pfAdminsObject in listPFAdminsObjects!
                {

                    cPFAdminsObjects += 1

                    let parsePFAdminsDataItem:ParsePFAdminsDataItem = ParsePFAdminsDataItem()

                    parsePFAdminsDataItem.constructParsePFAdminsDataItemFromPFObject(idPFAdminsObject:cPFAdminsObjects, pfAdminsObject:pfAdminsObject)

                    let sPFAdminsParseTID:String = parsePFAdminsDataItem.sPFAdminsParseTID

                    if (sPFAdminsParseTID.count  < 1 ||
                        sPFAdminsParseTID       == "-N/A-")
                    {

                        self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cPFAdminsObjects)) 'parsePFAdminsDataItem' - the 'tid' field is nil or '-N/A-' - Warning!")

                        continue

                    }

                    self.dictPFAdminsDataItems[sPFAdminsParseTID] = parsePFAdminsDataItem

                    self.xcgLogMsg("\(sCurrMethodDisp) Added object #(\(cPFAdminsObjects)) 'parsePFAdminsDataItem' keyed by 'sPFAdminsParseTID' of [\(sPFAdminsParseTID)] to the dictionary of item(s)...")

                }
                
                if (self.dictPFAdminsDataItems.count > 0)
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) Adding the 'TherapistFile' query data to the dictionary of 'parsePFAdminsDataItem' item(s) - 'bForceReloadOfPFQuery' is [\(bForceReloadOfPFQuery)]...")

                    self.getJmAppParsePFQueryForTherapistFileToAddToAdmins(bForceReloadOfPFQuery:bForceReloadOfPFQuery)
                    self.displayDictPFAdminsDataItems()

                    // Copy back to self.dictPFAdminsDataItems[] and to SwiftData...

                    self.xcgLogMsg("\(sCurrMethodDisp) Copying the item(s) from the dictionary of 'parsePFAdminsDataItem' to SwiftData...")

                    self.copyJmAppParsePFAdminsToSwiftData()

                }

            }
            else
            {

                self.xcgLogMsg("\(sCurrMethodDisp) Parse - query of 'pfQueryAdmins' returned an 'empty' or nil list of PFObject(s) for ALL TID(s)...")

            }
            
        }
        catch
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Parse - failed execute the query 'pfQueryAdmins' - Details: \(error) - Error!")
            
        }

        // We've updated from PFQuery, so then deep copy and update it in ParseCoreManager...

        let _ = self.deepCopyDictPFAdminsDataItems()

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
    
        return

    } // End of public func getJmAppParsePFQueryForAdmins(bForceReloadOfPFQuery:Bool).

    public func getJmAppParsePFQueryForTherapistFileToAddToAdmins(bForceReloadOfPFQuery:Bool = false)
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'bForceReloadOfPFQuery' is [\(bForceReloadOfPFQuery)]...")

        // Issue a PFQuery for the 'TherapistFile' class...

        self.xcgLogMsg("\(sCurrMethodDisp) Calling PFQuery to construct an instance for the 'TherapistFile' class...")

        let pfQueryTherapist:PFQuery = PFQuery(className:"TherapistFile")

        self.xcgLogMsg("\(sCurrMethodDisp) Called  PFQuery to construct an instance for the 'TherapistFile' class...")

        // Set the query parameter(s) and issue the 'find' then (possibly) iterate the result(s)...

        self.xcgLogMsg("\(sCurrMethodDisp) Returned query of 'pfQueryTherapist' is [\(String(describing: pfQueryTherapist))]...")

        do
        {
            
            pfQueryTherapist.whereKeyExists("ID")
            pfQueryTherapist.whereKeyExists("name")
        //  pfQueryTherapist.whereKeyExists("notActive")

        //  pfQueryTherapist.whereKey("notActive", equalTo:false)
            
            pfQueryTherapist.limit = 1500
            
            let listPFTherapistObjects:[PFObject]? = try pfQueryTherapist.findObjects()
            
            if (listPFTherapistObjects        != nil &&
                listPFTherapistObjects!.count  > 0)
            {
                
                self.xcgLogMsg("\(sCurrMethodDisp) Parse - query of 'pfQueryTherapist' returned a count of #(\(listPFTherapistObjects!.count)) PFObject(s) for ALL 'active' TID(s)...")
                self.xcgLogMsg("\(sCurrMethodDisp) Enumerating the result(s) of query of 'pfQueryTherapist'...")
                self.xcgLogMsg("\(sCurrMethodDisp) The 'tracking' location(s) list with #(\(self.listPFCscNameItems.count)) item(s) is [\(self.listPFCscNameItems)])...")

                var cPFTherapistObjects:Int   = 0

                let clModelObservable2:CoreLocationModelObservable2 = self.jmAppDelegateVisitor!.jmAppCLModelObservable2!

                clModelObservable2.resetNextReverseLocationLookupDeadlineInterval(clRevLocType:CLRevLocType.secondary)

                for pfTherapistObject in listPFTherapistObjects!
                {

                    cPFTherapistObjects += 1

                    let sPFTherapistParseName:String = String(describing: (pfTherapistObject.object(forKey:"name") ?? "-N/A-"))
                    let sPFTherapistParseTID:String  = String(describing: (pfTherapistObject.object(forKey:"ID")   ?? "-N/A-"))

                    if (sPFTherapistParseTID.count  < 1 ||
                        sPFTherapistParseTID       == "-N/A-")
                    {

                        self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cPFTherapistObjects)) 'pfTherapistObject' - 'sPFTherapistParseName' is [\(sPFTherapistParseName)] - the 'tid' field is nil or '-N/A-' - Warning!")

                        continue

                    }

                    let iPFTherapistParseTID:Int = Int(sPFTherapistParseTID) ?? -1

                    if (iPFTherapistParseTID < 0)
                    {

                        self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cPFTherapistObjects)) 'pfTherapistObject' - 'sPFTherapistParseName' is [\(sPFTherapistParseName)] - the 'tid' field (Int) is less than 0 - Warning!")

                        continue

                    }

                    if (sPFTherapistParseName.count  < 1 ||
                        sPFTherapistParseName       == "-N/A-")
                    {

                        self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cPFTherapistObjects)) 'pfTherapistObject' - 'sPFTherapistParseTID' is [\(sPFTherapistParseTID)] - the 'name' field is nil or '-N/A-' - Warning!")

                        continue

                    }

                    // Build the Tid/TherapistName Xref dictionary...

                    let sPFTherapistParseNameLower:String                     = sPFTherapistParseName.lowercased()
            
            //  //  let listPFTherapistParseNameLowerBase:[String]            = sPFTherapistParseNameLower.components(separatedBy:CharacterSet.illegalCharacters)
            //  //  let sPFTherapistParseNameLowerBaseJoined:String           = listPFTherapistParseNameLowerBase.joined(separator:"")
            //  //  let listPFTherapistParseNameLowerNoWS:[String]            = sPFTherapistParseNameLowerBaseJoined.components(separatedBy:CharacterSet.whitespacesAndNewlines)
            //  //  let sPFTherapistParseNameLowerNoWS:String                 = listPFTherapistParseNameLowerNoWS.joined(separator:"")
            //
            //      var csUnwantedDelimiters:CharacterSet = CharacterSet()
            //
            //      csUnwantedDelimiters = csUnwantedDelimiters.union(CharacterSet.illegalCharacters)
            //      csUnwantedDelimiters = csUnwantedDelimiters.union(CharacterSet.whitespacesAndNewlines)
            //      csUnwantedDelimiters = csUnwantedDelimiters.union(CharacterSet.punctuationCharacters)
            //
            //      let listPFTherapistParseNameLowerNoWS:[String]            = sPFTherapistParseNameLower.components(separatedBy:csUnwantedDelimiters)
            //      let sPFTherapistParseNameLowerNoWS:String                 = listPFTherapistParseNameLowerNoWS.joined(separator:"")

                    let sPFTherapistParseNameLowerNoWS:String                 = sPFTherapistParseName.removeUnwantedCharacters(charsetToRemove:[StringCleaning.removeAll], bResultIsLowerCased:true)

                    self.dictTherapistTidXref[sPFTherapistParseTID]           = sPFTherapistParseName
                    self.dictTherapistTidXref[sPFTherapistParseName]          = sPFTherapistParseTID
                    self.dictTherapistTidXref[sPFTherapistParseNameLower]     = sPFTherapistParseTID
                    self.dictTherapistTidXref[sPFTherapistParseNameLowerNoWS] = sPFTherapistParseTID

                    // Track the Therapist in the dictionary of TherapistFile item(s)...

                    let pfTherapistFileItem:ParsePFTherapistFileItem          = ParsePFTherapistFileItem()

                    pfTherapistFileItem.constructParsePFTherapistFileItemFromPFObject(idPFTherapistFileObject:cPFTherapistObjects, pfTherapistFileObject:pfTherapistObject)

                    self.dictPFTherapistFileItems[iPFTherapistParseTID]       = pfTherapistFileItem

                    self.xcgLogMsg("\(sCurrMethodDisp) Added an Item keyed by 'iPFTherapistParseTID' of [\(iPFTherapistParseTID)] added an Item 'pfTherapistFileItem' of [\(pfTherapistFileItem.toString())] to the dictionary of 'dictPFTherapistFileItems' item(s)...")

                    // Track the Therapist in the dictionary of Scheduled Patient 'location' item(s)...

                    if (self.dictSchedPatientLocItems[sPFTherapistParseTID] == nil)
                    {
                    
                        let scheduledPatientLocationItem:ScheduledPatientLocationItem =
                                ScheduledPatientLocationItem(pfTherapistFileItem:pfTherapistObject)
                    
                        var listScheduledPatientLocationItems:[ScheduledPatientLocationItem] = [ScheduledPatientLocationItem]()
                    
                        listScheduledPatientLocationItems.append(scheduledPatientLocationItem)
                    
                        self.dictSchedPatientLocItems[sPFTherapistParseTID] = listScheduledPatientLocationItems
                    
                        self.xcgLogMsg("\(sCurrMethodDisp) Added an initial Item 'listScheduledPatientLocationItems' of [\(listScheduledPatientLocationItems)] (in a List) to the dictionary of 'dictSchedPatientLocItems' item(s) keyed by 'sPFTherapistParseTID' of [\(sPFTherapistParseTID)] as a 'placeholder'...")
                    
                    }
                    else
                    {
                    
                        self.xcgLogMsg("\(sCurrMethodDisp) Skipped adding an initial Item 'ScheduledPatientLocationItem' (in a List) to the dictionary of 'dictSchedPatientLocItems' item(s) - key 'sPFTherapistParseTID' of [\(sPFTherapistParseTID)] already exists...")
                    
                    }
                    
                    // Track the Therapist 'name' in the PFAdminsDataItem(s) dictionary...
                
                    if let parsePFAdminsDataItem:ParsePFAdminsDataItem = self.dictPFAdminsDataItems[sPFTherapistParseTID]
                    {

                        parsePFAdminsDataItem.sPFAdminsParseName     = sPFTherapistParseName
                        parsePFAdminsDataItem.sPFAdminsParseNameNoWS = sPFTherapistParseName.removeUnwantedCharacters(charsetToRemove:[StringCleaning.removeAll], bResultIsLowerCased:true)

                        self.xcgLogMsg("\(sCurrMethodDisp) Using object #(\(cPFTherapistObjects)) 'pfTherapistObject' - to set the 'name' field of [\(sPFTherapistParseName)] in the dictionary of 'parsePFAdminsDataItem' item(s)...")

                    }
                    else
                    {

                        self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cPFTherapistObjects)) 'pfTherapistObject' - the 'tid' field of [\(sPFTherapistParseTID)] is NOT in the dictionary of 'parsePFAdminsDataItem' item(s)...")

                    }

                }
                
            }
            else
            {

                self.xcgLogMsg("\(sCurrMethodDisp) Parse - query of 'pfQueryTherapist' returned a count of #(\(listPFTherapistObjects!.count)) PFObject(s) for ALL 'active' TID(s) - Error!")

            }
            
        }
        catch
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Parse - failed execute the query 'pfQueryAdmins' - Details: \(error) - Error!")
            
        }

        // If we created item(s) in the 'dictSchedPatientLocItems' and we haven't displayed them, then display them...

        if (bHasDictSchedPatientLocItemsBeenDisplayed == false)
        {

            bHasDictSchedPatientLocItemsBeenDisplayed = true

            self.displayDictSchedPatientLocItems()

        }

        // If we created item(s) in the 'dictPFTherapistFileItems' and we haven't displayed them, then display them...

        if (bHasDictTherapistFileItemsBeenDisplayed == false)
        {

            bHasDictTherapistFileItemsBeenDisplayed = true

            self.displayDictPFTherapistFileItems()

        }

        // ----------------------------------------------------------------------------------------------------------------------
        //  var dictTherapistTidXref:[String:String] = [String:String]()
        //                                             // [String:String]
        //                                             // Key:Tid(String)                               -> TherapistName (String)
        //                                             // Key:TherapistName(String)                     -> Tid (String)
        //                                             // Key:TherapistName(String)<lowercased>         -> Tid (String)
        //                                             // Key:TherapistName(String)<lowercased & NO WS> -> Tid (String)
        // ----------------------------------------------------------------------------------------------------------------------

        if (self.dictTherapistTidXref.count > 0)
        {

            // If we have a different # of item(s) then the ParseCoreManager does, then deep copy and update it...

            if (self.jmAppParseCoreManager.dictTherapistTidXref.count  < 1 ||
                self.jmAppParseCoreManager.dictTherapistTidXref.count != self.dictTherapistTidXref.count)
            {

                let _ = self.deepCopyDictTherapistTidXref()
            
            }
            else
            {

                // If we're 'forcing' a Reload, then deep copy and update it...

                if (bForceReloadOfPFQuery == true)
                {
                    
                    let _ = self.deepCopyDictTherapistTidXref()
                
                }

            }

        }

        // ----------------------------------------------------------------------------------------------------------------------
        //  var dictPFTherapistFileItems:[Int:ParsePFTherapistFileItem] = [Int:ParsePFTherapistFileItem]()
        //                                                                // [Int:ParsePFTherapistFileItem]
        //                                                                // Key:Tid(Int) -> TherapistID (Int)
        // ----------------------------------------------------------------------------------------------------------------------

        if (self.dictPFTherapistFileItems.count > 0)
        {

            // If we have a different # of item(s) then the ParseCoreManager does, then deep copy and update it...

            if (self.jmAppParseCoreManager.dictPFTherapistFileItems.count  < 1 ||
                self.jmAppParseCoreManager.dictPFTherapistFileItems.count != self.dictPFTherapistFileItems.count)
            {

                let _ = self.deepCopyDictPFTherapistFileItems()
            
            }
            else
            {

                // If we're 'forcing' a Reload, then deep copy and update it...

                if (bForceReloadOfPFQuery == true)
                {

                    let _ = self.deepCopyDictPFTherapistFileItems()

                }

            }

        }

        // ----------------------------------------------------------------------------------------------------------------------
        //  var dictSchedPatientLocItems:[String:[ScheduledPatientLocationItem]] = [String:[ScheduledPatientLocationItem]]()
        //                                                                         // [String:[ScheduledPatientLocationItem]]
        //                                                                         // Key:sPFTherapistParseTID(String)
        // ----------------------------------------------------------------------------------------------------------------------

        if (self.dictSchedPatientLocItems.count > 0)
        {

            // If we have a different # of item(s) then the ParseCoreManager does, then deep copy and update it...

            if (self.jmAppParseCoreManager.dictSchedPatientLocItems.count  < 1 ||
                self.jmAppParseCoreManager.dictSchedPatientLocItems.count != self.dictSchedPatientLocItems.count)
            {

                let _ = self.deepCopyDictSchedPatientLocItems()
            
            }
            else
            {

                // If we're 'forcing' a Reload, then deep copy and update it...

                if (bForceReloadOfPFQuery == true)
                {

                    let _ = self.deepCopyDictSchedPatientLocItems()

                }

            }

        }

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
    
        return

    } // End of public func getJmAppParsePFQueryForTherapistFileToAddToAdmins(bForceReloadOfPFQuery:Bool).

    public func getJmAppParsePFQueryForCSC()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Issue a PFQuery for the 'CSC' class...

        self.xcgLogMsg("\(sCurrMethodDisp) Calling PFQuery to construct an instance for the 'CSC' class...")

        let pfQueryCSC:PFQuery = PFQuery(className:"CSC")

        self.xcgLogMsg("\(sCurrMethodDisp) Called  PFQuery to construct an instance for the 'CSC' class...")

        // Set the query parameter(s) and issue the 'find' then (possibly) iterate the result(s)...

        self.xcgLogMsg("\(sCurrMethodDisp) Returned query of 'pfQueryCSC' is [\(String(describing: pfQueryCSC))]...")

        do
        {
            
            pfQueryCSC.whereKeyExists("name")
            pfQueryCSC.whereKeyExists("lastLocDate")
            pfQueryCSC.whereKeyExists("lastLocTime")
            pfQueryCSC.whereKeyExists("latitude")
            pfQueryCSC.whereKeyExists("longitude")
            
            pfQueryCSC.whereKey("updatedAt", greaterThan:(Calendar.current.date(byAdding: .day, value: -1, to: .now)!))
            
            pfQueryCSC.addDescendingOrder("updatedAt")
            
            pfQueryCSC.limit = 1000
            
            let listPFCscObjects:[PFObject]? = try pfQueryCSC.findObjects()
            
            if (listPFCscObjects != nil &&
                listPFCscObjects!.count > 0)
            {

                self.xcgLogMsg("\(sCurrMethodDisp) Parse - query of 'pfQueryCSC' returned a count of #(\(listPFCscObjects!.count)) PFObject(s) for ALL TID(s) in the last day...")
                self.xcgLogMsg("\(sCurrMethodDisp) Enumerating the result(s) of query of 'pfQueryCSC'...")

                var cPFCscObjects:Int = 0
                
                var dictPFCscDataItems:[String:ParsePFCscDataItem]  = [String:ParsePFCscDataItem]()
                                                                      // [String:[ParsePFCscDataItem]]
                let clModelObservable2:CoreLocationModelObservable2 = self.jmAppDelegateVisitor!.jmAppCLModelObservable2!

                clModelObservable2.resetNextReverseLocationLookupDeadlineInterval(clRevLocType:CLRevLocType.primary)

                for currentPFCscDataItem:ParsePFCscDataItem in self.listPFCscDataItems
                {

                    if (currentPFCscDataItem.sPFCscParseName.count < 1)
                    {
                    
                        continue
                    
                    }

                    dictPFCscDataItems[currentPFCscDataItem.sPFCscParseName] = currentPFCscDataItem

                }

                for pfCscObject in listPFCscObjects!
                {

                    cPFCscObjects += 1

                    let parsePFCscDataItem:ParsePFCscDataItem = ParsePFCscDataItem()

                    parsePFCscDataItem.constructParsePFCscDataItemFromPFObject(idPFCscObject:cPFCscObjects, pfCscObject:pfCscObject)

                    let sPFCscParseName:String = parsePFCscDataItem.sPFCscParseName

                    parsePFCscDataItem.sPFTherapistParseTID = self.convertTherapistNameToTid(sPFTherapistParseName:sPFCscParseName)

                    if (dictPFCscDataItems.keys.contains(sPFCscParseName) == true)
                    {
                    
                        let currentPFCscDataItem:ParsePFCscDataItem = dictPFCscDataItems[sPFCscParseName]!

                        currentPFCscDataItem.overlayPFCscDataItemWithAnotherPFCscDataItem(pfCscDataItem:parsePFCscDataItem)

                        // NO update to 'listPFCscDataItems' - the object is the same in the list as the dictionary...
                        
                        self.xcgLogMsg("\(sCurrMethodDisp) <PFQuery> Updated object #(\(cPFCscObjects)) 'parsePFCscDataItem' for key 'sPFCscParseName' of [\(sPFCscParseName)] to the tracking dictionary (automatic update in the list)...")
                    
                    }
                    else
                    {
                    
                        dictPFCscDataItems[sPFCscParseName] = parsePFCscDataItem

                        self.listPFCscDataItems.append(parsePFCscDataItem)
                        self.listPFCscNameItems.append(sPFCscParseName)

                        // Dictionary and BOTH List(s) are updated as this is a 'new' Item...
                        
                        self.xcgLogMsg("\(sCurrMethodDisp) <PFQuery> Added object #(\(cPFCscObjects)) 'parsePFCscDataItem' for key 'sPFCscParseName' of [\(sPFCscParseName)] to the tracking dictionary and both lists of name(s)/item(s)...")
                    
                    }

                }

                if (dictPFCscDataItems.count > 0)
                {
                
                    self.xcgLogMsg("\(sCurrMethodDisp) <PFQuery> 'tracking' - Displaying the <internal/local> dictionary 'dictPFCscDataItems' of (\(dictPFCscDataItems.count))) item(s)...")

                    var cDictPFCscDataItems:Int = 0

                    for (sPFCscParseName, currentPFCscDataItem) in dictPFCscDataItems
                    {

                        cDictPFCscDataItems += 1

                        if (sPFCscParseName.count  < 1)
                        {

                            self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cDictPFCscDataItems)) 'sPFCscParseName' - the 'name' field is 'empty' - Warning!")

                            continue

                        }

                        currentPFCscDataItem.displayParsePFCscDataItemToLog(cDisplayItem:cDictPFCscDataItems)

                    }
                
                }
                else
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) <PFQuery> 'tracking' - Unable to display the <internal/local> dictionary 'dictPFCscDataItems' of (\(dictPFCscDataItems.count))) item(s) - Warning!")

                }

                // Gather the PFQueries to construct the new ScheduledPatientLocationItem(s) and
                // ParsePFPatientFileItem(s) in the background
                // (ONLY on the 1st call to this function - after that these fire from a View on a Timer)

                if (self.bNeedFirstPassPFQueriesInBackground == true)
                {
                    
                    self.bNeedFirstPassPFQueriesInBackground = false

                    self.xcgLogMsg("\(sCurrMethodDisp) <1st Run> Calling 'self.gatherJmAppParsePFQueriesForScheduledLocationsInBackground()' to gather 'scheduled' Patient location data...")

                    self.gatherJmAppParsePFQueriesForScheduledLocationsInBackground()

                    self.xcgLogMsg("\(sCurrMethodDisp) <1st Run> Called  'self.gatherJmAppParsePFQueriesForScheduledLocationsInBackground()' to gather 'scheduled' Patient location data...")

                    self.xcgLogMsg("\(sCurrMethodDisp) <1st Run> Calling 'self.gatherJmAppParsePFQueriesForPatientFileInBackground()' to gather PatientFile data...")

                    self.gatherJmAppParsePFQueriesForPatientFileInBackground()

                    self.xcgLogMsg("\(sCurrMethodDisp) <1st Run> Called  'self.gatherJmAppParsePFQueriesForPatientFileInBackground()' to gather PatientFile data...")

                }

            // ------------------------------------------------------------------------------------------------------------------
            //
            //  // After a 6/10th of a second delay (for location information gathering), display the list of item(s)...
            //
            //  DispatchQueue.main.asyncAfter(deadline:(.now() + 0.6))
            //  {
            //
            //      self.displayListPFCscDataItems()
            //
            //  //  self.xcgLogMsg("\(sCurrMethodDisp) Displaying the list of 'parsePFCscDataItem' item(s)...")
            //  //
            //  //  for parsePFCscDataItem in self.listPFCscDataItems
            //  //  {
            //  //
            //  //      parsePFCscDataItem.displayParsePFCscDataItemToLog()
            //  //
            //  //  }
            //
            //  }
            //
            // ------------------------------------------------------------------------------------------------------------------
                
            }
            else
            {

                self.xcgLogMsg("\(sCurrMethodDisp) Parse - query of 'pfQueryCSC' returned an 'empty' or nil list of PFObject(s) for ALL TID(s) in the last day...")

            }
            
        }
        catch
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Parse - failed execute the query 'pfQueryCSC' - Details: \(error) - Error!")
            
        }

        // ----------------------------------------------------------------------------------------------------------------------
        //  var listPFCscDataItems:[ParsePFCscDataItem] = []
        // ----------------------------------------------------------------------------------------------------------------------

        if (self.listPFCscDataItems.count > 0)
        {

            // If we have a different # of item(s) then the ParseCoreManager does, then deep copy and update it...

            if (self.jmAppParseCoreManager.listPFCscDataItems.count  < 1 ||
                self.jmAppParseCoreManager.listPFCscDataItems.count != self.listPFCscDataItems.count)
            {

                let _ = self.deepCopyListPFCscDataItems()
            
            }

        }

        // ----------------------------------------------------------------------------------------------------------------------
        //  var listPFCscNameItems:[String] = []
        // ----------------------------------------------------------------------------------------------------------------------

        if (self.listPFCscNameItems.count > 0)
        {

            // If we have a different # of item(s) then the ParseCoreManager does, then deep copy and update it...

            if (self.jmAppParseCoreManager.listPFCscNameItems.count  < 1 ||
                self.jmAppParseCoreManager.listPFCscNameItems.count != self.listPFCscNameItems.count)
            {

                let _ = self.deepCopyListPFCscNameItems()
            
            }

        }

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
    
        return

    } // End of public func getJmAppParsePFQueryForCSC().

    public func copyJmAppParsePFAdminsToSwiftData()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Copy (if any) PFQuery 'Admins' to SwiftData...

        if (self.dictPFAdminsDataItems.count > 0)
        {

            if (self.jmAppSwiftDataManager.modelContext != nil)
            {

            //  let pfAdminsSwiftDataItemsDescriptor = FetchDescriptor<PFAdminsSwiftDataItem>()

                DispatchQueue.main.async
                {

                    do
                    {

                    // ------------------------------------------------------------------------------------------------------------------
                    //  let pfAdminsSwiftDataItems:[PFAdminsSwiftDataItem] = try self.jmAppSwiftDataManager.modelContext!.fetch(pfAdminsSwiftDataItemsDescriptor)
                    //  let cPFAdminsSwiftDataItems:Int                    = pfAdminsSwiftDataItems.count
                    //
                    //  if (cPFAdminsSwiftDataItems > 0)
                    // ------------------------------------------------------------------------------------------------------------------

                        if (self.jmAppSwiftDataManager.pfAdminsSwiftDataItems.count > 0)
                        {

                            self.xcgLogMsg("\(sCurrMethodDisp) Deleting ALL #(\(self.jmAppSwiftDataManager.pfAdminsSwiftDataItems.count)) existing SwiftData PFQuery 'Admins' item(s)...")

                            try self.jmAppSwiftDataManager.modelContext!.delete(model:PFAdminsSwiftDataItem.self)

                            self.xcgLogMsg("\(sCurrMethodDisp) Deleted  ALL #(\(self.jmAppSwiftDataManager.pfAdminsSwiftDataItems.count)) existing SwiftData PFQuery 'Admins' item(s)...")

                        }
                        else
                        {

                            self.xcgLogMsg("\(sCurrMethodDisp) Skipping the deletion of ALL existing SwiftData PFQuery 'Admins' item(s) - there are NO existing item(s)...")

                        }

                    } 
                    catch
                    {

                        self.xcgLogMsg("\(sCurrMethodDisp) Failed to delete ALL SwiftData PFQuery 'Admins' items() - Details: \(error) - Error!")

                    }

                    self.xcgLogMsg("\(sCurrMethodDisp) Copying (\(self.dictPFAdminsDataItems.count)) PFQuery 'Admins' item(s) to SwiftData...")

                    var cPFAdminsDataItemsAdded:Int = 0

                    for (_, parsePFAdminsDataItem) in self.dictPFAdminsDataItems
                    {

                        let newPFAdminsSwiftDataItem = PFAdminsSwiftDataItem(timestamp:   Date(),
                                                                             sCreatedBy:  "\(ClassInfo.sClsDisp)",
                                                                             pfAdminsItem:parsePFAdminsDataItem)

                        self.jmAppSwiftDataManager.addAppSwiftDataItem(pfAdminsSwiftDataItem:newPFAdminsSwiftDataItem, 
                                                                       bShowDetailAfterAdd:  false)

                        self.xcgLogMsg("\(sCurrMethodDisp) Added 'newPFAdminsSwiftDataItem' of [\(String(describing: newPFAdminsSwiftDataItem.toString()))] to the SwiftDataManager...")

                        cPFAdminsDataItemsAdded += 1

                    }

                    self.xcgLogMsg("\(sCurrMethodDisp) Added #(\(cPFAdminsDataItemsAdded)) PFQuery 'Admins' item(s) to SwiftData from #(\(self.dictPFAdminsDataItems.count)) available item(s)...")

                    self.jmAppSwiftDataManager.saveAppSwiftData()

                    self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager has been signalled to 'save' SwiftData for PFQuery 'Admins' item(s)...")

                    self.xcgLogMsg("\(sCurrMethodDisp) Invoking 'self.jmAppSwiftDataManager.detailAppSwiftDataToLog()'...")

                    self.jmAppSwiftDataManager.detailAppSwiftDataToLog()

                    self.xcgLogMsg("\(sCurrMethodDisp) Invoked  'self.jmAppSwiftDataManager.detailAppSwiftDataToLog()'...")

                }

            }
            else
            {

                self.xcgLogMsg("\(sCurrMethodDisp) Copy failed - 'self.jmAppSwiftDataManager?.modelContent' is nil - NO 'target' to copy (\(self.dictPFAdminsDataItems.count)) item(s) too - Warning!")

            }

        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Copy failed - 'self.dictPFAdminsDataItems' has NO PFQuery 'Admins' item(s) - Warning!")
            
        }

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
    
        return

    } // End of public func copyJmAppParsePFAdminsToSwiftData().

    public func gatherJmAppParsePFQueriesForScheduledLocationsInBackground(bForceReloadOfPFQuery:Bool = false)
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'bForceReloadOfPFQuery' is [\(bForceReloadOfPFQuery)]...")
  
        let dispatchGroup = DispatchGroup()

        do
        {

            dispatchGroup.enter()

            let dispatchQueue = DispatchQueue(label: "GatherAppPFQueriesForSchedLocInBackground", qos: .userInitiated)

            dispatchQueue.async
            {

                self.xcgLogMsg("\(sCurrMethodDisp) Invoking background PFQueries method(s)...");

                self.xcgLogMsg("\(sCurrMethodDisp) Calling PFQuery to construct an instance for the 'PatientCalDay' class...")

                self.gatherJmAppParsePFQueriesForPatientCalDayInBackground(bForceReloadOfPFQuery:bForceReloadOfPFQuery)

                self.xcgLogMsg("\(sCurrMethodDisp) Called  PFQuery to construct an instance for the 'PatientCalDay' class...")

                self.xcgLogMsg("\(sCurrMethodDisp) Calling PFQuery to construct an instance for the 'BackupVisit' class...")

                self.gatherJmAppParsePFQueriesForBackupVisitInBackground(bForceReloadOfPFQuery:bForceReloadOfPFQuery)

                self.xcgLogMsg("\(sCurrMethodDisp) Called  PFQuery to construct an instance for the 'BackupVisit' class...")

            }

            dispatchGroup.leave()

        }

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return

    } // End of public func gatherJmAppParsePFQueriesForScheduledLocationsInBackground(bForceReloadOfPFQuery:Bool).
    
    public func gatherJmAppParsePFQueriesForPatientInfoInBackground(bForceReloadOfPFQuery:Bool = false)
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'bForceReloadOfPFQuery' is [\(bForceReloadOfPFQuery)]...")
  
        let dispatchGroup = DispatchGroup()

        do
        {

            dispatchGroup.enter()

            let dispatchQueue = DispatchQueue(label: "GatherAppPFQueriesForPatInfoInBackground", qos: .userInitiated)

            dispatchQueue.async
            {

                self.xcgLogMsg("\(sCurrMethodDisp) Invoking background PFQueries method(s)...");

                self.xcgLogMsg("\(sCurrMethodDisp) Calling PFQuery to construct an instance for the 'PatientFile' class...")

                self.gatherJmAppParsePFQueriesForPatientFileInBackground(bForceReloadOfPFQuery:bForceReloadOfPFQuery)

                self.xcgLogMsg("\(sCurrMethodDisp) Called  PFQuery to construct an instance for the 'PatientFile' class...")

            }

            dispatchGroup.leave()

        }

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return

    } // End of public func gatherJmAppParsePFQueriesForPatientInfoInBackground(bForceReloadOfPFQuery:Bool).
    
    public func gatherJmAppParsePFQueriesForPatientCalDayInBackground(bForceReloadOfPFQuery:Bool = false)
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'bForceReloadOfPFQuery' is [\(bForceReloadOfPFQuery)]...")
  
        // Issue a PFQueries to pull Therapist data from PatientCalDay for the current day...

        let dtFormatterDate:DateFormatter = DateFormatter()

        dtFormatterDate.locale     = Locale(identifier: "en_US")
        dtFormatterDate.timeZone   = TimeZone.current
        dtFormatterDate.dateFormat = "yyyy-MM-dd"

        let dateForCurrentQuery:Date = Date.now
        let sCurrentQueryDate:String = dtFormatterDate.string(from:dateForCurrentQuery)

        self.xcgLogMsg("\(sCurrMethodDisp) 'sCurrentQueryDate' is [\(String(describing: sCurrentQueryDate))] <formatted>...")

        // If we have item(s) in the 'dictSchedPatientLocItems' dictionary, then repopulate them with PatientCalDay information...

        if (self.dictSchedPatientLocItems.count > 0)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Enumerating the dictionary of #(\(self.dictSchedPatientLocItems.count)) 'dictSchedPatientLocItems' item(s) to gather 'PatientCalDay' information...")

            let cPFTherapistTotalTIDs:Int = self.dictSchedPatientLocItems.count
            var cPFTherapistParseTIDs:Int = 0

            for (sPFTherapistParseTID, listOfOldScheduledPatientLocationItems) in self.dictSchedPatientLocItems
            {

                cPFTherapistParseTIDs += 1

                if (sPFTherapistParseTID.count  < 1 ||
                    sPFTherapistParseTID       == "-N/A-")
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cPFTherapistParseTIDs)) 'sPFTherapistParseTID' - the 'tid' field is nil or '-N/A-' - Warning!")

                    continue

                }

                let iPFTherapistParseTID:Int = Int(sPFTherapistParseTID) ?? -1

                if (iPFTherapistParseTID < 0)
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cPFTherapistParseTIDs)) 'iPFTherapistParseTID' - 'sPFTherapistParseTID' is [\(sPFTherapistParseTID)] - the 'tid' field (Int) is less than 0 - Warning!")

                    continue

                }

                let pfTherapistFileItem:ParsePFTherapistFileItem? = self.dictPFTherapistFileItems[iPFTherapistParseTID]

                if (pfTherapistFileItem == nil)
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cPFTherapistParseTIDs)) 'pfTherapistFileItem' - 'sPFTherapistParseTID' is [\(sPFTherapistParseTID)] - the 'pfTherapistFileItem' is nil - unable to locate the TherapistFile item - Warning!")

                    continue

                }

                if (pfTherapistFileItem!.bPFTherapistFileNotActive == true)
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cPFTherapistParseTIDs)) 'pfTherapistFileItem.bPFTherapistFileNotActive' - 'sPFTherapistParseTID' is [\(sPFTherapistParseTID)] - the 'pfTherapistFileItem.bPFTherapistFileNotActive' flag is True - the Therapist is NOT 'active'...")

                    continue

                }

                if (listOfOldScheduledPatientLocationItems.count < 1)
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cPFTherapistTotalTIDs)) 'sPFTherapistParseTID' of [\(sPFTherapistParseTID)] - the 'listOfOldScheduledPatientLocationItems' field is nil or the count is less than 1 - Warning!")

                    continue

                }

                // 'listOfOldScheduledPatientLocationItems' has at least 1 item (added as a 'placeholder' when the 'dictSchedPatientLocItems' was built.
                // Grab the 1st item in the list to use as a 'template' object and then clear the list (to be rebuilt)...

                let scheduledPatientLocationItemTemplate:ScheduledPatientLocationItem = listOfOldScheduledPatientLocationItems[0]
                var listScheduledPatientLocationItems:[ScheduledPatientLocationItem]  = [ScheduledPatientLocationItem]()

                // Issue a PFQuery for the 'PatientCalDay' class...

                self.xcgLogMsg("\(sCurrMethodDisp) Calling PFQuery to construct an instance for the 'PatientCalDay' class...")

                let pfQueryPatientCalDay:PFQuery = PFQuery(className:"PatientCalDay")

                self.xcgLogMsg("\(sCurrMethodDisp) Called  PFQuery to construct an instance for the 'PatientCalDay' class...")

                // Set the query parameter(s) and issue the 'find' then (possibly) iterate the result(s)...

                self.xcgLogMsg("\(sCurrMethodDisp) Returned query of 'pfQueryPatientCalDay' is [\(String(describing: pfQueryPatientCalDay))]...")

                do
                {

                //  "class" : "select * from PatientCalDay where tid = 261 and VDate = \"2024-12-03\";",

                    pfQueryPatientCalDay.whereKeyExists("pid")
                    pfQueryPatientCalDay.whereKeyExists("startTime")

                    pfQueryPatientCalDay.whereKey("tid",   equalTo:Int(sPFTherapistParseTID) as Any)
                    pfQueryPatientCalDay.whereKey("VDate", equalTo:sCurrentQueryDate)

                //  pfQueryPatientCalDay.addAscendingOrder("startTime")

                    pfQueryPatientCalDay.limit = 2000

                    let listPFPatientCalDayObjects:[PFObject]? = try pfQueryPatientCalDay.findObjects()

                    if (listPFPatientCalDayObjects != nil &&
                        listPFPatientCalDayObjects!.count > 0)
                    {

                        self.xcgLogMsg("\(sCurrMethodDisp) Parse - query of 'pfQueryPatientCalDay' returned a count of #(\(listPFPatientCalDayObjects!.count)) PFObject(s) for the TID of [\(sPFTherapistParseTID)]...")
                        self.xcgLogMsg("\(sCurrMethodDisp) Enumerating the result(s) of query of 'pfQueryPatientCalDay'...")

                        var cPFPatientCalDayObjects:Int = 0

                        for pfPatientCalDayObject in listPFPatientCalDayObjects!
                        {

                            cPFPatientCalDayObjects += 1

                            let scheduledPatientLocationItem:ScheduledPatientLocationItem =
                                    ScheduledPatientLocationItem(scheduledPatientLocationItem:scheduledPatientLocationItemTemplate)

                            scheduledPatientLocationItem.updateScheduledPatientLocationItemFromPFPatientCalDay(pfPatientCalDayItem:pfPatientCalDayObject)

                            if (scheduledPatientLocationItem.sPid.count > 0)
                            {
                            
                                if (self.dictPFPatientFileItems.count                               > 0 &&
                                    self.dictPFPatientFileItems[scheduledPatientLocationItem.iPid] != nil)
                                {

                                    scheduledPatientLocationItem.updateScheduledPatientLocationItemFromPFPatientFile(pfPatientFileItem:self.dictPFPatientFileItems[scheduledPatientLocationItem.iPid]!)

                                }
                            
                            }

                            listScheduledPatientLocationItems.append(scheduledPatientLocationItem)

                            self.xcgLogMsg("\(sCurrMethodDisp) Added an updated Item #(\(cPFPatientCalDayObjects)) 'scheduledPatientLocationItem' of [\(scheduledPatientLocationItem)] to the list 'listScheduledPatientLocationItems' for 'sPFTherapistParseTID' of [\(sPFTherapistParseTID)]...")

                        }

                        if (cPFPatientCalDayObjects > 0)
                        {

                            if (cPFPatientCalDayObjects > 1)
                            {

                                self.xcgLogMsg("\(sCurrMethodDisp) Sorting #(\(cPFPatientCalDayObjects)) Item(s) in the 'listScheduledPatientLocationItems' of [\(listScheduledPatientLocationItems)] for 'sPFTherapistParseTID' of [\(sPFTherapistParseTID)]...")

                                listScheduledPatientLocationItems.sort
                                { (scheduledPatientLocationItem1, scheduledPatientLocationItem2) in

                                //  Compare for Sort: '<' sorts 'ascending' and '>' sorts 'descending'...

                                //  let bIsItem1GreaterThanItem2:Bool = (scheduledPatientLocationItem1.iVDateStartTime24h > scheduledPatientLocationItem2.iVDateStartTime24h)
                                    let bIsItem1GreaterThanItem2:Bool = (scheduledPatientLocationItem1.iVDateStartTime24h < scheduledPatientLocationItem2.iVDateStartTime24h)

                                //  self.xcgLogMsg("\(sCurrMethodDisp) Sort <OP> Returning 'bIsItem1GreaterThanItem2' of [\(bIsItem1GreaterThanItem2)] because 'scheduledPatientLocationItem1.iVDateStartTime24h' is [\(scheduledPatientLocationItem1.iVDateStartTime24h)] and is less than 'scheduledPatientLocationItem2.iVDateStartTime24h' is [\(scheduledPatientLocationItem2.iVDateStartTime24h)] for 'sPFTherapistParseTID' of [\(sPFTherapistParseTID)]...")

                                    return bIsItem1GreaterThanItem2

                                }

                                self.xcgLogMsg("\(sCurrMethodDisp) Sorted  #(\(cPFPatientCalDayObjects)) Item(s) in the 'listScheduledPatientLocationItems' of [\(listScheduledPatientLocationItems)] for 'sPFTherapistParseTID' of [\(sPFTherapistParseTID)]...")

                            }
                        
                            self.dictSchedPatientLocItems[sPFTherapistParseTID] = listScheduledPatientLocationItems

                            self.xcgLogMsg("\(sCurrMethodDisp) Added #(\(cPFPatientCalDayObjects)) updated Item(s) to the 'listScheduledPatientLocationItems' of [\(listScheduledPatientLocationItems)] to the dictionary of 'dictSchedPatientLocItems' item(s) keyed by 'sPFTherapistParseTID' of [\(sPFTherapistParseTID)]...")
                        
                        }

                    }
                    else
                    {

                        self.xcgLogMsg("\(sCurrMethodDisp) Parse - query of 'pfQueryPatientCalDay' returned an 'empty' or nil list of PFObject(s) for the TID of [\(sPFTherapistParseTID)]...")

                    }

                }
                catch
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) Parse - failed execute the query 'pfQueryPatientCalDay' - Details: \(error) - Error!")

                }

            }

        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Unable to enumerate the dictionary of 'dictSchedPatientLocItems' item(s) - item(s) count is less than 1 - Warning!")

        }

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return

    } // End of public func gatherJmAppParsePFQueriesForPatientCalDayInBackground(bForceReloadOfPFQuery:Bool).
    
    public func gatherJmAppParsePFQueriesForBackupVisitInBackground(bForceReloadOfPFQuery:Bool = false)
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'bForceReloadOfPFQuery' is [\(bForceReloadOfPFQuery)]...")
  
        // ------------------------------------------------------------------------------------------------------------------
        //
        // Issue a PFQueries to pull Patient (Visit) data from BackupVisit for the last 30 day(s)...
        //     :: From PFQuery Class: 'BackupVisit' ::
        //
        //     [Query::{ "pid"            : NumberLong(13556), 
        //               "billable"       : NumberLong(1), 
        //               "isTelepractice" : { "$ne" : NumberLong(1) },
        //               "VDate"          : { "$gt" : "2024-11-10" } }]  // Yields all visit(s) in last 30 day(s) or such...
        //     [Sort::{"VDate": -1}]                                     // Yields visit(s) newest to oldest (1st one is newest)...
        //
        // ------------------------------------------------------------------------------------------------------------------

        let dtFormatterDate:DateFormatter = DateFormatter()

        dtFormatterDate.locale     = Locale(identifier: "en_US")
        dtFormatterDate.timeZone   = TimeZone.current
        dtFormatterDate.dateFormat = "yyyy-MM-dd"

        let dateForCurrentQuery:Date = Calendar.current.date(byAdding: .day, value: -30, to: .now)!
        let sCurrentQueryDate:String = dtFormatterDate.string(from:dateForCurrentQuery)

        self.xcgLogMsg("\(sCurrMethodDisp) 'sCurrentQueryDate' is [\(String(describing: sCurrentQueryDate))] <formatted>...")

        // If we have item(s) in the 'dictSchedPatientLocItems' dictionary, then repopulate them with BackupVisit information...

        if (self.dictSchedPatientLocItems.count > 0)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Enumerating the dictionary of #(\(self.dictSchedPatientLocItems.count)) 'dictSchedPatientLocItems' item(s) to gather 'BackupVisit' information...")

            let cPFTherapistTotalTIDs:Int = self.dictSchedPatientLocItems.count
            var cPFTherapistParseTIDs:Int = 0

            for (sPFTherapistParseTID, listOfScheduledPatientLocationItems) in self.dictSchedPatientLocItems
            {

                cPFTherapistParseTIDs += 1

                if (sPFTherapistParseTID.count  < 1 ||
                    sPFTherapistParseTID       == "-N/A-")
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cPFTherapistParseTIDs)) 'sPFTherapistParseTID' - the 'tid' field is nil or '-N/A-' - Warning!")

                    continue

                }

                if (listOfScheduledPatientLocationItems.count < 1)
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cPFTherapistTotalTIDs)) 'sPFTherapistParseTID' of [\(sPFTherapistParseTID)] - the 'listOfScheduledPatientLocationItems' field is nil or the count is less than 1 - Warning!")

                    continue

                }

                var cPFPatientParsePIDs:Int = 0 

                for scheduledPatientLocationItem in listOfScheduledPatientLocationItems
                {

                    cPFPatientParsePIDs += 1 

                    if (scheduledPatientLocationItem.iPid < 1)
                    {
                    
                        self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cPFPatientParsePIDs)) for 'sPFTherapistParseTID' of [\(sPFTherapistParseTID)] - the patient 'pid' field ('iPid') is < 1 - Warning!")

                        continue
                    
                    }
                    
                    // Issue a PFQuery for the 'BackupVisit' class...

                    self.xcgLogMsg("\(sCurrMethodDisp) Calling PFQuery to construct an instance for the 'BackupVisit' class...")

                    let pfQueryBackupVisit:PFQuery = PFQuery(className:"BackupVisit")

                    self.xcgLogMsg("\(sCurrMethodDisp) Called  PFQuery to construct an instance for the 'BackupVisit' class...")

                    // Set the query parameter(s) and issue the 'find' then (possibly) iterate the result(s)...

                    self.xcgLogMsg("\(sCurrMethodDisp) Returned query of 'pfQueryBackupVisit' is [\(String(describing: pfQueryBackupVisit))]...")

                    do
                    {

                    // ------------------------------------------------------------------------------------------------------------------
                    //  :: From PFQuery Class: 'BackupVisit' ::
                    //
                    //  [Query::{ "pid"            : NumberLong(13556), 
                    //            "billable"       : NumberLong(1), 
                    //            "isTelepractice" : { "$ne" : NumberLong(1) },
                    //            "VDate"          : { "$gt" : "2024-11-10" } }]  // Yields all visit(s) in last 30 day(s) or such...
                    //  [Sort::{"VDate": -1}]                                     // Yields visit(s) newest to oldest (1st one is newest)...
                    // ------------------------------------------------------------------------------------------------------------------

                        self.xcgLogMsg("\(sCurrMethodDisp) Searching for 'pfQueryBackupVisit' Item(s) keyed by 'sPFTherapistParseTID' of [\(sPFTherapistParseTID)] for PID (\(scheduledPatientLocationItem.iPid))...")

                        pfQueryBackupVisit.whereKeyExists("lat")
                        pfQueryBackupVisit.whereKeyExists("long")

                        pfQueryBackupVisit.whereKey("pid",            equalTo:scheduledPatientLocationItem.iPid)
                        pfQueryBackupVisit.whereKey("billable",       equalTo:1)
                        pfQueryBackupVisit.whereKey("isTelepractice", notEqualTo:1)
                        pfQueryBackupVisit.whereKey("VDate",          greaterThan:sCurrentQueryDate)

                        pfQueryBackupVisit.addDescendingOrder("VDate")

                        pfQueryBackupVisit.limit = 1000

                        let listPFBackupVisitObjects:[PFObject]? = try pfQueryBackupVisit.findObjects()

                        if (listPFBackupVisitObjects != nil &&
                            listPFBackupVisitObjects!.count > 0)
                        {

                            self.xcgLogMsg("\(sCurrMethodDisp) Parse - query of 'pfQueryBackupVisit' returned a count of #(\(listPFBackupVisitObjects!.count)) PFObject(s) for PID (\(scheduledPatientLocationItem.iPid))...")
                            self.xcgLogMsg("\(sCurrMethodDisp) Using the 1st returned 'pfQueryBackupVisit' item...")

                            // ------------------------------------------------------------------------------------------------
                            //  >>> Template 1st entry, then search for new Template
                            //  >>>     (if item(s) are available and address == ""),
                            //  >>> to re-Template an item that is address != ""; and posted = 1;...
                            // ------------------------------------------------------------------------------------------------

                            var pfQueryBackupVisitTemplate = listPFBackupVisitObjects![0]

                            if (listPFBackupVisitObjects!.count > 1 &&
                                String(describing: (pfQueryBackupVisitTemplate.object(forKey:"address"))) == "")
                            {

                                for pfBackupVisit in listPFBackupVisitObjects!
                                {

                                    if (String(describing: (pfBackupVisit.object(forKey:"address"))) != "" &&
                                        String(describing: (pfBackupVisit.object(forKey:"posted")))  == "1")
                                    {

                                        pfQueryBackupVisitTemplate = pfBackupVisit
                                        
                                        break;
                                    
                                    }

                                }

                            }

                            scheduledPatientLocationItem.updateScheduledPatientLocationItemFromPFBackupVisit(pfBackupVisit:pfQueryBackupVisitTemplate)

                            if (scheduledPatientLocationItem.sLastVDateAddress == "")
                            {

                                self.xcgLogMsg("\(sCurrMethodDisp) Updating 'scheduledPatientLocationItem' by calling 'updateGeocoderLocation()' for Latitude/Longitude of [\(scheduledPatientLocationItem.sLastVDateLatitude)/\(scheduledPatientLocationItem.sLastVDateLongitude)]...")

                                if (self.jmAppDelegateVisitor!.jmAppCLModelObservable2 != nil)
                                {
                                
                                    let clModelObservable2:CoreLocationModelObservable2 = self.jmAppDelegateVisitor!.jmAppCLModelObservable2!
                                    let dblDeadlineInterval:Double                      = clModelObservable2.requestNextReverseLocationLookupDeadlineInterval(clRevLocType:CLRevLocType.tertiary)

                                    DispatchQueue.main.asyncAfter(deadline:(.now() + dblDeadlineInterval))
                                    {
                                        self.xcgLogMsg("\(sCurrMethodDisp) <closure> Calling 'updateGeocoderLocation()'with 'self' of [\(String(describing: self))] for Latitude/Longitude of [\(scheduledPatientLocationItem.sLastVDateLatitude)/\(scheduledPatientLocationItem.sLastVDateLongitude)] from 'scheduledPatientLocationItem' for Patient named [\(scheduledPatientLocationItem.sPtName)]...")

                                        let _ = clModelObservable2.updateGeocoderLocations(requestID: 1, 
                                                                                           latitude:  Double(scheduledPatientLocationItem.sLastVDateLatitude)!,
                                                                                           longitude: Double(scheduledPatientLocationItem.sLastVDateLongitude)!, 
                                                                                           withCompletionHandler:
                                                                                               { (requestID:Int, dictCurrentLocation:[String:Any]) in

                                                                                                   let sStreetAddress:String = String(describing: (dictCurrentLocation["sCurrentLocationName"]       ?? ""))
                                                                                                   let sCity:String          = String(describing: (dictCurrentLocation["sCurrentCity"]               ?? ""))
                                                                                                   let sState:String         = String(describing: (dictCurrentLocation["sCurrentAdministrativeArea"] ?? ""))
                                                                                                   let sZipCode:String       = String(describing: (dictCurrentLocation["sCurrentPostalCode"]         ?? ""))

                                                                                                   if (sStreetAddress.count < 1 ||
                                                                                                       sCity.count          < 1)
                                                                                                   {
                                                                                                       
                                                                                                       scheduledPatientLocationItem.sLastVDateAddress = ""
                                                                                                   
                                                                                                   }
                                                                                                   else
                                                                                                   {

                                                                                                       scheduledPatientLocationItem.sLastVDateAddress = "\(sStreetAddress), \(sCity), \(sState), \(sZipCode)"

                                                                                                   }

                                                                                                   self.xcgLogMsg("\(sCurrMethodDisp) Updated 'scheduledPatientLocationItem' for an address of [\(scheduledPatientLocationItem.sLastVDateAddress)] for Latitude/Longitude of [\(scheduledPatientLocationItem.sLastVDateLatitude)/\(scheduledPatientLocationItem.sLastVDateLongitude)]...")

                                                                                               }
                                                                                          )
                                    }

                                }

                            }

                            self.xcgLogMsg("\(sCurrMethodDisp) Updated an Item 'scheduledPatientLocationItem' of [\(scheduledPatientLocationItem)] (in a List) to the dictionary of 'dictSchedPatientLocItems' item(s) keyed by 'sPFTherapistParseTID' of [\(sPFTherapistParseTID)] for PID (\(scheduledPatientLocationItem.iPid))...")

                        }
                        else
                        {

                            self.xcgLogMsg("\(sCurrMethodDisp) Parse - query of 'pfQueryBackupVisit' returned an 'empty' or nil list of PFObject(s) for PID (\(scheduledPatientLocationItem.iPid))...")

                        }

                    }
                    catch
                    {

                        self.xcgLogMsg("\(sCurrMethodDisp) Parse - failed execute the query 'pfQueryBackupVisit' - Details: \(error) - Error!")

                    }

                }

            }

        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Unable to enumerate the dictionary of 'dictSchedPatientLocItems' item(s) - item(s) count is less than 1 - Warning!")

        }

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return

    } // End of public func gatherJmAppParsePFQueriesForBackupVisitInBackground(bForceReloadOfPFQuery:Bool).
    
    public func gatherJmAppParsePFQueriesForPatientFileInBackground(bForceReloadOfPFQuery:Bool = false)
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'bForceReloadOfPFQuery' is [\(bForceReloadOfPFQuery)]...")
  
        // Issue a PFQuery for the 'PatientFile' class...

        self.xcgLogMsg("\(sCurrMethodDisp) Calling PFQuery to construct an instance for the 'PatientFile' class...")

        let pfQueryPatient:PFQuery = PFQuery(className:"PatientFile")

        self.xcgLogMsg("\(sCurrMethodDisp) Called  PFQuery to construct an instance for the 'PatientFile' class...")

        // Set the query parameter(s) and issue the 'find' then (possibly) iterate the result(s)...

        self.xcgLogMsg("\(sCurrMethodDisp) Returned query of 'pfQueryPatient' is [\(String(describing: pfQueryPatient))]...")

        do
        {

        // Query => db.getCollection("PatientFile").find({$and: [{"discharged": {$ne: 1}}, {"expectedVisits": {$gte: 1}}]})
            
            pfQueryPatient.whereKeyExists("ID")
            pfQueryPatient.whereKeyExists("discharged")
            pfQueryPatient.whereKeyExists("expectedVisits")
        //  pfQueryPatient.whereKeyExists("name")
        //
        //  pfQueryPatient.whereKey("discharged",     notEqualTo:1)
        //  pfQueryPatient.whereKey("expectedVisits", greaterThanOrEqualTo:1)
            
            pfQueryPatient.limit = 3000
            
            let listPFPatientObjects:[PFObject]? = try pfQueryPatient.findObjects()
            
            if (listPFPatientObjects        != nil &&
                listPFPatientObjects!.count  > 0)
            {
                
                self.xcgLogMsg("\(sCurrMethodDisp) Parse - query of 'pfQueryPatient' returned a count of #(\(listPFPatientObjects!.count)) PFObject(s) for ALL PID(s) not 'discharged' and with 'expectedVisits' > 0...")
                self.xcgLogMsg("\(sCurrMethodDisp) Enumerating the result(s) of query of 'pfQueryPatient'...")
          
                var cPFPatientObjects:Int   = 0
          
                let clModelObservable2:CoreLocationModelObservable2 = self.jmAppDelegateVisitor!.jmAppCLModelObservable2!
          
                clModelObservable2.resetNextReverseLocationLookupDeadlineInterval(clRevLocType:CLRevLocType.tertiary)
          
                for pfPatientObject in listPFPatientObjects!
                {
          
                    cPFPatientObjects += 1
          
                    let sPFPatientParseFirstName:String = String(describing: (pfPatientObject.object(forKey:"firstName") ?? "-N/A-"))
                    let sPFPatientParseLastName:String  = String(describing: (pfPatientObject.object(forKey:"lastName")  ?? "-N/A-"))
                    var sPFPatientParseName:String      = String(describing: (pfPatientObject.object(forKey:"name")      ?? "-N/A-"))
                    let sPFPatientParsePID:String       = String(describing: (pfPatientObject.object(forKey:"ID")        ?? "-N/A-"))
          
                    if (sPFPatientParsePID.count  < 1 ||
                        sPFPatientParsePID       == "-N/A-")
                    {
          
                        self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cPFPatientObjects)) 'pfPatientObject' for 'sPFPatientParseName' of [\(sPFPatientParseName)] - the 'PID' field is nil or '-N/A-' - Warning!")
          
                        continue
          
                    }
          
          
                    let iPFPatientParsePID:Int = Int(sPFPatientParsePID) ?? -1
          
                    if (iPFPatientParsePID < 0)
                    {
          
                        self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cPFPatientObjects)) 'pfPatientObject' for 'sPFPatientParseName' of [\(sPFPatientParseName)] - the 'PID' field (Int) is less than 0 - Warning!")
          
                        continue
          
                    }
          
                    if (sPFPatientParseName.count  < 1 ||
                        sPFPatientParseName       == "-N/A-")
                    {
          
                        self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cPFPatientObjects)) 'pfPatientObject' has 'sPFPatientParseName' of [\(sPFPatientParseName)] - the 'name' field is nil or '-N/A-' - attempting to use first/last name(s) - Warning!")

                        if (sPFPatientParseFirstName.count  > 0       &&
                            sPFPatientParseFirstName       != "-N/A-" &&
                            sPFPatientParseLastName.count   > 0       &&
                            sPFPatientParseLastName        != "-N/A-")
                        {

                            sPFPatientParseName = "\(sPFPatientParseLastName),\(sPFPatientParseFirstName)"

                        }
                        else
                        {

                            self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cPFPatientObjects)) 'pfPatientObject' has 'sPFPatientParseName' of [\(sPFPatientParseName)] - the 'name' field is nil or '-N/A-' - unable to calculate a name from first/last name(s) - Error!")
          
                            continue

                        }
          
                    }
          
                    // Build the PID/PatientName Xref dictionary...
          
                    let sPFPatientParseNameLower:String                   = sPFPatientParseName.lowercased()
            
            //  //  let listPFPatientParseNameLowerBase:[String]          = sPFPatientParseNameLower.components(separatedBy:CharacterSet.illegalCharacters)
            //  //  let sPFPatientParseNameLowerBaseJoined:String         = listPFPatientParseNameLowerBase.joined(separator:"")
            //  //  let listPFPatientParseNameLowerNoWS:[String]          = sPFPatientParseNameLowerBaseJoined.components(separatedBy:CharacterSet.whitespacesAndNewlines)
            //  //  let sPFPatientParseNameLowerNoWS:String               = listPFPatientParseNameLowerNoWS.joined(separator:"")
            //
            //      var csUnwantedDelimiters:CharacterSet = CharacterSet()
            //
            //      csUnwantedDelimiters = csUnwantedDelimiters.union(CharacterSet.illegalCharacters)
            //      csUnwantedDelimiters = csUnwantedDelimiters.union(CharacterSet.whitespacesAndNewlines)
            //      csUnwantedDelimiters = csUnwantedDelimiters.union(CharacterSet.punctuationCharacters)
            //
            //      let listPFPatientParseNameLowerNoWS:[String]          = sPFPatientParseNameLower.components(separatedBy:csUnwantedDelimiters)
            //      let sPFPatientParseNameLowerNoWS:String               = listPFPatientParseNameLowerNoWS.joined(separator:"")

                    let sPFPatientParseNameLowerNoWS:String               = sPFPatientParseName.removeUnwantedCharacters(charsetToRemove:[StringCleaning.removeAll], bResultIsLowerCased:true)

                    self.dictPatientPidXref[sPFPatientParsePID]           = sPFPatientParseName
                    self.dictPatientPidXref[sPFPatientParseName]          = sPFPatientParsePID
                    self.dictPatientPidXref[sPFPatientParseNameLower]     = sPFPatientParsePID
                    self.dictPatientPidXref[sPFPatientParseNameLowerNoWS] = sPFPatientParsePID

                    // Track the Patient in the dictionary of PatientFile item(s)...
          
                    let pfPatientFileItem:ParsePFPatientFileItem          = ParsePFPatientFileItem()
          
                    pfPatientFileItem.constructParsePFPatientFileItemFromPFObject(idPFPatientFileObject:cPFPatientObjects, pfPatientFileObject:pfPatientObject)
          
                    self.dictPFPatientFileItems[iPFPatientParsePID]       = pfPatientFileItem
          
                    self.xcgLogMsg("\(sCurrMethodDisp) Added an Item keyed by 'iPFPatientParsePID' of [\(iPFPatientParsePID)] for 'sPFPatientParseName' of [\(sPFPatientParseName)] added an Item 'pfPatientFileItem' of [\(pfPatientFileItem.toString())] to the dictionary of 'dictPFPatientFileItems' item(s)...")
          
                }
                
            }
            else
            {
          
                self.xcgLogMsg("\(sCurrMethodDisp) Parse - query of 'pfQueryPatient' returned a count of #(\(listPFPatientObjects!.count)) PFObject(s) for ALL PID(s) not 'discharged' and with 'expectedVisits' > 0 - Error!")
          
            }
            
        }
        catch
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Parse - failed execute the query 'pfQueryPatient' - Details: \(error) - Error!")
            
        }

        // ----------------------------------------------------------------------------------------------------------------------
        //  var dictPatientPidXref:[String:String] = [String:String]()
        //                                           // [String:String]
        //                                           // Key:Pid(String)                             -> PatientName (String)
        //                                           // Key:PatientName(String)                     -> Pid (String)
        //                                           // Key:PatientName(String)<lowercased>         -> Pid (String)
        //                                           // Key:PatientName(String)<lowercased & NO WS> -> Pid (String)
        // ----------------------------------------------------------------------------------------------------------------------
      
        if (self.dictPatientPidXref.count > 0)
        {
      
            // If we have a different # of item(s) then the ParseCoreManager does, then deep copy and update it...
            
            if (self.jmAppParseCoreManager.dictPatientPidXref.count  < 1 ||
                self.jmAppParseCoreManager.dictPatientPidXref.count != self.dictPatientPidXref.count)
            {
            
                let _ = self.deepCopyDictPatientPidXref()
            
            }
            else
            {

                // If we're 'forcing' a Reload, then deep copy and update it...

                if (bForceReloadOfPFQuery == true)
                {

                    let _ = self.deepCopyDictPatientPidXref()

                }

            }
      
        }
      
        // ----------------------------------------------------------------------------------------------------------------------
        //  var dictPFPatientFileItems:[Int:ParsePFPatientFileItem] = [Int:ParsePFPatientFileItem]()
        //                                                            // [Int:ParsePFPatientFileItem]
        //                                                            // Key:Pid(Int) -> PatientPid (Int)
        // ----------------------------------------------------------------------------------------------------------------------
      
        if (self.dictPFPatientFileItems.count > 0)
        {
      
            // If we have a different # of item(s) then the ParseCoreManager does, then deep copy and update it...
            
            if (self.jmAppParseCoreManager.dictPFPatientFileItems.count  < 1 ||
                self.jmAppParseCoreManager.dictPFPatientFileItems.count != self.dictPFPatientFileItems.count)
            {
            
                let _ = self.deepCopyDictPFPatientFileItems()
            
            }
            else
            {

                // If we're 'forcing' a Reload, then deep copy and update it...

                if (bForceReloadOfPFQuery == true)
                {

                    let _ = self.deepCopyDictPFPatientFileItems()

                }

            }
      
        }

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return

    } // End of public func gatherJmAppParsePFQueriesForPatientFileInBackground(bForceReloadOfPFQuery:Bool).

    public func gatherJmAppPFQueriesForScheduledLocationsForExport(bForceReloadOfPFQuery:Bool = false, iTherapistTID:Int = -1, sExportSchedulesStartWeek:String = "", sExportSchedulesEndWeek:String = "")->Bool
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameters are 'bForceReloadOfPFQuery' is [\(bForceReloadOfPFQuery)] - 'iTherapistTID' is (\(iTherapistTID)) - 'sExportSchedulesStartWeek' is [\(sExportSchedulesStartWeek)] - 'sExportSchedulesEndWeek' is [\(sExportSchedulesEndWeek)]...")

        // Make sure the 2 Date(s) fields are not 'empty' strings...

        if (sExportSchedulesStartWeek.count < 1 ||
            sExportSchedulesEndWeek.count   < 1)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) For 'iTherapistTID' of (\(iTherapistTID)) - 'sExportSchedulesStartWeek' is [\(sExportSchedulesStartWeek)] - 'sExportSchedulesEndWeek' is [\(sExportSchedulesEndWeek)] - 1 or BOTH fields are 'empty' strings - unable to generate the 'export' data - Error!")

            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return false
        
        }

        // Gather the PFQueries for PatientCalDay (the actual Schedules)...

        self.xcgLogMsg("\(sCurrMethodDisp) Fetching PatientCalDay via 'self.fetchJmAppPFQueriesForPatientCalDayForExport(bForceReloadOfPFQuery:Bool, iTherapistTID:, sExportSchedulesStartWeek:, sExportSchedulesEndWeek:)' for 'iTherapistTID' of (\(iTherapistTID)) - 'sExportSchedulesStartWeek' is [\(sExportSchedulesStartWeek)] - 'sExportSchedulesEndWeek' is [\(sExportSchedulesEndWeek)]...")

        let bFetchPatientCalDayOk:Bool = self.fetchJmAppPFQueriesForPatientCalDayForExport(bForceReloadOfPFQuery:bForceReloadOfPFQuery, iTherapistTID:iTherapistTID, sExportSchedulesStartWeek:sExportSchedulesStartWeek, sExportSchedulesEndWeek:sExportSchedulesEndWeek)

        self.xcgLogMsg("\(sCurrMethodDisp) Fetched  PatientCalDay via 'self.fetchJmAppPFQueriesForPatientCalDayForExport(bForceReloadOfPFQuery:Bool, iTherapistTID:, sExportSchedulesStartWeek:, sExportSchedulesEndWeek:)' for 'iTherapistTID' of (\(iTherapistTID)) - 'sExportSchedulesStartWeek' is [\(sExportSchedulesStartWeek)] - 'sExportSchedulesEndWeek' is [\(sExportSchedulesEndWeek)] - return value of 'bFetchPatientCalDayOk' was [\(bFetchPatientCalDayOk)]...")

        if (bFetchPatientCalDayOk == false)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) For 'iTherapistTID' of (\(iTherapistTID)) - 'sExportSchedulesStartWeek' is [\(sExportSchedulesStartWeek)] - 'sExportSchedulesEndWeek' is [\(sExportSchedulesEndWeek)] - fetch of the PatientCalDay information failed - unable to generate the 'export' data - Error!")

            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return false
        
        }

        // Gather the PFQueries for BackupVisit (the 'last' Visit locations)...

        self.xcgLogMsg("\(sCurrMethodDisp) Fetching BackupVisit via 'self.fetchJmAppPFQueriesForBackupVisitForExport(bForceReloadOfPFQuery:Bool, iTherapistTID:, sExportSchedulesStartWeek:, sExportSchedulesEndWeek:)' for 'iTherapistTID' of (\(iTherapistTID)) - 'sExportSchedulesStartWeek' is [\(sExportSchedulesStartWeek)] - 'sExportSchedulesEndWeek' is [\(sExportSchedulesEndWeek)]...")

        let bFetchBackupVisitOk:Bool = self.fetchJmAppPFQueriesForBackupVisitForExport(bForceReloadOfPFQuery:bForceReloadOfPFQuery, iTherapistTID:iTherapistTID, sExportSchedulesStartWeek:sExportSchedulesStartWeek, sExportSchedulesEndWeek:sExportSchedulesEndWeek)

        self.xcgLogMsg("\(sCurrMethodDisp) Fetched  BackupVisit via 'self.fetchJmAppPFQueriesForBackupVisitForExport(bForceReloadOfPFQuery:Bool, iTherapistTID:, sExportSchedulesStartWeek:, sExportSchedulesEndWeek:)' for 'iTherapistTID' of (\(iTherapistTID)) - 'sExportSchedulesStartWeek' is [\(sExportSchedulesStartWeek)] - 'sExportSchedulesEndWeek' is [\(sExportSchedulesEndWeek)] - return value of 'bFetchBackupVisitOk' was [\(bFetchBackupVisitOk)]...")

        if (bFetchBackupVisitOk == false)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) For 'iTherapistTID' of (\(iTherapistTID)) - 'sExportSchedulesStartWeek' is [\(sExportSchedulesStartWeek)] - 'sExportSchedulesEndWeek' is [\(sExportSchedulesEndWeek)] - fetch of the BackupVisit information failed - unable to generate the 'export' data - Error!")

            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return false
        
        }

        // Apply the BackupVisit data to the Scheduled Patient Location data...

        self.xcgLogMsg("\(sCurrMethodDisp) Calling 'self.applyBackupFileItemsToScheduledLocations()'...")

        let _ = self.applyBackupFileItemsToScheduledLocations()

        self.xcgLogMsg("\(sCurrMethodDisp) Called  'self.applyBackupFileItemsToScheduledLocations()'...")

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return true

    } // End of public func gatherJmAppPFQueriesForScheduledLocationsForExport(bForceReloadOfPFQuery:Bool, iTherapistTID:, sExportSchedulesStartWeek:, sExportSchedulesEndWeek:)->Bool.

    private func fetchJmAppPFQueriesForPatientCalDayForExport(bForceReloadOfPFQuery:Bool = false, iTherapistTID:Int = -1, sExportSchedulesStartWeek:String = "", sExportSchedulesEndWeek:String = "")->Bool
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameters are 'bForceReloadOfPFQuery' is [\(bForceReloadOfPFQuery)] - 'iTherapistTID' is (\(iTherapistTID)) - 'sExportSchedulesStartWeek' is [\(sExportSchedulesStartWeek)] - 'sExportSchedulesEndWeek' is [\(sExportSchedulesEndWeek)]...")

        // Make sure the 2 Date(s) fields are not 'empty' strings...

        if (sExportSchedulesStartWeek.count < 1 ||
            sExportSchedulesEndWeek.count   < 1)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) For 'iTherapistTID' of (\(iTherapistTID)) - 'sExportSchedulesStartWeek' is [\(sExportSchedulesStartWeek)] - 'sExportSchedulesEndWeek' is [\(sExportSchedulesEndWeek)] - 1 or BOTH fields are 'empty' strings - unable to generate the 'export' data - Error!")

            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return false
        
        }

        // Make sure we have 'Therapist' and 'Patient' dictionaries...

        self.xcgLogMsg("\(sCurrMethodDisp) For 'self.dictExportSchedPatientLocItems' with #(\(self.dictExportSchedPatientLocItems.count)) item(s) - creating the 'export' data...")

        if (self.dictPFTherapistFileItems.count < 1)
        {
        
            self.getJmAppParsePFQueryForTherapistFileToAddToAdmins(bForceReloadOfPFQuery:bForceReloadOfPFQuery)
        
        }
        
        if (self.dictPFPatientFileItems.count < 1)
        {
        
            self.gatherJmAppParsePFQueriesForPatientFileInBackground(bForceReloadOfPFQuery:bForceReloadOfPFQuery)
        
        }
        
        // Check again to make sure both the 'Therapist' and 'Patient' dictionaries are NOT 'empty'...

        if (self.dictPFTherapistFileItems.count < 1)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) For 'iTherapistTID' of (\(iTherapistTID)) - 'self.dictPFTherapistFileItems' with #(\(self.dictPFTherapistFileItems.count)) item(s) is an 'empty' dictionary - unable to generate the 'export' data - Error!")

            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return false
        
        }
        
        if (self.dictPFPatientFileItems.count < 1)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) For 'iTherapistTID' of (\(iTherapistTID)) - 'self.dictPFPatientFileItems' with #(\(self.dictPFPatientFileItems.count)) item(s) is an 'empty' dictionary - unable to generate the 'export' data - Error!")

            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return false
        
        }

        // Clear the 'export' SchedPatientLocItems field(s)...

        self.bHasDictExportSchedPatientLocItemsBeenDisplayed = false
        self.dictExportSchedPatientLocItems                  = [String:[ScheduledPatientLocationItem]]()
  
        // Create a PFQuery for the 'PatientCalDay' class...

        self.xcgLogMsg("\(sCurrMethodDisp) Calling PFQuery to construct an instance for the 'PatientCalDay' class...")

        let pfQueryPatientCalDay:PFQuery = PFQuery(className:"PatientCalDay")

        self.xcgLogMsg("\(sCurrMethodDisp) Called  PFQuery to construct an instance for the 'PatientCalDay' class...")

        // Set the query parameter(s) and issue the 'find' then (possibly) iterate the result(s)...

        self.xcgLogMsg("\(sCurrMethodDisp) Returned query of 'pfQueryPatientCalDay' is [\(String(describing: pfQueryPatientCalDay))]...")

        do
        {

        //  "class" : "select * from PatientCalDay where tid = 'iTherapistTID' and VDate = \"2024-12-03\";",

            pfQueryPatientCalDay.whereKeyExists("pid")
            pfQueryPatientCalDay.whereKeyExists("startTime")

            if (iTherapistTID == -1)
            {
            
                pfQueryPatientCalDay.whereKeyExists("tid")
            
            }
            else
            {
            
                pfQueryPatientCalDay.whereKey("tid", equalTo:iTherapistTID)
            
            }

        //  pfQueryPatientCalDay.whereKey("tid",   notEqualTo:1)
            pfQueryPatientCalDay.whereKey("VDate", greaterThanOrEqualTo:sExportSchedulesStartWeek)
            pfQueryPatientCalDay.whereKey("VDate", lessThanOrEqualTo:sExportSchedulesEndWeek)

        //  pfQueryPatientCalDay.addAscendingOrder("startTime")

            pfQueryPatientCalDay.limit = 2000

            let listPFPatientCalDayObjects:[PFObject]? = try pfQueryPatientCalDay.findObjects()

            if (listPFPatientCalDayObjects != nil &&
                listPFPatientCalDayObjects!.count > 0)
            {

                self.xcgLogMsg("\(sCurrMethodDisp) Parse - query of 'pfQueryPatientCalDay' returned a count of #(\(listPFPatientCalDayObjects!.count)) PFObject(s) for the TID of [\(iTherapistTID)]...")
                self.xcgLogMsg("\(sCurrMethodDisp) Enumerating the result(s) of query of 'pfQueryPatientCalDay'...")

                var cPFPatientCalDayObjects:Int = 0

                for pfPatientCalDayObject in listPFPatientCalDayObjects!
                {

                    cPFPatientCalDayObjects += 1

                    let scheduledPatientLocationItem:ScheduledPatientLocationItem = 
                        ScheduledPatientLocationItem(pfPatientCalDayItem:pfPatientCalDayObject)

                    if (scheduledPatientLocationItem.sTid.count < 1)
                    {
                    
                        self.xcgLogMsg("\(sCurrMethodDisp) Constructed ScheduledPatientLocationItem from a PFPatientCalDay object has a 'scheduledPatientLocationItem.sTid' of [\(scheduledPatientLocationItem.sTid)] that is an 'empty' string - unable to generate the 'export' data for this object - bypassing - Error!")
                        
                        continue
                    
                    }

                    if (scheduledPatientLocationItem.sTid == "1")
                    {
                    
                        self.xcgLogMsg("\(sCurrMethodDisp) Constructed ScheduledPatientLocationItem from a PFPatientCalDay object has a 'scheduledPatientLocationItem.sTid' of [\(scheduledPatientLocationItem.sTid)] that is '1' - this is the 'testing' Therapist and will be 'skipped' - bypassing - Warning!")
                        
                        continue
                    
                    }

                    if (self.dictPFTherapistFileItems.count                               > 0 &&
                        self.dictPFTherapistFileItems[scheduledPatientLocationItem.iTid] != nil)
                    {

                        scheduledPatientLocationItem.updateScheduledPatientLocationItemFromPFTherapistFile(pfTherapistFileItem:self.dictPFTherapistFileItems[scheduledPatientLocationItem.iTid]!)

                    }

                    if (scheduledPatientLocationItem.sPid.count > 0)
                    {

                        if (self.dictPFPatientFileItems.count                               > 0 &&
                            self.dictPFPatientFileItems[scheduledPatientLocationItem.iPid] != nil)
                        {

                            scheduledPatientLocationItem.updateScheduledPatientLocationItemFromPFPatientFile(pfPatientFileItem:self.dictPFPatientFileItems[scheduledPatientLocationItem.iPid]!)

                        }

                    }

                    var listScheduledPatientLocationItems:[ScheduledPatientLocationItem] = [ScheduledPatientLocationItem]()

                    if (self.dictExportSchedPatientLocItems.count                               > 0 &&
                        self.dictExportSchedPatientLocItems[scheduledPatientLocationItem.sTid] != nil)
                    {

                        listScheduledPatientLocationItems = self.dictExportSchedPatientLocItems[scheduledPatientLocationItem.sTid]!

                    }

                    listScheduledPatientLocationItems.append(scheduledPatientLocationItem)

                    self.xcgLogMsg("\(sCurrMethodDisp) Added an updated Item #(\(cPFPatientCalDayObjects)) 'scheduledPatientLocationItem' of [\(scheduledPatientLocationItem)] to the list 'listScheduledPatientLocationItems' for 'scheduledPatientLocationItem.sTid' of [\(scheduledPatientLocationItem.sTid)]...")

                    self.dictExportSchedPatientLocItems[scheduledPatientLocationItem.sTid] = listScheduledPatientLocationItems

                }

                if (self.dictExportSchedPatientLocItems.count > 0)
                {

                    var cExportPFTherapistParseTIDs:Int = 0

                    for (sPFTherapistParseTID, listScheduledPatientLocationItems) in self.dictExportSchedPatientLocItems
                    {

                        cExportPFTherapistParseTIDs += 1

                        if (sPFTherapistParseTID.count  < 1 ||
                            sPFTherapistParseTID       == "-N/A-")
                        {

                            self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cExportPFTherapistParseTIDs)) 'sPFTherapistParseTID' - the 'tid' field is nil or '-N/A-' - Warning!")

                            continue

                        }

                        if (listScheduledPatientLocationItems.count < 1)
                        {

                            self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cExportPFTherapistParseTIDs)) 'sPFTherapistParseTID' of [\(sPFTherapistParseTID)] - the 'listScheduledPatientLocationItems' field is nil or the count is less than 1 - Warning!")

                            continue

                        }

                        if (listScheduledPatientLocationItems.count < 2)
                        {

                            self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cExportPFTherapistParseTIDs)) 'sPFTherapistParseTID' of [\(sPFTherapistParseTID)] - the 'listScheduledPatientLocationItems' field count is less than 2 - the list does NOT need sorting...")

                            continue

                        }

                        self.xcgLogMsg("\(sCurrMethodDisp) Sorting #(\(listScheduledPatientLocationItems.count)) Item(s) in the 'listScheduledPatientLocationItems' of [\(listScheduledPatientLocationItems)] for 'sPFTherapistParseTID' of [\(sPFTherapistParseTID)]...")
                        
                        var listSortedScheduledPatientLocationItems:[ScheduledPatientLocationItem] = listScheduledPatientLocationItems
                        
                        listSortedScheduledPatientLocationItems.sort
                        { (scheduledPatientLocationItem1, scheduledPatientLocationItem2) in

                            var bIsItem1GreaterThanItem2:Bool = false

                            //  Compare for Sort: '<' sorts 'ascending' and '>' sorts 'descending'...
                        
                            if (scheduledPatientLocationItem1.sVDate == scheduledPatientLocationItem2.sVDate)
                            {
                            
                            //  bIsItem1GreaterThanItem2 = (scheduledPatientLocationItem1.iVDateStartTime24h > scheduledPatientLocationItem2.iVDateStartTime24h)
                                bIsItem1GreaterThanItem2 = (scheduledPatientLocationItem1.iVDateStartTime24h < scheduledPatientLocationItem2.iVDateStartTime24h)
                            
                            }
                            else
                            {
                            
                                bIsItem1GreaterThanItem2 = (scheduledPatientLocationItem1.sVDate < scheduledPatientLocationItem2.sVDate)
                            
                            }
                        
                        //  self.xcgLogMsg("\(sCurrMethodDisp) Sort <OP> Returning 'bIsItem1GreaterThanItem2' of [\(bIsItem1GreaterThanItem2)] because 'scheduledPatientLocationItem1.iVDateStartTime24h' is [\(scheduledPatientLocationItem1.iVDateStartTime24h)] and is less than 'scheduledPatientLocationItem2.iVDateStartTime24h' is [\(scheduledPatientLocationItem2.iVDateStartTime24h)] for 'sPFTherapistParseTID' of [\(sPFTherapistParseTID)]...")
                        
                            return bIsItem1GreaterThanItem2
                        
                        }
                        
                        self.dictExportSchedPatientLocItems[sPFTherapistParseTID] = listSortedScheduledPatientLocationItems
                        
                        self.xcgLogMsg("\(sCurrMethodDisp) Sorted  #(\(listScheduledPatientLocationItems.count)) Item(s) in the 'listScheduledPatientLocationItems' of [\(listScheduledPatientLocationItems)] for 'sPFTherapistParseTID' of [\(sPFTherapistParseTID)]...")

                    }

                }

                // If we created item(s) in the 'dictSchedPatientLocItems' and we haven't displayed them, then display them...

                if (self.bHasDictExportSchedPatientLocItemsBeenDisplayed == false)
                {

                    self.bHasDictExportSchedPatientLocItemsBeenDisplayed = true

                    self.displayDictExportSchedPatientLocItems()

                }

            }
            else
            {

                self.xcgLogMsg("\(sCurrMethodDisp) Parse - query of 'pfQueryPatientCalDay' returned an 'empty' or nil list of PFObject(s) for the TID of [\(iTherapistTID)]  - unable to generate the 'export' data - Warning!")

            }

        }
        catch
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Parse - failed execute the query 'pfQueryPatientCalDay' - Details: \(error) - for 'iTherapistTID' of (\(iTherapistTID)) - unable to generate the 'export' data - Error!")

            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return false

        }

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return true

    }   // End of private func fetchJmAppPFQueriesForPatientCalDayForExport(bForceReloadOfPFQuery:Bool, iTherapistTID:, sExportSchedulesStartWeek:, sExportSchedulesEndWeek:)->Bool.
    
    private func fetchJmAppPFQueriesForBackupVisitForExport(bForceReloadOfPFQuery:Bool = false, iTherapistTID:Int = -1, sExportSchedulesStartWeek:String = "", sExportSchedulesEndWeek:String = "")->Bool
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameters are 'bForceReloadOfPFQuery' is [\(bForceReloadOfPFQuery)] - 'iTherapistTID' is (\(iTherapistTID)) - 'sExportSchedulesStartWeek' is [\(sExportSchedulesStartWeek)] - 'sExportSchedulesEndWeek' is [\(sExportSchedulesEndWeek)]...")

        // Make sure the 2 Date(s) fields are not 'empty' strings...

        if (sExportSchedulesStartWeek.count < 1 ||
            sExportSchedulesEndWeek.count   < 1)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) For 'iTherapistTID' of (\(iTherapistTID)) - 'sExportSchedulesStartWeek' is [\(sExportSchedulesStartWeek)] - 'sExportSchedulesEndWeek' is [\(sExportSchedulesEndWeek)] - 1 or BOTH fields are 'empty' strings - unable to generate the 'export' data - Error!")

            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return false
        
        }

        // Make sure the 'export' SchedPatientLocItems dictionary is NOT 'empty'...

        if (self.dictExportSchedPatientLocItems.count < 1)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) For 'iTherapistTID' of (\(iTherapistTID)) - 'self.dictExportSchedPatientLocItems' with #(\(self.dictExportSchedPatientLocItems.count)) item(s) is an 'empty' dictionary - unable to generate the 'export' data - Error!")

            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return false
        
        }
        
        // Prepare to get the BackupVisit(s) for the set of TIDs and PIDs...

        var listOfExportTIDs:[Int]          = [Int]()
        var listOfExportPIDs:[Int]          = [Int]()
        var cExportPFTherapistParseTIDs:Int = 0

        for (sPFTherapistParseTID, listScheduledPatientLocationItems) in self.dictExportSchedPatientLocItems
        {
            
            cExportPFTherapistParseTIDs += 1

            if (sPFTherapistParseTID.count  < 1 ||
                sPFTherapistParseTID       == "-N/A-")
            {

                self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cExportPFTherapistParseTIDs)) 'sPFTherapistParseTID' - the 'tid' field is nil or '-N/A-' - Warning!")

                continue

            }

            if (listScheduledPatientLocationItems.count < 1)
            {

                self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cExportPFTherapistParseTIDs)) 'sPFTherapistParseTID' of [\(sPFTherapistParseTID)] - the 'listScheduledPatientLocationItems' field is nil or the count is less than 1 - Warning!")

                continue

            }

            let iTherapistTID:Int = Int(sPFTherapistParseTID)!

            if (listOfExportTIDs.contains(iTherapistTID) == false)
            {
            
                listOfExportTIDs.append(Int(sPFTherapistParseTID)!)
            
            }
            
            for scheduledPatientLocationItem in listScheduledPatientLocationItems
            {

                if (listOfExportPIDs.contains(scheduledPatientLocationItem.iPid) == false)
                {
                
                    listOfExportPIDs.append(scheduledPatientLocationItem.iPid)
                
                }

            }

        }

        if (listOfExportTIDs.count < 1)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) The generated list 'listOfExportTIDs' with #(\(listOfExportTIDs.count)) item(s) is 'empty' - unable to generate the 'export' data - Error!")

            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return false
        
        }
        
        if (listOfExportPIDs.count < 1)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) The generated list 'listOfExportPIDs' with #(\(listOfExportPIDs.count)) item(s) is 'empty' - unable to generate the 'export' data - Error!")

            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return false
        
        }

        // Prepare to get the BackupVisit(s) for the last Month...

        let dtFormatterDate:DateFormatter = DateFormatter()

        dtFormatterDate.locale     = Locale(identifier: "en_US")
        dtFormatterDate.timeZone   = TimeZone.current
        dtFormatterDate.dateFormat = "yyyy-MM-dd"

    //  let dateForCurrentQuery:Date = Calendar.current.date(byAdding:.day, value:-30, to:.now)!
        let dateForCurrentQuery:Date = Calendar.current.date(byAdding:.day, value:-60, to:.now)!
        let sCurrentQueryDate:String = dtFormatterDate.string(from:dateForCurrentQuery)

        self.xcgLogMsg("\(sCurrMethodDisp) BackupVisit 'sCurrentQueryDate' is [\(String(describing: sCurrentQueryDate))] <formatted>...")

        self.dictExportBackupFileItems     = [String:[String:ParsePFBackupFileItem]]()
        self.dictExportLastBackupFileItems = [String:ParsePFBackupFileItem]()

        // Create a PFQuery for the 'BackupVisit' class...

        self.xcgLogMsg("\(sCurrMethodDisp) Calling PFQuery to construct an instance for the 'BackupVisit' class...")

        let pfQueryBackupVisit:PFQuery = PFQuery(className:"BackupVisit")

        self.xcgLogMsg("\(sCurrMethodDisp) Called  PFQuery to construct an instance for the 'BackupVisit' class...")

        // Set the query parameter(s) and issue the 'find' then (possibly) iterate the result(s)...

        self.xcgLogMsg("\(sCurrMethodDisp) Returned query of 'pfQueryBackupVisit' is [\(String(describing: pfQueryBackupVisit))]...")

        do
        {

            self.xcgLogMsg("\(sCurrMethodDisp) <BackupVisit Parse> Searching for 'pfQueryBackupVisit' Item(s) keyed by #(\(listOfExportTIDs.count)) TIDs 'listOfExportTIDs' of [\(String(describing:listOfExportTIDs))] for #(\(listOfExportPIDs.count)) PIDs of 'listOfExportPIDs' of [\(String(describing:listOfExportPIDs))]...")

            pfQueryBackupVisit.whereKeyExists("lat")
            pfQueryBackupVisit.whereKeyExists("long")

            pfQueryBackupVisit.whereKey("tid",            containedIn:listOfExportTIDs)
            pfQueryBackupVisit.whereKey("pid",            containedIn:listOfExportPIDs)
            pfQueryBackupVisit.whereKey("billable",       equalTo:1)
        //  pfQueryBackupVisit.whereKey("isTelepractice", notEqualTo:1)
            pfQueryBackupVisit.whereKey("VDate",          greaterThan:sCurrentQueryDate)

            pfQueryBackupVisit.addDescendingOrder("VDate")

            pfQueryBackupVisit.limit = 5000

            let listPFBackupVisitObjects:[PFObject]? = try pfQueryBackupVisit.findObjects()

            if (listPFBackupVisitObjects != nil &&
                listPFBackupVisitObjects!.count > 0)
            {

                self.xcgLogMsg("\(sCurrMethodDisp) <BackupVisit Parse> - query of 'pfQueryBackupVisit' returned a count of #(\(listPFBackupVisitObjects!.count)) PFObject(s))...")

                if (self.bInternalTraceFlag == true)
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) <BackupVisit Parse> - returned list 'listPFBackupVisitObjects' is [\(String(describing:listPFBackupVisitObjects))]...")

                }

                var cParsePFBackupVisitObjects:Int = 0

                for parsePFBackupVisitObject in listPFBackupVisitObjects!
                {

                    cParsePFBackupVisitObjects += 1

                    let parsePFBackupFileItem:ParsePFBackupFileItem = ParsePFBackupFileItem(pfBackupVisit:parsePFBackupVisitObject)

                    if (parsePFBackupFileItem.sTid.count < 1 ||
                        parsePFBackupFileItem.sPid.count < 1)
                    {
                    
                        self.xcgLogMsg("\(sCurrMethodDisp) <BackupVisit Parse> - For the 'parsePFBackupFileItem' object - either the TID string of [\(parsePFBackupFileItem.sTid)] or PID string of [\(parsePFBackupFileItem.sPid)] is an 'empty' string - bypassing this object - Warning!")
                        
                        continue

                    }

                    if (parsePFBackupFileItem.sLastVDate.count < 1)
                    {
                    
                        self.xcgLogMsg("\(sCurrMethodDisp) <BackupVisit Parse> - For the 'parsePFBackupFileItem' object - the 'sLastVDate' string of [\(parsePFBackupFileItem.sLastVDate)] is an 'empty' string - bypassing this object - Warning!")
                        
                        continue

                    }

                    // ----------------------------------------------------------------------------------------------------------
                    //  var dictExportBackupFileItems:[String:[String:ParsePFBackupFileItem]] = 
                    //      [String:[String:ParsePFBackupFileItem]]()
                    //          // [String:[String:ParsePFBackupFileItem]]
                    //          // Key #1:"sTherapistTID(String).sPatientPID(String)"
                    //          // Key #2:ParsePFBackupFileItem.sLastVDate
                    //          // Value :ParsePFBackupFileItem
                    // ----------------------------------------------------------------------------------------------------------

                    let sExportBackupFileItemKey1:String = "\(parsePFBackupFileItem.sTid).\(parsePFBackupFileItem.sPid)"
                    let sExportBackupFileItemKey2:String = "\(parsePFBackupFileItem.sPid)"

                    if (self.dictExportBackupFileItems[sExportBackupFileItemKey1] == nil)
                    {
                    
                        self.dictExportBackupFileItems[sExportBackupFileItemKey1] = [String:ParsePFBackupFileItem]()
                    
                    }

                    var dictExportBackupFileItemsByDate:[String:ParsePFBackupFileItem] =
                        self.dictExportBackupFileItems[sExportBackupFileItemKey1]!

                    if (dictExportBackupFileItemsByDate[parsePFBackupFileItem.sLastVDate] == nil)
                    {
                    
                        dictExportBackupFileItemsByDate[parsePFBackupFileItem.sLastVDate] = parsePFBackupFileItem

                        self.xcgLogMsg("\(sCurrMethodDisp) <BackupVisit Parse> - for a 'primary' Key of [\(sExportBackupFileItemKey1)] and 'secondary' Key of [\(parsePFBackupFileItem.sLastVDate)] added a 'parsePFBackupFileItem' object to the dictionary of 'dictExportBackupFileItemsByDate'...")
                    
                    }
                    else
                    {
                    
                        dictExportBackupFileItemsByDate[parsePFBackupFileItem.sLastVDate]!.updateParsePFBackupFileItemFromPFBackupVisitIfNewer(pfBackupFileItem:parsePFBackupFileItem)

                        self.xcgLogMsg("\(sCurrMethodDisp) <BackupVisit Parse> - for a 'primary' Key of [\(sExportBackupFileItemKey1)] and 'secondary' Key of [\(parsePFBackupFileItem.sLastVDate)] updated the 'parsePFBackupFileItem' object in the dictionary of 'dictExportBackupFileItemsByDate'...")
                    
                    }

                    self.dictExportBackupFileItems[sExportBackupFileItemKey1] = dictExportBackupFileItemsByDate

                    self.xcgLogMsg("\(sCurrMethodDisp) <BackupVisit Parse> - for a 'primary' Key of [\(sExportBackupFileItemKey1)] and 'secondary' Key of [\(parsePFBackupFileItem.sLastVDate)] updated the dictionary of 'dictExportBackupFileItemsByDate'...")

                    let pfBackupFileItem:ParsePFBackupFileItem = ParsePFBackupFileItem(pfBackupFileItem:parsePFBackupFileItem)

                    if (self.dictExportLastBackupFileItems[sExportBackupFileItemKey1] == nil)
                    {

                        self.dictExportLastBackupFileItems[sExportBackupFileItemKey1] = pfBackupFileItem
                    
                    }
                    else
                    {
                    
                        self.dictExportLastBackupFileItems[sExportBackupFileItemKey1]!.updateParsePFBackupFileItemFromPFBackupVisitIfNewer(pfBackupFileItem:parsePFBackupFileItem)
                    
                    }

                    if (self.dictExportLastBackupFileItems[sExportBackupFileItemKey2] == nil)
                    {

                        self.dictExportLastBackupFileItems[sExportBackupFileItemKey2] = pfBackupFileItem
                    
                    }
                    else
                    {
                    
                        self.dictExportLastBackupFileItems[sExportBackupFileItemKey2]!.updateParsePFBackupFileItemFromPFBackupVisitIfNewer(pfBackupFileItem:parsePFBackupFileItem)
                    
                    }

                }

            }

            // If we created item(s) in the 'dictExportBackupFileItems' and we haven't displayed them, then display them...

            if (self.bHasDictExportBackupFileItemsBeenDisplayed == false)
            {

                self.bHasDictExportBackupFileItemsBeenDisplayed = true

                self.displayDictExportBackupFileItems()

            }

            // If we created item(s) in the 'dictExportLastBackupFileItems' and we haven't displayed them, then display them...

            if (self.bHasDictExportLastBackupFileItemsBeenDisplayed == false)
            {

                self.bHasDictExportLastBackupFileItemsBeenDisplayed = true

                self.displayDictExportLastBackupFileItems()

            }

        }
        catch
        {

            self.xcgLogMsg("\(sCurrMethodDisp) <BackupVisit Parse> - failed execute the query 'pfQueryBackupVisit' - Details: \(error) - Error!")

            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return false

        }

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return true

    }   // End of private func fetchJmAppPFQueriesForBackupVisitForExport(bForceReloadOfPFQuery:Bool, iTherapistTID:, sExportSchedulesStartWeek:, sExportSchedulesEndWeek:)->Bool.
    
    private func applyBackupFileItemsToScheduledLocations()->Bool
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Check that we have data to 'apply'...

        if (self.dictExportSchedPatientLocItems.count < 1)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) For 'self.dictExportSchedPatientLocItems' with #(\(self.dictExportSchedPatientLocItems.count)) item(s) is an 'empty' dictionary - unable to apply the 'export' data - Error!")

            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return false
        
        }
  
        if (self.dictExportBackupFileItems.count < 1)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) For 'self.dictExportBackupFileItems' with #(\(self.dictExportBackupFileItems.count)) item(s) is an 'empty' dictionary - unable to apply the 'export' data - Error!")

            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return false
        
        }

        // Loop thru the dictionary of Scheduled Patient Locations and apply the appropriate BackupFile item(s)...

        self.xcgLogMsg("\(sCurrMethodDisp) Applying the dictionary of #(\(self.dictExportBackupFileItems.count)) 'dictExportBackupFileItems' item(s) to the dictionary of #(\(self.dictExportSchedPatientLocItems.count)) 'dictExportSchedPatientLocItems' item(s)...")

        let cExportPFTherapistTotalTIDs:Int               = self.dictExportSchedPatientLocItems.count
        var cExportPFTherapistParseTIDs:Int               = 0
        var cTotalExportScheduledPatientLocationItems:Int = 0
        var cTotalExportLastBackupFileItemsApplied:Int    = 0

        for (sPFTherapistParseTID, listScheduledPatientLocationItems) in self.dictExportSchedPatientLocItems
        {

            cExportPFTherapistParseTIDs += 1

            if (sPFTherapistParseTID.count  < 1 ||
                sPFTherapistParseTID       == "-N/A-")
            {

                self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cExportPFTherapistParseTIDs)) 'sPFTherapistParseTID' - the 'tid' field is nil or '-N/A-' - Warning!")

                continue

            }

            if (listScheduledPatientLocationItems.count < 1)
            {

                self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cExportPFTherapistParseTIDs)) 'sPFTherapistParseTID' of [\(sPFTherapistParseTID)] - the 'listScheduledPatientLocationItems' field is nil or the count is less than 1 - Warning!")

                continue

            }

            var cExportScheduledPatientLocationItems:Int = 0

            for scheduledPatientLocationItem in listScheduledPatientLocationItems
            {

                cExportScheduledPatientLocationItems += 1

                self.xcgLogMsg("\(sCurrMethodDisp) Of #(\(cExportPFTherapistTotalTIDs)) TIDs - For TID [\(sPFTherapistParseTID)] - Applying the BackupFile data to 'scheduledPatientLocationItem' item #(\(cExportPFTherapistParseTIDs).\(cExportScheduledPatientLocationItems)):")

                if (scheduledPatientLocationItem.sPid.count < 1)
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) <Apply BackupVisit to SchedPatLoc> - For the 'scheduledPatientLocationItem' object - the PID string of [\(scheduledPatientLocationItem.sPid)] is an 'empty' string - bypassing this object - Warning!")

                    continue

                }

                if (scheduledPatientLocationItem.sVDate.count < 1)
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) <Apply BackupVisit to SchedPatLoc> - For the 'scheduledPatientLocationItem' object - the VDate string of [\(scheduledPatientLocationItem.sVDate)] is an 'empty' string - bypassing this object - Warning!")

                    continue

                }

                let sExportBackupFileItemKey1:String = "\(sPFTherapistParseTID).\(scheduledPatientLocationItem.sPid)"
                let sExportBackupFileItemKey2:String = "\(scheduledPatientLocationItem.sPid)"

                if (self.dictExportBackupFileItems[sExportBackupFileItemKey1] == nil)
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) <Apply BackupVisit to SchedPatLoc> - For the 'scheduledPatientLocationItem' object - the 'sExportBackupFileItemKey1' of [\(sExportBackupFileItemKey1)] does NOT exist in the BackupFile item(s) dictionary - attempting to locate a LAST BackupFile item...")

                }
                else
                {

                    let dictExportBackupFileItemsByDate:[String:ParsePFBackupFileItem] =
                        self.dictExportBackupFileItems[sExportBackupFileItemKey1]!

                    if (dictExportBackupFileItemsByDate[scheduledPatientLocationItem.sVDate] == nil)
                    {

                        self.xcgLogMsg("\(sCurrMethodDisp) <Apply BackupVisit to SchedPatLoc> - For a 'primary' Key of [\(sExportBackupFileItemKey1)] the 'scheduledPatientLocationItem.sVDate' of [\(scheduledPatientLocationItem.sVDate)] does NOT exist in the BackupFile item(s) dictionary - attempting to locate a LAST BackupFile item...")

                    }
                    else
                    {

                        let pfBackupFileItem:ParsePFBackupFileItem = dictExportBackupFileItemsByDate[scheduledPatientLocationItem.sVDate]!

                        scheduledPatientLocationItem.updateScheduledPatientLocationItemFromPFBackupVisitItem(pfBackupFileItem:pfBackupFileItem)

                        self.xcgLogMsg("\(sCurrMethodDisp) <Apply BackupVisit to SchedPatLoc> - For a 'primary' Key of [\(sExportBackupFileItemKey1)] and 'secondary' Key of [\(scheduledPatientLocationItem.sVDate)] overlayed the BackupFile item - 'scheduledPatientLocationItem.sLastVDate' is [\(scheduledPatientLocationItem.sLastVDate)]...")

                    }

                }

                if (scheduledPatientLocationItem.sLastVDate.count < 1)
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) <Apply BackupVisit to SchedPatLoc> <LAST Backup #1> - For a 'primary' Key of [\(sExportBackupFileItemKey1)] the 'scheduledPatientLocationItem.sLastVDate' of [\(scheduledPatientLocationItem.sLastVDate)] is an 'empty' string - attempting to apply a LAST BackupFile item #1...")

                    if (self.dictExportLastBackupFileItems[sExportBackupFileItemKey1] == nil)
                    {

                        self.xcgLogMsg("\(sCurrMethodDisp) <Apply BackupVisit to SchedPatLoc> <LAST Backup #1> - For the 'scheduledPatientLocationItem' object - the 'sExportBackupFileItemKey1' of [\(sExportBackupFileItemKey1)] does NOT exist in the LAST BackupFile item(s) dictionary #1 - bypassing this object - Warning!")

                    }
                    else
                    {

                        let pfBackupFileItem:ParsePFBackupFileItem = self.dictExportLastBackupFileItems[sExportBackupFileItemKey1]!

                        scheduledPatientLocationItem.updateScheduledPatientLocationItemFromPFBackupVisitItem(pfBackupFileItem:pfBackupFileItem)

                        self.xcgLogMsg("\(sCurrMethodDisp) <Apply BackupVisit to SchedPatLoc> <LAST Backup #1> - For a 'primary' Key of [\(sExportBackupFileItemKey1)] overlayed the LAST BackupFile item #1...")

                        if (scheduledPatientLocationItem.sLastVDate.count > 0)
                        {

                            cTotalExportLastBackupFileItemsApplied += 1

                        }

                    }
                
                }

                if (scheduledPatientLocationItem.sLastVDate.count < 1)
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) <Apply BackupVisit to SchedPatLoc> <LAST Backup #2> - For a 'primary' Key of [\(sExportBackupFileItemKey2)] the 'scheduledPatientLocationItem.sLastVDate' of [\(scheduledPatientLocationItem.sLastVDate)] is an 'empty' string - attempting to apply a LAST BackupFile item #2...")

                    if (self.dictExportLastBackupFileItems[sExportBackupFileItemKey2] == nil)
                    {

                        self.xcgLogMsg("\(sCurrMethodDisp) <Apply BackupVisit to SchedPatLoc> <LAST Backup #2> - For the 'scheduledPatientLocationItem' object - the 'sExportBackupFileItemKey2' of [\(sExportBackupFileItemKey2)] does NOT exist in the LAST BackupFile item(s) dictionary #2 - bypassing this object - Warning!")

                    }
                    else
                    {

                        let pfBackupFileItem:ParsePFBackupFileItem = self.dictExportLastBackupFileItems[sExportBackupFileItemKey2]!

                        scheduledPatientLocationItem.updateScheduledPatientLocationItemFromPFBackupVisitItem(pfBackupFileItem:pfBackupFileItem)

                        self.xcgLogMsg("\(sCurrMethodDisp) <Apply BackupVisit to SchedPatLoc> <LAST Backup #2> - For a 'primary' Key of [\(sExportBackupFileItemKey2)] overlayed the LAST BackupFile item #2...")

                        if (scheduledPatientLocationItem.sLastVDate.count > 0)
                        {

                            cTotalExportLastBackupFileItemsApplied += 1

                        }

                    }
                
                }

            }

            self.xcgLogMsg("\(sCurrMethodDisp) <Export Counts> Of #(\(cExportPFTherapistTotalTIDs)) TIDs - #(\(cExportPFTherapistParseTIDs)) TID of [\(sPFTherapistParseTID)] has a TOTAL of #(\(cExportScheduledPatientLocationItems)) scheduled visits...")

            cTotalExportScheduledPatientLocationItems += cExportScheduledPatientLocationItems

        }

        self.xcgLogMsg("\(sCurrMethodDisp) <Export Counts> A TOTAL of #(\(cExportPFTherapistTotalTIDs)) TIDs have a TOTAL of #(\(cTotalExportScheduledPatientLocationItems)) scheduled visits with a TOTAL of #(\(cTotalExportLastBackupFileItemsApplied)) LAST BackupFile visits applied...")
  
        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return true

    }   // End of private func applyBackupFileItemsToScheduledLocations()->Bool.
    
    public func auditExportSchedPatientLocItems(bForceApplyOfficeLatLongAddr:Bool = false)->[String:String]
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'bForceApplyOfficeLatLongAddr' is [\(bForceApplyOfficeLatLongAddr)]...")

        var dictAuditExportSchedPatientLocItemsMetrics:[String:String] = [String:String]()

        // Check that we have data to 'audit'...

        if (self.dictExportSchedPatientLocItems.count < 1)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) For 'self.dictExportSchedPatientLocItems' with #(\(self.dictExportSchedPatientLocItems.count)) item(s) is an 'empty' dictionary - unable to audit the 'export' data - Error!")

            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return dictAuditExportSchedPatientLocItemsMetrics
        
        }

        // Set initial 'count' values for the response Metrics dictionary...
  
        let cExportPFTherapistTotalTIDs:Int               = self.dictExportSchedPatientLocItems.count
        var cExportPFTherapistParseTIDs:Int               = 0
        var cTotalExportScheduledPatientLocationItems:Int = 0

        var listOfExportTIDs:[Int]                        = [Int]()
        var listOfExportPIDs:[Int]                        = [Int]()

        var cExportNoLastVDateItems:Int                   = 0
        var cExportNoLastVDateLatitudeItems:Int           = 0
        var cExportNoLastVDateLongitudeItems:Int          = 0
        var cExportNoLastVDateAddressItems:Int            = 0

        var cExportScheduleTypeUndefined:Int              = 0
        var cExportScheduleTypePastDate:Int               = 0
        var cExportScheduleTypeScheduled:Int              = 0
        var cExportScheduleTypeDone:Int                   = 0
        var cExportScheduleTypeDateError:Int              = 0
        var cExportScheduleTypeMissed:Int                 = 0

        for (sPFTherapistParseTID, listScheduledPatientLocationItems) in self.dictExportSchedPatientLocItems
        {
            
            cExportPFTherapistParseTIDs += 1

            if (sPFTherapistParseTID.count  < 1 ||
                sPFTherapistParseTID       == "-N/A-")
            {

                self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cExportPFTherapistParseTIDs)) 'sPFTherapistParseTID' - the 'tid' field is nil or '-N/A-' - Warning!")

                continue

            }

            if (listScheduledPatientLocationItems.count < 1)
            {

                self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cExportPFTherapistParseTIDs)) 'sPFTherapistParseTID' of [\(sPFTherapistParseTID)] - the 'listScheduledPatientLocationItems' field is nil or the count is less than 1 - Warning!")

                continue

            }

            let iTherapistTID:Int = Int(sPFTherapistParseTID)!

            if (listOfExportTIDs.contains(iTherapistTID) == false)
            {
            
                listOfExportTIDs.append(Int(sPFTherapistParseTID)!)
            
            }
            
            for scheduledPatientLocationItem in listScheduledPatientLocationItems
            {

                cTotalExportScheduledPatientLocationItems += 1

                if (listOfExportPIDs.contains(scheduledPatientLocationItem.iPid) == false)
                {
                    listOfExportPIDs.append(scheduledPatientLocationItem.iPid)
                }

                // ----------------------------------------------------------------------------------------------
                //  var cExportNoLastVDateItems:Int                   = 0
                //  var cExportNoLastVDateLatitudeItems:Int           = 0
                //  var cExportNoLastVDateLongitudeItems:Int          = 0
                //  var cExportNoLastVDateAddressItems:Int            = 0
                // ----------------------------------------------------------------------------------------------
            
                if (scheduledPatientLocationItem.sLastVDate.count < 1)
                {
                    cExportNoLastVDateItems          += 1
                }
                
                if (scheduledPatientLocationItem.sLastVDateLatitude.count < 1)
                {
                    cExportNoLastVDateLatitudeItems  += 1

                    if (bForceApplyOfficeLatLongAddr == true)
                    {
                        scheduledPatientLocationItem.sLastVDateLatitude  = "32.84517288208008"
                    }
                }
                
                if (scheduledPatientLocationItem.sLastVDateLongitude.count < 1)
                {
                    cExportNoLastVDateLongitudeItems += 1

                    if (bForceApplyOfficeLatLongAddr == true)
                    {
                        scheduledPatientLocationItem.sLastVDateLongitude = "-97.12534332275391"
                    }
                }
                
                if (scheduledPatientLocationItem.sLastVDateAddress.count < 1)
                {
                    cExportNoLastVDateAddressItems   += 1

                    if (bForceApplyOfficeLatLongAddr == true)
                    {
                        scheduledPatientLocationItem.sLastVDateAddress   = "2509 Bedford Road, Bedford, Texas 76021"
                    }
                }

                // ----------------------------------------------------------------------------------------------
                //  var cExportScheduleTypeUndefined:Int = 0
                //  var cExportScheduleTypePastDate:Int  = 0
                //  var cExportScheduleTypeScheduled:Int = 0
                //  var cExportScheduleTypeDone:Int      = 0
                //  var cExportScheduleTypeDateError:Int = 0
                //  var cExportScheduleTypeMissed:Int    = 0
                //
                //  enum ScheduleType: String, CaseIterable
                //  {
                //      case undefined = "Undefined"
                //      case pastdate  = "PastDate"
                //      case scheduled = "Scheduled"
                //      case done      = "Done"
                //      case dateError = "DateError"
                //      case missed    = "Missed"
                //  }   // End of enum ScheduleType(String, CaseIterable).
                //
                //  var scheduledPatientLocationItem.scheduleType:ScheduleType = ScheduleType.undefined
                // ----------------------------------------------------------------------------------------------

                switch (scheduledPatientLocationItem.scheduleType)
                {
                    case ScheduleType.undefined:
                        cExportScheduleTypeUndefined += 1
                    case ScheduleType.pastdate:
                        cExportScheduleTypePastDate  += 1
                    case ScheduleType.scheduled:
                        cExportScheduleTypeScheduled += 1
                    case ScheduleType.done:
                        cExportScheduleTypeDone      += 1
                    case ScheduleType.dateError:
                        cExportScheduleTypeDateError += 1
                    case ScheduleType.missed:
                        cExportScheduleTypeMissed    += 1
                }

            }

        }

        // Create the result Dictionary from the discrete count(s)...

        dictAuditExportSchedPatientLocItemsMetrics["TotalTIDs"]                 = "\(cExportPFTherapistTotalTIDs)"
        dictAuditExportSchedPatientLocItemsMetrics["TotalTIDsCounted"]          = "\(cExportPFTherapistParseTIDs)"
        dictAuditExportSchedPatientLocItemsMetrics["TotalPatientVisits"]        = "\(cTotalExportScheduledPatientLocationItems)"

        dictAuditExportSchedPatientLocItemsMetrics["TotalUniqueTIDs"]           = "\(listOfExportTIDs.count)"
        dictAuditExportSchedPatientLocItemsMetrics["TotalUniquePIDs"]           = "\(listOfExportPIDs.count)"

        dictAuditExportSchedPatientLocItemsMetrics["TotalNoLastVDate"]          = "\(cExportNoLastVDateItems)"
        dictAuditExportSchedPatientLocItemsMetrics["TotalNoLastVDateLatitude"]  = "\(cExportNoLastVDateLatitudeItems)"
        dictAuditExportSchedPatientLocItemsMetrics["TotalNoLastVDateLongitude"] = "\(cExportNoLastVDateLongitudeItems)"
        dictAuditExportSchedPatientLocItemsMetrics["TotalNoLastVDateAddress"]   = "\(cExportNoLastVDateAddressItems)"

        dictAuditExportSchedPatientLocItemsMetrics["ScheduleType.Undefined"]    = "\(cExportScheduleTypeUndefined)"
        dictAuditExportSchedPatientLocItemsMetrics["ScheduleType.PastDate"]     = "\(cExportScheduleTypePastDate)"
        dictAuditExportSchedPatientLocItemsMetrics["ScheduleType.Scheduled"]    = "\(cExportScheduleTypeScheduled)"
        dictAuditExportSchedPatientLocItemsMetrics["ScheduleType.Done"]         = "\(cExportScheduleTypeDone)"
        dictAuditExportSchedPatientLocItemsMetrics["ScheduleType.DateError"]    = "\(cExportScheduleTypeDateError)"
        dictAuditExportSchedPatientLocItemsMetrics["ScheduleType.Missed"]       = "\(cExportScheduleTypeMissed)"

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'dictAuditExportSchedPatientLocItemsMetrics' has #(\(dictAuditExportSchedPatientLocItemsMetrics.count)) item(s) of [\(String(describing: dictAuditExportSchedPatientLocItemsMetrics))]...")
  
        return dictAuditExportSchedPatientLocItemsMetrics

    }   // End of public func auditExportSchedPatientLocItems(bForceApplyOfficeLatLongAddr:Bool = false)->[String:String].
    
    public func exportJmAppPFQueriesForScheduledLocations()->Bool
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Check that we have data to 'export'...
      
        if (self.dictExportSchedPatientLocItems.count < 1)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) For 'self.dictExportSchedPatientLocItems' with #(\(self.dictExportSchedPatientLocItems.count)) item(s) is an 'empty' dictionary - unable to process the 'export' data - Error!")
      
            // Exit...
      
            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
      
            return false
        
        }
  
        // Convert the dictionary of 'export' SchedPatientLocItems into an Excel file...

        self.xcgLogMsg("\(sCurrMethodDisp) <SwiftXLSX> For 'self.dictExportSchedPatientLocItems' with #(\(self.dictExportSchedPatientLocItems.count)) item(s) - converting the 'export' data into Excel...")

        // Set the SwiftXLSX WorkBook/WorkSheet 'title' line...

        let xlsxWorkBook:XWorkBook          = XWorkBook()
        var xlsxWorkSheet:XSheet            = xlsxWorkBook.NewSheet("ScheduleLocations")

        var xlsxCurrentCell:XCell           = xlsxWorkSheet.AddCell(XCoords(row:1, col:1))
        xlsxCurrentCell.value               = .text("Therapist")
        xlsxCurrentCell.alignmentHorizontal = .left
        xlsxCurrentCell.Font                = XFont(.TrebuchetMS, 18, true)

        xlsxCurrentCell                     = xlsxWorkSheet.AddCell(XCoords(row:1, col:2))
        xlsxCurrentCell.value               = .text("Visit Date")
        xlsxCurrentCell.alignmentHorizontal = .center
        xlsxCurrentCell.Font                = XFont(.TrebuchetMS, 18, true)

        xlsxCurrentCell                     = xlsxWorkSheet.AddCell(XCoords(row:1, col:3))
        xlsxCurrentCell.value               = .text("Visit Time")
        xlsxCurrentCell.alignmentHorizontal = .center
        xlsxCurrentCell.Font                = XFont(.TrebuchetMS, 18, true)

        xlsxCurrentCell                     = xlsxWorkSheet.AddCell(XCoords(row:1, col:4))
        xlsxCurrentCell.value               = .text("Patient")
        xlsxCurrentCell.alignmentHorizontal = .center
        xlsxCurrentCell.Font                = XFont(.TrebuchetMS, 18, true)

        xlsxCurrentCell                     = xlsxWorkSheet.AddCell(XCoords(row:1, col:5))
        xlsxCurrentCell.value               = .text("DOB")
        xlsxCurrentCell.alignmentHorizontal = .center
        xlsxCurrentCell.Font                = XFont(.TrebuchetMS, 18, true)

        xlsxCurrentCell                     = xlsxWorkSheet.AddCell(XCoords(row:1, col:6))
        xlsxCurrentCell.value               = .text("Address")
        xlsxCurrentCell.alignmentHorizontal = .center
        xlsxCurrentCell.Font                = XFont(.TrebuchetMS, 18, true)

        xlsxCurrentCell                     = xlsxWorkSheet.AddCell(XCoords(row:1, col:7))
        xlsxCurrentCell.value               = .text("Latitude")
        xlsxCurrentCell.alignmentHorizontal = .center
        xlsxCurrentCell.Font                = XFont(.TrebuchetMS, 18, true)

        xlsxCurrentCell                     = xlsxWorkSheet.AddCell(XCoords(row:1, col:8))
        xlsxCurrentCell.value               = .text("Longitude")
        xlsxCurrentCell.alignmentHorizontal = .center
        xlsxCurrentCell.Font                = XFont(.TrebuchetMS, 18, true)

        xlsxCurrentCell                     = xlsxWorkSheet.AddCell(XCoords(row:1, col:9))
        xlsxCurrentCell.value               = .text("Primary Ins")
        xlsxCurrentCell.alignmentHorizontal = .center
        xlsxCurrentCell.Font                = XFont(.TrebuchetMS, 18, true)

        xlsxCurrentCell                     = xlsxWorkSheet.AddCell(XCoords(row:1, col:10))
        xlsxCurrentCell.value               = .text("emm_acc")
        xlsxCurrentCell.alignmentHorizontal = .center
        xlsxCurrentCell.Font                = XFont(.TrebuchetMS, 18, true)

        // Loop to build the SwiftXLSX WorkBook/WorkSheet 'data' line(s)...

        let cExportPFTherapistTotalTIDs:Int               = self.dictExportSchedPatientLocItems.count
        var cExportPFTherapistParseTIDs:Int               = 0
        var cTotalExportScheduledPatientLocationItems:Int = 0
        var cXLSXWorksheetRow:Int                         = 1

        for (sPFTherapistParseTID, listScheduledPatientLocationItems) in self.dictExportSchedPatientLocItems
        {
            
            cExportPFTherapistParseTIDs += 1

            if (sPFTherapistParseTID.count  < 1 ||
                sPFTherapistParseTID       == "-N/A-")
            {

                self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cExportPFTherapistParseTIDs)) 'sPFTherapistParseTID' - the 'tid' field is nil or '-N/A-' - Warning!")

                continue

            }

            if (listScheduledPatientLocationItems.count < 1)
            {

                self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cExportPFTherapistParseTIDs)) 'sPFTherapistParseTID' of [\(sPFTherapistParseTID)] - the 'listScheduledPatientLocationItems' field is nil or the count is less than 1 - Warning!")

                continue

            }

            for scheduledPatientLocationItem in listScheduledPatientLocationItems
            {

                cTotalExportScheduledPatientLocationItems += 1
                cXLSXWorksheetRow                         += 1

                var xlsxCurrentCell:XCell           = xlsxWorkSheet.AddCell(XCoords(row:cXLSXWorksheetRow, col:1))
                xlsxCurrentCell.value               = .text(scheduledPatientLocationItem.sTherapistName)
                xlsxCurrentCell.alignmentHorizontal = .left
                xlsxCurrentCell.Font                = XFont(.TrebuchetMS, 18, true)

                xlsxCurrentCell                     = xlsxWorkSheet.AddCell(XCoords(row:cXLSXWorksheetRow, col:2))
                xlsxCurrentCell.value               = .text(scheduledPatientLocationItem.sVDate)
                xlsxCurrentCell.alignmentHorizontal = .center
                xlsxCurrentCell.Font                = XFont(.TrebuchetMS, 18, true)

                xlsxCurrentCell                     = xlsxWorkSheet.AddCell(XCoords(row:cXLSXWorksheetRow, col:3))
                xlsxCurrentCell.value               = .text(scheduledPatientLocationItem.sVDateStartTime)
                xlsxCurrentCell.alignmentHorizontal = .center
                xlsxCurrentCell.Font                = XFont(.TrebuchetMS, 18, true)

                xlsxCurrentCell                     = xlsxWorkSheet.AddCell(XCoords(row:cXLSXWorksheetRow, col:4))
                xlsxCurrentCell.value               = .text(scheduledPatientLocationItem.sPtName)
                xlsxCurrentCell.alignmentHorizontal = .center
                xlsxCurrentCell.Font                = XFont(.TrebuchetMS, 18, true)

                xlsxCurrentCell                     = xlsxWorkSheet.AddCell(XCoords(row:cXLSXWorksheetRow, col:5))
                xlsxCurrentCell.value               = .text(scheduledPatientLocationItem.sPatientDOB)
                xlsxCurrentCell.alignmentHorizontal = .center
                xlsxCurrentCell.Font                = XFont(.TrebuchetMS, 18, true)

                xlsxCurrentCell                     = xlsxWorkSheet.AddCell(XCoords(row:cXLSXWorksheetRow, col:6))
                xlsxCurrentCell.value               = .text(scheduledPatientLocationItem.sLastVDateAddress)
                xlsxCurrentCell.alignmentHorizontal = .center
                xlsxCurrentCell.Font                = XFont(.TrebuchetMS, 18, true)

                xlsxCurrentCell                     = xlsxWorkSheet.AddCell(XCoords(row:cXLSXWorksheetRow, col:7))
                xlsxCurrentCell.value               = .text(scheduledPatientLocationItem.sLastVDateLatitude)
                xlsxCurrentCell.alignmentHorizontal = .center
                xlsxCurrentCell.Font                = XFont(.TrebuchetMS, 18, true)

                xlsxCurrentCell                     = xlsxWorkSheet.AddCell(XCoords(row:cXLSXWorksheetRow, col:8))
                xlsxCurrentCell.value               = .text(scheduledPatientLocationItem.sLastVDateLongitude)
                xlsxCurrentCell.alignmentHorizontal = .center
                xlsxCurrentCell.Font                = XFont(.TrebuchetMS, 18, true)

                xlsxCurrentCell                     = xlsxWorkSheet.AddCell(XCoords(row:cXLSXWorksheetRow, col:9))
            //  xlsxCurrentCell.value               = .text("\(scheduledPatientLocationItem.iPatientPrimaryIns)")
                xlsxCurrentCell.value               = .text(InsuranceType.allCases[scheduledPatientLocationItem.iPatientPrimaryIns].rawValue)
                xlsxCurrentCell.alignmentHorizontal = .center
                xlsxCurrentCell.Font                = XFont(.TrebuchetMS, 18, true)

                xlsxCurrentCell                     = xlsxWorkSheet.AddCell(XCoords(row:cXLSXWorksheetRow, col:10))
                xlsxCurrentCell.value               = .text("ROOFTOP")
                xlsxCurrentCell.alignmentHorizontal = .center
                xlsxCurrentCell.Font                = XFont(.TrebuchetMS, 18, true)

            }

        }

        xlsxWorkSheet.buildindex()

        xlsxWorkSheet.ForColumnSetWidth(1,  180)
        xlsxWorkSheet.ForColumnSetWidth(2,  100)
        xlsxWorkSheet.ForColumnSetWidth(3,  100)
        xlsxWorkSheet.ForColumnSetWidth(4,  240)
        xlsxWorkSheet.ForColumnSetWidth(5,  100)
        xlsxWorkSheet.ForColumnSetWidth(6,  240)
        xlsxWorkSheet.ForColumnSetWidth(7,  200)
        xlsxWorkSheet.ForColumnSetWidth(8,  200)
        xlsxWorkSheet.ForColumnSetWidth(9,  180)
        xlsxWorkSheet.ForColumnSetWidth(10, 120)

        // Upload the 'export' Schedule Patient Location(s) data...

        let sXLSXFilename:String       = "ScheduledPatientLocations.xlsx"
        let sXLSXFilespec:String       = xlsxWorkBook.save(sXLSXFilename)
        let bIsAppXLSXFilePresent:Bool = JmFileIO.fileExists(sFilespec:sXLSXFilespec)

        self.xcgLogMsg("\(sCurrMethodDisp) <SwiftXLSX> 'export' for a 'sXLSXFilename' of [\(sXLSXFilename)] created a 'sXLSXFilespec' of [\(sXLSXFilespec)] and 'bIsAppXLSXFilePresent' is [\(bIsAppXLSXFilePresent)]...")

        if (bIsAppXLSXFilePresent == true)
        {

            self.xcgLogMsg("[\(sCurrMethodDisp)] <SwiftXLSX> Preparing to upload the 'source' filespec ('current' SwiftXLSX file) of [\(String(describing: sXLSXFilespec))]...")

        }
        else
        {

            self.xcgLogMsg("[\(sCurrMethodDisp)] <SwiftXLSX> Failed to create an XLSX spreadsheet for a 'sXLSXFilename' of [\(sXLSXFilename)] created a 'sXLSXFilespec' of [\(sXLSXFilespec)] and 'bIsAppXLSXFilePresent' is [\(bIsAppXLSXFilePresent)] - the file is NOT present - Error!")
            
            // Exit...
            
            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
            
            return false
            
        }

        // Create the XLSX file's 'multipartRequestInfo' object (but WITHOUT any Data (yet))...

        let multipartRequestInfo:MultipartRequestInfo = MultipartRequestInfo()

        multipartRequestInfo.bAppZipSourceToUpload    = false
        multipartRequestInfo.sAppUploadURL            = ""          // "" takes the Upload URL 'default'...
        multipartRequestInfo.sAppUploadNotifyTo       = ""          // This is email notification - "" defaults to all Dev(s)...
        multipartRequestInfo.sAppUploadNotifyCc       = ""          // This is email notification - "" defaults to 'none'...
        multipartRequestInfo.sAppSourceFilespec       = sXLSXFilespec
        multipartRequestInfo.sAppSourceFilename       = sXLSXFilename
        multipartRequestInfo.sAppZipFilename          = ""
        multipartRequestInfo.sAppSaveAsFilename       = sXLSXFilename
        multipartRequestInfo.sAppFileMimeType         = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    //  multipartRequestInfo.sAppFileMimeType         = "text/plain"

        // Create the XLSX file's 'multipartRequestInfo.dataAppFile' object...

        multipartRequestInfo.dataAppFile              = FileManager.default.contents(atPath:sXLSXFilespec)

        self.xcgLogMsg("\(sCurrMethodDisp) <SwiftXLSX> The 'upload' is using 'multipartRequestInfo' of [\(String(describing: multipartRequestInfo.toString()))]...")

        // Send the XLSX file as an 'upload' to the Server...

        let multipartRequestDriver:MultipartRequestDriver = MultipartRequestDriver(bGenerateResponseLongMsg:true)

        self.xcgLogMsg("\(sCurrMethodDisp) <SwiftXLSX> Using 'multipartRequestInfo' of [\(String(describing: multipartRequestInfo.toString()))]...")
        self.xcgLogMsg("\(sCurrMethodDisp) <SwiftXLSX> Calling 'multipartRequestDriver.executeMultipartRequest(multipartRequestInfo:)'...")

        multipartRequestDriver.executeMultipartRequest(multipartRequestInfo:multipartRequestInfo)

        self.xcgLogMsg("\(sCurrMethodDisp) <SwiftXLSX> Called  'multipartRequestDriver.executeMultipartRequest(multipartRequestInfo:)'...")

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return true

    } // End of public func exportJmAppPFQueriesForScheduledLocations()->Bool.
    
    public func convertTidToTherapistName(sPFTherapistParseTID:String = "")->String
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'sPFTherapistParseTID' is [\(sPFTherapistParseTID)]...")

        // Lookup and convert the 'sPFTherapistParseTID' to 'sPFTherapistParseName'...

        var sPFTherapistParseName:String = ""

        if (sPFTherapistParseTID.count      > 0 &&
            self.dictTherapistTidXref.count > 0)
        {
        
            if (self.dictTherapistTidXref[sPFTherapistParseTID] != nil)
            {

                sPFTherapistParseName = self.dictTherapistTidXref[sPFTherapistParseTID] ?? ""

            }
        
        }
        
        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'sPFTherapistParseName' is [\(sPFTherapistParseName)]...")
  
        return sPFTherapistParseName

    } // End of public func convertTidToTherapistName(sPFTherapistParseTID:String)->String.
    
    public func convertTherapistNameToTid(sPFTherapistParseName:String = "")->String
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'sPFTherapistParseName' is [\(sPFTherapistParseName)]...")

        // Lookup and convert the 'sPFTherapistParseName' to 'sPFTherapistParseTID'...

        var sPFTherapistParseTID:String = ""

        if (sPFTherapistParseName.count     > 0 &&
            self.dictTherapistTidXref.count > 0)
        {

            let sPFTherapistParseNameLower:String     = sPFTherapistParseName.lowercased()
            let sPFTherapistParseNameLowerNoWS:String = sPFTherapistParseName.removeUnwantedCharacters(charsetToRemove:[StringCleaning.removeAll], bResultIsLowerCased:true)

            if (self.dictTherapistTidXref[sPFTherapistParseNameLower] != nil)
            {

                sPFTherapistParseTID = self.dictTherapistTidXref[sPFTherapistParseNameLower] ?? ""

            }
        
            if (sPFTherapistParseTID.count < 1)
            {

                self.xcgLogMsg("\(sCurrMethodDisp) <Convert Name to TID> - 'sPFTherapistParseNameLower' of [\(sPFTherapistParseNameLower)] did NOT 'match' - trying without WhiteSpace using 'sPFTherapistParseNameLowerNoWS' of [\(sPFTherapistParseNameLowerNoWS)]...")

                sPFTherapistParseTID = self.dictTherapistTidXref[sPFTherapistParseNameLowerNoWS] ?? ""

                if (sPFTherapistParseTID.count < 1)
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) <Convert Name to TID> - 'sPFTherapistParseNameLowerNoWS' of [\(sPFTherapistParseNameLowerNoWS)] did NOT 'match' - unable to convert Name to TID - Error!")

                }

            }

        }
        
        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'sPFTherapistParseTID' is [\(sPFTherapistParseTID)]...")
  
        return sPFTherapistParseTID

    } // End of public func convertTherapistNameToTid(sPFTherapistParseName:String)->String.
    
    public func convertPidToPatientName(sPFPatientParsePID:String = "")->String
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'sPFPatientParsePID' is [\(sPFPatientParsePID)]...")

        // Lookup and convert the 'sPFPatientParsePID' to 'sPFPatientParseName'...

        var sPFPatientParseName:String = ""

        if (sPFPatientParsePID.count      > 0 &&
            self.dictPatientPidXref.count > 0)
        {
        
            if (self.dictPatientPidXref[sPFPatientParsePID] != nil)
            {

                sPFPatientParseName = self.dictPatientPidXref[sPFPatientParsePID] ?? ""

            }
        
        }
        
        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'sPFPatientParseName' is [\(sPFPatientParseName)]...")
  
        return sPFPatientParseName

    } // End of public func convertPidToPatientName(sPFPatientParsePID:String)->String.
    
    public func convertPatientNameToPid(sPFPatientParseName:String = "")->String
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'sPFPatientParseName' is [\(sPFPatientParseName)]...")

        // Lookup and convert the 'sPFPatientParseName' to 'sPFPatientParsePID'...

        var sPFPatientParsePID:String = ""

        if (sPFPatientParseName.count     > 0 &&
            self.dictPatientPidXref.count > 0)
        {

            let sPFPatientParseNameLower:String     = sPFPatientParseName.lowercased()
            let sPFPatientParseNameLowerNoWS:String = sPFPatientParseName.removeUnwantedCharacters(charsetToRemove:[StringCleaning.removeAll], bResultIsLowerCased:true)

            if (self.dictPatientPidXref[sPFPatientParseNameLower] != nil)
            {

                sPFPatientParsePID = self.dictPatientPidXref[sPFPatientParseNameLower] ?? ""

            }
        
            if (sPFPatientParsePID.count < 1)
            {

                self.xcgLogMsg("\(sCurrMethodDisp) <Convert Name to PID> - 'sPFPatientParseNameLower' of [\(sPFPatientParseNameLower)] did NOT 'match' - trying without WhiteSpace using 'sPFPatientParseNameLowerNoWS' of [\(sPFPatientParseNameLowerNoWS)]...")

                sPFPatientParsePID = self.dictPatientPidXref[sPFPatientParseNameLowerNoWS] ?? ""

                if (sPFPatientParsePID.count < 1)
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) <Convert Name to PID> - 'sPFPatientParseNameLowerNoWS' of [\(sPFPatientParseNameLowerNoWS)] did NOT 'match' - unable to convert Name to PID - Error!")

                }

            }

        }
        
        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'sPFPatientParsePID' is [\(sPFPatientParsePID)]...")
  
        return sPFPatientParsePID

    } // End of public func convertPatientNameToPid(sPFPatientParseName:String)->String.
    
    // This method can NOT be declared 'public' because its' result is an 'internal' type (ParsePFCscDataItem)...
    
    func locatePFCscDataItemByID(id:UUID)->ParsePFCscDataItem
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'id' is [\(id)]...")

        // Locate a given PFCscDataItem given an 'id' (aka, UUID)...

        var pfCscDataItem:ParsePFCscDataItem = ParsePFCscDataItem()

        if (self.listPFCscDataItems.count > 1)
        {
        
            for currentPFCscDataItem:ParsePFCscDataItem in self.listPFCscDataItems
            {

                if (currentPFCscDataItem.id == id)
                {
                
                    pfCscDataItem = currentPFCscDataItem
                    
                    break
                
                }

            }
        
        }
        
        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'pfCscDataItem' is [\(pfCscDataItem)]...")
  
        return pfCscDataItem

    } // End of func locatePFCscDataItemByID(id:UUID)->ParsePFCscDataItem.
    
    public func deepCopyDictPFAdminsDataItems()->Int
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Deep copy the dictionary 'dictPFAdminsDataItems' from here to the 'jmAppParseCoreManager'...

        self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy'ing the dictionary 'dictPFAdminsDataItems' of (\(self.dictPFAdminsDataItems.count)) 'parsePFAdminsDataItem' item(s)...")

        var cDeepCopyPFAdminsDataItems:Int                               = 0 
        var dictDeepCopyPFAdminsDataItems:[String:ParsePFAdminsDataItem] = [String:ParsePFAdminsDataItem]()

        for (_, parsePFAdminsDataItem) in self.dictPFAdminsDataItems
        {

            cDeepCopyPFAdminsDataItems                    += 1
            let newPFAdminsDataItem:ParsePFAdminsDataItem  = ParsePFAdminsDataItem(pfAdminsDataItem:parsePFAdminsDataItem)

            let sPFAdminsParseTID:String = parsePFAdminsDataItem.sPFAdminsParseTID

            if (sPFAdminsParseTID.count  < 1 ||
                sPFAdminsParseTID       == "-N/A-")
            {

                self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy' Skipping object #(\(cDeepCopyPFAdminsDataItems)) 'parsePFAdminsDataItem' - the 'tid' field is nil or '-N/A-' - Warning!")

                continue

            }

            dictDeepCopyPFAdminsDataItems[sPFAdminsParseTID] = newPFAdminsDataItem

            self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy' Added object #(\(cDeepCopyPFAdminsDataItems)) 'newPFAdminsDataItem' keyed by 'sPFAdminsParseTID' of [\(sPFAdminsParseTID)] to the 'deep copy' dictionary of item(s)...")

        }

        DispatchQueue.main.async
        {

            self.jmAppParseCoreManager.dictPFAdminsDataItems = dictDeepCopyPFAdminsDataItems

            if (dictDeepCopyPFAdminsDataItems.count > 0)
            {

                self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy' replaced #(\(dictDeepCopyPFAdminsDataItems.count)) item(s) in the ParseCoreManager 'dictPFAdminsDataItems'...")

            }
            else
            {

                self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy' replaced the ParseCoreManager 'dictPFAdminsDataItems' with an 'empty' dictionary - NO item(s) were available...")

            }

        }
        
        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'dictDeepCopyPFAdminsDataItems.count' is (\(dictDeepCopyPFAdminsDataItems.count))...")
  
        return dictDeepCopyPFAdminsDataItems.count

    } // End of func deepCopyDictPFAdminsDataItems()->Int.
    
    public func deepCopyDictTherapistTidXref()->Int
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Deep copy the dictionary 'dictTherapistTidXref' from here to the 'jmAppParseCoreManager'...

        self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy'ing the dictionary 'dictTherapistTidXref' of (\(self.dictTherapistTidXref.count)) 'string' item(s)...")

        var cDeepCopyTherapistTidXrefItems:Int                = 0 
        var dictDeepCopyTherapistTidXrefItems:[String:String] = [String:String]()

        for (sTherapistTidXrefKey, sTherapistTidXrefValue) in self.dictTherapistTidXref
        {

            cDeepCopyTherapistTidXrefItems       += 1
            let sNewTherapistTidXrefKey:String    = sTherapistTidXrefKey
            let sNewTherapistTidXrefValue:String  = sTherapistTidXrefValue

            if (sNewTherapistTidXrefKey.count < 1)
            {

                self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy' Skipping object #(\(cDeepCopyTherapistTidXrefItems)) - the 'key' field is nil - Warning!")

                continue

            }

            dictDeepCopyTherapistTidXrefItems[sNewTherapistTidXrefKey] = sNewTherapistTidXrefValue

            self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy' Added referance #(\(cDeepCopyTherapistTidXrefItems)) keyed by 'sNewTherapistTidXrefKey' of [\(sNewTherapistTidXrefKey)] to the 'deep copy' dictionary of item(s)...")

        }

        DispatchQueue.main.async
        {

            self.jmAppParseCoreManager.dictTherapistTidXref = dictDeepCopyTherapistTidXrefItems

            if (dictDeepCopyTherapistTidXrefItems.count > 0)
            {

                self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy' replaced #(\(dictDeepCopyTherapistTidXrefItems.count)) item(s) in the ParseCoreManager 'dictTherapistTidXref'...")

            }
            else
            {

                self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy' replaced the ParseCoreManager 'dictTherapistTidXref' with an 'empty' dictionary - NO item(s) were available...")

            }

        }

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'dictDeepCopyTherapistTidXrefItems.count' is (\(dictDeepCopyTherapistTidXrefItems.count))...")
  
        return dictDeepCopyTherapistTidXrefItems.count

    } // End of func deepCopyDictTherapistTidXref()->Int.
    
    public func deepCopyDictPFTherapistFileItems()->Int
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Deep copy the dictionary 'dictPFTherapistFileItems' from here to the 'jmAppParseCoreManager'...
        
        self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy'ing the dictionary 'dictPFTherapistFileItems' of (\(self.dictPFTherapistFileItems.count)) 'pfTherapistFileItem' item(s)...")

        var cDeepCopyPFTherapistFileItems:Int                               = 0 
        var dictDeepCopyPFTherapistFileItems:[Int:ParsePFTherapistFileItem] = [Int:ParsePFTherapistFileItem]()

        for (iPFTherapistFileTID, pfTherapistFileItem) in self.dictPFTherapistFileItems
        {

            cDeepCopyPFTherapistFileItems                            += 1
            let iNewPFTherapistFileTID:Int                            = iPFTherapistFileTID
            let newPFTherapistFileItem:ParsePFTherapistFileItem       = ParsePFTherapistFileItem(pfTherapistFileItem:pfTherapistFileItem)
            dictDeepCopyPFTherapistFileItems[iNewPFTherapistFileTID]  = newPFTherapistFileItem

            self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy' Added object #(\(cDeepCopyPFTherapistFileItems)) 'newPFTherapistFileItem' keyed by 'iNewPFTherapistFileTID' of (\(iNewPFTherapistFileTID)) to the 'deep copy' dictionary of item(s)...")

        }

        DispatchQueue.main.async
        {

            self.jmAppParseCoreManager.dictPFTherapistFileItems = dictDeepCopyPFTherapistFileItems

            if (dictDeepCopyPFTherapistFileItems.count > 0)
            {

                self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy' replaced #(\(dictDeepCopyPFTherapistFileItems.count)) item(s) in the ParseCoreManager 'dictPFTherapistFileItems'...")

            }
            else
            {

                self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy' replaced the ParseCoreManager 'dictPFTherapistFileItems' with an 'empty' dictionary - NO item(s) were available...")

            }

        }

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'dictDeepCopyPFTherapistFileItems.count' is (\(dictDeepCopyPFTherapistFileItems.count))...")
  
        return dictDeepCopyPFTherapistFileItems.count

    } // End of func deepCopyDictPFTherapistFileItems()->Int.
    
    public func deepCopyDictPatientPidXref()->Int
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Deep copy the dictionary 'dictPatientPidXref' from here to the 'jmAppParseCoreManager'...
      
        self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy'ing the dictionary 'dictPatientPidXref' of (\(self.dictPatientPidXref.count)) 'string' item(s)...")
      
        var cDeepCopyPatientPidXrefItems:Int                = 0 
        var dictDeepCopyPatientPidXrefItems:[String:String] = [String:String]()
      
        for (sPatientPidXrefKey, sPatientPidXrefValue) in self.dictPatientPidXref
        {
      
            cDeepCopyPatientPidXrefItems       += 1
            let sNewPatientPidXrefKey:String    = sPatientPidXrefKey
            let sNewPatientPidXrefValue:String  = sPatientPidXrefValue
      
            if (sNewPatientPidXrefKey.count < 1)
            {
      
                self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy' Skipping object #(\(cDeepCopyPatientPidXrefItems)) - the 'key' field is nil - Warning!")
      
                continue
      
            }
      
            dictDeepCopyPatientPidXrefItems[sNewPatientPidXrefKey] = sNewPatientPidXrefValue
      
            self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy' Added referance #(\(cDeepCopyPatientPidXrefItems)) keyed by 'sNewPatientPidXrefKey' of [\(sNewPatientPidXrefKey)] to the 'deep copy' dictionary of item(s)...")
      
        }
      
        DispatchQueue.main.async
        {
      
            self.jmAppParseCoreManager.dictPatientPidXref = dictDeepCopyPatientPidXrefItems
      
            if (dictDeepCopyPatientPidXrefItems.count > 0)
            {
      
                self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy' replaced #(\(dictDeepCopyPatientPidXrefItems.count)) item(s) in the ParseCoreManager 'dictPatientPidXref'...")
      
            }
            else
            {
      
                self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy' replaced the ParseCoreManager 'dictPatientPidXref' with an 'empty' dictionary - NO item(s) were available...")
      
            }
      
        }
      
        // Exit...
      
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'dictDeepCopyPatientPidXrefItems.count' is (\(dictDeepCopyPatientPidXrefItems.count))...")
      
        return dictDeepCopyPatientPidXrefItems.count

    } // End of func deepCopyDictPatientPidXref()->Int.
    
    public func deepCopyDictPFPatientFileItems()->Int
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Deep copy the dictionary 'dictPFPatientFileItems' from here to the 'jmAppParseCoreManager'...
        
        self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy'ing the dictionary 'dictPFPatientFileItems' of (\(self.dictPFPatientFileItems.count)) 'pfPatientFileItem' item(s)...")
      
        var cDeepCopyPFPatientFileItems:Int                               = 0 
        var dictDeepCopyPFPatientFileItems:[Int:ParsePFPatientFileItem] = [Int:ParsePFPatientFileItem]()
      
        for (iPFPatientFilePID, pfPatientFileItem) in self.dictPFPatientFileItems
        {
      
            cDeepCopyPFPatientFileItems                            += 1
            let iNewPFPatientFilePID:Int                            = iPFPatientFilePID
            let newPFPatientFileItem:ParsePFPatientFileItem       = ParsePFPatientFileItem(pfPatientFileItem:pfPatientFileItem)
            dictDeepCopyPFPatientFileItems[iNewPFPatientFilePID]  = newPFPatientFileItem
      
            self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy' Added object #(\(cDeepCopyPFPatientFileItems)) 'newPFPatientFileItem' keyed by 'iNewPFPatientFilePID' of (\(iNewPFPatientFilePID)) to the 'deep copy' dictionary of item(s)...")
      
        }
      
        DispatchQueue.main.async
        {
      
            self.jmAppParseCoreManager.dictPFPatientFileItems = dictDeepCopyPFPatientFileItems
      
            if (dictDeepCopyPFPatientFileItems.count > 0)
            {
      
                self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy' replaced #(\(dictDeepCopyPFPatientFileItems.count)) item(s) in the ParseCoreManager 'dictPFPatientFileItems'...")
      
            }
            else
            {
      
                self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy' replaced the ParseCoreManager 'dictPFPatientFileItems' with an 'empty' dictionary - NO item(s) were available...")
      
            }
      
        }
      
        // Exit...
      
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'dictDeepCopyPFPatientFileItems.count' is (\(dictDeepCopyPFPatientFileItems.count))...")
      
        return dictDeepCopyPFPatientFileItems.count
        
    } // End of func deepCopyDictPFPatientFileItems()->Int.
    
    public func deepCopyDictSchedPatientLocItems()->Int
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Deep copy the dictionary 'dictSchedPatientLocItems' from here to the 'jmAppParseCoreManager'...

        self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy'ing the dictionary 'dictSchedPatientLocItems' of (\(self.dictSchedPatientLocItems.count)) ['scheduledPatientLocationItem'] item(s)...")

        var cDeepCopySchedPatientLocItems:Int                                                 = 0 
        var dictDeepCopyScheduledPatientLocationItems:[String:[ScheduledPatientLocationItem]] = [String:[ScheduledPatientLocationItem]]()

        for (sPFTherapistTID, listScheduledPatientLocationItems) in self.dictSchedPatientLocItems
        {

            cDeepCopySchedPatientLocItems += 1
            let sNewPFTherapistTID:String  = sPFTherapistTID

            if (sNewPFTherapistTID.count < 1)
            {

                self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy' Skipping object #(\(cDeepCopySchedPatientLocItems)) - the 'sNewPFTherapistTID' <key> field is nil - Warning!")

                continue

            }

            self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy'ing the list of (\(listScheduledPatientLocationItems.count)) 'listScheduledPatientLocationItems' item(s)...")

            var listNewScheduledPatientLocationItems:[ScheduledPatientLocationItem] = [ScheduledPatientLocationItem]()

            for scheduledPatientLocationItem in listScheduledPatientLocationItems
            {

                let newScheduledPatientLocationItem:ScheduledPatientLocationItem = ScheduledPatientLocationItem(scheduledPatientLocationItem:scheduledPatientLocationItem)

                listNewScheduledPatientLocationItems.append(newScheduledPatientLocationItem)

            }

            dictDeepCopyScheduledPatientLocationItems[sNewPFTherapistTID] = listNewScheduledPatientLocationItems

            self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy' Added list #(\(cDeepCopySchedPatientLocItems)) of (\(listScheduledPatientLocationItems.count)) 'listNewScheduledPatientLocationItems' keyed by 'sNewPFTherapistTID' of [\(sNewPFTherapistTID)] to the 'deep copy' dictionary of item(s)...")

        }

        DispatchQueue.main.async
        {

            self.jmAppParseCoreManager.dictSchedPatientLocItems = dictDeepCopyScheduledPatientLocationItems

            if (dictDeepCopyScheduledPatientLocationItems.count > 0)
            {

                self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy' replaced #(\(dictDeepCopyScheduledPatientLocationItems.count)) item(s) in the ParseCoreManager 'dictSchedPatientLocItems'...")

            }
            else
            {

                self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy' replaced the ParseCoreManager 'dictSchedPatientLocItems' with an 'empty' dictionary - NO item(s) were available...")

            }

        }

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'dictDeepCopyScheduledPatientLocationItems.count' is (\(dictDeepCopyScheduledPatientLocationItems.count))...")
  
        return dictDeepCopyScheduledPatientLocationItems.count

    } // End of func deepCopyDictSchedPatientLocItems()->Int.
    
    public func deepCopyListPFCscDataItems()->Int
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Deep copy the list 'listPFCscDataItems' from here to the 'jmAppParseCoreManager'...

        self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy'ing the list 'listPFCscDataItems' of (\(self.listPFCscDataItems.count)) ['pfCscDataItem'] item(s)...")

        var cDeepCopyPFCscDataItems:Int                     = 0 
        var listDeepCopyPFCscDataItems:[ParsePFCscDataItem] = [ParsePFCscDataItem]()

        for pfCscDataItem in self.listPFCscDataItems
        {

            cDeepCopyPFCscDataItems                 += 1
            let newPFCscDataItem:ParsePFCscDataItem  = ParsePFCscDataItem(pfCscDataItem:pfCscDataItem)

            listDeepCopyPFCscDataItems.append(newPFCscDataItem)

            self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy' Added object #(\(cDeepCopyPFCscDataItems)) 'newPFCscDataItem' of [\(newPFCscDataItem)] to the 'deep copy' list of item(s)...")

        }

        DispatchQueue.main.async
        {

            self.jmAppParseCoreManager.listPFCscDataItems = listDeepCopyPFCscDataItems

            if (listDeepCopyPFCscDataItems.count > 0)
            {

                self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy' replaced #(\(listDeepCopyPFCscDataItems.count)) item(s) in the ParseCoreManager 'listPFCscDataItems'...")

            }
            else
            {

                self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy' replaced the ParseCoreManager 'listPFCscDataItems' with an 'empty' list - NO item(s) were available...")

            }

            // Kick the 'cPFCscObjectsRefresh' count to force any SwiftUI display(s) to refresh...

            self.jmAppParseCoreManager.cPFCscObjects         = listDeepCopyPFCscDataItems.count
            self.jmAppParseCoreManager.cPFCscObjectsRefresh += 1

        }

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'listDeepCopyPFCscDataItems.count' is (\(listDeepCopyPFCscDataItems.count))...")
  
        return listDeepCopyPFCscDataItems.count

    } // End of func deepCopyListPFCscDataItems()->Int.
    
    public func deepCopyListPFCscNameItems()->Int
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Deep copy the list 'listPFCscNameItems' from here to the 'jmAppParseCoreManager'...

        self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy'ing the list 'listPFCscNameItems' of (\(self.listPFCscNameItems.count)) [String] item(s)...")

        var cDeepCopyPFCscNameItems:Int         = 0 
        var listDeepCopyPFCscNameItems:[String] = [String]()

        for sPFCscParseName in self.listPFCscNameItems
        {

            cDeepCopyPFCscNameItems      += 1
            let sNewPFCscNameItem:String  = sPFCscParseName

            listDeepCopyPFCscNameItems.append(sNewPFCscNameItem)

            self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy' Added object #(\(cDeepCopyPFCscNameItems)) 'sNewPFCscNameItem' of [\(sNewPFCscNameItem)] to the 'deep copy' list of item(s)...")

        }

        DispatchQueue.main.async
        {

            self.jmAppParseCoreManager.listPFCscNameItems = listDeepCopyPFCscNameItems

            if (listDeepCopyPFCscNameItems.count > 0)
            {

                self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy' replaced #(\(listDeepCopyPFCscNameItems.count)) item(s) in the ParseCoreManager 'listPFCscNameItems'...")

            }
            else
            {

                self.xcgLogMsg("\(sCurrMethodDisp) 'deep copy' replaced the ParseCoreManager 'listPFCscNameItems' with an 'empty' list - NO item(s) were available...")

            }

        }

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'listDeepCopyPFCscNameItems.count' is (\(listDeepCopyPFCscNameItems.count))...")
  
        return listDeepCopyPFCscNameItems.count

    } // End of func deepCopyListPFCscNameItems()->Int.
    
    public func displayDictPFAdminsDataItems()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Display the dictionary of 'dictPFAdminsDataItems'...

        if (self.dictPFAdminsDataItems.count > 0)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Displaying the dictionary of 'parsePFAdminsDataItem' item(s)...")

            for (_, parsePFAdminsDataItem) in self.dictPFAdminsDataItems
            {

                parsePFAdminsDataItem.displayParsePFAdminsDataItemToLog()

            }

        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Unable to display the dictionary of 'parsePFAdminsDataItem' item(s) - item(s) count is less than 1 - Warning!")

        }
        
        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return

    } // End of func displayDictPFAdminsDataItems().
    
    public func displayDictPFTherapistFileItems()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Display the dictionary of 'dictPFTherapistFileItems'...

        if (self.dictPFTherapistFileItems.count > 0)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Displaying the dictionary of #(\(self.dictPFTherapistFileItems.count)) 'dictPFTherapistFileItems' item(s)...")

            var cPFTherapistParseTIDs:Int = 0

            for (iPFTherapistParseTID, pfTherapistFileItem) in self.dictPFTherapistFileItems
            {

                cPFTherapistParseTIDs += 1

                if (iPFTherapistParseTID < 0)
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cPFTherapistParseTIDs)) 'iPFTherapistParseTID' - the 'tid' field is less than 0 - Warning!")

                    continue

                }

                self.xcgLogMsg("\(sCurrMethodDisp) For TID [\(iPFTherapistParseTID)] - Displaying 'pfTherapistFileItem' item #(\(cPFTherapistParseTIDs)):")

                pfTherapistFileItem.displayParsePFTherapistFileItemToLog()

            }

        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Unable to display the dictionary of 'dictPFTherapistFileItems' item(s) - item(s) count is less than 1 - Warning!")

        }
        
        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return

    } // End of func displayDictPFTherapistFileItems().
    
    public func displayDictPFPatientFileItems()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Display the dictionary of 'dictPFPatientFileItems'...
      
        if (self.dictPFPatientFileItems.count > 0)
        {
      
            self.xcgLogMsg("\(sCurrMethodDisp) Displaying the dictionary of #(\(self.dictPFPatientFileItems.count)) 'dictPFPatientFileItems' item(s)...")
      
            var cPFPatientParsePIDs:Int = 0
      
            for (iPFPatientParsePID, pfPatientFileItem) in self.dictPFPatientFileItems
            {
      
                cPFPatientParsePIDs += 1
      
                if (iPFPatientParsePID < 0)
                {
      
                    self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cPFPatientParsePIDs)) 'iPFPatientParsePID' - the 'pid' field is less than 0 - Warning!")
      
                    continue
      
                }
      
                self.xcgLogMsg("\(sCurrMethodDisp) For PID [\(iPFPatientParsePID)] - Displaying 'pfPatientFileItem' item #(\(cPFPatientParsePIDs)):")
      
                pfPatientFileItem.displayParsePFPatientFileItemToLog()
      
            }
      
        }
        else
        {
      
            self.xcgLogMsg("\(sCurrMethodDisp) Unable to display the dictionary of 'dictPFPatientFileItems' item(s) - item(s) count is less than 1 - Warning!")
      
        }
        
        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return

    } // End of func displayDictPFPatientFileItems().
    
    public func displayDictSchedPatientLocItems()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Display the dictionary of 'dictSchedPatientLocItems'...

        if (self.dictSchedPatientLocItems.count > 0)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Displaying the dictionary of #(\(self.dictSchedPatientLocItems.count)) 'dictSchedPatientLocItems' item(s)...")

            let cPFTherapistTotalTIDs:Int = self.dictSchedPatientLocItems.count
            var cPFTherapistParseTIDs:Int = 0

            for (sPFTherapistParseTID, listScheduledPatientLocationItems) in self.dictSchedPatientLocItems
            {

                cPFTherapistParseTIDs += 1

                if (sPFTherapistParseTID.count  < 1 ||
                    sPFTherapistParseTID       == "-N/A-")
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cPFTherapistParseTIDs)) 'sPFTherapistParseTID' - the 'tid' field is nil or '-N/A-' - Warning!")

                    continue

                }

                if (listScheduledPatientLocationItems.count < 1)
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cPFTherapistParseTIDs)) 'sPFTherapistParseTID' of [\(sPFTherapistParseTID)] - the 'listScheduledPatientLocationItems' field is nil or the count is less than 1 - Warning!")

                    continue

                }

                var cScheduledPatientLocationItems:Int = 0

                for scheduledPatientLocationItem in listScheduledPatientLocationItems
                {

                    cScheduledPatientLocationItems += 1

                    self.xcgLogMsg("\(sCurrMethodDisp) Of #(\(cPFTherapistTotalTIDs)) TIDs - For TID [\(sPFTherapistParseTID)] - Displaying 'scheduledPatientLocationItem' item #(\(cPFTherapistParseTIDs).\(cScheduledPatientLocationItems)):")

                    scheduledPatientLocationItem.displayScheduledPatientLocationItemToLog()

                }

            }

        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Unable to display the dictionary of 'dictSchedPatientLocItems' item(s) - item(s) count is less than 1 - Warning!")

        }
        
        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return

    } // End of func displayDictSchedPatientLocItems().
    
    public func displayDictExportSchedPatientLocItems()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Display the dictionary of 'dictExportSchedPatientLocItems'...

        if (self.dictExportSchedPatientLocItems.count > 0)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Displaying the dictionary of #(\(self.dictExportSchedPatientLocItems.count)) 'dictExportSchedPatientLocItems' item(s)...")

            let cExportPFTherapistTotalTIDs:Int               = self.dictExportSchedPatientLocItems.count
            var cExportPFTherapistParseTIDs:Int               = 0
            var cTotalExportScheduledPatientLocationItems:Int = 0

            for (sPFTherapistParseTID, listScheduledPatientLocationItems) in self.dictExportSchedPatientLocItems
            {

                cExportPFTherapistParseTIDs += 1

                if (sPFTherapistParseTID.count  < 1 ||
                    sPFTherapistParseTID       == "-N/A-")
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cExportPFTherapistParseTIDs)) 'sPFTherapistParseTID' - the 'tid' field is nil or '-N/A-' - Warning!")

                    continue

                }

                if (listScheduledPatientLocationItems.count < 1)
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cExportPFTherapistParseTIDs)) 'sPFTherapistParseTID' of [\(sPFTherapistParseTID)] - the 'listScheduledPatientLocationItems' field is nil or the count is less than 1 - Warning!")

                    continue

                }

                var cExportScheduledPatientLocationItems:Int = 0

                for scheduledPatientLocationItem in listScheduledPatientLocationItems
                {

                    cExportScheduledPatientLocationItems += 1

                    self.xcgLogMsg("\(sCurrMethodDisp) Of #(\(cExportPFTherapistTotalTIDs)) TIDs - For TID [\(sPFTherapistParseTID)] - Displaying 'scheduledPatientLocationItem' item #(\(cExportPFTherapistParseTIDs).\(cExportScheduledPatientLocationItems)):")

                    scheduledPatientLocationItem.displayScheduledPatientLocationItemToLog()

                }

                self.xcgLogMsg("\(sCurrMethodDisp) <Export Counts> Of #(\(cExportPFTherapistTotalTIDs)) TIDs - #(\(cExportPFTherapistParseTIDs)) TID of [\(sPFTherapistParseTID)] has a TOTAL of #(\(cExportScheduledPatientLocationItems)) scheduled visits...")

                cTotalExportScheduledPatientLocationItems += cExportScheduledPatientLocationItems

            }

            self.xcgLogMsg("\(sCurrMethodDisp) <Export Counts> A TOTAL of #(\(cExportPFTherapistTotalTIDs)) TIDs have a TOTAL of #(\(cTotalExportScheduledPatientLocationItems)) scheduled visits...")

        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Unable to display the dictionary of 'dictExportSchedPatientLocItems' item(s) - item(s) count is less than 1 - Warning!")

        }
        
        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return

    } // End of func displayDictExportSchedPatientLocItems().
    
    public func displayDictExportBackupFileItems()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // ----------------------------------------------------------------------------------------------------------
        //  var dictExportBackupFileItems:[String:[String:ParsePFBackupFileItem]] = 
        //      [String:[String:ParsePFBackupFileItem]]()
        //          // [String:[String:ParsePFBackupFileItem]]
        //          // Key #1:"sTherapistTID(String).sPatientPID(String)"
        //          // Key #2:ParsePFBackupFileItem.sLastVDate
        //          // Value :ParsePFBackupFileItem
        // ----------------------------------------------------------------------------------------------------------

        // Display the dictionary of 'dictExportBackupFileItems'...

        if (self.bInternalTraceFlag == true)
        {
      
            self.xcgLogMsg("\(sCurrMethodDisp) <BackupVisit Display> - the dictionary of #(\(self.dictExportBackupFileItems.count)) 'dictExportBackupFileItems' item(s) is [\(String(describing: self.dictExportBackupFileItems))]...")
      
        }

        if (self.dictExportBackupFileItems.count > 0)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Displaying the dictionary of #(\(self.dictExportBackupFileItems.count)) 'dictExportBackupFileItems' item(s)...")

            let cExportTotalTIDsAndPIDs:Int     = self.dictExportBackupFileItems.count
            var cExportParseTIDsAndPIDs:Int     = 0
            var cExportTotalBackupFileItems:Int = 0

            for (sExportBackupFileItemKey1, dictExportBackupFileItemsByDate) in self.dictExportBackupFileItems
            {

                cExportParseTIDsAndPIDs += 1

                if (sExportBackupFileItemKey1.count < 1)
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cExportParseTIDsAndPIDs)) 'sExportBackupFileItemKey1' is an 'empty' string - Warning!")

                    continue

                }

                if (dictExportBackupFileItemsByDate.count < 1)
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cExportParseTIDsAndPIDs)) 'sExportBackupFileItemKey1' of [\(sExportBackupFileItemKey1)] - the 'dictExportBackupFileItemsByDate' count is less than 1 - Warning!")

                    continue

                }

                var cExportBackupFileItems:Int = 0

                for (sLastVDate, parsePFBackupFileItem) in dictExportBackupFileItemsByDate
                {

                    cExportBackupFileItems += 1

                    self.xcgLogMsg("\(sCurrMethodDisp) Of #(\(cExportTotalTIDsAndPIDs)) TIDs.PIDs Keys - For 'primary' Key [\(sExportBackupFileItemKey1)] and 'secondary' Key [\(sLastVDate)] - Displaying 'parsePFBackupFileItem' item #(\(cExportParseTIDsAndPIDs).\(cExportBackupFileItems)):")

                    parsePFBackupFileItem.displayParsePFBackupFileItemToLog()

                }

                self.xcgLogMsg("\(sCurrMethodDisp) <Export Counts> Of #(\(cExportTotalTIDsAndPIDs)) TIDs.PIDs Keys - For Key [\(sExportBackupFileItemKey1)] has a TOTAL of #(\(cExportBackupFileItems)) backup visits...")

                cExportTotalBackupFileItems += cExportBackupFileItems

            }

            self.xcgLogMsg("\(sCurrMethodDisp) <Export Counts> A TOTAL of #(\(cExportTotalTIDsAndPIDs)) TIDs.PIDs have a TOTAL of #(\(cExportTotalBackupFileItems)) backup visits...")

        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Unable to display the dictionary of 'dictExportBackupFileItems' item(s) - item(s) count is less than 1 - Warning!")

        }
        
        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return

    } // End of func displayDictExportBackupFileItems().
    
    public func displayDictExportLastBackupFileItems()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // ----------------------------------------------------------------------------------------------------------
        //  var dictExportLastBackupFileItems:[String:ParsePFBackupFileItem] = 
        //      [String:ParsePFBackupFileItem]()
        //          // [String:ParsePFBackupFileItem]
        //          // Key #1:"sTherapistTID(String).sPatientPID(String)"
        //          // Value :ParsePFBackupFileItem
        // ----------------------------------------------------------------------------------------------------------

        // Display the dictionary of 'dictExportLastBackupFileItems'...

        if (self.bInternalTraceFlag == true)
        {
      
            self.xcgLogMsg("\(sCurrMethodDisp) <BackupVisit Display> - the dictionary of #(\(self.dictExportLastBackupFileItems.count)) 'dictExportLastBackupFileItems' item(s) is [\(String(describing: self.dictExportLastBackupFileItems))]...")
      
        }

        if (self.dictExportLastBackupFileItems.count > 0)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Displaying the dictionary of #(\(self.dictExportLastBackupFileItems.count)) 'dictExportLastBackupFileItems' item(s)...")

            let cExportTotalTIDsAndPIDs:Int     = self.dictExportLastBackupFileItems.count
            var cExportParseTIDsAndPIDs:Int     = 0
            var cExportTotalBackupFileItems:Int = 0

            for (sExportBackupFileItemKey1, parsePFBackupFileItem) in self.dictExportLastBackupFileItems
            {

                cExportParseTIDsAndPIDs += 1

                if (sExportBackupFileItemKey1.count < 1)
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cExportParseTIDsAndPIDs)) 'sExportBackupFileItemKey1' is an 'empty' string - Warning!")

                    continue

                }

                cExportTotalBackupFileItems += 1

                self.xcgLogMsg("\(sCurrMethodDisp) Of #(\(cExportTotalTIDsAndPIDs)) TIDs.PIDs Keys - For Key [\(sExportBackupFileItemKey1)] - Displaying 'parsePFBackupFileItem' item #(\(cExportParseTIDsAndPIDs).\(cExportTotalBackupFileItems)):")

                parsePFBackupFileItem.displayParsePFBackupFileItemToLog()

            }

            self.xcgLogMsg("\(sCurrMethodDisp) <Export Counts> A TOTAL of #(\(cExportTotalTIDsAndPIDs)) TIDs.PIDs have a TOTAL of #(\(cExportTotalBackupFileItems)) backup visits...")

        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Unable to display the dictionary of 'dictExportLastBackupFileItems' item(s) - item(s) count is less than 1 - Warning!")

        }
        
        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return

    } // End of func displayDictExportLastBackupFileItems().
    
    public func displayListPFCscDataItems()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Display the list 'self.listPFCscDataItems'...

        if (self.listPFCscDataItems.count > 0)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) Displaying the list of 'parsePFCscDataItem' item(s)...")

            var cDictPFCscDataItems:Int = 0

            for parsePFCscDataItem in self.listPFCscDataItems
            {

                cDictPFCscDataItems += 1

                parsePFCscDataItem.displayParsePFCscDataItemToLog(cDisplayItem:cDictPFCscDataItems)

            }
        
        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Unable to display the list of 'listPFCscDataItems' item(s) - item(s) count is less than 1 - Warning!")

        }
        
        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return

    } // End of func displayListPFCscDataItems().
    
    public func displayDictTherapistTidXfef()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Display the dictionary 'self.dictTherapistTidXref'...

        if (self.dictTherapistTidXref.count > 0)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) Displaying the dictionary of 'dictTherapistTidXref' item(s)...")

            var cTherapistTidXrefItems:Int = 0

            for (sPFTherapistXrefKey, sPFTherapistXrefItem) in self.dictTherapistTidXref
            {

                cTherapistTidXrefItems += 1

                self.xcgLogMsg("\(sCurrMethodDisp) #(\(cTherapistTidXrefItems)): 'sPFTherapistXrefKey' is [\(sPFTherapistXrefKey)] - 'sPFTherapistXrefItem' is [\(sPFTherapistXrefItem)]...")

            }
        
        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Unable to display the dictionary of 'dictTherapistTidXref' item(s) - item(s) count is less than 1 - Warning!")

        }
        
        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return

    } // End of func displayDictTherapistTidXfef().
    
    public func displayDictPatientPidXfef()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Display the dictionary 'self.dictPatientPidXref'...

        if (self.dictPatientPidXref.count > 0)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) Displaying the dictionary of 'dictPatientPidXref' item(s)...")

            var cPatientPidXrefItems:Int = 0

            for (sPFPatientXrefKey, sPFPatientXrefItem) in self.dictPatientPidXref
            {

                cPatientPidXrefItems += 1

                self.xcgLogMsg("\(sCurrMethodDisp) #(\(cPatientPidXrefItems)): 'sPFPatientXrefKey' is [\(sPFPatientXrefKey)] - 'sPFPatientXrefItem' is [\(sPFPatientXrefItem)]...")

            }
        
        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Unable to display the dictionary of 'dictPatientPidXref' item(s) - item(s) count is less than 1 - Warning!")

        }
        
        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return

    } // End of func displayDictPatientPidXfef().
    
}   // End of public class JmAppParseCoreBkgdDataRepo.

