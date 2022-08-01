//
//  MyCoursesEmptyView.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 01/03/22.
//

import SwiftUI

struct MyCoursesEmptyView: View {
    
    @Binding var emptyData : MyCourseEmptyModel
    var courseSection: DashboardCard?
    var courseType : MyCourses
    var showExploreButton: Bool = true

    var body: some View {
        
        VStack(spacing: 16) {
            
            Image(emptyData.courseImageURL, bundle: AppConstants.bundle)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            
            VStack(spacing: 8) {
                Text(StaticLabel.get(emptyData.courseTitle))
                    .font(.getCustomFontWithSize(fontType: .gt_walsheim_medium, fontSize: .vlargemid))
                    .foregroundColor(.amwayBlack)
                
                Text(StaticLabel.get(emptyData.courseDescription))
                    .font(.getCustomFontWithSize(fontType: .gt_walsheim_regular, fontSize: .regular))
                    .lineLimit(4)
                    .foregroundColor(.amwayBlack)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 16)
            
            if showExploreButton {
                NavigationLink(destination: ExploreCourseView(courseSection: courseSection)) {
                    HStack {
                        Text(StaticLabel.get(emptyData.coursesButtonTitle))
                        .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .regular))
                        .foregroundColor(.amwayBlack)
                        Image("RightArrowIcon", bundle: AppConstants.bundle)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .opacity(courseType == .requiredCourses ? 0 : 1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .top)
        .padding(.vertical, 24)
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 16)
        .onAppear {
            AmwayAppLogger.generalLogger.debug(String(describing: emptyData))
        }
    }
}

//struct MyCoursesEmptyView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyCoursesEmptyView(emptyData: .constant(MyCourseEmptyModel()), courseType: .requiredCourses)
//    }
//}
