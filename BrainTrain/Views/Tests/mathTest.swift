//
//  mathTest.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 14.06.2021.
//

import SwiftUI
import Introspect

struct mathTest: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var number1 = 0
    @State private var number2 = 0
    @State private var operator1 = ""
    @State private var totalSum = 0
    @State private var totalSumText = ""
    @State private var startTest = false
    @State private var timeRemaining = 0
    @State private var prevAnswer = ""
    @State private var prevAnswerColor = Color.black
    @Environment(\.presentationMode) var presentation
    @State private  var totalExample = 50
    
    var body: some View {
        VStack {
            
            
            if !viewModel.isMathTestFinish {
            Text("Максмимально быстро решите математические задачи")
                .mainFont(size: 18)
                .padding()
            
            VStack (alignment: .leading, spacing: 50){
                HStack {
                    Spacer()
                    Text("\(number1) \(operator1) \(number2) =")
                        .redacted(reason: startTest ? [] : .placeholder)
                    
                    TextField("", text: $totalSumText)
                        .keyboardType(.numberPad)
                        .padding(.leading, 7)
                        .frame(width: 44, height: 30)
                        .overlay(Rectangle().stroke())
                        .disabled(!startTest)
                        .onChange(of: totalSumText, perform: { value in
                            if totalSumText.count > 2{
                                totalSumText.removeLast()
                            }
                        })
                        .introspectTextField { textField in
                            if startTest{
                            textField.becomeFirstResponder()
                            }
                        }
                    Spacer()
                }
                
                if !startTest{
                LottieView(name: "math", loopMode: .playOnce, animationSpeed: 1)
                           .frame(height: 250)
                }
                if startTest && prevAnswer != "" {
                   
                    HStack {
                        Spacer()
                        Text(prevAnswer)
                            .foregroundColor(prevAnswerColor)
                        Spacer()
                    }
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                startTest = true
            }
            } else {
                Text("Тест завершён")
                    .font(.title)
                    .bold()
                    .padding(.top)
                
                Text("Начальная цель - 2 минуты 30 секунд.\nКаждый раз старайтесь улучшать предыдуший результат. Когда вам удатся решать все примеры за 2 минуты, можно будет сказать, что у вас получилось. Если же вы стправитесь за минуту, считайте, что получилили золотую медаль.")
                    .mainFont(size: 18)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                
                LottieView(name: "math", loopMode: .playOnce, animationSpeed: 1)
                           .frame(height: 250)
            }
            Spacer()
            
      
            VStack {
                if !viewModel.isMathTestFinish {
                Text("Осталось: \(totalExample - viewModel.examplesCount )")
                    .mainFont(size: 20)
                    .onChange(of: viewModel.examplesCount, perform: { value in
                        if viewModel.examplesCount == totalExample {
                            startTest.toggle()
                            viewModel.isMathTestFinish = true
                        }
                    })
            }
                Text("Правильных ответов: \(viewModel.correctAnswers)")
              
            }
            .mainFont(size: 20)
            timerView(result: $viewModel.mathTestResult, startTimer: $startTest, timeRemaining: $timeRemaining, fontSize: 25)
                .padding(.top)
            
            Button(action:{
                if  !viewModel.mathTestResult.isEmpty {
                    viewModel.isMathTestFinish = true
                    viewModel.day = 2
                    presentation.wrappedValue.dismiss()
                } else {
                    if !startTest {
                    startTest.toggle()
                        viewModel.isMathTStarted = true
                        
                    } else if viewModel.examplesCount < totalExample && totalSumText != ""{
                  
                        prevAnswer = "\(number1) \(operator1) \(number2) = \(totalSum)"
                         prevAnswerColor = totalSumText == String(totalSum) ? .green : .red
                   
                        if totalSumText == String(totalSum) {
                            viewModel.correctAnswers += 1
                        }
                        totalSumText = ""
                        viewModel.examplesCount += 1
                        math()
                    }
                }
            }, label:{
                if viewModel.examplesCount < totalExample {
                Text(!startTest ? "Старт" : "Дальше")
                    .mainButton()
                } else {
                    Text("Назад")
                        .mainButton()
                }
            })
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background()
        .navigationBarTitle("Неделя 1. День 1.")
        .mainFont(size: 30)
        .onAppear{
            math()
        }
    }
    
    
   private func math () {
        let random1 = Int.random(in: 1..<10)
        let random2 = Int.random(in: 1..<10)
        operator1 = ["+", "-", "×"].randomElement()!
       
        
        if operator1 == "+" {
            number1 = random1
            number2 = random2
            totalSum = Int(random1 + random2)
        }
        if operator1 == "-" {
                number1 = Int.random(in: 2..<20)
            number2 = Int.random(in: 1..<number1)
         
            totalSum = Int(number1 - number2)
            
            
        }
        if operator1 == "×" {
            number1 = random1
            number2 = random2
            totalSum = Int(random1 * random2)
        }
        
    }
}

//.foregroundColor(totalSumText == totalSum(int1: random, int2: random1) ? .blue : .red)

struct mathTest_Previews: PreviewProvider {
    static var previews: some View {
        mathTest()
            .environmentObject(ViewModel())
    }
}
