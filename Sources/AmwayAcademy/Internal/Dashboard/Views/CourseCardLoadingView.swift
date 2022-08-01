//
//  CourseCardLoadingView.swift
//  ABOAcademy
//
//  Created by Tahir Gani on 01/04/22.
//

import SwiftUI
import Shimmer

struct CourseCardLoadingView: View {
    @State var course: CourseModel = DashboardViewModel.shared.courses.count != 0 ? DashboardViewModel.shared.courses[0] : CourseModel()
    
    var cardCount: Int = 1
    var displayHorizontal: Bool = true
    var width: CGFloat = UIScreen.main.bounds.width - 32
    var noHeader: Bool = false
    var descLineLimit: Int?
    var cardHeight: CGFloat?
    var spacing: CGFloat?
    
    var body: some View {
        VStack {
            if !noHeader {
                VStack{ }
                    .frame(height: 10)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray)
                    .padding(.top, displayHorizontal ? 16 : 25)
                    .padding(.bottom, 16)
            }
            
            if displayHorizontal {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: spacing ?? 8) {
                        ForEach(0..<cardCount, id:\.self) { index in
                            cardView
                                .frame(width: width)
                        }
                    }
                }
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: spacing ?? 12) {
                        ForEach(0..<cardCount, id:\.self) { index in
                            cardView
                                .frame(width: width)
                        }
                    }
                }
            }
            
            
        }
        .redacted(reason: .placeholder)
        .shimmering()
        .onAppear {
            course = DashboardViewModel.shared.courses.count != 0 ? DashboardViewModel.shared.courses[0] : CourseModel()
        }
    }
    
    var cardView: some View {
        VStack {
            VStack { }
            .frame(width: width, height: displayHorizontal ? 160 : 155)
            .background(Color.gray)
            .cornerRadius(AppConstants.dashboardMaxCardCornerRadius, corners: [.topLeft, .topRight])
            
            VStack {
                ///
                /// Course Title
                Text(course.title)
                    .padding(.top, 8)
                    .font(.getCustomFontWithSize(fontType: .gt_walsheim_medium, fontSize: .regular))
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(1)
                
                ///
                /// Course Description
                Text(course.description)
                    .font(.getCustomFontWithSize(fontType: .gt_walsheim_regular, fontSize: .regular))
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(descLineLimit ?? (displayHorizontal ? 3 : 2))
                    .padding(.top, 0.5)
                
                Spacer()
                
                ///
                /// Bottom section
                HStack(spacing: 8) {

                    // TODO: Create custom component
                    HStack(spacing: 4) {
                        Image("TimeIcon", bundle: AppConstants.bundle)
                            .frame(width: 14, height: 14)
                        Text("\(course.duration)m")
                            .frame(height: 16)
                    }
                    .font(.getCustomFontWithSize(fontType: .gt_walsheim_medium, fontSize: .regular))
                    .foregroundColor(.darkPurple)
                    
                    Spacer()
                    HStack(spacing: 4) {
                        
                        Image("FavIcon", bundle: AppConstants.bundle)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .cornerRadius(AppConstants.dashboardMaxCardCornerRadius)
                        
                        Image("DownloadIcon", bundle: AppConstants.bundle)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .cornerRadius(AppConstants.dashboardMaxCardCornerRadius)
                    
                        Image("CertificateIcon", bundle: AppConstants.bundle)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .cornerRadius(AppConstants.dashboardMaxCardCornerRadius)
                    }
                }
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 16)
        }
        .frame(height: cardHeight ?? (displayHorizontal ? AppConstants.cardHeightMd : AppConstants.cardHeightLg), alignment: .top)
    }
}

struct CourseCardLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        CourseCardLoadingView()
    }
}
