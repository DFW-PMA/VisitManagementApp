//
//  LogFileView.swift
//  VisitManagementApp
//
//  Created by JustMacApps.net on 03/20/2024.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
import SwiftUI
import QuickLook

struct LogFileView: View 
{
    
    struct ClassInfo
    {
        
        static let sClsId          = "LogFileView"
        static let sClsVers        = "v1.1801"
        static let sClsDisp        = sClsId+".("+sClsVers+"): "
        static let sClsCopyRight   = "Copyright (C) JustMacApps 2023-2025. All Rights Reserved."
        static let bClsTrace       = true
        static let bClsFileLog     = true
        
    }

    // App Data field(s):

    @Environment(\.presentationMode) var presentationMode

    @State private var cLogFileViewAppLogClearButtonPresses:Int = 0

    @State private var isAppLogClearShowingAlert:Bool           = false
    
#if os(macOS)

    private let pasteboard = NSPasteboard.general

#elseif os(iOS)

    private let pasteboard = UIPasteboard.general

#endif

    @State  var logFileUrl:URL?
    
    var jmAppDelegateVisitor:JmAppDelegateVisitor               = JmAppDelegateVisitor.ClassSingleton.appDelegateVisitor
    
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
        
        VStack
        {

            HStack(alignment:.center)
            {

            #if os(macOS)

                Spacer()

            #endif

                Button
                {

                    self.logFileUrl = self.jmAppDelegateVisitor.urlAppDelegateVisitorLogFilespec

                    self.xcgLogMsg("\(ClassInfo.sClsDisp):LogFileView.Button('Preview Log file') performed for the URL of [\(String(describing: self.logFileUrl))]...")

                }
                label:
                {

                    VStack(alignment:.center)
                    {

                        Label("", systemImage: "text.viewfinder")
                            .help(Text("Preview the LOG file..."))
                            .imageScale(.medium)

                        Text("Preview LOG")
                            .font(.caption2)

                    }

                }
                .quickLookPreview($logFileUrl)
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

                    self.cLogFileViewAppLogClearButtonPresses += 1

                    let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):LogFileView.Button(Xcode).'App Log 'Clear'.#(\(self.cLogFileViewAppLogClearButtonPresses))'...")

                    self.jmAppDelegateVisitor.clearAppDelegateVisitorTraceLogFile()

                    self.isAppLogClearShowingAlert = true

                }
                label:
                {

                    VStack(alignment:.center)
                    {

                        Label("", systemImage: "clear")
                            .help(Text("Clear the LOG file..."))
                            .imageScale(.medium)

                        Text("Clear LOG")
                            .font(.caption2)

                    }

                }
                .alert("App Log has been 'Cleared'...", isPresented:$isAppLogClearShowingAlert)
                {

                    Button("Ok", role:.cancel) { }

                }
            #if os(macOS)
                .buttonStyle(.borderedProminent)
                .padding()
            //  .background(???.isPressed ? .blue : .gray)
                .cornerRadius(10)
                .foregroundColor(Color.primary)
            #endif

                Spacer()

            #if os(iOS)

                Button
                {

                    let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):LogFileView.Button(Xcode).'Dismiss' pressed...")

                    self.presentationMode.wrappedValue.dismiss()

                    //  dismiss()

                }
                label:
                {

                    VStack(alignment:.center)
                    {

                        Label("", systemImage: "xmark.circle")
                            .help(Text("Dismiss this Screen"))
                            .imageScale(.medium)

                        Text("Dismiss")
                            .font(.caption2)

                    }

                }
                .padding()

            #endif

            }

            Spacer()

            Text("Log file:")
                .font(.callout)
                .contextMenu
                {
                
                    Button
                    {
                        
                        let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp):LogFileView in Text.contextMenu.'copy' button #1...")
                        
                        copyLogFilespecToClipboard()
                        
                    }
                    label:
                    {
                        
                        Text("Copy to Clipboard")
                        
                    }
                
                }

            Text("")

            Text(self.jmAppDelegateVisitor.sAppDelegateVisitorLogFilespec ?? "...empty...")
                .contextMenu
                {
                
                    Button
                    {
                        
                        let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp):LogFileView in Text.contextMenu.'copy' button #2...")
                        
                        copyLogFilespecToClipboard()
                        
                    }
                    label:
                    {
                        
                        Text("Copy to Clipboard")
                        
                    }
                
                }

            Text("")

            Text("Log file 'size' is: [\(self.getLogFilespecFileSizeDisplayableMB())]")

            Spacer()

        }
        
    }
    
    private func copyLogFilespecToClipboard()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
          
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - for text of [\(jmAppDelegateVisitor.sAppDelegateVisitorLogFilespec!)]...")
        
    #if os(macOS)

        pasteboard.prepareForNewContents()
        pasteboard.setString(jmAppDelegateVisitor.sAppDelegateVisitorLogFilespec!, forType:.string)

    #elseif os(iOS)

        pasteboard.string = jmAppDelegateVisitor.sAppDelegateVisitorLogFilespec!

    #endif

        // Exit...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
    
        return
        
    }   // End of private func copyLogFilespecToClipboard().
    
    private func getLogFilespecFileSizeDisplayableMB()->String
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
          
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'sAppDelegateVisitorLogFilespec' is [\(jmAppDelegateVisitor.sAppDelegateVisitorLogFilespec!)]...")

        // Get the size of the LogFilespec in a displayable MB string...

        let sLogFilespecSizeInMB:String = JmFileIO.getFilespecSizeAsDisplayableMB(sFilespec:self.jmAppDelegateVisitor.sAppDelegateVisitorLogFilespec)

        // Exit...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'sLogFilespecSizeInMB' is [\(sLogFilespecSizeInMB)] for 'sAppDelegateVisitorLogFilespec' of [\(jmAppDelegateVisitor.sAppDelegateVisitorLogFilespec!)]...")
    
        return sLogFilespecSizeInMB
        
    }   // End of private func getLogFilespecFileSizeDisplayableMB()->String.
    
}   // End of struct LogFileView(View). 

#Preview 
{
    
    LogFileView()
    
}

