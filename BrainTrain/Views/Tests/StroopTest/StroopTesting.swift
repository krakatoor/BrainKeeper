//
//  StroopTesting.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 29.06.2021.
//

import SwiftUI

struct StroopTesting: View {
    @State private var colors = [Color(#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)),Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)),Color(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)),Color(#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)),Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)),Color(#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)),Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)),Color(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)),Color(#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)),Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))]
    let colorsName = ["Синий","Красный","Зелёный","Жёлтый", "Серый"]
    @Binding var colorsViewTag: Int
    @State private var random = 0
 
    
    var body: some View {
        VStack {
            TabView(selection: $colorsViewTag) {
                ForEach(0..<5) { index in
                    VStack (spacing: 10){
                    ForEach(0...9, id: \.self) { index in
                        Text(colorsViewTag == -1 ? colorsName[4] : colorsName.randomElement()!)
                            .mainFont(size: 25)
                            .foregroundColor(colorsViewTag == -1 ? colors.shuffled()[index] : colors.randomElement()!)
                           
                    }
                    
                }
                .tag(index)
                   
                }
                .redacted(reason: colorsViewTag == -1  ? .placeholder : [])
               
            }
            .disabled(true)
            .tabViewStyle(PageTabViewStyle())
           
            Spacer()
        }
        .padding(.bottom)
        .background()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    
        
    }
     
}

struct StroopTesting_Previews: PreviewProvider {
    static var previews: some View {
        StroopTesting(colorsViewTag: .constant(0))
    }
}


struct StroopFinish: View {
    @EnvironmentObject var viewModel: ViewModel
    var animation: Namespace.ID
    var body: some View {
        VStack {
            LottieView(name: "stroop", loopMode: .autoReverse, animationSpeed: 0.6)
                                        .frame(width: 250, height: 250)
                .padding(.top, 20)
                .matchedGeometryEffect(id: "stroop", in: animation)
            
            VStack (alignment: .leading){
                Text("\(viewModel.stroopTestResult.capitalized)")
                    .font(.title2)
                
                Text("Тест Струпа оценивает совместную работу передних частей лобных долей левого и правого полушарий. Скорость его выполнения завист от индивидуальных особенностей, поэтому никакие верменые рамки не устанавливаются. Возьмите за основу свой результат, полученый на предыдущей неделе.")
                    .padding(.top)
                    .fixedSize(horizontal: false, vertical: true)
                 
            }
            .padding()
            
            Spacer()
        }
    }
    
}
