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
            Text("Отлично!".localized)
                .font(.title2)
                .bold()
            Text("Мы зафиксировали отправную точку.\nПредполагается, что в будние дни вы решаете тесты с простыми математическими примерами на сложение, вычитание, умножение  и деление, а в выходные даёте себе отдохнуть. Исследования показали, что такие тесты - один из лучших тренажеров мозга. Решение примеров на время снижает процесс старения мозга. У взрослых после месяца тренировки память улучшается на 12%, а у детей на 20%.\n\nЗапомните - вы соревнуетесь с собой. Сверяйте результаты разных недель и улучшайте их.".localized)
                .fixedSize(horizontal: false, vertical: true)
            
            
            Spacer()
       
            Text("Вы можете изменить уровень сложности в меню".localized)
                .font(.callout)
            .foregroundColor(.primary)
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
                Text("К тренировке".localized)
                    .mainButton()
            })
            .padding(.bottom)
        }
        .padding()
        .background()
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 0.5))
        .frame(width: screenSize.width - 40, height: screenSize.height - (small ? 80 : 120))
       
    }
}

struct MathTestCover_Previews: PreviewProvider {
    static var previews: some View {
        MathTestCover(showCover: .constant(false))
    }
}
