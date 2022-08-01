
/*
 *
 * FileName: Syllabus.swift
 * CreatedOn: Thursday, March 3rd 2022
 * CreatedBy: Maverick's Parser
 * Ready to Use. Pass dictionary response to ParentModel init(response: [String : Any]) to configure all the sub-Models.
 *
 */

import Foundation 


struct SyllabusModel {
    
    var header : String = ""
    var syllabusData : [SyllabusData] = []
    var showSection : Bool = false
    
    init() {}
    
    init(response : [String : Any]) {
        
        if let header = response["header"] as? String {
            self.header = header
        }
        
        if let syllabusData = response["syllabusData"] as? [[String : Any]] {
            for item in syllabusData {
                let object = SyllabusData( response: item)
                self.syllabusData.append(object)
            }
        }
        
        if let showSection = response["showSection"] as? Bool {
            self.showSection = showSection
        }
        
    }
}
