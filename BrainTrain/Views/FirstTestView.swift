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
      
            VStack  {
                        Text("Неделя №\(viewModel.week)")
                            .bold()
                        
                        Text("Прежде чем начать тренировку, определите с помощью следующих тестов, как сейчас работает ваш мозг.")
                            .mainFont(size: 18)
                            .padding([.horizontal, .bottom])
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                        
                        VStack (spacing: 20) {
                        VStack (spacing: 10) {
                        Text("Тест на счёт")
                            .font(.title2)
                            .bold()
                            .padding(.top, 10)
                        
                        HStack {
                            Spacer()
                                Text("Оценка работы лобных долей")
                                    .mainFont(size: 14)
                                    .fixedSize()
                            
                            Spacer()
                        }
                        .padding([.leading, .bottom])
                     
                        NavigationLink(
                            destination: CounterTestView()
                                .environmentObject(viewModel),
                            label: {
                                Text("Начать")
                                    .mainButton()
                            })
                        }
                        .padding()
                        .background(BlurView(style: .regular).cornerRadius(20))
                        .frame(width: screenSize.width - 40)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 0.3))
                    
                        VStack (spacing: 10) {
                        Text("Тест на запоминание слов")
                            .font(.title2)
                            .bold()
                            .padding(.top, 10)
                        
                        HStack {
                            Spacer()
                            Text("Проверим краткосрочную память")
                                .mainFont(size: 14)
                                .fixedSize()
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
                        .background(BlurView(style: .regular).cornerRadius(20))
                        .frame(width: screenSize.width - 40)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 0.3))
                        
                        VStack (spacing: 10) {
                        Text("Тест Струпа")
                            .font(.title2)
                            .bold()
                            .padding(.top, 10)
                        
                        HStack {
                            Spacer()
                            Text("Оценка совместной работы полушарий")
                                .mainFont(size: 14)
                                .fixedSize()
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
                        .background(BlurView(style: .regular).cornerRadius(20))
                        .frame(width: screenSize.width - 40)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 0.3))
                        }
                        .padding(.bottom)
                        
                        
                        Spacer()
                    
                }
            .navigationBarHidden(true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background()
            .mainFont(size: 20)
      
    }
}

struct FirstTestView_Previews: PreviewProvider {
    static var previews: some View {
        FirstTestView()
            .environmentObject(ViewModel())
    }
}
