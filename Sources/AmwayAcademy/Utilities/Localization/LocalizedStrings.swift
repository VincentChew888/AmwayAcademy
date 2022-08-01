//
//  LocalizedStrings.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 06/01/22.
//

import Foundation
import SwiftUI

struct LocalizedStrings {
    
    @AppStorage(AppConstants.language)
    static var language = LocalizationService.shared.language
    
    struct HomeScreen {
        static let welcomeVCTitle = "AmwayTitle"
        static let home = "HomeTitle"
        static let amwayTitle = "HomeSubtitle"
        static let englishButtonTitle = "English"
        static let spanishButtonTitle = "Spanish"
        static let changeLanguageFeature = "ChangeLanguageFeature"
        static let takeScreenshotFeature = "TakeScreenshotFeature"
        static let screenshotAndFeebackDemoButtonTitle = "Screenshot&FeedbackDemo"
        static let remoteLocalisationFeature = "RemoteLocalisationFeature"
        static let dynatraceUserPrivacySettings = "DynatraceUserPrivacySettings"
        static let dynatraceSettings = "DynatraceSettings"
        static let realTimeVideo = "RealTimeVideo"
        static let logoutFeatureTextTitle = "LogoutFeature"
        static let logoutButtonText = "Logout"
        static let locationButtonText = "GeoLocation"
        static let qrScannerButtonText = "QR code scanner"
        static let darkMode = "darkMode"
        static let cameraAndGallery = "cameraAndGallery"
        static let offlineSync = "offlineSync"
        static let offlineProducts = "offlineProducts"
    }
    
    struct CommonConstants {
        static let errorLabel = "Error"
        static let okLabel = "OK"
        static let noLabel = "NO"
        static let cancelButtonLabel = "Cancel"
        static let homeLabel = "HomeTitle"
        static let appUpgradeLabel = "AppUpgradeKey"
        static let upgradeLabel = "Upgrade"
        static let appUpdateLabel = "App Update"
        static let updateLabel = "Update"
        static let settingsLabel = "Settings"
    }
    
    struct LoginViewConstants {
        static let signInTitle = "SignInTitle"
        static let loginIDTitle = "LoginIDTitle"
        static let usernamePlaceHolder = "UsernamePlaceHolder"
        static let passwordPlaceHolder = "PasswordPlaceHolder"
        static let forgotPasswordTitle = "ForgotPasswordTitle"
        static let signInButtonTitle = "SignInButtonTitle"
        static let fingerprint = "UseFingerprint"
        static let useFaceID = "UseFaceID"
        static let enrollForBioAuth = "EnrollForBioAuth"
        static let firstTimeSignIn = "FirstTimeSignIn"
        static let biometricAuthFailed = "BiometricAuthFailed"
        static let permission = "Permission"
        static let loginPermissionText = "LoginPermissionText"
    }
    
    struct EditView {
        static let errorWhileSendingMail = "ErrorWhileSendingMail"
    }
    
    struct OktaLoginView {
        static let oktaLoginViewSignInTitle = "OktaLoginViewSignInTitle"
        static let loginCredentialSubtitle = "LoginCredentialSubtitle"
        static let signInWithOkta = "SignInWithOkta"
    }
    
    struct DynatraceView {
        static let dynatrace = "Dynatrace"
        static let userPrivacySettings = "UserPrivacySettings"
        static let dataCollectionLevel = "DataCollectionLevel"
        static let crashReportingOptedIn = "CrashReportingOptedIn"
        static let crashReplayOptedIn = "CrashReplayOptedIn"
        static let applyUserPrivacyOptions = "ApplyUserPrivacyOptions"
    }
    
    struct BrightcoveView {
        static let brightcoveVideoPlayingTitle = "BrightcoveVideoPlayingTitle"
    }
    
    struct DarkModeView {
        static let selectDarkMode = "selectDarkMode"
    }
    
    struct GeoLocation {
        static let currentLocationTitle = "currentLocationTitle"
        static let latitudeLabel = "latitudeLabel"
        static let longitudeLabel = "longitudeLabel"
        static let areaLabel = "areaLabel"
        static let cityLabel = "cityLabel"
        static let stateLabel = "stateLabel"
        static let countryLabel = "countryLabel"
        static let pincodeLabel = "pincodeLabel"
    }
    
    struct QRScan {
        static let scanCodeLabel = "scanCodeLabel"
        static let scanCodeToBegainLabel = "scanCodeToBegainLabel"
        static let qrCodeResultLabel = "qrCodeResultLabel"
    }
    
    struct CameraAndGallery {
        static let selectPhoto = "selectPhoto"
        static let choose = "choose"
        static let fromGallery = "fromGallery"
        static let takePhoto = "takePhoto"
    }
    
}
