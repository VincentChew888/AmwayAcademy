//
//  CustomImageView.swift
//  ABOAcademy
//
//  Created by Tahir Gani on 31/03/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct CustomImageView: View {
    var url: String
    var width: CGFloat?
    var height: CGFloat
    var placeholderImage: String
    var aspectRatio: CGFloat
    
    var body: some View {
        WebImage(url: URL(string: url))
            .onSuccess { image, data, cacheType in
                
            }
            .resizable()
            .placeholder {
                Image("\(placeholderImage)", bundle: AppConstants.bundle)
                    .resizable()
//                    .scaledToFill()
                    .frame(height: height)
            } // Placeholder Image
//            .placeholder {
//                Rectangle().foregroundColor(.gray)
//            }
            .indicator(.activity) // Activity Indicator
            .transition(.fade(duration: 0.5)) // Fade Transition with duration
            .aspectRatio(aspectRatio, contentMode: .fill)
            .frame(maxWidth: width ?? .infinity)
            .frame(width: width, height: height, alignment: .center)
            .clipped()
    }
}

//struct CustomImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomImageView()
//    }
//}
