//
//  QuickStartListViewModel.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 30/03/22.
//

import Foundation
import Amway_Base_Utility

class ListViewModel: ObservableObject {
    
    static let shared = ListViewModel()
    
    @Published var selectedCourse: CourseModel = CourseModel()
    @Published var getCoursesDataAPIStatus : APIState = .none
    @Published var CoursesList : [CourseModel] = []
    
    var pageSize = 10
    var pageNumber : Int = 1
    var isNextPageAvailable: Bool = false
}

extension ListViewModel {
    
    //MARK: - PAGINATION
    func loadMoreContent(currentItem item: CourseModel, courseType: CourseType, sortBy: String){
        var thresholdIndex = 0
        if isNextPageAvailable {
            thresholdIndex = self.CoursesList.index(self.CoursesList.endIndex, offsetBy: -3)
            if self.CoursesList[thresholdIndex].courseId == item.courseId {
                getListCourses(courseType: courseType.rawValue, isDashboard: false, page: pageNumber, size: pageSize, locale: AppConstants.defaultLocale, sortBy: sortBy)
                pageNumber += 1
            }
        }
        else {
            pageNumber = 1
        }
    }
    
    
    func getListCourses(courseType: String, isDashboard: Bool, page: Int, size: Int, locale: String, sortBy: String) {
        
        var params : [String:Any] = [:]
        
        params.updateValue(courseType, forKey: "courseType")
        params.updateValue(isDashboard, forKey: "isDashboard")
        params.updateValue(page, forKey: "pageNumber")
        params.updateValue(size, forKey: "pageSize")
        params.updateValue(locale, forKey: "locale")
        params.updateValue(sortBy, forKey: "sortBy")

        self.getCoursesDataAPIStatus = .Loading
        
        WebServiceManager.shared.sendRequest(serviceType: .getCourses, params: params) { result in
            AmwayAppLogger.generalLogger.debug(String(describing: result))
            
            if let responseDict = result as? [String : Any] {
                if let courseDetails = responseDict["data"] as? NSArray {
                    if courseDetails.count < 10 {
                        self.isNextPageAvailable = false
                    } else {
                        self.isNextPageAvailable = true
                    }
//                    if self.pageNumber == 1 {
//                        self.CoursesList.removeAll()
//                    }
                    for item in courseDetails {
                        if let dict = item as? [String : Any] {
                            let course = CourseModel(response: dict)
                            self.CoursesList.append(course)
                        }
                    }
                }
            }
            
            self.getCoursesDataAPIStatus = .success
            AppManager.shared.noInternet = false
        } failure: { failurError in
            
            self.getCoursesDataAPIStatus = .failure(.ApiError)
        } offline: { offline in
            
            self.getCoursesDataAPIStatus = .failure(.Offline)
            AppManager.shared.noInternet = true
        }
        
    }
}
