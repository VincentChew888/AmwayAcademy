//
//  CertificateCourseCompletion.swift
//  ABOAcademy
//
//  Created by Swapnil Tilkari on 07/03/22.
//

import SwiftUI

struct CertificateCourseCompletion: View {
    @Binding var courseId: String
    @Binding var showCertificateDetails: Bool
    @Binding var showCompletionDetails: Bool
//    @State var certificateSheetState: Bool = false
    @State var certificateSheetState: ResizableSheetState = .hidden
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
                        
                        VStack(alignment:.leading,spacing: 0) {
                            Spacer()
                            Image("CertificateLarge", bundle: AppConstants.bundle)
                                .resizable()
                                .scaledToFit()
                            
                            
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
                                
                                Button {
    //                                showCertificate.toggle()
                                    certificateSheetState = .medium
                                } label: {
                                    HStack {
                                        Spacer()
                                        Text(StaticLabel.get("txtViewCertificate"))
                                            .padding(9)
                                            .foregroundColor(Color.darkPurple)
                                            .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .regular))
                                        Spacer()
                                        
                                    }
                                    .background(Color.white)
                                    .customRoundedRectangle(cornerRadius: 24)
                                }
                                .frame(height: 36)
                                .padding(.top,24)
                                
                            }
                            .padding(16)
                            .padding(.bottom, 80)
                            .foregroundColor(Color.white)
                            // .frame(width: UIScreen.main.bounds.width)
                            .background(Color.darkPurple)
                            // .clipShape(curvedSideRectangle())
                            
                        }
                        //.frame(height: 450)
                        
                        
                    }
                    
                    Image("CloseBlackIcon", bundle: AppConstants.bundle)
                        .padding(16)
                        .onTapGesture {
                            showCertificateDetails = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                showCompletionDetails = true
                            }
                        }
                }
                .edgesIgnoringSafeArea(.bottom)
            } else if courseData.getCourseDataAPIStatus == .failure(.ApiError) {
                ErrorStateView(imageName: "BrokenLink", title: StaticLabel.get("txtReloadDrawerDescription"))
            }
        }
        .resizableSheet($certificateSheetState, id: "cert-sheet-1") { builder in
            builder.content { context in
                CertificateBottomPopUp(certificateSheetState: $certificateSheetState, course: $courseData.course)
            }
            .sheetBackground { _ in
                Color.black.opacity(0.01)
            }
            .supportedState([.hidden, .medium])
        }
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

struct curvedSideRectangle : Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY) )
        //path.addLine(to: CGPoint(x: 0, y: rect.minY))
        // path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addQuadCurve(to: CGPoint(x:0, y: rect.maxY), control: CGPoint(x: rect.midX, y: rect.maxY + 50))
        
        return path
    }
    
    
}

//struct CertificateCourseCompletion_Previews: PreviewProvider {
//    static var previews: some View {
//        CertificateCourseCompletion(showCertificateDetails: .constant(true), showCompletionDetails: .constant(false), course: .constant(CourseModel()))
//    }
//}
