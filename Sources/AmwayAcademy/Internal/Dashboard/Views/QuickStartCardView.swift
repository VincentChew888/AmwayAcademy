//
//  QuickStartCardView.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 12/01/22.
//


//This card can be used for Quick Start Courses(on Dashboard)

import SwiftUI
import Shimmer

struct QuickStartCardView: View {
    
    @Binding var course : CourseModel
    @State var isLoading: Bool = false
    var isNew: Bool = false
    var newText: String = "New!"
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 10.0) {
            
            VStack {
                
                ZStack(alignment: .topLeading) {
                    
                    CustomImageView(url: course.thumbnail, width: 99, height: 99, placeholderImage: "DefaultImage1x1", aspectRatio: 1)
                    .background(isLoading ? Color.gray : Color.white)
                    .cornerRadius(AppConstants.dashboardMaxCardCornerRadius)
                    .redacted(reason: isLoading ? .placeholder : [])
                    .shimmering(active: isLoading)

                    Text(course.isNew ? StaticLabel.get("txtNew") : "")
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                            .foregroundColor(.darkPurple)
                            .background(Color.lightPurple)
                            .cornerRadius(4)
                            .font(.getCustomFontWithSize(fontType: .gt_walsheim_medium, fontSize: .regular))
                            .padding([.top, .leading], 8)
                            .opacity(course.isNew ? 1 : 0)

                }
            }
            
            
            ZStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    HStack {
                        Text(course.title)
                            .lineLimit(2)
                            .font(.getCustomFontWithSize(fontType: .gt_walsheim_medium, fontSize: .regular))
                            .foregroundColor(.amwayBlack)
                            .shimmering(active: isLoading)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    
                    HStack {
                        Text(course.description)
                            .lineLimit(2)
                            .font(.getCustomFontWithSize(fontType: .gt_walsheim_regular, fontSize: .regular))
                            .foregroundColor(.darkGray)
                            .shimmering(active: isLoading)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                
//                Spacer()
                VStack(alignment: .leading) {
                    HStack {
                        
                        CustomLabelWithImage(image: "TimeIcon", title: "\(course.duration)")
                        .shimmering(active: isLoading)
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
//                            if course.isDownloadAvailable {
//                                Image("DownloadIcon", bundle: AppConstants.bundle)
//                                    .resizable()
//                                    .frame(width: 24, height: 24)
//                            }
                            
                            if course.isFavorite {
                                Image("FavIcon", bundle: AppConstants.bundle)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                            
                            if course.isCertificateAvailable {
                                Image("CertificateIcon", bundle: AppConstants.bundle)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                        }
                    }
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            .frame(minHeight: 97, maxHeight: 97)
        }
        .frame(maxHeight: 120)
        .fixedSize(horizontal: false, vertical: true)
        .padding(16)
    }
}

struct QuickStartCardView_Previews: PreviewProvider {
    static var previews: some View {
        QuickStartCardView(course: .constant(CourseModel()))
    }
}
