//
//  CourseCardView.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 11/01/22.
//

// This card can be used for Learning Paths, Courses For You, Required Courses

import SwiftUI
import Shimmer

enum CourseType: String {
    case Shared = "shared"
    case Required = "required"
    case CoursesForYou = "courses_for_you"
    case Default = "default"
    case quickStart = "quick_start"
    case inProgress = "in_progress"
    case completed = "completed"
    case newest = "newest"
    case favorite = "favorite"
    case courseCatalog = "course_catalog"
}

struct CourseCardView: View {
    /// Binding value Example
    @Binding var course: CourseModel
    var isNewCourse: Bool = true
    var isAssigned: Bool = true
    var isRequired: Bool = false
    var isLearningPath: Bool = true
    var courseType: CourseType = .Default
    var imageName: String = "DefaultImage"
    var isFromMyCoursesView: Bool = false
    var lineLimit: Int = 3
    var cornerRadius: CGFloat = 12
    var isCoursesListView: Bool = false
    /// If this is true card will not take the full width, else it will take the full width
    var mediumCardWidth: Bool
    var cardHeight: CGFloat?
    @State var isLoading: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .top) {
                
                if  course.thumbnail != "" {
                    
                    VStack {
                        
                        CustomImageView(url: course.bannerImage, width: UIScreen.main.bounds.width, height: 160, placeholderImage: "", aspectRatio: 16/9
                        )
                    }
                    .frame(width: isLoading ? UIScreen.main.bounds.width - 40 : 160, height: isLoading ? 100 : 160)
                    .background(isLoading ? Color.gray : Color.white)
                    
                } else {
                    
                    Image(imageName, bundle: AppConstants.bundle)
                        .resizable()
                    // .aspectRatio(contentMode: .fit)
                        .frame(height: 160)
                }
                
                // TODO: If required add scroll view
                HStack(alignment: .top) {
                    
                    HStack(alignment: .top, spacing: 4) {
                        
                        if course.isNew {
                            
                            TagView(image: "New")
                        }
                        if courseType == .Required || course.courseType.contains(where: { courseType in courseType.lowercased() == CourseType.Required.rawValue.lowercased()}) {
                        
                        TagView(image: "Required",backgroundColor:Color.alertLightOrange,forgroundColor: .alertOrange  )
                        }
                        
                        if course.courseType.contains(where: { courseType in courseType.lowercased() == CourseType.Shared.rawValue.lowercased()}) {
                            TagView(image: "Shared",backgroundColor:Color.lightGreen,forgroundColor:  .darkGreen  )
                        }
                        //                        if courseType == .Shared || courseType == .Required {
                        //
                        //                            TagView(image: courseType == .Shared ? "Shared" : "Required", backgroundColor: courseType == .Shared ? Color.lightGreen : Color.alertLightOrange, forgroundColor: courseType == .Shared ? .darkGreen : .alertOrange)
                        //                        }
                    }
                    .padding([.horizontal, .top], 12)
                    Spacer()
                    
                    if courseType == .Shared {
                        // TODO: create a custom component
                        Button {
                            AmwayAppLogger.generalLogger.debug("Delete Button pressed")
                        } label: {
                            // TODO: Obsereve the changes
                            Image("CloseBlackIcon", bundle: AppConstants.bundle)
                                .resizable()
                                .frame(width: 12, height: 12)
                                .padding(8)
                                .background(Color.amwayWhite)
                                .clipShape(Circle())
                        }
                        .padding([.top, .trailing], 8)
                        .opacity(isFromMyCoursesView ? 0 : 1)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    ///
                    /// Course Title
                    Text(course.title)
                        .font(.getCustomFontWithSize(fontType: .gt_walsheim_medium, fontSize: .medium))
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(2)
                        .foregroundColor(.amwayBlack)
                    //.shimmering(active: isLoading)
                    
                    ///
                    /// Course Description
                    Text(course.description)
                        .font(.getCustomFontWithSize(fontType: .gt_walsheim_regular, fontSize: .regular))
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(lineLimit)
                        .foregroundColor(.darkGray)
                    if mediumCardWidth {
                        Spacer()
                    }
                }
                .frame(alignment: .top)
                .padding(.top, 12)
                
                Spacer()
                
                ///
                /// Bottom section
                HStack(spacing: 8) {
                    
                    HStack(spacing: 4) {
                        if !course.isCompleted {
                            
                            if course.progress == 0 {
                                Image("TimeIcon", bundle: AppConstants.bundle)
                                    .frame(width: 14, height: 14)
                                Text("\(course.duration)")
                                    .frame(height: 16)
                            } else {
                                // Show Progress Bar
                                CustomLabelWithImage(image: "LoadIcon", title: "\(String(course.duration)) \(StaticLabel.get("txtLeft"))")
                                    .padding(.trailing, 8)
                                
                                ProgressBar(value: $course.progress)
                                    .frame(height: 10)
                                    .padding(.trailing, 8)
                            }
                            
                            
                        } else {
                            Image("DoneIcon", bundle: AppConstants.bundle)
                                .resizable()
                                .frame(width: 24, height: 24)
                            
                            if course.isCertificateAvailable {
                                Image("CertificateIcon-Green", bundle: AppConstants.bundle)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                        }
                    }
                    .font(.getCustomFontWithSize(fontType: .gt_walsheim_medium, fontSize: .regular))
                    .foregroundColor(.darkPurple)
                    
                    Spacer()
                    HStack(spacing: 4) {
                        
                        if course.isFavorite {
                            Image("FavIcon", bundle: AppConstants.bundle)
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        
//                        if course.isDownloadAvailable  {
//                            Image("DownloadIcon", bundle: AppConstants.bundle)
//                                .resizable()
//                                .frame(width: 24, height: 24)
//                                .redacted(reason: isLoading ? .placeholder : [])
//                        }
                        
                        if !course.isCompleted && course.isCertificateAvailable  {
                            Image("CertificateIcon", bundle: AppConstants.bundle)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .redacted(reason: isLoading ? .placeholder : [])
                        }
                    }
                }
                .padding(.bottom, 16)
            }
            .padding(.horizontal, 16)
        }
        .frame(height: cardHeight ?? (mediumCardWidth ? AppConstants.cardHeightMd : AppConstants.cardHeightLg), alignment: .top)
        .background(Color.white)
        .cornerRadius(cornerRadius)
    }
}

struct CourseCardView_Previews: PreviewProvider {
    static var previews: some View {
        CourseCardView(course: .constant(CourseModel()), mediumCardWidth: true)
    }
}
