//
//  RootModel.swift
//  ABOAcademy
//
//  Created by Swapnil Tilkari on 27/04/22.
//

import Swift
import SwiftUI
import CommonInteractions

public struct RootModel  {
    
    var aboNumber : String = ""
    var partyID : String = ""
    var accessToken : String = ""
    var name : String = ""
    var email : String = ""
    var locale : String = ""
    var env : String = ""
    var isRenewToken : Bool = false
    var showProfile : Bool = false
    var isLogOut : Bool = false
    
    init (){
        
    }
    
    public init(aboNumber: String? , partyID: String?,accessToken: String?,name:String?,email:String?, locale:String?,env: String?) {
        
        if let aboNumber = aboNumber {
            self.aboNumber = aboNumber
        }
        
        if let env = env {
            self.env = env
        }
        
        if let partyID = partyID {
            self.partyID = partyID
        }
        
        if let accessToken = accessToken {
            self.accessToken = accessToken
        }
        
        if let name = name  {
            self.name = name
        }
        
        if let email = email  {
            self.email = email
        }

       if let email = email  {
           self.email = email
       }
       
       if let locale = locale  {
           self.locale = locale
       }
    }
}
