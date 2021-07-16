//
//  MathTestCover.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 01.07.2021.
//

import SwiftUI

struct MathTestCover: View {
    @Binding var showCover: Bool
    var body: some View {
        VStack (spacing: 10){
            Text("Отлично!")
                .font(.title2)
                .bold()
            Text("Мы зафиксировали отправную точку.\nВ последующие 5 дней вы будете решать простые математические примеры на сложение, вычитание, умножение  и деление. Как показали исследования решение подобных примеров один из лучших тренажеров мозга. Решение примеров на время снижает процесс старения мозга. У всех испытыемых отмечено улучшение памяти: у взрослых после месяца тренировки память улучшается на 12%, а у детей на 20%.\n\nЗапомните - вы соревнуетесь с собой. Сверяйте результаты разных недель. Улучшайте их. У вас все получится!")
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
            
            Image("thinkingBrain")
                .resizable()
                .scaledToFit()
            
            Button(action: {
                withAnimation{
                    showCover = false
                }
                
            }, label: {
                Text("К тренировке")
                    .mainButton()
            })

        }
        .padding()
        .background(BlurView(style: .regular).cornerRadius(15).shadow(radius: 5))
        .frame(width: screenSize.width - 40, height: screenSize.height - 140)
        .padding(.bottom)
    }
}

struct MathTestCover_Previews: PreviewProvider {
    static var previews: some View {
        MathTestCover(showCover: .constant(false))
    }
}
