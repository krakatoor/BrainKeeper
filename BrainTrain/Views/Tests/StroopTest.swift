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
    @State private var buttonTitile = "Дальше"
    @State private var colorsViewTag = -1
    @State private var stage: StroopTestStages = .prepare
    @State private var showAlert = false
    var body: some View {
        
                    VStack {
                        stroopTestViews()
                            .background()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .transition(.slide)
                            .onChange(of: colorsViewTag, perform: { value in
                                if value == 4 {
                                    buttonTitile = "Стоп"
                                }
                                if value == 5 {
                                    viewModel.startStroopTestTimer = false
                                    buttonTitile = "Назад"
                                    colorsViewTag = -1
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        withAnimation{
                                            stage = .finish
                                        }
                                        let testResult = TestResult(context: viewContext)
                                        testResult.date = today
                                        testResult.week = String(viewModel.week)
                                        testResult.day = String(viewModel.day)
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
                                    Alert(title: Text("Начать тест заново?"), message: Text("При прохождении теста результаты будут заменены"),
                                          primaryButton: .destructive(Text("Да")) {
                                            viewModel.stroopTestResult = ""
                                            viewModel.timeRemaining = 0
                                            stage = .prepare
                                            buttonTitile = "Дальше"
                                          },
                                          secondaryButton: .cancel(Text("Нет"))
                                    )
                                }
                            }
                            
                            
                            Spacer()
                            
                            
                            Button(action: {
                                testAction()
                            }, label: {
                                Text(buttonTitile)
                                    .mainButton()
                            })
                            .padding(.leading , !viewModel.stroopTestResult.isEmpty && stage == .finish ? -25 : 0)
                            
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
                            buttonTitile = "Назад"
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
            buttonTitile = "Начать"
            stage = .test
        case .test:
            if colorsViewTag == -1 {
                viewModel.startStroopTestTimer = true
                colorsViewTag = 0
                buttonTitile = "Дальше"
            } else if colorsViewTag < 5 {
                withAnimation{
                    colorsViewTag += 1
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

