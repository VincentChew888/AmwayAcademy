//
//  DashboardView.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 25/01/22.
//

import SwiftUI
import Shimmer
import AVKit

struct DashboardView: View {
    
    @StateObject var DashboardData : DashboardViewModel = DashboardViewModel.shared
//    @StateObject var courseData = CourseDetailsMainViewModel.shared
    
    @State var showCourseDetails : Bool = false
    @State var showCompletionDetails: Bool = false
    @State var showAdoptFile : Bool = false
    
    @State var isNewUser = RootViewModel.shared.userDetails.showWelcomeVideo
    
    @State var videoXOffset: CGFloat = 0
    
    @State var showInProgressSection = true
    @State var inProgressSectionXOffset: CGFloat = 0
    @State var shouldPlay: Bool = false
    
    // Whenever you animate out anything just set this to whatever you want to be the hero section
    @State var heroSectionCourseType: DashboardCard = .requiredCoursesCard
    
    // This should be a
//    @StateObject var inProgressCourseVM: InProgressCourseViewModel = InProgressCourseViewModel.shared
    
    var leftBarAction : (() -> Void)?
    var rightBarAction : (() -> Void)?
    
    @State var welcomeVideoUrl: URL?
//    @State var welcomeVideoTitle: String = StaticLabel.get("txtWelecomeToAcademy")
    @State var videoPlayer: AVPlayer = AVPlayer()
    
    // Two index variables because This changes on the drag end only
    @State var inProgressCarouselIndex: Int = 0
    // This changes while the drag is happening and is also responsible for offset in Carousel
    @State var inProgressCarouselCurrentIndex: Int = 0
    
    @State var inProgressDashboardCourses: [CourseModel] = []
    @State var curSelectedSection: DashboardCard?
    @StateObject var warningPopupVM: WarningPopupVM = WarningPopupVM.shared
    
    // Setup to use Resizable Sheet
    var resizableSheetCenter: ResizableSheetCenter? {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let window = windowScenes?.windows.first
        
        return window?.windowScene.flatMap(ResizableSheetCenter.resolve(for:))
    }
    
    var body: some View {
        ShowViewWithErrorHandling(mainView: mainView) {
            getAllData(true)
        }
    }
    
    var mainView: some View {
        VStack {
            if DashboardData.getStaticLabelAPIStatus == .Loading {
                DashboardLoadingView(title: AppConstants.defaultLocale == "zh" ? "學習" : "ABO Academy")
            } else if DashboardData.getStaticLabelAPIStatus == .failure(.ApiError) {
                ErrorStateView(imageName: "BrokenLink", title: StaticLabel.get("txtReloadDescription"), fullHeight: true) {
                    DashboardData.getStaticLabelData(lang: AppConstants.defaultLocale)
                }
                .padding(.vertical, 16)
                .padding(.top, (UIApplication.shared.windows.last?.safeAreaInsets.top)!)
            } else if DashboardData.getStaticLabelAPIStatus == .success {
                ZStack {
                    VStack(alignment:.leading,spacing: 0) {
                        
                        NavigationView {
                            ZStack {
                                VStack(alignment: .leading, spacing: 0) {
                                    CustomNavBar(navBarTitle: StaticLabel.get("txtDashboardTitle"), navBarBackIcon: "HeaderCreatorsAIcon", navBarBackIconWidth: 24, navBarBackIconHeight: 24, rightNavButtonIsExploreButton: true, showCompletionDetails: $showCompletionDetails)  {
                                        if let leftBarAction = leftBarAction {
                                            leftBarAction()
                                        }
                                    } rightBarAction: {
                                        if let rightBarAction = rightBarAction {
                                            rightBarAction()
                                        }
                                    }
                                    
            //                        CustomNavBar(navBarTitle: "ABO Academy")
                                    ScrollView {
                                        VStack(alignment: .leading, spacing: 0) {
                                        
                                        // This block is to make in progress section as hero section
                                        if !DashboardData.getCardShowStatus(.requiredCoursesCard) || (DashboardData.getRequiredCourseAPIStatus == .success && DashboardData.requiredCourses.isEmpty) {
                                            VStack{}
                                                .frame(width: 0)
                                                .onAppear {
                                                heroSectionCourseType = .inProgressCoursesCard
                                            }
                                        }
                                            
                                            //Welcome Video Section
                                            if isNewUser {
                                                if DashboardData.getWelcomeVideoAPIStatus == .success {
                                                    welcomeVideoSection
                                                } else if DashboardData.getWelcomeVideoAPIStatus == .Loading {
                                                    WelcomeVideoCardLoadingView()
                                                } else if DashboardData.getWelcomeVideoAPIStatus == .failure(.ApiError) {
                                                    WelcomeVideoCardErrorView() {
                                                        getWelcomeVideo()
                                                    }
                                                }
                                                
            //                                        .animation(.spring())
                                            }
                                            
                                            VStack(alignment: .leading, spacing: 32) {
                                                
                                                
                                                //Required Course Card Section
                                                if DashboardData.getCardShowStatus(.requiredCoursesCard) && !(DashboardData.getRequiredCourseAPIStatus == .success && DashboardData.requiredCourses.isEmpty) {
                                                    requiredCourseSection
                                                }
                                                
                                                
                                                //Not in this release so hiding the shared with me section
                                                //Assigned Course Card Section
            //                                    if DashboardViewModel.shared.getCardShowStatus(.assignedCoursesCard) {
            //                                        sharedWithMeCourseSection
            //                                    }
                                                
                                                //InProgress Course Card Section
                                                if DashboardViewModel.shared.getCardShowStatus(.inProgressCoursesCard) {
                                                    if showInProgressSection {
                                                        if DashboardData.getInProgressCoursesAPIStatus == .success && DashboardData.inProgressCourses.count > 0 {
                                                            VStack(alignment: .leading,spacing: 16) {
                                                                                                                    
                                                                ListHeader(headerTitle: StaticLabel.get("txtInProgress"), isRelatedToCourses: false, courseType: .inProgress, courseSection: .inProgressCoursesCard, showCompletionDetails: $showCompletionDetails)
                                                                    .padding(.horizontal, 16)
                                                                SnapCarousel(index: $inProgressCarouselIndex, currentIndex: $inProgressCarouselCurrentIndex, items: $DashboardData.inProgressCourses) {course in
                                                                    InProgressCardView(course: course, carouselIndex: $inProgressCarouselCurrentIndex, inProgressDashboardCourses: $inProgressDashboardCourses)
                                                                }
                                                                .frame(height: 330)
                                                                .animation(.easeInOut)
                                                                .onTapGesture {
                                                                    DashboardData.selectedCourse = DashboardData.inProgressCourses[inProgressCarouselIndex]
                                                                    // Setting the section from which this course is selected
                                                                    curSelectedSection = .inProgressCoursesCard
                                                                    showCourseSheet()
                                                                }
                                                                
                                                                // Indicator...
                                                                HStack(alignment: .center, spacing: 12) {
                                                                    ForEach((0..<min(inProgressDashboardCourses.count, 5)), id: \.self) { i in
                                                                        Circle()
                                                                            .fill(i == inProgressCarouselCurrentIndex ? Color.darkPurple : Color.outlinePurple)
                                                                            .frame(width: 8, height: 8)
                                                                        
                                                                    }
                                                                }
                                                                .frame(maxWidth: .infinity)
                                                                    
            //                                                    if DashboardData.inProgressCourses.count == 0 {
            //                                                        VStack {}
            //                                                        .onAppear() {
            //                                                            removeInProgressCourseSection()
            //                                                        }
            //                                                    } else {
            //                                                        VStack {}
            //                                                        .onAppear() {
            //                                                            showInProgressCourseSection()
            //                                                        }
            //                                                    }
                                                            }
                                                            
                                                        } else if DashboardData.getInProgressCoursesAPIStatus == .Loading {
                                                            CourseCardLoadingView(cardCount: 1, displayHorizontal: false)
                                                                .padding(.horizontal, 16)
                                                        } else if DashboardData.getInProgressCoursesAPIStatus == .failure(.ApiError) {
                                                            VStack(alignment: .leading,spacing: 16) {
                                                                ListHeader(headerTitle: StaticLabel.get("txtInProgress"), isRelatedToCourses: false, courseType: .inProgress, courseSection: .inProgressCoursesCard, showCompletionDetails: $showCompletionDetails)
                                                                    .padding(.horizontal, 16)
                                                                ErrorStateView(imageName: "BrokenLink", title: StaticLabel.get("txtReloadDescription")) {
                                                                    DashboardData.getCourses(courseType: CourseType.inProgress.rawValue, isDashboard: true, pageSize: 3, pageNumber: 0, locale: AppConstants.defaultLocale, sortBy: SortBy.most_relevant.description){
                                                                        
                                                                    }
                                                                }
                                                                .padding(.top, 16)
                                                            }
                                                        }
                                                        
                                                        
                                                    }
                                                }
                                                
                                                if DashboardViewModel.shared.getCardShowStatus(.myCourses) {
                                                    NavigationLink(destination: MyCourseView(courseSection: nil)) {
                                                        SectionView(image: "Courses", title: StaticLabel.get("txtMyCourses"), subtitle: StaticLabel.get("txtMyCoursesDescription"), forgroundColor: Color.darkPurple, backgroundColor: Color.white)
                                                            .padding(.horizontal, 16)
                                                    }
                                                    .buttonStyle(PlainButtonStyle())
                                                    .simultaneousGesture(TapGesture().onEnded {
                                                        
                                                        let myCoursesTouch = GenericEventInfo(name: "Academy: Touch: My Courses")
                                                        RootViewModel.shared.creatorAction?.action(.analytics(event: myCoursesTouch))
                                                        
                                                        curSelectedSection = nil
                                                    })
                                                }
                                                
                                                // Course For You Card Section
                                                if DashboardViewModel.shared.getCardShowStatus(.coursesForYouCard) && !(DashboardData.getCoursesForYouCourseAPIStatus == .success && DashboardData.CoursesForYouCourses.isEmpty) {
                                                    coursesForYouCourseSection
                                                }
                                                
                                                //Quick Start Courses Section
                                                if DashboardViewModel.shared.getCardShowStatus(.quickStartCoursesCard) && !(DashboardData.getQuickStartCoursesAPIStatus == .success && DashboardData.quickStartCourses.isEmpty) {
                                                    
                                                    if DashboardData.getQuickStartCoursesAPIStatus == .success {
                                                        VStack(alignment: .leading,spacing: 16) {
                                                            
                                                            ListHeader(headerTitle: StaticLabel.get("txtQuickStartCourses"), isRelatedToCourses: false, headerType: .small, courseType: .quickStart, courseSection: .quickStartCoursesCard, showCompletionDetails: $showCompletionDetails)
                                                            
                                                                VStack(spacing: 0) {
                                                                    
                                                                    ForEach(0..<min(DashboardData.quickStartCourses.count, 3), id:\.self) { index in
                                                                        Button(action: {
                                                                            DashboardData.selectedCourse = DashboardData.quickStartCourses[index]
                                                                            // Setting the section from which this course is selected
                                                                            curSelectedSection = .quickStartCoursesCard
                                                                            showCourseSheet()
                                                                        }) {
                                                                            QuickStartCardView(course: $DashboardData.quickStartCourses[index])
                                                                        }
                                                                        if index != DashboardData.quickStartCourses.count - 1 {
                                                                            Divider()
                                                                                .frame(height: 1)
                                                                                .padding(.horizontal, 16)
                                                                        }
                                                                    }
                                                                }
                                                                .background(Color.white)
                                                                .customRoundedRectangle()
                                                            }
                                                            .padding(.horizontal, 16)
            //                                        .animation(.spring())
                                                    } else if DashboardData.getQuickStartCoursesAPIStatus == .Loading {
                                                        quickStartListLoadingView
                                                            .padding(.horizontal, 16)
                                                    } else if DashboardData.getQuickStartCoursesAPIStatus == .failure(.ApiError) {
                                                        VStack(alignment: .leading,spacing: 16) {
                                                            ListHeader(headerTitle: StaticLabel.get("txtQuickStartCourses"), isRelatedToCourses: false, headerType: .small, courseType: .quickStart, courseSection: .quickStartCoursesCard, showCompletionDetails: $showCompletionDetails)
                                                                .padding(.horizontal, 16)
                                                            ErrorStateView(imageName: "BrokenLink", title: StaticLabel.get("txtReloadDescription")) {
                                                                DashboardData.getCourses(courseType: CourseType.quickStart.rawValue, isDashboard: true, pageSize: 3, pageNumber: 0, locale: AppConstants.defaultLocale, sortBy: SortBy.most_relevant.description){
                                                                }
                                                            }
                                                                .padding(.top, 16)
                                                        }
                                                    }
                                                }
                                                
                                                if DashboardViewModel.shared.getCardShowStatus(.exploreCard) {
                                                    NavigationLink(destination: ExploreCourseView(courseSection: nil)) {
                                                        SectionView(image: "ExploreCourse", title: StaticLabel.get("txtExplore"), subtitle: StaticLabel.get("txtExploreDescription"), forgroundColor: Color.white, backgroundColor: Color.darkPurple)
                                                            .padding(.horizontal, 16)
                                                    }
                                                    .buttonStyle(PlainButtonStyle())
                                                    .simultaneousGesture(TapGesture().onEnded {
                                                        
                                                        let exploreCoursesButtonTouch = GenericEventInfo(name: "Academy: Touch: Explore Courses Button")
                                                        RootViewModel.shared.creatorAction?.action(.analytics(event: exploreCoursesButtonTouch))
                                                    })
            //                                        .animation(.spring())
                                                }
                                                
                                                /*
                                                //Not in this release so hiding the shared with me section
                                                //Learning Path Card Section
                                                if DashboardViewModel.shared.getCardShowStatus(.learningPathCard) {
                                                    learningPathCardSection
                                                }
                                                */
                                                //                            SectionView(image: "MyCourses", title: "My Courses", subtitle: "View all your Required, Assigned, In Progess, Favorite, Downloaded, and completed courses.", forgroundColor: Color.darkPurple, backgroundColor: Color.white)
                                                
                                                /*
                                                 //Courses For You Section For Hero Content
                                                 Section(header: HStack {
                                                 ListHeader(headerTitle: "Courses For You", isRelatedToCourses: true)
                                                 .padding()
                                                 Spacer()
                                                 }
                                                 .background(Color.darkPurple)
                                                 .listRowInsets(EdgeInsets(top: -10, leading: 0, bottom: -10, trailing: 0))
                                                 ) {
                                                 ScrollView(.horizontal, showsIndicators: false) {
                                                 LazyHStack(spacing: 0, pinnedViews: .sectionHeaders) {
                                                 CourseCardView()
                                                 .frame(width: gp.size.width * 0.80)
                                                 CourseCardView()
                                                 .frame(width: gp.size.width * 0.80)
                                                 CourseCardView()
                                                 .frame(width: gp.size.width * 0.80)
                                                 CourseCardView()
                                                 .frame(width: gp.size.width * 0.80)
                                                 .padding(.trailing)
                                                 }
                                                 }
                                                 }
                                                 .background(Color.darkPurple)
                                                 .listRowBackground(Color.darkPurple)//Only if first row
                                                 .listSectionSeparator(.hidden)
                                                 .padding(EdgeInsets(top: 10, leading: -20, bottom: 10, trailing: -20))
                                                 */
                                            }
                                            .padding(.bottom, 32)
                                            
                                        }
            //                            .navigationBarHidden(true)
            //                            .ignoresSafeArea()
                                        
                                    }
                                   // .ignoresSafeArea()
                                    .background(Color.backGround)
            //                        .frame(height: UIScreen.main.bounds.height - 130)
                                }
                                .onAppear {
                                   getSelectedSectionData()
                                }
                                .frame(maxHeight: .infinity)
                                .navigationBarHidden(true)
                                .edgesIgnoringSafeArea(.top)
            //                    .ignoresSafeArea()
                                
                                // Warningpopup
                                VStack {
                                    WarningPopupView(showWarningPopup: $warningPopupVM.showWarningPopup, title: warningPopupVM.title, description: warningPopupVM.description)
                                        .offset(x: 0, y: warningPopupVM.showWarningPopup ? 0 : -200)
                                        .animation(.spring(), value: warningPopupVM.showWarningPopup)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                            }
                            
                            
                        }
                    }
        //            .frame(height: UIScreen.main.bounds.height-AppConstants.bottomTabBarHeight)
        //            .ignoresSafeArea()
        //            .navigationBarHidden(true)
                    
//                    if (showCourseDetails || showCertificateDetails || showWithoutCertificateDetails || showCompletionDetails) {
//                        Color.white.opacity(0.5)
//                            .ignoresSafeArea()
//                            .transition(.move(edge: .bottom))
//        //                    .animation(.default)
//
//                    }
                    VStack {}
                        .sheet(isPresented: $showCompletionDetails, onDismiss: {
                            resetInProgressIndex()
                            getSelectedSectionData()
                        }) {
                            CompletionDetailsView(courseId: $DashboardData.selectedCourse.courseId, reloadCourses: .constant(false), courseSection: curSelectedSection)
                                .onAppear {
                                    UIScrollView.appearance().bounces = false
                                    videoPlayer.pause()
                                    shouldPlay = false
                                }.onDisappear {
                                    UIScrollView.appearance().bounces = true
                                }
                        }
                    
                    VStack {}
                        .sheet(isPresented: $showCourseDetails, onDismiss: {
                            resetInProgressIndex()
                            getSelectedSectionData()
                        }) {
                            CourseDeatilsMainView(courseId: $DashboardData.selectedCourse.courseId,showCourseDetails: $showCourseDetails, showCompletionDetails: $showCompletionDetails, reloadCourses: .constant(false), courseSection: curSelectedSection)
                                .onAppear {
                                    UIScrollView.appearance().bounces = false
                                    videoPlayer.pause()
                                    shouldPlay = false
                                }.onDisappear {
                                    UIScrollView.appearance().bounces = true
                                }
                        }
                }
                .environment(\.resizableSheetCenter, resizableSheetCenter)
            }
        }
    }
    var welcomeVideoSection: some View {
        VStack {
            Section() {
                WelcomeVideoCardView(player: $videoPlayer,shouldPlay: $shouldPlay) {
                    onVideoEnd()
                }
                .offset(x: videoXOffset, y: 0)
                
            }
            .padding(.bottom, videoXOffset < 0 ? 140 : 0)
//            .animation(.spring())
            .listRowBackground(Color.darkPurple)
//            .listSectionSeparator(.hidden)
        }
        .padding(.bottom, 24)
        .padding(.top, 40)
        .background(Color.darkPurple)
        .padding(.bottom, 40)
       
       
    
    }
    
    func getSelectedSectionData() {
        
        switch DashboardData.selectedCourseSection {
        case .welcomeVideoCard:
            getWelcomeVideo()
        case .requiredCoursesCard:
            getRequiredCourses()
        case .assignedCoursesCard:
            break
        case .inProgressCoursesCard:
            getInProgressCourses()
        case .coursesForYouCard:
            getCoursesForYouCourses()
        case .exploreCard:
            break
        case .quickStartCoursesCard:
            getQuickStartCourses()
        case .learningPathCard:
            break
        case .myCourses:
            break
        case .noCard:
            return
        case .none:
            getAllData()
        }
        
        if curSelectedSection != .inProgressCoursesCard && curSelectedSection != nil {
            getInProgressCourses()
        }
        
        curSelectedSection = .noCard
        DashboardData.selectedCourseSection = .noCard
    }
    
    func getAllData(_ force: Bool = false) {
        if RootViewModel.shared.isDifferentPartyID() || force {
            DashboardData.getCourseData()
            getWelcomeVideo()
            getRequiredCourses()
            getInProgressCourses()
            getCoursesForYouCourses()
            getQuickStartCourses()
       
        }
//        getLanguageData()
        
    }
    
    func getQuickStartCourses() {
        DashboardData.getCourses(courseType: CourseType.quickStart.rawValue, isDashboard: true, pageSize: 3, pageNumber: 0, locale: AppConstants.defaultLocale, sortBy: SortBy.most_relevant.description){
            
        }
    }
    
    func getInProgressCourses() {
        DashboardData.getCourses(courseType: CourseType.inProgress.rawValue, isDashboard: true, pageSize: 20, pageNumber: 0, locale: AppConstants.defaultLocale, sortBy: SortBy.most_relevant.description){
            inProgressDashboardCourses.removeAll()
            for i in 0..<min(DashboardData.inProgressCourses.count, 6) {
                inProgressDashboardCourses.append(DashboardData.inProgressCourses[i])
            }
        }
    }
    
    func getRequiredCourses() {
        DashboardData.getCourses(courseType: CourseType.Required.rawValue, isDashboard: true, pageSize: 10, pageNumber: 0, locale: AppConstants.defaultLocale, sortBy: SortBy.most_relevant.description){
            
        }
    }
    
    func getCoursesForYouCourses() {
        DashboardData.getCourses(courseType: CourseType.CoursesForYou.rawValue, isDashboard: true, pageSize: 10, pageNumber: 0, locale: AppConstants.defaultLocale, sortBy: SortBy.most_relevant.description){
            
        }
    }
    
    func resetInProgressIndex() {
        inProgressCarouselIndex = 0
        inProgressCarouselCurrentIndex = 0
    }
    
    func getLanguageData() {
        // Fetching Language data
        let langData = LangViewModel.shared
        langData.fetchLangData(locale: langData.selectedLang.langCode){
            let reqLangArr = langData.LangArr.filter({ lang in
                lang.langCode == langData.selectedLang.langCode
            })
            if reqLangArr.isEmpty {
                langData.selectedLang.langCode = "en-us"
                langData.selectedLang.language = "English"
            } else {
                langData.selectedLang = reqLangArr[0]
            }
        }
    }
    
    func getWelcomeVideo() {
        DashboardData.getWelcomeVideo(locale: AppConstants.defaultLocale) {
            guard let url = URL(string: DashboardData.welcomeResponse.url) else {
                return;
            }
            
            AmwayAppLogger.generalLogger.debug(DashboardData.welcomeResponse.url)
//            welcomeVideoTitle = StaticLabel.get("txtWelecomeToAcademy")
            welcomeVideoUrl = url
            videoPlayer = AVPlayer(url: url)
//            @AppStorage("isNewUser") var isNewUserFromStorage = true;
            
//            if isNewUserFromStorage {
//                // Turn isNewUser true
//                isNewUser = true
//            }
        }
    }
    
    var requiredCourseSection: some View {
        let isHeroSection: Bool = (heroSectionCourseType == .requiredCoursesCard) && !isNewUser
        // this variable is same as above variable but this will not animate the changes it makes.
        let isHeroSectionNoAnim: Bool = isHeroSection
        return CourseHorizontalListView(headerTitle: StaticLabel.get("txtRequiredCourses"), courses: $DashboardData.requiredCourses, selectedCourse: $DashboardData.selectedCourse, apiStatus: $DashboardData.getRequiredCourseAPIStatus, showCompletionDetails: $showCompletionDetails, curSelectedSection: $curSelectedSection,
                                        headerTextColor: isHeroSection ? .white : nil,courseType: .Required, courseSection: .requiredCoursesCard, limitCoursesCnt: 10, onReloadButtonClick: {
            getRequiredCourses()
        }, onCourseCardClick: {
            showCourseSheet()
        })
            .animation(.spring(), value: isNewUser)
            .padding(.top, isHeroSection ? 40 : 0)
            .padding(.bottom, isHeroSection ? 24 : 0)
            .background(isHeroSectionNoAnim ? Color.darkPurple : nil)
    }
    
    var sharedWithMeCourseSection: some View {
        let isHeroSection: Bool = (heroSectionCourseType == .assignedCoursesCard) && !isNewUser
        // this variable is same as above variable but this will not animate the changes it makes.
        let isHeroSectionNoAnim: Bool = (heroSectionCourseType == .assignedCoursesCard) && !isNewUser
        return CourseHorizontalListView(headerTitle: StaticLabel.get("txtSharedWithMe"), courses: $DashboardData.courses, selectedCourse: $DashboardData.selectedCourse, apiStatus: .constant(.success), showCompletionDetails: $showCompletionDetails, curSelectedSection: $curSelectedSection,
                                        headerTextColor: isHeroSection ? .white : nil, courseType: .Shared, courseSection: .assignedCoursesCard, limitCoursesCnt: 10
        ) {
            showCourseSheet()
        }
            .animation(.spring(), value: isNewUser)
            .padding(.top, isHeroSection ? 40 : 0)
            .padding(.bottom, isHeroSection ? 24 : 0)
            .background(isHeroSectionNoAnim ? Color.darkPurple : nil)
    }
    
    var coursesForYouCourseSection: some View {
        let isHeroSection: Bool = (heroSectionCourseType == .coursesForYouCard) && !isNewUser
        // this variable is same as above variable but this will not animate the changes it makes.
        let isHeroSectionNoAnim: Bool = (heroSectionCourseType == .coursesForYouCard) && !isNewUser
        return CourseHorizontalListView(headerTitle: StaticLabel.get("txtCoursesForYou"), courses: $DashboardData.CoursesForYouCourses, selectedCourse: $DashboardData.selectedCourse, apiStatus: $DashboardData.getCoursesForYouCourseAPIStatus, showCompletionDetails: $showCompletionDetails, curSelectedSection: $curSelectedSection, headerTextColor: isHeroSection ? .white : nil, courseType: .CoursesForYou, courseSection: .coursesForYouCard, limitCoursesCnt: 10, errorViewHeight: 400, onReloadButtonClick: {
               getCoursesForYouCourses()
            }, onCourseCardClick: {
                showCourseSheet()
            }
        )
            .animation(.spring(), value: isNewUser)
            .padding(.top, isHeroSection ? 40 : 0)
            .padding(.bottom, isHeroSection ? 24 : 0)
            .background(isHeroSectionNoAnim ? Color.darkPurple : nil)
    }
    
    var learningPathCardSection: some View {
        let isHeroSection: Bool = (heroSectionCourseType == .learningPathCard) && !isNewUser
        // this variable is same as above variable but this will not animate the changes it makes.
        let isHeroSectionNoAnim: Bool = (heroSectionCourseType == .learningPathCard) && !isNewUser
        return CourseHorizontalListView(headerTitle: StaticLabel.get("txtLearningPaths"), courses: $DashboardData.courses, selectedCourse: $DashboardData.selectedCourse, apiStatus: .constant(.success), showCompletionDetails: $showCompletionDetails, curSelectedSection: $curSelectedSection, descLineLimit: 3, headerTextColor: isHeroSection ? .white : nil, courseSection: DashboardCard.learningPathCard, isLearningPath: true, limitCoursesCnt: 10
        ) {
            showCourseSheet()
        }
            .animation(.spring(), value: isNewUser)
            .padding(.top, isHeroSection ? 40 : 0)
            .padding(.bottom, isHeroSection ? 24 : 0)
            .background(isHeroSectionNoAnim ? Color.darkPurple : nil)
    }
    
    var quickStartListLoadingView: some View {
        VStack {
            // Header
            VStack{ }
                .frame(height: 10)
                .frame(maxWidth: .infinity)
                .background(Color.gray)
                .padding(.top, 16)
                .padding(.bottom, 16)
            VStack(spacing: 0) {
                
                ForEach(0..<min(DashboardData.courses.count, 3), id:\.self) { index in
                    QuickStartCardView(course: $DashboardData.courses[index], isLoading: true)
                    if index != DashboardData.quickStartCourses.count - 1 {
                        Divider()
                            .frame(height: 1)
                            .padding(.horizontal, 16)
                    }
                }
            }
            .background(Color.white)
            .customRoundedRectangle()
        }
        .redacted(reason: .placeholder)
        .shimmering(duration: 1.0)
    }
    
    func onVideoEnd() {
        if !isNewUser {
            isNewUser = true
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                withAnimation(.spring()) {
                    videoXOffset = 0
                }
            }
        } else {
            // Set isNewUser to false in userdefaults
//            UserDefaults.standard.set(false, forKey: "isNewUser")
            withAnimation(.spring()) {
                videoXOffset = -UIScreen.main.bounds.width
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                isNewUser = false
            }
        }
        
        DashboardData.seenWelcomeVideo()
        
        
    }
    
    func removeInProgressCourseSection() {
        withAnimation(.spring()) {
            inProgressSectionXOffset = -UIScreen.main.bounds.width
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            withAnimation(.spring()) {
                showInProgressSection = false
            }
        }
    }
    
    func showInProgressCourseSection() {
        withAnimation(.spring()) {
            showInProgressSection = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            withAnimation(.spring()) {
                inProgressSectionXOffset = 0
            }
        }
    }
    
    func showCourseSheet() {
        let course = DashboardData.selectedCourse
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
    
    func getQSCoursesCount() -> Int {
        let quickStartCoursesCount = $DashboardData.quickStartCourses.count
        return min(3, quickStartCoursesCount)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DashboardView()
        }
    }
}
