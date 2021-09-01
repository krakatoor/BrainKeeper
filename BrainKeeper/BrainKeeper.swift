//
//  BrainKeeperApp.swift
//  BrainKeeper
//
//  Created by Камиль on 20.10.2020.
//

import SwiftUI

@main
struct BrainTrainApp: App {
    let persistenceController = PersistenceController.shared
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var viewModel = ViewModel()
    @StateObject private var store = StoreKit()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(store)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onChange(of: scenePhase) { _ in
                    persistenceController.save()
                    
                    if scenePhase == .background {
                        
                        UIApplication.shared.applicationIconBadgeNumber = 0
                        
                        if  viewModel.isMathTestFinish{
                            if viewModel.currentDay != today {
                            viewModel.day += 1
                                print("day + 1")
                                viewModel.currentDay = today
                                DispatchQueue.main.async {
                                    viewModel.showDayCard = true
                                    viewModel.startAnimation = true
                                    viewModel.results =  [0.0, 0.0, 0.0, 0.0, 0.0]
                                    viewModel.isMathTestFinish = false
                                    viewModel.correctAnswers = 0
                                    viewModel.examplesCount = 0
                                    viewModel.isTestFinish = false
                                    if viewModel.weekChange {
                                        viewModel.isWordsTestFinish = false
                                        viewModel.wordsTestResult = ""
                                        viewModel.isStroopTestFinish = false
                                        viewModel.stroopTestResult = ""
                                    }
                                }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    withAnimation{
                                        viewModel.showDayCard = false
                                        viewModel.startAnimation = false
                                    }
                                }
                       
                            if  viewModel.mathTestDay == 4 {
                                viewModel.mathTestDay = 0
                                withAnimation{
                                    viewModel.weekChange = true
                                }
                                
                            } else {
                                viewModel.mathTestDay += 1
                                print("mathTestDay + 1")
                            }
                        }
                        }
               
                    }
                }
        }
        
    }
}
