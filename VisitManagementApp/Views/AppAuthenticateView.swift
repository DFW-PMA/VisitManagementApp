//
//  AppAuthenticateView.swift
//  VisitManagementApp
//
//  Created by Daryl Cox on 11/21/2024.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftData
import LocalAuthentication
import LocalAuthenticationEmbeddedUI

struct AppAuthenticateView: View
{
    
    struct ClassInfo
    {
        
        static let sClsId        = "AppAuthenticateView"
        static let sClsVers      = "v1.3001"
        static let sClsDisp      = sClsId+".("+sClsVers+"): "
        static let sClsCopyRight = "Copyright (C) JustMacApps 2023-2025. All Rights Reserved."
        static let bClsTrace     = true
        static let bClsFileLog   = true
        
    }

    // App Data field(s):

//  @Environment(\.modelContext)        var modelContext
    @Environment(\.appGlobalDeviceType) var appGlobalDeviceType

    static              var timerOnDemandThirdOfSec                               = Timer()
    static              var timerOnDemandHalfOfSec                                = Timer()

    @Binding            var uuid4ForcingViewRefresh:UUID

    enum FocusedFields: Hashable
    {
       case fieldUsername
       case fieldPassword
    }

    @FocusState private var focusedField:FocusedFields?

    @Query              var pfAdminsSwiftDataItems:[PFAdminsSwiftDataItem]

    @State      private var shouldContentViewChange:Bool                          = false

    @State      private var bIsFaceIdAvailable:Bool                               = false
    @State      private var bIsFaceIdAuthenticated:Bool                           = false
    @State      private var sFaceIdAuthenticationMessage:String                   = ""

    @State      private var isUserAuthenticationAvailable:Bool                    = false
    @State      private var sCredentialsCheckReason:String                        = ""
    @State      private var isUserLoginFailureShowing:Bool                        = false
    @State      private var isUserLoggedIn:Bool                                   = false

    @AppStorage("VisitManagementApp.LastLoginBlockedFromFaceId")
                private var bIsUserBlockedFromFaceId:Bool                         = false
    @AppStorage("VisitManagementApp.LastLoginUsername")
                private var sLoginUsername:String                                 = ""
    @AppStorage("VisitManagementApp.LastLoginPassword")
                private var sLoginPassword:String                                 = ""

                private var isUserAuthorizedAndLoggedIn:Bool
    {
        var bAreWeGoodToGo:Bool = false

        if (self.bIsUserBlockedFromFaceId == true)
        {
            bAreWeGoodToGo = self.isUserLoggedIn
        }
        else
        {
            if (self.bIsFaceIdAvailable == false)
            {
                bAreWeGoodToGo = self.isUserLoggedIn
            }
            else
            {
                if (self.bIsFaceIdAuthenticated == true)
                {
                    bAreWeGoodToGo = self.isUserLoggedIn
                }
                else
                {
                    bAreWeGoodToGo = false
                }
            }
        }

        return bAreWeGoodToGo
    }

#if os(iOS)

    @State      private var cAppAboutButtonPresses:Int                            = 0
    @State      private var cAppViewRefreshButtonPresses:Int                      = 0

    @State      private var isAppAboutViewModal:Bool                              = false

#endif

    @ObservedObject     var jmAppDelegateVisitor:JmAppDelegateVisitor             = JmAppDelegateVisitor.ClassSingleton.appDelegateVisitor
    @ObservedObject     var jmAppSwiftDataManager:JmAppSwiftDataManager           = JmAppSwiftDataManager.ClassSingleton.appSwiftDataManager
    @ObservedObject     var jmAppParseCoreManager:JmAppParseCoreManager           = JmAppParseCoreManager.ClassSingleton.appParseCodeManager
                        var jmAppParseCoreBkgdDataRepo:JmAppParseCoreBkgdDataRepo = JmAppParseCoreBkgdDataRepo.ClassSingleton.appParseCodeBkgdDataRepo
                        var appGlobalInfo:AppGlobalInfo                           = AppGlobalInfo.ClassSingleton.appGlobalInfo

    init(uuid4ForcingViewRefresh:Binding<UUID>)
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        // Handle the 'uuid4ForcingViewRefresh' parameter...

        _uuid4ForcingViewRefresh = uuid4ForcingViewRefresh
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
        
        // Check if we have SwiftData 'login' item(s)...
        
        if (self.jmAppSwiftDataManager.pfAdminsSwiftDataItems.count > 0)
        {
            
            self.isUserAuthenticationAvailable.toggle()
            
            self.xcgLogMsg("\(ClassInfo.sClsDisp):body(some Scene) Toggling 'isUserAuthenticationAvailable' to 'true' - SwiftData has (\(self.jmAppSwiftDataManager.pfAdminsSwiftDataItems.count)) 'login' item(s) - value is \(isUserAuthenticationAvailable)...")

        }

        // Continue App 'initialization'...

    //  let _ = self.finishAppInitializationInBackground()

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

        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):body(some Scene) #1 Toggle 'appGlobalDeviceType' is (\(String(describing:appGlobalDeviceType)))...")
        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):body(some Scene) #1 Toggle 'jmAppSwiftDataManager.pfAdminsSwiftDataItems.count' is (\(self.jmAppSwiftDataManager.pfAdminsSwiftDataItems.count))...")
        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):body(some Scene) #1 Toggle 'jmAppSwiftDataManager.bArePFAdminsSwiftDataItemsAvailable' is [\(self.jmAppSwiftDataManager.bArePFAdminsSwiftDataItemsAvailable)]...")
        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):body(some Scene) #1 Toggle 'isUserAuthenticationAvailable' is [\(isUserAuthenticationAvailable)]...")
        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):body(some Scene) #1 Toggle 'bIsUserBlockedFromFaceId' is [\(bIsUserBlockedFromFaceId)]...")

        // Check if we have 'login' data available from SwiftData...

        if (self.jmAppSwiftDataManager.bArePFAdminsSwiftDataItemsAvailable == false &&
            isUserAuthenticationAvailable                                  == false)
        {

            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):body(some Scene) #2 Toggle 'jmAppSwiftDataManager.pfAdminsSwiftDataItems.count' is (\(self.jmAppSwiftDataManager.pfAdminsSwiftDataItems.count))...")
            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):body(some Scene) #2 Toggle 'jmAppSwiftDataManager.bArePFAdminsSwiftDataItemsAvailable' is [\(self.jmAppSwiftDataManager.bArePFAdminsSwiftDataItemsAvailable)]...")
            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):body(some Scene) #2 Toggle 'isUserAuthenticationAvailable' is [\(isUserAuthenticationAvailable)]...")
            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):body(some Scene) #2 Toggle 'bIsUserBlockedFromFaceId' is [\(bIsUserBlockedFromFaceId)]...")

            VStack(alignment:.center)
            {

                Spacer()

                HStack
                {

                    Spacer()

                #if os(iOS)

                    Button
                    {

                        self.cAppAboutButtonPresses += 1

                        let _ = xcgLogMsg("\(ClassInfo.sClsDisp):AppAuthenticateView.Button(Xcode).'App About'.#(\(self.cAppAboutButtonPresses))...")

                        self.isAppAboutViewModal.toggle()

                    }
                    label:
                    {

                        VStack(alignment:.center)
                        {

                            Label("", systemImage: "questionmark.diamond")
                                .help(Text("App About Information"))
                                .imageScale(.large)

                            Text("About")
                                .font(.caption)

                        }

                    }
                    .fullScreenCover(isPresented:$isAppAboutViewModal)
                    {

                        AppAboutView()

                    }

                    Spacer()

                #endif

                if #available(iOS 17.0, *)
                {

                    Image(ImageResource(name: "Gfx/AppIcon", bundle: Bundle.main))
                        .resizable()
                        .scaledToFit()
                        .containerRelativeFrame(.horizontal)
                            { size, axis in
                                size * 0.10
                            }

                }
                else
                {

                    Image(ImageResource(name: "Gfx/AppIcon", bundle: Bundle.main))
                        .resizable()
                        .scaledToFit()
                        .frame(width:50, height: 50, alignment:.center)

                }

                    Spacer()

                #if os(iOS)

                    VStack(alignment:.center)
                    {

                    //  Label("", systemImage: "questionmark.diamond")
                    //      .help(Text("App About Information"))
                    //      .imageScale(.large)

                    //  Text: --- (hidden) Horzonital <Spacer> ---
                    //  Text("")
                    //      .font(.caption)
                    //      .opacity(0)

                        Button
                        {

                            self.cAppViewRefreshButtonPresses += 1

                            let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp).Button(Xcode).'Refresh'.#(\(self.cAppViewRefreshButtonPresses))...")

                            self.bIsFaceIdAuthenticated = false

                            self.authenticateViaFaceId()

                            let bUserLoginValidated:Bool = self.isUserPasswordValidForLogin()

                            if (bUserLoginValidated == true)
                            {
                                self.jmAppDelegateVisitor.setAppDelegateVisitorSignalSwiftViewsShouldRefresh()
                                
                            //  // Generate a new UUID to force the View to be (completely) recreated...
                            //
                            //  uuid4ForcingViewRefresh = UUID()
                            //
                            //  let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp).Button(Xcode).'Refresh'.#(\(self.cAppViewRefreshButtonPresses)) - generated a new UUID in <'uuid4ForcingViewRefresh'>...")
                            }

                        }
                        label:
                        {

                            VStack(alignment:.center)
                            {

                                Label("", systemImage: "faceid")
                                    .help(Text("'Refresh' App 'Authenticate' Screen..."))
                                    .foregroundStyle(.tint)
                                    .font(.system(size: 30))

                                Text("Refresh - #(\(self.cAppViewRefreshButtonPresses))...")
                                    .font(.footnote)

                            }

                        }
                        .padding()

                    }

                    Spacer()

                #endif

                }

                Spacer()

                HStack
                {

                    Spacer()

                    Text("Gathering Authentication material(s)...")
                        .onReceive(jmAppDelegateVisitor.$appDelegateVisitorSwiftViewsShouldChange,
                            perform:
                            { bChange in
                                if (bChange == true)
                                {
                                    let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onReceive #1 - Received a 'view(s)' SHOULD Change - 'self.shouldContentViewChange' is [\(self.shouldContentViewChange)]...")

                                    self.shouldContentViewChange.toggle()

                                    let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onReceive #1 - Toggled 'self.shouldContentViewChange' which is now [\(self.shouldContentViewChange)]...")
                                    let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onReceive #1 - 'self.isUserAuthenticationAvailable' is [\(self.isUserAuthenticationAvailable)]...")
                                    let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onReceive #1 - 'bIsUserBlockedFromFaceId' is [\(bIsUserBlockedFromFaceId)]...")

                                    if (isUserAuthenticationAvailable                           == false &&
                                        self.jmAppDelegateVisitor.isUserAuthenticationAvailable == true)
                                    {

                                        self.isUserAuthenticationAvailable.toggle()

                                        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onReceive #1 - Toggled 'self.isUserAuthenticationAvailable' value is now [\(self.isUserAuthenticationAvailable)]...")

                                    }

                                    if (self.jmAppSwiftDataManager.pfAdminsSwiftDataItems.count         > 0 &&
                                        self.jmAppSwiftDataManager.bArePFAdminsSwiftDataItemsAvailable == false)
                                    {

                                        self.jmAppSwiftDataManager.bArePFAdminsSwiftDataItemsAvailable.toggle()

                                        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onReceive #1 - Toggled 'self.jmAppSwiftDataManager.bArePFAdminsSwiftDataItemsAvailable' value is now [\(self.jmAppSwiftDataManager.bArePFAdminsSwiftDataItemsAvailable)]...")

                                    }

                                    self.jmAppDelegateVisitor.resetAppDelegateVisitorSignalSwiftViewsShouldChange()
                                }
                            })

                    ProgressView()
                        .padding()

                    Spacer()

                }

                Spacer()

            }
            .onAppear(
                perform:
                {
                    let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onAppear #1 - Updating 'self.authenticateViaFaceId()' and then 'self.isUserPasswordValidForLogin()'...")

                    self.authenticateViaFaceId()

                    let bUserLoginValidated:Bool = self.isUserPasswordValidForLogin()

                    if (bUserLoginValidated == true)
                    {
                        self.jmAppDelegateVisitor.setAppDelegateVisitorSignalSwiftViewsShouldRefresh()

                    //  // Generate a new UUID to force the View to be (completely) recreated...
                    //
                    //  uuid4ForcingViewRefresh = UUID()
                    //
                    //  let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp).onAppear #1 - Updating 'self.authenticateViaFaceId()' and then 'self.isUserPasswordValidForLogin()' - generated a new UUID in <'uuid4ForcingViewRefresh'>...")
                    }

                }
            )

        }
        else
        {

            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):body(some Scene) #3 Toggle 'jmAppSwiftDataManager.pfAdminsSwiftDataItems.count' is (\(self.jmAppSwiftDataManager.pfAdminsSwiftDataItems.count))...")
            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):body(some Scene) #3 Toggle 'jmAppSwiftDataManager.bArePFAdminsSwiftDataItemsAvailable' is [\(self.jmAppSwiftDataManager.bArePFAdminsSwiftDataItemsAvailable)]...")
            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):body(some Scene) #3 Toggle 'isUserAuthenticationAvailable' is [\(isUserAuthenticationAvailable)]...")

            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):body(some Scene) #3 Toggle 'bIsFaceIdAuthenticated' is [\(bIsFaceIdAuthenticated)]...")
            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):body(some Scene) #3 Toggle 'isUserLoggedIn' is [\(isUserLoggedIn)]...")
            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):body(some Scene) #3 Toggle 'isUserAuthorizedAndLoggedIn' is [\(isUserAuthorizedAndLoggedIn)]...")
            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):body(some Scene) #3 Toggle 'bIsUserBlockedFromFaceId' is [\(bIsUserBlockedFromFaceId)]...")

        //  if (isUserLoggedIn == false)
            if (isUserAuthorizedAndLoggedIn == false)
            {

                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):body(some Scene) #3 Toggle 'isUserLoggedIn' is \(isUserLoggedIn)...")

                ScrollView
                {

                    VStack(alignment:.center)
                    {

                        Spacer()

                        HStack
                        {

                        #if os(iOS)

                            Button
                            {

                                self.cAppAboutButtonPresses += 1

                                let _ = xcgLogMsg("\(ClassInfo.sClsDisp):AppAuthenticateView.Button(Xcode).'App About'.#(\(self.cAppAboutButtonPresses))...")

                                self.isAppAboutViewModal.toggle()

                            }
                            label:
                            {

                                VStack(alignment:.center)
                                {

                                    Label("", systemImage: "questionmark.diamond")
                                        .help(Text("App About Information"))
                                        .imageScale(.large)

                                    Text("About")
                                        .font(.caption)

                                }

                            }
                            .fullScreenCover(isPresented:$isAppAboutViewModal)
                            {

                                AppAboutView()

                            }
                            .padding()

                        #endif

                            Spacer()

                        if #available(iOS 17.0, *)
                        {

                            Image(ImageResource(name: "Gfx/AppIcon", bundle: Bundle.main))
                                .resizable()
                                .scaledToFit()
                                .containerRelativeFrame(.horizontal)
                                    { size, axis in
                                        size * 0.10
                                    }

                        }
                        else
                        {

                            Image(ImageResource(name: "Gfx/AppIcon", bundle: Bundle.main))
                                .resizable()
                                .scaledToFit()
                                .frame(width:50, height: 50, alignment:.center)

                        }

                            Spacer()

                        #if os(iOS)

                        //  VStack(alignment:.center)
                        //  {
                        //
                        //      Label("", systemImage: "textformat.size.smaller")
                        //          .help(Text("App Marker"))
                        //          .imageScale(.large)
                        //          .opacity(0)
                        //
                        //  //  Text: --- (hidden) Horzonital <Spacer> ---
                        //      Text("")
                        //          .font(.caption)
                        //          .opacity(0)
                        //
                        //  }
                        //  .padding()

                        //  Button("FaceId")
                            Button
                            {

                                self.cAppViewRefreshButtonPresses += 1

                                let _ = self.xcgLogMsg("...\(ClassInfo.sClsDisp).Button(Xcode).'Refresh (FaceId)'.#(\(self.cAppViewRefreshButtonPresses))...")

                                self.bIsFaceIdAuthenticated = false

                                self.authenticateViaFaceId()

                                if sLoginUsername.isEmpty
                                {
                                    focusedField = .fieldUsername
                                }
                                else
                                {
                                    if sLoginPassword.isEmpty
                                    {
                                        focusedField = .fieldPassword
                                    }
                                    else
                                    {

                                        focusedField = nil

                                        let bUserLoginValidated:Bool = self.isUserPasswordValidForLogin()

                                        if (bUserLoginValidated == true)
                                        {

                                            AppAuthenticateView.timerOnDemandThirdOfSec = Timer.scheduledTimer(withTimeInterval:0.35, repeats:false)
                                            { _ in
                                                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp) <onDemand Timer> <View 'refresh' FaceId> '.35-second' Timer 'pop' - invoking the 'self.jmAppDelegateVisitor.setAppDelegateVisitorSignalSwiftViewsShouldRefresh()'...")
                                                self.jmAppDelegateVisitor.setAppDelegateVisitorSignalSwiftViewsShouldRefresh()
                                                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp) <onDemand Timer> <View 'refresh' FaceId> '.35-second' Timer 'pop' - invoked  the 'self.jmAppDelegateVisitor.setAppDelegateVisitorSignalSwiftViewsShouldRefresh()'...")

                                            }

                                            AppAuthenticateView.timerOnDemandHalfOfSec = Timer.scheduledTimer(withTimeInterval:0.50, repeats:false)
                                            { _ in
                                                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp) <onDemand Timer> <View 'refresh' FaceId> '.50-second' Timer 'pop' - generating a new UUID in <'uuid4ForcingViewRefresh'>...")

                                                // Generate a new UUID to force the View to be (completely) recreated...
                                              
                                                uuid4ForcingViewRefresh = UUID()

                                                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp) <onDemand Timer> <View 'refresh' FaceId> '.50-second' Timer 'pop' - generated  a new UUID in <'uuid4ForcingViewRefresh'>...")
                                            }

                                        }
                                    }
                                }
                            }
                            label:
                            {
                          
                                VStack(alignment:.center)
                                {
                          
                                    Label("", systemImage: "faceid")
                                        .help(Text("'Refresh' App 'Authenticate' Screen..."))
                                        .foregroundStyle(.tint)
                                        .font(.system(size: 30))
                          
                                    Text("Refresh - #(\(self.cAppViewRefreshButtonPresses))...")
                                        .font(.footnote)
                          
                                }
                          
                            }
                            .padding()
                        //  .buttonStyle(.borderedProminent)

                        #endif

                        }

                        Spacer()

                        Text("")

                        Image(systemName: "person.badge.key")
                            .imageScale(.large)
                            .foregroundStyle(.tint)

                        Spacer()

                        Text("Enter your Login information:")
                            .onAppear
                            {
                                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).Text #1 - Received an .onAppear()...")

                                if sLoginUsername.isEmpty
                                {
                                    focusedField = .fieldUsername
                                }
                                else
                                {
                                    if sLoginPassword.isEmpty
                                    {
                                        focusedField = .fieldPassword
                                    }
                                    else
                                    {
                                        focusedField = nil
                                    }
                                }
                            }

                        TextField("Username", text: $sLoginUsername)
                        #if os(iOS)
                            .keyboardType(.default)
                        #endif
                            .focused($focusedField, equals: .fieldUsername)
                            .onSubmit
                            {
                                focusedField = .fieldPassword
                            }
                            .onAppear
                            {
                                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).AppAuthenticateView.TextField #1 - Received an .onAppear() #1...")

                                focusedField = nil
                            }

                        SecureField("Password", text: $sLoginPassword)
                        #if os(iOS)
                            .keyboardType(.default)
                        #endif
                            .focused($focusedField, equals: .fieldPassword)
                            .onSubmit
                            {
                                let bUserLoginValidated:Bool = self.isUserPasswordValidForLogin()

                                if (bUserLoginValidated == true)
                                {
                                    self.jmAppDelegateVisitor.setAppDelegateVisitorSignalSwiftViewsShouldRefresh()

                                //  // Generate a new UUID to force the View to be (completely) recreated...
                                //
                                //  uuid4ForcingViewRefresh = UUID()
                                //
                                //  let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).Text #1 - Received an .onSubmit() - generated a new UUID in <'uuid4ForcingViewRefresh'>...")
                                }
                            }
                            .onAppear
                            {
                                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).AppAuthenticateView.TextField #2 - Received an .onAppear() #1...")

                                focusedField = nil
                            }
                            .alert("\(self.sCredentialsCheckReason) - try again...", isPresented:$isUserLoginFailureShowing)
                            {
                                Button("Ok", role:.cancel)
                                {
                                    let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp) User pressed 'Ok' to attempt the 'login' again...")
                                    focusedField = .fieldPassword
                                }
                            }

                        HStack
                        {

                            Spacer()

                            Button("Login")
                            {
                                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp) User pressed the 'Login' button...")

                                if sLoginUsername.isEmpty
                                {
                                    focusedField = .fieldUsername
                                }
                                else
                                {
                                    if sLoginPassword.isEmpty
                                    {
                                        focusedField = .fieldPassword
                                    }
                                    else
                                    {
                                        focusedField = nil

                                        let bUserLoginValidated:Bool = self.isUserPasswordValidForLogin()

                                        if (bUserLoginValidated == true)
                                        {
                                            self.jmAppDelegateVisitor.setAppDelegateVisitorSignalSwiftViewsShouldRefresh()

                                        //  // Generate a new UUID to force the View to be (completely) recreated...
                                        //
                                        //  uuid4ForcingViewRefresh = UUID()
                                        //
                                        //  let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp) User pressed the 'Login' button - generated a new UUID in <'uuid4ForcingViewRefresh'>...")
                                        }
                                    }
                                }
                            }
                            .buttonStyle(.borderedProminent)

                            Spacer()

                        }

                    }
                    .onAppear(
                        perform:
                        {
                            let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onAppear #2 - Updating 'self.authenticateViaFaceId()' and then 'self.isUserPasswordValidForLogin()'...")

                            self.authenticateViaFaceId()

                            let bUserLoginValidated:Bool = self.isUserPasswordValidForLogin()

                            if (bUserLoginValidated == true)
                            {
                                focusedField = nil

                                self.jmAppDelegateVisitor.setAppDelegateVisitorSignalSwiftViewsShouldRefresh()

                            //  // Generate a new UUID to force the View to be (completely) recreated...
                            //
                            //  uuid4ForcingViewRefresh = UUID()
                            //
                            //  let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onAppear #2 - Updating 'self.authenticateViaFaceId()' and then 'self.isUserPasswordValidForLogin()' - generated a new UUID in <'uuid4ForcingViewRefresh'>...")
                            }
                        }
                    )
                    .padding()

                }

            }
            else
            {

                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):body(some Scene) #4 Toggle 'jmAppSwiftDataManager.pfAdminsSwiftDataItems.count' is (\(self.jmAppSwiftDataManager.pfAdminsSwiftDataItems.count))...")
                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):body(some Scene) #4 Toggle 'jmAppSwiftDataManager.bArePFAdminsSwiftDataItemsAvailable' is [\(self.jmAppSwiftDataManager.bArePFAdminsSwiftDataItemsAvailable)]...")
                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):body(some Scene) #4 Toggle 'isUserAuthenticationAvailable' is [\(isUserAuthenticationAvailable)]...")

                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):body(some Scene) #4 Toggle 'bIsFaceIdAuthenticated' is [\(bIsFaceIdAuthenticated)]...")
                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):body(some Scene) #4 Toggle 'isUserLoggedIn' is [\(isUserLoggedIn)]...")
                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):body(some Scene) #4 Toggle 'isUserAuthorizedAndLoggedIn' is [\(isUserAuthorizedAndLoggedIn)]...")
                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp):body(some Scene) #4 Toggle 'bIsUserBlockedFromFaceId' is [\(bIsUserBlockedFromFaceId)]...")

                ContentView(isUserLoggedIn:$isUserLoggedIn, sLoginUsername:$sLoginUsername, sLoginPassword:$sLoginPassword)

            }

        }

        Text("View 'refresh' flag: [\(self.jmAppDelegateVisitor.appDelegateVisitorSwiftViewsShouldRefresh)]...")            
            .hidden()
            .onAppear(
                perform:
                {
                    // Continue App 'initialization'...

                    let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onAppear #3 - Updating 'self.authenticateViaFaceId()' and then 'self.isUserPasswordValidForLogin()'...")

                    let _ = self.finishAppInitializationInBackground()

                    if (self.bIsUserBlockedFromFaceId == true)
                    {
                        self.sLoginPassword = ""
                    }

                    self.authenticateViaFaceId()

                    let bUserLoginValidated:Bool = self.isUserPasswordValidForLogin()

                    if (bUserLoginValidated == true)
                    {
                        focusedField = nil

                        self.jmAppDelegateVisitor.setAppDelegateVisitorSignalSwiftViewsShouldRefresh()

                    //  // Generate a new UUID to force the View to be (completely) recreated...
                    //
                    //  uuid4ForcingViewRefresh = UUID()
                    //
                    //  let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onAppear #3 - Updating 'self.authenticateViaFaceId()' and then 'self.isUserPasswordValidForLogin()' - generated a new UUID in <'uuid4ForcingViewRefresh'>...")
                    }

                })
            .onChange(of:self.jmAppDelegateVisitor.appDelegateVisitorSwiftViewsShouldRefresh)
            {
                let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onChange #1 - JmAppDelegateVisitor has 'signalled' a View 'refresh' - 'appDelegateVisitorSwiftViewsShouldRefresh' is [\(self.jmAppDelegateVisitor.appDelegateVisitorSwiftViewsShouldRefresh)]...")

                if (self.jmAppDelegateVisitor.appDelegateVisitorSwiftViewsShouldRefresh == true)
                {
                    AppAuthenticateView.timerOnDemandThirdOfSec = Timer.scheduledTimer(withTimeInterval:0.35, repeats:false)
                    { _ in
                        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp) <onDemand Timer> <View 'refresh' .hidden> '.35-second' Timer 'pop' - invoking the 'self.jmAppDelegateVisitor.resetAppDelegateVisitorSignalSwiftViewsShouldRefresh()'...")
                        self.jmAppDelegateVisitor.resetAppDelegateVisitorSignalSwiftViewsShouldRefresh()
                        let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp) <onDemand Timer> <View 'refresh' .hidden> '.35-second' Timer 'pop' - invoked  the 'self.jmAppDelegateVisitor.resetAppDelegateVisitorSignalSwiftViewsShouldRefresh()'...")

                    //  // Generate a new UUID to force the View to be (completely) recreated...
                    //
                    //  uuid4ForcingViewRefresh = UUID()
                    //
                    //  let _ = self.xcgLogMsg("\(ClassInfo.sClsDisp).onChange #1 - JmAppDelegateVisitor has 'signalled' a View 'refresh' - generated a new UUID in <'uuid4ForcingViewRefresh'>...")
                    }
                }
            }
        
    }
    
    private func finishAppInitializationInBackground()
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
  
        let dispatchGroup = DispatchGroup()

        do
        {

            dispatchGroup.enter()

            let dispatchQueue = DispatchQueue(label: "FinishAppInitializationInBackground", qos: .userInitiated)

            dispatchQueue.async
            {

                self.xcgLogMsg("\(sCurrMethodDisp) Invoking background 'initialization' method(s)...");

                let isPFAdminsAvailable:Bool = self.checkIfAppParseCoreHasPFAdminsDataItems()

                if (isPFAdminsAvailable == true)
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) Toggling the 'isUserAuthenticationAvailable' flag...");

                    dispatchGroup.notify(queue: DispatchQueue.main, execute:
                    {
                    
                        self.isUserAuthenticationAvailable.toggle()

                        self.xcgLogMsg("\(sCurrMethodDisp) Toggled  the 'isUserAuthenticationAvailable' flag - value is now [\(self.isUserAuthenticationAvailable)]...");

                        self.jmAppDelegateVisitor.isUserAuthenticationAvailable = true

                        self.xcgLogMsg("\(sCurrMethodDisp) Set the 'self.jmAppDelegateVisitor.isUserAuthenticationAvailable' flag 'true' - value is now [\(self.jmAppDelegateVisitor.isUserAuthenticationAvailable)]...");

                        self.jmAppDelegateVisitor.setAppDelegateVisitorSignalSwiftViewsShouldChange()

                        self.xcgLogMsg("\(sCurrMethodDisp) Toggled  the 'self.jmAppDelegateVisitor.setAppDelegateVisitorSignalSwiftViewsShouldChange()' method - value is now [\(self.jmAppDelegateVisitor.appDelegateVisitorSwiftViewsShouldChange)]...");

                    })

                }

                let _ = self.checkIfAppParseCoreHasPFCscDataItems()
            //  let _ = self.checkIfAppParseCoreHasPFInstallationCurrent()

                self.xcgLogMsg("\(sCurrMethodDisp) Invoked  background 'initialization' method(s)...");

            }

            dispatchGroup.leave()

        }

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return

    } // End of private func finishAppInitializationInBackground().
    
    private func checkIfAppParseCoreHasPFAdminsDataItems() -> Bool
    {
  
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        self.xcgLogMsg("\(sCurrMethodDisp) Calling the 'jmAppParseCoreBkgdDataRepo' method 'getJmAppParsePFQueryForAdmins()' to get a 'authentication' dictionary...")

        let _ = self.jmAppParseCoreBkgdDataRepo.getJmAppParsePFQueryForAdmins()

        self.xcgLogMsg("\(sCurrMethodDisp) Called  the 'jmAppParseCoreBkgdDataRepo' method 'getJmAppParsePFQueryForAdmins()' to get a 'authentication' dictionary...")

        var bWasAppPFAdminsDataPresent:Bool = false

        if (self.jmAppParseCoreManager.dictPFAdminsDataItems.count < 1)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) 'jmAppParseCoreManager' has a 'dictPFAdminsDataItems' that is 'empty'...")

            bWasAppPFAdminsDataPresent = false

        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) 'jmAppParseCoreManager' has a 'dictPFAdminsDataItems' that is [\(String(describing: jmAppDelegateVisitor.jmAppParseCoreManager?.dictPFAdminsDataItems))]...")

            bWasAppPFAdminsDataPresent = true

        }
  
        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'bWasAppPFAdminsDataPresent' is [\(String(describing: bWasAppPFAdminsDataPresent))]...")
  
        return bWasAppPFAdminsDataPresent
  
    }   // End of private func checkIfAppParseCoreHasPFAdminsDataItems().

    private func checkIfAppParseCoreHasPFCscDataItems() -> Bool
    {
  
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
  
        self.xcgLogMsg("\(sCurrMethodDisp) Calling the 'jmAppParseCoreBkgdDataRepo' method 'getJmAppParsePFQueryForCSC()' to get a 'location' list...")

        let _ = self.jmAppParseCoreBkgdDataRepo.getJmAppParsePFQueryForCSC()

        self.xcgLogMsg("\(sCurrMethodDisp) Called  the 'jmAppParseCoreBkgdDataRepo' method 'getJmAppParsePFQueryForCSC()' to get a 'location' list...")

        var bWasAppPFCscDataPresent:Bool = false

        if (self.jmAppParseCoreManager.listPFCscDataItems.count < 1)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) 'jmAppParseCoreManager' has a 'listPFCscDataItems' that is 'empty'...")

            bWasAppPFCscDataPresent = false

        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) 'jmAppParseCoreManager' has a 'listPFCscDataItems' that is [\(String(describing: jmAppDelegateVisitor.jmAppParseCoreManager?.listPFCscDataItems))]...")

            bWasAppPFCscDataPresent = true

        }

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'bWasAppPFCscDataPresent' is [\(String(describing: bWasAppPFCscDataPresent))]...")
  
        return bWasAppPFCscDataPresent
  
    }   // End of private func checkIfAppParseCoreHasPFCscDataItems().

    private func getAppParseCoreManagerInstance()->JmAppParseCoreManager
    {
  
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")
  
        let jmAppParseCoreManager:JmAppParseCoreManager = JmAppParseCoreManager.ClassSingleton.appParseCodeManager
  
        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'jmAppParseCoreManager' is [\(String(describing: jmAppParseCoreManager))]...")
  
        return jmAppParseCoreManager
  
    }   // End of private func getAppParseCoreManagerInstance()->jmAppParseCoreManager.

    private func locateUserDataInPFAdmins()->ParsePFAdminsDataItem?
    {
  
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'sLoginUsername' is [\(self.sLoginUsername)] - 'sLoginPassword' is [\(self.sLoginPassword)]...")

        // Attempt to locate the User data in 'dictPFAdminsDataItems'...

        var pfAdminsDataItem:ParsePFAdminsDataItem? = nil
        var sLookupUserName:String                  = ""
        var sLookupUserNameNoWS:String              = ""

        if (self.sLoginUsername.count > 0)
        {

            sLookupUserName     = self.sLoginUsername.lowercased()
            sLookupUserNameNoWS = sLookupUserName.removeUnwantedCharacters(charsetToRemove:[StringCleaning.removeAll], bResultIsLowerCased:true)

        }
        else
        {

            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'self.sLoginUsername' is nil or Empty - can NOT be 'validated' - Warning!")

            pfAdminsDataItem = nil   

            return pfAdminsDataItem

        }

        let jmAppParseCoreManager:JmAppParseCoreManager = self.getAppParseCoreManagerInstance()

        if (jmAppParseCoreManager.dictPFAdminsDataItems.count < 1)
        {

            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'jmAppParseCoreManager.dictPFAdminsDataItems' is nil or Empty - can NOT be 'validated' - Error!")

            pfAdminsDataItem = nil   

            return pfAdminsDataItem

        }

        for (_, parsePFAdminsDataItem) in jmAppParseCoreManager.dictPFAdminsDataItems
        {

            let sComparePFAdminsParseName:String     = parsePFAdminsDataItem.sPFAdminsParseName.lowercased()
            let sComparePFAdminsParseNameNoWS:String = parsePFAdminsDataItem.sPFAdminsParseNameNoWS

            if (sComparePFAdminsParseName.count  > 0 &&
                sComparePFAdminsParseName       == sLookupUserName)
            {

                self.xcgLogMsg("\(sCurrMethodDisp) 'sLookupUserName' of [\(sLookupUserName)] matches the 'sComparePFAdminsParseName' of [\(sComparePFAdminsParseName)] - setting 'pfAdminsDataItem' to this item...")

                pfAdminsDataItem = parsePFAdminsDataItem   

                break

            }
            else
            {

                self.xcgLogMsg("\(sCurrMethodDisp) 'sLookupUserName' of [\(sLookupUserName)] does NOT match the 'sComparePFAdminsParseName' of [\(sComparePFAdminsParseName)] - continuing search...")

                if (sComparePFAdminsParseNameNoWS.count  > 0 &&
                    sComparePFAdminsParseNameNoWS       == sLookupUserNameNoWS)
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) 'sLookupUserNameNoWS' of [\(sLookupUserNameNoWS)] matches the 'sComparePFAdminsParseNameNoWS' of [\(sComparePFAdminsParseNameNoWS)] - setting 'pfAdminsDataItem' to this item...")

                    pfAdminsDataItem = parsePFAdminsDataItem   

                    break

                }
                else
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) 'sLookupUserName' of [\(sLookupUserName)] does NOT match the 'sComparePFAdminsParseName' of [\(sComparePFAdminsParseName)] - continuing search...")

                }

            }

            let sComparePFTherapistParseTID:String = parsePFAdminsDataItem.sPFAdminsParseTID.lowercased()

            if (sComparePFTherapistParseTID.count  > 0 &&
                sComparePFTherapistParseTID       == sLookupUserName)
            {

                self.xcgLogMsg("\(sCurrMethodDisp) 'sLookupUserName' of [\(sLookupUserName)] matches the 'sComparePFTherapistParseTID' of [\(sComparePFTherapistParseTID)] - setting 'pfAdminsDataItem' to this item...")

                pfAdminsDataItem = parsePFAdminsDataItem   

                break

            }
            else
            {

                self.xcgLogMsg("\(sCurrMethodDisp) 'sLookupUserName' of [\(sLookupUserName)] does NOT match the 'sComparePFTherapistParseTID' of [\(sComparePFTherapistParseTID)] - continuing search...")

            }

        }

        if (pfAdminsDataItem == nil)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) 'sLookupUserName' of [\(sLookupUserName)] can NOT be found in the valid (\(jmAppParseCoreManager.dictPFAdminsDataItems.count)) login(s) dictionary - User can NOT be 'validated' - Warning!")

            pfAdminsDataItem = nil   

        }
        else
        {

            if (pfAdminsDataItem!.bPFAdminsCanUseFaceId == false)
            {

                self.bIsUserBlockedFromFaceId     = true
                self.bIsFaceIdAvailable           = false
                self.bIsFaceIdAuthenticated       = false
                self.sFaceIdAuthenticationMessage = "App 'user' is NOT allowed to use 'FaceId' Authentication"

                self.xcgLogMsg("\(sCurrMethodDisp) 'sLookupUserName' of [\(sLookupUserName)] was found in the valid (\(jmAppParseCoreManager.dictPFAdminsDataItems.count)) login(s) dictionary - User can NOT use 'FaceId' - cleared the FaceId field(s) - Warning!")
            
            }
            else
            {

                self.bIsUserBlockedFromFaceId     = false

                self.xcgLogMsg("\(sCurrMethodDisp) 'sLookupUserName' of [\(sLookupUserName)] was found in the valid (\(jmAppParseCoreManager.dictPFAdminsDataItems.count)) login(s) dictionary - User CAN use 'FaceId' - set FaceId field...")

            }
            
        }
        
        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'pfAdminsDataItem' is [\(String(describing: pfAdminsDataItem))]...")
  
        return pfAdminsDataItem
  
    }   // End of private func locateUserDataInPFAdmins()->ParsePFAdminsDataItem?.

    private func locateUserDataInSwiftData()->PFAdminsSwiftDataItem?
    {
  
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'sLoginUsername' is [\(self.sLoginUsername)] - 'sLoginPassword' is [\(self.sLoginPassword)]...")

        // Attempt to locate the User data in SwiftData...

        var pfAdminsSwiftDataItem:PFAdminsSwiftDataItem? = nil
        var sLookupUserName:String                       = ""
        var sLookupUserNameNoWS:String                   = ""

        if (self.sLoginUsername.count > 0)
        {

            sLookupUserName     = self.sLoginUsername.lowercased()
            sLookupUserNameNoWS = sLookupUserName.removeUnwantedCharacters(charsetToRemove:[StringCleaning.removeAll], bResultIsLowerCased:true)

        }
        else
        {

            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'self.sLoginUsername' is nil or Empty - can NOT be 'validated' - Error!")

            pfAdminsSwiftDataItem = nil   

            return pfAdminsSwiftDataItem

        }

        for listSwiftDataItem in self.jmAppSwiftDataManager.pfAdminsSwiftDataItems
        {

            let sComparePFAdminsParseName:String     = listSwiftDataItem.sPFAdminsParseName.lowercased()
            let sComparePFAdminsParseNameNoWS:String = listSwiftDataItem.sPFAdminsParseNameNoWS

            if (sComparePFAdminsParseName.count  > 0 &&
                sComparePFAdminsParseName       == sLookupUserName)
            {

                self.xcgLogMsg("\(sCurrMethodDisp) 'sLookupUserName' of [\(sLookupUserName)] matches the 'sComparePFAdminsParseName' of [\(sComparePFAdminsParseName)] - setting 'pfAdminsSwiftDataItem' to this item...")

                pfAdminsSwiftDataItem = listSwiftDataItem   

                break

            }
            else
            {

                self.xcgLogMsg("\(sCurrMethodDisp) 'sLookupUserName' of [\(sLookupUserName)] does NOT match the 'sComparePFAdminsParseName' of [\(sComparePFAdminsParseName)] - continuing search...")

                if (sComparePFAdminsParseNameNoWS.count  > 0 &&
                    sComparePFAdminsParseNameNoWS       == sLookupUserNameNoWS)
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) 'sLookupUserNameNoWS' of [\(sLookupUserNameNoWS)] matches the 'sComparePFAdminsParseNameNoWS' of [\(sComparePFAdminsParseNameNoWS)] - setting 'pfAdminsSwiftDataItem' to this item...")

                    pfAdminsSwiftDataItem = listSwiftDataItem   

                    break

                }
                else
                {

                    self.xcgLogMsg("\(sCurrMethodDisp) 'sLookupUserName' of [\(sLookupUserName)] does NOT match the 'sComparePFAdminsParseName' of [\(sComparePFAdminsParseName)] - continuing search...")

                }

            }

            let sComparePFTherapistParseTID:String = listSwiftDataItem.sPFAdminsParseTID.lowercased()

            if (sComparePFTherapistParseTID.count  > 0 &&
                sComparePFTherapistParseTID       == sLookupUserName)
            {

                self.xcgLogMsg("\(sCurrMethodDisp) 'sLookupUserName' of [\(sLookupUserName)] matches the 'sComparePFTherapistParseTID' of [\(sComparePFTherapistParseTID)] - setting 'pfAdminsSwiftDataItem' to this item...")

                pfAdminsSwiftDataItem = listSwiftDataItem   

                break

            }
            else
            {

                self.xcgLogMsg("\(sCurrMethodDisp) 'sLookupUserName' of [\(sLookupUserName)] does NOT match the 'sComparePFTherapistParseTID' of [\(sComparePFTherapistParseTID)] - continuing search...")

            }

        }

        if (pfAdminsSwiftDataItem == nil)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) 'sLookupUserName' of [\(sLookupUserName)] can NOT be found in the valid SwiftData (\(self.jmAppSwiftDataManager.pfAdminsSwiftDataItems.count)) login(s) list - User can NOT be 'validated' - Warning!")

            pfAdminsSwiftDataItem = nil   

        }
        else
        {

            if (pfAdminsSwiftDataItem!.bPFAdminsCanUseFaceId == false)
            {

                self.bIsUserBlockedFromFaceId     = true
                self.bIsFaceIdAvailable           = false
                self.bIsFaceIdAuthenticated       = false
                self.sFaceIdAuthenticationMessage = "App 'user' is NOT allowed to use 'FaceId' Authentication"

                self.xcgLogMsg("\(sCurrMethodDisp) 'sLookupUserName' of [\(sLookupUserName)] was found in the valid (\(jmAppParseCoreManager.dictPFAdminsDataItems.count)) login(s) dictionary - User can NOT use 'FaceId' - cleared the FaceId field(s) - Warning!")

            }
            else
            {

                self.bIsUserBlockedFromFaceId     = false

                self.xcgLogMsg("\(sCurrMethodDisp) 'sLookupUserName' of [\(sLookupUserName)] was found in the valid (\(jmAppParseCoreManager.dictPFAdminsDataItems.count)) login(s) dictionary - User CAN use 'FaceId' - set FaceId field...")

            }

        }
        
        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'pfAdminsSwiftDataItem' is [\(String(describing: pfAdminsSwiftDataItem))]...")
  
        return pfAdminsSwiftDataItem
  
    }   // End of private func locateUserDataInSwiftData()->PFAdminsSwiftDataItem?.

    private func authenticateViaFaceId() 
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'self.bIsFaceIdAuthenticated' is [\(self.bIsFaceIdAuthenticated)] - 'self.sFaceIdAuthenticationMessage' is [\(self.sFaceIdAuthenticationMessage)]...")

        // Check if the 'last' User 'login' has the FaceId 'blocked'...

        if (self.bIsUserBlockedFromFaceId == true)
        {

            self.bIsUserBlockedFromFaceId     = true
            self.bIsFaceIdAvailable           = false
            self.bIsFaceIdAuthenticated       = false
            self.sFaceIdAuthenticationMessage = "App 'user' is NOT allowed to use 'FaceId' Authentication"

            self.xcgLogMsg("\(sCurrMethodDisp) User can NOT use 'FaceId' - cleared the FaceId field(s) - Warning!")

            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'self.bIsUserBlockedFromFaceId' is [\(self.bIsUserBlockedFromFaceId)] - 'self.bIsFaceIdAvailable' is [\(self.bIsFaceIdAvailable)] - 'self.bIsFaceIdAuthenticated' is [\(self.bIsFaceIdAuthenticated)] - 'self.sFaceIdAuthenticationMessage' is [\(self.sFaceIdAuthenticationMessage)]...")

            return

        }

        // Check whether biometric authentication is possible...

        let laContext = LAContext()
        var error: NSError?

        self.bIsFaceIdAvailable = false

        if laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error:&error) 
        {

            // It's possible, so go ahead and use it...

            self.bIsFaceIdAvailable        = true
            let sFaceIdNeededReason:String = "We need to unlock your data."

            laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason:sFaceIdNeededReason) 
            { success, authenticationError in

                // Authentication has now completed...

                if success 
                {

                    // Authenticated successfully...

                    self.bIsFaceIdAuthenticated       = true
                    self.sFaceIdAuthenticationMessage = "App has been 'successfully' Authenticated"

                    self.xcgLogMsg("\(sCurrMethodDisp) \(self.sFaceIdAuthenticationMessage) - 'self.bIsFaceIdAuthenticated' is [\(self.bIsFaceIdAuthenticated)] - 'self.sFaceIdAuthenticationMessage' is [\(self.sFaceIdAuthenticationMessage)]...")

                } 
                else 
                {

                    // There was a problem...

                    self.bIsFaceIdAuthenticated       = false
                    self.sFaceIdAuthenticationMessage = "App has 'failed' Authentication - 'success' is [\(success)] - 'authenticationError' is [\(String(describing: authenticationError))]"

                    self.xcgLogMsg("\(sCurrMethodDisp) \(self.sFaceIdAuthenticationMessage) - 'self.bIsFaceIdAuthenticated' is [\(self.bIsFaceIdAuthenticated)] - 'self.sFaceIdAuthenticationMessage' is [\(self.sFaceIdAuthenticationMessage)]...")

                }

            }

        } 
        else 
        {

            // NO biometrics...

            self.bIsFaceIdAvailable           = false
            self.bIsFaceIdAuthenticated       = false
            self.sFaceIdAuthenticationMessage = "App has 'failed' Authentication - NO Biometrics (Face ID) are available"

            self.xcgLogMsg("\(sCurrMethodDisp) \(self.sFaceIdAuthenticationMessage) - 'self.bIsFaceIdAuthenticated' is [\(self.bIsFaceIdAuthenticated)] - 'self.sFaceIdAuthenticationMessage' is [\(self.sFaceIdAuthenticationMessage)]...")

        }

        // Exit...

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'self.bIsFaceIdAuthenticated' is [\(self.bIsFaceIdAuthenticated)] - 'self.sFaceIdAuthenticationMessage' is [\(self.sFaceIdAuthenticationMessage)]...")

        return

    }   // End of private func authenticateViaFaceId().

    private func isUserPasswordValidForLogin()->Bool
    {
  
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'sLoginUsername' is [\(self.sLoginUsername)] - 'sLoginPassword' is [\(self.sLoginPassword)]...")

        // Validate the 'login' credential(s)...

        self.sCredentialsCheckReason = ""

        var bUserLoginValidated:Bool = false
        var sValidUserName:String    = ""

        if (self.sLoginUsername.count > 0)
        {

            sValidUserName = self.sLoginUsername

        }

        // Flag that indicates whether or not we've 'validated' the Username...

        var bUserNameIsValid:Bool = false

        // Check SwiftData (1st) for a match on the User...

        let pfAdminsSwiftDataItem:PFAdminsSwiftDataItem? = self.locateUserDataInSwiftData()

        if (pfAdminsSwiftDataItem == nil)
        {

            self.sCredentialsCheckReason = "The Username '\(sValidUserName)' is 'invalid' - NOT found in 'Admins' <#1>"
            bUserLoginValidated          = false

        }
        else
        {

            bUserNameIsValid = true

            if let sValidUserPassword:String = pfAdminsSwiftDataItem?.sPFAdminsParsePassword
            {

                if (sValidUserPassword.count  > 0 &&
                    sValidUserPassword       == self.sLoginPassword)
                {

                    self.sCredentialsCheckReason = "User credential(s) are 'valid'"
                    bUserLoginValidated          = true

                }
                else
                {

                    self.sCredentialsCheckReason = "For the Username '\(sValidUserName)', the password is 'invalid'"
                    bUserLoginValidated          = false

                }

            }
            else
            {

                self.sCredentialsCheckReason = "The Username '\(sValidUserName)' is 'missing' a password in 'Admins' <#1>"
                bUserLoginValidated          = false

            }

        }
        
        // Handle the SwiftData valid credentials(s) action/response...

        if (bUserLoginValidated == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Supplied credential(s) have been successfully 'validated'- credential(s) are good - reason [\(sCredentialsCheckReason)]...")

            self.isUserLoggedIn.toggle()

            // Exit...

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'bUserLoginValidated' is [\(String(describing: bUserLoginValidated))]...")

            return bUserLoginValidated

        }

        // SwiftData didn't have a match on the User - try PFAdmins...

        let pfAdminsDataItem:ParsePFAdminsDataItem? = self.locateUserDataInPFAdmins()

        if (pfAdminsDataItem == nil)
        {

            if (bUserNameIsValid == false)
            {
            
                self.sCredentialsCheckReason = "The Username '\(sValidUserName)' is 'invalid' - NOT found in 'Admins' <#2>"
            
            }

            bUserLoginValidated = false

        }
        else
        {

            bUserNameIsValid = true

            if let sValidUserPassword:String = pfAdminsDataItem?.sPFAdminsParsePassword
            {

                if (sValidUserPassword.count  > 0 &&
                    sValidUserPassword       == self.sLoginPassword)
                {

                    self.sCredentialsCheckReason = "User credential(s) are 'valid'"
                    bUserLoginValidated          = true

                }
                else
                {

                    self.sCredentialsCheckReason = "For the Username '\(sValidUserName)', the password is 'invalid'"
                    bUserLoginValidated          = false

                }

            }
            else
            {

                self.sCredentialsCheckReason = "The Username '\(sValidUserName)' is 'missing' a password in 'Admins' <#2>"
                bUserLoginValidated          = false

            }

        }
        
        // Handle the valid/invalid credentials(s) action/response...

        if (bUserLoginValidated == true)
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Supplied credential(s) have been successfully 'validated'- credential(s) are good - reason [\(sCredentialsCheckReason)]...")

            self.isUserLoggedIn.toggle()

        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Supplied credential(s) have NOT been successfully 'validated' - credential(s) failure - reason [\(sCredentialsCheckReason)] - Error!")

            self.dumpUserAuthenticationDataToLog()

        //  self.sLoginPassword = ""

            self.isUserLoginFailureShowing.toggle()

        }
        
        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'bUserLoginValidated' is [\(String(describing: bUserLoginValidated))]...")
  
        return bUserLoginValidated
  
    }   // End of private func isUserPasswordValidForLogin()->Bool.

    private func dumpUserAuthenticationDataToLog()
    {
  
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // Dump the User data in SwiftData to the Log...

        self.xcgLogMsg("\(sCurrMethodDisp) Invoking 'self.jmAppSwiftDataManager.detailAppSwiftDataToLog()'...")

        self.jmAppSwiftDataManager.detailAppSwiftDataToLog()

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked  'self.jmAppSwiftDataManager.detailAppSwiftDataToLog()'...")

        // Dump the User data in PFAdminsDataItems to the Log...

        let jmAppParseCoreManager:JmAppParseCoreManager = self.getAppParseCoreManagerInstance()

        if (jmAppParseCoreManager.dictPFAdminsDataItems.count > 0)
        {

            for (_, parsePFAdminsDataItem) in jmAppParseCoreManager.dictPFAdminsDataItems
            {

                parsePFAdminsDataItem.displayParsePFAdminsDataItemToLog()

            }

        }
        else
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Unable to dump the PFAdminsData item(s) - the list is 'empty' - Warning!")

        }

        // Exit...
  
        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
  
        return
  
    }   // End of private func dumpUserAuthenticationDataToLog().

}   // End of struct AppAuthenticateView(View).

//  #Preview
//  {
//      
//      AppAuthenticateView()
//      
//  }

