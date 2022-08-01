//
//  StaticLabelModel.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 01/04/22.
//

import Foundation


struct StaticLabelModel {
    
    var id : Int = -1
    var key : String = ""
    var translation : String = ""
    
    init() {}
    
    init(response : [String : Any]) {
        
        if let id = response["id"] as? Int {
            self.id = id
        }
        
        if let key = response["key"] as? String {
            self.key = key
        }
        
        if let translation = response["translation"] as? String {
            self.translation = translation
        }
        
    }
}

class StaticLabel {
    static func get(_ key: String) -> String {
        return DashboardViewModel.shared.getStaticLabelValue(forkey: key)
    }
}
