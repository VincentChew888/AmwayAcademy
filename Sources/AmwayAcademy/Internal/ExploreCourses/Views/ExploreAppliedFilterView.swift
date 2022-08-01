//
//  ExploreAppliedFilterView.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 15/03/22.
//

import SwiftUI

struct ExploreAppliedFilterView: View {
    
    @Binding var selectedFilters: [ExploreFilterModel]
    @Binding var totalHeight: CGFloat
    
    @StateObject var FilterData : ExploreFilterVM = ExploreFilterVM.shared
    
    @Binding var tempSubCatData: [SubCategory]
    @Binding var isFilterApplied: Bool
    
    let geometry: GeometryProxy

    var body: some View {
        self.generateContent(in: geometry)
    }

    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero


        return ZStack(alignment: .topLeading) {
            ForEach($tempSubCatData, id: \.self) { subCategoryFilter in
                AppliedFilter(subCategory: subCategoryFilter, selectedFilters: $selectedFilters, tempSubCatData: $tempSubCatData, isFilterApplied: $isFilterApplied)
                    .padding([.trailing, .leading], 4)
                    .padding(.bottom, 8)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if subCategoryFilter.wrappedValue == tempSubCatData.last! {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { d in
                        let result = height
                        if subCategoryFilter.wrappedValue == tempSubCatData.last! {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }
        .onAppear(perform: {
            tempSubCatData = FilterData.getAllSubCatSelected()
            if tempSubCatData.count > 0 {
                isFilterApplied = true
            } else {
                isFilterApplied = false
            }
        })
        .background(viewHeightReader($totalHeight))
    }
    
    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}

struct AppliedFilter: View {
    
    @Binding var subCategory: SubCategory
    @Binding var selectedFilters: [ExploreFilterModel]
    @Binding var tempSubCatData: [SubCategory]
    @StateObject var FilterData : ExploreFilterVM = ExploreFilterVM.shared
    @Binding var isFilterApplied: Bool

    var body: some View {
        
        HStack {
            Text(subCategory.title)
                .frame(height:24)
                .padding(.leading, 12)
                .font(.getCustomFontWithSize(fontType: .gt_walsheim_medium, fontSize: .regular))
                .foregroundColor(Color.white)
                .allowsHitTesting(false)
            
            Image("ExploreCloseIcon", bundle: AppConstants.bundle)
                .resizable()
                .frame(width: 14, height: 14)
                .padding(.trailing, 8)
                .onTapGesture {
                    FilterData.removeSelectedFilter(subCategory: subCategory)
                    subCategory.isMarked = false
                    FilterData.checkboxSelected(clickedFilter: subCategory, isFromExploreLandingPage: true)
                    tempSubCatData = FilterData.getAllSubCatSelected()
                    if tempSubCatData.count > 0 {
                        isFilterApplied = true
                    } else {
                        isFilterApplied = false
                    }
                }
                .contentShape(Circle())
        }
        .padding(.vertical, 3)
        .background(Color.darkPurple.allowsHitTesting(false))
        .clipShape(Capsule())
        .customRoundedRectangleOverlay(cornerRadius: 50, color: .darkPurple, lineWidth: 1.0)
    }
}

//struct ExplorAppliedFilterView_Previews: PreviewProvider {
//    static var previews: some View {
//        GeometryReader { geo in
//            ExploreAppliedFilterView(geometry: geo)
//        }
//    }
//}
