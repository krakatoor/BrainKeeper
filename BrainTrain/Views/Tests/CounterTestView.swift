//
//  CounterTestView.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 11.06.2021.
//

import SwiftUI

struct CounterTestView: View {
    @State private var startCountTest = false
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.presentationMode) var presentation
    @State var timeRemaining = 0
    
    var body: some View {
        VStack {
            
            LottieView(name: "timer", loopMode: .loop, animationSpeed: 0.3)
                       .frame(width: 250, height: 250)
         
            
            timerView(result: $viewModel.countTestResult, startTimer: $startCountTest, timeRemaining: $timeRemaining, fontSize: 25).environmentObject(viewModel)
                .padding()
            
            VStack {
                if !viewModel.isCountTestFinish {
            Text("Максимально быстро сосчитайте вслух от 1 до 120.")
                .mainFont(size: 20)
                } else {
                    Text("Тест завершён")
                        .font(.title)
                        .bold()
                    
                    Text("Поставьте перед собой цель и постарайтесь её достичь.\n45 секунд - уровень ученика средней школы,\n35 - страшеклассника,\n25 - студента, изучающего точные науки.")
                        .mainFont(size: 18)
                        .padding()
                }
            
                HStack {
                    if viewModel.isCountTestFinish  {
                    Button(action: {
                        viewModel.isCountTestFinish = false
                        timeRemaining = 0
                    }, label: {
                       Image(systemName: "arrow.clockwise")
                        .font(.title)
                    })
                    }
                    Spacer()
                    
                    Button(action: {
                    if viewModel.isCountTestFinish  {
                        presentation.wrappedValue.dismiss()
                    } else {
                        startCountTest.toggle()
                    if !viewModel.isCountTestFinish && !startCountTest {
                        startCountTest = false
                        viewModel.isCountTestFinish = true
                    }
                    }
                },
                    label: {
                        if !viewModel.isCountTestFinish {
                        Text(startCountTest ? "Стоп" : "Старт")
                            .mainButton()
                        } else {
                            Text("Назад" )
                                .mainButton()
                        }
                    })
                    .padding(.leading, -20)
                    Spacer()
                }
                .padding(.horizontal, 30)
                    .padding(.top, 40)
                
            }
            Spacer()
        }
        .navigationBarTitle("Тест на счет")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background()
    }
}

struct CounterTestView_Previews: PreviewProvider {
    static var previews: some View {
        CounterTestView()
            .environmentObject(ViewModel())
    }
}
