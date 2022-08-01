//
//  ExploreCourseView.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 08/03/22.
//

import SwiftUI
import Shimmer

struct ExploreCourseView: View {
    @State var showCertificateDetails: Bool = false
    @State var showCompletionDetails: Bool = false
    @State var showWithoutCertificateDetails: Bool = false
    @StateObject var FilterData : ExploreFilterVM = ExploreFilterVM.shared
//    @StateObject var courseData = CourseDetailsMainViewModel.shared
    @State var showExploreFilterView : Bool = false
    @State var totalHeight = CGFloat.zero       // << variant for ScrollView/List
    @State var isAppliedFilter: Bool = false

    @State var tempSubCatData: [SubCategory] = []

    @State var showCourseDetails : Bool = false
    
    @State var filterSheetState: ResizableSheetState = .hidden
    
    @State var reloadCourses: Bool = true
    var courseSection: DashboardCard?
    var filterSheetId: String = UUID().uuidString
    
    @StateObject var warningPopupVM: WarningPopupVM = WarningPopupVM.shared
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        ShowViewWithErrorHandling(mainView: mainView) {
            getData()
        }
    }
    
    var mainView: some View {
        ZStack {
            Color.backGround.ignoresSafeArea()
            
            VStack(alignment:.leading, spacing: 0) {


                CustomNavBar(navBarTitle: StaticLabel.get("txtExploreTitle"), navBarRightIcon: "NavBarExploreFilterIcon", showRightNavButton: true, showCompletionDetails: $showCompletionDetails) {
                    self.resetScreenData()
                    presentation.wrappedValue.dismiss()

                } rightBarAction: {
                    //right nav bar button action
                    
                    let exploreFilterTouch = GenericEventInfo(name: "Academy: Explore: Touch: Filter")
                    RootViewModel.shared.creatorAction?.action(.analytics(event: exploreFilterTouch))
                    
                    showExploreFilterView.toggle()
                    filterSheetState = .medium
                }



                ScrollView {

                    VStack(alignment:.leading, spacing: 0) {

//                        ScrollView {
                            
                            if isAppliedFilter {
                                //Applied Filter section
                                VStack(alignment: .leading, spacing: 0) {

                                    ExploreHeader(headerTitle: "\(FilterData.coursesCountForAppliedFiltersState.count) "+StaticLabel.get("txtCourses"), fontSize: .vvLarge, showClearAll: true, clearAllFilter: {
                                        FilterData.clearAllFilterState()
                                        isAppliedFilter = false
                                    })
                                        .frame(height: 28)
                                        .padding(.top, 39)
                                        .padding(.bottom, 16)
                                        .padding([.leading, .trailing], 16)

                                    GeometryReader { geo in

                                        ScrollView(.vertical) {

                                            VStack(alignment: .center) {

                                                ExploreAppliedFilterView(selectedFilters: $FilterData.exploreFilters, totalHeight: $totalHeight, tempSubCatData: $tempSubCatData, isFilterApplied: $isAppliedFilter, geometry: geo)

                                            }
                                        }
                                    }
                                    .frame(height: isAppliedFilter ? totalHeight : 0)// << variant for ScrollView/List
                                    .padding([.leading, .trailing], 8)
                                }
                            }

                            //Show below view only if filter are not applied
                            if !isAppliedFilter {
                                VStack {
                                    //Newest Course Section
                                    if FilterData.getNewestCoursesAPIStatus != .failure(.ApiError) {
                                        VStack(alignment: .leading,spacing: 0) {
    
                                            ExploreHeader(headerTitle: StaticLabel.get("txtNewestCourses"))
                                                .padding(.top, 32)
                                                .padding([.leading, .bottom], 16)
    
                                            ScrollView(.horizontal, showsIndicators: false) {
                                                HStack(spacing: 8) {
                                                    if FilterData.newestCourses.count > 0 {
                                                        LazyHStack(spacing: 8) {
    
                                                            ForEach($FilterData.newestCourses, id:\.self) { curCourse in
                                                                CourseCardView(course: curCourse, courseType: .newest, imageName: "DefaultImage", lineLimit: 3, mediumCardWidth: true)
                                                                    .frame(width: AppConstants.courseCardWidth)
                                                                    .onAppear {
                                                                        if !FilterData.newestCourses.isEmpty && FilterData.newestCourses.last == curCourse.wrappedValue {
                                                                            getNewestCourses()
                                                                        }
                                                                    }
    
                                                                    .onTapGesture {
                                                                        FilterData.selectedCourse = curCourse.wrappedValue
                                                                        showCourseSheet()
                                                                    }
                                                            }
                                                        }
                                                    }
    
                                                    if FilterData.getNewestCoursesAPIStatus == .Loading {
                                                        CourseCardLoadingView(cardCount: 3, displayHorizontal: true, width: AppConstants.courseCardWidth, noHeader: true)
                                                    }
                                                }
                                                .padding([.leading, .trailing], 16)
    
                                            }
                                        }
                                    }
                                    if FilterData.getNewestCoursesAPIStatus == .failure(.ApiError) {
                                        VStack(spacing: 16) {
                                            ExploreHeader(headerTitle: StaticLabel.get("txtNewestCourses"))
                                                .padding(.top, 32)
                                                .padding([.leading, .bottom], 16)
                                            ErrorStateView(imageName: "BrokenLink", title: StaticLabel.get("txtReloadDescription")) {
                                        if isAppliedFilter {
                                            applyFilterClicked()
                                        } else {
                                            resetNewestCourseAndCourseCatalog()
                                            getData()
                                        }
                                            }
                                        }
                                    }

                                    //TODO: - Hiding the learning path section for now, might need in future
                                    //Learning Paths Section
                                    /*
                                     if hasLoaded {
                                     VStack(alignment: .leading,spacing: 0) {

                                     ExploreHeader(headerTitle: "Learning Paths")
                                     .padding(.top, 32)
                                     .padding([.leading, .bottom], 16)

                                     ScrollView(.horizontal, showsIndicators: false) {
                                     HStack(spacing: 8) {

                                     ForEach(0..<DashboardData.courses.count, id:\.self) { index in
                                     CourseCardView(course: $DashboardData.courses[index],courseType: .Default, imageName: "RequiredCourse", lineLimit: 3)
                                     .frame(width: AppConstants.courseCardWidth)
                                     }
                                     }
                                     .padding([.leading, .trailing], 16)
                                     }
                                     }
                                     } else {
                                     CourseCardLoadingView(cardCount: 3, displayHorizontal: true, width: AppConstants.courseCardWidth)
                                     .padding(.horizontal, 16)
                                     }
                                     */

                                    //Course Catalog Section
                                    if FilterData.getCourseCatalogAPIStatus != .failure(.ApiError) {
                                        VStack(alignment: .leading,spacing: 0) {

                                            ExploreHeader(headerTitle: StaticLabel.get("txtCourseCatalog"))
                                                .padding(.top, 32)
                                                .padding([.leading, .bottom], 16)

//                                            ScrollView(.vertical, showsIndicators: false) {
                                            if FilterData.courseCatalog.count > 0 {
                                                LazyVStack(alignment: .leading, spacing: 16) {

                                                    ForEach($FilterData.courseCatalog, id:\.self) { curCourse in
                                                        CourseCardView(course: curCourse,courseType: .courseCatalog, imageName: "DefaultImage", lineLimit: 3, mediumCardWidth: false)
                                                            .onAppear {
                                                                if !FilterData.courseCatalog.isEmpty && FilterData.courseCatalog.last == curCourse.wrappedValue {
                                                                    getCourseCatalogCourses()
                                                                }
                                                            }
                                                            .onTapGesture {
                                                                FilterData.selectedCourse = curCourse.wrappedValue
                                                                showCourseSheet()
                                                            }
                                                    }
                                                }
                                                .padding([.horizontal, .bottom], 16)
                                            }
                                                if FilterData.getCourseCatalogAPIStatus == .Loading {
                                                    CourseCardLoadingView(cardCount: 3, displayHorizontal: false, noHeader: true)
                                                        .padding(.horizontal, 16)
                                                }
                                                
//                                            }
                                        }
                                    }
                                    if FilterData.getCourseCatalogAPIStatus == .failure(.ApiError) {
                                        VStack(spacing: 16) {
                                            ExploreHeader(headerTitle: StaticLabel.get("txtCourseCatalog"))
                                                .padding(.top, 32)
                                                .padding([.leading, .bottom], 16)
                                            ErrorStateView(imageName: "BrokenLink", title: StaticLabel.get("txtReloadDescription")) {
                                                if isAppliedFilter {
                                                    applyFilterClicked()
                                                } else {
                                                    resetNewestCourseAndCourseCatalog()
                                                    getData()
                                                }
                                            }
                                        }
                                    }
                                }
                            } else {
                                //Show below view only if filters are applied
                                VStack {
                                    if FilterData.getCoursesForAppliedFiltersAPIStatus == .success {
                                        VStack(spacing: 16) {

                                            if FilterData.coursesForAppliedFilters.count > 0 {
                                                ForEach($FilterData.coursesForAppliedFilters, id:\.self) { curCourse in
                                                    CourseCardView(course: curCourse, courseType: .Default, imageName: "DefaultImage", lineLimit: 3, mediumCardWidth: false)
                                                        .frame(width: UIScreen.main.bounds.width - 32)
                                                        .onTapGesture {
                                                            FilterData.selectedCourse = curCourse.wrappedValue
                                                            showCourseSheet()
                                                        }
                                                        .contentShape(Rectangle())
                                                }
                                            } else {
                                                ExploreNoCoursesView()
                                                    .opacity(FilterData.coursesForAppliedFilters.count == 0 ? 1 : 0)
                                                    .frame(width: UIScreen.main.bounds.width - 32)
                                                    .padding(.top, 32)
                                            }
                                        }
                                        .padding([.leading, .trailing], 16)
                                    }
                                    else if FilterData.getCoursesForAppliedFiltersAPIStatus == .Loading {
                                        CourseCardLoadingView(cardCount: 3, displayHorizontal: false, noHeader: true)
                                            .padding(.horizontal, 16)
                                    } else if FilterData.getCoursesForAppliedFiltersAPIStatus == .failure(.ApiError) {
                                        ErrorStateView(imageName: "BrokenLink", title: StaticLabel.get("txtReloadDescription")) {
                                            if isAppliedFilter {
                                                applyFilterClicked()
                                            } else {
                                                resetNewestCourseAndCourseCatalog()
                                                getData()
                                            }
                                        }
                                    }
                                }
                                .padding(.bottom, 16)
                                .padding(.top, 20)
                            }
//                        }
                    }
                }
            }
            .resizableSheet($filterSheetState, id: filterSheetId) { builder in
                builder.content { context in
                    VStack(alignment:.leading,spacing: 0){
                        
                        //
                        //MARK:- Dragger
                        //
                        // if showTitle {
                        HStack {
                            Spacer()
                            Rectangle()
                                .foregroundColor(Color.darkGray)
                                .frame(width: 50, height: 3,alignment: .center)
                                .customRoundedRectangle()
                            
                            Spacer()
                        }
                        .padding(.vertical,10)
                        .frame(height: 35)
                        .background(Color.amwayWhite)
                        
                            Divider()
                        
                        ExploreFilterView(courseCount: $FilterData.coursesCountForAppliedFilters.count, showWarningPopup: $FilterData.showWarningPopup, isAppliedFilter: $isAppliedFilter) { appliedFilters in
                                //Applied Filter Clicked
                                self.applyFilterClicked()
                                filterSheetState = .hidden
                                
                            } cancelAction: {
                                FilterData.cancelFilterState()
                                filterSheetState = .hidden
                            }
                            .frame(height: UIScreen.main.bounds.height/1.85)
                                .padding(.top, 0)
    //                        .padding(.bottom,(UIApplication.shared.windows.last?.safeAreaInsets.bottom)!)
                        //Spacer()
                        
                    }
                    .cornerRadius(25,corners: [.topLeft,.topRight])
                }
                .isDissmissible(false)
                .sheetBackground({ _ in
                    Color.white
                })
                .supportedState([.hidden, .medium])
                
            }
            
            // Warningpopup
            VStack {
                WarningPopupView(showWarningPopup: $warningPopupVM.showWarningPopup, title: warningPopupVM.title, description: warningPopupVM.description)
                    .offset(x: 0, y: warningPopupVM.showWarningPopup ? (UIApplication.shared.windows.last?.safeAreaInsets.top)! : -200)
                    .animation(.spring(), value: warningPopupVM.showWarningPopup)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
            VStack {}
                .sheet(isPresented: $showCompletionDetails, onDismiss: {
                    if !reloadCourses {
                        return
                    }
                    reloadCourses = false
                    if isAppliedFilter {
                        applyFilterClicked()
                    } else {
                        resetNewestCourseAndCourseCatalog()
                        getData()
                    }
                }) {
                    CompletionDetailsView(courseId: $FilterData.selectedCourse.courseId, reloadCourses: $reloadCourses, courseSection: courseSection )
                        .onAppear {
                            UIScrollView.appearance().bounces = false
                        }.onDisappear {
                            UIScrollView.appearance().bounces = true
                        }
                }
            
            VStack {}
                .sheet(isPresented: $showCourseDetails, onDismiss: {
                    if !reloadCourses {
                        return
                    }
                    reloadCourses = false
                    if isAppliedFilter {
                        applyFilterClicked()
                    } else {
                        resetNewestCourseAndCourseCatalog()
                        getData()
                    }
                }) {
                    CourseDeatilsMainView(courseId: $FilterData.selectedCourse.courseId, showCourseDetails: $showCourseDetails, showCompletionDetails: $showCompletionDetails, reloadCourses: $reloadCourses, courseSection: courseSection)
                        .onAppear {
                            UIScrollView.appearance().bounces = false
                        }.onDisappear {
                            UIScrollView.appearance().bounces = true
                        }
                }
        }
        .frame(maxHeight: .infinity)
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            getData()
        }
        .onDisappear {
            self.resetScreenData()
        }
    }
    
    func showCourseSheet() {
        let course = FilterData.selectedCourse
        if course.isCompleted {
            showCompletionDetails = true
        } else {
            if course.isLive {
                showCourseDetails = true
            } else if course.isOffline {
                WarningPopupVM.shared.show(title: "\(StaticLabel.get("txtCourseOffline"))", desc: "\(StaticLabel.get("txtCourseOfflineDescription"))")
            }
    //        else if course.isArchived {
    //            WarningPopupVM.shared.show(title: "Content Removed", desc: "This Content that was In-Progress has been removed. We apologise for any inconvenience.")
    //        }
        }
    }
    
    func getData() {
        reloadCourses = false
        FilterData.newestCoursePageNumber = 0
        FilterData.courseCatalogPageNumber = 0
        
        getNewestCourses()
        getCourseCatalogCourses()

        FilterData.resetFilters()

        FilterData.getExploreFilters(locale: AppConstants.defaultLocale)

        FilterData.getCoursesCountForAppliedFilters(locale: AppConstants.defaultLocale)
    }
    
    func getNewestCourses() {
        FilterData.getExploreCourses(courseType: CourseType.newest.rawValue, isDashboard: false, size: FilterData.newestCoursePageSize, page: FilterData.newestCoursePageNumber, locale: AppConstants.defaultLocale, sortBy: SortBy.most_relevant.description)
    }
    
    func getCourseCatalogCourses() {
        FilterData.getExploreCourses(courseType: CourseType.courseCatalog.rawValue, isDashboard: false, size: FilterData.courseCatalogPageSize, page: FilterData.courseCatalogPageNumber, locale: AppConstants.defaultLocale, sortBy: SortBy.most_relevant.description)
    }
 
    func applyFilterClicked() {

        isAppliedFilter = true
        showExploreFilterView = false
        FilterData.getCoursesForAppliedFilters(locale: AppConstants.defaultLocale)
        FilterData.appliedFilterState()
        tempSubCatData = FilterData.getAllSubCatSelected()
        
        let filterEvent = FilterEventInfo(name: "Academy: Explore: Touch: Apply Fliter:", categories: FilterData.selectedCategoryFiltersStateList, skills: FilterData.selectedSkillsFiltersStateList, keywords: FilterData.selectedKeywordsFiltersStateList)
                    
        RootViewModel.shared.creatorAction?.action(.analytics(event: filterEvent))
    }

    func resetScreenData() {

        FilterData.coursesCountForAppliedFilters.count = 0
        resetNewestCourseAndCourseCatalog()
        FilterData.selectedFiltersDict.removeAll()
        FilterData.clearAllFilterState()
        isAppliedFilter = false
        showExploreFilterView = false
    }
    
    func resetNewestCourseAndCourseCatalog() {
        reloadCourses = true
        FilterData.isNextPageAvailableForCourseCatalog = true
        FilterData.isNextPageAvailableForNewestCourse = true
        FilterData.newestCoursePageNumber = 0
        FilterData.courseCatalogPageNumber = 0
    }
}

struct ExploreHeader: View {
    
    var headerTitle: String = ""
    var fontSize: customFontSize = .medium
    var showClearAll: Bool = false
    var clearAllFilter : (() -> Void)?
    
    var body: some View {
        
        HStack() {
            
            Text(headerTitle)
                .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: fontSize ))
                .foregroundColor(.amwayBlack)
            
            Spacer()
            
            Button {
                
                if let clearAllFilter = clearAllFilter {
                    clearAllFilter()
                }
                
            } label: {
                
                HStack {
                    
                    Text(StaticLabel.get("txtClearAll"))
                        .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .regular))
                        .foregroundColor(.amwayBlack)
                        .overlay(Rectangle()
                                    .fill(Color.amwayBlack)
                                    .frame(height: 2)
                                    .offset(y: 2), alignment: .bottom)
                }
            }
            .opacity(showClearAll ? 1 : 0)
        }
    }
}


//struct ExploreCourseView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExploreCourseView()
//    }
//}
