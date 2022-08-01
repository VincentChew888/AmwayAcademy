//
//  CustomLabelWithImage.swift
//  ABOAcademy
//
//  Created by Swapnil Tilkari on 23/02/22.
//

import SwiftUI

struct CustomLabelWithImage: View {
    var image : String = ""
    var title : String = ""
    var backgroundColor : Color?
    var forgroundColor : Color = Color.darkPurple
    var body: some View {
        
        HStack(spacing: 4) {
            if(image != "") {
                Image(image, bundle: AppConstants.bundle)
            }
            Text(title)
        }
        .padding(.vertical,backgroundColor != nil ?  4 : 0)
        .padding(.horizontal,backgroundColor != nil ?  8 : 0)
        .font(.getCustomFontWithSize(fontType: .gt_walsheim_medium, fontSize: .regular))
        .foregroundColor(forgroundColor)
        .background(backgroundColor)
        .customRoundedRectangle(cornerRadius: 4)
    }
}

struct CustomLabelWithImageType2: View {
    var image : String = ""
    var title : String = ""
    var backgroundColor : Color?
    var forgroundColor : Color = Color.darkPurple
    var body: some View {
        
        HStack(spacing: 4) {
            Text(title)
            if(image != "") {
                Image(image, bundle: AppConstants.bundle)
            }
            
        }
        .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .regular))
        .foregroundColor(forgroundColor)
        .background(backgroundColor)
       
    }
}

struct CustomLabelWithImage_Previews: PreviewProvider {
    static var previews: some View {
        CustomLabelWithImage()
    }
}
