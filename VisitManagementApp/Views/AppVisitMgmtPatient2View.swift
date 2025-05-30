//
//  AppVisitMgmtPatient2View.swift
//  VisitManagementApp
//
//  Created by Daryl Cox on 02/05/2025.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct AppVisitMgmtPatient2View: View 
{
    
    struct ClassInfo
    {
        
        static let sClsId        = "AppVisitMgmtPatient2View"
        static let sClsVers      = "v1.0601"
        static let sClsDisp      = sClsId+"(.swift).("+sClsVers+"):"
        static let sClsCopyRight = "Copyright (C) JustMacApps 2023-2025. All Rights Reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }
    
    // App Data field(s):

//  @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode)     var presentationMode
    @Environment(\.openURL)              var openURL
    @Environment(\.openWindow)           var openWindow

    enum FocusedFields
    {
       case patientName
    }
    
    @FocusState  private var focusedField:FocusedFields?

    @State       private var sPatientPID:String                                    = ""
    @State       private var sPatientName:String                                   = ""

    @State       private var listSelectablePatientNames:[AppSearchablePatientName] = [AppSearchablePatientName]()

    @State       private var cAppLogPFDataButtonPresses:Int                        = 0
    @State       private var cAppVisitMgmtPatient2ViewRefreshButtonPresses:Int  = 0

    @State       private var isAppLogPFDataViewModal:Bool                          = false
    @State       private var isAppRunPatientLocateByNameShowing:Bool               = false
    @State       private var isAppPatientDetailsByNameShowing:Bool                 = false

                         var jmAppDelegateVisitor:JmAppDelegateVisitor             = JmAppDelegateVisitor.ClassSingleton.appDelegateVisitor
    @ObservedObject      var jmAppParseCoreManager:JmAppParseCoreManager           = JmAppParseCoreManager.ClassSingleton.appParseCodeManager
    
    init()
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Exit...

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

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

    var body: some View
    {
        
        let _ = xcgLogMsg("\(ClassInfo.sClsDisp):body(some View) \(ClassInfo.sClsCopyRight)...")
        
    //  NavigationStack
        ScrollView
        {

            VStack
            {

                HStack(alignment:.center)
                {

                    if (AppGlobalInfo.bPerformAppDevTesting == true)
                    {

                        Button
                        {

                            self.cAppLogPFDataButtonPresses += 1

                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):AppVisitMgmtPatient2View.Button(Xcode).'Log/Reload Data'.#(\(self.cAppLogPFDataButtonPresses)) pressed...")

                            self.isAppLogPFDataViewModal.toggle()

                        //  self.detailPFCscDataItems()

                        }
                        label:
                        {

                            VStack(alignment:.center)
                            {

                                Label("", systemImage: "doc.text.magnifyingglass")
                                    .help(Text("Log PFXxxDataItem(s)..."))
                                    .imageScale(.small)

                                Text("Log/Reload Data")
                                    .font(.caption2)

                            }

                        }
                    #if os(macOS)
                        .sheet(isPresented:$isAppLogPFDataViewModal, content:
                            {

                                AppLogPFDataView()

                            }
                        )
                    #endif
                    #if os(iOS)
                        .fullScreenCover(isPresented:$isAppLogPFDataViewModal)
                        {

                            AppLogPFDataView()

                        }
                    #endif
                        .padding()
                    #if os(macOS)
                        .buttonStyle(.borderedProminent)
                    //  .background(???.isPressed ? .blue : .gray)
                        .cornerRadius(10)
                        .foregroundColor(Color.primary)
                    #endif

                    }

                    Spacer()

                    Button
                    {

                        self.cAppVisitMgmtPatient2ViewRefreshButtonPresses += 1

                        let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)AppVisitMgmtPatient2View.Button(Xcode).'Refresh'.#(\(self.cAppVisitMgmtPatient2ViewRefreshButtonPresses))...")

                    }
                    label:
                    {

                        VStack(alignment:.center)
                        {

                            Label("", systemImage: "arrow.clockwise")
                                .help(Text("'Refresh' App VMA Patient by Name Screen..."))
                                .imageScale(.large)

                            Text("Refresh - #(\(self.cAppVisitMgmtPatient2ViewRefreshButtonPresses))...")
                                .font(.caption)

                        }

                    }
                #if os(macOS)
                    .buttonStyle(.borderedProminent)
                    .padding()
                //  .background(???.isPressed ? .blue : .gray)
                    .cornerRadius(10)
                    .foregroundColor(Color.primary)
                #endif

                    Spacer()

                    Button
                    {

                        let _ = xcgLogMsg("\(ClassInfo.sClsDisp):AppVisitMgmtPatient2View.Button(Xcode).'Dismiss' pressed...")

                        self.presentationMode.wrappedValue.dismiss()

                    //  dismiss()

                    }
                    label:
                    {

                        VStack(alignment:.center)
                        {

                            Label("", systemImage: "xmark.circle")
                                .help(Text("Dismiss this Screen"))
                                .imageScale(.large)

                            Text("Dismiss")
                                .font(.caption)

                        }

                    }
                #if os(macOS)
                    .buttonStyle(.borderedProminent)
                    .padding()
                //  .background(???.isPressed ? .blue : .gray)
                    .cornerRadius(10)
                    .foregroundColor(Color.primary)
                #endif
                    .padding()

                }

                VStack(alignment:.center)
                {

                    Text(" - - - - - - - - - - - - - - - - - - - - ")
                        .font(.caption2) 
                        .frame(maxWidth:.infinity, alignment:.center)

                    HStack
                    {

                        Button
                        {

                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtPatient2View.Button(Xcode).'Locate the Patient by Name'...")

                            self.sPatientPID = self.locateAppPatientNameByName(sPatientName:self.sPatientName)

                            self.isAppRunPatientLocateByNameShowing.toggle()

                        }
                        label:
                        {

                            HStack(alignment:.center)
                            {

                                Spacer()

                                Label("", systemImage: "figure.run.circle")
                                    .help(Text("Locate the Patient by Name..."))
                                    .imageScale(.small)

                                Text("=> Locate Patient by Name")
                                    .bold()
                                    .font(.caption2)
                                    .foregroundColor(.red)

                                Spacer()

                            }

                        }
                    #if os(macOS)
                        .buttonStyle(.borderedProminent)
                        .padding()
                    //  .background(???.isPressed ? .blue : .gray)
                        .cornerRadius(10)
                        .foregroundColor(Color.primary)
                    #endif
                    //  .padding()

                    }

                    Text(" - - - - - - - - - - - - - - - - - - - - ")
                        .font(.caption2) 
                        .frame(maxWidth:.infinity, alignment:.center)

                }

                HStack()
                {

                    Text("===> Patients' PID: ")
                        .font(.caption) 

                    Text("\(sPatientPID)")
                        .font(.caption) 
                        .onChange(of:self.sPatientName)
                        {
                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onChange #1 - 'self.sPatientName' is [\(self.sPatientName)] - clearing the 'sPatientPID' field...")

                            self.sPatientPID = ""
                        }

                    Spacer()

                    if (self.sPatientPID.count    > 0 &&
                        (self.sPatientName.count  > 0 &&
                         self.sPatientName       != "-N/A-"))
                    {

                        Button
                        {

                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtPatient2View.Button(Xcode).'Patient Detail(s) by Name'...")

                            self.isAppPatientDetailsByNameShowing.toggle()

                        }
                        label:
                        {

                            VStack(alignment:.center)
                            {

                                Label("", systemImage: "doc.questionmark")
                                    .help(Text("Show Patient Detail(s) by Name..."))
                                    .imageScale(.medium)

                                HStack(alignment:.center)
                                {

                                    Spacer()

                                    Text("Patient Details...")
                                        .font(.caption2)

                                    Spacer()

                                }

                            }

                        }
                    #if os(macOS)
                        .sheet(isPresented:$isAppPatientDetailsByNameShowing, content:
                        {

                            AppVisitMgmtPatient1DetailsView(sPatientPID:$sPatientPID)

                        })
                    #endif
                    #if os(iOS)
                        .fullScreenCover(isPresented:$isAppPatientDetailsByNameShowing)
                        {

                            AppVisitMgmtPatient1DetailsView(sPatientPID:$sPatientPID)

                        }
                    #endif
                    #if os(macOS)
                        .buttonStyle(.borderedProminent)
                        .padding()
                    //  .background(???.isPressed ? .blue : .gray)
                        .cornerRadius(10)
                        .foregroundColor(Color.primary)
                    #endif
                        .padding()
                    
                    }

                }

                HStack()
                {

                    Text("=> Enter the Patients' Name: ")
                        .font(.caption) 
                        .foregroundColor(.red)

                    TextField("Patient Name...", text:$sPatientName)
                        .italic()
                        .font(.caption) 
                        .focused($focusedField, equals:.patientName)
                        .onAppear
                        {
                            self.sPatientName = ""
                            self.sPatientPID  = ""
                            focusedField      = .patientName
                        }
                        .onChange(of: self.sPatientName)
                        {
                            self.updateSelectablePatientNamesList(sSearchValue:self.sPatientName)
                            focusedField      = .patientName

                            if (self.sPatientName.count < 1)
                            {
                                self.sPatientPID = ""
                            }
                        }
                        .onSubmit
                        {
                            self.sPatientPID  = self.locateAppPatientNameByName(sPatientName:self.sPatientName)
                            focusedField      = .patientName
                        }

                    Spacer()
                    
                    Button
                    {

                        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtPatient2View.Button(Xcode).'Patient Name delete'...")

                        self.sPatientName = ""
                        self.sPatientPID  = ""
                        focusedField      = .patientName

                    }
                    label:
                    {

                        VStack(alignment:.center)
                        {

                            Label("", systemImage: "delete.left")
                                .help(Text("Delete the Patient Name..."))
                                .imageScale(.medium)

                            HStack(alignment:.center)
                            {

                                Spacer()

                                Text("Delete Patient Name")
                                    .font(.caption2)

                                Spacer()

                            }

                        }

                    }
                #if os(macOS)
                    .buttonStyle(.borderedProminent)
                    .padding()
                //  .background(???.isPressed ? .blue : .gray)
                    .cornerRadius(10)
                    .foregroundColor(Color.primary)
                #endif
                    .padding()

                }

                Text("")
                    .font(.caption2)
                    .onAppear
                    {

                        listSelectablePatientNames = [AppSearchablePatientName]()

                        listSelectablePatientNames.append(AppSearchablePatientName(sPatientName:"...placeholder...", sPatientPID:"-1"))

                    }

                List(listSelectablePatientNames, id:\.id)
                { appSearchablePatientName in

                    Text(appSearchablePatientName.sPatientName)
                        .onTapGesture
                        {
                            self.sPatientName = appSearchablePatientName.sPatientName
                            self.sPatientPID  = self.locateAppPatientNameByName(sPatientName:self.sPatientName)
                            focusedField      = .patientName
                        }

                }
                .scaledToFill()
                .font(.caption) 
            //  .frame(maxHeight:250)

            }

            Spacer()

        }
        .padding()
        
    }
    
    private func locateAppPatientNameByName(sPatientName:String = "")->String
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'sPatientName' is [\(sPatientName)]...")

        // Locate the Patient PID by 'name'...

        var sPatientPID:String = self.jmAppParseCoreManager.convertPatientNameToPid(sPFPatientParseName:sPatientName)

        if (sPatientPID.count < 1)
        {
        
            sPatientPID = "-1"
        
        }

        // Exit...

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'sPatientName' is [\(sPatientName)] - 'sPatientPID' is [\(sPatientPID)]...")
  
        return sPatientPID
  
    }   // End of private func locateAppPatientNameByName(sPatientName:String)->String.

    private func updateSelectablePatientNamesList(sSearchValue:String = "")
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'sSearchValue' is [\(sSearchValue)]...")

        // Update the 'selectable' Patient 'name(s)' list from the 'sSearchValue' criteria...

        if (sSearchValue.isEmpty)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) Intermediate #1 - parameter 'sSearchValue' is an empty 'string' - unable to update the 'selectable' item(s) - Warning!")
            
            // Exit:

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return
        
        }

        // var dictPFPatientFileItems:[Int:ParsePFPatientFileItem] = [Int:ParsePFPatientFileItem]()

        if (self.jmAppParseCoreManager.dictPFPatientFileItems.count < 1)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) Intermediate #2 - 'self.jmAppParseCoreManager.dictPFPatientFileItems' is an empty 'dictionary' - unable to update the 'selectable' item(s) - Warning!")
            
            // Exit:

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return
        
        }

        self.xcgLogMsg("\(sCurrMethodDisp) Intermediate #3 - 'sSearchValue' is [\(sSearchValue)] - 'self.jmAppParseCoreManager.dictPFPatientFileItems' contains (\(self.jmAppParseCoreManager.dictPFPatientFileItems.count)) item(s)...")

        self.listSelectablePatientNames = [AppSearchablePatientName]()

        var cPatientNames:Int           = 0
        var cSelectablePatientNames:Int = 0
        let sSearchValueLow:String        = sSearchValue.lowercased()
        
        // var dictPFPatientFileItems:[Int:ParsePFPatientFileItem] = [Int:ParsePFPatientFileItem]()

        for (iPFPatientParsePID, pfPatientFileItem) in self.jmAppParseCoreManager.dictPFPatientFileItems
        {

            cPatientNames += 1

            if (iPFPatientParsePID < 0)
            {

                self.xcgLogMsg("\(sCurrMethodDisp) Skipping object #(\(cPatientNames)) 'iPFPatientParsePID' - the 'pid' field is less than 0 - Warning!")

                continue

            }

            let sPatientPID:String      = "\(pfPatientFileItem.iPFPatientFilePID)"
            let sPatientName:String     = pfPatientFileItem.sPFPatientFileName
            let sPatientNameLow:String  = sPatientName.lowercased()
            let sPatientNameNoWS:String = pfPatientFileItem.sPFPatientFileNameNoWS

            if (sPatientNameLow.contains(sSearchValueLow)  == true ||
                sPatientNameNoWS.contains(sSearchValueLow) == true)
            {
            
                self.listSelectablePatientNames.append(AppSearchablePatientName(sPatientName:sPatientName, sPatientPID:sPatientPID))

                cSelectablePatientNames += 1

                self.xcgLogMsg("\(sCurrMethodDisp) #(\(cPatientNames)): 'sPatientName' of [\(sPatientName)] - 'sPatientPID' is [\(sPatientPID)] contains the 'sSearchValue' of [\(sSearchValue)] - adding to the 'selectable' list...")
            
            }

        }

        self.xcgLogMsg("\(sCurrMethodDisp) Intermediate #3 - added (\(cSelectablePatientNames)) names(s) to the 'selectable' list of (\(self.listSelectablePatientNames.count)) item(s)...")

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of private func updateSelectablePatientNamesList(sSearchValue:String).

}   // End of struct AppVisitMgmtPatient2View(View).

#Preview 
{
    
    AppVisitMgmtPatient2View()
    
}

