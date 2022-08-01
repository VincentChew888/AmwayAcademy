//
//  DashboardViewModel.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 01/02/22.
//

import Foundation
import Amway_Base_Utility

public enum DashboardCard {
    
    case welcomeVideoCard
    case requiredCoursesCard
    case assignedCoursesCard
    case inProgressCoursesCard
    case coursesForYouCard
    case exploreCard
    case quickStartCoursesCard
    case learningPathCard
    case myCourses
    case noCard
}

enum SortBy: String, CaseIterable {
    
    case most_relevant = "txtMostRelevant"
    case a_z = "txtAToZ"
    case z_a = "txtZToA"
    case newest_to_oldest = "txtNewestToOldest"
    case oldest_to_newest = "txtOldestToNewest"
    
    
    var description: String {
        if let enumValue = SortBy(rawValue: self.rawValue) {
            return (String(describing: enumValue))
        } else {
            return "most_relevant"
        }
    }
}

class DashboardViewModel: ObservableObject {
    static let shared = DashboardViewModel()
    
    var selectedCourseSection: DashboardCard?
    @Published var selectedCourse: CourseModel = CourseModel()
    @Published var courses : [CourseModel] = []
    @Published var coursesResponse : [CourseModel] = []
    @Published var welcomeResponse : WelcomeVideoModel = WelcomeVideoModel()
    
    @Published var quickStartCourses : [CourseModel] = []
    @Published var inProgressCourses : [CourseModel] = []
    @Published var completedCourses : [CourseModel] = []
    
    
    @Published var requiredCourses : [CourseModel] = []
    @Published var CoursesForYouCourses : [CourseModel] = []
    
    @Published var newestCourses : [CourseModel] = []
    @Published var courseCatalog : [CourseModel] = []
    @Published var favourite : [CourseModel] = []

    @Published var getWelcomeVideoAPIStatus: APIState = .none
    @Published var getRequiredCourseAPIStatus: APIState = .none
    @Published var getSharedCoursesAPIStatus: APIState = .none
    @Published var getCoursesForYouCourseAPIStatus: APIState = .none
    @Published var getQuickStartCoursesAPIStatus: APIState = .none
    @Published var getInProgressCoursesAPIStatus: APIState = .none
    @Published var getCourseCompletedAPIStatus: APIState = .none
    @Published var clearInProgressCourseAPIStatus: APIState = .none
    @Published var seenWelcomeVideoAPIStatus: APIState = .none

    @Published var getNewestCoursesAPIStatus: APIState = .none
    @Published var getCourseCatalogAPIStatus: APIState = .none

    @Published var getCourseFavAPIStatus: APIState = .none
    
    @Published var getStaticLabelAPIStatus: APIState = .none
    @Published var staticLabel: [StaticLabelModel] = []
    
    private init() {
        
    }
}

extension DashboardViewModel {
    
    func getCardShowStatus(_ forCard: DashboardCard) -> Bool {
        switch forCard {
        case .welcomeVideoCard:
            return true
        case .requiredCoursesCard:
            return true
        case .assignedCoursesCard:
            return true
        case .inProgressCoursesCard:
            return true
        case .coursesForYouCard:
            return true
        case .exploreCard:
            return true
        case .quickStartCoursesCard:
            return true
        case .learningPathCard:
            return true
        case .myCourses:
            return true
        case .noCard:
            return true
        }
    }
    
    
    func getWelcomeVideo(locale: String, success: @escaping () -> Void) {
        
        var params : [String:Any] = [:]
        
        params.updateValue(locale, forKey: "locale")
        self.getWelcomeVideoAPIStatus = .Loading
        WebServiceManager.shared.sendRequest(serviceType: .getWelcomeVideo, params: params) { result in
            AmwayAppLogger.generalLogger.debug(String(describing: result))
            
            if let responseDict = result as? [String : Any] {
                
                if let welcomeVideoDetails = responseDict["data"] as? NSDictionary {
                    
                    if let dict = welcomeVideoDetails as? [String : Any] {
                        
                        let welcomeVideoModel = WelcomeVideoModel(response: dict)
                        self.welcomeResponse = welcomeVideoModel
                    }
                }
            }
            
            self.getWelcomeVideoAPIStatus = .success
            success()
            AppManager.shared.noInternet = false
        } failure: { failurError in
            
            self.getWelcomeVideoAPIStatus = .failure(.ApiError)
        } offline: { offline in
            self.getWelcomeVideoAPIStatus = .failure(.Offline)
            AppManager.shared.noInternet = true
        }
    }
    
    /*
    func getfavorite(success: @escaping () -> Void) {
        
        WebServiceManager.shared.sendRequest(serviceType: .getfavorite, params: [:]) { result in
            print(result)
            if let responseDict = result as? [String : Any] {
                
                if let courseDetails = responseDict["data"] as? NSArray {
                    self.favourite.removeAll()
                    for item in courseDetails {
                        if let dict = item as? [String : Any] {
                            let course = CourseModel(response: dict)
                            self.favourite.append(course)
                        }
                    }
                    self.getCourseFavAPIStatus = .success
                    AppManager.shared.noInternet = false
                }
                success()
            }
        }failure: { failurError in
            
            self.getCourseFavAPIStatus = .failure(.ApiError)
            
        } offline: { offline in
            self.getCourseFavAPIStatus = .failure(.Offline)
            AppManager.shared.noInternet = true
        }
    }
    */
    func getCourses(courseType: String, isDashboard: Bool, pageSize: Int, pageNumber: Int, locale: String, sortBy: String, failure: @escaping (_ status:APIState) -> Void = {status in }, success: @escaping () -> Void) {
        
        var params : [String:Any] = [:]
        
        params.updateValue(courseType, forKey: "courseType")
        params.updateValue(isDashboard, forKey: "isDashboard")
        params.updateValue(pageSize, forKey: "pageSize")
        params.updateValue(pageNumber, forKey: "pageNumber")
        params.updateValue(locale, forKey: "locale")
        params.updateValue(sortBy, forKey: "sortBy")
        
        switch courseType {

        case CourseType.Required.rawValue:
            getRequiredCourseAPIStatus = .Loading
        
        case CourseType.completed.rawValue:
            getCourseCompletedAPIStatus = .Loading
            
        case CourseType.quickStart.rawValue:
            getQuickStartCoursesAPIStatus = .Loading
            
        case CourseType.inProgress.rawValue:
            getInProgressCoursesAPIStatus = .Loading
            
        case CourseType.CoursesForYou.rawValue:
            getCoursesForYouCourseAPIStatus = .Loading
            
        case CourseType.Shared.rawValue:
            getSharedCoursesAPIStatus = .Loading
            
        case CourseType.newest.rawValue:
            getNewestCoursesAPIStatus = .Loading
            
        case CourseType.courseCatalog.rawValue:
            getCourseCatalogAPIStatus = .Loading
            
        case  CourseType.favorite.rawValue:
            getCourseFavAPIStatus = .Loading
            
        default:
            AmwayAppLogger.generalLogger.debug("Invalid course type")
        }

        
        WebServiceManager.shared.sendRequest(serviceType: .getCourses, params: params) { result in
            AmwayAppLogger.generalLogger.debug(String(describing: result))
            
            if let responseDict = result as? [String : Any] {
                
                if let courseDetails = responseDict["data"] as? NSArray {
                    
                    if courseType == CourseType.quickStart.rawValue {
                        self.quickStartCourses.removeAll()
                        for item in courseDetails {
                            if let dict = item as? [String : Any] {
                                let course = CourseModel(response: dict)
                                self.quickStartCourses.append(course)
                            }
                        }
                        self.getQuickStartCoursesAPIStatus = .success
                    }
                    
                    if courseType == CourseType.completed.rawValue {
                        self.completedCourses.removeAll()
                        for item in courseDetails {
                            if let dict = item as? [String : Any] {
                                let course = CourseModel(response: dict)
                                self.completedCourses.append(course)
                            }
                        }
                        self.getCourseCompletedAPIStatus = .success
                    }
                    
                    if courseType == CourseType.inProgress.rawValue {
                        
                        self.inProgressCourses.removeAll()
                        
                        for item in courseDetails {
                            if let dict = item as? [String : Any] {
                                let course = CourseModel(response: dict)
                                self.inProgressCourses.append(course)
                            }
                        }
                        self.getInProgressCoursesAPIStatus = .success
                    }
                    
                    if courseType == CourseType.Required.rawValue {
                        self.requiredCourses.removeAll()
                        for item in courseDetails {
                            if let dict = item as? [String : Any] {
                                let course = CourseModel(response: dict)
                                self.requiredCourses.append(course)
                            }
                        }
                        self.getRequiredCourseAPIStatus = .success
                    }
                    
                    if courseType == CourseType.CoursesForYou.rawValue {
                        self.CoursesForYouCourses.removeAll()
                        for item in courseDetails {
                            if let dict = item as? [String : Any] {
                                let course = CourseModel(response: dict)
                                self.CoursesForYouCourses.append(course)
                            }
                        }
                        self.getCoursesForYouCourseAPIStatus = .success
                    }
                    
                    if courseType == CourseType.newest.rawValue {
                        self.newestCourses.removeAll()
                        for item in courseDetails {
                            if let dict = item as? [String : Any] {
                                let course = CourseModel(response: dict)
                                self.newestCourses.append(course)
                            }
                        }
                        self.getNewestCoursesAPIStatus = .success
                    }
                    
                    if courseType == CourseType.courseCatalog.rawValue {
                        self.courseCatalog.removeAll()
                        for item in courseDetails {
                            if let dict = item as? [String : Any] {
                                let course = CourseModel(response: dict)
                                self.courseCatalog.append(course)
                            }
                        }
                        self.getCourseCatalogAPIStatus = .success
                    }
                    
                    if courseType == CourseType.favorite.rawValue {
                        self.favourite.removeAll()
                        for item in courseDetails {
                            if let dict = item as? [String : Any] {
                                let course = CourseModel(response: dict)
                                self.favourite.append(course)
                            }
                        }
                        self.getCourseFavAPIStatus = .success

                    }
                }
            }
            
            success()
            AppManager.shared.noInternet = false
            
        } failure: { failurError in
            
            failure(.failure(.ApiError))
            
            switch courseType {
                
            case CourseType.Required.rawValue:
                self.getRequiredCourseAPIStatus = .failure(.ApiError)
            case CourseType.completed.rawValue:
                self.getCourseCompletedAPIStatus = .failure(.ApiError)
                
            case CourseType.quickStart.rawValue:
                self.getQuickStartCoursesAPIStatus = .failure(.ApiError)
                
            case CourseType.inProgress.rawValue:
                self.getInProgressCoursesAPIStatus = .failure(.ApiError)
                
            case CourseType.CoursesForYou.rawValue:
                self.getCoursesForYouCourseAPIStatus = .failure(.ApiError)
                
            case CourseType.Shared.rawValue:
                self.getSharedCoursesAPIStatus = .failure(.ApiError)
                
            case CourseType.newest.rawValue:
                self.getNewestCoursesAPIStatus = .failure(.ApiError)
                
            case CourseType.courseCatalog.rawValue:
                self.getCourseCatalogAPIStatus = .failure(.ApiError)
                
            case CourseType.favorite.rawValue:
                self.getCourseFavAPIStatus = .failure(.ApiError)
                
            default:
                AmwayAppLogger.generalLogger.debug("Invalid course type")
            }

        } offline: { offline in
            
            failure(.failure(.Offline))
            
            switch courseType {
                
            case CourseType.Required.rawValue:
                self.getRequiredCourseAPIStatus = .failure(.Offline)
                
            case CourseType.completed.rawValue:
                self.getCourseCompletedAPIStatus = .failure(.Offline)
                
            case CourseType.quickStart.rawValue:
                self.getQuickStartCoursesAPIStatus = .failure(.Offline)

            case CourseType.inProgress.rawValue:
                self.getInProgressCoursesAPIStatus = .failure(.Offline)
                
            case CourseType.CoursesForYou.rawValue:
                self.getCoursesForYouCourseAPIStatus = .failure(.Offline)
                
            case CourseType.Shared.rawValue:
                self.getSharedCoursesAPIStatus = .failure(.Offline)
                
            case CourseType.newest.rawValue:
                self.getNewestCoursesAPIStatus = .failure(.Offline)
                
            case CourseType.courseCatalog.rawValue:
                self.getCourseCatalogAPIStatus = .failure(.Offline)
                
            case CourseType.favorite.rawValue:
                self.getCourseFavAPIStatus = .failure(.Offline)
                
            default:
                AmwayAppLogger.generalLogger.debug("Invalid course type")

            }
            AppManager.shared.noInternet = true
        }
        
    }
    
    //Get Static Label Data
    func getStaticLabelData(lang: String) {
        
        var params : [String:Any] = [:]
        
        params.updateValue(lang, forKey: "locale")
        
        self.getStaticLabelAPIStatus = .Loading
        
        WebServiceManager.shared.sendRequest(serviceType: .fetchStaticLabel, params: params) { result in
            
            AmwayAppLogger.generalLogger.debug(String(describing: result))
            
            if let responseDict = result as? [String : Any] {
                if let staticLabels = responseDict["data"] as? NSArray {
                    self.staticLabel.removeAll()
                    for item in staticLabels {
                        if let dict = item as? [String : Any] {
                            let staticLabel = StaticLabelModel(response: dict)
                            self.staticLabel.append(staticLabel)
                        }
                    }
                }
            }
            self.getStaticLabelAPIStatus = .success
            AppManager.shared.noInternet = false
            
        } failure: { failurError in
            
            self.getStaticLabelAPIStatus = .failure(.ApiError)
        } offline: { offline in
            self.getStaticLabelAPIStatus = .failure(.Offline)
            AppManager.shared.noInternet = true
        }
        
    }
    
    func getStaticLabelValue(forkey key: String) -> String {
        for item in staticLabel {
            if item.key == key {
                return item.translation
            }
        }
        return ""
    }
    
    func clearInProgressCourse(course: CourseModel, success: @escaping () -> Void) {
        
        var params : [String:Any] = [:]
        
        params.updateValue(course.courseId, forKey: "courseId")
        
        WebServiceManager.shared.sendRequest(serviceType: .clearInProgressCourse, params: params) { result in
            AmwayAppLogger.generalLogger.debug(String(describing: result))
            
            self.clearInProgressCourseAPIStatus = .success
            success()
            AppManager.shared.noInternet = false
        } failure: { failurError in
            self.clearInProgressCourseAPIStatus = .failure(.ApiError)
        } offline: { offline in
            self.clearInProgressCourseAPIStatus = .failure(.Offline)
            AppManager.shared.noInternet = true
        }
    }
    
    func seenWelcomeVideo() {
        
        var params : [String:Any] = [:]
        
        WebServiceManager.shared.sendRequest(serviceType: .seenWelcomeVideo, params: params) { result in
            AmwayAppLogger.generalLogger.debug(String(describing: result))
            
            self.seenWelcomeVideoAPIStatus = .success
            AppManager.shared.noInternet = false
        } failure: { failurError in
            self.seenWelcomeVideoAPIStatus = .failure(.ApiError)
        } offline: { offline in
            self.seenWelcomeVideoAPIStatus = .failure(.Offline)
            AppManager.shared.noInternet = true
        }
    }
    
    //Get Course Data
    func getCourseData() {
        
        let tempData = AppConstants.bundle
        if let courseData = tempData.url(forResource: "CourseData", withExtension: "json") {
            do {
                let data = try Data(contentsOf: courseData, options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any]
                
                if let courses = jsonResult!["MyCourses"] as? [[String: Any]] {
                    for item in courses {
                        let courseState = CourseModel(response: item)
                        self.courses.append(courseState)
                    }
                }
            }
            catch {
                
            }
        }
    }
    
    // Get Dummy Course List
//    func getDummyCourseList(_ count: Int) -> [CourseModel] {
//        let cnt = max(count, 1)
//        var course = CourseModel()
//        course.title = "Selling Balance Within™️ Probiotics to Build Your Business"
//        course.description = "Start Strong and drive your success with Amway Education to sharpen your competitive edge. Created with you, when and where you want. Start Strong and drive your success with Amway Education to sharpen your competitive edge. Created with you, when and where you want."
//        course.duration = "9m"
//        
//        var dummyCourseList: [CourseModel] = []
//        for _ in 0..<cnt {
//            dummyCourseList.append(course)
//        }
//        
//        return dummyCourseList
//    }
}
