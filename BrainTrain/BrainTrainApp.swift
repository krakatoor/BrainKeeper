//
//  BrainTrainApp.swift
//  BrainTrain
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
                        if viewModel.startAnimation && viewModel.isMathTestFinish{
                            
                            viewModel.day += 1
                                viewModel.showDayCard = true
                                viewModel.startAnimation = true
                            
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
                                print("day + 1")
                            }
                        }
                  
               
                    }
                }
        }
        
    }
}
