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
        
        GeometryReader { geo in
            let height = geo.size.height
            ZStack (alignment: .top){
                VStack  {
                    Text("Неделя \(viewModel.week)")
                        .bold()
                        .mainFont(size: 25)
                    
                    Text("Прежде чем начать тренировку, определим с помощью тестов, как сейчас работает ваш мозг.")
                        .mainFont(size: 18)
                        .padding()
                        .fixedSize(horizontal: false, vertical: true)
                    
                    
                    Spacer()
                }
                .padding(.top, small ? 0 : 30)
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
                        
                        
                        LottieView(name: "memory", loopMode: .loop, animationSpeed: 0.4)
                            .matchedGeometryEffect(id: "lamp", in: animation)
                            .frame(height: small ? 100 : 150)
                            .padding(.top)
                        
                        Spacer()
                        
                    }
                    .frame(width: screenSize.width / 1.3, height: height * 0.25)
                    .foregroundColor(.primary)
                    .padding()
                    .padding(.vertical, small ? 0 : 15)
                    .background()
                    .matchedGeometryEffect(id: "background", in: animation)
                    .cornerRadius(20).shadow(color: Color.primary.opacity(0.5), radius: 5, x: 0, y: 0)
                    .offset(y: height * (small ? 0.27 : 0.23))
                    .onTapGesture {
                        withAnimation(.spring()){
                            viewModel.wordsTestTapped.toggle()
                        }
                    }
                } else {
                    
                    WordsRememberTest(animation: animation)
                        .environmentObject(viewModel)
                        .zIndex(3)
                    
                }
                
                if viewModel.stroopTestTapped{
                    StroopTest(animation: animation)
                        .environmentObject(viewModel)
                        .zIndex(3)
                      
                } else {
           
                    VStack (spacing: 5) {
                        Text("Тест Струпа")
                            .font(.title2)
                            .bold()
                            .padding(.top, 20)
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
                    .frame(width: screenSize.width / 1.3, height: height * 0.25)
                    .foregroundColor(.primary)
                    .padding()
                    .padding(.vertical, small ? 0 : 15)
                    .background()
                    .matchedGeometryEffect(id: "background1", in: animation)
                    .cornerRadius(20).shadow(color: Color.primary.opacity(0.5), radius: 5, x: 0, y: 0)
                    .offset(y: height * (small ? 0.62 : 0.60))
                    .onTapGesture {
                        withAnimation(.spring()){
                            viewModel.stroopTestTapped.toggle()
                        }
                    }
                
                }
             
            }
        }
        .ignoresSafeArea(.all)
    }
}

struct FirstTestView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FirstTestView()
                .environmentObject(ViewModel())
                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
            FirstTestView()
                .environmentObject(ViewModel())
                .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
        }
    }
}
