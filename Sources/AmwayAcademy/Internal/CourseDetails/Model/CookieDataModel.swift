//
//  CookieDataModel.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 05/05/22.
//

import Foundation


struct CookieDataModel {
    
    var domain : String = ""
    var lrsDomain : String = ""
    var courseUrl : String = ""
    var cloudFrontPolicy : String = ""
    var cloudFrontKeyPairId : String = ""
    var cloudFrontSignature : String = ""
    var lrsCloudFrontPolicy : String = ""
    var lrsCloudFrontKeyPairId : String = ""
    var lrsCloudFrontSignature : String = ""

    var didFinishLoading: Bool = false

    init() {}
    
    init(response : [String : Any]) {
        
        if let domain = response["domain"] as? String {
            self.domain = domain
        }
        
        
        
        if let lrsDomain = response["lrsDomain"] as? String {
            self.lrsDomain = lrsDomain
        }
        
        if let courseUrl = response["courseUrl"] as? String {
          //  let val = #"{"name":["Vaibhav Mahajan"],"mbox":["mailto:vaibhav.mahajan@amway.com"]}"#
            self.courseUrl = courseUrl 
        }
        
        if let cloudFrontPolicy = response["cloudFrontPolicy"] as? String {
            self.cloudFrontPolicy = cloudFrontPolicy
        }
        
        if let cloudFrontKeyPairId = response["cloudFrontKeyPairId"] as? String {
            self.cloudFrontKeyPairId = cloudFrontKeyPairId
        }
        
        if let cloudFrontSignature = response["cloudFrontSignature"] as? String {
            self.cloudFrontSignature = cloudFrontSignature
        }
        
        if let lrsCloudFrontPolicy = response["lrsCloudFrontPolicy"] as? String {
            self.lrsCloudFrontPolicy = lrsCloudFrontPolicy
        }
        
        if let lrsCloudFrontKeyPairId = response["lrsCloudFrontKeyPairId"] as? String {
            self.lrsCloudFrontKeyPairId = lrsCloudFrontKeyPairId
        }
        
        if let lrsCloudFrontSignature = response["lrsCloudFrontSignature"] as? String {
            self.lrsCloudFrontSignature = lrsCloudFrontSignature
        }
    }
}
