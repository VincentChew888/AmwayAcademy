//
//  CourseDetailsLoadingView.swift
//  ABOAcademy
//
//  Created by Tahir Gani on 31/03/22.
//

import SwiftUI
import Shimmer

struct CourseDetailsLoadingView: View {
    let course = DashboardViewModel.shared.courses[0]
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    CourseDetailsView(course: course, courseSection: .noCard, reloadCourses: .constant(false), isLoadingView: true)
                    
                    AchivementView()
                        .padding(.horizontal,16)
                    
                   // SyllabusView(courseData: courseData)
                      //  .padding(16)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text(StaticLabel.get("txtRelatedCourses"))
                            .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .medium))

                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(0..<4){ i in

                                    CourseCardView(course: .constant(course), mediumCardWidth: true)
                                        .frame(width: AppConstants.courseCardWidth)
                                        .customShadow(frontColor: .black.opacity(0.1), BackColor: .white)
                                        .padding(.vertical, 16)

                                }
                            }

                        }
                    }
                    .padding(16)
                }
                
            }
        }
        .redacted(reason: .placeholder)
        .shimmering()
    }
}

struct CourseDetailsLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        CourseDetailsLoadingView()
    }
}
