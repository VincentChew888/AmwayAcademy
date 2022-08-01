//
//  DotLoadingAnimation.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 07/04/22.
//

import SwiftUI

struct DotLoadingAnimation: View {
    @State var delay: Double = 0 // 1.
    @State var scale: CGFloat = 0.2
    var body: some View {
        Circle()
            .frame(width: 3, height: 3)
            .scaleEffect(scale)
            .animation(Animation.easeInOut(duration: 0.6).repeatForever().delay(delay), value: self.scale)
            .onAppear {
                withAnimation {
                    self.scale = 1
                }
            }
    }
}

struct DotLoadingAnimation_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            DotLoadingAnimation() // 1.
            DotLoadingAnimation(delay: 0.2) // 2.
            DotLoadingAnimation(delay: 0.4) // 3.
                }
    }
}
