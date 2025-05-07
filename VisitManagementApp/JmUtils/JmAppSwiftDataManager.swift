//
//  JmAppSwiftDataManager.swift
//  VisitManagementApp
//
//  Created by Daryl Cox on 12/11/2024.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftData

public class JmAppSwiftDataManager: NSObject, ObservableObject
{
    
    struct ClassInfo
    {
        
        static let sClsId        = "JmAppSwiftDataManager"
        static let sClsVers      = "v1.0709"
        static let sClsDisp      = sClsId+".("+sClsVers+"): "
        static let sClsCopyRight = "Copyright (C) JustMacApps 2024-2025. All Rights Reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }

    // Class 'singleton' instance:

    struct ClassSingleton
    {

        static var appSwiftDataManager:JmAppSwiftDataManager           = JmAppSwiftDataManager()

    }

    // Various App field(s):

           private var bInternalTest:Bool                              = true

           private var cJmAppSwiftDataManagerMethodCalls:Int           = 0

    // Various App SwiftData field(s):

           public   var schema:Schema?                                 = nil
           public   var modelConfiguration:ModelConfiguration?         = nil
           public   var modelContainer:ModelContainer?                 = nil
           public   var modelContext:ModelContext?                     = nil
    //     public   var undoManager:UndoManager?                       = nil

    @Published      var alarmSwiftDataItems:[AlarmSwiftDataItem]       = []
    {
        didSet
        {
            objectWillChange.send()
        }
    }
    @Published      var bAreAlarmSwiftDataItemsAvailable:Bool          = false
    {
        didSet
        {
            objectWillChange.send()
        }
    }
    @Published      var sAlarmsEnabledMessage:String                   = "-N/A-"
    {
        didSet
        {
            objectWillChange.send()
        }
    }
    @Published      var sAlarmNextMessage:String                       = ""
    {
        didSet
        {
            objectWillChange.send()
        }
    }

    @Published      var pfAdminsSwiftDataItems:[PFAdminsSwiftDataItem] = [PFAdminsSwiftDataItem]()
    {
        didSet
        {
            objectWillChange.send()
        }
    }
    @Published      var bArePFAdminsSwiftDataItemsAvailable:Bool       = false
    {
        didSet
        {
            objectWillChange.send()
        }
    }
    
    // App 'delegate' Visitor:

                    var jmAppDelegateVisitor:JmAppDelegateVisitor?     = nil
                                                                         // 'jmAppDelegateVisitor' MUST remain declared this way
                                                                         // as having it reference the 'shared' instance of 
                                                                         // JmAppDelegateVisitor causes a circular reference
                                                                         // between the 'init()' methods of the 2 classes...

    // App <global> Message(s) 'stack' cached before XCGLogger is available:

                    var listPreXCGLoggerMessages:[String]              = Array()

    private override init()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        super.init()
      
        self.cJmAppSwiftDataManagerMethodCalls += 1
      
        self.xcgLogMsg("\(sCurrMethodDisp)#(\(self.cJmAppSwiftDataManagerMethodCalls))' Invoked...")
      
        // Exit:
      
        self.xcgLogMsg("\(sCurrMethodDisp)#(\(self.cJmAppSwiftDataManagerMethodCalls))' Exiting...")

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

    @objc public func toString() -> String
    {

        var asToString:[String] = Array()

        asToString.append("[")
        asToString.append("[")
        asToString.append("sClsId': [\(ClassInfo.sClsId)],")
        asToString.append("sClsVers': [\(ClassInfo.sClsVers)],")
        asToString.append("sClsDisp': [\(ClassInfo.sClsDisp)],")
        asToString.append("sClsCopyRight': [\(ClassInfo.sClsCopyRight)],")
        asToString.append("bClsTrace': [\(ClassInfo.bClsTrace)],")
        asToString.append("bClsFileLog': [\(ClassInfo.bClsFileLog)]")
        asToString.append("],")
        asToString.append("[")
        asToString.append("bInternalTest': [\(self.bInternalTest)],")
        asToString.append("cJmAppSwiftDataManagerMethodCalls': (\(self.cJmAppSwiftDataManagerMethodCalls))")
        asToString.append("],")
        asToString.append("[")
        asToString.append("SwiftData 'schema': [\(String(describing: self.schema))],")
        asToString.append("SwiftData 'modelConfiguration': [\(String(describing: self.modelConfiguration))],")
        asToString.append("SwiftData 'modelContainer': [\(String(describing: self.modelContainer))],")
        asToString.append("SwiftData 'modelContext': [\(String(describing: self.modelContext))]")
    //  asToString.append("SwiftData 'undoManager': [\(String(describing: self.undoManager))],")
        asToString.append("],")
        asToString.append("[")
        asToString.append("SwiftData 'alarmSwiftDataItems': [\(String(describing: self.alarmSwiftDataItems))],")
        asToString.append("SwiftData 'bAreAlarmSwiftDataItemsAvailable': [\(String(describing: self.bAreAlarmSwiftDataItemsAvailable))],")
        asToString.append("SwiftData 'sAlarmsEnabledMessage': [\(String(describing: self.sAlarmsEnabledMessage))],")
        asToString.append("SwiftData 'sAlarmNextMessage': [\(String(describing: self.sAlarmNextMessage))],")
        asToString.append("],")
        asToString.append("[")
        asToString.append("SwiftData 'pfAdminsSwiftDataItems': [\(String(describing: self.pfAdminsSwiftDataItems))[,")
        asToString.append("SwiftData 'bArePFAdminsSwiftDataItemsAvailable': [\(String(describing: self.bArePFAdminsSwiftDataItemsAvailable)))]")
        asToString.append("],")
        asToString.append("]")

        let sContents:String = "{"+(asToString.joined(separator: ""))+"}"

        return sContents

    }   // End of @objc public func toString().

    public func setJmAppDelegateVisitorInstance(jmAppDelegateVisitor:JmAppDelegateVisitor)
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.cJmAppSwiftDataManagerMethodCalls += 1
    
        self.xcgLogMsg("\(sCurrMethodDisp)#(\(self.cJmAppSwiftDataManagerMethodCalls))' Invoked - supplied parameter 'jmAppDelegateVisitor' is [\(jmAppDelegateVisitor)]...")

        // Set the AppDelegateVisitor instance...

        self.jmAppDelegateVisitor = jmAppDelegateVisitor

        // Spool <any> pre-XDGLogger (via the AppDelegateVisitor) message(s) into the Log...

        if (self.listPreXCGLoggerMessages.count > 0)
        {

            self.xcgLogMsg("")
            self.xcgLogMsg("\(sCurrMethodDisp) <<< === Spooling the JmAppDelegateVisitor.XCGLogger 'pre' Message(s) === >>>")

            let sPreXCGLoggerMessages:String = self.listPreXCGLoggerMessages.joined(separator: "\n")

            self.xcgLogMsg(sPreXCGLoggerMessages)

            self.xcgLogMsg("\(sCurrMethodDisp) <<< === Spooled  the JmAppDelegateVisitor.XCGLogger 'pre' Message(s) === >>>")
            self.xcgLogMsg("")

        }

        // Finish any 'initialization' work:

        self.xcgLogMsg("\(sCurrMethodDisp)#(\(self.cJmAppSwiftDataManagerMethodCalls))' SwiftDataManager Invoking 'self.runPostInitializationTasks()'...")
    
        self.runPostInitializationTasks()

        self.xcgLogMsg("\(sCurrMethodDisp)#(\(self.cJmAppSwiftDataManagerMethodCalls))' SwiftDataManager Invoked  'self.runPostInitializationTasks()'...")
    
        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp)#(\(self.cJmAppSwiftDataManagerMethodCalls))' Exiting - 'self.jmAppDelegateVisitor' is [\(String(describing: self.jmAppDelegateVisitor))]...")
    
        return

    } // End of public func setJmAppDelegateVisitorInstance().

    private func runPostInitializationTasks()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'self' is [\(self)]...")

        // Initialize the SwiftData 'model' Container (on the 'model' Configuration)...
        
        do
        {

        // --------------------------------------------------------------------------------------------------
        //  let schema             = Schema([PFAdminsSwiftDataItem.self])
        //  let modelConfiguration = ModelConfiguration(schema:schema, isStoredInMemoryOnly:false)
        //                return try ModelContainer(for:schema, configurations:[modelConfiguration])
        // --------------------------------------------------------------------------------------------------

            self.schema = Schema([PFAdminsSwiftDataItem.self])

            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager Schema has been constructed for PFAdminsSwiftDataItem (class)...")

            self.modelConfiguration = ModelConfiguration(schema:self.schema!, isStoredInMemoryOnly:false, allowsSave:true)
        //  self.modelConfiguration = ModelConfiguration(schema:self.schema!, isStoredInMemoryOnly:false)

            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager ModelConfiguration has been constructed on the Schema...")
            
        //  self.modelContainer = try ModelContainer(configurations:modelConfiguration!)
            self.modelContainer = try ModelContainer(for:self.schema!, configurations:modelConfiguration!)
            
            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager ModelContainer has been constructed on the ModelConfiguration...")

        //  self.modelContext   = self.modelContainer!.mainContext
            self.modelContext   = ModelContext(self.modelContainer!)

            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager ModelContext has been obtained (from the ModelContainer)...")

            if (self.modelContext != nil) 
            {
                
                self.modelContext?.autosaveEnabled = false
                
                self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager ModelContext 'autosaveEnabled' has been set to 'false'...")

                self.modelContext!.undoManager = UndoManager()

                self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager UndoManager has been constructed on the ModelContext...")

                self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager Invoking 'self.fetchAppSwiftData()'...")

                self.fetchAppSwiftData(bShowDetailAfterFetch:true)

                self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager Invoked  'self.fetchAppSwiftData()'...")
            //  self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager Invoking 'self.createAppSwiftDataDefaultsIfNone()'...")
            //
            //  self.createAppSwiftDataDefaultsIfNone()
            //
            //  self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager Invoked  'self.createAppSwiftDataDefaultsIfNone()'...")

                // Sort the SwiftData item(s) <if any>...

            //  self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager Invoking 'self.sortAppSwiftDataAlarmItems()'...")
            //
            //  let _ = self.sortAppSwiftDataAlarmItems()
            //
            //  self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager Invoked  'self.sortAppSwiftDataAlarmItems()'...")
          
            }

        }
        catch
        {
            
            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager ModelContainer has failed construction - Details: \(error) - Error!")

            self.bArePFAdminsSwiftDataItemsAvailable = false
            self.modelContext                     = nil
            self.modelContainer                   = nil

            self.xcgLogMsg("\(ClassInfo.sClsDisp) SwiftDataManagerManager 'self.pfAdminsSwiftDataItems' has #(\(self.pfAdminsSwiftDataItems.count)) 'alarm' item(s)...")
            self.xcgLogMsg("\(ClassInfo.sClsDisp) SwiftDataManagerManager 'self.bArePFAdminsSwiftDataItemsAvailable' is [\(self.bArePFAdminsSwiftDataItemsAvailable)]...")
            
        }

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of private func runPostInitializationTasks().

    // Method(s) to fetch, add, delete, detail, and save SwiftData item(s):

    public func addAppSwiftDataItem(pfAdminsSwiftDataItem:PFAdminsSwiftDataItem, bShowDetailAfterAdd:Bool = false)
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
  
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - SwiftDataManager <Add> - 'pfAdminsSwiftDataItem' is [\(pfAdminsSwiftDataItem)] - 'bShowDetailAfterAdd' is [\(bShowDetailAfterAdd)]...")
  
        // Add the supplied SwiftData item to the list 'pfAdminsSwiftDataItems' and the ModelContext...
  
        if (self.modelContext != nil) 
        {

            self.pfAdminsSwiftDataItems.append(pfAdminsSwiftDataItem)

            self.modelContext!.insert(pfAdminsSwiftDataItem)
      
            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <Add> - Added a supplied 'pfAdminsSwiftDataItem' of [\(String(describing: pfAdminsSwiftDataItem.toString()))] to the SwiftData 'model' Context...")
            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <Add> - Invoking 'self.saveAppSwiftData()'...")

            self.saveAppSwiftData()

            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <Add> - Invoked  'self.saveAppSwiftData()'...")
            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <Add> - Invoking 'self.fetchAppSwiftData()'...")

            self.fetchAppSwiftData(bShowDetailAfterFetch:bShowDetailAfterAdd)

            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <Add> - Invoked  'self.fetchAppSwiftData()'...")
            
            DispatchQueue.main.async
            {

                if (self.pfAdminsSwiftDataItems.count > 0)
                {

                    self.bArePFAdminsSwiftDataItemsAvailable = true

                }
                else
                {

                    self.bArePFAdminsSwiftDataItemsAvailable = false

                }

            }
            
            self.xcgLogMsg("\(ClassInfo.sClsDisp) SwiftDataManager <Add> - 'self.pfAdminsSwiftDataItems' has (\(self.pfAdminsSwiftDataItems.count)) 'admin' item(s)...")
            self.xcgLogMsg("\(ClassInfo.sClsDisp) SwiftDataManager <Add> - 'self.bArePFAdminsSwiftDataItemsAvailable' is [\(self.bArePFAdminsSwiftDataItemsAvailable)]...")

        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <Add> - has failed operation - 'self.modelContext' is nil - Error!")

        }
        
        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - SwiftDataManager <Add> - 'pfAdminsSwiftDataItem' is [\(pfAdminsSwiftDataItem)] - 'bShowDetailAfterAdd' is [\(bShowDetailAfterAdd)]...")
  
        return
  
    }   // End of public func addAppSwiftDataItem(pfAdminsSwiftDataItem:PFAdminsSwiftDataItem, bShowDetailAfterAdd:Bool).

    public func fetchAppSwiftData(bShowDetailAfterFetch:Bool = false)
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - SwiftDataManager <Fetch> - 'bShowDetailAfterFetch' is [\(bShowDetailAfterFetch)]...")

        // Fetch (or re-fetch) the SwiftData 'model' Container's ModelContext...
        
        DispatchQueue.main.async
        {

            do
            {

                if (self.modelContext != nil)
                {

                //  let pfAdminsSwiftDataItemsPredicate  = #Predicate<PFAdminsSwiftDataItem>()
                //  let pfAdminsSwiftDataItemsDescriptor = FetchDescriptor<PFAdminsSwiftDataItem>(predicate:PFAdminsSwiftDataItemsPredicate)
                    let pfAdminsSwiftDataItemsDescriptor = FetchDescriptor<PFAdminsSwiftDataItem>()
                    self.pfAdminsSwiftDataItems          = try self.modelContext!.fetch(pfAdminsSwiftDataItemsDescriptor)

                    if (self.pfAdminsSwiftDataItems.count > 0)
                    {

                        if (bShowDetailAfterFetch == true)
                        {
                        
                            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <Fetch> - Invoking 'self.detailAppSwiftDataToLog()'...")
                            
                            self.detailAppSwiftDataToLog()
                        
                            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <Fetch> - Invoked  'self.detailAppSwiftDataToLog()'...")
                            
                        }
                        
                        self.bArePFAdminsSwiftDataItemsAvailable = true

                    }
                    else
                    {

                        self.bArePFAdminsSwiftDataItemsAvailable = false

                    }

                    self.xcgLogMsg("\(ClassInfo.sClsDisp) #1 SwiftDataManager <Fetch> - 'self.pfAdminsSwiftDataItems' has (\(self.pfAdminsSwiftDataItems.count)) 'admin' item(s)...")
                    self.xcgLogMsg("\(ClassInfo.sClsDisp) #1 SwiftDataManager <Fetch> - 'self.bArePFAdminsSwiftDataItemsAvailable' is [\(self.bArePFAdminsSwiftDataItemsAvailable)]...")

                }
                else
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <Fetch> - has failed operation - 'self.modelContext' is nil - Error!")

                }

            }
            catch
            {
                
                self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <Fetch> - operation has failed - Details: \(error) - Error!")

                self.bArePFAdminsSwiftDataItemsAvailable = false
                self.modelContext                        = nil
                self.modelContainer                      = nil

                self.xcgLogMsg("\(ClassInfo.sClsDisp) #2 SwiftDataManager <Fetch> - 'self.pfAdminsSwiftDataItems' has #(\(self.pfAdminsSwiftDataItems.count)) 'admin' item(s)...")
                self.xcgLogMsg("\(ClassInfo.sClsDisp) #2 SwiftDataManager <Fetch> - 'self.bArePFAdminsSwiftDataItemsAvailable' is [\(self.bArePFAdminsSwiftDataItemsAvailable)]...")
                
            }

        }
        
        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - SwiftDataManager <Fetch> - 'bShowDetailAfterFetch' is [\(bShowDetailAfterFetch)]...")

        return

    }   // End of public func fetchAppSwiftData(bShowDetailAfterFetch:Bool).

    public func deleteAppSwiftDataItems(offsets:IndexSet, bShowDetailAfterDeletes:Bool = false)
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
  
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - SwiftDataManager <Deletes> - 'offsets' is [\(offsets)] - 'bShowDetailAfterDeletes' is [\(bShowDetailAfterDeletes)]...")
  
        // Delete the supplied SwiftData item(s) from the ModelContext...
  
        if (self.modelContext != nil) 
        {

            for index in offsets
            {
            
                self.deleteAppSwiftDataItem(pfAdminsSwiftDataItem:self.pfAdminsSwiftDataItems[index], bShowDetailAfterDelete:false)
            
            }
            
            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <Deletes> - SwiftData 'item(s)' has been 'deleted' from the SwiftDataManager ModelContext...")

        //  We bypass the 'save' here as each individual 'delete' does a 'save'...
        //
        //  self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager Invoking 'self.saveAppSwiftData()'...")
        //
        //  self.saveAppSwiftData()
        //
        //  self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager Invoked  'self.saveAppSwiftData()'...")

            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <Deletes> - Invoking 'self.fetchAppSwiftData()'...")

            self.fetchAppSwiftData(bShowDetailAfterFetch:bShowDetailAfterDeletes)

            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <Deletes> - Invoked  'self.fetchAppSwiftData()'...")

            if (self.pfAdminsSwiftDataItems.count > 0)
            {

                self.bArePFAdminsSwiftDataItemsAvailable = true

            }
            else
            {

                self.bArePFAdminsSwiftDataItemsAvailable = false

            }

            self.xcgLogMsg("\(ClassInfo.sClsDisp) SwiftDataManager <Deletes> - 'self.pfAdminsSwiftDataItems' has (\(self.pfAdminsSwiftDataItems.count)) 'admin' item(s)...")
            self.xcgLogMsg("\(ClassInfo.sClsDisp) SwiftDataManager <Deletes> - 'self.bArePFAdminsSwiftDataItemsAvailable' is [\(self.bArePFAdminsSwiftDataItemsAvailable)]...")

        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <Deletes> - operation has failed - 'self.modelContext' is nil - Error!")

        }
        
        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - SwiftDataManager <Deletes> - 'offsets' is [\(offsets)] - 'bShowDetailAfterDeletes' is [\(bShowDetailAfterDeletes)]...")
  
        return
  
    }   // End of public func deleteAppSwiftDataItems(offsets:IndexSet, bShowDetailAfterDeletes:Bool).

    public func deleteAppSwiftDataItem(pfAdminsSwiftDataItem:PFAdminsSwiftDataItem, bShowDetailAfterDelete:Bool = false)
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
  
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - SwiftDataManager <Delete> - 'pfAdminsSwiftDataItem' is [\(pfAdminsSwiftDataItem)] - 'bShowDetailAfterDelete' is [\(bShowDetailAfterDelete)]...")
  
        // Delete the supplied SwiftData item from the ModelContext...
  
        if (self.modelContext != nil) 
        {

            self.modelContext!.delete(pfAdminsSwiftDataItem)
      
            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <Delete> - Deleted a supplied 'pfAdminsSwiftDataItem' of [\(String(describing: pfAdminsSwiftDataItem.toString()))] to the SwiftData 'model' Context...")
            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <Delete> - Invoking 'self.saveAppSwiftData()'...")

            self.saveAppSwiftData()

            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <Delete> - Invoked  'self.saveAppSwiftData()'...")
            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <Delete> - Invoking 'self.fetchAppSwiftData()'...")

            self.fetchAppSwiftData(bShowDetailAfterFetch:bShowDetailAfterDelete)

            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <Delete> - Invoked  'self.fetchAppSwiftData()'...")

            if (self.pfAdminsSwiftDataItems.count > 0)
            {

                self.bArePFAdminsSwiftDataItemsAvailable = true

            }
            else
            {

                self.bArePFAdminsSwiftDataItemsAvailable = false

            }

            self.xcgLogMsg("\(ClassInfo.sClsDisp) SwiftDataManager <Delete> - 'self.pfAdminsSwiftDataItems' has (\(self.pfAdminsSwiftDataItems.count)) 'admin' item(s)...")
            self.xcgLogMsg("\(ClassInfo.sClsDisp) SwiftDataManager <Delete> - 'self.bArePFAdminsSwiftDataItemsAvailable' is [\(self.bArePFAdminsSwiftDataItemsAvailable)]...")

        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <Delete> - has failed operation - 'self.modelContext' is nil - Error!")

        }
        
        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - SwiftDataManager <Delete> - 'pfAdminsSwiftDataItem' is [\(pfAdminsSwiftDataItem)] - 'bShowDetailAfterDelete' is [\(bShowDetailAfterDelete)]...")
  
        return
  
    }   // End of public func deleteAppSwiftDataItem(pfAdminsSwiftDataItem:PFAdminsSwiftDataItem, bShowDetailAfterDelete:Bool).

    public func detailAppSwiftDataToLog()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - SwiftDataManager <Detail>...")

        // Detail the SwiftData 'model' Container's ModelContext to the Log...
        
        if (self.modelContext != nil) 
        {

            if (self.pfAdminsSwiftDataItems.count > 0)
            {
                
                var idPFAdminsSwiftDataItem:Int = 0
                
                for currentSwiftDataItem:PFAdminsSwiftDataItem in self.pfAdminsSwiftDataItems
                {
                    
                    idPFAdminsSwiftDataItem += 1
                    
                    if (idPFAdminsSwiftDataItem == 1)
                    {
                        
                        currentSwiftDataItem.displayPFAdminsSwiftDataItemWithLocalStore(bShowLocalStore:true)
                        
                    }
                    else
                    {
                        
                        currentSwiftDataItem.displayPFAdminsSwiftDataItemWithLocalStore(bShowLocalStore:false)
                        
                    }
                    
                }
                
            }

            DispatchQueue.main.async
            {

                if (self.pfAdminsSwiftDataItems.count > 0)
                {
                    
                    self.bArePFAdminsSwiftDataItemsAvailable = true

                }
                else
                {

                    self.bArePFAdminsSwiftDataItemsAvailable = false

                }

            }

            self.xcgLogMsg("\(ClassInfo.sClsDisp) SwiftDataManager <Detail> - 'self.pfAdminsSwiftDataItems' has (\(self.pfAdminsSwiftDataItems.count)) 'admin' item(s)...")
            self.xcgLogMsg("\(ClassInfo.sClsDisp) SwiftDataManager <Detail> - 'self.bArePFAdminsSwiftDataItemsAvailable' is [\(self.bArePFAdminsSwiftDataItemsAvailable)]...")

        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <Detail> - operation has failed operation - 'self.modelContext' is nil - Error!")

        }

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - SwiftDataManager <Detail>...")

        return

    }   // End of public func detailAppSwiftDataToLog().

    private func createAppSwiftDataDefaultsIfNone()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - SwiftDataManager <CreateDefaults>...")

        // NOTE: If necessary, the block below generates a 'default' SwiftData item (if there are NONE)...
        
        if (self.modelContext != nil) 
        {

        //  for i in 0..<3
            if (self.pfAdminsSwiftDataItems.count < 1)
            {
      
                let newPFAdminsSwiftDataItem = PFAdminsSwiftDataItem(idPFAdminsObject:0, timestamp:Date.now, sCreatedBy: "\(sCurrMethodDisp)")
      
                self.modelContext!.insert(newPFAdminsSwiftDataItem)
      
                self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <CreateDefaults> - There were NO SwiftData 'item(s)' - Added a default 'newPFAdminsSwiftDataItem' of [\(String(describing: newPFAdminsSwiftDataItem.toString()))] to the SwiftData 'model' Context...")
                self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <CreateDefaults> - Invoking 'self.saveAppSwiftData()'...")

                self.saveAppSwiftData()

                self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <CreateDefaults> - Invoked  'self.saveAppSwiftData()'...")
                self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <CreateDefaults> - Invoking 'self.detailAppSwiftDataToLog()'...")

                self.detailAppSwiftDataToLog()

                self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <CreateDefaults> - Invoked  'self.detailAppSwiftDataToLog()'...")

            }
      
        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <CreateDefaults> - operation has failed - 'self.modelContext' is nil - Error!")

        }

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - SwiftDataManager <CreateDefaults>...")

        return

    }   // End of private func createAppSwiftDataDefaultsIfNone().

    public func undoAppSwiftData()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - SwiftDataManager <Undo>...")

        // Undo the SwiftData item(s) (if there are any)...
        
        if (self.modelContext              != nil &&
            self.modelContext!.undoManager != nil)
        {

            if (self.alarmSwiftDataItems.count > 0)
            {
      
                self.modelContext!.undoManager!.undo()

                self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <Undo> - SwiftData ModelContext has been 'undone' - 'self.alarmSwiftDataItems' had #(\(self.alarmSwiftDataItems.count)) item(s)...")

                self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <Undo> - Invoking 'self.saveAppSwiftData()'...")

                self.saveAppSwiftData()

                self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <Undo> - Invoked  'self.saveAppSwiftData()'...")

            }

            if (self.alarmSwiftDataItems.count < 1)
            {
      
                self.bAreAlarmSwiftDataItemsAvailable = false

            }
            else
            {

                self.bAreAlarmSwiftDataItemsAvailable = true

            }

            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <Undo> - 'self.alarmSwiftDataItems' has #(\(self.alarmSwiftDataItems.count)) 'alarm' item(s)...")
            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <Undo> - 'self.bAreAlarmSwiftDataItemsAvailable' is [\(self.bAreAlarmSwiftDataItemsAvailable)]...")
      
        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <Undo> - operation has failed - 'self.modelContext' is nil - Error!")

        }

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - SwiftDataManager <Undo>...")

        return

    }   // End of public func undoAppSwiftData().

    public func beginAppSwiftDataUndoGrouping()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - SwiftDataManager <BeginUndoGroup>...")

        // 'begin' the 'undo' grouping...
        
        if (self.modelContext              != nil &&
            self.modelContext!.undoManager != nil)
        {

            self.modelContext!.undoManager!.beginUndoGrouping()

            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <BeginUndoGroup> - SwiftData ModelContext has 'begun' an 'undo' grouping...")

            if (self.alarmSwiftDataItems.count < 1)
            {
      
                self.bAreAlarmSwiftDataItemsAvailable = false

            }
            else
            {

                self.bAreAlarmSwiftDataItemsAvailable = true

            }

            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <BeginUndoGroup> - 'self.alarmSwiftDataItems' has #(\(self.alarmSwiftDataItems.count)) 'alarm' item(s)...")
            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <BeginUndoGroup> - 'self.bAreAlarmSwiftDataItemsAvailable' is [\(self.bAreAlarmSwiftDataItemsAvailable)]...")
      
        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <BeginUndoGroup> - operation has failed - 'self.modelContext' and/or 'self.modelContext!.undoManager' is nil - Error!")

        }

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - SwiftDataManager <BeginUndoGroup>...")

        return

    }   // End of public func beginAppSwiftDataUndoGrouping().

    public func endAppSwiftDataUndoGrouping()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - SwiftDataManager <EndUndoGroup>...")

        // 'end' the 'undo' grouping...
        
        if (self.modelContext              != nil &&
            self.modelContext!.undoManager != nil)
        {

            self.modelContext!.undoManager!.endUndoGrouping()

            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <EndUndoGroup> - SwiftData ModelContext has 'ended' an 'undo' grouping...")

            if (self.alarmSwiftDataItems.count < 1)
            {
      
                self.bAreAlarmSwiftDataItemsAvailable = false

            }
            else
            {

                self.bAreAlarmSwiftDataItemsAvailable = true

            }

            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <EndUndoGroup> - 'self.alarmSwiftDataItems' has #(\(self.alarmSwiftDataItems.count)) 'alarm' item(s)...")
            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <EndUndoGroup> - 'self.bAreAlarmSwiftDataItemsAvailable' is [\(self.bAreAlarmSwiftDataItemsAvailable)]...")
      
        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <EndUndoGroup> - operation has failed - 'self.modelContext' and/or 'self.modelContext!.undoManager' is nil - Error!")

        }

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - SwiftDataManager <EndUndoGroup>...")

        return

    }   // End of public func endAppSwiftDataUndoGrouping().

    public func undoAppSwiftDataNestedGroup()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - SwiftDataManager <UndoNestedGrouping>...")

        // 'undo' the 'nested' group...
        
        if (self.modelContext              != nil &&
            self.modelContext!.undoManager != nil)
        {

            self.modelContext!.undoManager!.undoNestedGroup()

            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <UndoNestedGrouping> - SwiftData ModelContext has 'undone' a 'nested' group...")

            if (self.alarmSwiftDataItems.count < 1)
            {
      
                self.bAreAlarmSwiftDataItemsAvailable = false

            }
            else
            {

                self.bAreAlarmSwiftDataItemsAvailable = true

            }

            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <UndoNestedGrouping> - 'self.alarmSwiftDataItems' has #(\(self.alarmSwiftDataItems.count)) 'alarm' item(s)...")
            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <UndoNestedGrouping> - 'self.bAreAlarmSwiftDataItemsAvailable' is [\(self.bAreAlarmSwiftDataItemsAvailable)]...")
      
        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <UndoNestedGrouping> - operation has failed - 'self.modelContext' and/or 'self.modelContext!.undoManager' is nil - Error!")

        }

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - SwiftDataManager <UndoNestedGrouping>...")

        return

    }   // End of public func undoAppSwiftDataNestedGroup().

    public func saveAppSwiftData()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - SwiftDataManager <Save>...")

        // Save the SwiftData item(s) (if there are any)...
        
        if (self.modelContext != nil) 
        {

            if (self.pfAdminsSwiftDataItems.count > 0)
            {
      
                do
                {

                    try self.modelContext!.save()

                    self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <Save> - operation has been completed - 'self.pfAdminsSwiftDataItems' had #(\(self.pfAdminsSwiftDataItems.count)) item(s)...")

                }
                catch
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <Save> - operation has failed - Details: \(error) - Error!")

                }

            }
            else
            {

                self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <Save> - operation has failed - 'self.pfAdminsSwiftDataItems.count' of (\(self.pfAdminsSwiftDataItems.count)) is less than 1 - nothing to save - Warning!")

            }
            
            DispatchQueue.main.async
            {

                if (self.pfAdminsSwiftDataItems.count < 1)
                {
          
                    self.bArePFAdminsSwiftDataItemsAvailable = false

                }
                else
                {

                    self.bArePFAdminsSwiftDataItemsAvailable = true

                }

            }
            
            self.xcgLogMsg("\(ClassInfo.sClsDisp) SwiftDataManager <Save> - 'self.pfAdminsSwiftDataItems' has #(\(self.pfAdminsSwiftDataItems.count)) 'alarm' item(s)...")
            self.xcgLogMsg("\(ClassInfo.sClsDisp) SwiftDataManager <Save> - 'self.bArePFAdminsSwiftDataItemsAvailable' is [\(self.bArePFAdminsSwiftDataItemsAvailable)]...")
      
        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager <Save> - operation has failed - 'self.modelContext' is nil - Error!")

        }

    //  // Sort the SwiftData item(s)...
    //
    //  self.xcgLogMsg("\(sCurrMethodDisp) SwiftData ModelContext <Save> Invoking 'self.sortAppSwiftDataAlarmItems()'...")
    //
    //  let _ = self.sortAppSwiftDataAlarmItems()
    //
    //  self.xcgLogMsg("\(sCurrMethodDisp) SwiftData ModelContext <Save> Invoked  'self.sortAppSwiftDataAlarmItems()'...")

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - SwiftDataManager <Save>...")

        return

    }   // End of public func saveAppSwiftData().

    public func signalAppSwiftDataItemUpdated(alarmSwiftDataItem:AlarmSwiftDataItem, bShowDetailAfterUpdate:Bool = false)
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
  
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'alarmSwiftDataItem' is [\(alarmSwiftDataItem)] - 'bShowDetailAfterUpdate' is [\(bShowDetailAfterUpdate)]...")

        // Sort the SwiftData item(s)...

        self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager (Signal 'Update') Invoking 'self.sortAppSwiftDataAlarmItems()'...")

        let _ = self.sortAppSwiftDataAlarmItems()

        self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager (Signal 'Update') Invoked  'self.sortAppSwiftDataAlarmItems()'...")
  
        // Tell the JmAppUserNotificationManager that this SwiftData item has been 'updated'...
  
        if (self.jmAppDelegateVisitor                               != nil &&
            self.jmAppDelegateVisitor!.jmAppUserNotificationManager != nil) 
        {

            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager (Signal 'Update') Invoking 'jmAppDelegateVisitor!.jmAppUserNotificationManager!' 'signalAppSwiftDataItemUpdated(alarmSwiftDataItem:)'...")

            self.jmAppDelegateVisitor!.jmAppUserNotificationManager!.signalAppSwiftDataItemUpdated(alarmSwiftDataItem:alarmSwiftDataItem)

            self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager (Signal 'Update') Invoked  'jmAppDelegateVisitor!.jmAppUserNotificationManager!' 'signalAppSwiftDataItemUpdated(alarmSwiftDataItem:)'...")

        }

        // Show SwiftData item(s) detail, if asked and we have any...
        
        if (self.alarmSwiftDataItems.count > 0)
        {

            if (bShowDetailAfterUpdate == true)
            {

                self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager Invoking 'self.detailAppSwiftDataToLog()'...")

                self.detailAppSwiftDataToLog()

                self.xcgLogMsg("\(sCurrMethodDisp) SwiftDataManager Invoked  'self.detailAppSwiftDataToLog()'...")

            }

            self.bAreAlarmSwiftDataItemsAvailable = true

        }
        else
        {

            self.bAreAlarmSwiftDataItemsAvailable = false

        }

        self.xcgLogMsg("\(sCurrMethodDisp) #1 SwiftDataManager 'self.alarmSwiftDataItems' has (\(self.alarmSwiftDataItems.count)) 'alarm' item(s)...")
        self.xcgLogMsg("\(sCurrMethodDisp) #1 SwiftDataManager 'self.bAreAlarmSwiftDataItemsAvailable' is [\(self.bAreAlarmSwiftDataItemsAvailable)]...")

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'alarmSwiftDataItem' is [\(alarmSwiftDataItem)] - 'bShowDetailAfterUpdate' is [\(bShowDetailAfterUpdate)]...")
  
        return
  
    }   // End of public func signalAppSwiftDataItemUpdated(alarmSwiftDataItem:AlarmSwiftDataItem, bShowDetailAfterUpdate:Bool).

    public func locateAppSwiftDataItemAlarmById(sAlarmSwiftDataItem:String)->AlarmSwiftDataItem?
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
  
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'sAlarmSwiftDataItem' is [\(sAlarmSwiftDataItem)]...")
  
        // Locate the SwiftData item by ID (if we have any)

        let idAlarmSwiftDataItem:UUID              = UUID(uuidString:sAlarmSwiftDataItem) ?? UUID()
        var alarmSwiftDataItem:AlarmSwiftDataItem? = nil
        
        if (self.alarmSwiftDataItems.count > 0)
        {

            for currentSwiftDataItem:AlarmSwiftDataItem in self.alarmSwiftDataItems
            {

                if (currentSwiftDataItem.id == idAlarmSwiftDataItem) 
                {

                    alarmSwiftDataItem = currentSwiftDataItem

                    break

                }

            }

            self.bAreAlarmSwiftDataItemsAvailable = true

        }
        else
        {

            self.bAreAlarmSwiftDataItemsAvailable = false

        }

        self.xcgLogMsg("\(sCurrMethodDisp) #1 SwiftDataManager 'self.alarmSwiftDataItems' has (\(self.alarmSwiftDataItems.count)) 'alarm' item(s)...")
        self.xcgLogMsg("\(sCurrMethodDisp) #1 SwiftDataManager 'self.bAreAlarmSwiftDataItemsAvailable' is [\(self.bAreAlarmSwiftDataItemsAvailable)]...")

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'idAlarmSwiftDataItem' is [\(idAlarmSwiftDataItem)] - 'alarmSwiftDataItem' is [\(String(describing: alarmSwiftDataItem))]...")
  
        return alarmSwiftDataItem
  
    }   // End of public func locateAppSwiftDataItemAlarmById(sAlarmSwiftDataItem:)->AlarmSwiftDataItem?.

    public func locateAppSwiftDataItemAlarmByMediaId(sAlarmSwiftDataItemMediaId:String)->AlarmSwiftDataItem?
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
  
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'sAlarmSwiftDataItemMediaId' is [\(sAlarmSwiftDataItemMediaId)]...")
  
        // Locate the SwiftData item by ID (if we have any)

        let idAlarmSwiftDataItemMedia:UUID         = UUID(uuidString:sAlarmSwiftDataItemMediaId) ?? UUID()
        var alarmSwiftDataItem:AlarmSwiftDataItem? = nil
        
        if (self.alarmSwiftDataItems.count > 0)
        {

            for currentSwiftDataItem:AlarmSwiftDataItem in self.alarmSwiftDataItems
            {

                if (currentSwiftDataItem.idMedia == idAlarmSwiftDataItemMedia) 
                {

                    alarmSwiftDataItem = currentSwiftDataItem

                    break

                }

            }

            self.bAreAlarmSwiftDataItemsAvailable = true

        }
        else
        {

            self.bAreAlarmSwiftDataItemsAvailable = false

        }

        self.xcgLogMsg("\(sCurrMethodDisp) #1 SwiftDataManager 'self.alarmSwiftDataItems' has (\(self.alarmSwiftDataItems.count)) 'alarm' item(s)...")
        self.xcgLogMsg("\(sCurrMethodDisp) #1 SwiftDataManager 'self.bAreAlarmSwiftDataItemsAvailable' is [\(self.bAreAlarmSwiftDataItemsAvailable)]...")

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'idAlarmSwiftDataItemMedia' is [\(idAlarmSwiftDataItemMedia)] - 'alarmSwiftDataItem' is [\(String(describing: alarmSwiftDataItem))]...")
  
        return alarmSwiftDataItem
  
    }   // End of public func locateAppSwiftDataItemAlarmByMediaId(sAlarmSwiftDataItemMediaId:)->AlarmSwiftDataItem?.

    public func sortAppSwiftDataAlarmItems()->Int
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
  
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
  
        // Sort the SwiftData item(s) returning the count of Alarm(s) 'enabled'...

        var cAppSwiftDataAlarmsEnabled:Int = 0
        
        if (self.alarmSwiftDataItems.count > 0)
        {
            
            if (self.alarmSwiftDataItems.count > 1)
            {
                
                self.xcgLogMsg("\(sCurrMethodDisp) Sorting #(\(self.alarmSwiftDataItems.count)) 'alarm' SwiftData Item(s) in the list...")
                
                self.alarmSwiftDataItems.sort
                { (alarmSwiftDataItem1, alarmSwiftDataItem2) in
                    
                    //  Compare for Sort: '<' sorts 'ascending' and '>' sorts 'descending'...
                    //  Sort by 'enabled' first and 'dateAlarmFires' second...
                    
                    var bIsItem1LessThanItem2:Bool = false
                    
                    if (alarmSwiftDataItem1.bIsAlarmEnabled == true &&
                        alarmSwiftDataItem2.bIsAlarmEnabled == true)
                    {
                        
                        bIsItem1LessThanItem2 = (alarmSwiftDataItem1.dateAlarmFires < alarmSwiftDataItem2.dateAlarmFires)
                        
                        self.xcgLogMsg("\(sCurrMethodDisp) Sort <op-comp> #(\(self.alarmSwiftDataItems.count)) 'alarm' SwiftData Item(s) in the list - returning 'bIsItem1LessThanItem2' of [\(bIsItem1LessThanItem2)] - Item 1 and Item 2 are BOTH 'enabled' - compared on dates...")
                        
                    }
                    else
                    {
                        
                        if (alarmSwiftDataItem1.bIsAlarmEnabled == true &&
                            alarmSwiftDataItem2.bIsAlarmEnabled == false)
                        {
                            
                            bIsItem1LessThanItem2 = true
                            
                            self.xcgLogMsg("\(sCurrMethodDisp) Sort <op-comp> #(\(self.alarmSwiftDataItems.count)) 'alarm' SwiftData Item(s) in the list - returning 'bIsItem1LessThanItem2' of [\(bIsItem1LessThanItem2)] - Item 1 is 'enabled' but Item 2 is NOT - compared on Item 1...")
                            
                        }
                        else
                        {
                            
                            if (alarmSwiftDataItem1.bIsAlarmEnabled == false &&
                                alarmSwiftDataItem2.bIsAlarmEnabled == true)
                            {
                                
                                bIsItem1LessThanItem2 = false
                                
                                self.xcgLogMsg("\(sCurrMethodDisp) Sort <op-comp> #(\(self.alarmSwiftDataItems.count)) 'alarm' SwiftData Item(s) in the list - returning 'bIsItem1LessThanItem2' of [\(bIsItem1LessThanItem2)] - Item 1 is NOT 'enabled' but Item 2 IS - compared on Item 2...")
                                
                            }
                            else
                            {
                                
                                bIsItem1LessThanItem2 = (alarmSwiftDataItem1.dateAlarmFires < alarmSwiftDataItem2.dateAlarmFires)
                                
                                self.xcgLogMsg("\(sCurrMethodDisp) Sort <op-comp> #(\(self.alarmSwiftDataItems.count)) 'alarm' SwiftData Item(s) in the list - returning 'bIsItem1LessThanItem2' of [\(bIsItem1LessThanItem2)] - Item 1 and Item 2 are BOTH NOT 'enabled' - compared on dates...")
                                
                            }
                            
                        }
                        
                    }
                    
                    self.xcgLogMsg("\(sCurrMethodDisp) Sort <op> #(\(self.alarmSwiftDataItems.count)) 'alarm' SwiftData Item(s) in the list - returning 'bIsItem1LessThanItem2' of [\(bIsItem1LessThanItem2)] - Item 1 'alarmSwiftDataItem1' is [\(alarmSwiftDataItem1.toString())] and Item 2 'alarmSwiftDataItem2' is [\(alarmSwiftDataItem2.toString())]...")
                    
                    return bIsItem1LessThanItem2
                    
                }
                
                self.xcgLogMsg("\(sCurrMethodDisp) Sorted  #(\(self.alarmSwiftDataItems.count)) 'alarm' SwiftData Item(s) in the list...")
                
            }
            
            for currentSwiftDataItem:AlarmSwiftDataItem in self.alarmSwiftDataItems
            {
                
                if (currentSwiftDataItem.bIsAlarmEnabled == true)
                {
                    
                    cAppSwiftDataAlarmsEnabled += 1
                    
                }
                
            }
            
        }
        
        DispatchQueue.main.async
        {

            if (self.alarmSwiftDataItems.count > 1)
            {
                
                self.bAreAlarmSwiftDataItemsAvailable = true

            }
            else
            {

                self.bAreAlarmSwiftDataItemsAvailable = false

            }

            self.xcgLogMsg("\(sCurrMethodDisp) #1 SwiftDataManager 'self.alarmSwiftDataItems' has (\(self.alarmSwiftDataItems.count)) 'alarm' item(s)...")
            self.xcgLogMsg("\(sCurrMethodDisp) #1 SwiftDataManager 'self.bAreAlarmSwiftDataItemsAvailable' is [\(self.bAreAlarmSwiftDataItemsAvailable)]...")

            // After the 'sort', update the Alarms/Enabled/NextDateTime message...

            self.sAlarmsEnabledMessage = "-N/A-"
            self.sAlarmNextMessage     = ""

            if (self.alarmSwiftDataItems.count > 0)
            {

                var sAlarmsTag:String = "Alarm"

                if (self.alarmSwiftDataItems.count > 1)
                {
                
                    sAlarmsTag = "Alarms"
                
                }

            //  self.sAlarmsEnabledMessage = "(\(self.alarmSwiftDataItems.count)) \(sAlarmsTag) (\(cAppSwiftDataAlarmsEnabled)) 'enabled'"
                self.sAlarmsEnabledMessage = "\(self.alarmSwiftDataItems.count) \(sAlarmsTag) - \(cAppSwiftDataAlarmsEnabled) Enabled"

                if (cAppSwiftDataAlarmsEnabled > 0)
                {

                //  self.sAlarmNextMessage = "Next at [\(self.alarmSwiftDataItems[0].getAlarmSwiftDataItemShortTitle())]"
                    self.sAlarmNextMessage = "Next -> \(self.alarmSwiftDataItems[0].getAlarmSwiftDataItemShortTitle())"

                }

                self.xcgLogMsg("\(sCurrMethodDisp) Intermediate #1 - 'self.alarmSwiftDataItems.count' is [\(self.alarmSwiftDataItems.count)] - 'cAppSwiftDataAlarmsEnabled' is (\(cAppSwiftDataAlarmsEnabled)) - 'self.sAlarmsEnabledMessage' is [\(self.sAlarmsEnabledMessage)] - 'self.sAlarmNextMessage' is [\(self.sAlarmNextMessage)]...")

            }
            else
            {

                self.sAlarmsEnabledMessage = "NO Alarms..."

                self.xcgLogMsg("\(sCurrMethodDisp) Intermediate #2 - 'self.alarmSwiftDataItems.count' is [\(self.alarmSwiftDataItems.count)] - 'cAppSwiftDataAlarmsEnabled' is (\(cAppSwiftDataAlarmsEnabled)) - 'self.sAlarmsEnabledMessage' is [\(self.sAlarmsEnabledMessage)] - 'self.sAlarmNextMessage' is [\(self.sAlarmNextMessage)]...")

            }

        }

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'cAppSwiftDataAlarmsEnabled' is (\(cAppSwiftDataAlarmsEnabled)) - 'self.sAlarmsEnabledMessage' is [\(self.sAlarmsEnabledMessage)] - 'self.sAlarmNextMessage' is [\(self.sAlarmNextMessage)]......")
  
        return cAppSwiftDataAlarmsEnabled
  
    }   // End of public func sortAppSwiftDataAlarmItems()->Int.

}   // End of class JmAppSwiftDataManager(NSObject).

