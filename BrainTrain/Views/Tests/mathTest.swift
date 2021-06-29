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
    @State private var showAnswer = false
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
                
                VStack (alignment: .center, spacing: 10){
        
                
                        LottieView(name: "math", loopMode: .loop, animationSpeed: 0.8)
                            .frame(height: startTest ? 150 : 250)
                    
                    
                    VStack {
                        if !viewModel.isMathTestFinish {
                        Text("Осталось: \(totalExample - viewModel.examplesCount )")
                            .mainFont(size: 20)
                            .onChange(of: viewModel.examplesCount, perform: { value in
                                if viewModel.examplesCount == totalExample {
                                    startTest.toggle()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        
                                        viewModel.isMathTestFinish = true
                                        
                                    }
                                    saveResult()
                                    
                                    
                                }
                            })
                    }
                        HStack {
                            Text("Правильных ответов: \(viewModel.correctAnswers)")
                      
                            
                        }
                      
                    }
                    .mainFont(size: 20)
                    timerView(result: $viewModel.mathTestResult, startTimer: $startTest, fontSize: 25, isMathTest: true)
                       
                  
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
                           
                           
                            
                            Text(prevAnswer)
                            .foregroundColor(prevAnswerColor)
                                .offset(x: 40)
                                .opacity(showAnswer ? 1 : 0)
                            Spacer()
                        }
                        
                    
                   
                    if startTest{
                      
                    buttons
                        .padding(.top)
                        .transition(.move(edge: .bottom))
                   
                    }
                   
                    Spacer()
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
                    
                    Text("Каждый раз старайтесь улучшать предыдуший результат. Когда вам удатся решать все примеры за 2 минуты, можно будет сказать, что у вас получилось. Если же вы стправитесь за минуту, считайте, что получилили золотую медаль.")
                        .mainFont(size: 18)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                    
                    LottieView(name: "math", loopMode: .loop, animationSpeed: 0.8)
                               .frame(height: 250)
                }
                Spacer()
                
                
                if !startTest{
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
                        if !startTest {
                            withAnimation{
                                startTest.toggle()
                            }
                              
                            } else if viewModel.examplesCount < totalExample && totalSumText != ""{
                          
                                prevAnswer = "\(totalSum)"
                                showAnswer.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    showAnswer.toggle()
                                }
                                
                                prevAnswerColor = totalSumText == String(totalSum) ? .green : .red
                           
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
                    
                  
                }
                .padding()
                .padding(.bottom, 40)
                    
                }
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
    
    private func saveResult() {
        
        let testResult = TestResult(context: viewContext)
        testResult.date = date
        testResult.week = String(viewModel.week)
        testResult.day = String(viewModel.day)
        testResult.testName = "Ежедневный тест"
        testResult.testResult = viewModel.mathTestResult
        testResult.isMathTest = true
        
        if testResults.contains(testResult) {
            viewContext.delete(testResult)
        } else {
        
          do {
              try viewContext.save()
          } catch {return}
        }
   
        viewModel.day += 1
        
        viewModel.sendNotification()
    }
    
    private var buttons: some View {
        VStack (spacing: 3){
           
            HStack(spacing: 3){
                ForEach(1...3, id: \.self) { text in
             
                    Button(action: {
                        totalSumText.append(text.description)
                    }, label: {
                        Text(text.description)
                            .padding()
                            .frame(width: 100, height: 70)
                            .background(Color("back").shadow(radius: 3).ignoresSafeArea())
                    })

                    }
                }
           
            HStack(spacing: 3){
                ForEach(4...6, id: \.self) { text in
             
                    Button(action: {
                        totalSumText.append(text.description)
                    }, label: {
                        Text(text.description)
                            .padding()
                            .frame(width: 100, height: 70)
                            .background(Color("back").shadow(radius: 3).ignoresSafeArea())
                    })

                    }
                }
            
            HStack(spacing: 3){
                ForEach(7...9, id: \.self) { text in
             
                    Button(action: {
                        totalSumText.append(text.description)
                    }, label: {
                        Text(text.description)
                            .padding()
                            .frame(width: 100, height: 70)
                            .background(Color("back").shadow(radius: 3).ignoresSafeArea())
                    })

                    }
                }
          
            HStack(spacing: 3){
                
                Button(action: {
                    if viewModel.examplesCount < totalExample && totalSumText != ""{
                  
                        prevAnswer = "\(totalSum)"
                        showAnswer.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            showAnswer.toggle()
                        }
                        
                        prevAnswerColor = totalSumText == String(totalSum) ? .green : .red
                   
                        if totalSumText == String(totalSum) {
                            viewModel.correctAnswers += 1
                        }
                        totalSumText = ""
                        viewModel.examplesCount += 1
                        math()
                    
                }
                }, label: {
                Text("OK")
                    .padding()
                    .frame(width: 100, height: 70)
                    .background(Color("back").shadow(radius: 3).ignoresSafeArea())
            })
                Button(action: {
                    totalSumText.append("0")
                }, label: {
                Text("0")
                    .padding()
                    .frame(width: 100, height: 70)
                    .background(Color("back").shadow(radius: 3).ignoresSafeArea())
            })
                Button(action: {
                    if !totalSumText.isEmpty{
                    totalSumText.removeLast()
                    }
                }, label: {
                Image(systemName: "delete.left")
                    .padding()
                    .frame(width: 100, height: 70)
                    .background(Color("back").shadow(radius: 3).ignoresSafeArea())
                  
            })
            }
           
            
        }
        .accentColor(.primary)
        .padding(.horizontal, 40)
        .onChange(of: totalSumText, perform: { value in
            if totalSumText.count > 2{
                totalSumText.removeLast()
            }
    })
        
    }
}


struct mathTest_Previews: PreviewProvider {
    static var previews: some View {
        mathTest()
            .environmentObject(ViewModel())
    }
}
