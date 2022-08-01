//
//  CourseHorizontalListView.swift
//  ABOAcademy
//
//  Created by Tahir Gani on 05/04/22.
//

import SwiftUI

struct CourseHorizontalListView: View {
    var headerTitle: String
    @Binding var courses: [CourseModel]
    @Binding var selectedCourse: CourseModel
    @Binding var apiStatus: APIState
    @Binding var showCompletionDetails: Bool
    @Binding var curSelectedSection: DashboardCard?
    var headerType: HeaderType = .large
    var descLineLimit: Int = 3
    var headerTextColor: Color?
    var isRelatedToCourses: Bool = true
    var courseType: CourseType = .Default
    var courseSection: DashboardCard?
    var paddingTop: CGFloat = 0
    var isLearningPath: Bool = false
    var cardHeight: CGFloat?
    var limitCoursesCnt: Int?
    var errorViewHeight: CGFloat = 320
    var onReloadButtonClick: (()->Void)?
    var onCourseCardClick: ()->Void
    
    var body: some View {
        VStack {
            if apiStatus == .success {
                if !courses.isEmpty {
                    mainView
                } else {
                    VStack {}
                }
            } else if apiStatus == .Loading {
                CourseCardLoadingView(cardCount: 3, displayHorizontal: true, width: AppConstants.courseCardWidth, cardHeight: cardHeight)
                    .padding(.horizontal, 16)
            } else if apiStatus == .failure(.ApiError) {
                VStack(alignment: .leading,spacing: 16) {
                    listHeader
                    ErrorStateView(imageName: "BrokenLink", title: StaticLabel.get("txtReloadDescription"), height: errorViewHeight, onButtonClick: onReloadButtonClick)
                        .padding(.top, 16)
                }
            }
        }
    }
    
    var mainView: some View {
        VStack(alignment: .leading,spacing: 16) {
            listHeader
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    //Binding Example
                    ForEach(0..<(min(courses.count, limitCoursesCnt ?? courses.count)), id:\.self) { index in
                        VStack {
                            if isLearningPath {
                                NavigationLink(destination: LearningPathDetails(course: courses[index])) {
                                    CourseCardView(course: $courses[index], imageName: "DefaultImage", mediumCardWidth: true)
                                }
                                .buttonStyle(PlainButtonStyle())
                            } else {
                                CourseCardView(course: $courses[index],courseType: courseType, imageName: "DefaultImage", lineLimit: descLineLimit, mediumCardWidth: true, cardHeight: cardHeight)
                            }
                        }
                            .frame(width: AppConstants.courseCardWidth)
                            .onTapGesture {
                                curSelectedSection = courseSection
                                selectedCourse = courses[index]
                                onCourseCardClick()
                            }
                            .padding(.leading, index == 0 ? 16 : 0)
                            .padding(.trailing, index == courses.count-1 ? 16 : 0)
                    }
                }
            }
        }
    }
    
    var listHeader: some View {
        ListHeader(headerTitle: headerTitle, isRelatedToCourses: isRelatedToCourses,
                   headerType: headerType, textColor: headerTextColor ?? Color.amwayBlack ,courseType: courseType, courseSection: courseSection, showCompletionDetails: $showCompletionDetails)
            .padding(.top, paddingTop)
            .padding(.horizontal, 16)
    }
}

//struct CourseHorizontalListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CourseHorizontalListView(selectedCourse: .constant(CourseModel()), showSheet: .constant(false))
//    }
//}
