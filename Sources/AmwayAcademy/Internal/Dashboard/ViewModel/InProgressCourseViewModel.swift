//
//  InProgressCourseViewModel.swift
//  ABOAcademy
//
//  Created by Tahir Gani on 09/04/22.
//

import Foundation

class InProgressCourseViewModel: ObservableObject {
    static let shared = InProgressCourseViewModel()
    
    @Published var courses: [CourseModel] = [
        CourseModel(), CourseModel(), CourseModel()
    ]
}
