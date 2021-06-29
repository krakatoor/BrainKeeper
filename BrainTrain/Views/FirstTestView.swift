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
                .padding()
                .fixedSize(horizontal: false, vertical: true)
            
            
            Spacer()
            
            VStack (spacing: 40) {
                
                
                NavigationLink(
                    destination: CounterTestView()
                        .environmentObject(viewModel),
                    label: {
                        VStack (spacing: 5) {
                            Text("Тест на счёт")
                                .font(.title2)
                                .bold()
                                .padding(.top, 10)
                            
                            HStack {
                                Spacer()
                                Text("Оценка работы лобных долей")
                                    .foregroundColor(.secondary)
                                    .mainFont(size: 14)
                                    .fixedSize()
                                
                                Spacer()
                            }
                            .padding([.leading, .bottom])
                        }
                        .frame(width: 300)
                        .foregroundColor(.primary)
                        .padding()
                        .padding(.vertical)
                        .background().cornerRadius(20).shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 0)
                        
                    })
                    .buttonStyle(PlainButtonStyle())
                
                
                
                
                NavigationLink(
                    destination: WordsRememberTest().environmentObject(viewModel),
                    label: {
                        VStack (spacing: 5) {
                            Text("Тест на запоминание слов")
                                .font(.title2)
                                .bold()
                                .padding(.top, 10)
                            
                            HStack {
                                Spacer()
                                Text("Проверим краткосрочную память")
                                    .foregroundColor(.secondary)
                                    .mainFont(size: 14)
                                    .fixedSize()
                                Spacer()
                            }
                            .padding([.leading, .bottom])
                        }
                        .frame(width: 300)
                        .foregroundColor(.primary)
                        .padding()
                        .padding(.vertical)
                        .background().cornerRadius(20).shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 0)
                        
                    })
                    .buttonStyle(PlainButtonStyle())
                
                
                
                
                NavigationLink(
                    destination: StroopTest().environmentObject(viewModel),
                    label: {
                        
                        VStack (spacing: 5) {
                            Text("Тест Струпа")
                                .font(.title2)
                                .bold()
                                .padding(.top, 10)
                            
                            HStack {
                                Spacer()
                                Text("Оценка совместной работы полушарий")
                                    .foregroundColor(.secondary)
                                    .mainFont(size: 14)
                                    .fixedSize()
                                Spacer()
                            }
                            .padding([.leading, .bottom])
                        }
                        .frame(width: 300)
                        .foregroundColor(.primary)
                        .padding()
                        .padding(.vertical)
                        .background().cornerRadius(20).shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 0)
                        
                    })
                    .buttonStyle(PlainButtonStyle())
                Spacer()
            }
            .padding(.top, 40)
            
            
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
