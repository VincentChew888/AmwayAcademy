//
//  COurseDetailsMainViewModel.swift
//  ABOAcademy
//
//  Created by Swapnil Tilkari on 03/03/22.
//

import Foundation
import Amway_Base_Utility

class CourseDetailsMainViewModel : ObservableObject {
    
    @Published var course : CourseModel = CourseModel()
    @Published var cookieData : CookieDataModel = CookieDataModel()

    @Published var syllabus : [SyllabusModel] = []
    @Published var relatedCourses: [CourseModel] = []

    static let shared = CourseDetailsMainViewModel()
    static let another = CourseDetailsMainViewModel()
    
    @Published var getCourseDataAPIStatus : APIState = .none
    @Published var getFavAPIStatus : APIState = .none
    @Published var getRelatedCoursesAPIStaus: APIState = .none
    @Published var getSignedCookieAPIStaus: APIState = .none

   private init() {
       getSyllabusData()

    }
    
    func getCourseData(CourseId: String,lang: String,success: @escaping () -> ()) {
        
        var params : [String:Any] = [:]
        params.updateValue(CourseId, forKey: "course_id")
        params.updateValue(lang, forKey: "locale")
        
        self.getCourseDataAPIStatus = .Loading
        WebServiceManager.shared.sendRequest(serviceType: .getCourseDetails, params: params) { result in
            AmwayAppLogger.generalLogger.debug(String(describing: result))
          
            
            if let responseDict = result as? [String : Any] {
                if let courseDetails = responseDict["data"] as? [String: Any] {
                    self.course = CourseModel(response: courseDetails)
//                    self.getRelatedCourses(categoryId: self.course.categoryId, isDashboard: false, pageSize: 5, pageNumber: 0, locale: lang)
                }
            }
            self.getCourseDataAPIStatus = .success
            AppManager.shared.noInternet = false
            success()
        } failure: { failurError in
            
            self.getCourseDataAPIStatus = .failure(.ApiError)
        } offline: { offline in
            self.getCourseDataAPIStatus = .failure(.Offline)
            AppManager.shared.noInternet = true
        }

    }
    
    func isCourseCompleted(courseId: String, lang: String, success: @escaping (_ isCompleted: Bool) -> ()) {
        
        var params : [String:Any] = [:]
        params.updateValue(courseId, forKey: "course_id")
        params.updateValue(lang, forKey: "locale")
        
        WebServiceManager.shared.sendRequest(serviceType: .getCourseDetails, params: params) { result in
            AmwayAppLogger.generalLogger.debug(String(describing: result))
          
            var tmpCourse: CourseModel = CourseModel()
            if let responseDict = result as? [String : Any] {
                if let courseDetails = responseDict["data"] as? [String: Any] {
                    tmpCourse = CourseModel(response: courseDetails)
                }
            }
            self.getCourseDataAPIStatus = .success
            AppManager.shared.noInternet = false
            success(tmpCourse.isCompleted)
        } failure: { failurError in
            
            self.getCourseDataAPIStatus = .failure(.ApiError)
        } offline: { offline in
            self.getCourseDataAPIStatus = .failure(.Offline)
            AppManager.shared.noInternet = true
        }

    }
    
    func getRelatedCourses(categoryId: String, isDashboard: Bool, pageSize: Int, pageNumber: Int, locale: String, sortBy: String) {
        var params : [String:Any] = [:]
        params.updateValue(categoryId, forKey: "categoryId")
        params.updateValue("related", forKey: "courseType")
        params.updateValue(isDashboard, forKey: "isDashboard")
        params.updateValue(pageSize, forKey: "pageSize")
        params.updateValue(pageNumber, forKey: "pageNumber")
        params.updateValue(locale, forKey: "locale")
        params.updateValue(sortBy, forKey: "sortBy")

        self.getRelatedCoursesAPIStaus = .Loading
        
        WebServiceManager.shared.sendRequest(serviceType: .getCourses, params: params) { result in
            AmwayAppLogger.generalLogger.debug(String(describing: result))
            
            if let responseDict = result as? [String : Any] {
                if let courseDetails = responseDict["data"] as? NSArray {
                    for item in courseDetails {
                        if let dict = item as? [String : Any] {
                            let course = CourseModel(response: dict)
                            self.relatedCourses.append(course)
                        }
                    }
                    
                }
            }
            self.getRelatedCoursesAPIStaus = .success
            AppManager.shared.noInternet = false
        } failure: { failurError in
            self.getRelatedCoursesAPIStaus = .failure(.ApiError)
        } offline: { offline in
            self.getRelatedCoursesAPIStaus = .failure(.Offline)
            AppManager.shared.noInternet = true
        }

    }
    
    
    func Favourite(success: @escaping ()->Void) {
        course.isFavorite.toggle()
        var params : [String:Any] = [:]
       
        params.updateValue(course.courseId, forKey: "courseId")
//        params.updateValue(RootViewModel.shared.userDetails.amwayId, forKey: "amwayId")
        params.updateValue(course.isFavorite, forKey: "favorited")
        AmwayAppLogger.generalLogger.debug(params.description)
        self.getFavAPIStatus = .Loading
        
        WebServiceManager.shared.sendRequest(serviceType: .favourite, params: params) { result in
            AmwayAppLogger.generalLogger.debug(String(describing: result))
            
            self.getFavAPIStatus = .success
//            MyCourseVM.shared.getSelectedMyCoursesData(.favoriteCourses, isFallThrough: false)
            AppManager.shared.noInternet = false
            success()
            
        } failure: { failurError in
            
            self.getFavAPIStatus = .failure(.ApiError)
        } offline: { offline in
            self.getFavAPIStatus = .failure(.Offline)
            AppManager.shared.noInternet = true
        }

    }
    
    //Get Course Data
    func getSyllabusData() {
        
        let tempData = AppConstants.bundle
        if let filterData = tempData.url(forResource: "SyllabusData", withExtension: "json") {
            do {
                let data = try Data(contentsOf: filterData, options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any]
                
                if let filters = jsonResult!["syllabus"] as? [[String: Any]] {
                    for item in filters {
                        let curCourse = SyllabusModel(response: item)
                        self.syllabus.append(curCourse)
                    }
                }
            }
            catch {
                
            }
        }
    }
    
    //Get Cookies Data on Start Course button Click
    func getCookieData(courseId: String, success: @escaping () -> (), failure: @escaping () -> ()) {
        var params : [String:Any] = [:]
        
        params.updateValue(courseId, forKey: "course_id")
        params.updateValue(AppConstants.defaultLocale, forKey: "locale")
        
        self.getSignedCookieAPIStaus = .Loading
        
        WebServiceManager.shared.sendRequest(serviceType: .getSignedCookiesData, params: params) { result in
          
            if let responseDict = result as? [String : Any] {
                if let cookieDetails = responseDict["data"] as? [String: Any] {
                    
                    self.cookieData = CookieDataModel(response: cookieDetails)
                }
            }
            self.getSignedCookieAPIStaus = .success
            success()
            AppManager.shared.noInternet = false
        } failure: { failurError in
            
            self.getSignedCookieAPIStaus = .failure(.ApiError)
            failure()
            
        } offline: { offline in
            
            self.getSignedCookieAPIStaus = .failure(.Offline)
            failure()
            AppManager.shared.noInternet = true
        }
    }
    
   
}
