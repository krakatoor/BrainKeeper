//
//  ProgressCard.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 07.07.2021.
//

import SwiftUI

struct ProgressCard: View {
    @EnvironmentObject var viewModel: ViewModel
    var body: some View {
        VStack {
            if viewModel.day != 1 {
                HStack {
                    
                    Spacer()
                    
                    if viewModel.day < 60 {
                    RingView(width: 70, heihgt: 70, percent: CGFloat((viewModel.day * 100 / 60)))
                        .padding()
                }
                }
            }
            
            Spacer()
            
            if viewModel.weekChange {
                Text("Новая неделя!".localized)
                    .bold()
                    .font(.title)
                    .foregroundColor(.red)
            }
            
            Text("День".localized + " " + " \(viewModel.day)")
            .font(.system(size: 40, weight: .black, design: .serif))
            .foregroundColor(.primary)
           
            Spacer()
            Image("puzzle")
                .resizable()
                .scaledToFit()
        }
        .background(BlurView(style: .regular).cornerRadius(20).shadow(radius: 10))
        .frame(width: screenSize.width - 30, height: screenSize.height * 0.7)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 0.3))
        
    }
}


struct ProgressCard_Previews: PreviewProvider {
    static var previews: some View {
        ProgressCard()
            .environmentObject(ViewModel())
    }
}
