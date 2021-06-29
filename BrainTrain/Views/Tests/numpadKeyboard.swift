//
//  numpadKeyboard.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 30.06.2021.
//

import SwiftUI

struct numpadKeyboard: View {
   
    var body: some View {
        VStack (spacing: 1){
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 1, alignment: .center), count: 3), alignment: .center, spacing: 1, content: {
                ForEach(1...9, id: \.self) {
                    Text($0.description)
                        .padding()
                        .frame(width: 100)
                        .background()
                        .shadow(radius: 3)
                }
            })
            .padding(.horizontal, 40)
                
            HStack{
                Spacer()
                Text("0")
                    .padding()
                    .frame(width: 100)
                    .background()
                    .shadow(radius: 3)
                Spacer()
            }
            
        }
    }
}

struct numpadKeyboard_Previews: PreviewProvider {
    static var previews: some View {
        numpadKeyboard()
    }
}
