//
//  ShowViewWithErrorHandling.swift
//  ABOAcademy
//
//  Created by Tahir Gani on 11/05/22.
//

import SwiftUI
import Shimmer

struct ShowViewWithErrorHandling<Content: View>: View {
    let mainView: Content
    var offlineTxt = StaticLabel.get("txtOffline") == "" ? "You appear to be offline. Please check your connection and try again." : StaticLabel.get("txtOffline")
    var reconnectTxt = StaticLabel.get("txtReconnect") == "" ? "Reconnect" : StaticLabel.get("txtReconnect")
    var serverDownTxt = StaticLabel.get("txtServerDown") == "" ? "Academy is currently unavailable due to ongoing maintenance. We apologize for any inconvenience. Please try again later. " : StaticLabel.get("txtServerDown")
    var reloadTxt = StaticLabel.get("txtReload") == "" ? "Reload" : StaticLabel.get("txtReload")
    var onReloadButtonClick: (()->Void)
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 0) {
                if AppManager.shared.noInternet {
                    ErrorStateView(imageName: "NoInternet", title: offlineTxt, fullHeight: true, btnTitle: reconnectTxt) {
                        onReloadButtonClick()
                    }
                    .padding(.vertical, 45)
                    .redacted(reason: DashboardViewModel.shared.getStaticLabelAPIStatus == .Loading ? .placeholder : [])
                    .shimmering(active: DashboardViewModel.shared.getStaticLabelAPIStatus == .Loading)
                } else if AppManager.shared.serverDown {
                    ErrorStateView(imageName: "ServerDown", title: serverDownTxt, fullHeight: true, btnTitle: reloadTxt) {
                        // Server sown state should first become false and then if any api gets server error then it will be  set again.
                        AppManager.shared.serverDown = false
                        onReloadButtonClick()
                    }
                    .padding(.vertical, 45)
                    .redacted(reason: DashboardViewModel.shared.getStaticLabelAPIStatus == .Loading ? .placeholder : [])
                    .shimmering(active: DashboardViewModel.shared.getStaticLabelAPIStatus == .Loading)
                } else {
                    mainView
                }
              
            }
            .frame(height: proxy.size.height+proxy.safeAreaInsets.top)
            .background(Color.lightGray)
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.top)
        }
    }
}

struct ShowViewWithErrorHandling_Previews: PreviewProvider {
    static var previews: some View {
        ShowViewWithErrorHandling(mainView: VStack{}, onReloadButtonClick: {})
    }
}
