//
//  TestResultsView.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 17.06.2021.
//

import SwiftUI

struct TestResultsView: View {
    @Environment(\.managedObjectContext) private var  viewContext
    @FetchRequest(entity: TestResult.entity(), sortDescriptors: [])
    private var testResults: FetchedResults<TestResult>
    
    var body: some View {
        VStack {
     
                ForEach(testResults, id: \.self) { result in
          
                    resultCard(result: result)
                }
            }
        
    }
}

struct TestResultsView_Previews: PreviewProvider {
    static var previews: some View {
        TestResultsView()
    }
}

struct resultCard: View {
    @Environment(\.managedObjectContext) private var  viewContext
    var result: TestResult
    var body: some View {
        HStack {
            VStack (alignment: .leading){
                Text(result.testName ?? "")
                    .bold()
                
                
                Text("Дата прохождения теста: " + (result.date ?? ""))
                Text(result.testResult ?? "")
            }
            .padding()
            
            Image(systemName: "trash.circle.fill")
                .renderingMode(.original)
                .font(.title)
                .onTapGesture {
                    viewContext.delete(result)
                    do {
                        try viewContext.save()
                    } catch {return}
                }
        }
        
     
    }
}
