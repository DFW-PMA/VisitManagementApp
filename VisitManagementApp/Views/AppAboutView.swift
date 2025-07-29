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
struct AppAboutView:View
{
    
    struct ClassInfo
    {
        
        static let sClsId        = "AppAboutView"
        static let sClsVers      = "v1.2001"
        static let sClsDisp      = sClsId+".("+sClsVers+"): "
        static let sClsCopyRight = "Copyright © JustMacApps 2023-2025. All rights reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }

    // App Data field(s):

//  @Environment(\.dismiss)          var dismiss
    @Environment(\.presentationMode) var presentationMode

#if os(macOS)
            private let pasteboard                                = NSPasteboard.general
#elseif os(iOS)
            private let pasteboard                                = UIPasteboard.general
#endif

                    var appGlobalInfo:AppGlobalInfo               = AppGlobalInfo.ClassSingleton.appGlobalInfo
//  @ObservedObject var appSwiftDataManager:AppSwiftDataManager   = AppSwiftDataManager.appSwiftDataManager
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

    var body:some View 
    {
        
        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):body' \(JmXcodeBuildSettings.jmAppVersionAndBuildNumber)...")

        VStack
        {
        #if os(iOS)
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
            //  .padding()
                .padding(1.00)
            }
        #endif

            ZStack(alignment:.bottom)
            {
            //  ScrollView
            //  ScrollViewWithIndicators
                ScrollView
                {
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

                    Text("")
                    Text("Display Name: \(JmXcodeBuildSettings.jmAppDisplayName)")
                        .bold()
                    Text("")
                    Text("Application Category:")
                        .bold()
                        .italic()
                        .font(.footnote)
                    Text("\(JmXcodeBuildSettings.jmAppCategory)")
                        .font(.footnote)
                    Text("")
                        .font(.footnote)
                    Text("\(JmXcodeBuildSettings.jmAppVersionAndBuildNumber)")     // <=== Version...
                        .italic()
                        .font(.footnote)
                    Text("")
                        .font(.caption2)
                    Text("- - - - - - - - - - - - - - -")
                        .font(.caption2)
                    Text("Log file:")
                        .font(.caption2)
                    Text(self.jmAppDelegateVisitor.sAppDelegateVisitorLogFilespec ?? "...empty...")
                        .font(.caption2)
                        .contextMenu
                        {
                            Button
                            {
                                let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp):AppAboutView in Text.contextMenu.'copy' button #1...")

                                self.copyLogFilespecToClipboard()
                            }
                            label:
                            {
                                Text("Copy to Clipboard")
                            }
                        }
                    Text("Log file 'size' is: [\(self.getLogFilespecFileSizeDisplayableMB())]")
                        .font(.caption2)
                    Text("")
                        .font(.caption2)
                    Text("UserDefaults file:")
                        .font(.caption2)
                    Text("\(self.appGlobalInfo.sAppUserDefaultsFileLocation)")
                        .font(.caption2)
                        .contextMenu
                        {
                            Button
                            {
                                let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp):AppAboutView in Text.contextMenu.'copy' button #2...")

                                self.copyUserDefaultsFilespecToClipboard()
                            }
                            label:
                            {
                                Text("Copy to Clipboard")
                            }
                        }
                    Text("")
                        .font(.caption2)
                    Text("SwiftData file(s) location:")
                        .font(.caption2)
                    Text("\(self.getSwiftDataFilesLocation())")
                        .font(.caption2)
                        .contextMenu
                        {
                            Button
                            {
                                let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp):AppAboutView in Text.contextMenu.'copy' button #3...")

                                self.copySwiftDataFilesLocationToClipboard()
                            }
                            label:
                            {
                                Text("Copy to Clipboard")
                            }
                        }
                    Text("- - - - - - - - - - - - - - -")
                        .font(.caption2)
                    Text("")
                        .font(.caption2)

                    Text("\(JmXcodeBuildSettings.jmAppCopyright)")
                        .italic()
                        .font(.caption2)

        //  #if os(iOS)
        //      if (AppGlobalInfo.bEnableAppAdsPlaceholder == true ||
        //          AppGlobalInfo.bEnableAppAdsTesting     == true ||
        //          AppGlobalInfo.bEnableAppAdsProduction  == true)
        //      {
        //          Text("")            
        //              .hidden()
        //              .frame(minWidth: 1, idealWidth: 2, maxWidth: 3,
        //                     minHeight:1, idealHeight:2, maxHeight:3)
        //              .padding(.bottom, 100)
        //      }
        //  #endif
                }
            #if os(macOS)
                .frame(height:300)
            #elseif os(iOS)
                .frame(minHeight:200)
            #endif
            //  .scrollIndicators(.visible, axes:.vertical)

                Divider()

    //  #if os(iOS)
    //      if (AppGlobalInfo.bEnableAppAdsPlaceholder == true ||
    //          AppGlobalInfo.bEnableAppAdsTesting     == true ||
    //          AppGlobalInfo.bEnableAppAdsProduction  == true)
    //      {
    //          VStack
    //          {
    //          if (AppGlobalInfo.bEnableAppAdsTesting    == true ||
    //              AppGlobalInfo.bEnableAppAdsProduction == true)
    //          {
    //              let _ = print("ContentView.View: Invoking 'BannerContentView()'...")
    //
    //              BannerContentView(navigationTitle:"AdMobSwiftUIDemoApp2")
    //
    //              let _ = print("ContentView.View: Invoked  'BannerContentView()'...")
    //          }
    //          else
    //          {
    //              if (AppGlobalInfo.bEnableAppAdsPlaceholder == true)
    //              {
    //                  HStack
    //                  {
    //                  if #available(iOS 17.0, *)
    //                  {
    //                      GeometryReader 
    //                      { geometry in
    //
    //                          Image(ImageResource(name:"Gfx/Placeholder-for-Ads", bundle:Bundle.main))
    //                              .resizable()
    //                              .scaledToFit()
    //                              .frame(width:geometry.size.width)
    //                          //  .frame(width:geometry.size.width, height:50)
    //                          //  .containerRelativeFrame(.horizontal)
    //                          //      { size, axis in
    //                          //          size * 1.000
    //                          //      }
    //                      }
    //                  }
    //                  else
    //                  {
    //                      Image(ImageResource(name:"Gfx/Placeholder-for-Ads", bundle:Bundle.main))
    //                          .resizable()
    //                          .scaledToFit()
    //                          .frame(width:320, height:50, alignment:.center)
    //                  }
    //                  }
    //              }
    //          }
    //          }
    //          .frame(minHeight:75)
    //      }
    //  #endif

            }
            .frame(minHeight:75)

            Text("")            
                .hidden()
                .onAppear(
                    perform:
                    {
                        let _ = self.finishAppInitialization()
                    })
                .frame(minWidth: 1, idealWidth: 2, maxWidth: 3,
                       minHeight:1, idealHeight:2, maxHeight:3)
        }
        
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
    
    private func getSwiftDataFilesLocation()->String
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
          
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Get the location of the SwiftData file(s)...

        var sSwiftDataFilesLocation:String = "-unknown-"

        if (self.jmAppDelegateVisitor.jmAppSwiftDataManager != nil)
        {
            if (self.jmAppDelegateVisitor.jmAppSwiftDataManager?.modelContext != nil)
            {
                if let urlSwiftDataLocation = self.jmAppDelegateVisitor.jmAppSwiftDataManager?.modelContext!.container.configurations.first?.url 
                {
                    sSwiftDataFilesLocation = String(describing:urlSwiftDataLocation).stripOptionalStringWrapper()
                
                    self.xcgLogMsg("\(sCurrMethodDisp) <SwiftData Location> 📱 The SwiftData 'location' is [\(String(describing:urlSwiftDataLocation).stripOptionalStringWrapper())]...")
                    self.xcgLogMsg("\(sCurrMethodDisp) <SwiftData Location> 📱 The SwiftData 'self.jmAppDelegateVisitor.jmAppSwiftDataManager?.modelContext!.container.configurations' is [\(String(describing: self.jmAppDelegateVisitor.jmAppSwiftDataManager?.modelContext!.container.configurations))]...")
                }
            }
        }

    //  if (self.appSwiftDataManager.modelContext != nil)
    //  {
    //      if let urlSwiftDataLocation = self.appSwiftDataManager.modelContext!.container.configurations.first?.url 
    //      {
    //          sSwiftDataFilesLocation = String(describing:urlSwiftDataLocation).stripOptionalStringWrapper()
    //
    //          self.xcgLogMsg("\(sCurrMethodDisp) <SwiftData Location> 📱 The SwiftData 'location' is [\(String(describing:urlSwiftDataLocation).stripOptionalStringWrapper())]...")
    //          self.xcgLogMsg("\(sCurrMethodDisp) <SwiftData Location> 📱 The SwiftData 'self.appSwiftDataManager.modelContext.container.configurations' is [\(self.appSwiftDataManager.modelContext!.container.configurations)]...")
    //      }
    //  }

        // Exit...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'sSwiftDataFilesLocation' is [\(sSwiftDataFilesLocation)]...")
    
        return sSwiftDataFilesLocation
        
    }   // End of private func getSwiftDataFilesLocation()->String.
    
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
    
    private func copySwiftDataFilesLocationToClipboard()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        let sSwiftDataFilesLocation:String = self.getSwiftDataFilesLocation()
          
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - for text of [\(sSwiftDataFilesLocation)]...")
        
    #if os(macOS)
        pasteboard.prepareForNewContents()
        pasteboard.setString(sSwiftDataFilesLocation, forType:.string)
    #elseif os(iOS)
        pasteboard.string = sSwiftDataFilesLocation
    #endif

        // Exit...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
    
        return
        
    }   // End of private func copySwiftDataFilesLocationToClipboard().
    
}   // End of struct AppAboutView:View.

@available(iOS 14.0, *)
#Preview
{
    AppAboutView()
}

