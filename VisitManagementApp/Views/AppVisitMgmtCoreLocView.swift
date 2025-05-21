//
//  AppVisitMgmtCoreLocView.swift
//  VisitManagementApp
//
//  Created by JustMacApps.net on 05/16/2025.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

@available(iOS 16.0, *)
struct AppVisitMgmtCoreLocView:View 
{
    
    struct ClassInfo
    {
        
        static let sClsId        = "AppVisitMgmtCoreLocView"
        static let sClsVers      = "v1.0326"
        static let sClsDisp      = sClsId+".("+sClsVers+"): "
        static let sClsCopyRight = "Copyright (C) JustMacApps 2023-2025. All Rights Reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }
    
    // App Data field(s):
    
//  @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.openURL)          var openURL
    @Environment(\.openWindow)       var openWindow

#if os(macOS)
    private let pasteboard                                                 = NSPasteboard.general
#elseif os(iOS)
    private let pasteboard                                                 = UIPasteboard.general
#endif

    enum FocusedFields
    {
       case locationNil
       case locationLatitude
       case locationLongitude
       case locationAddress
    }
    
    @FocusState  private var focusedField:FocusedFields?

    @AppStorage("CoreLocLocationLatitude")
                 private var sLocationLatitude:String                      = ""
    @AppStorage("CoreLocLocationLongitude")
                 private var sLocationLongitude:String                     = ""
    @AppStorage("CoreLocLocationAddress")
                 private var sLocationAddress:String                       = ""

    @StateObject         var progressTriggerLatLong:ProgressOverlayTrigger = ProgressOverlayTrigger()
    @StateObject         var progressTriggerAddress:ProgressOverlayTrigger = ProgressOverlayTrigger()
    
                         var appGlobalInfo:AppGlobalInfo                   = AppGlobalInfo.ClassSingleton.appGlobalInfo
                         var jmAppDelegateVisitor:JmAppDelegateVisitor     = JmAppDelegateVisitor.ClassSingleton.appDelegateVisitor
    
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
        
    //  BLOCKED: Note - This would write a message into the log on EVERY refresh...
    //  let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):body(some View) \(JmXcodeBuildSettings.jmAppVersionAndBuildNumber)...")
        
        NavigationStack
        {

            VStack
            {

                HStack(alignment:.center)
                {

                    Spacer()

                    Button
                    {

                        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):AppVisitMgmtCoreLocView.Button(Xcode).'Dismiss' pressed...")

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

                Text("CoreLocation - Latitude/Longitude/Address Lookup")
                    .font(.footnote) 

                Divider()
                Divider()

                Text("")

                VStack
                {

                    HStack()
                    {

                        Text("=> Enter the Latitude: ")
                            .font(.caption) 
                            .contextMenu
                            {
                                Button
                                {
                                    let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp):AppVisitMgmtCoreLocView in Text.contextMenu.'copy' button #1...")

                                    copyLocationLatitudeToClipboard()
                                }
                                label:
                                {
                                    Text("Copy Latitude to Clipboard")
                                }
                            }
                            .foregroundColor(.red)

                        TextField("Latitude...", text:$sLocationLatitude)
                            .font(.caption) 
                        #if os(iOS)
                            .keyboardType(.numberPad)
                        #endif
                            .onAppear
                            {
                                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onAppear #1 - 'self.sLocationLatitude' is [\(self.sLocationLatitude)]...")

                                if (self.sLocationLatitude.count < 1)
                                {
                                    self.sLocationLongitude = ""
                                }

                                focusedField = .locationNil
                            }
                            .onChange(of:self.sLocationLongitude)
                            {
                                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onChange #1 - 'self.sLocationLongitude' is [\(self.sLocationLongitude)]...")
                            }
                            .onSubmit
                            {
                                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onSubmit #1 - 'self.sLocationLatitude'  is [\(self.sLocationLatitude)]...")
                                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onSubmit #1 - 'self.sLocationLongitude' is [\(self.sLocationLongitude)]...")
                        
                                focusedField = .locationLatitude
                            }
                            .onReceive(Just(sLocationLatitude))
                            { newValue in
                                let filteredValue  = newValue.filter { "-.0123456789".contains($0) }
                                if (filteredValue != newValue)
                                {
                                    self.sLocationLatitude = filteredValue
                                }
                            }
                            .focused($focusedField, equals:.locationLatitude)

                        Spacer()

                    }

                    HStack()
                    {

                        Spacer()

                        Text("   ")
                            .font(.caption2)

                        Spacer()

                        Button
                        {
                            let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp):AppVisitMgmtCoreLocView in Text.contextMenu.'copy' button #4...")

                            copyLocationLatitudeToClipboard()

                            focusedField = .locationNil
                        }
                        label:
                        {

                            VStack(alignment:.center)
                            {

                                Label("", systemImage: "list.clipboard")
                                    .help(Text("Copy Latitude to Clipboard..."))
                                    .imageScale(.small)

                                HStack(alignment:.center)
                                {

                                    Spacer()

                                    Text("Copy Latitude")
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
                    #if os(iOS)
                        .padding()
                    #endif

                        Spacer()

                        Button
                        {
                            let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp):AppVisitMgmtCoreLocView in Text.contextMenu.'paste' button #7...")

                            pasteLocationLatitudeFromClipboard()

                            focusedField = .locationNil
                        }
                        label:
                        {

                            VStack(alignment:.center)
                            {

                                Label("", systemImage: "list.clipboard")
                                    .help(Text("Paste Latitude from Clipboard..."))
                                    .imageScale(.small)

                                HStack(alignment:.center)
                                {

                                    Spacer()

                                    Text("Paste Latitude")
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
                    #if os(iOS)
                        .padding()
                    #endif

                        Spacer()

                        Button
                        {
                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtCoreLocView.Button(Xcode).'Latitude delete'...")

                            self.sLocationLatitude = ""
                            focusedField           = .locationNil
                        //  focusedField           = .locationLatitude
                        }
                        label:
                        {

                            VStack(alignment:.center)
                            {

                                Label("", systemImage: "delete.left")
                                    .help(Text("Delete the Latitude..."))
                                    .imageScale(.small)

                                HStack(alignment:.center)
                                {

                                    Spacer()

                                    Text("Delete Latitude")
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
                    #if os(iOS)
                        .padding()
                    #endif

                    }

                }

                VStack
                {

                    HStack()
                    {

                        Text("=> Enter the Longitude: ")
                            .font(.caption) 
                            .contextMenu
                            {
                                Button
                                {
                                    let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp):AppVisitMgmtCoreLocView in Text.contextMenu.'copy' button #2...")

                                    copyLocationLongitudeToClipboard()
                                }
                                label:
                                {
                                    Text("Copy Longitude to Clipboard")
                                }
                            }
                            .foregroundColor(.red)

                        TextField("Longitude...", text:$sLocationLongitude)
                            .font(.caption) 
                        #if os(iOS)
                            .keyboardType(.numberPad)
                        #endif
                            .onAppear
                            {
                                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onAppear #2 - 'self.sLocationLongitude' is [\(self.sLocationLongitude)]...")

                                if (self.sLocationLatitude.count < 1)
                                {
                                    self.sLocationLongitude = ""
                                }

                                focusedField = .locationNil
                            }
                            .onChange(of:self.sLocationLatitude)
                            {
                                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onChange #2 - 'self.sLocationLatitude' is [\(self.sLocationLatitude)]...")
                            }
                            .onSubmit
                            {
                                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onSubmit #2 - 'self.sLocationLatitude'  is [\(self.sLocationLatitude)]...")
                                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onSubmit #2 - 'self.sLocationLongitude' is [\(self.sLocationLongitude)]...")
                        
                                focusedField = .locationLongitude
                            }
                            .onReceive(Just(sLocationLongitude))
                            { newValue in
                                let filteredValue  = newValue.filter { "-.0123456789".contains($0) }
                                if (filteredValue != newValue)
                                {
                                    self.sLocationLongitude = filteredValue
                                }
                            }
                            .focused($focusedField, equals:.locationLongitude)

                        Spacer()

                    }

                    HStack()
                    {

                        Spacer()

                        Text("   ")
                            .font(.caption2)

                        Spacer()

                        Button
                        {
                            let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp):AppVisitMgmtCoreLocView in Text.contextMenu.'copy' button #5...")

                            copyLocationLongitudeToClipboard()

                            focusedField = .locationNil
                        }
                        label:
                        {

                            VStack(alignment:.center)
                            {

                                Label("", systemImage: "list.clipboard")
                                    .help(Text("Copy Longitude to Clipboard..."))
                                    .imageScale(.small)

                                HStack(alignment:.center)
                                {

                                    Spacer()

                                    Text("Copy Longitude")
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
                    #if os(iOS)
                        .padding()
                    #endif

                        Spacer()

                        Button
                        {
                            let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp):AppVisitMgmtCoreLocView in Text.contextMenu.'paste' button #8...")

                            pasteLocationLongitudeFromClipboard()

                            focusedField = .locationNil
                        }
                        label:
                        {

                            VStack(alignment:.center)
                            {

                                Label("", systemImage: "list.clipboard")
                                    .help(Text("Paste Longitude from Clipboard..."))
                                    .imageScale(.small)

                                HStack(alignment:.center)
                                {

                                    Spacer()

                                    Text("Paste Longitude")
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
                    #if os(iOS)
                        .padding()
                    #endif

                        Spacer()

                        Button
                        {
                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtCoreLocView.Button(Xcode).'Longitude delete'...")

                            self.sLocationLongitude = ""
                            focusedField            = .locationNil
                        //  focusedField            = .locationLongitude
                        }
                        label:
                        {

                            VStack(alignment:.center)
                            {

                                Label("", systemImage: "delete.left")
                                    .help(Text("Delete the Longitude..."))
                                    .imageScale(.small)

                                HStack(alignment:.center)
                                {

                                    Spacer()

                                    Text("Delete Longitude")
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
                    #if os(iOS)
                        .padding()
                    #endif

                    }

                }

                Divider()

                VStack
                {

                    HStack
                    {

                        Text("=> Located Address: ")
                            .font(.caption) 
                            .contextMenu
                            {
                                Button
                                {
                                    let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp):AppVisitMgmtCoreLocView in Text.contextMenu.'copy' button #3...")

                                    copyLocationAddressToClipboard()
                                }
                                label:
                                {
                                    Text("Copy Address to Clipboard")
                                }
                            }
                            .foregroundColor(.red)

                        TextField("Address...", text:$sLocationAddress)
                            .lineLimit(2)
                            .font(.caption) 
                            .onAppear
                            {
                                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onAppear #3 - 'self.sLocationAddress' is [\(self.sLocationAddress)]...")

                                if (self.sLocationAddress.count < 1)
                                {
                                    self.sLocationAddress = ""
                                }

                                focusedField = .locationNil
                            }
                            .onChange(of:self.sLocationAddress)
                            {
                                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onChange #3 - 'self.sLocationAddress' is [\(self.sLocationAddress)]...")
                            }
                            .onSubmit
                            {
                                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onSubmit #3 - 'self.sLocationAddress'  is [\(self.sLocationAddress)]...")
                        
                                focusedField = .locationAddress
                            }
                            .focused($focusedField, equals:.locationAddress)
                        //  .frame(maxWidth:600)

                        Spacer()

                    }
                    
                    VStack(alignment:.trailing)
                    {
                        
                        HStack(spacing:1)
                        {

                            Spacer()
                            
                            Text("   ")
                                .font(.caption2)

                            Spacer()

                            Button
                            {
                                let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp):AppVisitMgmtCoreLocView in Text.contextMenu.'copy' button #6...")

                                copyLocationAddressToClipboard()

                                focusedField = .locationNil
                            }
                            label:
                            {

                                VStack(alignment:.center)
                                {

                                    Label("", systemImage: "list.clipboard")
                                        .help(Text("Copy Address to Clipboard..."))
                                        .imageScale(.small)

                                    HStack(alignment:.center)
                                    {

                                        Spacer()

                                        Text("Copy Address")
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
                        #if os(iOS)
                            .padding()
                        #endif

                        //  Spacer()

                            Button
                            {
                                let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp):AppVisitMgmtCoreLocView in Text.contextMenu.'paste' button #9...")

                                pasteLocationAddressFromClipboard()

                                focusedField = .locationNil
                            }
                            label:
                            {

                                VStack(alignment:.center)
                                {

                                    Label("", systemImage: "list.clipboard")
                                        .help(Text("Paste Address from Clipboard..."))
                                        .imageScale(.small)

                                    HStack(alignment:.center)
                                    {

                                        Spacer()

                                        Text("Paste Address")
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
                        #if os(iOS)
                            .padding()
                        #endif

                        //  Spacer()

                            Button
                            {
                                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtCoreLocView.Button(Xcode).'Address delete'...")

                                self.sLocationAddress = ""
                                focusedField          = .locationNil
                            //  focusedField          = .locationAddress
                            }
                            label:
                            {

                                VStack(alignment:.center)
                                {

                                    Label("", systemImage: "delete.left")
                                        .help(Text("Delete the Address..."))
                                        .imageScale(.small)

                                    HStack(alignment:.center)
                                    {

                                        Spacer()

                                        Text("Delete Address")
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
                        #if os(iOS)
                            .padding()
                        #endif

                        }
                        
                    }

                }

                VStack
                {

                    Divider()
                    Divider()

                    HStack
                    {

                        Spacer()

                        Button
                        {

                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtCoreLocView.Button(Xcode).'Locate an Address by Latitude/Longitude'...")

                            self.progressTriggerLatLong.setProgressOverlay(isProgressOverlayOn:true)

                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtCoreLocView.Button(Xcode).'Locate an Address by Latitude/Longitude' - 'self.progressTriggerLatLong.isProgressOverlayOn' is [\(self.progressTriggerLatLong.isProgressOverlayOn)] <should be 'true'>...")

                            DispatchQueue.main.asyncAfter(deadline:(.now() + 0.25)) 
                            {

                                self.sLocationAddress = self.locateAddressByLatitudeLongitude()
                                focusedField          = .locationNil
                            //  focusedField          = .locationAddress

                                self.progressTriggerLatLong.setProgressOverlay(isProgressOverlayOn:false)

                                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtCoreLocView.Button(Xcode).'Locate an Address by Latitude/Longitude' - 'self.progressTriggerLatLong.isProgressOverlayOn' is [\(self.progressTriggerLatLong.isProgressOverlayOn)] <should be 'false'>...")

                            }

                        }
                        label:
                        {

                            VStack(alignment:.center)
                            {

                            //  Label("", systemImage: "figure.run.circle")
                                Label("", systemImage: "pencil.tip.crop.circle.badge.plus")
                                    .help(Text("Locate an Address by Latitude/Longitude..."))
                                    .imageScale(.small)

                                Text("Locate Address")
                                    .bold()
                                    .font(.caption2)

                            }
                            .progressOverlay(trigger:self.progressTriggerLatLong)

                        }
                    #if os(macOS)
                        .buttonStyle(.borderedProminent)
                        .padding()
                    //  .background(???.isPressed ? .blue : .gray)
                        .cornerRadius(10)
                        .foregroundColor(Color.primary)
                    #endif
                        .padding()

                        Spacer()

                        Button
                        {

                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtCoreLocView.Button(Xcode).'Locate Latitude/Longitude by Address'...")

                            self.progressTriggerAddress.setProgressOverlay(isProgressOverlayOn:true)

                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtCoreLocView.Button(Xcode).'Locate Latitude/Longitude by Address' - 'self.progressTriggerAddress.isProgressOverlayOn' is [\(self.progressTriggerAddress.isProgressOverlayOn)] <should be 'true'>...")

                            DispatchQueue.main.asyncAfter(deadline:(.now() + 0.25)) 
                            {

                                (self.sLocationLatitude, self.sLocationLongitude) = self.locateLatitudeLongitudeByAddress()
                                focusedField                                      = .locationNil
                            //  focusedField                                      = .locationLatitude

                                self.progressTriggerAddress.setProgressOverlay(isProgressOverlayOn:false)

                                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp)AppVisitMgmtCoreLocView.Button(Xcode).'Locate Latitude/Longitude by Address' - 'self.progressTriggerAddress.isProgressOverlayOn' is [\(self.progressTriggerAddress.isProgressOverlayOn)] <should be 'false'>...")

                            }

                        }
                        label:
                        {

                            VStack(alignment:.center)
                            {

                                Label("", systemImage: "pencil.tip.crop.circle.badge.arrow.forward")
                                    .help(Text("Locate Latitude/Longitude by Address..."))
                                    .imageScale(.small)

                                Text("Locate Lat/Long")
                                    .bold()
                                    .font(.caption2)

                            }
                            .progressOverlay(trigger:self.progressTriggerAddress)

                        }
                    #if os(macOS)
                        .buttonStyle(.borderedProminent)
                        .padding()
                    //  .background(???.isPressed ? .blue : .gray)
                        .cornerRadius(10)
                        .foregroundColor(Color.primary)
                    #endif
                        .padding()

                        Spacer()

                    }

                    Divider()
                    Divider()

                }

                Spacer()

            }

            Text("")            
                .hidden()
                .font(.caption2)
                .onAppear(
                    perform:
                    {
                        // Finish App 'initialization'...

                        let _ = self.finishAppInitialization()
                    })

            Spacer()

        }
        .padding()
        
    }
    
    private func finishAppInitialization()
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Finish the App 'initialization'...
  
        self.xcgLogMsg("\(ClassInfo.sClsDisp) Invoking the 'jmAppDelegateVisitor.checkAppDelegateVisitorTraceLogFileForSize()'...")

        self.jmAppDelegateVisitor.checkAppDelegateVisitorTraceLogFileForSize()

        self.xcgLogMsg("\(ClassInfo.sClsDisp) Invoked  the 'jmAppDelegateVisitor.checkAppDelegateVisitorTraceLogFileForSize()'...")

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return

    } // End of private func finishAppInitialization().
    
    private func locateAddressByLatitudeLongitude()->String
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameters are 'self.sLocationLatitude' is (\(self.sLocationLatitude)) - 'self.sLocationLongitude' is (\(self.sLocationLongitude))...")

        // Locate an Address from the Latitude/Longitude coordinates...

        let sLocatedAddress:String = "-N/A-"

        if (self.sLocationLatitude.count  < 1 ||
            self.sLocationLongitude.count < 1)
        {
        
            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - latitude and/or longitude were NOT provided - 'sLocatedAddress' is [\(sLocatedAddress)]...")

            return sLocatedAddress

        }

        // Use the Latitude/Longitude values to resolve address...

        if (self.jmAppDelegateVisitor.jmAppCLModelObservable2 != nil)
        {

            let clModelObservable2:CoreLocationModelObservable2 = self.jmAppDelegateVisitor.jmAppCLModelObservable2!
            let iRequestID:Int                                  = 1
            let dblLocationLatitude:Double                      = Double(self.sLocationLatitude)  ?? 0.0000
            let dblLocationLongitude:Double                     = Double(self.sLocationLongitude) ?? 0.0000

            DispatchQueue.main.async
            {
                self.xcgLogMsg("\(sCurrMethodDisp) <closure> Calling 'updateGeocoderLocation()' for Latitude/Longitude of [\(dblLocationLatitude)/\(dblLocationLongitude)]...")

                let _ = clModelObservable2.updateGeocoderLocations(requestID:iRequestID, 
                                                                   latitude: dblLocationLatitude, 
                                                                   longitude:dblLocationLongitude, 
                                                                   withCompletionHandler:
                                                                       { (requestID:Int, dictCurrentLocation:[String:Any]) in
                                                                           self.handleLocationAndAddressClosureEvent(bIsDownstreamObject:false, requestID:requestID, dictCurrentLocation:dictCurrentLocation)
                                                                       }
                                                                  )
            }

        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) CoreLocation (service) is NOT available...")

        }

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'sLocatedAddress' is [\(sLocatedAddress)]...")
  
        return sLocatedAddress

    } // End of private func locateAddressByLatitudeLongitude()->String.
    
    private func locateLatitudeLongitudeByAddress()->(String,String)
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter is 'self.sLocationAddress' is [\(self.sLocationAddress)]...")

        // Locate the Latitude/Longitude coordinates from an Address...

        let sLocatedLatitude:String  = "0.0000"
        let sLocatedLongitude:String = "0.0000"

        if (self.sLocationAddress.count < 1)
        {
        
            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - address was NOT provided - 'sLocatedLatitude' is [\(sLocatedLatitude)] - 'sLocatedLongitude' is [\(sLocatedLongitude)]...")

            return (sLocatedLatitude, sLocatedLongitude)

        }

        // Use the Latitude/Longitude values to resolve address...

        if (self.jmAppDelegateVisitor.jmAppCLModelObservable2 != nil)
        {

            let clModelObservable2:CoreLocationModelObservable2 = self.jmAppDelegateVisitor.jmAppCLModelObservable2!
            let iRequestID:Int                                  = 1

            DispatchQueue.main.async
            {
                self.xcgLogMsg("\(sCurrMethodDisp) <closure> Calling 'updateGeocoderFromAddress()' for an Address of [\(self.sLocationAddress)]...")

                let _ = clModelObservable2.updateGeocoderFromAddress(requestID:iRequestID, 
                                                                     address:  self.sLocationAddress,
                                                                     withCompletionHandler:
                                                                         { (requestID:Int, dictCurrentLocation:[String:Any]) in
                                                                             self.handleLocationAndAddressClosureEvent(bIsDownstreamObject:false, requestID:requestID, dictCurrentLocation:dictCurrentLocation)
                                                                         }
                                                                    )
            }

        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) CoreLocation (service) is NOT available...")

        }

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'sLocatedLatitude' is (\(sLocatedLatitude)) - 'sLocatedLongitude' is (\(sLocatedLongitude))...")
  
        return (sLocatedLatitude, sLocatedLongitude)

    } // End of private func locateLatitudeLongitudeByAddress()->(String,String).
    
    public func handleLocationAndAddressClosureEvent(bIsDownstreamObject:Bool = false, requestID:Int, dictCurrentLocation:[String:Any])
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'bIsDownstreamObject' is [\(bIsDownstreamObject)] - 'requestID' is [\(requestID)] - 'dictCurrentLocation' is [\(String(describing: dictCurrentLocation))]...")

        // Update the address info...

        if (dictCurrentLocation.count > 0)
        {
        
            self.xcgLogMsg("\(sCurrMethodDisp) #(\(requestID)): <closure> Called  'updateGeocoderLocation()' a 'location' of [\(String(describing: dictCurrentLocation))]...")

            self.sLocationLatitude  = String(describing: (dictCurrentLocation["dblLatitude"]             ?? "0.000000"))
            self.sLocationLongitude = String(describing: (dictCurrentLocation["dblLongitude"]            ?? "0.000000"))
            self.sLocationAddress   = String(describing: (dictCurrentLocation["sCurrentLocationAddress"] ?? "-N/A-"))

            self.xcgLogMsg("\(sCurrMethodDisp) Updated - 'self.sLocationLatitude' is [\(self.sLocationLatitude)] - 'self.sLocationLongitude' is [\(self.sLocationLongitude)] - 'self.sLocationAddress' is [\(self.sLocationAddress)] ...")
        
        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) #(\(requestID)): Dictionary 'dictCurrentLocation' is 'empty' - bypassing update - Warning!")

        }

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of public func handleLocationAndAddressClosureEvent(bIsDownstreamObject:Bool, requestID:Int, dictCurrentLocation:[String:Any]).

    private func copyLocationLatitudeToClipboard()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
          
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - for text 'self.sLocationLatitude' of [\(self.sLocationLatitude)]...")

        if (self.sLocationLatitude.count < 1)
        {
        
            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return
        
        }
        
    #if os(macOS)
        pasteboard.prepareForNewContents()
        pasteboard.setString(self.sLocationLatitude, forType:.string)
    #elseif os(iOS)
        pasteboard.string = self.sLocationLatitude
    #endif

        // Exit...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
    
        return
        
    }   // End of private func copyLocationLatitudeToClipboard().
    
    private func copyLocationLongitudeToClipboard()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
          
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - for text 'self.sLocationLongitude' of [\(self.sLocationLongitude)]...")

        if (self.sLocationLongitude.count < 1)
        {
        
            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return
        
        }
        
    #if os(macOS)
        pasteboard.prepareForNewContents()
        pasteboard.setString(self.sLocationLongitude, forType:.string)
    #elseif os(iOS)
        pasteboard.string = self.sLocationLongitude
    #endif

        // Exit...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
    
        return
        
    }   // End of private func copyLocationLongitudeToClipboard().
    
    private func copyLocationAddressToClipboard()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
          
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - for text 'self.sLocationAddress' of [\(self.sLocationAddress)]...")

        if (self.sLocationAddress.count < 1)
        {
        
            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return
        
        }
        
    #if os(macOS)
        pasteboard.prepareForNewContents()
        pasteboard.setString(self.sLocationAddress, forType:.string)
    #elseif os(iOS)
        pasteboard.string = self.sLocationAddress
    #endif

        // Exit...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
    
        return
        
    }   // End of private func copyLocationAddressToClipboard().
    
    private func pasteLocationLatitudeFromClipboard()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
          
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked ...")

        var sPasteboardText:String = ""

        #if os(macOS)
            sPasteboardText = pasteboard.string(forType: .string) ?? ""
        #elseif os(iOS)
            sPasteboardText = pasteboard.string ?? ""
        #endif

        if (sPasteboardText.count < 1)
        {
        
            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return
        
        }

        self.sLocationLatitude = sPasteboardText
        
        // Exit...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting- for text 'self.sLocationLatitude' of [\(self.sLocationLatitude)]...")
    
        return
        
    }   // End of private func pasteLocationLatitudeFromClipboard().
    
    private func pasteLocationLongitudeFromClipboard()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
          
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        var sPasteboardText:String = ""

        #if os(macOS)
            sPasteboardText = pasteboard.string(forType: .string) ?? ""
        #elseif os(iOS)
            sPasteboardText = pasteboard.string ?? ""
        #endif

        if (sPasteboardText.count < 1)
        {
        
            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return
        
        }

        self.sLocationLongitude = sPasteboardText

        // Exit...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'self.sLocationLongitude' of [\(self.sLocationLongitude)]...")
    
        return
        
    }   // End of private func pasteLocationLongitudeFromClipboard().
    
    private func pasteLocationAddressFromClipboard()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
          
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        var sPasteboardText:String = ""

        #if os(macOS)
            sPasteboardText = pasteboard.string(forType: .string) ?? ""
        #elseif os(iOS)
            sPasteboardText = pasteboard.string ?? ""
        #endif

        if (sPasteboardText.count < 1)
        {
        
            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return
        
        }

        self.sLocationAddress = sPasteboardText

        // Exit...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'self.sLocationAddress' of [\(self.sLocationAddress)]...")
    
        return
        
    }   // End of private func pasteLocationAddressFromClipboard().
    
}   // End of struct AppVisitMgmtCoreLocView:View. 

#Preview 
{
    
    AppVisitMgmtCoreLocView()
    
}

