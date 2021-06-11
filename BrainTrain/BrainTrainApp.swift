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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
