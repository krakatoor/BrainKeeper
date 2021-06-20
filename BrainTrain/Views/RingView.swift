//
//  RingView.swift
//  Design + code
//
//  Created by Камиль on 21.07.2020.
//  Copyright © 2020 Kamil. All rights reserved.
//

import SwiftUI

struct RingView: View {
    var width: CGFloat = 88
    var heihgt: CGFloat = 88
    @Binding var percent: Int
//    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        let multiplier = width / 44
        let progress = 1 - (percent / 100)
        return ZStack {
            Circle()
                .stroke(lineWidth: 10)
                .fill(Color.black.opacity(0.05))
                .frame(width: width, height: heihgt)

            Circle()
                .trim(from: CGFloat(progress) , to: 1) //заполнение круга
                .stroke(lineWidth: 10)
                .rotationEffect(Angle(degrees: 90))
                .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
                
               
            VStack {
                Text("Прогресс")
                    .font(.system(size: 5 * multiplier))
                Text("\(Int(percent))%")
                    .font(.system(size: 12 * multiplier))
                    .fontWeight(.bold)
            }
//                .onReceive(timer){ _ in
//                    if percent == 0 {
//                        timer.upstream.connect().cancel()
//                    } else {
//            percent -= 1
//        }
//                }
        }
        .frame(width: width, height: heihgt)
        
    }
}

struct RingView_Previews: PreviewProvider {
    static var previews: some View {
        RingView(percent: .constant(60))
    }
}
