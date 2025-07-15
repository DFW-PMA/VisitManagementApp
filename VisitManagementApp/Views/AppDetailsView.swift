//
//  AppDetailsView.swift
//  VisitVerify
//
//  Created by Daryl Cox on 09/16/2024.
//  Copyright © DFW-PMA 2024-2025. All rights reserved.
//

import Foundation
import SwiftUI

@available(iOS 16.0, *)
struct AppDetailsView:View
{
    
    struct ClassInfo
    {
        
        static let sClsId        = "AppDetailsView"
        static let sClsVers      = "v1.1004"
        static let sClsDisp      = sClsId+".("+sClsVers+"): "
        static let sClsCopyRight = "Copyright © DFW-PMA 2024-2025. All rights reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }

    // App Data field(s):

//  @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode

//         private  var updateNumber:Double                       = UPDATE_NUMBER
//         private  var vmaNameAndNumber:String                   = "VMA #"+String(format:"%.3f", UPDATE_NUMBER)
           private  var vmaNameAndNumber:String                   = "VMA \(JmXcodeBuildSettings.jmAppVersionAndBuildNumber)"

           private  var bAppDevIsTesting:Bool                     = false

    @ObservedObject var appDevDetailsModelObservable:AppDevDetailsModelObservable
                                                                  = AppDevDetailsModelObservable.ClassSingleton.appDevDetailsModelObservable

//  @AppStorage("VisitManagementApp.LastLoginBlockedFromFaceId")
//              private var bIsUserBlockedFromFaceId:Bool         = false
//  @AppStorage("VisitManagementApp.LastLoginUsername")
//              private var sLoginUsername:String                 = ""
//  @AppStorage("VisitManagementApp.LastLoginPassword")
//              private var sLoginPassword:String                 = ""
//  @AppStorage("VisitManagementApp.LastLoginEmail")
//              private var sLoginEmail:String                    = ""

#if os(macOS)
           private let pasteboard                                 = NSPasteboard.general
#elseif os(iOS)
           private let pasteboard                                 = UIPasteboard.general
#endif

                    var appGlobalInfo:AppGlobalInfo               = AppGlobalInfo.ClassSingleton.appGlobalInfo
                    var jmAppDelegateVisitor:JmAppDelegateVisitor = JmAppDelegateVisitor.ClassSingleton.appDelegateVisitor

    init()
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

    //  super.init()
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Get all the 'internal' Dev Detail(s)...

        self.bAppDevIsTesting = checkIfAppDevIsTesting()

    //  self.appDevDetailsModelObservable.setAppDevDetailsItems(bIsUserBlockedFromFaceId:self.bIsUserBlockedFromFaceId, 
    //                                                          sLoginUsername:self.sLoginUsername, 
    //                                                          sLoginPassword:self.sLoginPassword,
    //                                                          sLoginEmail:sLoginEmail)

        self.appDevDetailsModelObservable.updateAppDevDetailsItemList()

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
        
        let _ = self.xcgLogMsg("...'AppDetailsView(.swift):body' \(JmXcodeBuildSettings.jmAppVersionAndBuildNumber)...")

        VStack
        {

            HStack(alignment:.center)
            {

                Spacer()

                Button
                {

                    let _ = xcgLogMsg("\(ClassInfo.sClsDisp):AppDetailsView.Button(Xcode).'Dismiss' pressed...")

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
                .padding()

            }

            if #available(iOS 17.0, *)
            {

            //  Image(ImageResource(name:"Gfx/Splash_iPad", bundle:Bundle.main))
                Image(ImageResource(name:"Gfx/AppIcon", bundle:Bundle.main))
                    .resizable()
                    .scaledToFit()
                    .containerRelativeFrame(.horizontal)
                        { size, axis in
                            size * 0.15
                        }

            }
            else
            {

            //  Image(ImageResource(name:"Gfx/Splash_iPad", bundle:Bundle.main))
                Image(ImageResource(name:"Gfx/AppIcon", bundle:Bundle.main))
                    .resizable()
                    .scaledToFit()
                    .frame(width:75, height:75, alignment:.center)

            }

            Text("")
            Text("--- 'internal' Dev Detail(s) ---")
                .italic()
            Text("\(vmaNameAndNumber)")
                .bold()

            ScrollView
            {

                Text("")
                Text("---")
                Text("")

                Text("Display Name: \(JmXcodeBuildSettings.jmAppDisplayName)")
                    .bold()
                Text("Application Category:")
                    .bold()
                    .italic()
                Text("\(JmXcodeBuildSettings.jmAppCategory)")
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
                Text("---")
                Text("")

                Grid(alignment:.leadingFirstTextBaseline, horizontalSpacing:5, verticalSpacing: 3)
                {

                    // Column Headings:

                    Divider() 

                    GridRow 
                    {

                        Text("Item Name")
                        Text("Item Description")
                        Text("Item Value")

                    }
                    .font(.title2) 

                    Divider() 

                    // Item Rows:

                    ForEach(appDevDetailsModelObservable.listAppDevDetailsItems) 
                    { appDevDetailsItem in

                        GridRow(alignment:.bottom)
                        {

                            Text(appDevDetailsItem.sAppDevDetailsItemName)
                                .bold()
                            Text(appDevDetailsItem.sAppDevDetailsItemDesc)
                            //  .gridColumnAlignment(.center)
                            Text(appDevDetailsItem.sAppDevDetailsItemValue)

                        }

                    }

                }

            }

            Spacer()

        }
        .padding()
        
    }

    func checkIfAppDevIsTesting() -> Bool
    {
  
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        let bIsAppDevTesting:Bool = AppGlobalInfo.bPerformAppDevTesting
  
    //  let appDelegate:AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    //
    //  if (appDelegate == nil) 
    //  {
    //
    //      self.xcgLogMsg("\(sCurrMethodDisp) 'UIApplication.shared.delegate' is [\(String(describing: UIApplication.shared.delegate))] - Error!")
    //      self.xcgLogMsg("\(sCurrMethodDisp) exiting...")
    //
    //      return false
    //
    //  }
    //
    //  self.xcgLogMsg("\(sCurrMethodDisp) 'UIApplication.shared.delegate' is [\(String(describing: UIApplication.shared.delegate))]...")
    //
    //  let objcVVObjCSwiftEnvBridge = appDelegate?.getVVObjCSwiftEnvBridge()
    //
    //  if (objcVVObjCSwiftEnvBridge == nil) 
    //  {
    //
    //      let sErrorMsg:String = "\(sCurrMethodDisp) 'appDelegate._objVVObjCSwiftEnvBridge' is [\(String(describing: objcVVObjCSwiftEnvBridge))] - Fatal Error!"
    //
    //      self.xcgLogMsg(sErrorMsg)
    //      self.xcgLogMsg("\(sCurrMethodDisp) exiting...")
    //
    //      return false
    //
    //  }
    //
    //  self.xcgLogMsg("\(sCurrMethodDisp) 'appDelegate._objVVObjCSwiftEnvBridge' is [\(String(describing: objcVVObjCSwiftEnvBridge))]...")
    //
    //  let bIsAppDevTesting:Bool = (objcVVObjCSwiftEnvBridge?.getAppDevIsTesting())!
        
        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'bIsAppDevTesting' is [\(String(describing: bIsAppDevTesting))]...")
  
        return bIsAppDevTesting
  
    }   // End of checkIfAppDevIsTesting().

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
    
}   // End of struct AppDetailsView:View.

@available(iOS 16.0, *)
#Preview
{
    AppDetailsView()
}

