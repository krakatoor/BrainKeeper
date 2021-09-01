//
//  StroopTesting.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 29.06.2021.
//

import SwiftUI

struct StroopTesting: View {
    @State private var colors = [Color(#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)),Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)),Color(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)),Color(#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)),Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)),Color(#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)),Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)),Color(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)),Color(#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)),Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))].shuffled()
    @State private var colorsName = ["Синий","Красный","Зелёный","Жёлтый", "Серый", "Синий","Красный","Зелёный","Жёлтый", "Серый"].shuffled()
    @Binding var colorsViewTag: Int
    
    var body: some View {
        VStack {
            TabView(selection: $colorsViewTag) {
                ForEach(0..<5) { index in
                    VStack (spacing: 10){
                        ForEach(0...9, id: \.self) { index1 in
                            Text(colorsViewTag == -1 ? colorsName[4].localized : colorsName[index1].localized)
                                .mainFont(size: 25)
                                .foregroundColor(colors[index1])
                        }
                    }
                    .tag(colorsViewTag)
                }
                .redacted(reason: colorsViewTag == -1  ? .placeholder : [])
              
            }
            .disabled(true)
            .tabViewStyle(PageTabViewStyle())
            .animation(colorsViewTag > 0 && colorsViewTag < 5 ? .easeInOut : nil) 
   
            Spacer()
        }
        .padding(.bottom)
        .onChange(of: colorsViewTag, perform: { _ in
            setColors()
        })
    }
    
    func setColors() {
        colorsName = ["Синий","Красный","Зелёный","Жёлтый", "Серый", "Синий","Красный","Зелёный","Жёлтый", "Серый"]
            .shuffled()
        
        colors = [Color(#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)),Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)),Color(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)),Color(#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)),Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)),Color(#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)),Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)),Color(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)),Color(#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)),Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))]
            .shuffled()
    }
    
}

struct StroopTesting_Previews: PreviewProvider {
    static var previews: some View {
        StroopTesting(colorsViewTag: .constant(0))
    }
}


struct StroopFinish: View {
    @EnvironmentObject var viewModel: ViewModel
    var body: some View {
        VStack {
            LottieView(name: "stroop", loopMode: .autoReverse, animationSpeed: 0.6)
                .frame(width: 250, height: 250)
                .padding(.top, 20)
            
            VStack (alignment: .leading){
                Text("Результаты теста:".localized + " " + "\(viewModel.stroopTestResult.capitalized)")
                    .font(.title2)
                
                Text("Тест Струпа оценивает совместную работу передних частей лобных долей левого и правого полушарий. Скорость его выполнения зависит от индивидуальных особенностей, поэтому никакие временные рамки не устанавливаются. Возьмите за основу свой результат, полученный на предыдущей неделе.".localized)
                    .padding(.top)
                    .fixedSize(horizontal: false, vertical: true)
                
            }
            .padding()
            
            Spacer()
        }
    }
    
}
