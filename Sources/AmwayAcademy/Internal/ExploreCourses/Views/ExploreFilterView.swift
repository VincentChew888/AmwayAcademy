//
//  ExploreFilterView.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 09/03/22.
//

import SwiftUI
import Shimmer

struct ExploreFilterView: View {
        
    @StateObject var FilterData : ExploreFilterVM = ExploreFilterVM.shared
    
    @State var selectedFilter : [SubCategory] = []
    
    @Binding var courseCount : Int
    @Binding var showWarningPopup: Bool
    @Binding var isAppliedFilter: Bool
    
    var applyFilterAction : ((_ appliedFilters: [SubCategory]) -> Void)?
    var cancelAction : (() -> Void)?
    
    @State var dissmissTime: DispatchTime = .now()
    
    
    init(courseCount: Binding<Int>, showWarningPopup: Binding<Bool>, isAppliedFilter: Binding<Bool>, applyFilterAction: @escaping (_ appliedFilters: [SubCategory]) -> (), cancelAction: @escaping () -> ()) {
        self._courseCount = courseCount
        self.applyFilterAction = applyFilterAction
        self.cancelAction = cancelAction
        self._showWarningPopup = showWarningPopup
        self._isAppliedFilter = isAppliedFilter
    }
    
    var body: some View {
        if ((FilterData.getNewestCoursesAPIStatus == .Loading) || (FilterData.getCourseCatalogAPIStatus == .Loading) || (FilterData.getCoursesForAppliedFiltersAPIStatus == .Loading)) {
            ExploreFilterLoadingView()
        } else {
            VStack(alignment: .leading, spacing: 0) {
                
                HStack(alignment: .center, spacing: 0) {
                    Text(StaticLabel.get("txtFilters")+" ")
                        .font(.getCustomFontWithSize(fontType: .gt_walsheim_medium, fontSize: .vlargemid))
                    
                    if FilterData.getCoursesCountForAppliedFiltersAPIStatus == .Loading {
                        Text("(...)")
                            .font(.getCustomFontWithSize(fontType: .gt_walsheim_medium, fontSize: .vlargemid))
    //                    HStack(spacing: 1) {
    //
    ////                        DotLoadingAnimation()
    ////                        DotLoadingAnimation(delay: 0.2) // 2.
    ////                        DotLoadingAnimation(delay: 0.4) // 3.
    ////                        Text(")")
    ////                            .font(.getCustomFontWithSize(fontType: .gt_walsheim_medium, fontSize: .vlargemid))
    //                    }
                    } else {
                        Text("(\(courseCount))")
                            .font(.getCustomFontWithSize(fontType: .gt_walsheim_medium, fontSize: .vlargemid))
                    }
                    
                    Spacer()
                    
                    let areFiltersSelected = !FilterData.selectedCategoryFiltersList.isEmpty || !FilterData.selectedKeywordsFiltersList.isEmpty || !FilterData.selectedSkillsFiltersList.isEmpty
                    Button {
                        //Clear all applied filters
                        FilterData.clearAllFilterState()
                        isAppliedFilter = false
                    } label: {
                        HStack {
                            Text(StaticLabel.get("txtClearAll"))
                                .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .regular))
                                .foregroundColor(areFiltersSelected ? .amwayBlack : .gray)
                                .overlay(Rectangle()
                                            .fill(areFiltersSelected ? Color.amwayBlack : Color.gray)
                                            .frame(height: 2)
                                            .offset(y: 2), alignment: .bottom)
                        }
                    }
                    .disabled(!areFiltersSelected)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
                
                Divider()
                    .frame(height: 1)
                
                VStack {
                    
                    HStack {

                        VStack(alignment: .leading, spacing: 0) {
                            if FilterData.exploreFilters.count > 0 {
                                ScrollView {
                                    //Show Category filter
                                    ForEach(Array(FilterData.exploreFilters.enumerated()), id: \.element) { index, curFilter in
                                            Button(action: {
                                                FilterData.setSelectedCategoryIndex(index: index)
                                            }, label: {
                                                HStack {
                                                    Text(StaticLabel.get("txt\(curFilter.category)"))
                                                        .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .regular))
                                                        .foregroundColor(.amwayBlack)
                                                    Spacer()
                                                }
                                                    .frame(maxWidth: .infinity)
                                                    .frame(height: 42)
                                                    .padding(.horizontal, 16)
                                                    .background(index == FilterData.selectedCategoryIndex ? Color.white : Color.lightGray)
                                            })
                                    }
                                }
                            }
                        }
                        .padding([.top, .bottom], 12)
                        .frame(width: UIScreen.main.bounds.width / 3)
                        .background(Color.lightGray)
                        
                        if FilterData.exploreFilters.count > 0 {
                            VStack(alignment: .leading, spacing: 0) {
                                ScrollView {
                                    VStack(spacing: 22) {
                                        //Show subcategories for selected category filter
                                        ForEach($FilterData.exploreFilters[FilterData.selectedCategoryIndex].subCategory) { curSubCategory in
                                                CheckboxField(subcategoryFilter: curSubCategory, callback: checkboxSelected)
                                                    .padding([.leading, .trailing], 16)
                                            }
                                    }
                                    .padding([.top, .bottom], 23)
                                }
                            }
                        }
                    }
                }

                VStack {

                    HStack(alignment: .center, spacing: 0) {

                        Button(action: {

                            if let cancelAction = cancelAction {
                                cancelAction()
                            }
                        }, label: {

                            Text(StaticLabel.get("txtCancel"))
                                .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .regular))
                                .foregroundColor(.amwayBlack)
                                .frame(width: 120, height: 36)
                        })
    //                        .fixedSize()
    //                        .background()
                        .clipShape(Capsule())
                        .customRoundedRectangleOverlay(cornerRadius: 50, color: .amwayBlack, lineWidth: 2.0)
                        Spacer()
                            .frame(width: 12)
                        Button(action: {
                            if FilterData.coursesCountForAppliedFilters.count == 0 || FilterData.selectedFiltersDict.count == 0 {
                                if !showWarningPopup && courseCount == 0 {
                                    triggerWarningPopup()
                                }
                            } else if let applyFilterAction = applyFilterAction {
                                applyFilterAction(self.selectedFilter)
                            }
                        }, label: {

                            Text(StaticLabel.get("txtApplyFilter"))
                                .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .regular))
                                .foregroundColor((FilterData.coursesCountForAppliedFilters.count != 0 && FilterData.selectedFiltersDict.count != 0) ? .white : .disableButtonText)
                                .frame(height: 36)
                                .frame(maxWidth: .infinity)
                                
                        })
    //                        .fixedSize()
    //                        .padding(.horizontal, 10)
                        .disabled(FilterData.getCoursesCountForAppliedFiltersAPIStatus == .Loading)
    //                    .disabled(FilterData.coursesCountForAppliedFilters.count == 0 || FilterData.selectedFiltersDict.count == 0 || FilterData.getCoursesCountForAppliedFiltersAPIStatus == .Loading)
                        .background((FilterData.coursesCountForAppliedFilters.count != 0 && FilterData.selectedFiltersDict.count != 0 && FilterData.getCoursesCountForAppliedFiltersAPIStatus != .Loading) ? Color.amwayBlack : Color.disableButton)
                        .clipShape(Capsule())
                        .customRoundedRectangleOverlay(cornerRadius: 50, color: (FilterData.coursesCountForAppliedFilters.count != 0 && FilterData.selectedFiltersDict.count != 0 && FilterData.getCoursesCountForAppliedFiltersAPIStatus != .Loading) ? .amwayBlack : .disableButton, lineWidth: 2.0)

                    }
                    .background(Color.white)
                    .padding(16)
                    .padding(.bottom,(UIApplication.shared.windows.last?.safeAreaInsets.bottom)!)
                }
                .background(
                    Color.white
                        .shadow(color: .amwayBlack, radius: 6, x: 0, y: 0)
                        .mask(Rectangle()
                                .padding(.top, -20)
                                .opacity(0.2))
                )
                
    //                VStack{}.frame(height: 10)
            }
            .edgesIgnoringSafeArea(.vertical)
            .onAppear() {
                if FilterData.exploreFilters.count > 0 {
                    
                    FilterData.saveSelectedCategory(categoryFilter: FilterData.exploreFilters[0].category)
                    FilterData.setSelectedCategoryIndex(index: 0)
                }
                FilterData.appliedFilterState()
            }
            .onDisappear() {
                FilterData.cancelFilterState()
            }
        }
    }
    
    func triggerWarningPopup() {
        showWarningPopup = true
        dissmissTime = .now()+3.0
        DispatchQueue.main.asyncAfter(deadline: .now()+3.0) {
            if  .now() >= self.dissmissTime {
                showWarningPopup = false
            }
        }
    }
    
    
    func checkboxSelected(clickedFilter: SubCategory) {
        FilterData.checkboxSelected(clickedFilter: clickedFilter)
    }
}

struct ExploreFilterLoadingView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 0) {
                Text(StaticLabel.get("txtFilters")+" ")
                    .font(.getCustomFontWithSize(fontType: .gt_walsheim_medium, fontSize: .vlargemid))
                    .redacted(reason: .placeholder)
                    .shimmering()
                
                Spacer()
                Text(StaticLabel.get("txtClearAll"))
                    .font(.getCustomFontWithSize(fontType: .gt_walsheim_medium, fontSize: .vlargemid))
                    .redacted(reason: .placeholder)
                    .shimmering()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            
            Divider()
                .frame(height: 1)
            
            VStack {
                
                HStack {

                    VStack(alignment: .leading, spacing: 0) {

                        ScrollView {
                            //Show Category filter
                            ForEach(0..<3, id:\.self) { index in
                                VStack {
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 10)
                                .background(Color.gray.opacity(0.6))
                                .padding(.horizontal, 16)
                                .padding(.top, 22)
                                .redacted(reason: .placeholder)
                                .shimmering()
                            }
                        }
                    }
                    .padding([.top, .bottom], 12)
                    .background(Color.gray.opacity(0.3))
                    .frame(width: UIScreen.main.bounds.width / 3)

                    VStack(alignment: .leading, spacing: 0) {
                        
                        ScrollView {

                            //Show subcategories for selected category filter
                            ForEach(0..<10, id:\.self) { i in
                                VStack {
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 10)
                                .background(Color.gray.opacity(0.6))
                                .padding(.horizontal, 16)
                                .padding(.top, 22)
                                .redacted(reason: .placeholder)
                                .shimmering()
                            }
                        }
                        .padding([.top, .bottom], 12)

                    }
                }
            }

            VStack {

                HStack(alignment: .center, spacing: 12) {

                    Button(action: {
                        
                    }, label: {

                        Text(StaticLabel.get("txtCancel"))
                            .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .regular))
                            .foregroundColor(.amwayBlack)
                            .frame(width: 120, height: 36)
                    })
                    .fixedSize()
//                    .background()
                    .clipShape(Capsule())
                    .customRoundedRectangleOverlay(cornerRadius: 50, color: .amwayBlack, lineWidth: 2.0)
                    .redacted(reason: .placeholder)
                    .shimmering()

                    Button(action: {
                        
                    }, label: {

                        Text(StaticLabel.get("txtApplyFilter"))
                            .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .regular))
                            .foregroundColor(.amwayBlack)
                            .frame(width: 211, height: 36)
                            
                    })
                    .fixedSize()
//                    .background()
                    .padding(.horizontal, 10)
                    .clipShape(Capsule())
                    .customRoundedRectangleOverlay(cornerRadius: 50, color: .amwayBlack, lineWidth: 2.0)
                    .redacted(reason: .placeholder)
                    .shimmering()

                }
                .background(Color.white)
                .padding(16)
                .padding(.bottom,(UIApplication.shared.windows.last?.safeAreaInsets.bottom)!)
            }
            .background(
                Color.white
                    .shadow(color: .amwayBlack, radius: 6, x: 0, y: 0)
                    .mask(Rectangle()
                            .padding(.top, -20)
                            .opacity(0.2))
            )
        }
        .edgesIgnoringSafeArea(.vertical)
        .frame(maxWidth: .infinity, maxHeight: 2*UIScreen.main.bounds.height/3)
    }
}

struct ExploreFilterView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreFilterView(courseCount: .constant(0), showWarningPopup: .constant(false), isAppliedFilter: .constant(false)) { _ in
            
        } cancelAction: {
            
        }

    }
}
