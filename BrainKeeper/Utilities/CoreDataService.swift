//
//  CoreDataViewModel.swift
//  BrainKeeper
//
//  Created by Камиль Сулейманов on 05.09.2021.
//

import SwiftUI
import CoreData


class CoreDataService: ObservableObject{
    
    static let shared = CoreDataService()
    
    let container: NSPersistentContainer
    @Published var testResults: [TestResult] = []
    
    private init() {
        container = NSPersistentCloudKitContainer(name: "CoreData")
        container.loadPersistentStores{ description, error in
            if let error = error {
                print("Error loading CoreData. \(error)")
            }
        }
        fetchTestResults()
    }
    
    func fetchTestResults(){
        let request = NSFetchRequest<TestResult>(entityName: "TestResult")
        
        do {
            testResults = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching data. \(error)")
        }
    }
    
    func save() {
        do{
            try container.viewContext.save()
            fetchTestResults()
        } catch let error {
            print("Error saving coredata. \(error)")
        }
    }
    
    func delete(_ result: TestResult) {
        container.viewContext.delete(result)
        save()
    }
}
