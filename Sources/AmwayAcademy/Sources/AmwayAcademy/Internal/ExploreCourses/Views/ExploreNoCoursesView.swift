//
//  ExploreNoCoursesView.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 08/04/22.
//

import SwiftUI

struct ExploreNoCoursesView: View {
    var body: some View {
        VStack {
            Image("ExploreNoCoursesIcon", bundle: AppConstants.bundle)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 82, height: 85)
                .padding(.top, 24)
            
            Text(StaticLabel.get("txtNoResult"))
                .padding(.top, 20)
                .padding([.leading, .trailing], 16)
                .padding(.bottom, 8)
                .font(.getCustomFontWithSize(fontType: .gt_walsheim_medium, fontSize: .vlargemid))
                .foregroundColor(.amwayBlack)
            
            Text(StaticLabel.get("txtNoResultDescription"))
                .lineLimit(2)
                .padding([.leading, .trailing], 16)
                .padding(.bottom, 24)
                .font(.getCustomFontWithSize(fontType: .gt_walsheim_regular, fontSize: .medium))
                .foregroundColor(.amwayBlack)
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .customRoundedRectangle(cornerRadius: 12)
    }
}

struct ExploreNoCoursesView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreNoCoursesView()
    }
}
