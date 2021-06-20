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
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        VStack {
            VStack {
                
                Spacer()
            
                LottieView(name: "timer", loopMode: .loop, animationSpeed: 0.3)
                           .frame(height: 200)
                
                timerView(result: $viewModel.countTestResult, startTimer: $startCountTest, timeRemaining: $timeRemaining, fontSize: 25).environmentObject(viewModel)
                    .padding()
                
                VStack {
                    if viewModel.countTestResult.isEmpty  {
                Text("Максимально быстро сосчитайте вслух от 1 до 120.")
                    .mainFont(size: 20)
                    .padding()
                    } else {
                        Text("Тест завершён")
                            .font(.title)
                            .bold()
                        
                        Text("Поставьте перед собой цель и постарайтесь её достичь.\n45 секунд - уровень ученика средней школы,\n35 - страшеклассника,\n25 - студента, изучающего точные науки.")
                            .mainFont(size: 18)
                            .padding()
                            
                    }
                    
                    Spacer()
                    
                    HStack {
                        if !viewModel.countTestResult.isEmpty  {
                        Button(action: {
                            viewModel.countTestResult = ""
                            timeRemaining = 0
                        }, label: {
                           Image(systemName: "arrow.clockwise")
                            .font(.title)
                        })
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            if !viewModel.countTestResult.isEmpty  {
                                viewModel.isCountTestFinish = true
                                presentation.wrappedValue.dismiss()
                                
                              let testResult = TestResult(context: viewContext)
                              testResult.date = date
                              testResult.testName = "Тест на счет"
                              testResult.testResult = viewModel.countTestResult
//                              do {
//                                  try viewContext.save()
//                              } catch {return}
                        } else {
                            startCountTest.toggle()
                        
                        }
                    },
                        label: {
                            if  viewModel.countTestResult == "" {
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
            .onDisappear{
                if !viewModel.countTestResult.isEmpty{
                viewModel.isCountTestFinish = true
                }
            }
            .navigationBarTitle("Тест на счет")
            .background()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
      
      
    }
}

struct CounterTestView_Previews: PreviewProvider {
    static var previews: some View {
        CounterTestView()
            .environmentObject(ViewModel())
    }
}
