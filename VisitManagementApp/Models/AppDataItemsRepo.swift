//
//  AppDataItemsRepo.swift
//  QRCaptureRefactorApp3
//
//  Created by Daryl Cox on 06/26/2025.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftData

public class AppDataItemsRepo:NSObject, ObservableObject, DataItemRepo
{
    
    struct ClassInfo
    {
        
        static let sClsId        = "AppDataItemsRepo"
        static let sClsVers      = "v1.0801"
        static let sClsDisp      = sClsId+".("+sClsVers+"): "
        static let sClsCopyRight = "Copyright (C) JustMacApps 2024-2025. All Rights Reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }

    // Class 'singleton' instance:

            static  var appDataItemsRepo:AppDataItemsRepo          = AppDataItemsRepo()

    // Various App field(s):

           private  var bInternalTest:Bool                         = true

    // Various App SwiftData field(s):

//         public   var schema:Schema?                             = nil
//         public   var modelConfiguration:ModelConfiguration?     = nil
//         public   var modelContainer:ModelContainer?             = nil
//         public   var modelContext:ModelContext?                 = nil
//  //     public   var undoManager:UndoManager?                   = nil

           private  var dataItemsStorage:[String:[Any]]            = [String:[Any]]()
//  @Published      var dataItemsStorage:[String:[Any]]            = [String:[Any]]()
//  {
//      didSet
//      {
//          objectWillChange.send()
//      }
//  }

//  // App 'delegate' Visitor:
//
//                  var jmAppDelegateVisitor:JmAppDelegateVisitor? = nil
//                                                                   // 'jmAppDelegateVisitor' MUST remain declared this way
//                                                                   // as having it reference the 'shared' instance of 
//                                                                   // JmAppDelegateVisitor causes a circular reference
//                                                                   // between the 'init()' methods of the 2 classes...
//
//  // App <global> Message(s) 'stack' cached before XCGLogger is available:
//
//                  var listPreXCGLoggerMessages:[String]          = Array()

    private override init()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        super.init()
      
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Finish any 'initialization' work:
        
        self.xcgLogMsg("\(sCurrMethodDisp) AppDataItemsRepo Invoking 'self.runPostInitializationTasks()'...")
        
        self.runPostInitializationTasks()
        
        self.xcgLogMsg("\(sCurrMethodDisp) AppDataItemsRepo Invoked  'self.runPostInitializationTasks()'...")
      
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
//      asToString.append("],")
//      asToString.append("[")
//      asToString.append("SwiftData 'schema': [\(String(describing: self.schema))],")
//      asToString.append("SwiftData 'modelConfiguration': [\(String(describing: self.modelConfiguration))],")
//      asToString.append("SwiftData 'modelContainer': [\(String(describing: self.modelContainer))],")
//      asToString.append("SwiftData 'modelContext': [\(String(describing: self.modelContext))]")
//  //  asToString.append("SwiftData 'undoManager': [\(String(describing: self.undoManager))],")
        asToString.append("],")
        asToString.append("[")
        asToString.append("SwiftData 'dataItemsStorage': [\(String(describing: self.dataItemsStorage))[,")
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
//      self.cAppDataItemsRepoMethodCalls += 1
//  
//      self.xcgLogMsg("\(sCurrMethodDisp)#(\(self.cAppDataItemsRepoMethodCalls))' Invoked - supplied parameter 'jmAppDelegateVisitor' is [\(jmAppDelegateVisitor)]...")
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
//      self.xcgLogMsg("\(sCurrMethodDisp)#(\(self.cAppDataItemsRepoMethodCalls))' AppDataItemsRepo Invoking 'self.runPostInitializationTasks()'...")
//  
//      self.runPostInitializationTasks()
//
//      self.xcgLogMsg("\(sCurrMethodDisp)#(\(self.cAppDataItemsRepoMethodCalls))' AppDataItemsRepo Invoked  'self.runPostInitializationTasks()'...")
//  
//      // Exit:
//
//      self.xcgLogMsg("\(sCurrMethodDisp)#(\(self.cAppDataItemsRepoMethodCalls))' Exiting - 'self.jmAppDelegateVisitor' is [\(String(describing: self.jmAppDelegateVisitor))]...")
//  
//      return
//
//  } // End of public func setJmAppDelegateVisitorInstance().

    private func runPostInitializationTasks()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'self' is [\(self)]...")

        // Handle 'post' Initialization task(s)...
        
        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of private func runPostInitializationTasks().

    // Protocol Method(s):

    func areEqual<T>(_ lhs:T, _ rhs:T, using comparator:(T, T)->Bool)->Bool 
    {

        return comparator(lhs, rhs)

    }   // End of func areEqual<T>(_ lhs:T, _ rhs:T, using comparator:(T, T)->Bool)->Bool.

    func fetch<T:DataItem>() async throws->[T] 
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        let typeName:String = String(describing:T.self)
        let dataItems:[T]   = self.dataItemsStorage[typeName] as? [T] ?? [T]()

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - returning DataItem(s) of [\(typeName)] with #(\(dataItems.count)) item(s)...")

        return dataItems

    }   // End of func fetch<T:DataItem>() async throws->[T].

    func fetch<T:DataItem>(byId id:T.ID) async throws->T? 
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'id' is [\(id)]...")

        let typeName:String = String(describing:T.self)
        let dataItems:[T]   = try await fetch()

        let locatedDataItem = dataItems.first
        {
            $0.id == id
        }

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - returning a DataItem of [\(typeName)] of [\(String(describing: locatedDataItem))]...")

        return locatedDataItem

    }   // End of func fetch<T:DataItem>(byId id:T.ID) async throws->T?.

    func save<T:DataItem>(_ item:T) async throws 
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'item' is [\(item)]...")

        try item.validate()

        let typeName:String             = String(describing:T.self)
        var dataItems:[T]               = self.dataItemsStorage[typeName] as? [T] ?? [T]()

        dataItems.append(item)

        self.dataItemsStorage[typeName] = dataItems

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - Saved a DataItem of [\(typeName)] with ID of [\(item.id)]...")

        return

    }   // End of func save<T:DataItem>(_ item:T) async throws.

    func saveBatch<T:DataItem>(_ items:[T]) async throws 
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'items' are [\(items)]...")

        for item in items 
        {
            try item.validate()
        }

        let typeName:String             = String(describing:T.self)
        var dataItems:[T]               = self.dataItemsStorage[typeName] as? [T] ?? [T]()

        dataItems.append(contentsOf:items)

        self.dataItemsStorage[typeName] = dataItems

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - Saved a 'batch' of DataItem(s) of [\(typeName)] with #(\(items.count)) item(s)...")

        return

    }   // End of func saveBatch<T:DataItem>(_ items:[T]) async throws.

    func upsert<T:DataItem>(_ item:T) async throws 
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'item' is [\(item)]...")

        try item.validate()

        let typeName:String             = String(describing:T.self)
        var dataItems:[T]               = self.dataItemsStorage[typeName] as? [T] ?? [T]()

        if let index = dataItems.firstIndex(where:{ $0.isLogicallyEqual(to:item) }) 
        {
            // Update existing...

            dataItems[index].update(from:item)

            self.xcgLogMsg("\(sCurrMethodDisp) Intermediate - updated an 'existing' DataItem of [\(typeName)] item with ID of [\(item.id)]...")
        }
        else 
        {
            // Insert new...

            dataItems.append(item)

            self.xcgLogMsg("\(sCurrMethodDisp) Intermediate - inserted a 'new' DataItem of [\(typeName)] item with ID of [\(item.id)]...")
        }

        self.dataItemsStorage[typeName] = dataItems

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'upsert'd a DataItem of [\(typeName)] with ID of [\(item.id)]...")

        return

    }   // End of func upsert<T:DataItem>(_ item:T) async throws.

    func delete<T:DataItem>(_ item:T) async throws 
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'item' is [\(item)]...")

        let typeName:String             = String(describing:T.self)
        var dataItems:[T]               = self.dataItemsStorage[typeName] as? [T] ?? [T]()

        dataItems.removeAll 
        {
            $0.id == item.id
        }

        self.dataItemsStorage[typeName] = dataItems

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
        var dataItems:[T]   = items

        // Remove items at specified offsets (in reverse order to maintain indices)...

        for offset in offsets.sorted(by:>) 
        {
            if offset < dataItems.count 
            {
                let removedDataItem = dataItems.remove(at:offset)

                self.xcgLogMsg("\(sCurrMethodDisp) Intermediate - Deleted a DataItem of [\(typeName)] with ID of [\(removedDataItem.id)]...")
            }
        }

        // Update self.dataItems Storage with the modified array...

        self.dataItemsStorage[typeName] = dataItems

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - removed DataItem(s) of [\(typeName)] - storage now has #(\(dataItems.count)) item(s)...")

        return dataItems

    }   // End of func delete<T:DataItem>(from items:[T], at offsets:IndexSet) async throws->[T].

    func transform<Input, Output>(_ input:Input, using transformer:(Input)->Output)->Output 
    {

        return transformer(input)

    }   // End of func transform<Input, Output>(_ input:Input, using transformer:(Input)->Output)->Output.

    public func displayDataItemsToLog()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
  
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - AppDataItemsRepo <Detail> for DataItems...")

        // Detail the DataItem(s) of the Repo to the Log...

        for typeName in self.dataItemsStorage.keys
        {
            if (typeName.count < 1)
            {
                continue
            }
            
            let dataItems = self.dataItemsStorage[typeName]

            self.xcgLogMsg("\(ClassInfo.sClsDisp) DataItems <Detail> - Repo DataItem(s) of [\(typeName)] has (\(String(describing: dataItems?.count))) item(s)...")
            
            if (dataItems        == nil ||
                dataItems!.count  < 1)
            {
                continue
            }
            
            for dataItem in dataItems!
            {
                switch (typeName)
                {
                case "StatusItemMenuItem":
                    let statusItemMenuItem:StatusItemMenuItem = dataItem as! StatusItemMenuItem
                    statusItemMenuItem.displayStatusItemMenuItemToLog()
            //  case "dataItemPhotoQR":
            //      let dataItemPhotoQR:DataItemPhotoQR = dataItem as! DataItemPhotoQR
            //      dataItemPhotoQR.displayDataItemPhotoQRToLog()
            //  case "DataItemPID":
            //      let dataItemPID:DataItemPID = dataItem as! DataItemPID
            //      dataItemPID.displayDataItemPIDToLog()
                default:
                    continue
                }
            }
        }

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

        // Retrieve storage (if any) for the supplied Type...

        let typeName:String = String(describing:T.self)
    //  var dataItems:[T]   = self.dataItemsStorage[typeName] as? [T] ?? [T]()
        var dataItems:[T]   = [T]()
        
        if (self.dataItemsStorage[typeName] != nil)
        {
            dataItems = self.dataItemsStorage[typeName] as! [T]
        }

        // Sort ONLY if the list has more than 1 item...

        if (dataItems.count > 1)
        {
            // Use default ascending sort if no comparison provided,
            //     then sort the retrieved storage (and replace it)...

            let actualComparison = comparison ?? { $0 < $1 }

            dataItems.sort(by:actualComparison)

            self.dataItemsStorage[typeName] = dataItems
        }

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - returning DataItem(s) of [\(typeName)] with #(\(dataItems.count)) item(s)...")
  
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

        // Retrieve storage (if any) for the supplied Type...

        let typeName:String = sTypeKey
        var dataItems:[T]   = [T]()
        
        if (self.dataItemsStorage[typeName] != nil)
        {
            dataItems = self.dataItemsStorage[typeName] as! [T]
        }

        // Sort ONLY if the list has more than 1 item...

        if (dataItems.count > 1)
        {
            // Use default ascending sort if no comparison provided,
            //     then sort the retrieved storage (and replace it)...

            let actualComparison = comparison ?? { $0 < $1 }

            dataItems.sort(by:actualComparison)

            self.dataItemsStorage[typeName] = dataItems
        }

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - returning DataItem(s) of [\(typeName)] with #(\(dataItems.count)) item(s)...")
  
        return dataItems
  
    }   // End of func retrieveStorage<T>(for sTypeKey:String, by comparison:((T, T)->Bool)?)->[T] where T:Comparable.

    func reacquireStorage<T:DataItem>(from items:[T])
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Reacquire (set) storage (if any) for the supplied Type...

        let typeName:String = String(describing:T.self)

        self.dataItemsStorage[typeName] = items

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - acquired DataItem(s) of [\(typeName)] with #(\(items.count)) item(s)...")
  
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

        // Reacquire (set) storage (if any) for the supplied Type...

        let typeName:String = sTypeKey

        self.dataItemsStorage[typeName] = items

        // Exit:
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - acquired DataItem(s) of [\(typeName)] with #(\(items.count)) item(s)...")
  
        return
  
    }   // End of func reacquireStorage(for sTypeKey:String), from items:[Any]).

}   // End of public class AppDataItemsRepo:NSObject, ObservableObject, DataItemRepo.

// ----------------------------------------------------------------------------------------------------------
// <<< PARKED Here >>> NOTE: Do NOT use SortDescriptor(s) - these are unstable in runtime...
// ----------------------------------------------------------------------------------------------------------
//
//  // Retrieve the storage for a given Type...
//  // NOTE: Do NOT use SortDescriptor(s) - these are unstable in runtime...
//
//  func retrieveStorage<T:DataItem>(sortBy:[SortDescriptor<T>] = [])->[T]
//  {
//
//      let sCurrMethod:String = #function
//      let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
//
//      self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
//
//      // Retrieve storage (if any) for the supplied Type...
//
//      let typeName:String = String(describing:T.self)
//      var dataItems:[T]   = self.dataItemsStorage[typeName] as? [T] ?? [T]()
//
//      // If SortDescriptor(s) have been provided, the sort the retrieved storage (and replace it)...
//
//      if (!sortBy.isEmpty)
//      {
//          dataItems = dataItems.sorted(using:sortBy)
//
//          self.dataItemsStorage[typeName] = dataItems
//      }
//
//      // Exit:
//
//      self.xcgLogMsg("\(sCurrMethodDisp) Exiting - returning DataItem(s) of [\(typeName)] with #(\(dataItems.count)) item(s)...")
//
//      return dataItems
//
//  }   // End of retrieveStorage<T:DataItem>()->[T].
//
//  // Retrieve the storage for a given Key (aka, Type.self)...
//  // NOTE: Do NOT use SortDescriptor(s) - these are unstable in runtime...
//
//  func retrieveStorage(for sTypeKey:String, sortBy:[SortDescriptor<Any>] = [])->[Any]
//  {
//
//      let sCurrMethod:String = #function
//      let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
//
//      self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
//
//      if (sTypeKey.count < 1)
//      {
//          // Exit:
//
//          self.xcgLogMsg("\(sCurrMethodDisp) Exiting - returning an empty list - supplied 'sTypeKey' is an empty string...")
//
//          return [Any]()
//      }
//
//      // Retrieve storage (if any) for the supplied Type...
//
//      let typeName:String = sTypeKey
//      var dataItems:[Any] = self.dataItemsStorage[typeName] ?? [Any]()
//
//      // If SortDescriptor(s) have been provided, the sort the retrieved storage (and replace it)...
//
//      if (!sortBy.isEmpty)
//      {
//          dataItems = dataItems.sorted(using:sortBy)
//
//          self.dataItemsStorage[typeName] = dataItems
//      }
//
//      // Exit:
//
//      self.xcgLogMsg("\(sCurrMethodDisp) Exiting - returning DataItem(s) of [\(typeName)] with #(\(dataItems.count)) item(s)...")
//
//      return dataItems
//
//  }   // End of retrieveStorage(for sTypeKey:String)->[Any].
//
// ----------------------------------------------------------------------------------------------------------
// <<< PARKED Here >>> NOTE: Do NOT use SortDescriptor(s) - these are unstable in runtime...
// ----------------------------------------------------------------------------------------------------------

