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
  

    init() {
        UIScrollView.appearance().showsVerticalScrollIndicator = false
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
           UINavigationBar.appearance().shadowImage = UIImage()       
    }
    var body: some View {
        
        NavigationView {
            ZStack {
                if viewModel.currentView == .DateCard {
                    ProgressCard()
                        .zIndex(1)
                        .transition(.move(edge: .leading))
                        .environmentObject(viewModel)
                }
  
                    FirstTestView()
                        .opacity(viewModel.currentView != .MathTest ? 1 : 0)
                        .environmentObject(viewModel)
                
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
                       
                            viewModel.currentView = .BrainTests
                            
                        }
                    }
            }
            .padding(.top, -50)
    }
        .accentColor(.primary)
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



