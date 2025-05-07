//
//  JmAppAlarmSoundManager.swift
//  JmUtils_Library
//
//  Created by Daryl Cox on 11/04/2024.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation
import AudioToolbox
import AVFoundation

// Implementation class to handle access to the APP 'alarm' Sound(s).

public class JmAppAlarmSoundManager: NSObject, AVAudioPlayerDelegate
{

    struct ClassInfo
    {

        static let sClsId        = "JmAppAlarmSoundManager"
        static let sClsVers      = "v1.0601"
        static let sClsDisp      = sClsId+".("+sClsVers+"): "
        static let sClsCopyRight = "Copyright (C) JustMacApps 2023-2025. All Rights Reserved."
        static let bClsTrace     = false
        static let bClsFileLog   = false

    }   // End of struct ClassInfo.

    // Class 'singleton' instance:

    static  let sharedJmAppAlarmSoundManager               = JmAppAlarmSoundManager()

    // App Data field(s):

    public  var avAudioPlayer:AVAudioPlayer?               = nil

            var jmAppDelegateVisitor:JmAppDelegateVisitor? = nil
                                                             // 'jmAppDelegateVisitor' MUST remain declared this way
                                                             // as having it reference the 'shared' instance of 
                                                             // JmAppDelegateVisitor causes a circular reference
                                                             // between the 'init()' methods of the 2 classes...

    // App <global> Message(s) 'stack' cached before XCGLogger is available:

            var listPreXCGLoggerMessages:[String]          = Array()

    override init()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        super.init()

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'jmAppDelegateVisitor' is [\(String(describing: self.jmAppDelegateVisitor))]...")
        
        // Finish any initialization...
        
        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'jmAppDelegateVisitor' is [\(String(describing: self.jmAppDelegateVisitor))]...")

        return

    }   // End of override init().

    public func terminateAppAlarmSounds()
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"

        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - 'jmAppDelegateVisitor' is [\(String(describing: self.jmAppDelegateVisitor))]...")

        // Handle App 'termination'...

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'jmAppDelegateVisitor' is [\(String(describing: self.jmAppDelegateVisitor))]...")

        return

    }   // End of public func terminateAppUserNotifications().

    private func xcgLogMsg(_ sMessage:String)
    {

        if (self.jmAppDelegateVisitor != nil)
        {

            if (self.jmAppDelegateVisitor!.bAppDelegateVisitorLogFilespecIsUsable == true)
            {

                self.jmAppDelegateVisitor!.xcgLogMsg(sMessage)

            }
            else
            {

                print("\(sMessage)")

                self.listPreXCGLoggerMessages.append(sMessage)

            }

        }
        else
        {

            print("\(sMessage)")

            self.listPreXCGLoggerMessages.append(sMessage)

        }

        // Exit:

        return

    }   // End of private func xcgLogMsg().

    public func toString() -> String
    {

        var asToString:[String] = Array()

        asToString.append("[")
        asToString.append("[")
        asToString.append("'sClsId': [\(ClassInfo.sClsId)],")
        asToString.append("'sClsVers': [\(ClassInfo.sClsVers)],")
        asToString.append("'sClsDisp': [\(ClassInfo.sClsDisp)],")
        asToString.append("'sClsCopyRight': [\(ClassInfo.sClsCopyRight)],")
        asToString.append("'bClsTrace': [\(ClassInfo.bClsTrace)],")
        asToString.append("'bClsFileLog': [\(ClassInfo.bClsFileLog)]")
        asToString.append("],")
        asToString.append("[")
        asToString.append("'avAudioPlayer': [\(String(describing: self.avAudioPlayer))]")
        asToString.append("],")
        asToString.append("]")

        let sContents:String = "{"+(asToString.joined(separator: ""))+"}"

        return sContents

    }   // End of public func toString().

    // (Call-back) Method to set the jmAppDelegateVisitor instance...

    public func setJmAppDelegateVisitorInstance(jmAppDelegateVisitor:JmAppDelegateVisitor)
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - supplied parameter 'jmAppDelegateVisitor' is [\(jmAppDelegateVisitor)]...")

        // Set the AppDelegateVisitor instance...

        self.jmAppDelegateVisitor = jmAppDelegateVisitor
    
        // Spool <any> pre-XDGLogger (via the AppDelegateVisitor) message(s) into the Log...

        if (self.listPreXCGLoggerMessages.count > 0)
        {

            self.xcgLogMsg("")
            self.xcgLogMsg("\(sCurrMethodDisp) <<< === Spooling the JmAppDelegateVisitor.XCGLogger 'pre' Message(s) from JmAppAlarmSoundManager === >>>")

            let sPreXCGLoggerMessages:String = self.listPreXCGLoggerMessages.joined(separator: "\n")

            self.xcgLogMsg(sPreXCGLoggerMessages)

            self.xcgLogMsg("\(sCurrMethodDisp) <<< === Spooled  the JmAppDelegateVisitor.XCGLogger 'pre' Message(s) from JmAppAlarmSoundManager === >>>")
            self.xcgLogMsg("")

        }

        // Finish performing any setup...

    #if os(iOS)

        self.xcgLogMsg("\(sCurrMethodDisp) Set the Sound 'playback' category...")

        do 
        {

            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)

            self.xcgLogMsg("\(sCurrMethodDisp) Sound 'playback' category has been set...")

        } 
        catch let error as NSError
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Failed to set the Sound 'playback' category - Details: [\(error.localizedDescription)] - Error!")

        }

        self.xcgLogMsg("\(sCurrMethodDisp) Set the Sound 'playback' instance 'active'...")

        do 
        {

            try AVAudioSession.sharedInstance().setActive(true)

            self.xcgLogMsg("\(sCurrMethodDisp) Sound 'playback' instance has been set 'active'...")

        } 
        catch let error as NSError
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Failed to set the Sound 'playback' instance 'active' - Details: [\(error.localizedDescription)] - Error!")

        }

    #endif
        
        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting - 'self.jmAppDelegateVisitor' is [\(String(describing: self.jmAppDelegateVisitor))]...")
    
        return

    } // End of public func setJmAppDelegateVisitorInstance().

    // Method(s) for manipulating 'alarm' sound(s)...

    public func jmAppAlarmManagerStartPlayingSound(_ soundName:String = "bell") 
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - supplied parameter 'soundName' is [\(soundName)]...")

        // --------------------------------------------------------------------------------------------------
        // <macOS>:
        //  The only macOS system sounds that can be used are those documented, 
        //  System Sounds in Apple's documentation -> i.e.:
        //    'kSystemSoundID_FlashScreen' and
        //    'kSystemSoundID_UserPreferredAlert'.
        //
        //  Code:
        //      AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_UserPreferredAlert))
        //      AudioServicesRemoveSystemSoundCompletion(SystemSoundID(kSystemSoundID_UserPreferredAlert))
        // --------------------------------------------------------------------------------------------------

        // ...

        // --------------------------------------------------------------------------------------------------
        // <iOS>:
        // --------------------------------------------------------------------------------------------------

        // First: 'Vibrate' the phone...

        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))

        // Second: Set the 'vibrate' callback

        AudioServicesAddSystemSoundCompletion(SystemSoundID(kSystemSoundID_Vibrate), 
                                              nil, 
                                              nil,
                                              { (_:SystemSoundID, _:UnsafeMutableRawPointer?) -> Void in

                                                  AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))

                                              },
                                              nil)

        // Third: Locate the URL for the 'sound'...

        guard let sSoundFilepath:String = Bundle.main.path(forResource:soundName, ofType:"mp3") 
        else 
        {

            self.xcgLogMsg("\(sCurrMethodDisp) Unable to find the resource [\(soundName).mp3] in Bundle.main.path - Error!")

            // Exit:

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
        
            return

        }

        // Fourth: Create an AVAudioPlayer on the 'sound' URL...

        let urlSoundFilepath:URL = URL(fileURLWithPath:sSoundFilepath)
        
        do 
        {

            self.avAudioPlayer = try AVAudioPlayer(contentsOf:urlSoundFilepath)

        } 
        catch let error as NSError 
        {

            self.avAudioPlayer = nil

            self.xcgLogMsg("\(sCurrMethodDisp) Failed to create an AVAudioPlayer on the 'sound' URL of [\(urlSoundFilepath)] - Details: [\(error.localizedDescription)] - Error!")

            // Exit:

            self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")

            return

        }

        // Fifth: Set the 'delegate' (to 'self') and start playing the 'sound'...
        
        if self.avAudioPlayer != nil 
        {

            // Note: A negative number means to loop to infinity...

        //  self.avAudioPlayer?.numberOfLoops = 2
        //  self.avAudioPlayer?.numberOfLoops = 0
            self.avAudioPlayer?.numberOfLoops = -1
            self.avAudioPlayer?.delegate      = self

            self.avAudioPlayer?.prepareToPlay()
            self.avAudioPlayer?.play()

        }
        
        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
    
        return

    }   // End of public func jmAppAlarmManagerStartPlayingSound(_ soundName:String).

    public func jmAppAlarmManagerStopPlayingSound() 
    {

        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked...")

        // First: Stop playing the sound...

        if self.avAudioPlayer != nil 
        {

            self.avAudioPlayer?.stop()

        }

        // Second: Stop the 'vibrate' callback...

        AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate)

        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
    
        return

    }   // End of public func jmAppAlarmManagerStopPlayingSound().

    // Method(s) 'required' by the AVAudioPlayerDelegate for a 'delegate'...

    public func audioPlayerDidFinishPlaying(_ player:AVAudioPlayer, successfully flag:Bool) 
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'flag' is [\(flag)]...")
        
        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
    
        return

    }   // End of func audioPlayerDidFinishPlaying(_ player:AVAudioPlayer, successfully flag:Bool).
    
    public func audioPlayerDecodeErrorDidOccur(_ player:AVAudioPlayer, error:Error?) 
    {
        
        let sCurrMethod:String = #function
        let sCurrMethodDisp    = "\(ClassInfo.sClsDisp)'"+sCurrMethod+"':"
        
        self.xcgLogMsg("\(sCurrMethodDisp) Invoked - parameter 'error' is [\(String(describing: error))]...")
        
        // Exit:

        self.xcgLogMsg("\(sCurrMethodDisp) Exiting...")
    
        return

    }   // End of public func audioPlayerDecodeErrorDidOccur(_ player:AVAudioPlayer, error:Error?).

}   // End of public class JmAppAlarmSoundManager.

