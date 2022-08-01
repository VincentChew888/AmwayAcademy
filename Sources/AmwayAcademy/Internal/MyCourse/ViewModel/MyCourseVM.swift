//
//  MyCourseVM.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 23/02/22.
//

import Foundation
import Amway_Base_Utility

enum MyCourses: String, CaseIterable {
    
    case requiredCourses = "Required"
    case inProgressCourses = "InProgress"
    //    case sharedCourses = "Shared"
    case favoriteCourses = "Favorite"
    //    case downloadedCourses = "Downloaded"
    case completedCourses = "Completed"
}

class MyCourseVM: ObservableObject {
    
    static let shared = MyCourseVM()
    
    @Published var selectedCourse: CourseModel = CourseModel()
    @Published var myCourses : [CourseModel] = []
    
    @Published var filteredCourses : [CourseModel] = []
    
    @Published var coursesAPIStatus: APIState = .none
    @Published var clickedCard: MyCourses = .requiredCourses
    @Published var courseCardType: CourseType = .Default
    
    @Published var coursesEmptyState : [MyCourseEmptyModel] = []
    
    @Published var selectedCourseEmptyData: MyCourseEmptyModel = MyCourseEmptyModel()
    
    var pageSize = 10
    var pageNumber : Int = 0
    var isNextPageAvailable: Bool = true
    
    init() {
//        myCourses = DashboardViewModel.shared.courses
    }
    
    
}

extension MyCourseVM {
    
    //MARK: - PAGINATION
//    func loadMoreContent(currentItem item: CourseModel, myCourseType: MyCourses, sortBy: String) {
//        var thresholdIndex = 0
//        if self.filteredCourses.count > 9 {
//            thresholdIndex = self.filteredCourses.index(self.filteredCourses.endIndex, offsetBy: -3)
//            if self.filteredCourses[thresholdIndex].courseId == item.courseId,
//               isNextPageAvailable {
//
//                getSelectedMyCoursesData(myCourseType: myCourseType, isFallThrough: false, isDashboard: false, page: pageNumber, size: pageSize, locale: AppConstants.defaultLocale, sortBy: sortBy)
//
//                pageNumber += 1
//            }
//        }
//        else {
//            pageNumber = 1
//        }
//    }
    
    func getSelectedMyCoursesData(myCourseType: MyCourses, isFallThrough: Bool, isDashboard: Bool, page: Int, size: Int, locale: String, sortBy: String) {
        
        if coursesAPIStatus == .Loading || !isNextPageAvailable {
            // Already fetching data or no more available courses
            return
        }
        coursesAPIStatus = .Loading
        if pageNumber == 0 {
            self.filteredCourses.removeAll()
        }
        switch myCourseType {
            
        case .requiredCourses:

            getCourses(courseType: CourseType.Required.rawValue, isDashboard: isDashboard, pageSize: size, pageNumber: page, locale: locale, sortBy: sortBy, success: {
//                self.courseCardType = .Required
//                self.clickedCard = MyCourses.requiredCourses
            })
            
            
        case .inProgressCourses:

            getCourses(courseType: CourseType.inProgress.rawValue, isDashboard: isDashboard, pageSize: pageSize, pageNumber: pageNumber, locale: AppConstants.defaultLocale, sortBy: sortBy, success: {
//                self.courseCardType = .inProgress
//                self.clickedCard = MyCourses.inProgressCourses
            })
            
            /*
             //Not in this release so hiding the tab
             case .sharedCourses:
             filteredCourses = myCourses.filter { $0.courseType[0] == MyCourses.sharedCourses.rawValue }
             courseCardType = .Shared
             clickedCard = MyCourses.sharedCourses
             self.coursesAPIStatus = .success
             
             */
        case .favoriteCourses:
                
            getCourses(courseType: CourseType.favorite.rawValue, isDashboard: isDashboard, pageSize: pageSize, pageNumber: pageNumber, locale: AppConstants.defaultLocale, sortBy: sortBy, success: {
//                self.courseCardType = .favorite
//                self.clickedCard = MyCourses.favoriteCourses
            })
            
            /*
             //Not in this release so hiding the tab
             case .downloadedCourses:
             filteredCourses = myCourses.filter { $0.courseType[0] == MyCourses.downloadedCourses.rawValue }
             courseCardType = .Default
             clickedCard = MyCourses.downloadedCourses
             self.coursesAPIStatus = .success
             
             */
        case .completedCourses:
            
            getCourses(courseType: CourseType.completed.rawValue, isDashboard: isDashboard, pageSize: pageSize, pageNumber: pageNumber, locale: AppConstants.defaultLocale, sortBy: sortBy, success: {
//                self.courseCardType = .completed
//                self.clickedCard = MyCourses.completedCourses
            })
        }
    }
    
    func getSelectedCourseEmptyState() {
        
        for emptyData in coursesEmptyState {
            if emptyData.courseType == clickedCard.rawValue {
                selectedCourseEmptyData = emptyData
            }
        }
    }
    
    func getEmptyCourseData() {
        let tempData = AppConstants.bundle
        if let courseData = tempData.url(forResource: "MyCourseEmptyState", withExtension: "json") {
            do {
                let data = try Data(contentsOf: courseData, options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any]
                
                if let courses = jsonResult!["CoursesEmptyState"] as? [[String: Any]] {
                    for item in courses {
                        let courseState = MyCourseEmptyModel(response: item)
                        self.coursesEmptyState.append(courseState)
                    }
                }
            }
            catch {
                
            }
        }
    }
    
    func getCourses(courseType: String, isDashboard: Bool, pageSize: Int, pageNumber: Int, locale: String, sortBy: String, success: @escaping () -> Void) {
        
        var params : [String:Any] = [:]
        
        params.updateValue(courseType, forKey: "courseType")
        params.updateValue(isDashboard, forKey: "isDashboard")
        params.updateValue(pageSize, forKey: "pageSize")
        params.updateValue(pageNumber, forKey: "pageNumber")
        params.updateValue(locale, forKey: "locale")
        params.updateValue(sortBy, forKey: "sortBy")
        
        
        WebServiceManager.shared.sendRequest(serviceType: .getCourses, params: params) { result in
            AmwayAppLogger.generalLogger.debug(String(describing: result))
            
            if let responseDict = result as? [String : Any] {
                
                if let courseDetails = responseDict["data"] as? NSArray {
                    for item in courseDetails {
                        if let dict = item as? [String : Any] {
                            let course = CourseModel(response: dict)
                            self.filteredCourses.append(course)
                        }
                    }
                    
                    if courseDetails.count == pageSize {
                        self.pageNumber += 1
                    } else {
                        self.isNextPageAvailable = false
                    }
                }
            }
            
            success()
            self.coursesAPIStatus = .success
            AppManager.shared.noInternet = false
            
        } failure: { failurError in
            
            self.coursesAPIStatus = .failure(.ApiError)
            
        } offline: { offline in
            
            self.coursesAPIStatus = .failure(.Offline)
            AppManager.shared.noInternet = true
        }
        
    }
    
}
