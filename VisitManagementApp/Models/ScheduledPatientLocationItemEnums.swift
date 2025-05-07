//
//  ScheduledPatientLocationItemEnums.swift
//  JustAFirstSwiftDataApp1
//
//  Created by Daryl Cox on 04/18/2025 - v1.0103.
//  Copyright © JustMacApps 2023-2025. All rights reserved.
//

import Foundation

enum InsuranceType: String, CaseIterable 
{

    case NoInsurance         = "NoInsurance"         // 0:none
    case PrivatePay          = "PrivatePay"          // 1:private
    case TMHP                = "TMHP"                // 2:medicaid
    case ParklandComm        = "ParklandComm"        // 3:medicaid
    case ParklandCHIP        = "ParklandCHIP"        // 4:chip
    case Cigna               = "Cigna"               // 5:private
    case BCBSTX              = "BCBSTX"              // 6:private
    case Superior            = "Superior"            // 7:medicaid
    case Molina              = "Molina"              // 8:medicaid
    case Amerigroup          = "Amerigroup"          // 9:medicaid
    case United              = "United"              // 10:private
    case Aetna               = "Aetna"               // 11:private
    case CookComm            = "CookComm"            // 12:medicaid
    case CookCHIP            = "CookCHIP"            // 13:chip
    case UMR                 = "UMR"                 // 14:private
    case AmerigroupCHIP      = "AmerigroupCHIP"      // 15:chip
    case TMHPSSI             = "TMHPSSI"             // 16:medicaid
    case TRICARE             = "TRICARE"             // 17:private
    case TexasChildrens      = "TexasChildrens"      // 18:medicaid
    case AmerigroupSSI       = "AmerigroupSSI"       // 19:medicaid
    case AetnaMedicaid       = "AetnaMedicaid"       // 20:medicaid
    case AetnaChip           = "AetnaChip"           // 21:chip
    case ArkansasBCBS        = "ArkansasBCBS"        // 22:private
    case ChildrensMed        = "ChildrensMed"        // 23:medicaid
    case CookStar            = "CookStar"            // 24:medicaid
    case UnitedMedicare      = "UnitedMedicare"      // 25:private
    case TennesseeBCBS       = "TennesseeBCBS"       // 26:private
    case AlabamaBCBS         = "AlabamaBCBS"         // 27:private
    case MolinaCHIP          = "MolinaCHIP"          // 28:chip
    case TCHPCHIP            = "TCHPCHIP"            // 29:chip
    case CookStarKids        = "CookStarKids"        // 30:medicaid
    case Humana              = "Humana"              // 31:private
    case CSHCN               = "CSHCN"               // 32:private
    case AmerigroupWellPoint = "AmerigroupWellPoint" // 33:private

}   // End of enum InsuranceType:String,CaseIterable.

enum ScheduleType: String, CaseIterable
{
    
    case undefined = "Undefined"
    case pastdate  = "PastDate"
    case scheduled = "Scheduled"
    case done      = "Done"
    case dateError = "DateError"
    case missed    = "Missed"
    
}   // End of enum ScheduleType:String,CaseIterable.

