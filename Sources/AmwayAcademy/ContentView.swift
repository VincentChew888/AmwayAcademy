//
//  ContentView.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 21/12/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
//        RootView(data: RootModel(aboNumber: 0, partyID: 0, accessToken: "abcd", name: "Swapnil", email: "swapnil@test.com")) {
//            print("success")
//        }
        DashboardView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
