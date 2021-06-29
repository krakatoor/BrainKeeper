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
  
    var body: some View {
        VStack {
            VStack {
                viewModel.stroopTestViews()
            }
                    .environmentObject(viewModel)
                    .padding(.top, 10)
                    .onChange(of: viewModel.colorsViewTag, perform: { value in
                        if value == 5 {
                            buttonTitile = "Назад"
                            viewModel.colorsViewTag = -1
                            viewModel.startStroopTestTimer = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                viewModel.stage = .finish
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
        .background()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear{
            if viewModel.week != 1 {
                viewModel.stage = .test
            }
        }
        .onDisappear{
            if viewModel.week == 1 {
            viewModel.stage = .prepare
            }
            viewModel.startStroopTestTimer = false
            viewModel.colorsViewTag = -1
            
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
        switch viewModel.stage {
        
        case .prepare:
            buttonTitile = "Начать"
            viewModel.stage = .test
        case .test:
            if viewModel.colorsViewTag == -1 {
            viewModel.startStroopTestTimer = true
                viewModel.colorsViewTag = 0
            buttonTitile = "Дальше"
            } else if viewModel.colorsViewTag < 5 {
                viewModel.colorsViewTag += 1
                print(viewModel.colorsViewTag)
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
    }

struct StrupTest_Previews: PreviewProvider {
    static var previews: some View {
        StroopTest()
            .environmentObject(ViewModel())
    }
}

