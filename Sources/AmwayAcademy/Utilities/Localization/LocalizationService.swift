//
//  LocalizationService.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 06/01/22.
//

import Foundation

class LocalizationService {

    static let shared = LocalizationService()
    static let changedLanguage = Notification.Name(AppConstants.changedLanguage)

    private init() {}
    
    var language: Languages {
        get {
            guard let languageString = UserDefaults.standard.string(forKey: AppConstants.language) else {
                return .english_us
            }
            return Languages(rawValue: languageString) ?? .english_us
        }
        set {
            if newValue != language {
                UserDefaults.standard.setValue(newValue.rawValue, forKey: AppConstants.language)
                NotificationCenter.default.post(name: LocalizationService.changedLanguage, object: nil)
            }
        }
    }
}
