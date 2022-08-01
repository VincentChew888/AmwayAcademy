//
//  CourseAdaptView.swift
//  ABOAcademy
//
//  Created by Swapnil Tilkari on 25/03/22.
//

import SwiftUI

struct CourseAdaptView: View {
    
    @Binding var showCourse : Bool
    @Binding var course : CourseModel
    @Binding var cookieData: CookieDataModel
    
    @StateObject var courseData = CourseDetailsMainViewModel.shared
    @StateObject var langData = LangViewModel.shared
    @StateObject var courseAdaptyVM: CourseAdaptVM = CourseAdaptVM.shared
    //    @ObservedObject var model : CourseAdaptModel
    
    // @State var isLoading : Bool = true
    var body: some View {
        VStack(alignment:.leading,spacing: 0) {
            // ScrollView {
            CustomNavBar(navBarTitle: course.title, showRightNavButton: false, rightNavButtonIsExploreButton: false, showCompletionDetails: .constant(false)) {
                if courseAdaptyVM.otherUrlRequest != nil {
                    courseAdaptyVM.otherUrlRequest = nil
                    return
                }
                
                showCourse = false
            } rightBarAction: {
                //  showFilterView.toggle()
            }
            ZStack {
                
                WebView(cookieData: $cookieData,courseID: $course.courseId)
                    .background(Color.white)
                
                //            SwiftUIWebView(viewModel: model)
                //                .background(Color.white)
                
                //            CourseAdaptLoadingView()
                if cookieData.didFinishLoading {
                    
                }else{
                    ProgressView()
                        //.opacity(cookieData.didFinishLoading ? 0 : 1 )
                }
                
                if courseAdaptyVM.otherUrlRequest != nil {
                    WebView(cookieData: $cookieData,courseID: $course.courseId, urlRequest: courseAdaptyVM.otherUrlRequest)
                        .background(Color.red.opacity(0.5))
                }
              
                
                //Commenting for now, will uncomment after Swapnils confirmation
                /*
                if model.outPutName != "" {
                    VStack {
                        Spacer()
                        Text(model.outPutName)
                        Spacer()
                    }
                    
                }
                 */
            }
            .background(Color.white)
            .onAppear {
                AmwayAppLogger.generalLogger.debug(cookieData.courseUrl)
                
            }
            
            // Spacer()
            
            //}
            //.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
}

//struct CourseAdaptView_Previews: PreviewProvider {
//    static var previews: some View {
//        CourseAdaptView()
//    }
//}
