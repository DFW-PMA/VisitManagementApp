//
//  ProgressOverlay.swift
//  PMADataGatherer
//
//  Created by Daryl Cox on 05/01/2025 - v1.0202.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
import SwiftUI

// Reusable ProgressOverlay modifier and View extension...

struct ProgressOverlay:ViewModifier
{

    @Binding var isContentLoading:Bool
             var backgroundColor:Color
             var opacity:Double
    
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

        let _ = self.xcgLogMsg("<ContentLoading> ProgressOverlay:ViewModifier - 'isContentLoading' is [\(isContentLoading)] - launching the 'ZStack'...")

        ZStack 
        {

            content
                .disabled(isContentLoading)
                .blur(radius:((isContentLoading == true) ? 2 : 0))
            
            if (isContentLoading == true)
            {

                backgroundColor
                    .opacity(opacity)
                    .edgesIgnoringSafeArea(.all)
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint:.white))
                    .scaleEffect(0.75)

            }

        }
        .animation(.default, value:isContentLoading)

    }   // End of func body(content:Content)->some View.

}   // End of struct ProgressOverlay:ViewModifier.

extension View 
{

    func progressOverlay(isContentLoading:Binding<Bool>, backgroundColor:Color = .black, opacity:Double = 0.6)->some View 
    {

        modifier(ProgressOverlay(isContentLoading:isContentLoading, backgroundColor:backgroundColor, opacity:opacity))

    }   // End of func ProgressOverlay(isContentLoading:Binding<Bool>, backgroundColor:Color=.black, opacity:Double=0.6)->some View.

}   // End of extension View.

