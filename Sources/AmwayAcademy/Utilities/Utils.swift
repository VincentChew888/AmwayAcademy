//
//  Utils.swift
//  ABOAcademy
//
//  Created by Swapnil Tilkari on 11/02/22.
//

import Foundation
import SwiftUI

class Utils {
    static func getMonthNameFromMonthNo(_ n: String) -> String {
        switch n {
            case "1":
                return "Jan"
            case "2":
                return "Feb"
            case "3":
                return "Mar"
            case "4":
                return "Apr"
            case "5":
                return "May"
            case "6":
                return "Jun"
            case "7":
                return "Jul"
            case "8":
                return "Aug"
            case "9":
                return "Sep"
            case "10":
                return "Oct"
            case "11":
                return "Nov"
            case "12":
                return "Dec"
            default:
                return ""
        }
    }
    
//    static func getStaticLabelKey(fromValue val: String) -> String {
//        switch val {
//        case "In Progress":
//            return "txtInProgress"
//        case "Required":
//            return "txtRequired"
//        case "Shared":
//            return "txtShared"
//        case "Favorite":
//            return "txtFavorite"
//        case "Downloaded":
//            return "txtDownloaded"
//        case "Completed":
//            return "txtCompleted"
//        default:
//            return ""
//        }
//    }
}
