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
    @Environment(\.managedObjectContext) private var  viewContext
    @FetchRequest(entity: TestResult.entity(), sortDescriptors: [])
    private var testResults: FetchedResults<TestResult>
    @State private var buttonTitile = "Дальше"
    @State private var colorsViewTag = -1
    @State private var stage: StroopTestStages = .prepare
    var animation: Namespace.ID
    var body: some View {
        
        
        GeometryReader { geo in
            let y = geo.frame(in: .global).minY
            
            ZStack (alignment: Alignment(horizontal: .trailing, vertical: .top)){
                
                Image(systemName: "xmark.circle")
                    .font(.title)
                    .zIndex(1)
                    .padding(.trailing)
                    .padding(.top, -(y - 50))
                    .onTapGesture {
                        withAnimation(.spring()) {
                            viewModel.stroopTestTapped = false
                        }
                    }
                
                VStack {
                    stroopTestViews()
                        .transition(.slide)
                        .environmentObject(viewModel)
                        .onChange(of: y) { _ in
                            if y > 130 {
                                withAnimation(.spring()) {
                                    viewModel.stroopTestTapped = false
                                }
                            }
                        }
                        .onChange(of: colorsViewTag, perform: { value in
                            if value == 4 {
                                buttonTitile = "Стоп"
                            }
                            if value == 5 {
                                viewModel.startStroopTestTimer = false
                                buttonTitile = "Назад"
                                colorsViewTag = -1
                                viewModel.startStroopTestTimer = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
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
                                    do {
                                        for result in testResults{
                                            if result.date == testResult.date {
                                                if result.testName == testResult.testName{
                                                    viewContext.delete(result)
                                                }
                                            }
                                        }
                                        try viewContext.save()
                                    } catch {return}
                                    print("save stroop")
                                    viewModel.isStroopTestFinish = true
                                }
                            }
                        })
                    
                  
                        timerView(result: $viewModel.stroopTestResult, startTimer: $viewModel.startStroopTestTimer)
                            .environmentObject(viewModel)
                            .padding(.top, 10)
                            .opacity(stage == .test ? 1 : 0)
                   
                    
                    Spacer()
                    
                    HStack {
                        
                        if !viewModel.stroopTestResult.isEmpty  {
                            Button(action: {
                                viewModel.stroopTestResult = ""
                                viewModel.isStroopTestFinish = false
                                stage = .prepare
                                buttonTitile = "Дальше"
                            }, label: {
                                Image(systemName: "arrow.clockwise")
                                    .font(.title)
                            })
                        }
                        
                        Spacer()
                        
                        
                        Button(action: {
                            testAction()
                        }, label: {
                            Text(buttonTitile)
                                .mainButton()
                        })
                        .padding(.leading,  !viewModel.stroopTestResult.isEmpty  ? -20 : 0)
                        Spacer()
                        
                    }
                    .padding(.bottom)
                    .padding(.horizontal, 30)
                }
                .padding(.vertical, 20)
                .background()
                .matchedGeometryEffect(id: "background1", in: animation)
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
                    if viewModel.isWordsTestFinish && viewModel.isStroopTestFinish{
                        withAnimation(.linear){
                            viewModel.currentView = .MathTest
                            viewModel.timeRemaining = 0
                        }
                    }
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
            }
        case .finish:
            withAnimation(.spring()){
                viewModel.stroopTestTapped = false
            }
        }
    }
    
    @ViewBuilder func stroopTestViews() -> some View {
        
        switch stage {
        case .prepare:
            StroopTestPreparing(animation: animation)
        case .test:
            StroopTesting(colorsViewTag: $colorsViewTag)
                .environmentObject(viewModel)
        case .finish:
            StroopFinish(animation: animation)
        }
    }
}




struct StrupTest_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        StroopTest(animation: namespace)
            .environmentObject(ViewModel())
    }
}

