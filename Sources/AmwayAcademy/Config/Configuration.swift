//
//  Configuration.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 21/12/21.
//

import Foundation

enum Configuration: String {

    // MARK: - Configurations
    case dev
    case qa
    case uat
    case production

    // MARK: - Current Configuration
    static let current: Configuration = {
//        guard let rawValue = AppConstants.bundle.infoDictionary?["Configuration"] as? String else {
//            fatalError("No Configuration Found")
//        }
        let rawValue = RootViewModel.shared.data.env

        guard let configuration = Configuration(rawValue: rawValue.lowercased()) else {
            fatalError("Invalid Configuration")
        }

        return configuration
    }()
    
    //TODO: - Add the base URLs here for different envs
    // MARK: - Base URL
    static var baseURL: String {
        switch current {
        case .dev:
            return "https://dev.api.tw.academy.amway.com"
        case .uat:
         return "https://qa.api.tw.academy.amway.com"
        case .qa:
            return "https://qa.api.tw.academy.amway.com"
        case .production:
            return "https://api.tw.academy.amway.com"
        }
    }
    
    

}
