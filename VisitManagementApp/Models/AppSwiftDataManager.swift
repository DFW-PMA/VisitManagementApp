//
//  AppSwiftDataManager.swift
//  QRCaptureRefactorApp3
//
//  Created by Daryl Cox on 06/25/2025.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftData

public class AppSwiftDataManager:NSObject, ObservableObject, SwiftDataManager
{
    
    struct ClassInfo
    {
        
        static let sClsId        = "AppSwiftDataManager"
        static let sClsVers      = "v1.1101"
        static let sClsDisp      = sClsId+".("+sClsVers+"): "
        static let sClsCopyRight = "Copyright (C) JustMacApps 2024-2025. All Rights Reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }

    // Class 'singleton' instance:

            static  var appSwiftDataManager:AppSwiftDataManager        = AppSwiftDataManager()

    // Various App field(s):

           private  var bInternalTest:Bool                             = true

    // Various App SwiftData field(s):

           public   var schema:Schema?                                 = nil
           public   var modelConfiguration:ModelConfiguration?         = nil
           public   var modelContainer:ModelContainer?                 = nil
           public   var modelContext:ModelContext?                     = nil
    //     public   var undoManager:UndoManager?                       = nil

                    var appDataItemsRepo:AppDataItemsRepo              = AppDataItemsRepo.appDataItemsRepo
    
//  // App 'delegate' Visitor:
//
//                  var jmAppDelegateVisitor:JmAppDelegateVisitor?     = nil
//                                                                       // 'jmAppDelegateVisitor' MUST remain declared this way
//                                                                       // as having it reference the 'shared' instance of 
//                                                                       // JmAppDelegateVisitor causes a circular reference
//                                                                       // between the 'init()' methods of the 2 classes...
//
//  // App <global> Message(s) 'stack' cached before XCGLogger is available:
//
//                  var listPreXCGLoggerMessages:[String]              = Array()

    private override init()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        super.init()
      
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Finish any 'initialization' work:
        
        self.xcgLogMsg("\(sCurrMethodDisp) AppSwiftDataManager Invoking 'self.runPostInitializationTasks()'...")
        
        self.runPostInitializationTasks()
        
        self.xcgLogMsg("\(sCurrMethodDisp) AppSwiftDataManager Invoked  'self.runPostInitializationTasks()'...")
      
        // Exit:
      
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of private override init().
    
    private func xcgLogMsg(_ sMessage:String)
    {

        let dtFormatterDateStamp:DateFormatter = DateFormatter()

        dtFormatterDateStamp.locale     = Locale(identifier: "en_US")
        dtFormatterDateStamp.timeZone   = TimeZone.current
        dtFormatterDateStamp.dateFormat = "yyyy-MM-dd hh:mm:ss.SSS"

        let dateStampNow:Date = .now
        let sDateStamp:String = ("\(dtFormatterDateStamp.string(from:dateStampNow)) >> ")

        print("\(sDateStamp)\(sMessage)")

        // Exit:

        return

    }   // End of private func xcgLogMsg().

//  private func xcgLogMsg(_ sMessage:String)
//  {
//
//      if (self.jmAppDelegateVisitor != nil)
//      {
//
//          if (self.jmAppDelegateVisitor!.bAppDelegateVisitorLogFilespecIsUsable == true)
//          {
//
//              self.jmAppDelegateVisitor!.xcgLogMsg(sMessage)
//
//          }
//          else
//          {
//
//              print("\(sMessage)")
//
//              self.listPreXCGLoggerMessages.append(sMessage)
//
//          }
//
//      }
//      else
//      {
//
//          print("\(sMessage)")
//
//          self.listPreXCGLoggerMessages.append(sMessage)
//
//      }
//
//      // Exit:
//
//      return
//
//  }   // End of private func xcgLogMsg().

    public func toString()->String
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
        asToString.append("],")
        asToString.append("[")
        asToString.append("SwiftData 'schema': [\(String(describing: self.schema))],")
        asToString.append("SwiftData 'modelConfiguration': [\(String(describing: self.modelConfiguration))],")
        asToString.append("SwiftData 'modelContainer': [\(String(describing: self.modelContainer))],")
        asToString.append("SwiftData 'modelContext': [\(String(describing: self.modelContext))]")
    //  asToString.append("SwiftData 'undoManager': [\(String(describing: self.undoManager))],")
        asToString.append("],")
        asToString.append("[")
        asToString.append("SwiftData 'appDataItemsRepo': [\(String(describing: self.appDataItemsRepo))[,")
        asToString.append("],")
        asToString.append("]")

        let sContents:String = "{"+(asToString.joined(separator: ""))+"}"

        return sContents

    }   // End of public func toString().

//  public func setJmAppDelegateVisitorInstance(jmAppDelegateVisitor:JmAppDelegateVisitor)
//  {
//      
//      let sCurrMethod:String = #function
//      let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
//      
//      self.cAppSwiftDataManagerMethodCalls += 1
//  
//      self.xcgLogMsg("\(sCurrMethodDisp)#(\(self.cAppSwiftDataManagerMethodCalls))' Invoked - supplied parameter 'jmAppDelegateVisitor' is [\(jmAppDelegateVisitor)]...")
//
//      // Set the AppDelegateVisitor instance...
//
//      self.jmAppDelegateVisitor = jmAppDelegateVisitor
//
//      // Spool <any> pre-XDGLogger (via the AppDelegateVisitor) message(s) into the Log...
//
//      if (self.listPreXCGLoggerMessages.count > 0)
//      {
//
//          self.xcgLogMsg("")
//          self.xcgLogMsg("\(sCurrMethodDisp) <<< === Spooling the JmAppDelegateVisitor.XCGLogger 'pre' Message(s) === >>>")
//
//          let sPreXCGLoggerMessages:String = self.listPreXCGLoggerMessages.joined(separator: "\n")
//
//          self.xcgLogMsg(sPreXCGLoggerMessages)
//
//          self.xcgLogMsg("\(sCurrMethodDisp) <<< === Spooled  the JmAppDelegateVisitor.XCGLogger 'pre' Message(s) === >>>")
//          self.xcgLogMsg("")
//
//      }
//
//      // Finish any 'initialization' work:
//
//      self.xcgLogMsg("\(sCurrMethodDisp)#(\(self.cAppSwiftDataManagerMethodCalls))' SwiftDataManager Invoking 'self.runPostInitializationTasks()'...")
//  
//      self.runPostInitializationTasks()
//
//      self.xcgLogMsg("\(sCurrMethodDisp)#(\(self.cAppSwiftDataManagerMethodCalls))' SwiftDataManager Invoked  'self.runPostInitializationTasks()'...")
//  
//      // Exit:
//
//      self.xcgLogMsg("\(sCurrMethodDisp)#(\(self.cAppSwiftDataManagerMethodCalls))' Exiting - 'self.jmAppDelegateVisitor' is [\(String(describing: self.jmAppDelegateVisitor))]...")
//  
//      return
//
//  } // End of public func setJmAppDelegateVisitorInstance().

    private func runPostInitializationTasks()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'self' is [\(self)]...")

        // Initialize the SwiftData 'model' Container (on the 'model' Configuration)...
        
        do
        {
            self.schema             = Schema([StatusItemMenuItem.self,])
        //  self.schema             = Schema(["StatusItemMenuItem",])
            
            self.xcgLogMsg("\(sCurrMethodDisp) Schema has been constructed for StatusItemMenuItem (class)...")

            self.modelConfiguration = ModelConfiguration(schema:self.schema!, isStoredInMemoryOnly:false, allowsSave:true)

            self.xcgLogMsg("\(sCurrMethodDisp) ModelConfiguration has been constructed on the Schema...")
            
            self.modelContainer     = try ModelContainer(for:self.schema!, configurations:modelConfiguration!)
            
            self.xcgLogMsg("\(sCurrMethodDisp) ModelContainer has been constructed on the ModelConfiguration...")
        }
        catch
        {
            self.xcgLogMsg("\(sCurrMethodDisp) ModelContainer has failed construction - Details: \(error) - Error!")

            self.modelContainer = nil

            if (AppGlobalInfo.bEnableAppDevSwiftDataRecovery == false)
            {
                // Exit - We will not 'nuke' the SwiftData Store nor attempt a recovery...
        
                self.xcgLogMsg("\(sCurrMethodDisp) Exiting - SwiftDataManager ModelContainer has failed construction in the 1st attempt - recovery NOT allowed - Error!")
        
                return
            }
        }

        // If we don't have a 'model' Container, then decide if we can attempt recovery.

        if (self.modelContainer == nil)
        {
            if (AppGlobalInfo.bEnableAppDevSwiftDataRecovery == true)
            {
                self.nukeAppSwiftDataStore()
            }
        
            do
            {
                self.modelContainer = try ModelContainer(for:self.schema!, configurations:modelConfiguration!)

                self.xcgLogMsg("\(sCurrMethodDisp) ModelContainer has been constructed on the ModelConfiguration...")
            }
            catch
            {
                self.xcgLogMsg("\(sCurrMethodDisp) ModelContainer has failed construction - Details: \(error) - Error!")

                self.modelContainer = nil
            }

            if (self.modelContainer == nil)
            {
                self.xcgLogMsg("\(sCurrMethodDisp) ModelContainer has failed construction in recovery - Severe Error!")

                // Exit...
        
                self.xcgLogMsg("\(sCurrMethodDisp) Exiting - SwiftDataManager ModelContainer has failed construction in recovery - Severe Error!")
        
                return
            }
        }
        
        // Initialize the SwiftData 'model' Context (on the 'model' Container)...
        
        self.modelContext = ModelContext(self.modelContainer!)

        if (self.modelContext != nil) 
        {
            self.xcgLogMsg("\(sCurrMethodDisp) ModelContext has been obtained (from the ModelContainer)...")
        }
        else
        {
            // Exit:

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - SwiftDataManager ModelContext has NOT been obtained (from the ModelContainer) - Error!")

            return
        }

        // Finish the setup of the 'modelContext'...

        if (self.modelContext != nil) 
        {
            self.modelContext?.autosaveEnabled = false
            
            self.xcgLogMsg("\(sCurrMethodDisp) ModelContext 'autosaveEnabled' has been set to 'false'...")

            self.modelContext!.undoManager     = UndoManager()

            self.xcgLogMsg("\(sCurrMethodDisp) UndoManager has been constructed on the ModelContext...")

            if let urlSwiftDataLocation = self.modelContext!.container.configurations.first?.url 
            {
                self.xcgLogMsg("\(sCurrMethodDisp) <SwiftData Location> 📱 The SwiftData 'location' is [\(urlSwiftDataLocation)]...")
                self.xcgLogMsg("\(sCurrMethodDisp) <SwiftData Location> 📱 The SwiftData 'self.modelContext.container.configurations' is [\(self.modelContext!.container.configurations)]...")
            }

        //  // Fetch the initial SwiftData item(s)...
        //
        //  self.xcgLogMsg("\(sCurrMethodDisp) Invoking 'self.fetch(predicate:nil, sortBy:nil)' to get 'statusItemMenuItems' item(s)...")
        //
        //  var statusItemMenuItems:[StatusItemMenuItem] = [StatusItemMenuItem]()
        //
        //  Task
        //  {
        //      statusItemMenuItems = try await self.fetchPersistentModels()
        //  }
        //
        //  self.xcgLogMsg("\(sCurrMethodDisp) Invoked  'self.fetch(predicate:nil, sortBy:nil)' to get #(\(statusItemMenuItems.count)) 'statusItemMenuItems' item(s)...")
        }

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of private func runPostInitializationTasks().

    // Protocol Method(s):

    func areEqual<T>(_ lhs:T, _ rhs:T, using comparator:(T, T)->Bool)->Bool 
    {

        return comparator(lhs, rhs)

    }   // End of func areEqual<T>(_ lhs:T, _ rhs:T, using comparator:(T, T)->Bool)->Bool.

    // Implement DataManager methods for non-SwiftData types:

    func fetch<T:DataItem>() async throws->[T] 
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // For non-SwiftData types, use other storage...

        let typeName:String = String(describing:T.self)
        let dataItems:[T]   = try await self.appDataItemsRepo.fetch()

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - returning DataItem(s) of [\(typeName)] with #(\(dataItems.count)) item(s)...")

        return dataItems

    }   // End of func fetch<T:DataItem>() async throws->[T].

    func fetch<T:DataItem>(byId id:T.ID) async throws->T? 
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'id' is [\(id)]...")

        // For non-SwiftData types, use Repo storage...
        
        return try await self.appDataItemsRepo.fetch(byId:id)

    }   // End of func fetch<T:DataItem>(byId id:T.ID) async throws->T?.

    func fetchPersistentModels<T:PersistentModel & DataItem>(predicate:Predicate<T>? = nil, sortBy:[SortDescriptor<T>] = []) async throws->[T] 
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'predicate' is [\(String(describing: predicate))] - 'sortBy' is [\(sortBy)]...")

        if (self.modelContext == nil)
        {
            throw DataManagerError.invalidModelContext
        }

        let typeName:String                 = String(describing:T.self)
        let fetchDescriptor:FetchDescriptor = FetchDescriptor<T>(predicate:predicate, sortBy:sortBy)
        let dataItems:[T]                   = try self.modelContext!.fetch(fetchDescriptor)

        self.appDataItemsRepo.reacquireStorage(from:dataItems)
    //  self.appDataItemsRepo.dataItemsStorage[typeName] = dataItems

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - returning DataItem(s) of [\(typeName)] with #(\(dataItems.count)) item(s)...")

        return dataItems

    }   // End of func fetchPersistentModels<T:PersistentModel & DataItem>(predicate:Predicate<T>?, sortBy:[SortDescriptor<T>]) async throws->[T].

    func save<T:DataItem>(_ item:T) async throws 
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'item' is [\(item)]...")

        if (self.modelContext == nil)
        {
            throw DataManagerError.invalidModelContext
        }

        let typeName:String = String(describing:T.self)

        if let persistentItem = item as? any PersistentModel 
        {
            self.modelContext!.insert(persistentItem)

            try self.modelContext!.save()
        }

        try await self.appDataItemsRepo.save(item)

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - Saved a DataItem of [\(typeName)] with ID of [\(item.id)]...")

        return

    }   // End of func save<T:DataItem>(_ item:T) async throws.

    func saveBatch<T:DataItem>(_ items:[T]) async throws 
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'items' are [\(items)]...")

        if (self.modelContext == nil)
        {
            throw DataManagerError.invalidModelContext
        }

        let typeName:String = String(describing:T.self)

        for item in items 
        {
            if let persistentItem = item as? any PersistentModel 
            {
                self.modelContext!.insert(persistentItem)
            }
        }

        try self.modelContext!.save()

        try await self.appDataItemsRepo.saveBatch(items)

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - Saved a 'batch' of DataItem(s) of [\(typeName)] with #(\(items.count)) item(s)...")

        return

    }   // End of func saveBatch<T:DataItem>(_ items:[T]) async throws.

    func upsert<T:DataItem>(_ item:T) async throws 
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'item' is [\(item)]...")

        let typeName:String = String(describing:T.self)

        if let persistentItem = item as? (any PersistentModel & DataItem) 
        {
            try await upsertPersistentModel(persistentItem)
        }
        else
        {
            try await self.appDataItemsRepo.upsert(item)
        }

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'upsert'd a DataItem of [\(typeName)] with ID of [\(item.id)]...")

        return

    }   // End of func upsert<T:DataItem>(_ item:T) async throws.

    func upsertPersistentModel<T:PersistentModel & DataItem>(_ item:T) async throws 
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'item' is [\(item)] with ID of [\(item.id)]...")

        if (self.modelContext == nil)
        {
            throw DataManagerError.invalidModelContext
        }

        try item.validate()

        // Create a fetch descriptor to find existing items by business equality...

        let typeName:String                 = String(describing:T.self)
        let fetchDescriptor:FetchDescriptor = FetchDescriptor<T>()
        let dataItems:[T]                   = try self.modelContext!.fetch(fetchDescriptor)

        if var existingItem = dataItems.first(where:{ $0.isLogicallyEqual(to:item) })
        {
            // Update the existing item...

            existingItem.update(from:item)

            self.xcgLogMsg("\(sCurrMethodDisp) Intermediate - updated an 'existing' DataItem of [\(typeName)] item with ID of [\(item.id)] in SwiftData...")
        }
        else 
        {
            // Insert new...

            self.modelContext!.insert(item)

            self.xcgLogMsg("\(sCurrMethodDisp) Intermediate - inserted a 'new' DataItem(s) of [\(typeName)] item with ID of [\(item.id)] in SwiftData...")
        }

        try self.modelContext!.save()
        
    //  DispatchQueue.main.async
    //  {
    //      do
    //      {
    //          try await self.appDataItemsRepo.upsert(item)
    //      }
    //  //  try await self.appDataItemsRepo.upsert(item)
    //  }

        try await self.appDataItemsRepo.upsert(item)

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'upsert'd <PersistentModel> a DataItem of [\(typeName)] with ID of [\(item.id)]...")

        return

    }   // End of func upsertPersistentModel<T:PersistentModel & DataItem>(_ item:T) async throws.

    func delete<T:DataItem>(_ item:T) async throws 
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'item' is [\(item)]...")

        let typeName:String   = String(describing:T.self)

        if let persistentItem = item as? any PersistentModel 
        {
            self.modelContext!.delete(persistentItem)

            try self.modelContext!.save()
        }

        try await self.appDataItemsRepo.delete(item)

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - Deleted a DataItem of [\(typeName)] with ID of [\(item.id)]...")

        return

    }   // End of func delete<T:DataItem>(_ item:T) async throws.

    func delete<T:DataItem>(from items:[T], at offsets:IndexSet) async throws->[T] 
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'items' are [\(items)] - 'offsets' is [\(offsets)]...")

        let typeName:String = String(describing:T.self)
        let dataItems:[T]  = try await self.appDataItemsRepo.delete(from:items, at:offsets)

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - removed DataItem(s) of [\(typeName)] - storage now has #(\(dataItems.count)) item(s)...")

        return dataItems

    }   // End of func delete<T:DataItem>(from items:[T], at offsets:IndexSet) async throws->[T].

    func deletePersistentModels<T:PersistentModel & DataItem>(from items:[T], at offsets:IndexSet) async throws->[T] 
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'items' are [\(items)] - 'offsets' is [\(offsets)]...")

        if (self.modelContext == nil)
        {
            throw DataManagerError.invalidModelContext
        }

        let typeName:String = String(describing:T.self)
        var dataItems:[T]   = items

        // Delete from SwiftData context and remove from array (in reverse order)...

        for offset in offsets.sorted(by:>) 
        {
            if offset < dataItems.count 
            {
                let removedDataItem = dataItems[offset]

                self.modelContext!.delete(removedDataItem)
                dataItems.remove(at:offset)

                self.xcgLogMsg("\(sCurrMethodDisp) Intermediate - Deleted a DataItem of [\(typeName)] with ID of [\(removedDataItem.id)]...")
            }
        }

        try self.modelContext!.save()

        dataItems = try await self.appDataItemsRepo.delete(from:items, at:offsets)

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - removed DataItem(s) of [\(typeName)] - storage now has #(\(dataItems.count)) item(s)...")

        return dataItems

    }   // End of func deletePersistentModels<T:PersistentModel & DataItem>(from items:[T], at offsets:IndexSet) async throws->[T].

    func deletePersistentModel<T:PersistentModel & DataItem>(_ item:T) async throws
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'item' is [\(item)]...")

        let typeName:String   = String(describing:T.self)

        if let persistentItem = item as? any PersistentModel 
        {
            self.modelContext!.delete(persistentItem)

            try self.modelContext!.save()
        }

        try await self.appDataItemsRepo.delete(item)

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - Deleted a DataItem of [\(typeName)] with ID of [\(item.id)]...")

        return

    }   // End of func deletePersistentModel<T:PersistentModel & DataItem>(_ item:T) async throws.

    func transform<Input, Output>(_ input:Input, using transformer:(Input)->Output)->Output 
    {

        return transformer(input)

    }   // End of func transform<Input, Output>(_ input:Input, using transformer:(Input)->Output)->Output.

    public func displayDataItemsToLog()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
  
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Pass on the detail of the DataItem(s) to the Repo...

        self.appDataItemsRepo.displayDataItemsToLog()

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return
  
    }   // End of public func displayDataItemsToLog().
  
    // Retrieve the storage for a given Type...
    // NOTE: Use a 'comparson' closure for sort and NOT SortDescriptor(s)...

    func retrieveStorage<T:DataItem>(by comparison:((T, T)->Bool)? = nil)->[T]
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Pass on the retrieval of storage (if any) to the Repo...

        let dataItems:[T] = self.appDataItemsRepo.retrieveStorage(by:comparison)

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return dataItems
  
    }   // End of func retrieveStorage<T:DataItem>(by comparison:((T, T)->Bool)?)->[T].

    // Retrieve the storage for a given Key (aka, Type.self)...
    // NOTE: Use a 'comparson' closure for sort and NOT SortDescriptor(s)...

    func retrieveStorage<T>(for sTypeKey:String, by comparison:((T, T)->Bool)? = nil)->[T] where T:Comparable
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        if (sTypeKey.count < 1)
        {
            // Exit:
        
            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - returning an empty list - supplied 'sTypeKey' is an empty string...")

            return [T]()
        }

        // Pass on the retrieval of storage (if any) to the Repo...

        let dataItems:[T] = self.appDataItemsRepo.retrieveStorage(for:sTypeKey, by:comparison)

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return dataItems
  
    }   // End of func retrieveStorage<T>(for sTypeKey:String, by comparison:((T, T)->Bool)?)->[T] where T:Comparable.

    func reacquireStorage<T:DataItem>(from items:[T])
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Pass on the reacquire of storage (if any) to the Repo...

        self.appDataItemsRepo.reacquireStorage(from:items)

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return
  
    }   // End of func reacquireStorage<T:DataItem>(from items:[T]).

    func reacquireStorage(for sTypeKey:String, from items:[Any])
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        if (sTypeKey.count < 1)
        {
            // Exit:
        
            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - supplied 'sTypeKey' is an empty string...")

            return
        }

        // Pass on the reacquire of storage (if any) to the Repo...

        self.appDataItemsRepo.reacquireStorage(for:sTypeKey, from:items)

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return
  
    }   // End of reacquireStorage(for sTypeKey:String, from items:[Any]).

    // Reacquire (set) the storage for a PersistentModel...

    func reacquireStoragePersistentModels<T:DataItem>(from items:[T])
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Reacquire the Storage by saving the 'batch' into SwiftData...

        Task
        {
            do
            {
                try await self.saveBatch(items)

                // Pass on the reacquire of storage (if any) to the Repo...

                self.appDataItemsRepo.reacquireStorage(from:items)
            }
            catch
            {
                self.xcgLogMsg("\(sCurrMethodDisp) Save of the 'batch' of PersistentModel storage failed - Details: \(error) - Error!")
            }
        }

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return
  
    }   // End of func reacquireStoragePersistentModels<T:DataItem>(from items:[T]).

    private func nukeAppSwiftDataStore()
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // 'Nuke' the SwiftData storage...

        let appSupportURL  = URL.applicationSupportDirectory
        let storeURL       = appSupportURL.appending(path:"default.store")
        let storeURLForWal = storeURL.appendingPathExtension("wal")
        let storeURLForShm = storeURL.appendingPathExtension("shm")

        // Delete all the store files...

        try? FileManager.default.removeItem(at:storeURL)
        try? FileManager.default.removeItem(at:storeURLForWal)
        try? FileManager.default.removeItem(at:storeURLForShm)

        self.xcgLogMsg("\(sCurrMethodDisp) Intermediate - Deleted the files: [\(storeURL)], [\(storeURLForWal)], and [\(storeURLForShm)]...")

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return
  
    }   // End of private func nukeAppSwiftDataStore().

}   // End of class AppSwiftDataManager(NSObject).

