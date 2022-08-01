//
//  ConnectivityManager.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 17/05/22.
//

import Foundation
import Alamofire

class ConnectivityManager {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
