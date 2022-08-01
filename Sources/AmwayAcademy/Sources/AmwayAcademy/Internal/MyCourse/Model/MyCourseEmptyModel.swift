//
//  MyCourseEmptyModel.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 01/03/22.
//

import Foundation


class MyCourseEmptyModel: ObservableObject  {
    
    //Optional Values
    var id : Int = 0
    var courseImageURL: String = ""
    var courseTitle: String = ""
    var courseDescription: String = ""
    var courseType: String = ""
    var coursesButtonTitle: String = ""
    
    init() {}
    
    // Getting data from response
    init(response : [String : Any]) {
        
        if let id = response["id"] as? Int {
            self.id = id
        }
        
        if let courseImageURL = response["courseImageURL"] as? String {
            self.courseImageURL = courseImageURL
        }
        
        if let courseTitle = response["courseTitle"] as? String {
            self.courseTitle = courseTitle
        }
        
        if let courseDescription = response["courseDescription"] as? String {
            self.courseDescription = courseDescription
        }
        
        if let coursesType = response["courseType"] as? String {
            self.courseType = coursesType
        }
        
        if let coursesButtonTitle = response["coursesButtonTitle"] as? String {
            self.coursesButtonTitle = coursesButtonTitle
        }
        
    }
    
    
}
