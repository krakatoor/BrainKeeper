//
//  BrainKeeperApp.swift
//  BrainKeeper
//
//  Created by Камиль on 20.10.2020.
//

import SwiftUI

@main
struct BrainTrainApp: App {
    @StateObject private var homeVM = HomeViewModel()
    @StateObject private var viewModel = ViewModel()
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            Home()
                .environmentObject(viewModel)
                .environmentObject(homeVM)
                .onChange(of: scenePhase) { _ in
                    if scenePhase == .background {
                        checkCurrentDate()
                    }
                }
        }
        
    }
    
    private func checkCurrentDate() {
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        if  viewModel.isMathTestFinish{
            if viewModel.currentDay != today {
                viewModel.day += 1
                print("day + 1")
                viewModel.currentDay = today
                DispatchQueue.main.async {
                    homeVM.showLoadingScreen = true
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
                        homeVM.showLoadingScreen = false
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
                }
            }
        }
    }
}
