//
//  AnalyticalEventManager.swift
//  
//
//  Created by Shrinivas Reddy on 07/06/22.
//

import Foundation
import CommonInteractions

struct CourseEventInfo {
    
    let name: String
    let courseID: String
    let courseName: String
    let requiredCourse: Bool
}

struct FilterEventInfo {
    
    let name: String
    let categories: [String]
    let skills: [String]
    let keywords: [String]
}

struct GenericEventInfo {
    
    var name: String
}

extension CourseEventInfo: AnalyticsEvent {
    func encode() -> Metadata {
        // Custom logic of converting the native type
        // to `Metadata` goes here

         let convertedPayload: Metadata = [
            "name": self.name,
            "courseID": self.courseID,
            "courseName" : self.courseName,
            "requiredCourse" : self.requiredCourse
        ]

        return convertedPayload
    }
}

extension FilterEventInfo: AnalyticsEvent {
    func encode() -> Metadata {
        // Custom logic of converting the native type
        // to `Metadata` goes here

        let convertedPayload: Metadata = [
           "name": self.name,
           "categories": self.categories,
           "skills" : self.skills,
           "keywords" : self.keywords
       ]

        return convertedPayload
    }
}

extension GenericEventInfo: AnalyticsEvent {
    func encode() -> Metadata {
        // Custom logic of converting the native type
        // to `Metadata` goes here

         let convertedPayload: Metadata = [
            "name": self.name
        ]

        return convertedPayload
    }
}
