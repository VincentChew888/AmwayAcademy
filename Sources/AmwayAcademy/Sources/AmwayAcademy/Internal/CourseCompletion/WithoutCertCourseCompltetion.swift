//
//  WithoutCertCourseCompltetion.swift
//  ABOAcademy
//
//  Created by Swapnil Tilkari on 09/03/22.
//

import SwiftUI

struct WithoutCertCourseCompltetion: View {
    @Binding var courseId: String
    @Binding var showWithoutCertificateDetails: Bool
    @Binding var showSecondView: Bool
    @StateObject var courseData = CourseDetailsMainViewModel.shared
    @StateObject var langData = LangViewModel.shared
    
    var body: some View {
        VStack {
            if courseData.getCourseDataAPIStatus == .Loading {
                CourseDetailsLoadingView()
            } else if courseData.getCourseDataAPIStatus == .success {
                ZStack(alignment:.topTrailing) {
                ZStack(alignment:.top) {
                // Image("CertificateConfetti", bundle: AppConstants.bundle)
                       //.resizable()
                    VStack {
                        
                    }
                        .frame(width: UIScreen.main.bounds.width,height: 200)
                        .padding(.top, 50)
                   
                VStack(alignment:.leading,spacing: 0) {
                    Spacer()
                 Image("WithoutCertificate", bundle: AppConstants.bundle)
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width,height: 400)
                       
                        
                VStack(alignment:.leading,spacing: 0) {
                    HStack {
                        Text(courseData.course.title)
                            .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .regular))
                        Spacer()
                    }
                    HStack {
                        Text("\(StaticLabel.get("txtWellDone"))\n\(StaticLabel.get("txtCompletedThisCourse"))")
                            .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .xxxLarge))
                        Spacer()
                    }
                    
        //            Button {
        //
        //            } label: {
        //                HStack {
        //                    Spacer()
        //                Text("View Certificate")
        //                    .padding(9)
        //                    .foregroundColor(Color.black)
        //                    .font(.getCustomFontWithSize(fontType: .gt_walsheim_regular, fontSize: .regular))
        //                    Spacer()
        //
        //                }
        //                .background(Color.white)
        //                .customRoundedRectangle()
        //                .padding(.top,24)
        //            }

                 }
                //.frame(width: UIScreen.main.bounds.width)
                .padding(16)
                .padding(.bottom, 80)
                .foregroundColor(Color.white)
                
                .background(Color.darkPurple)
                // .clipShape(curvedSideRectangle())
                        
                    }
                  //.frame(height: 450)
                
                
                }
                //
                //.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .navigationBarHidden(true)
                    
                  Image("CloseBlackIcon", bundle: AppConstants.bundle)
                        .padding(16)
                        .onTapGesture {
                            showWithoutCertificateDetails = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                showSecondView = true
                            }
                        }
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear(perform: {
            getData()
        })
        .onDisappear {
            langData.selectedLang.langCode = LangModel().langCode
            langData.selectedLang.language = LangModel().language
        }
    }
    
    func getData() {
        courseData.getCourseData(CourseId: courseId,lang: langData.selectedLang.langCode){

        }
    }
}

//struct WithoutCertCourseCompltetion_Previews: PreviewProvider {
//    static var previews: some View {
//        WithoutCertCourseCompltetion(showWithoutCertificateDetails: .constant(true), showSecondView: .constant(false))
//    }
//}
