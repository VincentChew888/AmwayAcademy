//
//  ErrorStateView.swift
//  ABOAcademy
//
//  Created by Tahir Gani on 28/04/22.
//

import SwiftUI

struct ErrorStateView: View {
    var imageName: String
    var title: String
    var description: String = ""
    var height: CGFloat = 320
    var fullHeight: Bool = false
    var imgWidth: CGFloat = 100
    var imgHeight: CGFloat = 100
    var bgColor: Color = .white
    var btnTitle: String = StaticLabel.get("txtTryAgain")
    var paddingHorizontal: CGFloat = 16
    var onButtonClick: (()->Void)?
    
    var body: some View {
        VStack(spacing: 16) {
            Image(imageName, bundle: AppConstants.bundle)
                .resizable()
                .scaledToFit()
                .frame(width: imgWidth, height: imgHeight)
                .clipShape(Circle())
            
            VStack(spacing: 8) {
                Text(title == "" ? "Looks like the link is broken" : title)
                    .font(.getCustomFontWithSize(fontType: .gt_walsheim_medium, fontSize: .vlargemid))
                    .foregroundColor(.amwayBlack)
                    .multilineTextAlignment(.center)
                    .frame(alignment: .center)
                if description != "" {
                    Text(description)
                        .font(.getCustomFontWithSize(fontType: .gt_walsheim_regular, fontSize: .regular))
                        .foregroundColor(.amwayBlack)
                        .multilineTextAlignment(.center)
                }
                
                if let onButtonClick = onButtonClick {
                    Button(action: {
                        onButtonClick()
                    }) {
                        HStack {
                            Text(btnTitle == "" ? "Try Again" : btnTitle)
                                .font(.getCustomFontWithSize(fontType: .gt_walsheim_medium, fontSize: .large))
                                .foregroundColor(Color.darkPurple)
                            Image("ReloadIcon", bundle: AppConstants.bundle)
                        }
                    }
                    .padding(.top, 8)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: fullHeight ? .infinity : nil)
        .frame(height: !fullHeight ? height : nil)
        .background(bgColor)
        .cornerRadius(12)
        .padding(.horizontal, paddingHorizontal)
    }
}

struct ErrorStateView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorStateView(imageName: "BrokenLink", title: "Looks like the link is broken", description: "") {
            
        }
    }
}
