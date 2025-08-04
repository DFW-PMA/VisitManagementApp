//
//  CoreLocationSiteDetailsView.swift
//  VisitManagementApp
//
//  Created by Daryl Cox on 08/03/2024.
//  Copyright © JustMacApps 2023-2024. All rights reserved.
//

import SwiftUI
import CoreLocation

struct CoreLocationSiteDetailsView:View 
{
    
    struct ClassInfo
    {
        static let sClsId        = "CoreLocationSiteDetailsView"
        static let sClsVers      = "v1.1601"
        static let sClsDisp      = sClsId+"(.swift).("+sClsVers+"):"
        static let sClsCopyRight = "Copyright (C) JustMacApps 2023-2024. All Rights Reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
    }
    
    // App Data field(s):
    
    @Environment(\.presentationMode)    var presentationMode
    @Environment(\.openWindow)          var openWindow
    @Environment(\.openURL)             var openURL
    @Environment(\.appGlobalDeviceType) var appGlobalDeviceType
    
    @State private  var cCoreLocationSiteDetailsViewRefreshButtonPresses:Int     = 0

                    var jmAppDelegateVisitor:JmAppDelegateVisitor                = JmAppDelegateVisitor.ClassSingleton.appDelegateVisitor
    @ObservedObject var coreLocationModelObservable:CoreLocationModelObservable2 = CoreLocationModelObservable2.ClassSingleton.appCoreLocationModel
    
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
        
        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):body(some Scene) 'appGlobalDeviceType' is (\(String(describing:appGlobalDeviceType)))...")
        
        VStack
        {

            HStack(alignment:.center)
            {
                Spacer()

                Button
                {
                    self.cCoreLocationSiteDetailsViewRefreshButtonPresses += 1

                    let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp)CoreLocationSiteDetailsView.Button(Xcode).'Refresh'.#(\(self.cCoreLocationSiteDetailsViewRefreshButtonPresses))...")

                    self.refreshCoreLocation()
                }
                label:
                {
                    VStack(alignment:.center)
                    {
                        Label("", systemImage: "arrow.clockwise")
                            .help(Text("'Refresh' App Screen..."))
                            .imageScale(.large)
                        Text("Refresh - #(\(self.cCoreLocationSiteDetailsViewRefreshButtonPresses))...")
                            .font(.caption2)
                    }
                }
            #if os(macOS)
                .buttonStyle(.borderedProminent)
                .padding()
            //  .background(???.isPressed ? .blue : .gray)
                .cornerRadius(10)
                .foregroundColor(Color.primary)
            #endif

                Spacer()
                
                Button
                {
                    let _ = xcgLogMsg("\(ClassInfo.sClsDisp):CoreLocationSiteDetailsView.Button(Xcode).'Dismiss' pressed...")
                    
                    self.presentationMode.wrappedValue.dismiss()
                }
                label:
                {
                    VStack(alignment:.center)
                    {
                        Label("", systemImage: "xmark.circle")
                            .help(Text("Dismiss this Screen"))
                            .imageScale(.small)
                        Text("Dismiss")
                            .font(.caption2)
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

            Text("CoreLocation2 Information:")
                .bold()
                .italic()
                .underline()
                .font(.footnote) 
            Text("")

            ScrollView
            {
                VStack(alignment:.leading)
                {
                    Text("Reverse 'lookups' Primary:   (\(coreLocationModelObservable.cCoreLocationReverseLookupsPrimary))")
                    Text("Reverse 'lookups' Secondary: (\(coreLocationModelObservable.cCoreLocationReverseLookupsSecondary))")
                    Text("Reverse 'lookups' Tertiary:  (\(coreLocationModelObservable.cCoreLocationReverseLookupsTertiary))")

                    Text("Authorization 'status':      [\(coreLocationModelObservable.clAuthorizationStatus)]")
                    Text("Location 'accuracy':         (\(coreLocationModelObservable.clLocationAccuracy))")
                    Text("Last 'update' Timestamp:     [\(coreLocationModelObservable.clLocationLastUpdateTimestamp)]")
                    Text("GPS 'tolerance:              (\(coreLocationModelObservable.clLocationGPSTolerance))")

                    Text("Possibly 'throttling'?:      [\(coreLocationModelObservable.bCLLocationUpdateIsPossiblyThrottling)]")
                    Text("Pending Reqs 'timestamps':  #(\(coreLocationModelObservable.clLocationPendingRequestsTimestamps.count)) item(s)")
                    Text("Reqs 'response' times:      #(\(coreLocationModelObservable.clLocationRequestsResponseTimes.count)) item(s)")
                    Text("Max # 'response' history:    (\(coreLocationModelObservable.clLocationMaxResponseTimeHistory))")
                    Text("Max time Reqs 'stale':       (\(coreLocationModelObservable.clLocationMaxRequestIsStale))")
                    Text("Average 'response' time:     (\(coreLocationModelObservable.clLocationRequestAverageResponseTime))")
                    Text("Total' # Reqs:               (\(coreLocationModelObservable.cLocationRequestsTotal))")

                    Text("Heading 'available'?:        [\(coreLocationModelObservable.bCLManagerHeadingAvailable)]")
                    Text("Heading 'current':           (\(coreLocationModelObservable.clCurrentHeading))")
                    Text("Heading 'accuracy':          (\(coreLocationModelObservable.clCurrentHeadingAccuracy))")

                    Text("")
                    Text("--------------------")
                    Text("")
                }
                .font(.caption2)

                Grid(alignment:.leadingFirstTextBaseline, horizontalSpacing:5, verticalSpacing:3)
                {
                    // Column Headings:

                    Divider() 

                    GridRow 
                    {
                        Text("ItemName")
                        Text("Description")
                    }
                    .font(.footnote) 

                    Divider() 

                    // Item Rows:

                    ForEach(coreLocationModelObservable.listCoreLocationSiteItems) 
                    { siteItem in

                        GridRow(alignment:.bottom)
                        {
                            Text(siteItem.sCLSiteItemName)
                                .bold()
                            Text((siteItem.sCLSiteItemDesc).stripOptionalStringWrapper())
                                .gridColumnAlignment(.center)
                        }
                        .font(.caption2)

                    }
                }
                
                Spacer()
            }

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
        .padding()
        
        Spacer()
        
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
    
    private func refreshCoreLocation()
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Refresh the 'core' Location...

        self.coreLocationModelObservable.requestLocationUpdate()

        let currLatitude:Double  = coreLocationModelObservable.locationManager?.location?.coordinate.latitude  ?? 0.000000
        let currLongitude:Double = coreLocationModelObservable.locationManager?.location?.coordinate.longitude ?? 0.000000

        let _ = coreLocationModelObservable.updateGeocoderLocation(latitude: currLatitude,
                                                                   longitude:currLongitude)

        // Exit...

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

        return

    }   // End of private func refreshCoreLocation().

}   // End of struct CoreLocationSiteDetailsView:View.

#Preview 
{
    CoreLocationSiteDetailsView()
}

