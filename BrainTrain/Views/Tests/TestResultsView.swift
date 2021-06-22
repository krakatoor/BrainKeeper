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
        VStack{
            Text("Результаты тестов")
                .bold()
                .mainFont(size: 25)
                .padding(.top, 30)
            ScrollView(showsIndicators: false) {
                ForEach(1...4, id: \.self) { week in
                    VStack {
                        Text("Неделя №\(week)")
                            .bold()
                            
                            .mainFont(size: 22)
                        ForEach(testResults.sorted{$0.isMathTest != $1.isMathTest}.filter{$0.week == String(week)}, id: \.self) { result in
                            resultCard(result: result)
                        }
                    }
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background()
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
    @State private var showDetail = false
    
    var body: some View {
        
        HStack {
            VStack (alignment: .leading){
                
                if result.isMathTest{
                    Text( "День " + (result.day ?? ""))
                        .bold()
                    Text("Дата прохождения теста: " + (result.date ?? ""))
                } else {
                    Text(result.testName ?? "")
                        .bold()
                }
                Text(result.testResult ?? "")
            }
            .padding()
            
            Spacer()
            
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
        .mainFont(size: 18)
        .padding(.horizontal)
        
    }
}
