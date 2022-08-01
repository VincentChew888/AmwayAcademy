//
//  WelcomeVideoCardLoadingView.swift
//  
//
//  Created by Tahir Gani on 14/06/22.
//

import SwiftUI
import Shimmer

struct WelcomeVideoCardLoadingView: View {
    var body: some View {
        VStack {
           // Spacer()
            HStack {
                Text("Welcome to ABO Academy")
                    .foregroundColor(.white)
                    .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .vvLarge))
                Spacer()
            }
            .redacted(reason: .placeholder)
            .shimmering()
            
            Spacer()
                .frame(height: 16)
            
            VStack {}
                .frame(maxWidth: .infinity)
                .frame(height: 220)
                .background(Color.darkGray)
                .cornerRadius(12)
                .shimmering()
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
        .padding(.top, 40)
        .background(Color.darkPurple)
        .padding(.bottom, 40)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeVideoCardLoadingView()
    }
}
