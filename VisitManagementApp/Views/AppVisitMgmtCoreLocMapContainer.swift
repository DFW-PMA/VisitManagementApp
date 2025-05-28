//
//  AppVisitMgmtCoreLocMapContainer.swift
//  VisitManagementApp
//
//  Created by Daryl Cox on 05/28/2025.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
import SwiftUI

// Shared data class for passing data to the window:

@MainActor
class AppVisitMgmtCoreLocMapData:ObservableObject 
{

    static     let shared:AppVisitMgmtCoreLocMapData = AppVisitMgmtCoreLocMapData()
    
    @Published var sCoreLocLatLong:String            = "0.000000,0.000000"
    @Published var sCoreLocAddress:String            = "-N/A-"
    
    private init() {}
    
    func updateLocation(sCoreLocLatLong:String, sCoreLocAddress:String) 
    {

        self.sCoreLocLatLong = sCoreLocLatLong
        self.sCoreLocAddress = sCoreLocAddress

    }   // End of func updateLocation(sCoreLocLatLong:String, sCoreLocAddress:String).

}   // End of @MainActor class AppVisitMgmtCoreLocMapData:ObservableObject.

// Container view that observes the shared data:

struct AppVisitMgmtCoreLocMapContainer:View 
{

    @ObservedObject private var appVisitMgmtCoreLocMapData:AppVisitMgmtCoreLocMapData = AppVisitMgmtCoreLocMapData.shared
    
    var body:some View 
    {

        let sCoreLocLatLong:String = appVisitMgmtCoreLocMapData.sCoreLocLatLong
        let sCoreLocAddress:String = appVisitMgmtCoreLocMapData.sCoreLocAddress

        AppVisitMgmtCoreLocMapView(sCoreLocLatLong:sCoreLocLatLong,
                                   sCoreLocAddress:sCoreLocAddress)
    //  AppVisitMgmtCoreLocMapView(sCoreLocLatLong:appVisitMgmtCoreLocMapData.sCoreLocLatLong,
    //                             sCoreLocAddress:appVisitMgmtCoreLocMapData.sCoreLocAddress)

    }

}   // End of struct AppVisitMgmtCoreLocMapContainer:View.

