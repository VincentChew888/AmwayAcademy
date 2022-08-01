//
//  RootViewModel.swift
//  ABOAcademy
//
//  Created by Swapnil Tilkari on 27/04/22.
//

import Foundation
import CommonInteractions

class RootViewModel : ObservableObject {
    
    @Published var createUserAPIStatus : APIState = .none
    @Published var creatorAction : CreatorsAction?

    static var shared = RootViewModel()

    private init(){
        //AlamofireManager.shared.delegate = self
    }
    
    @Published var data : RootModel = RootModel()
    @Published var userDetails : UserModel = UserModel()
    @Published var isDifferentPartyIDVal : Bool =  false
   // @Published func renewToken()
    func renewToken() {
        data.isRenewToken = true
    }
    
    func getLocale() -> String {
        return data.locale
    }
    
    func isDifferentPartyID() -> Bool {
        return isDifferentPartyIDVal
    }
}

extension RootViewModel {
    
    func createUser(rootModel: RootModel, success: @escaping () -> Void) {
        
        var params : [String:Any] = [:]
       
        params.updateValue(rootModel.name, forKey: "name")
        params.updateValue(rootModel.partyID, forKey: "partyId")
        
        self.createUserAPIStatus = .Loading

        WebServiceManager.shared.sendRequest(serviceType: .createUser, params: params) { result in
            
            if let responseDict = result as? [String : Any] {
                if let userDetails = responseDict["data"] as? [String: Any] {
                    self.userDetails = UserModel(response: userDetails)
                }
            }
            AppManager.shared.noInternet = false
            self.createUserAPIStatus = .success
            success()
        } failure: { failurError in
            
            AppManager.shared.noInternet = false
            self.createUserAPIStatus = .failure(.ApiError)
        } offline: { offline in
            
            self.createUserAPIStatus = .failure(.Offline)
            AppManager.shared.noInternet = true
        }
    }
}
