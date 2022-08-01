//
//  LangViewModel.swift
//  ABOAcademy
//
//  Created by Swapnil Tilkari on 02/03/22.
//

import Foundation
import Amway_Base_Utility
class LangViewModel : ObservableObject {

//var LangArr = ["English","Chinese"]
@Published var selectedLang : LangModel = LangModel()
@Published var LangArr : [LangModel] = []
@Published var FetchLangAPIStatus : APIState = .none
    
static var shared = LangViewModel()
    
private init(){
   // fetchLangData()
    }
    func fetchLangData(locale: String,  success: @escaping () -> ()) {
        self.FetchLangAPIStatus = .Loading
        var param : [String:Any] = [:]
        param.updateValue(locale, forKey: "locale")
        WebServiceManager.shared.sendRequest(serviceType: .fetchLanguage, params: param) { result in
            AmwayAppLogger.generalLogger.debug(String(describing: result))
            self.LangArr.removeAll()
            
            if let responseDict = result as? [String : Any] {
                if let langDetails = responseDict["data"] as? [String: Any] {
                    if let langArr = langDetails["languages"] as? [[String: Any]] {
                        for item in langArr {
                            self.LangArr.append(LangModel(response: item))
                        }
                    }
                }
            }
            self.FetchLangAPIStatus = .success
            success()
            AppManager.shared.noInternet = false
        } failure: { failurError in
            
            self.FetchLangAPIStatus = .failure(.ApiError)
        } offline: { offline in
            self.FetchLangAPIStatus = .failure(.Offline)
            AppManager.shared.noInternet = true
        }
    }
    func getlangData() {
        
        let tempData = AppConstants.bundle
        if let filterData = tempData.url(forResource: "Lang", withExtension: "json") {
            do {
                let data = try Data(contentsOf: filterData, options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any]
                
                if let filters = jsonResult!["lang"] as? [[String: Any]] {
                    for item in filters {
                        let lang = LangModel(response: item)
                        self.LangArr.append(lang)
                    }
                }
            }
            catch {
                
            }
        }
    }

}
