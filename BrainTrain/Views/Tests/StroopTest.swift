//
//  colorsView.swift
//  BrainTrain
//
//  Created by Камиль  Сулейманов on 28.11.2020.
//

import SwiftUI

enum StroopTestStages {
    case prepare, test, finish
}

struct StroopTest: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment (\.presentationMode) private var presentation
    @Environment(\.managedObjectContext) private var  viewContext
    @FetchRequest(entity: TestResult.entity(), sortDescriptors: [])
    private var testResults: FetchedResults<TestResult>
    @State private var buttonTitile = "Дальше".localized
    @State private var colorsViewTag = -1
    @State private var stage: StroopTestStages = .prepare
    @State private var showAlert = false
    @State private var disableButton = false

    var body: some View {
        
                    VStack {
                        stroopTestViews()
                            .background()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .transition(.slide)
                            .onChange(of: colorsViewTag, perform: { value in
                                if value == 4 {
                                    buttonTitile = "Стоп".localized
                                }
                                if value == 5 {
                                    viewModel.startStroopTestTimer = false
                                    buttonTitile = "Назад".localized
                                    colorsViewTag = -1
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        withAnimation{
                                            stage = .finish
                                        }
                                        let testResult = TestResult(context: viewContext)
                                        testResult.date = today
                                        testResult.week = String(viewModel.week)
                                        testResult.day = Double(viewModel.day)
                                        testResult.testName = "Тест Струпа"
                                        testResult.testResult = viewModel.stroopTestResult
                                        testResult.isMathTest = false
                                     
                                            for result in testResults{
                                                if result.date == testResult.date {
                                                    if result.testName == testResult.testName{
                                                        viewContext.delete(result)
                                                        print("Delete")
                                                    }
                                                }
                                            }
                                        
                                        do {try viewContext.save() } catch { return }
                                        viewModel.isStroopTestFinish = true
                                        print("save stroop")
                                    }
                                }
                            })
                        
                        
                        timerView(result: $viewModel.stroopTestResult, startTimer: $viewModel.startStroopTestTimer)
                            .environmentObject(viewModel)
                            .padding(.top, 10)
                            .opacity(stage == .test ? 1 : 0)
                        
                        
                  
                        
                        HStack {
                            
                            if !viewModel.stroopTestResult.isEmpty && stage == .finish {
                                Button(action: {
                                    showAlert = true
                                }, label: {
                                    Image(systemName: "arrow.clockwise")
                                        .font(.title)
                                })
                                .alert(isPresented: $showAlert) {
                                    Alert(title: Text("Начать тест заново?".localized), message: Text("При прохождении теста результаты будут заменены".localized),
                                          primaryButton: .destructive(Text("Да")) {
                                            viewModel.stroopTestResult = ""
                                            viewModel.timeRemaining = 0
                                            stage = .prepare
                                            buttonTitile = "Дальше".localized
                                          },
                                          secondaryButton: .cancel(Text("Нет".localized))
                                    )
                                }
                            }
                            
                            
                            Spacer()
                            
                            
                            Button(action: {
                                testAction()
                            }, label: {
                                Text(buttonTitile)
                                    .mainFont(size: small ? 18 : 20)
                                    .foregroundColor(.white)
                                    .frame(width: 150)
                                    .padding(10)
                                    .background(stage == .test && disableButton ? Color.gray.cornerRadius(15) : Color.blue.cornerRadius(15))
                            })
                            .padding(.leading , !viewModel.stroopTestResult.isEmpty && stage == .finish ? -25 : 0)
                            .disabled(stage == .test && disableButton)
                            .padding(.bottom, small ? 10 : 0)
                            
                            Spacer()
                            
                        }
                       
                        .padding(.horizontal, 30)
                    }
                    .padding(.top, -50)
                    .background()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear{
                        viewModel.timeRemaining = 0
                        if viewModel.week != 1 {
                            stage = .test
                        } else if !viewModel.stroopTestResult.isEmpty {
                            stage = .finish
                            buttonTitile = "Назад".localized
                        }
                        
                      
                    }
                    .onDisappear{
                        if viewModel.week == 1 {
                            stage = .prepare
                        }
                        viewModel.startStroopTestTimer = false
                        colorsViewTag = -1
                        
                        if !viewModel.stroopTestResult.isEmpty{
                            viewModel.isStroopTestFinish = true
                        }
                }
        
    }
    
    func testAction(){
        
        switch stage {
        case .prepare:
            buttonTitile = "Старт".localized
            stage = .test
        case .test:
            if colorsViewTag == -1 {
                viewModel.startStroopTestTimer = true
                colorsViewTag = 0
                buttonTitile = "Дальше".localized
                disableButton = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    disableButton = false
                }
            } else if colorsViewTag < 5 {
                withAnimation{
                    colorsViewTag += 1
                    disableButton = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        disableButton = false
                    }
                }
            }
        case .finish:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                withAnimation(){
                    presentation.wrappedValue.dismiss()
                }
            }
        }
    }
    
    @ViewBuilder func stroopTestViews() -> some View {
        
        switch stage {
        case .prepare:
            StroopTestPreparing()
                .frame(height: screenSize.height * 0.7)
                .environmentObject(viewModel)
        case .test:
            StroopTesting(colorsViewTag: $colorsViewTag)
                .frame(height: screenSize.height * 0.7)
                .environmentObject(viewModel)
        case .finish:
            StroopFinish()
                .frame(height: screenSize.height * 0.7)
                .environmentObject(viewModel)
        }
    }
}




struct StrupTest_Previews: PreviewProvider {
    static var previews: some View {
        StroopTest()
            .environmentObject(ViewModel())
    }
}

