//
//  AppConstants.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 06/01/22.
//

import Foundation
import UIKit
import SwiftUI

/// View String Constants
struct AppConstants {
    static let changedLanguage = "changedLanguage"
    static let language = "language"
    static let unlockAppScreen = "unlockAppScreen"
    static let remoteLanguage = "remoteLanguage"
    static let isDarkMode = "isDarkMode"
    
//    static var defaultLocale = "en-us"
    static var defaultLocale = RootViewModel.shared.getLocale()
    
    static let dashboardMaxCardCornerRadius = 12.0
    static let dashboardMinCardCornerRadius = 4.0

    static let courseCardWidth = UIScreen.main.bounds.width - UIScreen.main.bounds.width/3.5
    static let bundle: Bundle = Bundle.module
    
    // Used for course card's height
    static let cardHeightMd: CGFloat = 326
    static let cardHeightLg: CGFloat = 326

    static let usedId: String = "a42aa86d-9820-48c8-8a25-d36dd1da8d18"

    static let userUrl: String = "https://abo.net"
    
    public static let navbarHeight: Double = 46 + (UIApplication.shared.windows.last?.safeAreaInsets.top)!
}
