//
//  SnapCarousel.swift
//  ABOAcademy
//
//  Created by Tahir Gani on 25/05/22.
//

import SwiftUI

struct SnapCarousel<Content: View, T: Identifiable>: View {
    var content: (T) -> Content
    @Binding var list: [T]
    
    var spacing: CGFloat
    var trailingSpace: CGFloat
    @Binding var index: Int
    @Binding var currentIndex: Int
    var thresholdVal: CGFloat = 0.2
    
    init(spacing: CGFloat = 16, trailingSpacing: CGFloat = 32, index: Binding<Int>, currentIndex: Binding<Int>,items: Binding<[T]>, @ViewBuilder content: @escaping (T)->Content) {
        self._list = items
        self.spacing = spacing
        self.trailingSpace = trailingSpacing
        self._index = index
        self._currentIndex = currentIndex
        self.content = content
    }
    
    @GestureState var offset: CGFloat = 0
    
    var body: some View {
        
        GeometryReader { proxy in
            
            let width = proxy.size.width - (trailingSpace - spacing)
            let adjustmentWidth = (trailingSpace / 2) - spacing
            
            HStack(spacing: spacing) {
                ForEach(list) {item in
                    
                    content(item)
                        .frame(width: proxy.size.width - trailingSpace)
                }
            }
            .padding(.horizontal, spacing)
            .offset(x: (CGFloat(currentIndex) * -width) + (adjustmentWidth) + offset)
            .gesture(
                DragGesture()
                    .updating($offset, body: { value, out, _ in
                        out = value.translation.width
                    })
                    .onEnded({ value in
                        let offsetX = value.translation.width
                        let progress = -offsetX / width
                        var roundIndex = progress
                        if roundIndex <= -thresholdVal && roundIndex < 0 {
                            roundIndex = -1
                        } else if roundIndex >= thresholdVal && roundIndex > 0 {
                            roundIndex = 1
                        } else {
                            roundIndex = 0
                        }
                        currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                        currentIndex = index
                    })
                    .onChanged({ value in
                        let offsetX = value.translation.width
                        let progress = -offsetX / width
                        var roundIndex = progress
                        if roundIndex <= -thresholdVal && roundIndex < 0 {
                            roundIndex = -1
                        } else if roundIndex >= thresholdVal && roundIndex > 0 {
                            roundIndex = 1
                        } else {
                            roundIndex = 0
                        }
                        AmwayAppLogger.generalLogger.debug("P  \(progress)")
                        AmwayAppLogger.generalLogger.debug("R \(roundIndex)")
                        index = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                    })
            )
        }
        .animation(.easeInOut, value: offset == 0)
    }
}

//struct SnapCarousel_Previews: PreviewProvider {
//    static var previews: some View {
//        SnapCarousel()
//    }
//}
