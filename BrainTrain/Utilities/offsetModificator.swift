//
//  OffsetModificator.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 23.06.2021.
//

import SwiftUI

struct offsetModificator: ViewModifier {
    var anchorPoint: Anchor = .top
    @Binding var offset: CGFloat
    func body (content: Content) -> some View {
       content
        .overlay(
            
            GeometryReader { proxy  -> Color in
                let frame = proxy.frame(in: .global)
                
                DispatchQueue.main.async {
                    
                    switch anchorPoint {
                    
                    case .top:
                        offset = frame.minY
                    case .trailing:
                        offset = frame.maxX
                    case .leading:
                        offset = frame.minX
                    case .bottom:
                        offset = frame.maxY
                    }
                }
                return Color.clear
            }
        )
    }
}

enum Anchor {
    case top, trailing, leading, bottom
}



//@State private var offset: CGFloat = .zero
//
//.rotation3DEffect(
//    .degrees(Double(getProgress()) * 90),
//    axis: (x: 0.0, y: 1.0, z: 0.0),
//    anchor: offset > 0 ? .leading : .trailing,
//    anchorZ: 0.0,
//    perspective: 0.6
//)
//.modifier(offsetModificator(anchorPoint: .leading, offset: $offset))
//
//
//func getProgress() -> CGFloat {
//    let progress = offset / UIScreen.main.bounds.width
//    return progress
//}
