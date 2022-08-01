//
//  ListHeader.swift
//  ABOAcademy
//
//  Created by Tahir Gani on 05/04/22.
//

import SwiftUI

enum HeaderType : String {
    case large = "large"
    case small = "small"
}

struct ListHeader: View {
    
    var headerTitle: String = ""
    var isRelatedToCourses: Bool = false
    var headerType : HeaderType = .large
    var textColor: Color = .amwayBlack
    var courseType: CourseType = .Default
    var courseSection: DashboardCard?
    @Binding var showCompletionDetails: Bool
    
    var viewAllAction : (() -> Void)?
    
    var body: some View {
        HStack() {
            Text(headerTitle)
                .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: headerType == .large ? .vvLarge : .medium ))
                .foregroundColor(textColor)
            
            Spacer()
            
            NavigationLink(destination: CoursesListView(navBarTitle: headerTitle,courseType: courseType, courseSection: courseSection)) {
                Text(StaticLabel.get("txtViewAll"))
                    .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .regular))
                    .foregroundColor(textColor == .white ? .white : .darkPurple)
                    .overlay(
                        Rectangle()
                            .frame(height: 2)
                            .cornerRadius(10)
                            .foregroundColor(textColor == .white ? .white : .darkPurple)
                            .offset(y: 2)
                        , alignment: .bottom
                    )
            }
            .simultaneousGesture(TapGesture().onEnded{
                if let viewAllAction = viewAllAction {
                    viewAllAction()
                }
            })
        }
        //Apply below padding only for Courses For You, Learning Paths, Required Courses
        //  .padding(isRelatedToCourses ? [.leading, .trailing] : [])
    }
}

//struct ListHeader_Previews: PreviewProvider {
//    static var previews: some View {
//        ListHeader(courseSection: .requiredCoursesCard, showCertificateDetails: .constant(false), showCompletionDetails: .constant(false))
//    }
//}
