//
//  TagView.swift
//  ABOAcademy
//
//  Created by Swapnil Tilkari on 23/02/22.
//

import SwiftUI

struct TagView: View {
    
    var image : String = ""
    var backgroundColor : Color = Color.lightPurple
    var forgroundColor : Color = Color.darkPurple
    var body: some View {
        
        Text(StaticLabel.get("txt"+image))
            .padding([.leading, .trailing], 8)
            .padding([.top, .bottom], 3)
            .foregroundColor(forgroundColor)
            .background(backgroundColor)
            .customRoundedRectangle(cornerRadius: 4)
            .font(.getCustomFontWithSize(fontType: .gt_walsheim_medium, fontSize: .regular))
            //.padding(8)
    }
}
struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView(image: "LearningPathDetails")
    }
}
