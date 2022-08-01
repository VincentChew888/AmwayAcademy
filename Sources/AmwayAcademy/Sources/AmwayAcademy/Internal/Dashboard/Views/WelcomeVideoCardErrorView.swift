//
//  WelcomeVideoCardErrorView.swift
//  
//
//  Created by Tahir Gani on 14/06/22.
//

import SwiftUI

struct WelcomeVideoCardErrorView: View {
    var getWelcomeVideo: ()->Void
    
    var body: some View {
        VStack {
           // Spacer()
            HStack {
                Text(StaticLabel.get("txtWelecomeToAcademy"))
                    .foregroundColor(.white)
                    .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .vvLarge))
                Spacer()
            }
            
            Spacer()
                .frame(height: 16)
            
            ErrorStateView(imageName: "BrokenLink", title: StaticLabel.get("txtReloadDescription"), height: 220, paddingHorizontal: 0) {
                getWelcomeVideo()
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
        .padding(.top, 40)
        .background(Color.darkPurple)
        .padding(.bottom, 40)
    }
}

//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        WelcomeVideoCardErrorView()
//    }
//}
