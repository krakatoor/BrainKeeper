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
    @Environment (\.presentationMode) private var presentation
    @State private var number1 = 0
    @State private var number2 = 0
    @State private var operator1 = ""
    @State private var totalSum = 0
    @State private var totalSumText = ""
    @State private var timeRemaining = 0
    @State private var prevAnswer = ""
    @State private var prevAnswerColor = Color.black
    @State private var showAnswer = false
    @State private var testFinishCover = false
    @State private var showCover = true
    @State private var results = ""
    @State private var showAlert = false
    @Namespace var animation
    @Environment(\.managedObjectContext) private var  viewContext
    @FetchRequest(entity: TestResult.entity(), sortDescriptors: [])
    private var testResults: FetchedResults<TestResult>
    let buttonWidth = screenSize.width / 3 - 5
    
    var body: some View {
        
        ZStack (alignment: Alignment(horizontal: .trailing, vertical: .top)){
            
            if !viewModel.showNotificationCover {
                Image(systemName: "deskclock")
                    .font(.title2)
                    .zIndex(2)
                    .offset(x: -20, y: -10)
                    .matchedGeometryEffect(id: "deskclock", in: animation)
                    .onTapGesture {
                        withAnimation{
                            viewModel.showNotificationCover.toggle()
                        }
                    }
            }
            
            ZStack (alignment: .center){
                if showCover  && viewModel.day == 1 && viewModel.mathTestResult.isEmpty{
                    MathTestCover(showCover: $showCover)
                        .zIndex(1)
                        .transition(.move(edge: .bottom))
                }
                
                if testFinishCover && viewModel.showNotificationCover {
                    MathTestFinish(hideCover: $testFinishCover, animation: animation)
                        .zIndex(1)
                        .environmentObject(viewModel)
                        .transition(.move(edge: .bottom))
                }
                
                
                VStack {
                    if viewModel.mathTestResult.isEmpty {
                        Text("Максмимально быстро решите математические задачи")
                            .mainFont(size: 18)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding()
                    }
                    
                    
                    VStack (alignment: .center, spacing: 10){
                        
                        
                        LottieView(name: "math", loopMode: .loop, animationSpeed: 0.8)
                            .frame(height: viewModel.startTest ? 150 : (small ? 200 : 250))
                        
                        
                        VStack {
                            if viewModel.mathTestResult.isEmpty {
                                Text("Примеров осталось: \(viewModel.totalExample - viewModel.examplesCount )")
                                    .mainFont(size: 20)
                            }
                            
                            Text(viewModel.isTestFinish ? results : "Правильных ответов: \(viewModel.correctAnswers)")
                
                            
                        }
                        .mainFont(size: 20)
                        
                        
                        if !viewModel.mathTestResult.isEmpty {
                            Text(viewModel.mathTestResult)
                                .font(.title3)
                        } else {
                            timerView(result: $viewModel.mathTestResult, startTimer: $viewModel.startTest, fontSize: 25, isMathTest: true)
                                .environmentObject(viewModel)
                        }
                        
                        Spacer()
                        
                        if viewModel.mathTestResult.isEmpty {
                            
                            HStack {
                                Spacer()
                                
                                if viewModel.startTest {
                                    Text("\(number1) \(operator1) \(number2) =")
                                        .transition(.move(edge: .bottom))
                                        .mainFont(size: 40)
                                        .redacted(reason: viewModel.examplesCount == viewModel.totalExample ? .placeholder : [])
                                } else {
                                    Text("3 x 3 =")
                                        .redacted(reason: viewModel.startTest ? [] : .placeholder)
                                }
                                
                                Text(totalSumText)
                                    .mainFont(size: 40)
                                    .frame(width: viewModel.startTest ?  60 : 40, height: viewModel.startTest ? 45 : 35)
                                    .overlay(Rectangle().stroke().frame(width: viewModel.startTest ?  60 : 40, height: viewModel.startTest ? 45 : 35))
                                
                                Image(systemName: totalSumText != String(totalSum) ?  "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(prevAnswerColor)
                                    .offset(x: 20)
                                    .opacity(showAnswer ? 1 : 0)
                                Spacer()
                            }
                            .onChange(of: viewModel.examplesCount, perform: { _ in
                                if viewModel.examplesCount == viewModel.totalExample {
                                    saveResult()
                                    
                                    viewModel.isMathTestFinish  = true
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                        withAnimation{
                                            testFinishCover = true
                                        }
                                       
                                    }
                                }
                            })
                            
                        } else {
                            
                            VStack{
                                Text("Тест завершён")
                                    .font(.title)
                                    .bold()
                                    .padding(.top)
                                
                                Text("Каждый раз старайтесь улучшать предыдуший результат. Когда вам удатся решать все примеры за 2 минуты, можно будет сказать, что у вас получилось. Если же вы стправитесь за минуту, считайте, что получилили золотую медаль.")
                                    .mainFont(size: 18)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding()
                            }
                            .transition(.move(edge: .bottom))
                        }
                        
                        //MARK: KEYBOARD
                        if viewModel.startTest{
                            buttons
                                .padding(.top)
                                .padding(.bottom, 10)
                                .transition(.move(edge: .bottom))
                            Spacer()
                        }
                        
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if viewModel.examplesCount != viewModel.totalExample{
                            withAnimation{
                                viewModel.startTest = true
                            }
                        }
                    }
                    
                    Spacer()
                    
                    if !viewModel.startTest {
                        
                        HStack {
                            
                            if !viewModel.mathTestResult.isEmpty {
                                Button(action: {
                                    showAlert = true
                                }, label: {
                                    Image(systemName: "arrow.clockwise")
                                        .font(.title)
                                        .offset(y: 7)
                                })
                                .padding(.leading)
                                .alert(isPresented: $showAlert) {
                                    Alert(title: Text("Начать тест заново?"), message: Text("При прохождении теста результаты будут заменены"),
                                          primaryButton: .destructive(Text("Да")) {
                                       
                                            viewModel.timeRemaining = 0
                                            viewModel.examplesCount = 0
                                            withAnimation{
                                                viewModel.mathTestResult = ""
                                            }
                                          },
                                          secondaryButton: .cancel(Text("Нет"))
                                    )
                                }
                            }
                            
                            Spacer()
                            
                            Button(action:{
                                if viewModel.mathTestResult.isEmpty {
                                    withAnimation{
                                        viewModel.startTest = true
                                    }
                                    
                                } else {
                                    withAnimation{
                                        presentation.wrappedValue.dismiss()
                                    }
                                }
                            }, label:{
                                
                                if !viewModel.mathTestResult.isEmpty {
                                    Text("Назад")
                                        .mainFont(size: 20)
                                        .foregroundColor(.white)
                                        .frame(width: 250)
                                        .padding(10)
                                        .background(Color.blue.cornerRadius(15))
                                    
                                } else if viewModel.examplesCount < viewModel.totalExample {
                                    Text(!viewModel.startTest ? "Старт" : "Дальше")
                                        .mainFont(size: 20)
                                        .foregroundColor(.white)
                                        .frame(width: 250)
                                        .padding(10)
                                        .background(Color.blue.cornerRadius(15))
                                    
                                }
                            })
                            .padding(.leading, !viewModel.mathTestResult.isEmpty  ? -25 : 0)
                            .padding(.top)
                            
                            Spacer()
                            
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background()
                .navigationBarTitle("")
                .mainFont(size: 30)
                .onAppear{
                    math()
                    viewModel.timeRemaining = 0
                    print("Всего записей", testResults.count)
                }
            }
        }
    }
    
    
    private func math() {
        operator1 = ["+", "-", "×", "÷"].randomElement()!
        if operator1 == "+" {
            number1 = Int.random(in: 2..<10)
            number2 = Int.random(in: 2..<10)
            totalSum = Int(number1 + number2)
        }
        if operator1 == "-" {
            number1 = Int.random(in: 2..<20)
            number2 = Int.random(in: 1..<number1)
            
            totalSum = Int(number1 - number2)
            
            
        }
        if operator1 == "×" {
            number1 = Int.random(in: 2..<10)
            number2 = Int.random(in: 2..<10)
            totalSum = Int(number1 * number2)
        }
        
        if operator1 == "÷" {
            number1 = (Int.random(in: 10..<30))
            number2 = Int.random(in: 2..<10)
            
            while(number1 %  number2 != 0 ){
                number1 = (Int.random(in: 10..<30))
                number2 = Int.random(in: 2..<10)
            }
            
            totalSum = Int(number1 / number2)
        }
        
    }
    
    //MARK: Save result
    private func saveResult() {
        
        withAnimation{
            viewModel.startTest = false
            viewModel.isTestFinish = true
        
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let testResult = TestResult(context: viewContext)
            testResult.date = today
            testResult.week = String(viewModel.week)
            testResult.day = String(viewModel.mathTestDay)
            testResult.testName = "Ежедневный тест"
            testResult.testResult = viewModel.mathTestResult
            testResult.isMathTest = true
            testResult.result = viewModel.mathTestResultTime
            
            print("Всего записей", testResults.count)
            
            if viewModel.isMathTestFinish{
                for result in testResults.filter({$0.isMathTest && $0.day == String(viewModel.mathTestDay - 1) && $0.week == testResult.week}) {

                        viewContext.delete(result)
                    print("Запись удалена")
                        viewModel.mathTestDay -= 1
                        testResult.day = String(viewModel.mathTestDay)
                        testResult.result = viewModel.mathTestResultTime
                 
                }
            }
                //remove notification if test fineshed early
                notificationCenter.removePendingNotificationRequests(withIdentifiers: ["timeToTrain"])
                notificationCenter.removeDeliveredNotifications(withIdentifiers: ["timeToTrain"])
               
            viewModel.results[Int(testResult.day!)! - 1] = testResult.result
            
            do {try viewContext.save() } catch { return }
            
            
            if  viewModel.mathTestDay == 5{
                viewModel.mathTestDay = 1
            } else {
                viewModel.mathTestDay += 1
            }
          
            viewModel.currentDay = today
            
            print("Save math test")
        }
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
                            .frame(width: buttonWidth, height: small ? 50 : 70)
                            .background(Color("back").shadow(color: Color.primary.opacity(0.5), radius: 3, x: 0, y: 0))
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
                            .frame(width: buttonWidth, height: small ? 50 : 70)
                            .background(Color("back").shadow(color: Color.primary.opacity(0.5), radius: 3, x: 0, y: 0))
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
                            .frame(width: buttonWidth, height: small ? 50 : 70)
                            .background(Color("back").shadow(color: Color.primary.opacity(0.5), radius: 3, x: 0, y: 0))
                    })
                    
                }
            }
            
            HStack(spacing: 3){
                Button(action: {
                    if !totalSumText.isEmpty{
                        totalSumText.removeLast()
                    }
                }, label: {
                    Image(systemName: "delete.left")
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding()
                        .frame(width: buttonWidth, height: small ? 50 : 70)
                        .background(Color.red.clipShape(CustomCorner(corners: small ? [] : .bottomLeft)).shadow(color: Color.primary.opacity(0.5), radius: 3, x: 0, y: 0).shadow(color: Color.primary.opacity(0.3), radius: 1, x: 1, y: 0))
                    
                })
                
                Button(action: {
                    totalSumText.append("0")
                }, label: {
                    Text("0")
                        .padding()
                        .frame(width: buttonWidth, height: small ? 50 : 70)
                        .background(Color("back").shadow(color: Color.primary.opacity(0.5), radius: 3, x: 0, y: 0))
                })
                
                Button(action: {
                    if viewModel.examplesCount < viewModel.totalExample && totalSumText != ""{
                        
                        prevAnswer = "\(totalSum)"
                        showAnswer.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: buttonWidth, height: small ? 50 : 70)
                        .background(Color.blue.clipShape(CustomCorner(corners: small ? [] : .bottomRight)).shadow(color: Color.primary.opacity(0.5), radius: 3, x: 0, y: 0).shadow(color: Color.primary.opacity(0.3), radius: 1, x: -1, y: 0))
                    
                })
                
            }
            
        }
        .background()
        .accentColor(.primary)
        .onChange(of: totalSumText, perform: { value in
            if totalSumText.count > 2{
                totalSumText.removeLast()
            }
        })
        .onAppear{
            viewModel.timeRemaining = 0
        }
    }
}


struct mathTest_Previews: PreviewProvider {
    static var previews: some View {
        mathTest()
            .environmentObject(ViewModel())
    }
}
