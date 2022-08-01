//
//  ExploreFilterVM.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 11/03/22.
//

import Foundation
import Amway_Base_Utility

class ExploreFilterVM: ObservableObject {
    
    static let shared = ExploreFilterVM()
    
    @Published var selectedCourse: CourseModel = CourseModel()
    @Published var exploreFilters : [ExploreFilterModel] = []
    @Published var originalFilters : [ExploreFilterModel] = []
    @Published var selectedStateExploreFilters : [ExploreFilterModel] = []
    @Published var selectedCategoryIndex: Int = 0
    @Published var selectedFilter : [SubCategory] = []
    @Published var selectedCategoryFilter : String = ""
    
    @Published var selectedFiltersDict : [String : [String]] = [:]
    @Published var selectedFiltersStateDict : [String : [String]] = [:]
    @Published var coursesCountForAppliedFilters : CoursesCountForAppliedFiltersModel = CoursesCountForAppliedFiltersModel()
    @Published var coursesCountForAppliedFiltersState: CoursesCountForAppliedFiltersModel = CoursesCountForAppliedFiltersModel()
    @Published var coursesForAppliedFilters : [CourseModel] = []
    
    @Published var getExploreFilterAPIStatus : APIState = .none
    @Published var getCoursesCountForAppliedFiltersAPIStatus : APIState = .none
    @Published var getCoursesForAppliedFiltersAPIStatus : APIState = .none
    
    @Published var newestCourses : [CourseModel] = []
    @Published var courseCatalog : [CourseModel] = []
    
    @Published var getNewestCoursesAPIStatus: APIState = .none
    @Published var getCourseCatalogAPIStatus: APIState = .none
    
    @Published var showWarningPopup: Bool = false
    
    @Published var selectedCategoryFiltersList: [String] = []
    @Published var selectedSkillsFiltersList: [String] = []
    @Published var selectedKeywordsFiltersList: [String] = []
    
    @Published var selectedCategoryFiltersStateList: [String] = []
    @Published var selectedSkillsFiltersStateList: [String] = []
    @Published var selectedKeywordsFiltersStateList: [String] = []
    
    var newestCoursePageSize = 10
    var newestCoursePageNumber : Int = 0
    var isNextPageAvailableForNewestCourse: Bool = true
    
    var courseCatalogPageSize = 10
    var courseCatalogPageNumber : Int = 0
    var isNextPageAvailableForCourseCatalog: Bool = true
    
}

extension ExploreFilterVM {
    
    //Get Explore Filters Data
//    func getExploreFiltersData() {
//        if  let filterData = Amway_Base_Utility.CommonUtils.fetchDataFromLocalJson(name: "ExploreFilter") as? [String: Any] {
//            if let filters = filterData["filters"] as? [[String: Any]] {
//                for item in filters {
//                    let exploreFilter = ExploreFilterModel(response: item)
//                    self.exploreFilters.append(exploreFilter)
//                    self.originalFilters.append(exploreFilter)
//                    self.selectedStateExploreFilters.append(exploreFilter)
//                }
//            }
//        }
//    }
    
    
    func getExploreFiltersData() {
        let tempData = AppConstants.bundle
        if let filterData = tempData.url(forResource: "ExploreFilter", withExtension: "json") {
            do {
                let data = try Data(contentsOf: filterData, options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any]
                
                if let filters = jsonResult!["filters"] as? [[String: Any]] {
                    self.exploreFilters.removeAll()
                    self.originalFilters.removeAll()
                    self.selectedStateExploreFilters.removeAll()
                    for item in filters {
                        let exploreFilter = ExploreFilterModel(response: item)
                        self.exploreFilters.append(exploreFilter)
                        self.originalFilters.append(exploreFilter)
                        self.selectedStateExploreFilters.append(exploreFilter)
                    }
                }
            }
            catch {
                
            }
        }
    }
    
    func appliedFilterState() {
        self.selectedStateExploreFilters = self.exploreFilters
        self.selectedFiltersStateDict = self.selectedFiltersDict
        self.selectedCategoryFiltersStateList = self.selectedCategoryFiltersList
        self.selectedSkillsFiltersStateList = self.selectedSkillsFiltersList
        self.selectedKeywordsFiltersStateList = self.selectedKeywordsFiltersList
        self.coursesCountForAppliedFiltersState = self.coursesCountForAppliedFilters
    }
    
    func cancelFilterState() {
        self.exploreFilters = self.selectedStateExploreFilters
        self.selectedFiltersDict = self.selectedFiltersStateDict
        self.getCoursesCountForAppliedFilters(locale: AppConstants.defaultLocale)
        self.selectedCategoryFiltersList = self.selectedCategoryFiltersStateList
        self.selectedSkillsFiltersList = self.selectedSkillsFiltersStateList
        self.selectedKeywordsFiltersList = self.selectedKeywordsFiltersStateList
    }
    
    func clearAllFilterState() {
        self.exploreFilters = self.originalFilters
        self.selectedStateExploreFilters = self.exploreFilters
        self.selectedFiltersDict.removeAll()
        self.getCoursesCountForAppliedFilters(locale: AppConstants.defaultLocale)
        self.selectedCategoryFiltersList.removeAll()
        self.selectedSkillsFiltersList.removeAll()
        self.selectedKeywordsFiltersList.removeAll()
        self.selectedCategoryFiltersStateList.removeAll()
        self.selectedSkillsFiltersStateList.removeAll()
        self.selectedKeywordsFiltersStateList.removeAll()
    }
    
    func getAllSubCatSelected() -> [SubCategory] {
        var tempSubCatArray: [SubCategory] = []

        for cat in selectedStateExploreFilters {
            for subCat in cat.subCategory {
                if subCat.isMarked == true {
                    tempSubCatArray.append(subCat)
                }
            }
        }
        return tempSubCatArray
    }
    
    func removeSelectedFilter(subCategory: SubCategory) {
        for i in 0..<self.exploreFilters.count {
            for j in 0..<self.exploreFilters[i].subCategory.count {
                if self.exploreFilters[i].subCategory[j].id == subCategory.id {
                    self.exploreFilters[i].subCategory[j].isMarked = false
                }
            }
        }
        self.appliedFilterState()
    }
    
    func setSelectedCategoryIndex(index: Int) {
        selectedCategoryIndex = index
    }
    
    func resetFilters() {
        self.exploreFilters.removeAll()
        self.originalFilters.removeAll()
        self.selectedStateExploreFilters.removeAll()
        self.newestCourses.removeAll()
        self.courseCatalog.removeAll()
        self.selectedCategoryFiltersList.removeAll()
        self.selectedSkillsFiltersList.removeAll()
        self.selectedKeywordsFiltersList.removeAll()
        self.selectedCategoryFiltersStateList.removeAll()
        self.selectedSkillsFiltersStateList.removeAll()
        self.selectedKeywordsFiltersStateList.removeAll()
    }
    
    func saveSelectedCategory(categoryFilter: String) {
        self.selectedCategoryFilter = categoryFilter
    }
    
    func checkboxSelected(clickedFilter: SubCategory, isFromExploreLandingPage: Bool = false) {
        
        if self.selectedFiltersDict.keys.contains(self.exploreFilters[self.selectedCategoryIndex].category.lowercased()) {
            
            var tempFilter = self.selectedFiltersDict[self.exploreFilters[self.selectedCategoryIndex].category.lowercased()]
            
            if clickedFilter.isMarked {
                tempFilter?.append(clickedFilter.subCatId)
                addToFiltersList(categoryIdx: self.selectedCategoryIndex, title: clickedFilter.title)
            } else {
                if let index = tempFilter?.firstIndex(of: clickedFilter.subCatId) {
                    tempFilter?.remove(at: index)
                    removeFromFiltersList(categoryIdx: self.selectedCategoryIndex, title: clickedFilter.title)
                }
            }
            
            self.selectedFiltersDict[self.exploreFilters[self.selectedCategoryIndex].category.lowercased()] = tempFilter
            
            if self.selectedFiltersDict[self.exploreFilters[self.selectedCategoryIndex].category.lowercased()]?.count == 0 {
                self.selectedFiltersDict.removeValue(forKey: self.exploreFilters[self.selectedCategoryIndex].category.lowercased())
            }
            
        } else {
            let tempFilter = [clickedFilter.subCatId]
            self.selectedFiltersDict[self.exploreFilters[self.selectedCategoryIndex].category.lowercased()] = tempFilter
            addToFiltersList(categoryIdx: self.selectedCategoryIndex, title: clickedFilter.title)
        }
        if isFromExploreLandingPage {
            self.appliedFilterState()
        }
        self.getCoursesCountForAppliedFilters(locale: AppConstants.defaultLocale) {
            if isFromExploreLandingPage {
                self.coursesCountForAppliedFiltersState = self.coursesCountForAppliedFilters
            }
        }
        
        if isFromExploreLandingPage {
            self.getCoursesForAppliedFilters(locale: AppConstants.defaultLocale)
        }
    }
    
    func addToFiltersList(categoryIdx: Int, title: String) {
        let idx = categoryIdx
        let reqFilter = title
        if idx == 0 {
            // Category Filter clicked
            if !selectedCategoryFiltersList.contains(reqFilter) {
                selectedCategoryFiltersList.append(reqFilter)
            }
        } else if idx == 1 {
            // Skills Filter clicked
            if !selectedSkillsFiltersList.contains(reqFilter) {
                selectedSkillsFiltersList.append(reqFilter)
            }
        } else if idx == 2 {
            // Keywords Filter clicked
            if !selectedKeywordsFiltersList.contains(reqFilter) {
                selectedKeywordsFiltersList.append(reqFilter)
            }
        }
    }
    
    func removeFromFiltersList(categoryIdx: Int, title: String) {
        let idx = categoryIdx
        let reqFilter = title
        if idx == 0 {
            // Category Filter clicked
            if let reqInd = selectedCategoryFiltersList.firstIndex(where: { filt in
                filt == reqFilter
            }) {
                selectedCategoryFiltersList.remove(at: reqInd)
            }
        } else if idx == 1 {
            // Skills Filter clicked
            if let reqInd = selectedSkillsFiltersList.firstIndex(where: { filt in
                filt == reqFilter
            }) {
                selectedSkillsFiltersList.remove(at: reqInd)
            }
        } else if idx == 2 {
            // Keywords Filter clicked
            if let reqInd = selectedKeywordsFiltersList.firstIndex(where: { filt in
                filt == reqFilter
            }) {
                selectedKeywordsFiltersList.remove(at: reqInd)
            }
        }
    }
    
    func getExploreFilters(locale: String) {
        
        var params : [String:Any] = [:]

        params.updateValue(locale, forKey: "locale")

        self.getExploreFilterAPIStatus = .Loading
        
        WebServiceManager.shared.sendRequest(serviceType: .getExploreFilters, params: params) { result in
            AmwayAppLogger.generalLogger.debug(String(describing: result))
            
            if let responseDict = result as? [String : Any] {
                
                if let filterDetails = responseDict["data"] as? NSArray {
                    self.exploreFilters.removeAll()
                    self.originalFilters.removeAll()
                    self.selectedStateExploreFilters.removeAll()
                    
                    for item in filterDetails {
                        
                        if let dict = item as? [String : Any] {
                            
                            let exploreFilter = ExploreFilterModel(response: dict)
                            self.exploreFilters.append(exploreFilter)
                            self.originalFilters.append(exploreFilter)
                            self.selectedStateExploreFilters.append(exploreFilter)

                        }
                    }
                }
            }
            
            self.getExploreFilterAPIStatus = .success
        } failure: { failurError in
            
            self.getExploreFilterAPIStatus = .failure(.ApiError)
        } offline: { offline in
            self.getExploreFilterAPIStatus = .failure(.Offline)
        }

    }
    
    func getCoursesCountForAppliedFilters(locale: String, success: @escaping ()->Void = {}) {
        
        var queryParams : [String:Any] = [:]
        
        queryParams.updateValue(locale, forKey: "locale")
        
        self.getCoursesCountForAppliedFiltersAPIStatus = .Loading
        
        WebServiceManager.shared.sendRequest(serviceType: .getCoursesCountForAppliedFilters, params: queryParams, bodyParams: selectedFiltersDict) { result in
            AmwayAppLogger.generalLogger.debug(String(describing: result))
            
            if let responseDict = result as? [String : Any] {
                
                if let coursesCountDetails = responseDict["data"] as? NSDictionary {
                    
                    if let dict = coursesCountDetails as? [String : Any] {
                        
                        let coursesCount = CoursesCountForAppliedFiltersModel(response: dict)
                        self.coursesCountForAppliedFilters = coursesCount
                    }
                }
            }
            
            self.getCoursesCountForAppliedFiltersAPIStatus = .success
            success()
        } failure: { failurError in
            
            self.getCoursesCountForAppliedFiltersAPIStatus = .failure(.ApiError)
        } offline: { offline in
            self.getCoursesCountForAppliedFiltersAPIStatus = .failure(.Offline)
        }
        
    }
    
    func getCoursesForAppliedFilters(locale: String) {
        
        var queryParams : [String:Any] = [:]

        queryParams.updateValue(locale, forKey: "locale")

        self.getCoursesForAppliedFiltersAPIStatus = .Loading
        
        WebServiceManager.shared.sendRequest(serviceType: .getCoursesForAppliedFilters, params: queryParams, bodyParams: selectedFiltersDict) { result in
            self.coursesForAppliedFilters.removeAll()
            if let responseDict = result as? [String : Any] {
                if let courseDetails = responseDict["data"] as? NSArray {
                    for item in courseDetails {
                        if let dict = item as? [String : Any] {
                            let course = CourseModel(response: dict)
                            self.coursesForAppliedFilters.append(course)
                        }
                    }
                }
            }
            
            self.getCoursesForAppliedFiltersAPIStatus = .success
            
        } failure: { failurError in
            
            self.getCoursesForAppliedFiltersAPIStatus = .failure(.ApiError)
        } offline: { offline in
            self.getCoursesForAppliedFiltersAPIStatus = .failure(.Offline)
        }

    }
    
    //MARK: - PAGINATION
//    func loadMoreContent(currentItem item: CourseModel, courseType: CourseType){
//        var thresholdIndex = 0
//
//        if courseType == .newest {
//
//            if self.newestCourses.count > 9 {
//
//                thresholdIndex = self.newestCourses.index(self.newestCourses.endIndex, offsetBy: -3)
//                if self.newestCourses[thresholdIndex].courseId == item.courseId,
//                   isNextPageAvailableForNewestCourse {
//                    getExploreCourses(courseType: courseType.rawValue, isDashboard: false, size: newestCoursePageSize, page: newestCoursePageNumber, locale: AppConstants.defaultLocale, sortBy: SortBy.most_relevant.description)
//                    newestCoursePageNumber += 1
//                }
//            }
//        } else {
//
//            if self.courseCatalog.count > 9 {
//
//                thresholdIndex = self.courseCatalog.index(self.courseCatalog.endIndex, offsetBy: -3)
//                if self.courseCatalog[thresholdIndex].courseId == item.courseId,
//                   isNextPageAvailableForCourseCatalog {
//                    getExploreCourses(courseType: courseType.rawValue, isDashboard: false, size: courseCatalogPageSize, page: courseCatalogPageNumber, locale: AppConstants.defaultLocale, sortBy: SortBy.most_relevant.description)
//                    courseCatalogPageNumber += 1
//                }
//            }
//        }
//
//
//    }
    
    func getExploreCourses(courseType: String, isDashboard: Bool, size: Int, page: Int, locale: String, sortBy: String) {
        
        var params : [String:Any] = [:]
        
        params.updateValue(courseType, forKey: "courseType")
        params.updateValue(isDashboard, forKey: "isDashboard")
        params.updateValue(size, forKey: "pageSize")
        params.updateValue(page, forKey: "pageNumber")
        params.updateValue(locale, forKey: "locale")
        params.updateValue(sortBy, forKey: "sortBy")

        if courseType == CourseType.newest.rawValue {
            if !isNextPageAvailableForNewestCourse {
                // No more newest courses available
                getNewestCoursesAPIStatus = .success
                return
            } else if getNewestCoursesAPIStatus == .Loading {
                // Still fetching data for previous call
                return
            } else {
                getNewestCoursesAPIStatus = .Loading
            }
        } else if courseType == CourseType.courseCatalog.rawValue {
            if !isNextPageAvailableForCourseCatalog {
                // No more course catalog courses available
                getCourseCatalogAPIStatus = .success
                return
            } else if getCourseCatalogAPIStatus == .Loading {
                // Still fetching data for previous call
                return
            } else {
                getCourseCatalogAPIStatus = .Loading
            }
        } else {
            AmwayAppLogger.generalLogger.debug("Invalid course type")
        }
        
        WebServiceManager.shared.sendRequest(serviceType: .getCourses, params: params) { result in
            AmwayAppLogger.generalLogger.debug(String(describing: result))
                        
            if let responseDict = result as? [String : Any] {
                
                if let courseDetails = responseDict["data"] as? NSArray {
                    
                    if courseType == CourseType.newest.rawValue {
                        if self.newestCoursePageNumber == 0 {
                            self.newestCourses.removeAll()
                        }
                        for item in courseDetails {
                            if let dict = item as? [String : Any] {
                                let course = CourseModel(response: dict)
                                self.newestCourses.append(course)
                            }
                        }
                        self.getNewestCoursesAPIStatus = .success
                        if courseDetails.count == self.newestCoursePageSize {
                            self.newestCoursePageNumber += 1
                        } else {
                            self.isNextPageAvailableForNewestCourse = false
                        }
                    }
                    
                    if courseType == CourseType.courseCatalog.rawValue {
                        if self.courseCatalogPageNumber == 0 {
                            self.courseCatalog.removeAll()
                        }
                        for item in courseDetails {
                            if let dict = item as? [String : Any] {
                                let course = CourseModel(response: dict)
                                self.courseCatalog.append(course)
                            }
                        }
                        self.getCourseCatalogAPIStatus = .success
                        if courseDetails.count == self.courseCatalogPageSize {
                            self.courseCatalogPageNumber += 1
                        } else {
                            self.isNextPageAvailableForCourseCatalog = false
                        }
                    }
                }
            }
            
            
        } failure: { failurError in
            
            switch courseType {
                    
                case CourseType.newest.rawValue:
                    self.getNewestCoursesAPIStatus = .failure(.ApiError)
                    
                case CourseType.courseCatalog.rawValue:
                    self.getCourseCatalogAPIStatus = .failure(.ApiError)
                    
                default:
                AmwayAppLogger.generalLogger.debug("Invalid course type")
            }
        } offline: { offline in
            switch courseType {
                    
                case CourseType.newest.rawValue:
                    self.getNewestCoursesAPIStatus = .failure(.Offline)
                    
                case CourseType.courseCatalog.rawValue:
                    self.getCourseCatalogAPIStatus = .failure(.Offline)
                    
                default:
                AmwayAppLogger.generalLogger.debug("Invalid course type")
            }
        }
        
    }
}
