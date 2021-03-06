//
//  RingView.swift
//  Design + code
//
//  Created by Камиль on 21.07.2020.
//  Copyright © 2020 Kamil. All rights reserved.
//

import SwiftUI

struct RingView: View {
    var width: CGFloat = 50
    var heihgt: CGFloat = 50
    var percent: CGFloat
    @State private var startAnimation = false
    
    var body: some View {
        let multiplier = width / 44
        let progress =  1 - (percent / 100)
        return ZStack {
            Circle()
                .stroke(lineWidth: 10)
                .fill(Color.primary.opacity(0.05))
                .frame(width: width, height: heihgt)

            Circle()
                .trim(from: !startAnimation ? 1 :  progress, to: 60) 
                .stroke(lineWidth: 10)
                .rotationEffect(Angle(degrees: 90))
                .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
                
               
            VStack {
                Text("Прогресс".localized)
                    .font(.system(size: 5 * multiplier))
                    .font(.system(size: 12 * multiplier))
                    .fontWeight(.bold)
                
                Text("\(Int(percent))%")
                    .font(.system(size: 7 * multiplier))
                    .font(.system(size: 14 * multiplier))
            }

        }
        .frame(width: width, height: heihgt)
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation (.linear(duration: 0.4)) {
                startAnimation = true
                }
            }
        }
        
    }
}

struct RingView_Previews: PreviewProvider {
    static var previews: some View {
        RingView(percent: 60)
    }
}
