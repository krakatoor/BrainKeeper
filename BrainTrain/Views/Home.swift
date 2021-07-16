//
//  Home.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 15.06.2021.
//

import SwiftUI
import UserNotifications

struct Home: View {
    @EnvironmentObject var viewModel: ViewModel
    //coreData
    @Environment(\.managedObjectContext) private var  viewContext
    @FetchRequest(entity: TestResult.entity(), sortDescriptors: [])
    private var testResults: FetchedResults<TestResult>
    //
    @State private var offset: CGFloat = .zero

    init() {
        UIScrollView.appearance().showsVerticalScrollIndicator = false
    }
    var body: some View {
        
     
            ZStack {
                if viewModel.currentView == .DateCard {
                    ProgressCard()
                        .zIndex(1)
                        .transition(.move(edge: .leading))
                        .environmentObject(viewModel)
                }
  
                TabView (selection: $viewModel.mainScreen){
                    ZStack{
                    FirstTestView()
                        .opacity(viewModel.currentView != .MathTest ? 1 : 0)
                        .environmentObject(viewModel)
                        
                    mathTest()
                        .environmentObject(viewModel)
                        .opacity(viewModel.currentView == .MathTest ? 1 : 0)
                        .padding(.top, 30)
                        .padding(.bottom)
                    }
                    .tag(1)
                    .rotation3DEffect(
                        .degrees(Double(getProgress()) * 90),
                        axis: (x: 0.0, y: 1.0, z: 0.0),
                        anchor: offset > 0 ? .leading : .trailing,
                        anchorZ: 0.0,
                        perspective: 0.6
                    )
                    .modifier(offsetModificator(anchorPoint: .leading, offset: $offset))
                    
                  TestResultsView()
                    .environmentObject(viewModel)
                        .tag(2)
                }
                .padding(.bottom, -30)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: viewModel.mainScreen == 1 && !viewModel.wordsTestTapped && !viewModel.stroopTestTapped ? .always : .never))
                .opacity(viewModel.currentView != .DateCard ? 1 : 0)
               
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background()
            .onAppear{
                
                //reset all data
                
//                viewModel.day = 1
//                viewModel.mathTestDay = 1
//                viewModel.isTestFinish = false
//                for i in testResults{
//                    viewContext.delete(i)
//                    do {
//                        try viewContext.save()
//                    } catch {return}
//                }
//
              

                
//                check if tests finish
                if viewModel.currentView == .DateCard {

                    for result in testResults{
                            if result.date == today {
                                if result.testName == "Тест на запоминание слов"{
                                    if viewModel.wordsTestResult.isEmpty {
                                        viewModel.wordsTestResult = result.testResult!
                                        viewModel.isWordsTestFinish = true
                                    }
                            }

                                if result.testName == "Тест Струпа"{
                                    if viewModel.stroopTestResult.isEmpty {
                                        viewModel.stroopTestResult = result.testResult!
                                        viewModel.isStroopTestFinish = true
                                    }
                                }

                                if result.testName == "Ежедневный тест"{
                                    if viewModel.mathTestResult.isEmpty {
                                        viewModel.mathTestResult = result.testResult!
                                        viewModel.isMathTestFinish = true
                                        
                                        if today != viewModel.currentDay {
                                            viewModel.day += 1
                                        }
                                    }
                                    
                                }
                        }

                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation{
                            if  viewModel.isWordsTestFinish &&  viewModel.isStroopTestFinish {
                                viewModel.currentView = .MathTest
                            } else  if viewModel.currentView == .DateCard && viewModel.brainTestsDay.contains(viewModel.day - 1) || viewModel.day == 1{
                            viewModel.currentView = .BrainTests
                            } else {
                                viewModel.currentView = .MathTest
                            }
                        }
                    }
            }
    
    }
    
    private func getProgress() -> CGFloat {
        let progress = offset / UIScreen.main.bounds.width
        return progress
    }
    
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Group{
        Home()
            Home()
                .environment(\.locale, .init(identifier: "eng"))
        }
            .environmentObject(ViewModel())
    }
}



