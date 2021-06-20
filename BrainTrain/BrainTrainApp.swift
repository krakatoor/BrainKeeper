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
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onChange(of: scenePhase) { _ in
                    persistenceController.save()
                }
        }
        
    }
}
