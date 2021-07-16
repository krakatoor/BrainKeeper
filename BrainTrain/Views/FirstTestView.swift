//
//  FirstTestView.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 11.06.2021.
//

import SwiftUI

struct FirstTestView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var blur: CGFloat = 15
    var body: some View {
        VStack  {
            if viewModel.day == 1 && !viewModel.isMathTestFinish && !viewModel.isWordsTestFinish && !viewModel.isStroopTestFinish {
                
            Text("Неделя \(viewModel.week)")
                .bold()
                .mainFont(size: 22)
            
                Text("Прежде чем начать тренировку, определим с помощью тестов, как сейчас работает ваш мозг.")
                    .mainFont(size: 16)
                    .padding([.horizontal, .bottom])
                    .fixedSize(horizontal: false, vertical: true)
            }
         
            
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack (spacing: 10) {
                        VStack (spacing: 20){
                        
                            NavigationLink(
                                destination: WordsRememberTest(),
                                label: {
                                    TestCard(title: "Тест на запоминание слов", subTitle: "Проверим краткосрочную память")
                                        .environmentObject(viewModel)
                                })
                            
                            NavigationLink(
                                destination: StroopTest(),
                                label: {
                                    TestCard(title: "Тест Струпа", subTitle: "Оценка совместной работы полушарий")
                                })
                        
                        }
                        
                        Spacer()
                        
                            NavigationLink(
                                destination: mathTest(),
                                label: {
                                    TestCard(title: "Ежедневный тест", subTitle: "Оценка совместной работы полушарий")
                                })
                                .id(1)
                                .padding(.trailing, 10)
                        
                            NavigationLink("", destination: EmptyView())
                       
                        
                    }
                    .padding(.leading)
                    .padding(.vertical)
                    .onAppear{
                        if viewModel.isWordsTestFinish && viewModel.isStroopTestFinish{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation(.spring()){
                                proxy.scrollTo(1)
                                    blur = 0
                                }
                            }
                           
                        }
                    }
                }
            }
            
           
            TestResultsView()
            
        }
        .blur(radius: blur)
        .background()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("")
    }
}

struct FirstTestView_Previews: PreviewProvider {
    static var previews: some View {
        FirstTestView()
            .environmentObject(ViewModel())
        
    }
}

struct TestCard: View {
    @EnvironmentObject var viewModel: ViewModel
    var title: String
    var subTitle: String
    
    var body: some View {
        VStack (spacing: 5) {
            
            Text(title)
                .font(.title2)
                .bold()
                .padding(.top, 20)
            
            HStack {
                Spacer()
                Text(subTitle)
                    .foregroundColor(.secondary)
                    .mainFont(size: 14)
                    .fixedSize()
                
                Spacer()
            }
            .padding([.leading, .bottom])
            
            Spacer()
            
            if title == "Ежедневный тест" {
                LottieView(name: "math", loopMode: .loop, animationSpeed: 0.8)
                    .frame(height: 150)
            }
            
        }
        .frame(width: screenSize.width / 1.2, height: title == "Ежедневный тест" ? 170 : 50)
        .foregroundColor(.primary)
        .padding()
        .padding(.vertical, small ? 0 : 15)
        .background(Color("back").cornerRadius(15).shadow(color: Color.primary.opacity(0.5), radius: 3, x: 0, y: 0))
    }
}


