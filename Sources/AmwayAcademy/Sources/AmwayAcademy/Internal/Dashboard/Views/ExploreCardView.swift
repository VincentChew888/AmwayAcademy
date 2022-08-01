//
//  ExploreCardView.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 12/01/22.
//

//This card can be used for Explore Section on Dashboard

import SwiftUI




struct ExploreView: View {
    var tags: [String]

    @State private var totalHeight
          = CGFloat.zero       // << variant for ScrollView/List
    //    = CGFloat.infinity   // << variant for VStack

    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
        .frame(height: totalHeight)// << variant for ScrollView/List
        //.frame(maxHeight: totalHeight) // << variant for VStack
    }

    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(self.tags, id: \.self) { tag in
                self.item(for: tag)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width) {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if tag == self.tags.last! {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { d in
                        let result = height
                        if tag == self.tags.last! {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }
        .background(viewHeightReader($totalHeight))
        
    }

    private func item(for text: String) -> some View {
        
        ZStack {
            HStack {
                Spacer()
                    .frame(width: 10)
                Image("CoursesIcon", bundle: AppConstants.bundle)
                    .resizable()
                    .frame(width: 25, height: 25, alignment: .center)
                    .aspectRatio(1, contentMode: .fit)
                Text(text)
                    .font(.getCustomFontWithSize(fontType: .gt_walsheim_medium, fontSize: .regular))
                    .foregroundColor(.amwayBlack)
                    .lineLimit(1)
                    .frame(height: 35)
                Spacer()
                    .frame(width: 10)
            }
            .padding(.all, 5)
            .font(.body)
            .background(Color.white)
            .cornerRadius(10)
        }
    }

    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .backGround
        }
    }
}

struct ExploreCardView: View {
    
    private var exploreImage: String = ""
    private var exploreTitle: String = "Amway Business"
    private var tags: [String] = ["Amway Business", "Leadership", "Comp & Recognition", "Sponsoring", "Products", "Selling", "Social"]
    
    var body: some View {
        
        VStack {
            ExploreView(tags: tags)
        }
        .background(Color.backGround)
    }
}





struct ExploreCardView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreCardView()
    }
}
