//
//  AppDevDetailsItem.swift
//  VisitManagementApp
//
//  Created by Daryl Cox on 09/17/2024.
//  Copyright © DFW-PMA 2023-2025. All rights reserved.
//

import Foundation
import SwiftUI

struct AppDevDetailsItem: Identifiable
{

    struct ClassInfo
    {
        
        static let sClsId        = "AppDevDetailsItem"
        static let sClsVers      = "v1.0201"
        static let sClsDisp      = sClsId+"(.swift).("+sClsVers+"):"
        static let sClsCopyRight = "Copyright (C) DFW-PMA 2023-2025. All Rights Reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }

    // Item Data field(s):
    
    let id                             = UUID()

    var sAppDevDetailsItemName:String  = "-N/A-"
    var sAppDevDetailsItemDesc:String  = "-N/A-"
    var sAppDevDetailsItemValue:String = "-N/A-"
    var objAppDevDetailsItemValue:Any? = nil
    
}   // End of struct AppDevDetailsItem(Identifiable).

