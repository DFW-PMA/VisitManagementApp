//
//  ProgressOverlay.swift
//  VisitManagementApp
//
//  Created by Daryl Cox on 05/01/2025.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
import SwiftUI

// Reusable ProgressOverlay 'trigger' (Bool wrapper) class:

class ProgressOverlayTrigger:ObservableObject
{

    struct ClassInfo
    {
        
        static let sClsId        = "ProgressOverlayTrigger"
        static let sClsVers      = "v1.0212"
        static let sClsDisp      = sClsId+"(.swift).("+sClsVers+"):"
        static let sClsCopyRight = "Copyright (C) JustMacApps 2023-2025. All Rights Reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }
    
    // 'Internal' Trace flag:

    private 
    var bInternalTraceFlag:Bool             = false

    // App Data field(s):

    @Published var isProgressOverlayOn:Bool = false

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

    public func setProgressOverlay(isProgressOverlayOn:Bool = false)
    {
    
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'isProgressOverlayOn' is [\(isProgressOverlayOn)]...")
        
        // Set the 'self.isProgressOverlayOn' field to the supplied 'isProgressOverlayOn' field (accordingly)...
        
        if (self.isProgressOverlayOn != isProgressOverlayOn)
        {
            
            self.isProgressOverlayOn.toggle()
            
        }

        // If the field is 'on', delay for ###/1000th of a second to allow SwiftUI to render the new View...

        if (self.isProgressOverlayOn == true)
        {
            
            let iDelayTime:UInt32 = (100 * 1000)

            self.xcgLogMsg("\(sCurrMethodDisp) Intermediate - Delaying for 'iDelayTime' of (\(iDelayTime)) <1000th of a second> - 'self.isProgressOverlayOn' is [\(self.isProgressOverlayOn)]...")

            usleep(iDelayTime)
            
        }

        // Exit...
    
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'self.isProgressOverlayOn' is [\(self.isProgressOverlayOn)]...")
    
        return
    
    }   // End of public func setProgressOverlay(isProgressOverlayOn:Bool = false).

}   // End of class ProgressOverlayTrigger:ObservableObject.

// Reusable ProgressOverlayModifier and View extension...

struct ProgressOverlayModifier:ViewModifier
{

    struct ClassInfo
    {
        
        static let sClsId        = "ProgressOverlay"
        static let sClsVers      = "v1.0205"
        static let sClsDisp      = sClsId+"(.swift).("+sClsVers+"):"
        static let sClsCopyRight = "Copyright (C) JustMacApps 2023-2025. All Rights Reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }
    
    // App Data field(s):

    @ObservedObject var trigger:ProgressOverlayTrigger
//  @Binding var isContentLoading:Bool
//           var backgroundColor:Color
//           var opacity:Double
    
    public func xcgLogMsg(_ sMessage:String)
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

    }   // End of public func xcgLogMsg().

    func body(content:Content)->some View 
    {

        let _ = self.xcgLogMsg("<ContentLoading> ProgressOverlay:ViewModifier - 'self.trigger.isProgressOverlayOn' is [\(self.trigger.isProgressOverlayOn)] - launching the 'ZStack'...")

        ZStack 
        {

            content
                .disabled(self.trigger.isProgressOverlayOn)
            //  .blur(radius:((isProgressOverlayOn == true) ? 2 : 0))
                .opacity(trigger.isProgressOverlayOn ? 0.6 : 1.0)
                // Optional: dim the content when overlay is active...

        if (trigger.isProgressOverlayOn == true)
        {

            ZStack 
            {

                // Semi-transparent background...

                Color.black
                    .opacity(0.4)
                    .edgesIgnoringSafeArea(.all)

                // Progress indicator...

                VStack(spacing:16) 
                {

                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint:.white))
                        .scaleEffect(1.5)

                    Text("Loading...")
                        .foregroundColor(.white)
                        .font(.headline)

                }
                .padding(24)
                .background(RoundedRectangle(cornerRadius:12).fill(Color.gray.opacity(0.7)))

            }
            .transition(.opacity)
            .zIndex(100) // Ensure it's above all other content

        }
            
        //  if (self.trigger.isProgressOverlayOn == true)
        //  {
        //
        //      backgroundColor
        //          .opacity(opacity)
        //          .edgesIgnoringSafeArea(.all)
        //      
        //      ProgressView()
        //          .progressViewStyle(CircularProgressViewStyle(tint:.white))
        //          .scaleEffect(0.75)
        //
        //  }

        }
        .animation(.easeInOut(duration:0.2), value:self.trigger.isProgressOverlayOn)
    //  .animation(.default, value:self.trigger.isProgressOverlayOn)

    }   // End of func body(content:Content)->some View.

}   // End of struct ProgressOverlayModifier:ViewModifier.

extension View 
{

    func progressOverlay(trigger:ProgressOverlayTrigger)->some View 
    {

        self.modifier(ProgressOverlayModifier(trigger:trigger))

    }   // End of func progressOverlay(trigger:ProgressOverlayTrigger)->some View.

//  func progressOverlay(isContentLoading:Binding<Bool>, backgroundColor:Color = .black, opacity:Double = 0.6)->some View 
//  {
//
//      modifier(ProgressOverlay(isContentLoading:isContentLoading, backgroundColor:backgroundColor, opacity:opacity))
//
//  }   // End of func ProgressOverlay(isContentLoading:Binding<Bool>, backgroundColor:Color=.black, opacity:Double=0.6)->some View.

}   // End of extension View.

