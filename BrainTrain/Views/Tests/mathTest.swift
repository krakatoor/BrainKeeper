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
    @State private var totalSumText = "?"
    @State private var timeRemaining = 0
    @State private var prevAnswer = ""
    @State private var prevAnswerColor = Color.black
    @State private var showAnswer = false
    @State private var testFinishCover = false
    @State private var showCover = true
    @State private var results = ""
    @State private var showAlert = false
    @Environment(\.managedObjectContext) private var  viewContext
    @FetchRequest(entity: TestResult.entity(), sortDescriptors: [])
    private var testResults: FetchedResults<TestResult>
    let buttonWidth = screenSize.width / 3 - 5
    
    var body: some View {
        
        ZStack (alignment: .bottom) {
        ZStack (alignment: .center){
            if showCover  && viewModel.day == 1 && viewModel.results[viewModel.mathTestDay] == 0.0 {
                MathTestCover(showCover: $showCover)
                    .zIndex(1)
                    .transition(.move(edge: .bottom))
            }
            
            if testFinishCover && viewModel.showNotification && !viewModel.hideFinishCover {
                MathTestFinish(hideCover: $testFinishCover)
                    .zIndex(1)
                    .environmentObject(viewModel)
                    .transition(.move(edge: .bottom))
            }
            
            
            VStack {
                if viewModel.results[viewModel.mathTestDay] == 0.0  {
                    Text("Максимально быстро решите математические задачи".localized)
                        .mainFont(size: 18)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                }
                
                
                VStack (alignment: .center, spacing: 10){
                    
                    
                    LottieView(name: "math", loopMode: .loop, animationSpeed: 0.8)
                        .frame(height: viewModel.startMathTest ? (small ? 80 : 150) : (small ? 150 : 250))
                    
                    
                    VStack {
                        if viewModel.results[viewModel.mathTestDay] == 0.0  {
                            HStack {
                            Text("Примеров осталось:".localized)
                                Text(" \(viewModel.totalExample - viewModel.examplesCount )")
                            }
                            .mainFont(size: 20)
                        }
                        
          
                            if viewModel.results[viewModel.mathTestDay] != 0.0 {
                                Text(results)
                            } else {
                            
                                Text("Правильных ответов:".localized + " " + " \(viewModel.correctAnswers)")
                            }
                       
                        
                    }
                    .mainFont(size: 20)
                    
                    
                    if viewModel.results[viewModel.mathTestDay] != 0.0 {
                        Text("Правильных ответов:".localized + " " + viewModel.mathTestResult)
                            .font(.title3)
                    } else {
                        timerView(result: $viewModel.mathTestResult, startTimer: $viewModel.startMathTest, fontSize: 25, isMathTest: true)
                            .environmentObject(viewModel)
                    }
                    
                    Spacer()
                    
                    if viewModel.results[viewModel.mathTestDay] == 0.0  {
                        
                        HStack {
                            
                            Spacer()
                            
                            if viewModel.startMathTest {
                                Text("\(number1) \(operator1) \(number2) =")
                                    .transition(.move(edge: .bottom))
                                    .mainFont(size: small ? 35 : 40)
                                    .redacted(reason: viewModel.examplesCount == viewModel.totalExample ? .placeholder : [])
                                
                                
                                Text(totalSumText)
                                    .mainFont(size: small ? 35 : 40)
                                    .frame(width: viewModel.startMathTest ?  60 : 40, height: viewModel.startMathTest ? 45 : 35)
                                    .overlay(Rectangle().stroke().frame(width: viewModel.startMathTest ?  60 : 40, height: viewModel.startMathTest ? 45 : 35))
                                
                            }
                            
                            Image(systemName: totalSumText != String(totalSum) ?  "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(prevAnswerColor)
                                .offset(x: 20)
                                .opacity(showAnswer ? 1 : 0)
                            
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if viewModel.examplesCount != viewModel.totalExample{
                                withAnimation{
                                    viewModel.startMathTest = true
                                }
                            }
                        }
                        .onChange(of: viewModel.examplesCount, perform: { _ in
                            if viewModel.examplesCount == viewModel.totalExample {
                                print(viewModel.examplesCount)
                                withAnimation{
                                    testFinishCover = true
                                    viewModel.isTestFinish = true
                                    saveResult()
                                    viewModel.startMathTest = false
                                }
                            }
                            
                        })
                        
                    } else {
                        
                        VStack{
                            Text("Тест завершён")
                                .font(.title)
                                .bold()
                                .padding(.top)
                            
                            Text("Каждый раз старайтесь улучшать предыдущий результат. Когда вам удаться решать все примеры за 2 минуты, можно будет сказать, что у вас получилось. Если же вы справитесь за минуту, считайте, что получили золотую медаль.".localized)
                                .mainFont(size: 18)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding()
                        }
                        .transition(.move(edge: .bottom))
                    }
                    
                    //MARK: KEYBOARD
                    if viewModel.startMathTest{
                        buttons
                            .padding(.top)
                            .transition(.move(edge: .bottom))
                            .disabled(viewModel.examplesCount == viewModel.totalExample)
                    }
                    
                }
                
                Spacer()
                
                if !viewModel.startMathTest {
                    
                    HStack {
                        
                        if viewModel.results[viewModel.mathTestDay] != 0.0 {
                            Button(action: {
                                showAlert = true
                            }, label: {
                                Image(systemName: "arrow.clockwise")
                                    .font(.title)
                                    .offset(y: small ? 5 : 7)
                            })
                            .padding(.leading)
                            .alert(isPresented: $showAlert) {
                                Alert(title: Text("Начать тест заново?".localized), message: Text("При прохождении теста результаты будут заменены".localized),
                                      primaryButton: .destructive(Text("Да")) {
                                        totalSumText = "?"
                                        viewModel.timeRemaining = 0
                                        viewModel.correctAnswers = 0
                                        viewModel.examplesCount = 0
                                        showCover = false
                                        withAnimation{
                                            viewModel.results[viewModel.mathTestDay] = 0.0
                                        }
                                      },
                                      secondaryButton: .cancel(Text("Нет".localized))
                                )
                            }
                        }
                        
                        Spacer()
                        
                        Button(action:{
                            if viewModel.results[viewModel.mathTestDay] == 0.0  {
                                withAnimation{
                                    viewModel.startMathTest = true
                                    totalSumText = ""
                                }
                                
                            } else {
                                withAnimation{
                                    presentation.wrappedValue.dismiss()
                                }
                            }
                        }, label:{
                            
                            if viewModel.results[viewModel.mathTestDay] != 0.0 {
                                Text("Назад".localized)
                                    .mainFont(size: 20)
                                    .foregroundColor(.white)
                                    .frame(width: 250)
                                    .padding(10)
                                    .background(Color.blue.cornerRadius(15))
                                
                            } else if viewModel.examplesCount < viewModel.totalExample {
                                Text(!viewModel.startMathTest ? "Начать тест".localized : "Дальше".localized)
                                    .mainFont(size: 20)
                                    .foregroundColor(.white)
                                    .frame(width: 250)
                                    .padding(10)
                                    .background(Color.blue.cornerRadius(15))
                                
                            }
                        })
                        .padding(.leading, viewModel.results[viewModel.mathTestDay] != 0.0  ? -25 : 0)
                        .padding(.top)
                        .padding(.bottom, small ? 10 : 0)
                        .opacity(showCover && viewModel.day == 1 && viewModel.results[viewModel.mathTestDay] == 0.0  ? 0 : 1)
                        Spacer()
                        
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background()
            .navigationBarTitle("")
            .mainFont(size: 30)
        }
       
            Settings()
                .offset(y: viewModel.showSettings ? small ? 0 : 50 : 450)
                .offset(y:  viewModel.viewState)
                .gesture(
                    DragGesture().onChanged{ value in
                        if value.translation.height > 35 {
                            viewModel.viewState = value.translation.height
                        }
                    }
                    .onEnded{ value in
                        if value.translation.height > 120 {
                            withAnimation(.linear) {
                                viewModel.showSettings = false
                            }
                        } else { viewModel.viewState = .zero }})
        }
        .onAppear{
            math()
            viewModel.timeRemaining = 0
            viewModel.startMathTest = false
            print(viewModel.mathTestDay)
            if viewModel.isMathTestFinish {
                for result in testResults{
                    
                    if result.isMathTest {
                        if result.week == String(viewModel.week){
                            viewModel.results[Int(result.day)] = result.result
                            viewModel.mathTestResult = result.testResult!
                        }
                        
                        if result.day == Double(viewModel.mathTestDay) {
                            viewModel.isMathTestFinish = true
                        }
                    }
                    
                }
            }
        }
        .onDisappear{
            if viewModel.startMathTest {
                viewModel.startMathTest = false
                totalSumText = "?"
                if viewModel.results[viewModel.mathTestDay] == 0.0 {
                    viewModel.timeRemaining = 0
                    viewModel.correctAnswers = 0
                    viewModel.examplesCount = 0
                }
            }
        }
        .navigationBarItems(trailing: settingButton().environmentObject(viewModel))
    }
    
    
    private func math() {
        operator1 = ["+", "-", "×", "÷"].randomElement()!
        
        switch viewModel.difficult {
        
        case .easy:
            if operator1 == "+" {
                number1 = Int.random(in: 2..<5)
                number2 = Int.random(in: 2..<5)
                totalSum = Int(number1 + number2)
            }
            
            if operator1 == "-" {
                number1 = Int.random(in: 2..<10)
                number2 = Int.random(in: 1..<number1)
                
                totalSum = Int(number1 - number2)
            }
            
            if operator1 == "×" {
                number1 = Int.random(in: 1..<5)
                number2 = Int.random(in: 1..<5)
                totalSum = Int(number1 * number2)
            }
            
            if operator1 == "÷" {
                number1 = (Int.random(in: 10..<20))
                number2 = Int.random(in: 2..<5)
                
                while(number1 %  number2 != 0 ){
                    number1 = (Int.random(in: 10..<20))
                    number2 = Int.random(in: 2..<5)
                }
                
                totalSum = Int(number1 / number2)
            }
            
        case .normal:
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
            
        case .hard:
            if operator1 == "+" {
                number1 = Int.random(in: 5..<20)
                number2 = Int.random(in: 5..<20)
                totalSum = Int(number1 + number2)
            }
            
            if operator1 == "-" {
                number1 = Int.random(in: 5..<40)
                number2 = Int.random(in: 1..<number1)
                
                totalSum = Int(number1 - number2)
            }
            
            if operator1 == "×" {
                number1 = Int.random(in: 5..<20)
                number2 = Int.random(in: 5..<20)
                totalSum = Int(number1 * number2)
            }
            
            if operator1 == "÷" {
                number1 = (Int.random(in: 20..<50))
                number2 = Int.random(in: 4..<20)
                
                while(number1 %  number2 != 0 ){
                    number1 = (Int.random(in: 20..<50))
                    number2 = Int.random(in: 4..<20)
                }
                
                totalSum = Int(number1 / number2)
            }
        }
    }
    
    //MARK: Save result
    private func saveResult() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            
            let testResult = TestResult(context: viewContext)
            
            if viewModel.isMathTestFinish {
                
                for result in testResults{
                    if result.isMathTest{
                        if result.week == String(viewModel.week) {
                            if result.day == Double(viewModel.mathTestDay) {
                                viewContext.delete(result)
                            }
                        }
                    }
                }
            }
            
            testResult.date = today
            testResult.week = String(viewModel.week)
            testResult.day = Double(viewModel.mathTestDay)
            testResult.testName = "Ежедневный тест"
            testResult.testResult = viewModel.mathTestResult
            testResult.isMathTest = true
            testResult.result = viewModel.mathTestResultTime
            
            //remove notification if test fineshed early
            notificationCenter.removeAllPendingNotificationRequests()
            notificationCenter.removeAllDeliveredNotifications()
            
            withAnimation{
                viewModel.results[viewModel.mathTestDay] = testResult.result
            }
            
            do {try viewContext.save() } catch { return }
            
            if viewModel.saveChoice && viewModel.showNotification {
                viewModel.sendNotification()
            }
            
            viewModel.currentDay = today
            viewModel.currentDay = tomorrow //delete
            
            print("Save math test")
            
            viewModel.isMathTestFinish  = true
            
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
    }
}


struct mathTest_Previews: PreviewProvider {
    static var previews: some View {
        mathTest()
            .environmentObject(ViewModel())
    }
}
