//
//  CourseDetailsView.swift
//  ABOAcademy
//
//  Created by Swapnil Tilkari on 23/02/22.
//

import SwiftUI
import Shimmer

struct CourseDetailsView: View {
    @StateObject var langData = LangViewModel.shared
    @State var langSheetState: ResizableSheetState = .hidden
    @StateObject var courseData = CourseDetailsMainViewModel.shared
    
    @State var progressValue: Float = 0.1
    var course : CourseModel = CourseModel()
    var isLearning : Bool = false
    var courseSection: DashboardCard?
    @Binding var reloadCourses: Bool
    
    @State var showShareSheet = false
    /// Used for showing shimmering effect while loading
    @State var isLoadingView = false
    var langAction : (() -> Void)?
    
    var body: some View {
        if !isLoadingView {
            VStack {
                mainView
            }
            .resizableSheet($langSheetState) { builder in
                
                builder.content { context in
                    LangSelectorCustomPopUp(langSheetState: $langSheetState,langData: langData) {
                        
                        if let action = langAction {
                            action()
                        }
                    }
                    .onAppear() {
                        langData.fetchLangData(locale: langData.selectedLang.langCode){
                            AmwayAppLogger.generalLogger.debug(String(describing: langData.LangArr))
                        }
                    }
                }
                .sheetBackground({ _ in
                    Color.white
                })
                .cornerRadius(20)
                .supportedState([.hidden, .medium])
            }
            
        } else {
            mainView
                .redacted(reason: .placeholder)
                .shimmering()
        }
    }
    
    var mainView: some View {
        VStack(alignment: .leading, spacing: 0){
            
            ZStack(alignment:.topLeading) {
                //                if course.bannerImage != "" {
                CustomImageView(url: course.bannerImage, width: UIScreen.main.bounds.width, height: 212, placeholderImage: "", aspectRatio: 16/9
                )
                //                } else {
                //                    Image("DefaultImage", bundle: AppConstants.bundle)
                //                        .resizable()
                //                        .aspectRatio(16/9, contentMode: .fill)
                //                        .frame(height: 212)
                //                }
                
                
                
                HStack {
                    if course.isNew {
                        TagView(image: "New")
                    }
                    if course.courseType.contains(where: { courseType in courseType.lowercased() == CourseType.Required.rawValue.lowercased()}) {
                        TagView(image: course.courseType[0],backgroundColor:Color.alertLightOrange,forgroundColor: .alertOrange  )
                    }
                    Spacer()
                }
                .padding(16)
                
                // }
                
            }
            ZStack {
                if course.isCompleted {
                    Image("CourseConfetti", bundle: AppConstants.bundle)
                    .resizable()
                    .scaledToFill()
                    .allowsHitTesting(false)
                }
                
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 12) {
                        
//                        HStack {
//
//                            //Not in this release so hiding the shared with me section
//                            CustomLabelWithImageType2(image: "DownArrow", title: langData.selectedLang.language )
//                                .onTapGesture {
//                                    langSheetState = .medium
//                                }
//
//                            Spacer()
//                            /* Removing Share Button
//                            CustomLabelWithImageType2(image: "Share", title: StaticLabel.get("txtShare"))
//                                .onTapGesture {
//                                    //                            guard let url = URL(string: course.courseUrl) else {
//                                    //                                return
//                                    //                            }
//                                    showShareSheet.toggle()
//                                }
//                                .sheet(isPresented: $showShareSheet) {
//                                    ShareSheetView(items: [URL(string: course.courseUrl)!])
//                                }
//                            */
//                        }
                        
                        if course.isCompleted {
                            
                            VStack(alignment: .leading, spacing: 4) {
                                ///
                                /// Course Title
                                Text("\(StaticLabel.get("txtCourseCompleted"))")
                                    .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .xxxLarge))
                                    .fixedSize(horizontal: false, vertical: true)
                                    .lineLimit(2)
                                    .foregroundColor(.darkPurple)
                                HStack {
                                    //                            Text("")
                                    //                                .font(.getCustomFontWithSize(fontType: .gt_walsheim_regular, fontSize: .xxxLarge))
                                    
                                    HStack {
                                        Text("\(course.title)")
                                            .italic()
                                            .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .regular))
                                            .foregroundColor(Color.darkGray)
        //                                Text("was completed on 01/25/2022.")
                                        + Text(" \(StaticLabel.get("txtWasCompletedOn")) \(course.completionDate)")
                                            .font(.getCustomFontWithSize(fontType: .gt_walsheim_regular, fontSize: .regular))
                                            .foregroundColor(Color.darkGray)
                                    }
                                    Spacer()
                                }
                                
                            }
                        }else{
                            CourseDescriptionView(course: course)
                        }
                        
                        HStack(spacing: 4) {
                            Image(course.isFavorite ? "FavIconBlack" : "FavIconBlackEmpty", bundle: AppConstants.bundle )
                                .resizable()
                                .frame(width: 40, height: 40)
                                .onTapGesture {
                                    // course.setFav()
                                    // Should reload courses on the current screen and the course type on dashboard
                                    DashboardViewModel.shared.selectedCourseSection = courseSection
                                    reloadCourses = true
                                    
                                    courseData.Favourite() {
                                        let isRequired: Bool = courseData.course.courseType.contains(where: { courseType in courseType.lowercased() == CourseType.Required.rawValue.lowercased()})
                                        
                                        let courseEvent = CourseEventInfo(name: "Academy: Course: Touch: Favorite:", courseID: courseData.course.courseId, courseName: courseData.course.title, requiredCourse: isRequired)
                                                    
                                        RootViewModel.shared.creatorAction?.action(.analytics(event: courseEvent))
                                    }
                                }
                            
                            
                            //                    Image("DownloadIConBlackEmpty", bundle: AppConstants.bundle)
                            //                        .resizable()
                            //                        .frame(width: 40, height: 40)
                            
                            
                            Spacer()
                        }
                        .padding(.top, 4)
                        
                    }
                    .padding(16)
            
                    if course.isCompleted {
                        VStack {
                            CourseDescriptionView(course: courseData.course, showSection: false)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 16)
                            if courseData.course.isCertificateAvailable {
                                AchivementView(courseCompleteion: true,showSection: false)
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 16)
                            }
        //                              SyllabusView(courseData: syllabusData,showSection: false, courseCompleteion: true)
        //                                    .padding(.horizontal, 16)
        //                                    .padding(.bottom, 16)
                            
                            VStack {
                                
                            }
                            .frame(height: 300)
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}

//struct CourseDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CourseDetailsView(courseSection: .noCard, reloadCourses: .constant(false))
//    }
//}

struct CourseDescriptionView: View {
    var course : CourseModel = CourseModel()
    @State var showSection : Bool = true
    @StateObject var courseData = CourseDetailsMainViewModel.shared
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            if course.isCompleted {
                HStack{
                    Text(StaticLabel.get("txtCourseDescription"))
                        .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .medium))
                    Spacer()
                    
                    Image("Chevron", bundle: AppConstants.bundle)
                        .rotationEffect(showSection ? .degrees(180): .degrees(0))
                        .onTapGesture {
                            showSection.toggle()
                        }
                }
                .padding(.bottom, 4)
            }
            
            if showSection {
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    
                    if course.isCompleted || course.progress == 0 {
                        HStack(spacing: 8) {
                            
                            CustomLabelWithImage(image: "TimeIcon", title: "\(course.duration)")
                            Spacer()
                        }
                    } else {
                        HStack(alignment: .center) {
                            CustomLabelWithImage(image: "LoadIcon", title: "\(String(course.duration)) \(StaticLabel.get("txtLeft"))")
                            
                            
                            ProgressBar(value: .constant(Int(Float(course.progress))))
                                .frame(height: 10)
                            
                            Spacer()
                        }
                    }
                    
                    ///
                    /// Course Title
                    VStack(alignment: .leading, spacing: 4) {
                        Text(course.title)
                            .font(.getCustomFontWithSize(fontType: .gt_walsheim_medium, fontSize: .vlargemid))
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(2)
                            .foregroundColor(.amwayBlack)
                        
                        if course.speaker != "" {
                            Text("\(StaticLabel.get("txtTaughtBy")): \(course.speaker)")
                                .font(.getCustomFontWithSize(fontType: .gt_walsheim_medium, fontSize: .regular))
                                .fixedSize(horizontal: false, vertical: true)
                                .lineLimit(2)
                                .foregroundColor(.amwayBlack)
                        }
                        
                        ///
                        /// Course Description
                        ///
                        if course.description != "" {
                            Text(course.description)
                                .font(.getCustomFontWithSize(fontType: .gt_walsheim_regular, fontSize: .regular))
                                .fixedSize(horizontal: false, vertical: true)
                                .lineLimit(4)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                ScrollView(.horizontal, showsIndicators: false ) {
                    HStack {
                        ForEach(0..<course.skills.count){ i in
                            CustomLabelWithImage(image: "", title:course.skills[i].title , backgroundColor: Color.lightPurple)
                        }
                    }
                }
            }
        }
        .padding(.top, 4)
    }
}
