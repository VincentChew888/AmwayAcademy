//
//  InProgressCarouselView.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 10/02/22.
//

import SwiftUI

//struct InProgressCarouselView: View {
//
//    @Binding var inProgressCourses: [CourseModel]
//    @Binding var selectedCourse : CourseModel
//    @Binding var showCourseDetails : Bool
//
//    @State private var index = 0
//    @State var videoXOffset: CGFloat = 0
//
//    var body: some View {
//        VStack(spacing: 16) {
//            TabView(selection: $index) {
//                ForEach((0..<min(inProgressCourses.count, 5)), id: \.self) { i in
//                    InProgressCardView(course: inProgressCourses[i]) {
//                        //                        inProgressCourses.remove(at: index)
//                    }
//                    .padding(.horizontal, 16)
//                    .onTapGesture {
//                        selectedCourse = inProgressCourses[i]
//                        showCourseDetails.toggle()
//                    }
//                }
//            }
//            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//            .frame(maxWidth: .infinity)
//            .frame(height: 330)
//
//            HStack(spacing: 12) {
//                ForEach((0..<inProgressCourses.count), id: \.self) { i in
//                    Circle()
//                        .fill(i == self.index ? Color.darkPurple : Color.outlinePurple)
//                        .frame(width: 8, height: 8)
//
//                }
//            }
//        }
//        .frame(maxWidth: 600)
//    }
//}

struct InProgressCardView: View {
    
    @State var course: CourseModel = CourseModel()
    @Binding var carouselIndex: Int
    @Binding var inProgressDashboardCourses: [CourseModel]
    @State var xOffset: CGFloat = 0
    
    @StateObject var DashboardData : DashboardViewModel = DashboardViewModel.shared
    
    var courseImageURL: String = ""
    var courseTitle: String = "Selling Balance Within™️ Probiotics to Build Your Business Probiotics to Build"
    var courseDuration: String = "1h 15m"
    var coursesCount: String = "10 Courses"

    @State var isLoading: Bool = false
    //    @State var progressValue: Float = 0.1
    
    var onCloseButtonClick: ()->Void = {}
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            ZStack(alignment: .top) {
                if course.bannerImage != "" {
                    CustomImageView(url: course.bannerImage, height: 162, placeholderImage: "DefaultImage", aspectRatio: 16/9)
                        .background(isLoading ? Color.gray : Color.white)
                    //                .cornerRadius(AppConstants.dashboardMaxCardCornerRadius)
                        .redacted(reason: isLoading ? .placeholder : [])
                        .shimmering(active: isLoading)
                } else {
                    Image("DefaultImage", bundle: AppConstants.bundle)
                        .resizable()
                    // .aspectRatio(contentMode: .fit)
                        .frame(height: 162)
                }
                
                HStack(alignment: .top) {
                    HStack(alignment: .top, spacing: 4) {
                        if course.isNew {
                            
                            TagView(image: "New")
                        }
                        if course.courseType.contains(where: { courseType in courseType.lowercased() == CourseType.Required.rawValue.lowercased()}) {
                        
                        TagView(image: "Required",backgroundColor:Color.alertLightOrange,forgroundColor: .alertOrange  )
                        }
                        
                        if course.courseType.contains(where: { courseType in courseType.lowercased() == CourseType.Shared.rawValue.lowercased()}) {
                            TagView(image: "Shared",backgroundColor:Color.lightGreen,forgroundColor:  .darkGreen  )
                        }
                    }
                    .padding([.horizontal, .top], 12)
                
                    Spacer()
                    Button {
                        withAnimation(.spring()) {
                            xOffset = -500
                        }
                        // This is to fix the issue that occurs when the last course in the carousel is deleted and there are no courses at the current selected index so we have to manually decrease the index
                        var changeCarouselIndex = false
                        if carouselIndex != 0 && carouselIndex == DashboardData.inProgressCourses.count-1 {
                            changeCarouselIndex = true
                        }
                        AmwayAppLogger.generalLogger.debug("Delete Button pressed for course selected \(course)")
                        removeCourse(course: course) {
                            if changeCarouselIndex {
                                carouselIndex = DashboardData.inProgressCourses.count-1
                            }
                        }
                        
                    } label: {
                        Image("CloseBlackIcon", bundle: AppConstants.bundle)
                            .resizable()
                            .frame(width: 12, height: 12)
                            .padding(8)
                            .background(Color.amwayWhite)
                            .clipShape(Circle())
                    }
                    .padding([.top, .trailing], 8)
                }
            }
            
            VStack(alignment: .leading) {
                
                Text(course.title)
                    .font(.getCustomFontWithSize(fontType: .gt_walsheim_bold, fontSize: .vvLarge))
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(3)
                    .foregroundColor(.amwayBlack)
                
                Spacer()
                
                HStack(alignment: .center) {
                    
                    CustomLabelWithImage(image: "LoadIcon", title: "\(String(course.duration)) \(StaticLabel.get("txtLeft"))")
                        .padding(.trailing, 8)
                    
                    ProgressBar(value: $course.progress)
                        .frame(height: 10)
                        .padding(.trailing, 12)
                    
                    //                    Spacer()
                    HStack(spacing: 4) {
                        if course.isFavorite {
                            Image("FavIcon", bundle: AppConstants.bundle)
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        
                        //                        Image("DownloadIcon", bundle: AppConstants.bundle)
                        //                            .resizable()
                        //                            .frame(width: 24, height: 24)
                    }
                }
                
            }
            .padding([.horizontal, .bottom], 16)
            .padding(.top, 10)
        }
        .background(Color.white)
        .cornerRadius(12)
        .offset(x: xOffset)
    }
    
    func removeCourse(course: CourseModel, success: @escaping ()->Void) {
        DashboardData.clearInProgressCourse(course: course) {
            
            if let index = DashboardData.inProgressCourses.firstIndex(where: { $0.courseId == course.courseId }) {
                DashboardData.inProgressCourses.remove(at: index)
            }
            inProgressDashboardCourses.removeAll()
            for i in 0..<min(DashboardData.inProgressCourses.count, 6) {
                inProgressDashboardCourses.append(DashboardData.inProgressCourses[i])
            }
            
            success()
            AmwayAppLogger.generalLogger.debug("Course deleted")
        }
    }
}

struct ProgressBar: View {
    
    @Binding var value: Int
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color.gray)
                
                Rectangle().frame(width: min(CGFloat(self.value)*geometry.size.width*0.01, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color.darkPurple)
                    .animation(.linear, value: value)
                    .clipShape(Capsule())
            }
            .cornerRadius(5.0)
        }
    }
}

//struct InProgressCarouselView_Previews: PreviewProvider {
//    static var previews: some View {
//        InProgressCarouselView(inProgressCourses: .constant([]),selectedCourse: CourseModel(),showCourseDetails: .constant(Bool))
//    }
//}
