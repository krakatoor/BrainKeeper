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
    @State private var rightAnswer = false
    @State private  var totalExample = 5
    @Environment(\.managedObjectContext) private var  viewContext
    @FetchRequest(entity: TestResult.entity(), sortDescriptors: [])
    private var testResults: FetchedResults<TestResult>
    
    var body: some View {
        VStack {
            
            if !viewModel.isMathTestFinish {
            Text("Максмимально быстро решите математические задачи")
                .mainFont(size: 18)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
            
            VStack (alignment: .center, spacing: 20){
    
                
              
                   
                    LottieView(name: "math", loopMode: .loop, animationSpeed: 0.8)
                           .frame(height: 250)
                
                
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
                    HStack {
                        Text("Правильных ответов: \(viewModel.correctAnswers)")
                  
                        
                    }
                  
                }
                .mainFont(size: 20)
                timerView(result: $viewModel.mathTestResult, startTimer: $startTest, timeRemaining: $timeRemaining, fontSize: 25, isMathTest: true)
                   
                if startTest{
                Spacer()
                }
                HStack {
                    Spacer()
                    
                    if startTest {
                    Text("\(number1) \(operator1) \(number2) =")
                    } else {
                        Text("3 x 3 =")
                            .redacted(reason: startTest ? [] : .placeholder)
                    }
                    
                    Text(totalSumText)
                        .frame(width: 44, height: 30)
                        .overlay(Rectangle().stroke())
                   
                    Spacer()
                }
                
                
                if startTest{
                    Spacer()
                buttons
                    .transition(.move(edge: .trailing))
                    .animation(.linear)
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
                
                LottieView(name: "math", loopMode: .loop, animationSpeed: 0.8)
                           .frame(height: 250)
            }
            Spacer()
            
            
            HStack {
                if startTest {
                Button(action: {
                    startTest.toggle()
                  
                }, label: {
                    Image(systemName: "pause.circle")
                        .font(.title)
                        .foregroundColor(.primary)
                })
              
                }
                
                Button(action:{
                    if viewModel.isMathTestFinish {
                        
                        let testResult = TestResult(context: viewContext)
                        testResult.date = date
                          testResult.week = String(viewModel.week)
                          testResult.day = String(viewModel.day)
                        testResult.testName = "Ежедневный тест"
                        testResult.testResult = viewModel.mathTestResult
                        testResult.isMathTest = true
                        
                            withAnimation(.linear){
                            viewModel.showResults = true
                            }
                        
                   
                        viewModel.day += 1
                        
                        if testResults.contains(testResult) {
                            viewContext.delete(testResult)
                        } else {
                        
                          do {
                              try viewContext.save()
                          } catch {return}
                        }
                        viewModel.sendNotification()
                    } else  if !startTest {
                        
                            startTest.toggle()
                          
                        } else if viewModel.examplesCount < totalExample && totalSumText != ""{
                      
                            prevAnswer = "\(number1) \(operator1) \(number2) = \(totalSum)"
                            if totalSumText == String(totalSum) {
                                withAnimation{
                                    rightAnswer.toggle()
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    withAnimation{
                                        rightAnswer.toggle()
                                    }
                                }
                            }
                       
                            if totalSumText == String(totalSum) {
                                viewModel.correctAnswers += 1
                            }
                            totalSumText = ""
                            viewModel.examplesCount += 1
                            math()
                        
                    }
                }, label:{
                    
                    if viewModel.isMathTestFinish{
                        Text("К результатам!")
                            .mainButton()
                    } else if viewModel.examplesCount < totalExample {
                    Text(!startTest ? "Старт" : "Дальше")
                        .mainButton()
                    
                    }
                })
                .padding(.leading)
                
                if startTest{
                Button(action: {
                    if !totalSumText.isEmpty{
                    totalSumText.removeLast()
                    }
                }, label: {
                   Image(systemName: "delete.left")
                    .mainFont(size: 18)
                    .foregroundColor(.white)
                    .frame(width: 40)
                    .padding(11)
                    .background(Color.blue.cornerRadius(13))
                })
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background()
        .navigationBarTitle("")
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
    
    private var buttons: some View {
        VStack {
            HStack (spacing: 8){
            Spacer()
            ForEach(1...5, id: \.self) { number in
                Button(action: {
                    totalSumText.append("\(number)")
                }, label: {
                    Text("\(number)")
                        .mainFont(size: 19)
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                        .padding(10)
                        .background(Color.blue.cornerRadius(5))
                })

            }
         
            Spacer()
        }
        .onChange(of: totalSumText, perform: { value in
            if totalSumText.count > 2{
                totalSumText.removeLast()
            }
    })
            
            
            HStack (spacing: 8){
            Spacer()
            ForEach(6...9, id: \.self) { number in
                Button(action: {
                    totalSumText.append("\(number)")
                }, label: {
                    Text("\(number)")
                        .mainFont(size: 19)
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                        .padding(10)
                        .background(Color.blue.cornerRadius(5))
                })

            }
         
                Button(action: {
                    totalSumText.append("\(0)")
                }, label: {
                    Text("\(0)")
                        .mainFont(size: 19)
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                        .padding(10)
                        .background(Color.blue.cornerRadius(5))
            })

                
            Spacer()
        }
              
        }
    }
}


struct mathTest_Previews: PreviewProvider {
    static var previews: some View {
        mathTest()
            .environmentObject(ViewModel())
    }
}
