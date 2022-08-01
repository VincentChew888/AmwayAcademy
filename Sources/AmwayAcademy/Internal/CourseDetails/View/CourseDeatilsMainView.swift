//
//  CourseDeatilsMainView.swift
//  ABOAcademy
//
//  Created by Swapnil Tilkari on 24/02/22.
//

import SwiftUI
import Shimmer
import SDWebImageSwiftUI

struct CourseDeatilsMainView: View {
    
    @Binding var courseId : String
    
   @Binding var showCourseDetails : Bool
    @Binding var showCompletionDetails: Bool
    @Binding var reloadCourses: Bool
    var courseSection: DashboardCard?

    @StateObject var langData = LangViewModel.shared
    @StateObject var courseData = CourseDetailsMainViewModel.shared
    //    @State private var selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = UISheetPresentationController.Detent.Identifier.medium
    @State var showWeView : Bool = false
    @StateObject var courseDetailsVM = CourseDetailsMainViewModel.shared
    @State var isLoading = false
    @State var showCertificateDetailsSheet = false
    
//    init() {
//        UIScrollView.appearance().bounces = false
//    }
    
    var body: some View {
        ShowViewWithErrorHandling(mainView: mainView) {
            getData()
        }
    }
    
    var mainView: some View {
        VStack {
            if showCertificateDetailsSheet {
                if courseData.course.isCertificateAvailable {
                    CertificateCourseCompletion(courseId: $courseId, showCertificateDetails: $showCourseDetails, showCompletionDetails: $showCompletionDetails)
                } else {
                    WithoutCertCourseCompltetion(courseId: $courseId, showWithoutCertificateDetails: $showCourseDetails, showSecondView: $showCompletionDetails)
                }
            } else {
        ZStack {
            VStack {
                if courseData.getCourseDataAPIStatus == .Loading {
                    CourseDetailsLoadingView()
                } else if courseData.getCourseDataAPIStatus == .success {
    //                if showWeView {
    //                    CourseAdaptView()
    //                } else {
    //                    ZStack(alignment:.top) {
    //
                            ZStack(alignment:.top) {
                                
                                
                                VStack(alignment: .leading, spacing: 0) {
                                   // ScrollView {
                                    //    VStack {
                                            VStack(alignment: .leading, spacing: 0) {
                                                ScrollView {
                                                    VStack(alignment: .leading, spacing: 0) {
    //                                                    Button("CLICK MEEEE") {
    //                                                        showCourseDetails = false
    //                                                        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
    //                                                            showCertificateDetails = true
    //                                                        }
    //
    //                                                    }
                                                        CourseDetailsView(course: courseData.course, courseSection: courseSection, reloadCourses: $reloadCourses)
                                                        {
                                                            langData.fetchLangData(locale: langData.selectedLang.langCode){
                                                                langData.selectedLang = langData.LangArr.filter({ lang in
                                                                    lang.langCode == langData.selectedLang.langCode
                                                                })[0]
                                                                AmwayAppLogger.generalLogger.debug(langData.selectedLang.language)
                                                                courseData.getCourseData(CourseId: courseId,lang: langData.selectedLang.langCode){
                                                                    
                                                                }
                                                            }
                                                           
                                                        }
                                                        if courseData.course.isCertificateAvailable {
                                                        AchivementView()
                                                            .padding(.horizontal,16)
                                                        }
                                                        
                                                       // SyllabusView(courseData: courseData)
                                                          //  .padding(16)
                                                        /// TODO: Related Courses, uncomment in second phase
    //                                                    if courseDetailsVM.getRelatedCoursesAPIStaus == .Loading {
    //                                                        relatedCoursesLoadingView
    //                                                            .padding(16)
    //                                                    } else if courseDetailsVM.getRelatedCoursesAPIStaus == .success {
    //                                                        if courseDetailsVM.relatedCourses.count > 0 {
    //                                                            VStack(alignment: .leading, spacing: 16) {
    //                                                                Text(courseData.getStaticLabelValue(forkey: "txtRelatedCourses"))
    //                                                                    .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .medium))
    //
    //                                                                ScrollView(.horizontal) {
    //                                                                    HStack {
    //                                                                        ForEach(0..<courseDetailsVM.relatedCourses.count){ i in
    //
    //                                                                            CourseCardView(course: .constant(courseDetailsVM.relatedCourses[i]), mediumCardWidth: false)
    //                                                                                .frame(width: AppConstants.courseCardWidth)
    //                                                                                .customShadow(frontColor: .black.opacity(0.1), BackColor: .white)
    //                                                                            .padding(.bottom, 16)
    //
    //                                                                        }
    //                                                                    }
    //
    //                                                                }
    //                                                            }
    //                                                            .padding(16)
    //                                                        }
    //                                                    }
                                                    }
                                                    
                                                }
    //                                            Spacer()
                                                VStack {
                                                    Button {
                                                        isLoading = true
                                                        // Should reload courses on the current screen and the course type on dashboard
                                                        DashboardViewModel.shared.selectedCourseSection = courseSection
                                                        reloadCourses = true
                                                        // On Start Course Click Get the Cookie Data
                                                        courseData.getCookieData(courseId: courseId) {
                                                            isLoading = false
                                                            let isRequired: Bool = courseData.course.courseType.contains(where: { courseType in courseType.lowercased() == CourseType.Required.rawValue.lowercased()})
                                                            
                                                            let courseEvent = CourseEventInfo(name: "Academy: Course: Touch: Start Course:", courseID: courseData.course.courseId, courseName: courseData.course.title, requiredCourse: isRequired)
                                                                        
                                                            RootViewModel.shared.creatorAction?.action(.analytics(event: courseEvent))
                                                            
                                                            showWeView.toggle()
                                                        } failure: {
                                                            
                                                        }
                                                       
                                                    } label: {
                                                        HStack{
                                                            Spacer()
                                                            Text(StaticLabel.get("btnStartCourse"))
                                                                .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .regular))
                                                            Spacer()
                                                        }
                                                        
                                                    }
                                                    .frame(height: 40)
                                                    .background(Color.black)
                                                    .foregroundColor(Color.white)
                                                    .customRoundedRectangle(cornerRadius: 20)
                                                    .padding([.horizontal, .top], 16)
                                                    .padding(.bottom,34)
                                                    
                                                }
                                                .frame(width: UIScreen.main.bounds.width)
                                                .background(Color.white)
                                                .customRoundedRectangle()
                                                
                                            }
                                            //.navigationBarHidden(true)
                                            .background(Color.white)
                                            .shadow(color: .amwayBlack.opacity(0.1), radius: 6, x: 0, y: -2)
                                             //.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 50)
                                            .edgesIgnoringSafeArea(.bottom)
                                            
                                          
                                       // }
                                   // }
                                }
                                HStack {
                                    Spacer()
                                    Rectangle()
                                        .foregroundColor(.white)
                                        .frame(width: 48, height: 5,alignment: .center)
                                        .customRoundedRectangle()
                                    
                                    Spacer()
                                }
                                .padding(.vertical,10)
                                .allowsHitTesting(false)
                            }
    //                    }
                        
                       // .padding(.vertical,10)
                        .fullScreenCover(isPresented: $showWeView, onDismiss: {
                            getData()
                        }, content: {
    //                        CourseAdaptView(showCourse: $showWeView, course: $courseData.course, model:CourseAdaptModel(link: courseData.course.courseUrl, headerName: ""))
                            
                            CourseAdaptView(showCourse: $showWeView, course: $courseData.course, cookieData: $courseData.cookieData)
                               
                            
                        })
    //                    .resizableSheet($showWeView) { builder in
    //
    //                        builder.content { context in
    //                            CourseAdaptView(showCourse: $showWeView, course: $courseData.course)
    //                        }
    //                        .sheetBackground({ _ in
    //                            Color.white
    //                        })
    //                        .supportedState([.hidden, .large])
    //
    //                    }
                    //}
                } else if courseData.getCourseDataAPIStatus == .failure(.ApiError) {
                    ErrorStateView(imageName: "BrokenLink", title: StaticLabel.get("txtReloadDrawerDescription"))
                }
            }
            .onAppear(perform: {
                getData()
            })
            
            if isLoading {
                VStack {
                    ProgressView()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.2).ignoresSafeArea())
            }
        }
            }
        }
    }
    
    func getData() {
        courseData.getCourseData(CourseId: courseId,lang: langData.selectedLang.langCode){
            let isRequired: Bool = courseData.course.courseType.contains(where: { courseType in courseType.lowercased() == CourseType.Required.rawValue.lowercased()})
            
            let courseEvent = CourseEventInfo(name: "Academy: Course: View: Details:", courseID: courseData.course.courseId, courseName: courseData.course.title, requiredCourse: isRequired)
                        
            RootViewModel.shared.creatorAction?.action(.analytics(event: courseEvent))
            
            if(courseData.course.isCompleted) {
                
                let courseCompleteEvent = CourseEventInfo(name: "Academy: Course: View: Complete:", courseID: courseData.course.courseId, courseName: courseData.course.title, requiredCourse: isRequired)
                RootViewModel.shared.creatorAction?.action(.analytics(event: courseCompleteEvent))
                
                showCertificateDetailsSheet = true
            }
        }
    }
    
//    var relatedCoursesLoadingView: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            Text("Related Courses")
//                .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .medium))
//
//            ScrollView(.horizontal) {
//                HStack {
//                    ForEach(0..<4){ i in
//
//                        CourseCardView(course: .constant(DashboardViewModel.shared.courses[0]), mediumCardWidth: true)
//                            .frame(width: AppConstants.courseCardWidth)
//                            .customShadow(frontColor: .black.opacity(0.1), BackColor: .white)
//                            .padding(.vertical, 16)
//
//                    }
//                }
//
//            }
//        }
//        .padding(16)
//        .redacted(reason: .placeholder)
//        .shimmering(duration: 1.0)
//    }
}



struct SyllabusView: View {
    @ObservedObject var courseData : CourseDetailsMainViewModel
    @State var showSection : Bool = true
    var courseCompleteion : Bool = false
    
    var body: some View {
        
        VStack(alignment:.leading,spacing: 27) {
            
            HStack {
                Text(StaticLabel.get("txtSyllabus"))
                    .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .medium))
                Spacer()
                
                if courseCompleteion {
                    Image("Chevron", bundle: AppConstants.bundle)
                        .rotationEffect(showSection ? .degrees(180): .degrees(0))
                        .onTapGesture {
                            showSection.toggle()
                        }
                }
            }
            
            if showSection {
                if courseData.syllabus.count > 0 {
                    
                    ForEach(0..<courseData.syllabus.count,id:\.self) { i in
                        VStack {
                            HStack(spacing: 12) {
                                Text("\(StaticLabel.get("txtSection")) \(i + 1): \(courseData.syllabus[i].header)")
                                    .font(.getCustomFontWithSize(fontType: .gt_walsheim_medium, fontSize: .regular))
                                
                                Spacer()
                                Image("Chevron", bundle: AppConstants.bundle)
                                    .rotationEffect(courseData.syllabus[i].showSection ? .degrees(180): .degrees(0))
                                    .onTapGesture {
                                        courseData.syllabus[i].showSection.toggle()
                                    }
                                
                            }
                            if courseData.syllabus[i].showSection {
                                VStack(spacing: 8) {
                                    ForEach(0..<courseData.syllabus[i].syllabusData.count,id:\.self){ j in
                                        
                                        SyllabusCellView(data: $courseData.syllabus[i].syllabusData[j])
                                    }
                                }
                            }
                        }
                        .padding(.bottom, 3)
                    }
                }
            }
        }
    }
    
}

struct SyllabusCellView: View {
    
    @Binding var data : SyllabusData
    
    var body: some View {
        
        HStack{
            VStack(alignment: .leading) {
                Text("1.")
                .font(.getCustomFontWithSize(fontType: .gt_walsheim_medium, fontSize: .regular))
                Spacer()
            }
            
            VStack(alignment:.leading) {
                Text("Video Title")
                    .font(.getCustomFontWithSize(fontType: .gt_walsheim_medium, fontSize: .regular))
                
                Text("Runtime – 3:01 mins")
                    .font(.getCustomFontWithSize(fontType: .gt_walsheim_regular, fontSize: .regular))
                    .foregroundColor(Color.darkGray)
            }
            
            Spacer()
            
            VStack(alignment:.leading) {
                Spacer()
                
                Image("Video", bundle: AppConstants.bundle)
                
                Spacer()
            }
            
            
            
        }
        .padding(16)
        .frame(maxWidth:.infinity)
        .frame(height: 50)
        .background(Color.lightGray)
        .customRoundedRectangle()
        
        
    }
    
}


struct AchivementView: View {
    
    var courseCompleteion : Bool = false
    @State var showSection : Bool = true
    @StateObject var courseData = CourseDetailsMainViewModel.shared

    var body: some View {
        
        VStack(alignment:.leading,spacing: 16) {
            
            VStack(alignment:.leading,spacing: 4) {
                HStack(spacing: 8){
                    Text(StaticLabel.get("txtAchievements"))
                        .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .medium))
                    //Image("QuestionMark", bundle: AppConstants.bundle)
                    Spacer()
                    if courseCompleteion {
                        Image("Chevron", bundle: AppConstants.bundle)
                            .rotationEffect(showSection ? .degrees(180): .degrees(0))
                            .onTapGesture {
                                showSection.toggle()
                            }
                    }
                }
                
                if  showSection {
                    Text(StaticLabel.get("txtAchievementsDescription"))
                        .font(.getCustomFontWithSize(fontType: .gt_walsheim_regular, fontSize: .regular))
                        .foregroundColor(Color.darkGray)
                }
            }
            if  showSection {
                HStack{
                    Image("Acheivement", bundle: AppConstants.bundle)
                        .frame(width: 65, height: 65)
                    
                    Spacer()
                    
                    let completionDate = courseData.course.completionDate
                    let firstIndexOfSlash = completionDate.firstIndex(of: "/") ?? completionDate.startIndex
                    let lastIndexOfSlash = completionDate.lastIndex(of: "/") ?? completionDate.startIndex
                    let year: String = (completionDate=="") ? "" : String(completionDate[completionDate.index(after: lastIndexOfSlash)...])
                    let day: String = (completionDate=="") ? "" : String(completionDate[..<firstIndexOfSlash])
                    let month: String = (completionDate=="") ? "" : String(completionDate[completionDate.index(after: firstIndexOfSlash)..<lastIndexOfSlash])
                    Text(courseCompleteion ? ("\(StaticLabel.get("txtCertificatePostCompletion")) \n \(year) \(Utils.getMonthNameFromMonthNo(month)) \((day.count == 1) ? "0" : "")\(day)") : StaticLabel.get("txtCertificatePreCompletion"))
                        .font(.getCustomFontWithSize(fontType: .gt_walsheim_medium, fontSize: .large))
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                }
                .padding(16)
                .frame(maxWidth:.infinity)
                .frame(height: 105)
                .foregroundColor(.white)
                .background(Color.darkPurple)
                .customRoundedRectangle()
                
            }
            
            
        }
        
    }
    
}

//struct CourseDeatilsMainView_Previews: PreviewProvider {
//    static var previews: some View {
//        CourseDeatilsMainView(course: .constant(CourseModel()))
//    }
//}
