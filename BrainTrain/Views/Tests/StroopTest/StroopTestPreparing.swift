//
//  Stroop.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 29.06.2021.
//

import SwiftUI

struct StroopTestPreparing: View {
    let colors = [Color(#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)),Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)),Color(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)),Color(#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)),Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))]
    let colorsName = ["Синий","Красный","Зелёный","Жёлтый", "Фиолетовый"]
    var body: some View {
        
        ScrollViewReader{ proxy in
            ScrollView(showsIndicators: false) {
                    
                    VStack  {
                        Text("Перед началом тестирования пройдите подготовку к нему.\n\nНазывайте в слух цвет слов, делая это как можно быстрее. Будьте внимательней вы должны не читать слова, а называть их цвет. Если ошиблись назовите цвет еще раз.")
                            .mainFont(size: small ? 18 : 20)
                            .fixedSize(horizontal: false, vertical: true)
                         
                        
                        HStack {
                            Text("(Пример: если написано")
                                .mainFont(size: small ? 18 : 20)
                            Text("Красный,")
                                .foregroundColor(.blue)
                                .mainFont(size: small ? 18 : 20)
                            Spacer()
                        }
                        .padding(.top)
                        .fixedSize(horizontal: false, vertical: true)
                        
                            HStack {
                                Text("говорите Синий.)")
                                    .mainFont(size: small ? 18 : 20)
                                Spacer()
                            }
                        
                        VStack (spacing: 15){
                            ForEach(0..<colorsName.count, id: \.self) { index in
                                Text(colorsName.reversed()[index])
                                    .mainFont(size: 25)
                                    .foregroundColor(colors[index])
                            }
                        }
                        .padding(.vertical, 20)
                        
                        Text("Вы дали правильные ответы: синий, фиолетовый, красный, зелёный, жёлтый?\n\nТеперь приступайте к упражнению.")
                            .mainFont(size: 20)
                            .fixedSize(horizontal: false, vertical: true)
                    
                       Spacer()
                        .id(1)

                    }
                    .padding(.horizontal)
                    .navigationTitle("Тест Струпа")
                    .background()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation{
                            proxy.scrollTo(1)
                            }
                        }
                    }
            }
        }
            
        
      
    }
    
}

struct StroopTestPreparing_Previews: PreviewProvider {
    static var previews: some View {
        StroopTestPreparing()
    }
}


