//
//  WelcomeVideoModel.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 04/05/22.
//

import Foundation


struct WelcomeVideoModel {
    
    var title : String = ""
    var url : String = ""
    
    init() {}
   
    init(response : [String : Any]) {
       
        if let title = response["title"] as? String {
            self.title = title
        }
        
        if let url = response["url"] as? String {
            self.url = url
        }
        
        
    }
}
