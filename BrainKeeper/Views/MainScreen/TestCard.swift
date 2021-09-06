//
//  TestCard.swift
//  BrainKeeper
//
//  Created by Камиль Сулейманов on 05.09.2021.
//

import SwiftUI

struct TestCard: View {
    @EnvironmentObject var viewModel: ViewModel
    let title: String
    let subTitle: String
    
    var body: some View {
        VStack (spacing: 5) {
            
            Text(subTitle == "" ? title + "\(viewModel.day)" : title)
                .font(.title2)
                .bold()
                .padding(.top, 20)
            
            HStack {
                Spacer()
                Text(subTitle)
                    .foregroundColor(.secondary)
                    .mainFont(size: 14)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
            .padding([.leading, .bottom])
            
            Spacer()
            
            if subTitle == "" {
                LottieView(name: "math", loopMode: .loop, animationSpeed: 0.8)
                    .frame(height: small ? 120 : 150)
            }
            
        }
        .frame(width: screenSize.width / 1.2, height: subTitle == "" ? screenSize.height * 0.25 : screenSize.height * 0.077)
        .foregroundColor(.primary)
        .padding()
        .padding(.vertical, small ? 0 : 15)
        .background(Color("back").cornerRadius(15))
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 0.5))
    }
}




struct TestCard_Previews: PreviewProvider {
    static var previews: some View {
        TestCard(title: "title", subTitle: "subTitle")
            .environmentObject(ViewModel())
    }
}
