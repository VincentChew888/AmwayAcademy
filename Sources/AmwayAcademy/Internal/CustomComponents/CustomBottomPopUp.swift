//
//  CustomBottomPopUp.swift
//  Spark
//
//  Created by Swapnil.Tilkari on 01/06/21.
//

import SwiftUI

struct CustomBottomPopUp<Content: View> : View {
    var title: String
    var backgroundColor : Color = .white
    var drawerColor : Color = .backGround
    var showCancelButton : Bool = false
    var cancelButtonAction : (() ->Void)?
    var showClearButton : Bool = false
    var clearButtonAction : (() ->Void)?
    let content: () -> Content
    @Binding var showContentView : Bool
    @Binding var handleDragGesture : Bool
    @Binding var handleBgTapGesture : Bool
    @State var draggedOffset = CGSize.zero
    
    //New Props
    var showTitle : Bool = true
    var showDrawerInZStack : Bool = false
    var disableHorizontalPadding : Bool = false
    var disableVerticalPadding: Bool = false
    var showDrawerBackgroundColor: Bool = false
    var drawerSpacing : CGFloat = 16
    init(title: String,showContentView:Binding<Bool>,handleDragGesture: Binding<Bool>,handleBgTapGesture:Binding<Bool>, backgroundColor:  Color,showDrawerInZStack: Bool = true, showDrawerBackgroundColor: Bool = false, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self._showContentView = showContentView
        self.content = content
        self._handleDragGesture = handleDragGesture
        self._handleBgTapGesture = handleBgTapGesture
        self.backgroundColor = backgroundColor
        self.showDrawerInZStack = showDrawerInZStack
        self.showDrawerBackgroundColor = showDrawerBackgroundColor
    }
    
    init(title: String,showContentView:Binding<Bool>,handleDragGesture: Binding<Bool>,handleBgTapGesture:Binding<Bool>, disableHorizontalPadding : Bool = false, disableVerticalPadding: Bool = false, showTitle : Bool = true,drawerColor: Color,drawerSpacing: CGFloat = 0,showDrawerInZStack: Bool = true, showDrawerBackgroundColor: Bool = false, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self._showContentView = showContentView
        self.content = content
        self._handleDragGesture = handleDragGesture
        self._handleBgTapGesture = handleBgTapGesture
        self.disableHorizontalPadding = disableHorizontalPadding
        self.disableVerticalPadding = disableVerticalPadding
        self.showTitle = showTitle
        self.drawerColor = drawerColor
        self.showDrawerInZStack = showDrawerInZStack
        self.showDrawerBackgroundColor = showDrawerBackgroundColor
        self.drawerSpacing = drawerSpacing
        // self.backgroundColor = backgroundColor ?? .white
    }
    init(title: String,showContentView:Binding<Bool>,handleDragGesture: Binding<Bool>,handleBgTapGesture:Binding<Bool>,showCancelButton:Bool,showDrawerInZStack: Bool = true,showDrawerBackgroundColor: Bool = false, cancelButtonAction: (() ->Void)?, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self._showContentView = showContentView
        self.content = content
        self._handleDragGesture = handleDragGesture
        self._handleBgTapGesture = handleBgTapGesture
        self.showCancelButton = showCancelButton
        self.cancelButtonAction = cancelButtonAction
        self.showDrawerInZStack = showDrawerInZStack
        self.showDrawerBackgroundColor = showDrawerBackgroundColor


    }
    init(title: String,showContentView:Binding<Bool>,handleDragGesture: Binding<Bool>,handleBgTapGesture:Binding<Bool>,showCancelButton:Bool,showDrawerInZStack: Bool = true,showDrawerBackgroundColor: Bool = false, showClearButton:Bool,cancelButtonAction: (() ->Void)?,clearButtonAction: (() ->Void)?, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self._showContentView = showContentView
        self.content = content
        self._handleDragGesture = handleDragGesture
        self._handleBgTapGesture = handleBgTapGesture
        self.showCancelButton = showCancelButton
        self.cancelButtonAction = cancelButtonAction
        self.showClearButton = showClearButton
        self.clearButtonAction = clearButtonAction
        self.showDrawerInZStack = showDrawerInZStack
        self.showDrawerBackgroundColor = showDrawerBackgroundColor

    }
    
    var body : some View {
        
        VStack(alignment:.leading,spacing: 0){
            
            Spacer()
            ZStack(alignment:.top) {
                
                VStack(alignment:.leading,spacing: 0){
                    
                    //
                    //MARK:- Dragger
                    //
                    // if showTitle {
                    if !showDrawerInZStack {
                    HStack {
                        Spacer()
                        Rectangle()
                            .foregroundColor(drawerColor)
                            .frame(width: 50, height: 3,alignment: .center)
                            .customRoundedRectangle()
                        
                        Spacer()
                    }
                    .padding(.vertical,10)
                    .frame(height: self.showDrawerBackgroundColor ? 35 : nil)
                    .background(self.showDrawerBackgroundColor ? Color.amwayWhite : nil)

                    }
                    // }
                    
                    //
                    //MARK:- Title
                    //
                    if showTitle {
                        HStack {
                            if showCancelButton {
                                Image("RemoveFounder", bundle: AppConstants.bundle)
                                    .resizable()
                                    .frame(width: 12, height: 12, alignment: .center)
                                    .onTapGesture {
                                        if let action = cancelButtonAction {
                                            action()
                                        }
                                    }
                            }
                            
                            Text(title)
                                .padding(.trailing, showClearButton ? -50 : 0)
                                .frame(alignment: .center)
                                .font(.getCustomFontWithSize(fontType: .gt_walsheim_medium, fontSize: .largemid))
                            Spacer()
                            if showClearButton {
                                Text(StaticLabel.get("txtClearAll"))
                                    .foregroundColor(.darkPurple)
                                    .font(.getCustomFontWithSize(fontType: .gt_walsheim_regular, fontSize: .largemid))
                                    .onTapGesture {
                                        if let action = clearButtonAction {
                                            action()
                                        }
                                    }
                            }
                            
                        }
                        .padding([.top, .horizontal], 16)
                        Divider()
                            .padding([.top], 20)
                    }
                    //
                    //MARK:- Content
                    //
                    
                    content()
                        .padding(.top, showDrawerInZStack ? 00 : 20)
//                        .padding(.bottom,(UIApplication.shared.windows.last?.safeAreaInsets.bottom)!)
                    //Spacer()
                    
                }
                
                
                if showDrawerInZStack {
                HStack {
                    Spacer()
                    Rectangle()
                        .foregroundColor(drawerColor)
                        .frame(width: 48, height: 5,alignment: .center)
                        .customRoundedRectangle()
                    
                    Spacer()
                }
                .padding(.vertical,10)
                }
                
            }
            .padding(.horizontal, disableHorizontalPadding ? 0 : nil)
            .edgesIgnoringSafeArea(.all)
            .background(backgroundColor)
            .cornerRadius(25,corners: [.topLeft,.topRight])
            
            .offset(y: showContentView ? self.draggedOffset.height:UIScreen.main.bounds.height + CGFloat(30))
           
            
            
        }
        .edgesIgnoringSafeArea(.top)
        .transition(.move(edge: .bottom))
        .animation(.easeInOut)
        .background(Color.black.opacity(showContentView ? 0.3 : 0).ignoresSafeArea())
       // .animation(.spring())
//        .offset(x: 0, y: sheetYOffset)
//        .transition(.move(edge: .bottom))
//        .animation(.easeInOut, value: showContentView)
        .onTapGesture(perform: {
            if !showCancelButton {
                if let action = cancelButtonAction {
                    action()
                }
            }
            if handleBgTapGesture {
                self.showContentView.toggle()
            }
        })
        .gesture(handleDragGesture ? DragGesture()
        .onChanged({ value in
            if ( value.translation.height > 0 ){
                withAnimation(.easeInOut) {
                    self.draggedOffset = value.translation
                }
            }
        })
        .onEnded({ value in
            if value.translation.height >= 150 {
                showContentView.toggle()
            } else {
                withAnimation(.easeInOut) {
                    self.draggedOffset = CGSize.zero
                }
            }
            
        })
                 : nil
        )
       
        
        
    }
   
}
