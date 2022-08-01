//
//  CourseAdaptModel.swift
//  ABOAcademy
//
//  Created by Swapnil Tilkari on 25/03/22.
//

import Foundation


class CourseAdaptModel: ObservableObject {
    
    @Published var link: String
    @Published var headerName: String = ""
    @Published var outPutName: String = ""
    @Published var didFinishLoading: Bool = false

    init (link: String, headerName: String) {
        self.link = link
        self.headerName = headerName
    }
}
