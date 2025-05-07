//
//  AppSearchablePatientName.swift
//  SearchableListMPApp1
//
//  Created by Daryl Cox on 02/05/2025.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
import SwiftUI

@available(iOS 14.0, *)
final class AppSearchablePatientName: Identifiable
{
    
    struct ClassInfo
    {
        
        static let sClsId        = "AppSearchablePatientName"
        static let sClsVers      = "v1.0201"
        static let sClsDisp      = sClsId+".("+sClsVers+"): "
        static let sClsCopyRight = "Copyright © JustMacApps 2023-2025. All rights reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }

    // App Data field(s):

    var id:UUID             = UUID()
    var sPatientName:String = ""
    var sPatientPID:String  = ""

    init(id:UUID? = nil, sPatientName:String, sPatientPID:String)
    {

        if (id != nil)
        {
        
            self.id = id ?? UUID()
        
        }
        else
        {
        
            self.id = UUID()
        
        }

        self.sPatientName = sPatientName
        self.sPatientPID  = sPatientPID

    }   // End of init(id:UUID, sPatientName:String, sPatientPID:String).

}   // End of final class AppSearchablePatientName(Identifiable).

