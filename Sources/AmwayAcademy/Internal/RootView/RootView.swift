//
//  RootView.swift
//  ABOAcademy
//
//  Created by Swapnil Tilkari on 27/04/22.
//

import SwiftUI
import CommonInteractions

public struct RootView: View {
    // var data : RootModel
    // var renewAccessToken : (() -> Void)?
    @StateObject var rootData = RootViewModel.shared
    
    @State private var isLoaded: Bool = false
    @State private var dashboardTitle: String = "學習"
    
    //var profileAction : (() -> Void)?
    // var exploreAction : (() -> Void)?
    var creatorAction : CreatorsAction
    var env : String
    public init(action: CreatorsAction,env:String) {
        self.creatorAction = action
        self.env = env
    }
    
    public var body: some View {
        ShowViewWithErrorHandling(mainView: mainView) {
            getData()
        }
    }
    
    var mainView: some View {
        
        VStack {
            if isLoaded {
                DashboardView(leftBarAction: {
                    AmwayAppLogger.generalLogger.debug("Profile action Performed.")
                    creatorAction.action(.showProfile({
                        
                    }))
                }, rightBarAction: {
                    //             if let rightBarAction = exploreAction {
                    //                 rightBarAction()
                    //             }
                })
            } else {
                //SHOW SHIMMER EFFECT
                DashboardLoadingView(title: dashboardTitle)
            }
        }
        
        .onAppear {
            //                rootData.data = data
            getData()
            //print("Access token JWT",amwayABOIdentity.partyId)
        }
        .onChange(of: rootData.data.isLogOut ) { newValue in
            if rootData.data.isLogOut {
                rootData.data.isLogOut = false
            }
        }
    }
    
    
    func getData() {
        rootData.creatorAction = self.creatorAction
        
        self.creatorAction.action(.aboIdentity({ result in
            switch result {
            case .success(let amwayABOIdentity) :
                
                DispatchQueue.main.async{
                    //put your code here


                    AmwayAppLogger.generalLogger.debug("env : \(env)")
                    if amwayABOIdentity.partyId != RootViewModel.shared.data.partyID {
                        
                        RootViewModel.shared.isDifferentPartyIDVal = true
                        let data =  RootModel(aboNumber: amwayABOIdentity.aboNumber, partyID: amwayABOIdentity.partyId, accessToken: amwayABOIdentity.accessToken, name: amwayABOIdentity.name, email: "", locale: "zh",env:env)

                        AmwayAppLogger.generalLogger.debug(amwayABOIdentity.accessToken)
                        rootData.data = data
                        
                        if data.locale == "zh" {
                            dashboardTitle = "學習"
                        } else if data.locale == "en-us" {
                            dashboardTitle = "ABO Academy"
                        }
                        
                        DashboardViewModel.shared.getStaticLabelData(lang: AppConstants.defaultLocale)
                        
                        rootData.createUser(rootModel: rootData.data) {
                            AmwayAppLogger.generalLogger.debug("User Created")
                            isLoaded = true
                        }
                        
                    }else{
                        RootViewModel.shared.isDifferentPartyIDVal = false
                        isLoaded = true
                    }
                }
            case .failure(let error) :
                AmwayAppLogger.generalLogger.debug(error.localizedDescription)
                
                let statusCode = error.asAFError?.responseCode
                if statusCode != nil && statusCode! >= 500 && statusCode! < 600 {
                    AppManager.shared.serverDown = true
                }
            }
        }))
    }
}

