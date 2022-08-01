//
//  LangModel.swift
//  ABOAcademy
//
//  Created by Swapnil Tilkari on 30/03/22.
//

import Foundation

struct LangModel: Equatable,Hashable {
    
    var id : Int = -1
    var language : String = ""
    var langCode : String = AppConstants.defaultLocale
    
    init() {}
    
    init(response : [String : Any]) {
        
        if let id = response["id"] as? Int {
            self.id = id
        }
        
        if let language = response["langName"] as? String {
            self.language = language
        }
        
        if let lang_code = response["langCode"] as? String {
            self.langCode = lang_code
        }
        
    }
}
