//
//  Stroop.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 29.06.2021.
//

import SwiftUI

struct StroopTestPreparing: View {
    let colors = [Color(#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)),Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)),Color(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)),Color(#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)),Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))]
    let colorsName = ["Синий".localized,"Красный".localized,"Зелёный".localized,"Жёлтый".localized, "Серый".localized]
    
    var body: some View {
        VStack  {
            Text("Тест Струпа".localized)
                .font(.title2)
                .bold()
            
            HStack  {
                Spacer()

            Text("Перед началом тестирования пройдите подготовку к нему.".localized)
                .mainFont(size: 20)
                .padding(.top, small ? 5 : 10)
                
                Spacer()

            }
            HStack  {
            
                Text("Называйте в слух цвет слов, делая это как можно быстрее. Будьте внимательней вы должны не читать слова, а называть их цвет. Если ошиблись, назовите цвет еще раз.".localized)
                .mainFont(size: 18)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, small ? 5 : 10)
                
                Spacer()

            }
            
            HStack {
                Text("(Пример: если написано".localized)
                    .mainFont(size: 18)
                Text("Красный,")
                    .foregroundColor(.blue)
                    .mainFont(size: 18)
                Spacer()
            }
            .fixedSize(horizontal: false, vertical: true)
            
            HStack {
                Text("говорите Синий.)".localized)
                    .mainFont(size: 18)
                Spacer()
            }
            
            VStack (spacing: 10){
                ForEach(0..<colorsName.count, id: \.self) { index in
                    Text(colorsName.reversed()[index].localized)
                        .mainFont(size: 22)
                        .foregroundColor(colors[index])
                }
            }
            .padding(.vertical, small ? 10 : 20)
            
            Text("Вы дали правильные ответы: синий, серый, красный, зелёный, жёлтый?\n\nТеперь приступайте к упражнению.".localized)
                .mainFont(size: 18)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
            
        }
        .padding(.horizontal)
        
    }
    
    
}

struct StroopTestPreparing_Previews: PreviewProvider {
    static var previews: some View {
        StroopTestPreparing()
    }
}


