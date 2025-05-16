//
//  AppAboutView.swift
//  VisitManagementApp
//
//  Created by Daryl Cox on 08/24/2024.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
import SwiftUI

@available(iOS 14.0, *)
struct AppAboutView: View 
{
    
    struct ClassInfo
    {
        
        static let sClsId        = "AppAboutView"
        static let sClsVers      = "v1.1203"
        static let sClsDisp      = sClsId+".("+sClsVers+"): "
        static let sClsCopyRight = "Copyright © JustMacApps 2023-2025. All rights reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }

    // App Data field(s):

//  @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode

#if os(macOS)
    private let pasteboard                                = NSPasteboard.general
#elseif os(iOS)
    private let pasteboard                                = UIPasteboard.general
#endif

            var appGlobalInfo:AppGlobalInfo               = AppGlobalInfo.ClassSingleton.appGlobalInfo
            var jmAppDelegateVisitor:JmAppDelegateVisitor = JmAppDelegateVisitor.ClassSingleton.appDelegateVisitor
    
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
        
        let _ = self.xcgLogMsg("...'AppAboutView(.swift):body' \(JmXcodeBuildSettings.jmAppVersionAndBuildNumber)...")

        VStack
        {

            HStack(alignment:.center)
            {

                Spacer()

                Button
                {

                    let _ = xcgLogMsg("\(ClassInfo.sClsDisp):AppAboutView.Button(Xcode).'Dismiss' pressed...")

                    self.presentationMode.wrappedValue.dismiss()

                //  dismiss()

                }
                label:
                {

                    VStack(alignment:.center)
                    {

                        Label("", systemImage:"xmark.circle")
                            .help(Text("Dismiss this Screen"))
                            .imageScale(.small)

                        Text("Dismiss")
                            .font(.caption2)

                    }

                }
            #if os(macOS)
                .buttonStyle(.borderedProminent)
            //  .background(???.isPressed ? .blue : .gray)
                .cornerRadius(10)
                .foregroundColor(Color.primary)
            #endif
                .padding()

            }

            if #available(iOS 17.0, *)
            {

                Image(ImageResource(name:"Gfx/AppIcon", bundle:Bundle.main))
                    .resizable()
                    .scaledToFit()
                    .containerRelativeFrame(.horizontal)
                        { size, axis in
                            size * 0.10
                        }

            }
            else
            {

                Image(ImageResource(name:"Gfx/AppIcon", bundle:Bundle.main))
                    .resizable()
                    .scaledToFit()
                    .frame(width:50, height:50, alignment:.center)

            }

            ScrollView
            {

                Text("")
                Text("Display Name: \(JmXcodeBuildSettings.jmAppDisplayName)")
                    .bold()
                Text("")
                Text("Application Category:")
                    .bold()
                    .italic()
                Text("\(JmXcodeBuildSettings.jmAppCategory)")
                Text("")
                Text("\(JmXcodeBuildSettings.jmAppVersionAndBuildNumber)")     // <=== Version...
                    .italic()

                Text("")
                Text("- - - - - - - - - - - - - - -")
                Text("Log file:")
                    .font(.caption2)
                Text(self.jmAppDelegateVisitor.sAppDelegateVisitorLogFilespec ?? "...empty...")
                    .font(.caption2)
                    .contextMenu
                    {
                        Button
                        {
                            let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp):AppAboutView in Text.contextMenu.'copy' button #1...")

                            copyLogFilespecToClipboard()
                        }
                        label:
                        {
                            Text("Copy to Clipboard")
                        }
                    }
                Text("Log file 'size' is: [\(self.getLogFilespecFileSizeDisplayableMB())]")
                    .font(.caption2)
                Text("")
                Text("UserDefaults file:")
                    .font(.caption2)
                Text("\(self.appGlobalInfo.sAppUserDefaultsFileLocation)")
                    .font(.caption2)
                    .contextMenu
                    {
                        Button
                        {
                            let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp):AppAboutView in Text.contextMenu.'copy' button #2...")

                            copyUserDefaultsFilespecToClipboard()
                        }
                        label:
                        {
                            Text("Copy to Clipboard")
                        }
                    }
                Text("- - - - - - - - - - - - - - -")
                Text("")

                Text("\(JmXcodeBuildSettings.jmAppCopyright)")
                    .italic()

            }

            Spacer()

        }
        
    }
    
    private func copyLogFilespecToClipboard()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
          
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - for text of [\(self.jmAppDelegateVisitor.sAppDelegateVisitorLogFilespec!)]...")
        
    #if os(macOS)
        pasteboard.prepareForNewContents()
        pasteboard.setString(self.jmAppDelegateVisitor.sAppDelegateVisitorLogFilespec!, forType:.string)
    #elseif os(iOS)
        pasteboard.string = self.jmAppDelegateVisitor.sAppDelegateVisitorLogFilespec!
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
    
    private func copyUserDefaultsFilespecToClipboard()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
          
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - for text of [\(self.appGlobalInfo.sAppUserDefaultsFileLocation)]...")
        
    #if os(macOS)
        pasteboard.prepareForNewContents()
        pasteboard.setString(self.appGlobalInfo.sAppUserDefaultsFileLocation, forType:.string)
    #elseif os(iOS)
        pasteboard.string = self.appGlobalInfo.sAppUserDefaultsFileLocation
    #endif

        // Exit...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
    
        return
        
    }   // End of private func copyUserDefaultsFilespecToClipboard().
    
}   // End of struct AppAboutView:View.

@available(iOS 14.0, *)
#Preview
{
    
    AppAboutView()
    
}

