//
//  CustomNavBar.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 23/02/22.
//

import SwiftUI

public struct CustomNavBar: View {
    
    var navBarTitle: String = "My Courses"
    var navBarBackIcon: String = "NavBarBackIcon"
    var navBarBackIconWidth: CGFloat = 16
    var navBarBackIconHeight: CGFloat = 18
    var navBarRightIcon: String = "NavBarMyCourseFilterIcon"
    var navBarRightIconWidth: CGFloat = 18
    var navBarRightIconHeight: CGFloat = 20
    var navBarRightIconDisabled: Bool = false
    var navBarHeight: Double = AppConstants.navbarHeight
    var showRightNavButton: Bool = false
    /// This will make the right nav button as a navigation link to the explore page and the icon as 'telescope' icon.
    var rightNavButtonIsExploreButton: Bool = false
    @Binding var showCompletionDetails: Bool
    var leftBarAction : (() -> Void)?
    var rightBarAction : (() -> Void)?
    
    public init(navBarTitle: String = "My Courses", navBarBackIcon: String = "NavBarBackIcon", navBarBackIconWidth: CGFloat = 16, navBarBackIconHeight: CGFloat = 18, navBarRightIcon: String = "NavBarMyCourseFilterIcon", navBarRightIconWidth: CGFloat = 18, navBarRightIconHeight: CGFloat = 20, navBarRightIconDisabled: Bool = false, showRightNavButton: Bool = false, rightNavButtonIsExploreButton: Bool = false, showCompletionDetails: Binding<Bool>, leftBarAction : @escaping (() -> Void) = {}, rightBarAction : @escaping (() -> Void) = {}) {
        
        self.navBarTitle = navBarTitle
        self.navBarBackIcon = navBarBackIcon
        self.navBarBackIconWidth = navBarBackIconWidth
        self.navBarBackIconHeight = navBarBackIconHeight
        self.navBarRightIcon = navBarRightIcon
        self.navBarRightIconWidth = navBarRightIconWidth
        self.navBarRightIconHeight = navBarRightIconHeight
        self.navBarRightIconDisabled = navBarRightIconDisabled
        self.showRightNavButton = showRightNavButton
        self.rightNavButtonIsExploreButton = rightNavButtonIsExploreButton
        self._showCompletionDetails = showCompletionDetails
        
        self.leftBarAction = leftBarAction
        self.rightBarAction = rightBarAction
    }
    
    public var body: some View {
        
        VStack {
            Spacer()
            ZStack {
                HStack(alignment: .bottom) {
                    Button {
                        RootViewModel.shared.data.showProfile = true
                        if let leftBarAction = leftBarAction {
                           leftBarAction()
                        }
                    } label: {
                        Image(navBarBackIcon, bundle: AppConstants.bundle)
                            .resizable()
                            .scaledToFit()
                            .frame(width: navBarBackIconWidth, height: navBarBackIconHeight)
                    }
                    Spacer()
    //                Text(navBarTitle)
    //                    .font(.getCustomFontWithSize(fontType: .gt_walsheim_medium, fontSize: .large))
    //                    .foregroundColor(Color.white)
    //                    .fixedSize(horizontal: false, vertical: true)
    //                    .lineLimit(1)
    //                Spacer()
                    if !rightNavButtonIsExploreButton {
                        Button {
                            if let rightBarAction = rightBarAction {
                               rightBarAction()
                            }
                        } label: {
                            Image(navBarRightIcon, bundle: AppConstants.bundle)
                                .resizable()
                                .scaledToFit()
                                .frame(width: navBarRightIconWidth, height: navBarRightIconHeight)
                        }
                        .disabled(navBarRightIconDisabled)
                        .opacity(showRightNavButton ? 1 : 0)
                    } else {
                        NavigationLink(destination: ExploreCourseView(courseSection: nil)) {
                            Image("TelescopeIcon", bundle: AppConstants.bundle)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 20)
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            
                            let exploreCoursesIconTouch = GenericEventInfo(name: "Academy: Touch: Explore Courses Icon")
                            RootViewModel.shared.creatorAction?.action(.analytics(event: exploreCoursesIconTouch))
                        })
                    }
                }
                .padding([.leading, .trailing], 20)
                .padding(.bottom, 12)
                
                VStack {
                    Text(navBarTitle)
                        .font(.getCustomFontWithSize(fontType: .gt_walsheim_medium, fontSize: .large))
                        .foregroundColor(Color.white)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(1)
                }
                .padding([.leading, .trailing], 40)
                .padding(.bottom, 12)
            }
        }
        .frame(height: navBarHeight)
        .background(Color.darkPurple)
        
    }
}

//struct CustomNavBar_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomNavBar()
//    }
//}
