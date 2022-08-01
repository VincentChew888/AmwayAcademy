//
//  RequiredCoursesAlertCardView.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 20/01/22.
//

import SwiftUI

struct RequiredCoursesAlertCardView: View {
    
    var requireCourseAlertTitle: String = StaticLabel.get("txtNewRequiredCourses")
    var requireCourseAlertDescription: String = "Congratulations on hitting Platinum! You have 11 new required courses to help you level up again!"
    
    var body: some View {
        HStack {
            VStack {
                Image("BulbIcon", bundle: AppConstants.bundle)
                    .frame(width: 40, height: 40)
                    .offset(y: 0)
                Spacer()
            }
            
            //
            // TODO: Realign Element
            VStack {
                Spacer()
                    .frame(height: 4)
                HStack {
                    Text(requireCourseAlertTitle)
                        .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .regular))
                        .foregroundColor(.darkPurple)
                    Spacer()
                    Button {
                        AmwayAppLogger.generalLogger.debug("Close Button Clicked")
                    } label: {
                        Image("CloseIcon", bundle: AppConstants.bundle)
                            .renderingMode(.original)
                    }
                    .padding([.trailing])
                }
                HStack {
                    Text(requireCourseAlertDescription)
                        .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .regular))
                        .foregroundColor(.darkPurple)
                        .lineLimit(3)
                        .padding([.trailing])
                    Spacer()
                }
                .padding([.trailing])
                Spacer()
            }
        }
    }
}

struct RequiredCoursesAlertCardView_Previews: PreviewProvider {
    static var previews: some View {
        RequiredCoursesAlertCardView()
    }
}
