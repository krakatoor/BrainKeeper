//
//  FirstTestView.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 11.06.2021.
//

import SwiftUI

struct FirstTestView: View {
 
    @EnvironmentObject var viewModel: ViewModel
    var body: some View {
        NavigationView {
            VStack (spacing: 0){
                  
                VStack (spacing: 20) {
                    Text("Неделя №1")
                        .bold()
                        .padding(.top)
                    
                    Text("Прежде чем начать тренировку, определите с помощью следующих тестов, как сейчас работает ваш мозг.")
                        .mainFont(size: 18)
                        .padding([.horizontal, .bottom])
                    
                    Spacer()
                    
                    VStack (spacing: 10) {
                    Text("Тест на счёт")
                        .font(.title2)
                        .bold()
                        .padding(.top, 10)
                    
                    HStack {
                      
                            Text(viewModel.countTestResult == "" ? "Время теста: ___" : viewModel.countTestResult)
                        
                        Spacer()
                    }
                    .padding([.leading, .bottom])
                 
                    NavigationLink(
                        destination: CounterTestView().environmentObject(viewModel),
                        label: {
                            Text("Начать")
                                .mainButton()
                        })
                    }
                    .padding()
                    .background(Color(#colorLiteral(red: 0.9411536983, green: 0.9728569642, blue: 0.9764705896, alpha: 0.5650093129)).cornerRadius(20).shadow(radius: 10))
                    .frame(width: screenSize.width - 40)
                
                    VStack (spacing: 10) {
                    Text("Тест на запоминание слов")
                        .font(.title2)
                        .bold()
                        .padding(.top, 10)
                    
                    HStack {
                        
                        Text(viewModel.words.isEmpty ? "Запомнил слов: 0" : "Запомнил слов: \(viewModel.words.count)")
                        
                        Spacer()
                    }
                    .padding([.leading, .bottom])
                 
                    NavigationLink(
                        destination: WordsRememberTest().environmentObject(viewModel),
                        label: {
                            Text("Начать")
                                .mainButton()
                        })
                    }
                    .padding()
                    .background(Color(#colorLiteral(red: 0.9411536983, green: 0.9728569642, blue: 0.9764705896, alpha: 0.5650093129)).cornerRadius(20).shadow(radius: 10))
                    .frame(width: screenSize.width - 40)
                    
                    VStack (spacing: 10) {
                    Text("Тест Струпа")
                        .font(.title2)
                        .bold()
                        .padding(.top, 10)
                    
                    HStack {
                        Text(viewModel.stroopTestResult == "" ? "Время теста: ___" : viewModel.stroopTestResult)
                        
                        Spacer()
                    }
                    .padding([.leading, .bottom])
                 
                    NavigationLink(
                        destination: StroopTest().environmentObject(viewModel),
                        label: {
                            Text("Начать")
                                .mainButton()
                        })
                    }
                    .padding()
                    .background(Color(#colorLiteral(red: 0.9411536983, green: 0.9728569642, blue: 0.9764705896, alpha: 0.5650093129)).cornerRadius(20).shadow(radius: 10))
                    .frame(width: screenSize.width - 40)
                    
                    Spacer()
                }
                
                
          
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("")
            .navigationBarHidden(true)
            .mainFont(size: 20)
            .background()
        }
    }
}

struct FirstTestView_Previews: PreviewProvider {
    static var previews: some View {
        FirstTestView()
            .environmentObject(ViewModel())
    }
}
