//
//  UserModel.swift
//  
//
//  Created by Shrinivas Reddy on 06/06/22.
//

import Foundation

public struct UserModel  {

    var partyId: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var amwayId : String = ""
    var name : String = ""
    var countryCode : String = ""
    var showWelcomeVideo : Bool = false
    var role : String = ""
    var regionCode : String = ""
    var userFavoriteCourses : String = ""
    var userFavoriteLearningPaths : String = ""
    
    init (){
        
    }
    
    init(response : [String : Any]) {
        
        if let partyId = response["partyId"] as? String {
            self.partyId = partyId
        }
        
        if let firstName = response["firstName"] as? String {
            self.firstName = firstName
        }
        
        if let lastName = response["lastName"] as? String {
            self.lastName = lastName
        }
        
        if let amwayId = response["amwayId"] as? String {
            self.amwayId = amwayId
        }
        
        if let name = response["name"] as? String {
            self.name = name
        }

       if let countryCode = response["countryCode"] as? String {
           self.countryCode = countryCode
       }
       
       if let showWelcomeVideo = response["showWelcomeVideo"] as? Bool {
           self.showWelcomeVideo = showWelcomeVideo
       }
       
       if let role = response["role"] as? String {
           self.role = role
       }
       
       if let regionCode = response["regionCode"] as? String {
           self.regionCode = regionCode
       }
       
       if let userFavoriteCourses = response["userFavoriteCourses"] as? String {
           self.userFavoriteCourses = userFavoriteCourses
       }
       
       if let userFavoriteLearningPaths = response["userFavoriteLearningPaths"] as? String {
           self.userFavoriteLearningPaths = userFavoriteLearningPaths
       }
    }
}
