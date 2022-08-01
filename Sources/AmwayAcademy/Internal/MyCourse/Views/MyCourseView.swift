//
//  MyCourseView.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 22/02/22.
//

import SwiftUI
import Shimmer

struct MyCourseView: View {
    @State var showCompletionDetails: Bool = false
    @StateObject var myCourseVM : MyCourseVM = MyCourseVM.shared
    
    @State var filterSheetState: ResizableSheetState = .hidden
    @State var showCourseDetails : Bool = false
    @State var selectedSortFilter: SortBy = .most_relevant
    
    @State var reloadCourses: Bool = true
    var courseSection: DashboardCard?
    
    @StateObject var warningPopupVM: WarningPopupVM = WarningPopupVM.shared
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        ShowViewWithErrorHandling(mainView: mainView) {
            getData(myCourseVM.clickedCard)
        }
    }
    
    var mainView: some View {
        
        ZStack {
            
            VStack(alignment:.leading, spacing: 0) {
                
                CustomNavBar(navBarTitle: StaticLabel.get("txtMyCourses"), showRightNavButton: true, showCompletionDetails: $showCompletionDetails) {
                    myCourseVM.clickedCard = .requiredCourses
                    resetVM()
                    presentation.wrappedValue.dismiss()
                } rightBarAction: {
                    //right nav bar button action
                    filterSheetState = .medium
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack(spacing: 8) {
                        
                        ForEach(0..<MyCourses.allCases.count, id:\.self) { index in
                            
                            Button(action: {
                                resetVM()
                                myCourseVM.clickedCard = MyCourses.allCases[index]
                                myCourseVM.getSelectedCourseEmptyState()
                                reloadCourses = true
                                getData(myCourseVM.clickedCard)
                                
                            }, label: {
                                Text(StaticLabel.get("txt\(MyCourses.allCases[index].rawValue)"))
                                    .font(.getCustomFontWithSize(fontType: .gt_walsheim_medium, fontSize: .regular))
                                    .foregroundColor(getForegroundColor(index))
                            })
                                .fixedSize()
                                .frame(height: 24)
                                .padding(.horizontal, 10)
                                .background(self.getBackgroundColor(index))
                                .clipShape(Capsule())
                                .customRoundedRectangleOverlay(cornerRadius: 50, color: .darkPurple, lineWidth: 1.0)
                                .disabled(myCourseVM.coursesAPIStatus == .Loading)
                        }
                    }
                    .padding([.leading, .trailing], 16)
                }
                .padding([.top, .bottom], 24)
                
                VStack {
                    if myCourseVM.coursesAPIStatus != .failure(.ApiError) {
                        if myCourseVM.coursesAPIStatus == .success && myCourseVM.filteredCourses.count == 0 {
                            VStack {
                                MyCoursesEmptyView(emptyData: $myCourseVM.selectedCourseEmptyData, courseSection: courseSection, courseType: myCourseVM.clickedCard)
                            }
                            .padding([.top], 8)
                        } else {
                            ScrollView(.vertical, showsIndicators: false) {
                                if myCourseVM.filteredCourses.count > 0 {
                                    LazyVStack(alignment: .leading, spacing: 16) {
    
                                        ForEach($myCourseVM.filteredCourses, id:\.self) { curCourse in
                                            CourseCardView(course: curCourse, courseType: myCourseVM.courseCardType, isFromMyCoursesView: true, mediumCardWidth: false)
                                                .onAppear {
                                                    if !myCourseVM.filteredCourses.isEmpty && myCourseVM.filteredCourses.last == curCourse.wrappedValue {
                                                        getData(myCourseVM.clickedCard)
                                                    }
                                                }
                                                .padding([.leading, .trailing], 16)
                                                .shadow(radius: 2)
                                                .onTapGesture {
                                                    myCourseVM.selectedCourse = curCourse.wrappedValue
                                                    showCourseSheet()
                                                }
    
                                        }
                                    }
                                    .padding(.bottom, 8)
                                }
    
                                if myCourseVM.coursesAPIStatus == .Loading {
                                    CourseCardLoadingView(cardCount: 5, displayHorizontal: false, noHeader: true, descLineLimit: 3)
                                        .padding(.horizontal, 16)
                                }
                            }
    //                        .navigationBarHidden(true)
    
                        }
                    }
                    if myCourseVM.coursesAPIStatus == .failure(.ApiError) {
                        ErrorStateView(imageName: "BrokenLink", title: StaticLabel.get("txtReloadDescription")) {
                            getData(myCourseVM.clickedCard)
                        }
                        .padding(.top, 16)
                    }
//                    Spacer()
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .frame(maxHeight: .infinity)
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.top)
            //.edgesIgnoringSafeArea(.top)
            .background(Color.backGround)
            .onAppear {
                myCourseVM.getEmptyCourseData()
                getData(myCourseVM.clickedCard)
                myCourseVM.getSelectedCourseEmptyState()
            }
            .onDisappear {
//                myCourseVM.clickedCard = .requiredCourses
                resetVM()
            }
           
       // }
       
        
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
                    if !reloadCourses {
                        return
                    }
                    resetVM()
                    getData(myCourseVM.clickedCard)
                }) {
                    CompletionDetailsView(courseId: $myCourseVM.selectedCourse.courseId, reloadCourses: $reloadCourses, courseSection: courseSection)
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
                    resetVM()
                    getData(myCourseVM.clickedCard)
                }) {
                    CourseDeatilsMainView(courseId: $myCourseVM.selectedCourse.courseId, showCourseDetails: $showCourseDetails, showCompletionDetails: $showCompletionDetails, reloadCourses: $reloadCourses, courseSection: courseSection)
                        .onAppear {
                            UIScrollView.appearance().bounces = false
                        }.onDisappear {
                            UIScrollView.appearance().bounces = true
                        }
                }
        }
    }
    
    
    func showCourseSheet() {
        let course = myCourseVM.selectedCourse
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
    
    func getData(_ courseType: MyCourses) {
        reloadCourses = false
        myCourseVM.getSelectedMyCoursesData(myCourseType: courseType, isFallThrough: true, isDashboard: false, page: myCourseVM.pageNumber, size: myCourseVM.pageSize, locale: AppConstants.defaultLocale, sortBy: selectedSortFilter.description)
    }
    
    func resetVM() {
        reloadCourses = true
        myCourseVM.pageNumber = 0
        myCourseVM.isNextPageAvailable = true
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
                                
                                resetVM()
                                selectedSortFilter = enumValue
                                getData(myCourseVM.clickedCard)
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
    
    func getBackgroundColor(_ value: Int) -> Color {
        return myCourseVM.clickedCard == MyCourses.allCases[value] ? .darkPurple : .white
    }
    
    func getForegroundColor(_ value: Int) -> Color {
        return myCourseVM.clickedCard == MyCourses.allCases[value] ? .white : .darkPurple
    }
    
}


//struct MyCourseView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyCourseView()
//    }
//}
