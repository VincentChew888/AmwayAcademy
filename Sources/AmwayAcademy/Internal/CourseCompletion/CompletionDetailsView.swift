//
//  CompletionDetailsView.swift
//  ABOAcademy
//
//  Created by Swapnil Tilkari on 09/03/22.
//

import SwiftUI

struct CompletionDetailsView: View {
    @Binding var courseId : String
    
    @StateObject var langData = LangViewModel.shared
    @StateObject var syllabusData = CourseDetailsMainViewModel.shared
    @State var showWebView: Bool = false
    
    @Binding var reloadCourses: Bool
    var courseSection: DashboardCard?
    
    @State var certificateSheetState: ResizableSheetState = .hidden
    @StateObject var courseData = CourseDetailsMainViewModel.shared
    @State var isLoading = false
    
    var body: some View {
        ShowViewWithErrorHandling(mainView: mainView) {
            getData()
        }
    }
    
    var mainView: some View {
        VStack {
            if courseData.getCourseDataAPIStatus == .Loading {
                CourseDetailsLoadingView()
            } else if courseData.getCourseDataAPIStatus == .success {
                ZStack {
                    ZStack(alignment:.top) {
                    VStack(alignment: .leading, spacing: 0) {
                        ScrollView {
                            VStack(alignment: .leading) {
                                VStack(alignment: .leading) {
                                    CourseDetailsView(course:courseData.course, courseSection: courseSection, reloadCourses: $reloadCourses) {
                                        langData.fetchLangData(locale: langData.selectedLang.langCode){
                                            langData.selectedLang = langData.LangArr.filter({ lang in
                                                lang.langCode == langData.selectedLang.langCode
                                            })[0]
                                            courseData.getCourseData(CourseId: courseId,lang: langData.selectedLang.langCode){
                                            }
                                        }
                                       
                                    }
                                
                               /* Removing Your next course section
                                    Text(StaticLabel.get("txtYourNextCourse"))
                                        .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .regular))
                                        .padding(.horizontal,16)
                                        
                                    QuickStartCardView(course:.constant(course) )
                                        .background(Color.white)
                                        .customRoundedRectangle()
                                        .customShadow(frontColor: .amwayBlack.opacity(0.1), BackColor: .white)
                                        .padding(.horizontal,16)
                                        .padding(.bottom, 60)
                                */
                                        
                                }
                                // .padding(35)
//                                .background(
//                                    GeometryReader { val in
//                                        VStack {
//                                            Spacer()
//                                        Image("CourseConfetti", bundle: AppConstants.bundle)
//                                            .resizable()
//                                            .scaledToFit()
//                                            //.frame(height: 300)
//                                        }
////                                        .offset(y: 10)
//                                    }
//                                )
                           // .padding(16)
//                                ZStack(alignment: .top) {
//                                        //.frame(height: 300)
//                                    VStack {
//                                        CourseDescriptionView(course: courseData.course, showSection: false)
//                                            .padding(.horizontal, 16)
//                                            .padding(.bottom, 16)
//
//                                        AchivementView(courseCompleteion: true,showSection: false)
//                                            .padding(.horizontal, 16)
//                                            .padding(.bottom, 16)
//
//        //                              SyllabusView(courseData: syllabusData,showSection: false, courseCompleteion: true)
//        //                                    .padding(.horizontal, 16)
//        //                                    .padding(.bottom, 16)
//
//                                        VStack {
//
//                                        }
//                                        .frame(height: 300)
//                                        Spacer()
//                                    }
//                                }
                            }
                            
                            
                            //.frame( height: UIScreen.main.bounds.height + 150)
                        }
                    }
                    .navigationBarHidden(true)
                    .background(Color.white)
                    //.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 120)
                    .edgesIgnoringSafeArea(.bottom)
                    
                    HStack {
                        Spacer()
                        Rectangle()
                            .foregroundColor(.white)
                            .frame(width: 48, height: 5,alignment: .center)
                            .customRoundedRectangle()
                        
                        Spacer()
                    }
                    .padding(.vertical,10)
                    }
                    
                    // Certificate Section
                    if courseData.course.isCertificateAvailable {
                        bottomViewWithCertificate
                    } else {
                        bottomViewWithoutCertificate
                    }
                    
                    if isLoading {
                        VStack {
                            ProgressView()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.2).ignoresSafeArea())
                    }
                }
            } else if courseData.getCourseDataAPIStatus == .failure(.ApiError) {
                ErrorStateView(imageName: "BrokenLink", title: StaticLabel.get("txtReloadDrawerDescription"))
            }
        }
        .onAppear(perform: {
            getData()
        })
        .onDisappear {
            langData.selectedLang.langCode = LangModel().langCode
            langData.selectedLang.language = LangModel().language
        }
        .fullScreenCover(isPresented: $showWebView, onDismiss: {
            getData()
        }, content: {
            
            CourseAdaptView(showCourse: $showWebView, course: $courseData.course, cookieData: $courseData.cookieData)
               
            
        })
    }
    
    var bottomViewWithoutCertificate: some View {
        VStack {
            Spacer()
            VStack(spacing: 0) {
                Image("CertificateSmallBg", bundle: AppConstants.bundle)
                    .resizable()
                    .scaledToFit()
                VStack(spacing: 20) {
                    if courseData.course.isCertificateAvailable {
                        Button {
                            certificateSheetState = .medium
                        } label: {
                            HStack {
                                Spacer()
                                Text(StaticLabel.get("txtViewCertificate"))
                                .padding(9)
                                .foregroundColor(.darkPurple)
                                .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .medium))
                                Spacer()

                            }
                            .background(Color.white)
                            .clipShape(Capsule())
                        }
                    }
                    let btnTitle: String = courseData.course.isLive ? StaticLabel.get("txtViewCourse") : courseData.course.isArchived ? StaticLabel.get("txtCourseNoLongerAvailable") :  courseData.course.isOffline ? StaticLabel.get("txtCourseTemporarilyUnavailable") : ""
                    
                    Button {
                        // Should reload courses on the current screen and the course type on dashboard
                        DashboardViewModel.shared.selectedCourseSection = courseSection
                        reloadCourses = true
                        isLoading = true
                        
                        courseData.getCookieData(courseId: courseId) {
                            let isRequired: Bool = courseData.course.courseType.contains(where: { courseType in courseType.lowercased() == CourseType.Required.rawValue.lowercased()})
                            
                            let courseEvent = CourseEventInfo(name: "Academy: Course: Touch: Start Course:", courseID: courseData.course.courseId, courseName: courseData.course.title, requiredCourse: isRequired)
                                        
                            RootViewModel.shared.creatorAction?.action(.analytics(event: courseEvent))
                            
                            isLoading = false
                            showWebView = true
                        } failure: {
                            
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text(btnTitle)
                                .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .medium))
                            .foregroundColor(courseData.course.isLive ? Color.darkPurple : Color.disableButtonText)
                            .padding(9)
                            Spacer()
                        }
                    }
                    .background(courseData.course.isLive ? Color.white : Color.disableButton)
                    .disabled(!courseData.course.isLive)
                    .clipShape(Capsule())
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 20)
                .padding(.horizontal)
                .padding(.bottom, 40)
                .background(Color.darkPurple)
          }


        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    var bottomViewWithCertificate: some View {
        VStack {
            Spacer()
            VStack(spacing: 0) {
                Image("CertificateSmall", bundle: AppConstants.bundle)
                    .resizable()
                    .scaledToFit()
                VStack(spacing: 20) {
                    if courseData.course.isCertificateAvailable {
                        Button {
                            certificateSheetState = .medium
                        } label: {
                            HStack {
                                Spacer()
                                Text(StaticLabel.get("txtViewCertificate"))
                                .padding(9)
                                .foregroundColor(.darkPurple)
                                .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .medium))
                                Spacer()

                            }
                            .background(Color.white)
                            .clipShape(Capsule())
                        }
                    }
                    let btnTitle: String = courseData.course.isLive ? StaticLabel.get("txtViewCourse") : courseData.course.isArchived ? StaticLabel.get("txtCourseNoLongerAvailable") :  courseData.course.isOffline ? StaticLabel.get("txtCourseTemporarilyUnavailable") : ""
                    
                    Button {
                        // Should reload courses on the current screen and the course type on dashboard
                        DashboardViewModel.shared.selectedCourseSection = courseSection
                        reloadCourses = true
                        isLoading = true
                        
                        courseData.getCookieData(courseId: courseId) {
                            let isRequired: Bool = courseData.course.courseType.contains(where: { courseType in courseType.lowercased() == CourseType.Required.rawValue.lowercased()})
                            
                            let courseEvent = CourseEventInfo(name: "Academy: Course: Touch: Start Course:", courseID: courseData.course.courseId, courseName: courseData.course.title, requiredCourse: isRequired)
                                        
                            RootViewModel.shared.creatorAction?.action(.analytics(event: courseEvent))
                            
                            isLoading = false
                            showWebView = true
                        } failure: {
                            
                        }
                    } label: {
                        Text(btnTitle)
                            .foregroundColor(Color.white)
                            .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .medium))
                        .overlay(
                            Rectangle()
                                .frame(height: 2)
                                .offset(y: 2)
                                .foregroundColor(.white)
                            
                            , alignment: .bottom
                        )
                    }
                    .disabled(!courseData.course.isLive)
                }
                .frame(maxWidth: .infinity)
                .padding(30)
                .background(Color.darkPurple)
          }


        }
        .edgesIgnoringSafeArea(.bottom)
        .resizableSheet($certificateSheetState, id: "cert-sheet-2") { builder in
            builder.content { context in
                CertificateBottomPopUp(certificateSheetState: $certificateSheetState, course: $courseData.course)
            }
            .sheetBackground { _ in
                Color.black.opacity(0.01)
            }
            .supportedState([.hidden, .medium])
        }
    }
    
    func getData() {
        courseData.getCourseData(CourseId: courseId,lang: langData.selectedLang.langCode){
            
            let isRequired: Bool = courseData.course.courseType.contains(where: { courseType in courseType.lowercased() == CourseType.Required.rawValue.lowercased()})
            
            let courseEvent = CourseEventInfo(name: "Academy: Course: View: Details:", courseID: courseData.course.courseId, courseName: courseData.course.title, requiredCourse: isRequired)
                        
            RootViewModel.shared.creatorAction?.action(.analytics(event: courseEvent))
            
        }
    }
}

//struct CompletionDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CompletionDetailsView(courseId: .constant(""), reloadCourses: .constant(false), courseSection: .noCard)
//    }
//}
