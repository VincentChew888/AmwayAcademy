//
//  AppManager.swift
//  ABOAcademy
//
//  Created by Tahir Gani on 11/05/22.
//

import Foundation
import SwiftUI

class AppManager: ObservableObject {
    static var shared = AppManager()
    
    // Used for handling offine error and server down error
    @Published var noInternet = false
    @Published var serverDown = false
}
