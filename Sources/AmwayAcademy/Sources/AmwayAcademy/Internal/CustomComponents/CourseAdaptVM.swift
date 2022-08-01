//
//  CourseAdaptVM.swift
//  
//
//  Created by Tahir Gani on 27/06/22.
//

import Foundation
import SwiftUI

class CourseAdaptVM: ObservableObject {
    static var shared = CourseAdaptVM()
    
    @Published var otherUrlRequest: URLRequest?
}
