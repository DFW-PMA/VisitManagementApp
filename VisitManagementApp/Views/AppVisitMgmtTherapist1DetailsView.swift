//
//  AppVisitMgmtTherapist1DetailsView.swift
//  VisitManagementApp
//
//  Created by Daryl Cox on 12/26/2024.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

enum TIDType: String, CaseIterable
{
    
    case therapist  = "therapist"
    case supervisor = "supervisor"
    case mentor     = "mentor"
    
}   // End of enum TIDType(String, CaseIterable).

struct AppVisitMgmtTherapist1DetailsView: View 
{
    
    struct ClassInfo
    {
        
        static let sClsId        = "AppVisitMgmtTherapist1DetailsView"
        static let sClsVers      = "v1.1701"
        static let sClsDisp      = sClsId+"(.swift).("+sClsVers+"):"
        static let sClsCopyRight = "Copyright (C) JustMacApps 2023-2025. All Rights Reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }
    
    // App Data field(s):

//  @Environment(\.dismiss)          var dismiss
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.openURL)          var openURL
    @Environment(\.openWindow)       var openWindow

    @Binding     private var sTherapistTID:String

    @State       private var sTherapistName:String                                   = ""
    @State       private var pfTherapistFileItem:ParsePFTherapistFileItem?           = nil

    @State       private var sSupervisorTID:String                                   = ""
    @State       private var sSupervisorName:String                                  = ""

    @State       private var cAppTidScheduleViewButtonPresses:Int                    = 0

    @State       private var isAppTidScheduleViewModal:Bool                          = false
    @State       private var isAppSupervisorDetailsByTIDShowing:Bool                 = false

                         var jmAppDelegateVisitor:JmAppDelegateVisitor               = JmAppDelegateVisitor.ClassSingleton.appDelegateVisitor
    @ObservedObject      var jmAppParseCoreManager:JmAppParseCoreManager             = JmAppParseCoreManager.ClassSingleton.appParseCodeManager
                         var jmAppParseCoreBkgdDataRepo:JmAppParseCoreBkgdDataRepo   = JmAppParseCoreBkgdDataRepo.ClassSingleton.appParseCodeBkgdDataRepo
                         var appScheduleLoadingAssistant:AppScheduleLoadingAssistant = AppScheduleLoadingAssistant.ClassSingleton.appScheduleLoadingAssistant
    
    init(sTherapistTID:Binding<String>)
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        // Handle the 'sTherapistTID' parameter...

        _sTherapistTID = sTherapistTID

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
        
    //  let listScheduledPatientLocationItems:[ScheduledPatientLocationItem]
    //      = self.getScheduledPatientLocationItemsForTid(sPFTherapistParseTID:sTherapistTID)

        NavigationStack
        {

            VStack
            {

                HStack(alignment:.center)
                {

                    Button
                    {

                        self.cAppTidScheduleViewButtonPresses += 1

                        let _ = xcgLogMsg("\(ClassInfo.sClsDisp):AppVisitMgmtTherapist1DetailsView.Button(Xcode).'App TID Schedule View'.#(\(self.cAppTidScheduleViewButtonPresses))...")

                        self.isAppTidScheduleViewModal.toggle()

                    }
                    label:
                    {

                        VStack(alignment:.center)
                        {

                            Label("", systemImage: "doc.text.magnifyingglass")
                                .help(Text("App TID/Patient Schedule Viewer"))
                                .imageScale(.large)

                            Text("Schedule Today")
                                .font(.caption)

                        }

                    }
                #if os(macOS)
                    .sheet(isPresented:$isAppTidScheduleViewModal, content:
                        {

                            AppTidScheduleView(listScheduledPatientLocationItems:self.appScheduleLoadingAssistant.getScheduledPatientLocationItemsForTid(sPFTherapistTID:sTherapistTID))

                        }
                    )
                #elseif os(iOS)
                    .fullScreenCover(isPresented:$isAppTidScheduleViewModal)
                    {

                        AppTidScheduleView(listScheduledPatientLocationItems:self.appScheduleLoadingAssistant.getScheduledPatientLocationItemsForTid(sPFTherapistTID:sTherapistTID))

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
                    .disabled(!self.appScheduleLoadingAssistant.bScheduledPatientLocationItemsAreAvaiable)

                    Spacer()

                    Button
                    {
                        let _ = xcgLogMsg("\(ClassInfo.sClsDisp):AppVisitMgmtView.Button(Xcode).'Sync Data' pressed...")

                        self.syncPFDataItems()
                    }
                    label:
                    {
                        VStack(alignment:.center)
                        {
                            Label("", systemImage: "doc.text.magnifyingglass")
                                .help(Text("Sync PFQuery Data Item(s)..."))
                                .imageScale(.medium)
                            Text("Sync Data")
                                .font(.footnote)
                        }
                    }
                    .padding()
                #if os(macOS)
                    .buttonStyle(.borderedProminent)
                //  .background(???.isPressed ? .blue : .gray)
                    .cornerRadius(10)
                    .foregroundColor(Color.primary)
                #endif

                    Spacer()

                    Button
                    {

                        let _ = xcgLogMsg("\(ClassInfo.sClsDisp):AppVisitMgmtTherapist1DetailsView.Button(Xcode).'Dismiss' pressed...")

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

                    Text("VMA - Therapist Details by TID/tName")
                        .bold()
                        .font(.caption2) 
                        .frame(maxWidth:.infinity, alignment:.center)

                    Text(" - - - - - - - - - - - - - - - - - - - - ")
                        .font(.caption2) 
                        .frame(maxWidth:.infinity, alignment:.center)

                }

                HStack()
                {

                    Text("::: Therapists' TID: ")
                        .font(.caption) 
                        .onAppear
                        {

                            self.sTherapistName = self.locateAppTherapistNamebyTid(tidType:TIDType.therapist, sTherapistTID:self.sTherapistTID)

                            let _ = self.appScheduleLoadingAssistant.getScheduledPatientLocationItemsForTid(sPFTherapistTID:sTherapistTID)

                        }

                    Text("\(self.sTherapistTID)")
                        .italic()
                        .font(.caption) 
                        .foregroundColor(.red)

                    Spacer()

                }

                HStack()
                {

                    Text("Therapists' Name: ")
                        .font(.caption) 

                    Text("\(self.sTherapistName)")
                        .italic()
                        .font(.caption) 
                        .foregroundColor(.red)

                    Spacer()

                }

            if (self.pfTherapistFileItem != nil)
            {
            
                ScrollView(.vertical)
                {

                    Grid(alignment:.leadingFirstTextBaseline, horizontalSpacing:5, verticalSpacing: 3)
                    {

                        // Column Headings:

                        Divider() 

                        GridRow 
                        {

                            Text("Item")
                                .bold()
                                .underline()
                            Text("Value")
                                .bold()
                                .underline()

                        }
                        .font(.caption) 

                        Divider() 

                        // Item Rows:

                        GridRow(alignment:.bottom)
                        {

                            Text("Therapists' Phone #")
                            Text("\(self.formatPhoneNumber(sPhoneNumber:self.pfTherapistFileItem!.sPFTherapistFilePhone))")
                        //  Text("\(self.pfTherapistFileItem!.sPFTherapistFilePhone)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Therapists' Email")
                            Text("\(self.pfTherapistFileItem!.sPFTherapistFileEmail)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Therapists' Username")
                            Text("\(self.pfTherapistFileItem!.sPFTherapistFileUsername)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Therapists' Password")
                            Text("\(self.pfTherapistFileItem!.sPFTherapistFilePassword)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Therapists' HOME Location")
                            Text("\(self.pfTherapistFileItem!.sPFTherapistFileHomeLoc)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Therapists' Address")
                            Text("\(self.pfTherapistFileItem!.sHomeLocLocationName), \(self.pfTherapistFileItem!.sHomeLocCity) \(self.pfTherapistFileItem!.sHomeLocPostalCode)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Therapists' License #")
                            Text(verbatim:"\(self.pfTherapistFileItem!.iPFTherapistFileLicenseNumber)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Therapists' Name (No Whitespace)")
                            Text("\(self.pfTherapistFileItem!.sPFTherapistFileNameNoWS)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Therapists' NOT Active?")
                            Text("\(self.pfTherapistFileItem!.bPFTherapistFileNotActive)")
                                .foregroundStyle((self.pfTherapistFileItem!.bPFTherapistFileNotActive) ? .red : .primary)


                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Therapists' is OFFICE?")
                            Text("\(self.pfTherapistFileItem!.bPFTherapistFileOffice)")
                                .foregroundStyle((self.pfTherapistFileItem!.bPFTherapistFileOffice) ? .red : .primary)

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Therapists' is Supervisor?")
                            Text("\(self.pfTherapistFileItem!.bPFTherapistFileIsSupervisor)")
                                .foregroundStyle((self.pfTherapistFileItem!.bPFTherapistFileIsSupervisor) ? .red : .primary)

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Therapists' has Assistant(s)?")
                            Text("\(self.pfTherapistFileItem!.bPFTherapistFileHaveAssistants)")
                                .foregroundStyle((self.pfTherapistFileItem!.bPFTherapistFileHaveAssistants) ? .red : .primary)

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Therapists' BADGE")
                            Text(verbatim:"\(self.pfTherapistFileItem!.iPFTherapistFileBadge)")
                                .foregroundStyle((self.pfTherapistFileItem!.iPFTherapistFileBadge == 86) ? .red : .primary)

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Therapists' TYPE")
                            Text(verbatim:"\(self.pfTherapistFileItem!.iPFTherapistFileType)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            VStack
                            {

                                Text("Therapists' Supervisor TID #")
                                Text("")    // ...vertical spacing...
                                Text("")    // ...vertical spacing...

                            }

                            HStack()
                            {

                                Text("\(sSupervisorTID) <\(sSupervisorName)>")
                                    .onAppear
                                    {

                                        self.sSupervisorTID  = "\(self.pfTherapistFileItem!.iPFTherapistFileSuperID)"
                                        self.sSupervisorName = self.locateAppTherapistNamebyTid(tidType:TIDType.supervisor, sTherapistTID:"\(self.pfTherapistFileItem!.iPFTherapistFileSuperID)")

                                    }

                                if (self.sSupervisorTID.count    > 0 &&
                                    (self.sSupervisorName.count  > 0 &&
                                     self.sSupervisorName       != "-N/A-"))
                                {

                                    Button
                                    {

                                        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtTherapist1DetailsView.Button(Xcode).'Supervisor Detail(s) by TID'...")

                                        self.isAppSupervisorDetailsByTIDShowing.toggle()

                                    }
                                    label:
                                    {

                                        VStack(alignment:.center)
                                        {

                                            Label("", systemImage: "doc.questionmark")
                                                .help(Text("Show Supervisor Detail(s) by TID..."))
                                                .imageScale(.medium)

                                            HStack(alignment:.center)
                                            {

                                                Spacer()

                                                Text("Supervisor Details...")
                                                    .font(.caption2)

                                                Spacer()

                                            }

                                        }

                                    }
                                #if os(macOS)
                                    .sheet(isPresented:$isAppSupervisorDetailsByTIDShowing, content:
                                    {

                                        AppVisitMgmtTherapist1DetailsView(sTherapistTID:$sSupervisorTID)

                                    })
                                #endif
                                #if os(iOS)
                                    .fullScreenCover(isPresented:$isAppSupervisorDetailsByTIDShowing)
                                    {

                                        AppVisitMgmtTherapist1DetailsView(sTherapistTID:$sSupervisorTID)

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
                                else
                                {

                                    Spacer()

                                }

                            }

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Therapists' Mentor TID #")

                            let sMentorTID:String  = "\(self.pfTherapistFileItem!.iPFTherapistFileMentorID)"
                            let sMentorName:String = (self.pfTherapistFileItem!.iPFTherapistFileMentorID == 9) ? "-unassigned-" : self.locateAppTherapistNamebyTid(tidType:TIDType.mentor, sTherapistTID:sMentorTID)

                            Text("\(sMentorTID) <\(sMentorName)>")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Therapists' iPad Update #")
                            Text(verbatim:"\(self.pfTherapistFileItem!.iPFTherapistFileIpadUpdate)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Therapists' iPhone Update #")
                            Text(verbatim:"\(self.pfTherapistFileItem!.iPFTherapistFileIphoneUpdate)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Therapists' LAST (Device) Sync")
                            Text("\(self.pfTherapistFileItem!.sPFTherapistFileLastSync)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Therapists' FINAL Sync")
                            Text("\(self.renderOptionalDateAsString(dateOptional:self.pfTherapistFileItem!.datePFTherapistFileFinalSync))")
                                .foregroundStyle((self.isOptionalDateOlderThanPrevSat(dateOptional:self.pfTherapistFileItem!.datePFTherapistFileFinalSync) == true) ? .red : .green)

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Therapists' 2nd FINAL Sync")
                            Text("\(self.renderOptionalDateAsString(dateOptional:self.pfTherapistFileItem!.datePFTherapistFileSecondFinalSync))")
                                .foregroundStyle((self.isOptionalDateOlderThanPrevSat(dateOptional:self.pfTherapistFileItem!.datePFTherapistFileSecondFinalSync) == true) ? .red : .green)

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Therapists' Start Week")
                            Text("\(self.pfTherapistFileItem!.sPFTherapistFileStartWeek)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Therapists' Start Invoice")
                            Text("\(self.pfTherapistFileItem!.sPFTherapistFileWeekStartInvoice)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Therapists' # of EXPECTED Week Visit(s)")
                            Text(verbatim:"\(self.pfTherapistFileItem!.iPFTherapistFileExpectedWeekVisits)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Therapists' # of LATE Week Visit(s)")
                            Text(verbatim:"\(self.pfTherapistFileItem!.iPFTherapistFileLateWeekVisits)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Therapists' # of Previous Week VOID(s)")
                            Text(verbatim:"\(self.pfTherapistFileItem!.iPFTherapistFilePreviousWeekVoids2)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Therapists' Makeups Allowed?")
                            Text("\(self.pfTherapistFileItem!.bPFTherapistFileMakeupsAllowed)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Therapists' Over 50 Allowed?")
                            Text("\(self.pfTherapistFileItem!.bPFTherapistFileOver50Allowed)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Therapists' Final Sync Ratios")
                            Text("\(self.pfTherapistFileItem!.listPFTherapistFileFinalSyncRatios)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Therapists' Week Patient(s) 'missing' visit(s)")
                            Text("\(self.pfTherapistFileItem!.listPFTherapistFileWeekPtMissingVisits)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Therapists' PID(s) for Friday")
                            Text("\(self.pfTherapistFileItem!.listPFTherapistFilePidsForFriday)")

                        }
                        .font(.caption2) 

                        GridRow(alignment:.bottom)
                        {

                            Text("Therapists' Parent ID(s)")
                            Text("\(self.pfTherapistFileItem!.listPFTherapistFileParentIDs)")

                        }
                        .font(.caption2) 

                        Divider() 

                    }

                }

            }
            else
            {

                Divider() 

                // Item Rows:

                GridRow(alignment:.bottom)
                {

                    Text("<<< NO Data >>>")
                    Text("Therapist TID #(\(self.sTherapistTID))")
                        .italic()

                }
                .font(.caption2) 

                Divider() 

            }

                Spacer()

            }

            Spacer()

        }
        .padding()
        
    }
    
//  private func getScheduledPatientLocationItemsForTid(sPFTherapistParseTID:String = "")->[ScheduledPatientLocationItem]
//  {
//
//      let sCurrMethod:String = #function
//      let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
//      
//      self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'sPFTherapistParseTID' is [\(sPFTherapistParseTID)]...")
//
//      // Use the TherapistName in the PFCscDataItem to lookup any ScheduledPatientLocationItem(s)...
//
//      var listScheduledPatientLocationItems:[ScheduledPatientLocationItem] = []
//      let jmAppParseCoreManager:JmAppParseCoreManager                      = JmAppParseCoreManager.ClassSingleton.appParseCodeManager
//
//      if (sPFTherapistParseTID.count > 0)
//      {
//
//          if (jmAppParseCoreManager.dictSchedPatientLocItems.count > 0)
//          {
//
//              listScheduledPatientLocationItems = jmAppParseCoreManager.dictSchedPatientLocItems[sPFTherapistParseTID] ?? []
//
//          }
//
//      }
//      
//      // Exit...
//
//      self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'listScheduledPatientLocationItems' is [\(listScheduledPatientLocationItems)]...")
//
//      return listScheduledPatientLocationItems
//
//  }   // End of private func getScheduledPatientLocationItemsForTid(sPFTherapistParseTID:String = "")->[ScheduledPatientLocationItem].

    private func locateAppTherapistNamebyTid(tidType:TIDType, sTherapistTID:String = "")->String
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'tidType' is [\(tidType)] - 'sTherapistTID' is [\(sTherapistTID)]...")

        // Locate the Therapist 'name' by TID...

        var sTherapistName:String = ""

        if (sTherapistTID.count > 0)
        {
        
            sTherapistName = self.jmAppParseCoreManager.convertTidToTherapistName(sPFTherapistParseTID:sTherapistTID)

            let iTherapistTID:Int = Int(sTherapistTID)!

            if (iTherapistTID >= 0)
            {

                if (tidType == TIDType.therapist)
                {
                
                    self.pfTherapistFileItem = self.jmAppParseCoreManager.dictPFTherapistFileItems[iTherapistTID]

                    self.xcgLogMsg("\(sCurrMethodDisp) Intermediate - 'self.pfTherapistFileItem' is [\(String(describing: self.pfTherapistFileItem))]...")
                
                }
                else
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) Intermediate - bypassing the setting of 'self.pfTherapistFileItem' - 'tidType' of [\(tidType)] is NOT TIDType.therapist...")

                }

            }
            else
            {
            
                self.xcgLogMsg("\(sCurrMethodDisp) Intermediate - bypassing the setting of 'self.pfTherapistFileItem' - 'iTherapistTID' of (\(iTherapistTID)) is less than Zero...")

            }

        }

        if (sTherapistName.count < 1)
        {
        
            sTherapistName = "-N/A-"
        
        }

        // Exit...

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'sTherapistTID' is [\(sTherapistTID)] - 'sTherapistName' is [\(sTherapistName)]...")
  
        return sTherapistName
  
    }   // End of private func locateAppTherapistNamebyTid(sTherapistTID:String)->String.

    private func formatPhoneNumber(sPhoneNumber:String = "")->String
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'sPhoneNumber' is [\(sPhoneNumber)]...")

        // Format the supplied Phone #...

        var sPhoneNumberFormatted:String = ""
        
        if (sPhoneNumber.count < 1)
        {
            
            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'sPhoneNumber' is [\(sPhoneNumber)] - 'sPhoneNumberFormatted' is [\(sPhoneNumberFormatted)]...")

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

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'sPhoneNumber' is [\(sPhoneNumber)] - 'sPhoneNumberFormatted' is [\(sPhoneNumberFormatted)]...")
  
        return sPhoneNumberFormatted
        
    }   // End of private func formatPhoneNumber(sPhoneNumber:String)->String

    private func renderOptionalDateAsString(dateOptional:Date? = nil)->String
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'dateOptional' is [\(String(describing: dateOptional))]...")

        // Convert and render the supplied 'optional' Date as a String...

        var sRenderedOptionalDate:String = "-invalid-"

        if (dateOptional != nil)
        {
        
            let dateFormatter:DateFormatter = DateFormatter()
            dateFormatter.dateFormat        = "yyyy-MM-dd"
        //  dateFormatter.dateFormat        = "yyyy-MM-dd HH:mm a zzz"
        //  dateFormatter.dateFormat        = "yyyy-MM-dd HH:mm:ss Z"

            sRenderedOptionalDate = dateFormatter.string(from:dateOptional!)
        
        }

        // Exit...

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'dateOptional' was [\(String(describing:dateOptional))] - 'sRenderedOptionalDate' is [\(sRenderedOptionalDate)]...")
  
        return sRenderedOptionalDate
        
    }   // End of private func renderOptionalDateAsString(dateOptional:Date?)->String.

    private func isOptionalDateOlderThanPrevSat(dateOptional:Date? = nil)->Bool
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'dateOptional' is [\(String(describing: dateOptional))]...")

        // Determine if the supplied 'optional' Date as older than the 'previous' Saturday...

        var bIsOptionalDateOlderThanPrevSat:Bool = true

        if (dateOptional != nil)
        {
        
            var dateOfPreviousSaturday:Date   = Date.now
            var dateOf2PreviousSaturdays:Date = Date.now
            var tiPrevSaturday:TimeInterval   = 0.0
            var tiPrev2Saturdays:TimeInterval = 0.0

            let _ = Calendar.current.nextWeekend(startingAfter:.now,
                                                 start:        &dateOfPreviousSaturday,
                                                 interval:     &tiPrevSaturday,
                                                 direction:    .backward)

            let _ = Calendar.current.nextWeekend(startingAfter:dateOfPreviousSaturday,
                                                 start:        &dateOf2PreviousSaturdays,
                                                 interval:     &tiPrev2Saturdays,
                                                 direction:    .backward)

            bIsOptionalDateOlderThanPrevSat = (dateOptional! < dateOf2PreviousSaturdays)
        //  bIsOptionalDateOlderThanPrevSat = (dateOptional! < dateOfPreviousSaturday)
        
        }

        // Exit...

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'dateOptional' was [\(String(describing:dateOptional))] - 'bIsOptionalDateOlderThanPrevSat' is [\(bIsOptionalDateOlderThanPrevSat)]...")
  
        return bIsOptionalDateOlderThanPrevSat
        
    }   // End of private func isOptionalDateOlderThanPrevSat(dateOptional:Date?)->String.

    private func syncPFDataItems()
    {
  
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // 'sync' (aka, deep copy) the ParseCoreBkgdDataRepo PFCscDataItem(s) to the ParseCoreManager...

        self.xcgLogMsg("\(sCurrMethodDisp) Invoking 'jmAppParseCoreBkgdDataRepo' 'deepCopyDictPFAdminsDataItems()'...")

        let _ = self.jmAppParseCoreBkgdDataRepo.deepCopyDictPFAdminsDataItems()

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked  'jmAppParseCoreBkgdDataRepo' 'deepCopyDictPFAdminsDataItems()'...")

        self.xcgLogMsg("\(sCurrMethodDisp) Invoking 'jmAppParseCoreBkgdDataRepo' 'deepCopyDictTherapistTidXref()'...")

        let _ = self.jmAppParseCoreBkgdDataRepo.deepCopyDictTherapistTidXref()

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked  'jmAppParseCoreBkgdDataRepo' 'deepCopyDictTherapistTidXref()'...")

        self.xcgLogMsg("\(sCurrMethodDisp) Invoking 'jmAppParseCoreBkgdDataRepo' 'deepCopyDictPFTherapistFileItems()'...")

        let _ = self.jmAppParseCoreBkgdDataRepo.deepCopyDictPFTherapistFileItems()

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked  'jmAppParseCoreBkgdDataRepo' 'deepCopyDictPFTherapistFileItems()'...")

        self.xcgLogMsg("\(sCurrMethodDisp) Invoking 'jmAppParseCoreBkgdDataRepo' 'deepCopyDictPatientPidXref()'...")

        let _ = self.jmAppParseCoreBkgdDataRepo.deepCopyDictPatientPidXref()

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked  'jmAppParseCoreBkgdDataRepo' 'deepCopyDictPatientPidXref()'...")

        self.xcgLogMsg("\(sCurrMethodDisp) Invoking 'jmAppParseCoreBkgdDataRepo' 'deepCopyDictPFPatientFileItems()'...")

        let _ = self.jmAppParseCoreBkgdDataRepo.deepCopyDictPFPatientFileItems()

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked  'jmAppParseCoreBkgdDataRepo' 'deepCopyDictPFPatientFileItems()'...")

        self.xcgLogMsg("\(sCurrMethodDisp) Invoking 'jmAppParseCoreBkgdDataRepo' 'deepCopyDictSchedPatientLocItems()'...")

        let _ = self.jmAppParseCoreBkgdDataRepo.deepCopyDictSchedPatientLocItems()

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked  'jmAppParseCoreBkgdDataRepo' 'deepCopyDictSchedPatientLocItems()'...")

        self.xcgLogMsg("\(sCurrMethodDisp) Invoking 'jmAppParseCoreBkgdDataRepo' 'deepCopyListPFCscDataItems()'...")

        let _ = self.jmAppParseCoreBkgdDataRepo.deepCopyListPFCscDataItems()

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked  'jmAppParseCoreBkgdDataRepo' 'deepCopyListPFCscDataItems()'...")

        self.xcgLogMsg("\(sCurrMethodDisp) Invoking 'jmAppParseCoreBkgdDataRepo' 'deepCopyListPFCscNameItems()'...")

        let _ = self.jmAppParseCoreBkgdDataRepo.deepCopyListPFCscNameItems()

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked  'jmAppParseCoreBkgdDataRepo' 'deepCopyListPFCscNameItems()'...")

    //  self.xcgLogMsg("\(sCurrMethodDisp) Invoking 'self.detailPFCscDataItems()'...")
    //
    //  self.detailPFCscDataItems()
    //
    //  self.xcgLogMsg("\(sCurrMethodDisp) Invoked 'self.detailPFCscDataItems()'...")

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return
  
    }   // End of private func syncPFDataItems().

}   // End of struct AppVisitMgmtTherapist1DetailsView(View).
