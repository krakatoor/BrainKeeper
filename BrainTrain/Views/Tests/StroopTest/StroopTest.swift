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
    @Environment(\.presentationMode) var presentation
    @Environment(\.managedObjectContext) private var viewContext
    @State private var buttonTitile = "Дальше"
  @State private var colorsViewTag = -1
    @State private var stage: StroopTestStages = .prepare
    var body: some View {
        VStack {
            
              stroopTestViews()
                    .transition(.slide)
                    .environmentObject(viewModel)
                    .padding(.top, 10)
                    .onChange(of: colorsViewTag, perform: { value in
                        if value == 5 {
                            buttonTitile = "Назад"
                            colorsViewTag = -1
                            viewModel.startStroopTestTimer = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                withAnimation{
                                stage = .finish
                                }
                              let testResult = TestResult(context: viewContext)
                              testResult.date = date
                                testResult.week = String(viewModel.week)
                                testResult.day = String(viewModel.day)
                              testResult.testName = "Тест Струпа"
                              testResult.testResult = viewModel.stroopTestResult
                                testResult.isMathTest = false
                              do {
                                  try viewContext.save()
                              } catch {return}
                                viewModel.isStroopTestFinish = true
                            }
                        }
                })
            
            if colorsViewTag != -1 {
                timerView(result: $viewModel.stroopTestResult, startTimer: $viewModel.startStroopTestTimer)
                .padding(.top, 10)
            }
            
            Spacer()
            
            Button(action: {
                testAction()
            }, label: {
                Text(buttonTitile)
                    .mainButton()
            })
            .padding(.bottom)
        }
        .navigationTitle("Тест Струпа")
        .navigationBarTitleDisplayMode(small ? .inline : .large)
        .background()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear{
            if viewModel.week != 1 {
               stage = .test
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
            if viewModel.isCountTestFinish && viewModel.isWordsTestFinish && viewModel.isStroopTestFinish{
                withAnimation(.linear){
                    viewModel.currentView = .MathTest
                }
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
                buttonTitile = "Дальше"
            }
            
        case .finish:
            presentation.wrappedValue.dismiss()
            if viewModel.isCountTestFinish && viewModel.isWordsTestFinish && viewModel.isStroopTestFinish{
                withAnimation(.linear){
                    viewModel.currentView = .MathTest
                }
            }
            
        }
    }
    
    @ViewBuilder func stroopTestViews() -> some View {

        switch stage {
        case .prepare:
           StroopTestPreparing()
        case .test:
            StroopTesting(colorsViewTag: $colorsViewTag)
        case .finish:
            StroopFinish()
        }
    }
    }




struct StrupTest_Previews: PreviewProvider {
    static var previews: some View {
        StroopTest()
            .environmentObject(ViewModel())
    }
}

