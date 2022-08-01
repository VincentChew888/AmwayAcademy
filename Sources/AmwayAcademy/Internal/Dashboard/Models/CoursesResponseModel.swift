//
//  CoursesResponseModel.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 24/03/22.
//

import Foundation

class CoursesResponseModel: ObservableObject {
    
    var status : String = ""
    var message : String = ""
    var data : [CourseModel] = []
    
    init() {}
    
    init(response : [String : Any]) {
        
        if let status = response["status"] as? String {
            self.status = status
        }
        
        if let message = response["message"] as? String {
            self.message = message
        }
        
        if let data = response["data"] as? [[String : Any]] {
            for item in data {
                let object = CourseModel( response: item)
                self.data.append(object)
            }
        }
        
    }
}

struct CourseDetails {
    
    var courseId : String = ""
    var title : String = ""
    var description : String = ""
    var thumbnail : String = ""
    var progress : Int = 0
    var duration : Int = 0
    var course_type : [String] = []
    var isCertificateAvailable : Bool = false
    var isFavorite : Bool = false
    var isDownloadAvailable : Bool = false
    
    init() {}
    
    init(response : [String : Any]) {
        
        if let courseId = response["courseId"] as? String {
            self.courseId = courseId
        }
        
        if let title = response["title"] as? String {
            self.title = title
        }
        
        if let description = response["description"] as? String {
            self.description = description
        }
        
        if let thumbnail = response["thumbnail"] as? String {
            self.thumbnail = thumbnail
        }
        
        if let progress = response["progress"] as? Int {
            self.progress = progress
        }
        
        if let duration = response["duration"] as? Int {
            self.duration = duration
        }
        
        if let course_type = response["course_type"] as? [String] {
            for item in course_type {
                self.course_type.append(item)
            }
        }
        
        if let isCertificateAvailable = response["isCertificateAvailable"] as? Bool {
            self.isCertificateAvailable = isCertificateAvailable
        }
        
        if let isFavorite = response["isFavorite"] as? Bool {
            self.isFavorite = isFavorite
        }
        
        if let isDownloadAvailable = response["isDownloadAvailable"] as? Bool {
            self.isDownloadAvailable = isDownloadAvailable
        }
        
    }
}
