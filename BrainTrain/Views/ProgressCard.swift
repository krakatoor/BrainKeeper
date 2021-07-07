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
                Spacer()
                
                Text("День \(viewModel.day)")
                    .font(.system(size: 40, weight: .black, design: .serif))
                    .foregroundColor(.primary)
                    .transition(.scale)
                
                
                Spacer()
                Image("puzzle")
                    .resizable()
                    .scaledToFit()
            }
            .background(BlurView(style: .regular).cornerRadius(20).shadow(radius: 10))
            .frame(width: screenSize.width - 50, height: screenSize.height * 0.5)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 0.3))
        
    }
}


struct ProgressCard_Previews: PreviewProvider {
    static var previews: some View {
        ProgressCard()
    }
}
