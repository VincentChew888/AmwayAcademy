//
//  MyLabel.swift
//  
//
//  Created by Tahir Gani on 07/06/22.
//

import SwiftUI

struct MyLabel: View {
    var title: String
    var image: String
    
    init(_ title: String, image: String) {
        self.title = title
        self.image = image
    }
    
    var body: some View {
        HStack {
            Text("\(title)")
            Image(image, bundle: AppConstants.bundle)
        }
    }
}

//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyLabel()
//    }
//}
