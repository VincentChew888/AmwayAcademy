//
//  DashboardLoadingView.swift
//  
//
//  Created by Tahir Gani on 07/06/22.
//

import SwiftUI

struct DashboardLoadingView: View {
    var title: String
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Spacer()
                HStack(alignment: .bottom) {
                    Image("HeaderCreatorsAIcon", bundle: AppConstants.bundle)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    
                    Spacer()
                    
                    Text(title)
                        .font(.getCustomFontWithSize(fontType: .gt_walsheim_medium, fontSize: .large))
                        .foregroundColor(Color.white)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    NavigationLink(destination: EmptyView()) {
                        Image("TelescopeIcon", bundle: AppConstants.bundle)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 20)
                    }
                    .disabled(true)
                }
            }
            .padding([.leading, .trailing], 20)
            .padding(.bottom, 12)
            .frame(height: AppConstants.navbarHeight)
            .padding(.bottom, 8)
            .background(Color.darkPurple)
            .zIndex(3)
            
            ScrollView {
                VStack(spacing: 32) {
                    CourseCardLoadingView(cardCount: 3, displayHorizontal: true, width: AppConstants.courseCardWidth)
                        .padding(.horizontal)
                        .padding(.top, 40)
                        .padding(.bottom, 24)
                        .background(Color.darkPurple)
                    
                    CourseCardLoadingView(cardCount: 3, displayHorizontal: true, width: AppConstants.courseCardWidth)
                        .padding(.horizontal)
                    
                    CourseCardLoadingView(cardCount: 1, displayHorizontal: false)
                        .padding(.horizontal)
                    
                    CourseCardLoadingView(cardCount: 3, displayHorizontal: true, width: AppConstants.courseCardWidth)
                        .padding(.horizontal)
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            DashboardViewModel.shared.getCourseData()
        }
    }
}

struct DashboardLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardLoadingView(title: "ABO Academy")
    }
}
