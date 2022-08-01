//
//  WebServiceManager.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 27/12/21.
//

import Foundation
import Alamofire
import Amway_Base_Utility

enum APIState : Equatable {
    case Loading
    case none
    case success
    case failure(Failure)
}
enum Failure {
    case ApiError
    case Offline
}

enum ServiceType {
    
   // case FetchServiceAccessToken
    case createUser
    case getWelcomeVideo
    case seenWelcomeVideo
    case getCourses
    case getCourseDetails
    case fetchLanguage
    case fetchStaticLabel
    case getExploreFilters
    case getCoursesCountForAppliedFilters
    case getCoursesForAppliedFilters
    case favourite
    case getfavorite
    case getSignedCookiesData
    case clearInProgressCourse
}

typealias ServiceRequestSuccessBlock  = (_ result:Any) -> Void
typealias ServiceRequestFailureBlock  = (_ failurError:NSError) -> Void
typealias ServiceRequestOfflineBlock  = (_ offline:NSError) -> Void

// Manages the service calls throughout the app

class WebServiceManager : NSObject {
    
    static var shared = WebServiceManager()
    weak var alamofireManager : AlamofireManager? = AlamofireManager.shared
    
    private override init() {
        super.init()
    }
    
    func sendRequest(serviceType : ServiceType,
                     params : [String : Any],
                     bodyParams : [String : Any] = [:],
                     success: @escaping ServiceRequestSuccessBlock,
                     failure: @escaping ServiceRequestFailureBlock,
                     offline: @escaping ServiceRequestOfflineBlock){
        
        // Provision for custom tokens
        let accessToken = ""
        AmwayAppLogger.generalLogger.debug("SERVICE TYPE IS - \(serviceType)")
        
        switch serviceType {
        
//        case .FetchServiceAccessToken:
//            sendAccessTokenRequest(headers: headers, accessToken: accessToken, serviceType: serviceType, params: params, success: success, failure: failure, offline: offline)
        case .createUser:
            createUser(params: params, success: success, failure: failure, offline: offline)
        case .getWelcomeVideo:
            getWelcomeVideo(params: params, success: success, failure: failure, offline: offline)
        case .seenWelcomeVideo:
            seenWelcomeVideo(success: success, failure: failure, offline: offline)
        case .getCourses:
            getCourses(params: params, success: success, failure: failure, offline: offline)
        case .getCourseDetails:
            getCourseDetails(params: params, success: success, failure: failure, offline: offline)
        case .fetchLanguage:
            fetchLanguage(params: params, success: success, failure: failure, offline: offline)
        case .fetchStaticLabel:
            fetchStaticLabel(params: params, success: success, failure: failure, offline: offline)
        case .getExploreFilters:
            getExploreFilters(params: params, success: success, failure: failure, offline: offline)
        case .getCoursesCountForAppliedFilters:
            getCoursesCountForAppliedFilters(queryParams: params, bodyParams: bodyParams, success: success, failure: failure, offline: offline)
        case .getCoursesForAppliedFilters:
            getCoursesForAppliedFilters(queryParams: params, bodyParams: bodyParams, success: success, failure: failure, offline: offline)
        case .favourite:
            favourite(params: params, success: success, failure: failure, offline: offline)
        case .getfavorite :
            getfavorites(params: params, success: success, failure: failure, offline: offline)
        case .getSignedCookiesData:
            getSignedCookiesData(params: params, success: success, failure: failure, offline: offline)
        case .clearInProgressCourse:
            clearInProgressCourse(params: params, success: success, failure: failure, offline: offline)

        }
    }
    
    
    //MARK:- Token Requests
    
    // Fetch Access Token
    //
//    private func sendAccessTokenRequest(url: String, headers: [String : Any], accessToken : String, serviceType : ServiceType, params: [String : Any], success: @escaping ServiceRequestSuccessBlock, failure: @escaping ServiceRequestFailureBlock, offline: @escaping ServiceRequestOfflineBlock) {
//
//        let header : [String : String] = headers as! [String : String]
//        let url = Amway_Base_Utility.CommonUtils.getURLFromString(urlString: url)
//        let httpHeaders = HTTPHeaders.init(header)
//
//        alamofireManager?.makeAPIRequest(urlRequest: url, parameters: params, methodType: .post, encodingType: URLEncoding.default, headers: httpHeaders, success: { (response) in
//
//            /*
//            // Save Token into Keychain & Token Manager
//            TokenManager.shared.saveAccessTokenToKeychain(response: response , key: APIConstants.keys.keychainIDForTokens)*/
//            success(response)
//
//        }) { (error) in
//            failure(error as NSError)
//        }
//    }
    
    
    private func getCourses(params: [String : Any], success: @escaping ServiceRequestSuccessBlock, failure: @escaping ServiceRequestFailureBlock, offline: @escaping ServiceRequestOfflineBlock) {
        
        let header : [String : String] = APIManger.fetchCourses.headers!
        let categoryId = params["categoryId"] as? String
        if let courseType =  params["courseType"]  as? String,
           let isDashboard = params["isDashboard"] as? Bool,
           let pageSize = params["pageSize"] as? Int,
           let pageNumber = params["pageNumber"] as? Int,
           let locale = params["locale"] as? String,
           let sortBy = params["sortBy"] as? String {
            
            let temp = courseType.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            var url = APIManger.fetchCourses.path + "?courseType=\(temp!)&isDashboard=\(isDashboard)&page=\(pageNumber)&size=\(pageSize)&locale=\(locale)&sortBy=\(sortBy)"
            if categoryId != nil {
                url.append("&categoryId=\(categoryId!)")
            }
            
            let httpHeaders = HTTPHeaders.init(header)
            
            alamofireManager?.makeAPIRequest(urlRequest: url, parameters: [:], methodType: .get, encodingType: URLEncoding.default, headers: httpHeaders, success: { (response) in
                
                /*
                 // Save Token into Keychain & Token Manager
                 TokenManager.shared.saveAccessTokenToKeychain(response: response , key: APIConstants.keys.keychainIDForTokens)*/
                success(response)
                
            }) { (error) in
                failure(error as NSError)
            }
        }
    }
    
    
    private func getFavorite(params: [String : Any], success: @escaping ServiceRequestSuccessBlock, failure: @escaping ServiceRequestFailureBlock, offline: @escaping ServiceRequestOfflineBlock) {
        
        let header : [String : String] = APIManger.fetchCourses.headers!
        
        if let courseType =  params["courseType"]  as? String,
           let isDashboard = params["isDashboard"] as? Bool,
           let pageSize = params["pageSize"] as? Int,
           let pageNumber = params["pageNumber"] as? Int,
           let locale = params["locale"] as? String {
            
            
            let temp = courseType.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            let url = APIManger.fetchCourses.path + "?courseType=\(temp!)&isDashboard=\(isDashboard)&page=\(pageNumber)&size=\(pageSize)&locale=\(locale)"
            
            let httpHeaders = HTTPHeaders.init(header)
            
            alamofireManager?.makeAPIRequest(urlRequest: url, parameters: [:], methodType: .get, encodingType: URLEncoding.default, headers: httpHeaders, success: { (response) in
                
                /*
                 // Save Token into Keychain & Token Manager
                 TokenManager.shared.saveAccessTokenToKeychain(response: response , key: APIConstants.keys.keychainIDForTokens)*/
                success(response)
                
            }) { (error) in
                failure(error as NSError)
            }
        }
    }
    
    
    private func getfavorites(params: [String : Any], success: @escaping ServiceRequestSuccessBlock, failure: @escaping ServiceRequestFailureBlock, offline: @escaping ServiceRequestOfflineBlock) {
        
        let header : [String : String] = APIManger.fetchCourses.headers!
        
            let url = APIManger.getFavCourses.path + "?userId=\(RootViewModel.shared.userDetails.amwayId)"
            
            let httpHeaders = HTTPHeaders.init(header)
            
            alamofireManager?.makeAPIRequest(urlRequest: url, parameters: [:], methodType: .get, encodingType: URLEncoding.default, headers: httpHeaders, success: { (response) in
                
                /*
                 // Save Token into Keychain & Token Manager
                 TokenManager.shared.saveAccessTokenToKeychain(response: response , key: APIConstants.keys.keychainIDForTokens)*/
                success(response)
                
            }) { (error) in
                failure(error as NSError)
            }
        //}
    }
    
    private func fetchLanguage(params: [String : Any], success: @escaping ServiceRequestSuccessBlock, failure: @escaping ServiceRequestFailureBlock, offline: @escaping ServiceRequestOfflineBlock) {
        
        let header : [String : String] = APIManger.fetchLanguages.headers!
        
        let url = APIManger.fetchLanguages.path
            
            let httpHeaders = HTTPHeaders.init(header)
            
            alamofireManager?.makeAPIRequest(urlRequest: url, parameters: params, methodType: .get, encodingType: URLEncoding.default, headers: httpHeaders, success: { (response) in
                
                /*
                 // Save Token into Keychain & Token Manager
                 TokenManager.shared.saveAccessTokenToKeychain(response: response , key: APIConstants.keys.keychainIDForTokens)*/
                success(response)
                
            }) { (error) in
                failure(error as NSError)
            }
        //}
    }
    
    
    private func favourite(params: [String : Any], success: @escaping ServiceRequestSuccessBlock, failure: @escaping ServiceRequestFailureBlock, offline: @escaping ServiceRequestOfflineBlock) {
        
        let header : [String : String] = APIManger.favUnFavCourses.headers!
        
        if let courseId =  params["courseId"]  as? String,
           let favorited =  params["favorited"]  as? Bool {
            
            let url = APIManger.favUnFavCourses.path + "\(courseId)" + "/favorite?isFavorite=\(favorited)"
            
            let httpHeaders = HTTPHeaders.init(header)
            
            alamofireManager?.makeAPIRequest(urlRequest: url, parameters: [:], methodType: .patch, encodingType: JSONEncoding.default, headers: httpHeaders, success: { (response) in
                
                /*
                 // Save Token into Keychain & Token Manager
                 TokenManager.shared.saveAccessTokenToKeychain(response: response , key: APIConstants.keys.keychainIDForTokens)*/
                success(response)
                
            }) { (error) in
                failure(error as NSError)
            }
        }
    }
    
    
    private func fetchStaticLabel(params: [String : Any], success: @escaping ServiceRequestSuccessBlock, failure: @escaping ServiceRequestFailureBlock, offline: @escaping ServiceRequestOfflineBlock) {
        
        let header : [String : String] = APIManger.fetchStaticLabel.headers!
        
        if let locale =  params["locale"]  as? String {
            let url = APIManger.fetchStaticLabel.path + "?locale=\(locale)"
                
                let httpHeaders = HTTPHeaders.init(header)
                
                alamofireManager?.makeAPIRequest(urlRequest: url, parameters: [:], methodType: .get, encodingType: URLEncoding.default, headers: httpHeaders, success: { (response) in
                    
                    /*
                     // Save Token into Keychain & Token Manager
                     TokenManager.shared.saveAccessTokenToKeychain(response: response , key: APIConstants.keys.keychainIDForTokens)*/
                    success(response)
                    
                }) { (error) in
                    failure(error as NSError)
                }
        }
    }
    
    
    private func getCourseDetails(params: [String : Any], success: @escaping ServiceRequestSuccessBlock, failure: @escaping ServiceRequestFailureBlock, offline: @escaping ServiceRequestOfflineBlock) {
        
        let header : [String : String] = APIManger.fetchCourseDetails.headers!
        if let courseID =  params["course_id"]  as? String {
            var url = ""
            var Qparams:[String: Any] = [:]
            if let locale =  params["locale"]  as? String {
            url = APIManger.fetchCourseDetails.path + courseID
            Qparams.updateValue(locale, forKey: "locale")
            }else{
            url = APIManger.fetchCourseDetails.path + courseID
            }
        
        let httpHeaders = HTTPHeaders.init(header)
        
            alamofireManager?.makeAPIRequest(urlRequest: url, parameters: Qparams, methodType: .get, encodingType: URLEncoding.default, headers: httpHeaders, success: { (response) in
            
            /*
            // Save Token into Keychain & Token Manager
            TokenManager.shared.saveAccessTokenToKeychain(response: response , key: APIConstants.keys.keychainIDForTokens)*/
            success(response)
            
        }) { (error) in
            failure(error as NSError)
         }
        }else{
            AmwayAppLogger.generalLogger.debug("Course Id not found")
        }
    }
}

extension WebServiceManager {
    
    private func getExploreFilters(params: [String : Any], success: @escaping ServiceRequestSuccessBlock, failure: @escaping ServiceRequestFailureBlock, offline: @escaping ServiceRequestOfflineBlock) {
        
        let header : [String : String] = APIManger.fetchExploreFilters.headers!
        
        if let locale = params["locale"] as? String {
            
            let url = APIManger.fetchExploreFilters.path + "?locale=\(locale)"
            
            let httpHeaders = HTTPHeaders.init(header)
            
            alamofireManager?.makeAPIRequest(urlRequest: url, parameters: [:], methodType: .get, encodingType: URLEncoding.default, headers: httpHeaders, success: { (response) in

                success(response)
                
            }) { (error) in
                
                failure(error as NSError)
                
            }
        }
    }
    
    private func getCoursesCountForAppliedFilters(queryParams: [String : Any], bodyParams: [String : Any], success: @escaping ServiceRequestSuccessBlock, failure: @escaping ServiceRequestFailureBlock, offline: @escaping ServiceRequestOfflineBlock) {
        
        let header : [String : String] = APIManger.fetchCoursesCountForAppliedFilter.headers!
        
        if let locale = queryParams["locale"] as? String {
            
            let url = APIManger.fetchCoursesCountForAppliedFilter.path + "?locale=\(locale)"
            
            let httpHeaders = HTTPHeaders.init(header)
            
            alamofireManager?.makeAPIRequest(urlRequest: url, parameters: bodyParams, methodType: .post, encodingType: JSONEncoding.default, headers: httpHeaders, success: { (response) in
            
                success(response)
                
            }) { (error) in
                
                failure(error as NSError)
                
            }
        }
    }
    
    private func getCoursesForAppliedFilters(queryParams: [String : Any], bodyParams: [String : Any], success: @escaping ServiceRequestSuccessBlock, failure: @escaping ServiceRequestFailureBlock, offline: @escaping ServiceRequestOfflineBlock) {
        
        let header : [String : String] = APIManger.fetchCoursesForAppliedFilter.headers!
        
        if let locale = queryParams["locale"] as? String {
            
            let url = APIManger.fetchCoursesForAppliedFilter.path + "?locale=\(locale)"
            
            let httpHeaders = HTTPHeaders.init(header)
            
            alamofireManager?.makeAPIRequest(urlRequest: url, parameters: bodyParams, methodType: .post, encodingType: JSONEncoding.default, headers: httpHeaders, success: { (response) in
            
                success(response)
                
            }) { (error) in
                
                failure(error as NSError)
                
            }
        }
    }
    
    private func getSignedCookiesData(params: [String : Any], success: @escaping ServiceRequestSuccessBlock, failure: @escaping ServiceRequestFailureBlock, offline: @escaping ServiceRequestOfflineBlock) {
        
        let header : [String : String] = APIManger.getSignedCookiesData.headers!
        
        if let courseID =  params["course_id"]  as? String {
            
            var url = ""
            var Qparams:[String: Any] = [:]
            if let locale =  params["locale"]  as? String {
                
                url = APIManger.getSignedCookiesData.path + courseID + "/start"
                Qparams.updateValue(locale, forKey: "locale")
                
            } else {
                url = APIManger.getSignedCookiesData.path + courseID + "/start"
            }
            
            let httpHeaders = HTTPHeaders.init(header)
            
            alamofireManager?.makeAPIRequest(urlRequest: url, parameters: Qparams, methodType: .get, encodingType: URLEncoding.default, headers: httpHeaders, success: { (response) in
                
                success(response)
                
            }) { (error) in
                failure(error as NSError)
            }
        } else {
            AmwayAppLogger.generalLogger.debug("Course Id not found")
        }
    }
    
    private func getWelcomeVideo(params: [String : Any], success: @escaping ServiceRequestSuccessBlock, failure: @escaping ServiceRequestFailureBlock, offline: @escaping ServiceRequestOfflineBlock) {
        
        let header : [String : String] = APIManger.getWelcomeVideo.headers!
        
        if let locale = params["locale"] as? String {
            
            let url = APIManger.getWelcomeVideo.path + "?locale=\(locale)"
            
            let httpHeaders = HTTPHeaders.init(header)
            
            alamofireManager?.makeAPIRequest(urlRequest: url, parameters: [:], methodType: .get, encodingType: URLEncoding.default, headers: httpHeaders, success: { (response) in

                success(response)

            }) { (error) in
                
                failure(error as NSError)
                
            }
        }
    }
    
    private func seenWelcomeVideo(success: @escaping ServiceRequestSuccessBlock, failure: @escaping ServiceRequestFailureBlock, offline: @escaping ServiceRequestOfflineBlock) {
        
        let header : [String : String] = APIManger.seenWelcomeVideo.headers!
        
        let url = APIManger.seenWelcomeVideo.path

        let httpHeaders = HTTPHeaders.init(header)
        
        alamofireManager?.makeAPIRequest(urlRequest: url, parameters: [:], methodType: .patch, encodingType: JSONEncoding.default, headers: httpHeaders, success: { (response) in
            
            success(response)
            
        }) { (error) in
            
            failure(error as NSError)
            
        }
    }

    private func clearInProgressCourse(params: [String : Any], success: @escaping ServiceRequestSuccessBlock, failure: @escaping ServiceRequestFailureBlock, offline: @escaping ServiceRequestOfflineBlock) {
        
        let header : [String : String] = APIManger.clearInProgressCourse.headers!
        
        if let courseId = params["courseId"] as? String {
            
            let url = APIManger.clearInProgressCourse.path + "\(courseId)"
            
            let httpHeaders = HTTPHeaders.init(header)
            
            alamofireManager?.makeAPIRequest(urlRequest: url, parameters: [:], methodType: .patch, encodingType: JSONEncoding.default, headers: httpHeaders, success: { (response) in

                success(response)

            }) { (error) in
                
                failure(error as NSError)
                
            }
        }
    }
    
    private func createUser(params: [String : Any], success: @escaping ServiceRequestSuccessBlock, failure: @escaping ServiceRequestFailureBlock, offline: @escaping ServiceRequestOfflineBlock) {
        
        let header : [String : String] = APIManger.createUser.headers!
        
        let url = APIManger.createUser.path + "?isAdmin=false"
        let httpHeaders = HTTPHeaders.init(header)
        alamofireManager?.makeAPIRequest(urlRequest: url, parameters: params, methodType: .post, encodingType: JSONEncoding.default, headers: httpHeaders, success: { (response) in
            
            success(response)
        }) { (error) in
            
            failure(error as NSError)
        }
    }
}

