//
//  CoursesListView.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 08/03/22.
//

import SwiftUI
import Shimmer

struct CoursesListView: View {
    var navBarTitle: String
    @StateObject var ListData : ListViewModel = ListViewModel.shared
    @ObservedObject var DashboardData : DashboardViewModel = DashboardViewModel.shared
    
    @State var showEmptyView : Bool = false
    @State var showCourseDetails : Bool = false
    @State var selectedSortFilter: SortBy = .most_relevant

    var courseType: CourseType = .Default
    var courseSection: DashboardCard?
    @State var showCompletionDetails: Bool = false
    @State var reloadCourses: Bool = true
    
//    @EnvironmentObject var coursesData: DashboardViewModel
    
    @State var filterSheetState: ResizableSheetState = .hidden
    @StateObject var warningPopupVM: WarningPopupVM = WarningPopupVM.shared
    
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        ShowViewWithErrorHandling(mainView: mainView) {
            getData()
        }
    }
    
    var mainView: some View {
        ZStack {
            VStack(alignment:.leading, spacing: 0) {
                
                CustomNavBar(navBarTitle: navBarTitle, showRightNavButton: true, showCompletionDetails: $showCompletionDetails) {
                    
                    reloadCourses = true
                    ListData.CoursesList.removeAll()
                    presentation.wrappedValue.dismiss()
                } rightBarAction: {
                    filterSheetState = .medium
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    if ListData.CoursesList.count > 0 {
                        LazyVStack(spacing: 16) {
                            if ListData.getCoursesDataAPIStatus != .failure(.ApiError) {
                                ForEach($ListData.CoursesList, id:\.courseId) { curCourse in
                                    CourseCardView(course: curCourse, courseType: courseType, imageName: "DefaultImage", lineLimit: 2, cornerRadius: 12, mediumCardWidth: false)
                                        .frame(width: UIScreen.main.bounds.width - 32)
                                        .onAppear {
                                            if !ListData.CoursesList.isEmpty {
                                                ListData.loadMoreContent(currentItem: curCourse.wrappedValue, courseType: courseType, sortBy: selectedSortFilter.description)
                                            }
                                        }
                                        .onTapGesture {
                                            ListData.selectedCourse = curCourse.wrappedValue
                                            showCourseSheet()
                                        }
                                }
                            }
                        }
                        .padding([.leading, .trailing], 16)
                        .padding(.bottom, 8)
                        .padding(.vertical, 24)
                    }
                    
                    if ListData.getCoursesDataAPIStatus == .Loading {
                        CourseCardLoadingView(cardCount: 3, displayHorizontal: false, noHeader: true)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 24)
                    } else if ListData.getCoursesDataAPIStatus == .failure(.ApiError) {
                        ErrorStateView(imageName: "BrokenLink", title: StaticLabel.get("txtReloadDescription")) {
                            reloadCourses = true
                            getData()
                        }
                        .padding(.top, 16)
                        .padding(.vertical, 24)
                    }
                }
            }
    //            .navigationBarBackButtonHidden(true)
            //.ignoresSafeArea()
            .frame(maxHeight: .infinity)
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.top)
            .background(Color.backGround)
            //.edgesIgnoringSafeArea(.bottom)
            
            .onAppear() {
                sendHeapAnalyticalEvents()
                getData()
            }
            .onDisappear {
                ListData.CoursesList.removeAll()
            }
            .resizableSheet($filterSheetState, id: "filter-sheet") { builder in
                builder.content { context in
                    filterSheet
                }
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
                    getData()
                }) {
                    CompletionDetailsView(courseId: $ListData.selectedCourse.courseId, reloadCourses: $reloadCourses, courseSection: courseSection)
                        .onAppear {
                            UIScrollView.appearance().bounces = false
                        }.onDisappear {
                            UIScrollView.appearance().bounces = true
                        }
                }
            
            VStack {}
                .sheet(isPresented: $showCourseDetails, onDismiss: {
                    getData()
                }) {
                    CourseDeatilsMainView(courseId: $ListData.selectedCourse.courseId, showCourseDetails: $showCourseDetails, showCompletionDetails: $showCompletionDetails, reloadCourses: $reloadCourses, courseSection: courseSection)
                                .onAppear {
                                    UIScrollView.appearance().bounces = false
                                }
                                .onDisappear {
                                    UIScrollView.appearance().bounces = true
                                }
                }
        }
    }
    
    func sendHeapAnalyticalEvents() {
       
        var viewAllEvent = GenericEventInfo(name: "")
        
        switch courseType {
        
        case .Required:
            viewAllEvent.name = "Academy: Required Courses: Touch: View All"
        case .CoursesForYou:
            viewAllEvent.name = "Academy: Courses For You: Touch: View All"
        case .quickStart:
            viewAllEvent.name = "Academy: Quick Start Courses: Touch: View All"
        case .inProgress:
            viewAllEvent.name = "Academy: In Progress: Touch: View All"
        case .Shared, .Default, .completed, .newest, .favorite, .courseCatalog:
            viewAllEvent.name = "Academy: Touch: View All"
        }
        
        RootViewModel.shared.creatorAction?.action(.analytics(event: viewAllEvent))
        
        ListData.getListCourses(courseType: courseType.rawValue, isDashboard: false, page: 0, size: 10, locale: AppConstants.defaultLocale, sortBy: selectedSortFilter.description)
    }
    
    func getData() {
        if !reloadCourses {
            return
        }
        reloadCourses = false
        ListData.CoursesList.removeAll()
        ListData.getListCourses(courseType: courseType.rawValue, isDashboard: false, page: 0, size: 10, locale: AppConstants.defaultLocale, sortBy: selectedSortFilter.description)
    }
    
    var filterSheet: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Spacer()
                Rectangle()
                    .frame(width: 50, height: 3)
                    .background(Color.darkGray)
                Spacer()
            }
            .frame(height: 35)
            .background(Color.amwayWhite)
            .allowsHitTesting(false)
            
            Text(StaticLabel.get("txtSortBy"))
                .font(.getCustomFontWithSize(fontType: .gt_walsheim_medium, fontSize: .vlargemid))
                .padding(.horizontal, 16)
            
            VStack(alignment: .leading) {
                Divider().foregroundColor(.darkGray)
                    .padding(.bottom, 0)
                
                VStack(alignment: .leading, spacing: 25) {
                    ScrollView {
                        RadioButtonGroup(items: SortBy.allCases.map { $0.rawValue }, selectedId: SortBy.allCases[0].rawValue) { selected in
                            
                            if let enumValue = SortBy(rawValue: selected) {
                                reloadCourses = true
                                selectedSortFilter = enumValue
                                ListData.CoursesList.removeAll()
                                getData()
                                filterSheetState = .hidden
                                AmwayAppLogger.generalLogger.debug(enumValue.description)
                            } else {
                                AmwayAppLogger.generalLogger.debug("---")
                            }
                            //print("Selected is: \(selected)")
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 30)
                    }
                }
                .padding([.horizontal], 16)
            }
            .padding(.bottom, 16)
        }
        .frame(minHeight: UIScreen.main.bounds.height/2.3)
    }
    
    func showCourseSheet() {
        let course = ListData.selectedCourse
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
}

//struct CoursesListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CoursesListView(navBarTitle: "", courseSection: .noCard)
//    }
//}
