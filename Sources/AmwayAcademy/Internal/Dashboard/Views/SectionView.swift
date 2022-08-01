//
//  SectionView.swift
//  ABOAcademy
//
//  Created by Swapnil Tilkari on 17/02/22.
//

import SwiftUI

struct SectionView: View {
    var image : String = ""
    var title : String = ""
    var subtitle : String = ""
    var forgroundColor : Color = .black
    var backgroundColor : Color = .black
    
    var body: some View {
        
        HStack(spacing: 16){
            
            Image(image, bundle: AppConstants.bundle)
                .resizable()
                .frame(width: 85, height: 65)
            
            VStack(alignment: .leading, spacing : 8){
                
                Text(title)
                    .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .vvLarge))
                    .foregroundColor(forgroundColor)
                
                Text(subtitle)
                    .font(.getCustomFontWithSize(fontType: .gt_walsheim_regular, fontSize: .regular))
                    .foregroundColor(forgroundColor)
            }
            
            Spacer()
            
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .background(backgroundColor)
        .customRoundedRectangle()
    }
}

struct SectionView_Previews: PreviewProvider {
    static var previews: some View {
        SectionView()
    }
}
