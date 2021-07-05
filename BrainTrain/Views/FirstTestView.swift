//
//  FirstTestView.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 11.06.2021.
//

import SwiftUI

struct FirstTestView: View {
    @EnvironmentObject var viewModel: ViewModel

    @Namespace var animation
    
    var body: some View {
        
        ZStack  (alignment: .top){
            
        
            VStack  {
                    Text("Неделя \(viewModel.week)")
                        .bold()
                        .mainFont(size: 25)
                        .padding(.top, 20)
                    
                    Text("Прежде чем начать тренировку, определите с помощью следующих тестов, как сейчас работает ваш мозг.")
                        .mainFont(size: 18)
                        .padding()
                        .fixedSize(horizontal: false, vertical: true)
                    
                    
                    Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background()
            .mainFont(size: 20)
           
                    
            if !viewModel.wordsTestTapped{
                            VStack (spacing: 5) {
                             
                                        Text("Тест на запоминание слов")
                                            .font(.title2)
                                            .bold()
                                            .padding(.top, 20)
                                            .matchedGeometryEffect(id: "Тест", in: animation)
                                        
                                        HStack {
                                            Spacer()
                                            Text("Проверим краткосрочную память")
                                                .foregroundColor(.secondary)
                                                .mainFont(size: 14)
                                                .fixedSize()
                                            Spacer()
                                        }
                                        .padding([.leading, .bottom])
                                
                                        
                                LottieView(name: "memory", loopMode: .loop, animationSpeed: 0.6)
                                    .matchedGeometryEffect(id: "lamp", in: animation)
                                    .frame(height: small ? 80 : 150)
                                    .padding(.top)
                                
                              
                                        Spacer()
                                        

                                    }
                                    .frame(width: screenSize.width / 1.3, height: 200)
                                    .foregroundColor(.primary)
                                    .padding()
                                    .padding(.vertical, small ? 0 : 15)
                                    .background()
                            .matchedGeometryEffect(id: "background", in: animation)
                            .cornerRadius(20).shadow(color: Color.primary.opacity(0.5), radius: 5, x: 0, y: 0)
                            .offset(y: 180)
                                    .onTapGesture {
                                        withAnimation(.spring()){
                                        viewModel.wordsTestTapped.toggle()
                                        }
                                }
            } else {
             
                    WordsRememberTest(animation: animation)
                        .zIndex(3)
                
            }
                     
            if !viewModel.stroopTestTapped{
                                VStack (spacing: 5) {
                            
                                    Text("Тест Струпа")
                                        .font(.title2)
                                        .bold()
                                        .matchedGeometryEffect(id: "Тест Струпа", in: animation)
                                                               
                                    
                                    HStack {
                                        Spacer()
                                        Text("Оценка совместной работы полушарий")
                                            .foregroundColor(.secondary)
                                            .mainFont(size: 14)
                                            .fixedSize()
                                        Spacer()
                                    }
                                    .padding([.leading, .bottom])
                                    
                             
                                    LottieView(name: "stroop", loopMode: .loop, animationSpeed: 0.6)
                                        .matchedGeometryEffect(id: "stroop", in: animation)
                                                            .frame(height: 120)
                                   
                                    Spacer()
                                  

                                }
                                .frame(width: screenSize.width / 1.3, height: 200)
                                .foregroundColor(.primary)
                                .padding()
                                .padding(.vertical, small ? 0 : 15)
                                .background()
                                .matchedGeometryEffect(id: "background1", in: animation)
                                .cornerRadius(20).shadow(color: Color.primary.opacity(0.5), radius: 5, x: 0, y: 0)
                                .offset(y: 480)
                                .onTapGesture {
                                    withAnimation(.spring()){
                                    viewModel.stroopTestTapped.toggle()
                                    }
                                }
            } else {
                StroopTest(animation: animation)
                    .zIndex(3)
            }
        }
        
    }
}

struct FirstTestView_Previews: PreviewProvider {
    static var previews: some View {
        FirstTestView()
            .environmentObject(ViewModel())
    }
}
