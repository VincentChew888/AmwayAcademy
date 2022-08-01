//
//  APIManger.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 25/03/22.
//

import Foundation

/// ABO Academy  endpoints
enum APIManger {
    
    case createUser
    case getWelcomeVideo
    case seenWelcomeVideo
    case fetchCourses
    case fetchCourseDetails
    case fetchLanguages
    case fetchContent
    case fetchStaticLabel
    case fetchExploreFilters
    case fetchCoursesCountForAppliedFilter
    case fetchCoursesForAppliedFilter
    case favUnFavCourses
    case getFavCourses
    case getSignedCookiesData
    case clearInProgressCourse
}

extension APIManger  {
    
    var baseURL: String {
        
        return Configuration.baseURL
    }
    
    var path: String {
        
        switch self {
        
        case .createUser:
            return baseURL + "/mw/api/v1/users"
        case .getWelcomeVideo:
            return baseURL + "/mw/api/v1/videos/welcome"
        case .seenWelcomeVideo:
            return baseURL + "/mw/api/v1/users/\(RootViewModel.shared.userDetails.amwayId)/videos/welcome"
        case .fetchCourses:
            return baseURL + "/mw/api/v1/users/\(RootViewModel.shared.userDetails.amwayId)/courses"
        case .fetchCourseDetails:
            return baseURL + "/mw/api/v1/users/\(RootViewModel.shared.userDetails.amwayId)/courses/"
        case .fetchCoursesForAppliedFilter:
            return baseURL + "/mw/api/v1/users/\(RootViewModel.shared.userDetails.amwayId)/courses/filter"
        case .fetchCoursesCountForAppliedFilter:
            return baseURL + "/mw/api/v1/users/\(RootViewModel.shared.userDetails.amwayId)/courses/filter-count"
            
         case .favUnFavCourses:
            return  baseURL + "/mw/api/v1/users/\(RootViewModel.shared.userDetails.amwayId)/courses/"
            
        case .getFavCourses:
            return  baseURL + "/mw/api/v1/favorites"
        case .clearInProgressCourse:
            return baseURL + "/mw/api/v1/users/\(RootViewModel.shared.userDetails.amwayId)/courses/"
        case .getSignedCookiesData:
            return baseURL + "/mw/api/v1/users/\(RootViewModel.shared.userDetails.amwayId)/courses/"
        case .fetchLanguages:
            return baseURL + "/mw/api/v1/languages"
        case .fetchContent:
            return baseURL + "/mw/api/v1/content/"
        case .fetchStaticLabel:
            return baseURL + "/mw/api/v1/static-labels"
        case .fetchExploreFilters:
            return baseURL + "/mw/api/v1/filter-params"
        
        }
    }
    
    var headers: [String : String]? {
        
        var headers : [String : String] = [:]
        
        headers["Content-Type"] = "application/json"
        headers["Accept"] = "application/json"
        headers["Authorization"] = RootViewModel.shared.data.accessToken
        
        return headers
    }    
}

