//
//  LearningPathDetails.swift
//  ABOAcademy
//
//  Created by Swapnil Tilkari on 23/02/22.
//

import SwiftUI
import Shimmer

struct LearningPathDetails: View {
    var course : CourseModel = CourseModel()
    @Environment(\.presentationMode) var presentation
    @StateObject var langData = LangViewModel.shared

    var LangArr = ["English","Chinese"]
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0){
                
                CustomNavBar(navBarTitle: StaticLabel.get("txtLearningPath"), showRightNavButton: false, showCompletionDetails: .constant(false)) {
                    presentation.wrappedValue.dismiss()
                } rightBarAction: {
                    
                }
                
                ScrollView {
                    
                    CourseDetailsView(course: course,isLearning: true, courseSection: .noCard, reloadCourses: .constant(false))
                    
                    
                    
                    VStack(alignment:.leading, spacing: 16) {
                        
                        Text(StaticLabel.get("txtCourseInThisLearningPath"))
                            .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .medium))
                        
                        ForEach((0..<3), id: \.self) { index in
                            
                            // InProgressCardView()
                            CourseCardView(course: .constant(course), mediumCardWidth: false)
                                .customShadow(frontColor: .black.opacity(0.1), BackColor: .white)
                            //.padding(.vertical, 16)
                        }
                        
                    }
                    .padding(16)
                }
                
                
                
            }
            .navigationBarHidden(true)
            .background(Color.white)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
        
    }
}

struct LangSelectorCustomPopUp : View {
    
    @Binding var langSheetState: ResizableSheetState
    @StateObject var langData: LangViewModel
    @State var selectedTemp : LangModel = LangModel()
    @StateObject var courseData = CourseDetailsMainViewModel.shared
    @State var center: Int = 1

    var langAction : (() -> Void)?
    
    var body: some View {
        VStack(alignment:.leading,spacing : 0) {
                VStack(alignment:.leading,spacing : 0) {
                    HStack {
                        Spacer()
                        Rectangle()
                            .foregroundColor(.black)
                            .frame(width: 50, height: 3,alignment: .center)
                            .customRoundedRectangle()

                        Spacer()
                    }
                    .frame(height:  35)
                    .background( Color.amwayWhite)
                    .allowsHitTesting(false)
                    
                    if langData.FetchLangAPIStatus == .success {
                        Spacer()
                        VStack {
                            ZStack {
                               Rectangle()
                                    .frame(width: UIScreen.main.bounds.size.width-50, height: 32)
                                .foregroundColor(Color.lightPurple)
                                .cornerRadius(8)

                            Picker("", selection: $selectedTemp, content: {
                                ForEach(0..<langData.LangArr.count, content: { index in // <2>
                                    Text(langData.LangArr[index].language)
                                        .tag(langData.LangArr[index])
                                        .font(.getCustomFontWithSize(fontType: .gt_walsheim_medium, fontSize: .vlargemid))
                                        .foregroundColor(selectedTemp == langData.LangArr[index] ? .darkPurple : .disableButton )

                                    // <3>
                                })
                            })
                                //.listRowBackground(Color.clear)
                            .pickerStyle(WheelPickerStyle())

                            //.preferredColorScheme(colorScheme(Color.lightPurple))
                            .onAppear(perform: {
                               //x UIPickerView.appearance()
                            })

                            .frame(height: 100)
                            }
                            
                            
                            Spacer()

    //                    ScrollView {
    //                        VStack {
    //                            ForEach(0..<langData.LangArr.count){ i in
    //                                HStack {
    //                                    Spacer()
    //                                    Text(langData.LangArr[i].language)
    //                                        .font(.getCustomFontWithSize(fontType: .gt_walsheim_regular, fontSize: .largemid))
    //                                        .padding(.vertical, 8)
    //                                        .padding(.horizontal, 16)
    //                                    Spacer()
    //                                }
    //                                .contentShape(Rectangle())
    //                                .onTapGesture {
    //                                    selectedTemp = langData.LangArr[i]
    //                                    //                            dismiss()
    //                                }
    //                                .background(selectedTemp == langData.LangArr[i] ? Color.lightPurple : Color.white )
    //                                .foregroundColor(selectedTemp == langData.LangArr[i] ? .darkPurple : .disableButton )
    //                                .customRoundedRectangle()
    //                            }
    //                        }
    //                    }

                        Button {
                            langSheetState = .hidden
                            langData.selectedLang = selectedTemp
                            if let action = langAction {
                                action()
                            }
                        } label: {
                            HStack {
                                Spacer()
                                Text(StaticLabel.get("btnSet"))
                                    .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .regular))

                                Spacer()
                            }
                            //.padding(8)
                            .frame(height: 40)

                            .background(Color.black)

                            .foregroundColor(Color.white)
                            .cornerRadius(20)


                        }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                        .padding(.bottom, 34)
                        .edgesIgnoringSafeArea(.bottom)
                    } else {
                        VStack {
                            Spacer()
                            langSelectorLoadingView
                            Spacer()
                        }
                    }
                    }
                    .onAppear(perform: {
                        selectedTemp = langData.selectedLang
                    })
        }
        .frame(height: UIScreen.main.bounds.height/4+40)
      
    }
    
    var langSelectorLoadingView: some View {
        VStack {
            VStack {}
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 32)
            .background(Color.darkPurple)
            .cornerRadius(AppConstants.dashboardMaxCardCornerRadius)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .background(Color.gray.opacity(0.4))
        .cornerRadius(AppConstants.dashboardMaxCardCornerRadius)
        .padding()
        .shimmering()
    }
}

struct LearningPathDetails_Previews: PreviewProvider {
    static var previews: some View {
        LearningPathDetails()
    }
}




