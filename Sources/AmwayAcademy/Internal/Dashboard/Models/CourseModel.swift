
/*
 *
 * FileName: Data.swift
 * CreatedOn: Friday, March 25th 2022
 * CreatedBy: Maverick's Parser
 * Ready to Use. Pass dictionary response to ParentModel init(response: [String : Any]) to configure all the sub-Models.
 *
 */

import Foundation


enum CourseStatus : String, CaseIterable {
    case live = "live"
    case offline = "offline"
    case archived = "archived"
}

struct CourseSkill: Decodable {
    var id: String = ""
    var title: String = ""
    
    init(){}
    init(_ id: String, _ title: String) {
        self.id = id
        self.title = title
    }
}

struct CourseModel: Identifiable, Hashable {
    static func == (lhs: CourseModel, rhs: CourseModel) -> Bool {
        return lhs.id == rhs.id && lhs.courseId == rhs.courseId
    }
    
    static func != (lhs: CourseModel, rhs: CourseModel) -> Bool {
        return lhs.id != rhs.id || lhs.courseId != rhs.courseId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(courseId)
        hasher.combine(id)
    }
    
    var id: UUID = UUID()
    var courseId : String = ""
    var title : String = ""
    var description : String = ""
    var thumbnail : String = ""
    var bannerImage : String = ""
    var progress : Int = 0
    var duration : String = ""
    var courseType : [String] = []
    var isCertificateAvailable : Bool = false
    var isFavorite : Bool = false
    var isDownloadAvailable : Bool = false
    var isCompleted : Bool = false
    var completionDate : String = ""
    var courseUrl : String = ""
    var isMultilingual : Bool = false
    var skills : [CourseSkill] = []
    var isNew: Bool = false
    var speaker: String = ""
    var categoryId: String = ""
    var isLive: Bool = false
    var isOffline: Bool = false
    var isArchived: Bool = false

    init() {}
    
   mutating func setFav() {
        self.isFavorite.toggle()
    }
    
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
            self.duration = String(duration)+StaticLabel.get("txtMinute")
        }
        
        if let courseType = response["courseType"] as? [String] {
            self.courseType = courseType
        }
        
        if let isCertificateAvailable = response["isCertificateAvailable"] as? Bool {
            self.isCertificateAvailable = isCertificateAvailable
        }
        
        if let bannerImage = response["bannerImage"] as? String {
            self.bannerImage = bannerImage
        }
        
        if let isFavorite = response["isFavorite"] as? Bool {
            self.isFavorite = isFavorite
        }
        
        if let isNew = response["isNew"] as? Bool {
            self.isNew = isNew
        }
        
        if let isDownloadAvailable = response["isDownloadAvailable"] as? Bool {
            self.isDownloadAvailable = isDownloadAvailable
        }
        
        if let isCompleted = response["isCompleted"] as? Bool {
            self.isCompleted = isCompleted
        }
        
        if let completionDate = response["completionDate"] as? String {
            self.completionDate = completionDate
        }
        
        if let courseUrl = response["courseUrl"] as? String {
            self.courseUrl = courseUrl
        }
        
        if let isMultilingual = response["isMultilingual"] as? Bool {
            self.isMultilingual = isMultilingual
        }
        
        if let skills = response["skills"] as? [AnyObject] {
            for skill in skills {
                if let id = skill["id"] as? String, let title = skill["title"] as? String {
                    self.skills.append(CourseSkill(id, title))
                }
            }
        }
        
        if let speaker = response["speaker"] as? String {
            self.speaker = speaker
        }
        
        if let categoryId = response["categoryId"] as? String {
            self.categoryId = categoryId
        }
        
        if let isLive = response["isLive"] as? Bool {
            self.isLive = isLive
        }
        
        if let isOffline = response["isOffline"] as? Bool {
            self.isOffline = isOffline
        }
        
        if let isArchived = response["isArchived"] as? Bool {
            self.isArchived = isArchived
        }

    }
}
