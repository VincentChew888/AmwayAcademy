//
//  ShareRepresentable.swift
//  ABOAcademy
//
//  Created by Tahir Gani on 25/03/22.
//

import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
}

struct ShareSheetView: View {
    var items: [Any]
    
    var body: some View {
        ShareSheet(items: items)
    }
}
