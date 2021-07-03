//
//  ChartsResult.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 02.07.2021.
//

import SwiftUI

struct ChartsResult: View {
    @Environment(\.managedObjectContext) private var  viewContext
    @FetchRequest(entity: TestResult.entity(), sortDescriptors: [])
    private var testResults: FetchedResults<TestResult>
    @EnvironmentObject var viewModel: ViewModel
    let days = ["1","2","3","4","5"]
    @Binding var currentWeek: Int
    @State private var results = [0.0, 0.0, 0.0, 0.0, 0.0]
    @State private var wordsTestResult = "Тест на запоминание слов"
    @State private var StroopTestResult = "Тест Струпа"
    var week: Int
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.blue)
                .frame(height: 25)
                .padding(.horizontal)
                .overlay(
                Text(wordsTestResult)
                    .foregroundColor(.black)
                    .leadingView()
                    .padding(.leading, 10)
                    
                )
         
            Rectangle()
                .fill(Color.green)
                .frame(height: 25)
                .padding(.horizontal)
                .overlay(
                    Text(StroopTestResult)
                        .foregroundColor(.black)
                    .leadingView()
                    .padding(.leading, 10)
                )
         
            
                VStack {
                    ZStack (alignment: .bottomLeading){
                        Text("Время")
                            .font(.caption2)
                            .offset(x: 40,y: -50)
                            .rotationEffect(.degrees(270))
                        
                        ChartView(results: $results)
                            .onChange(of: viewModel.isMathTestFinish, perform: { value in
                                if value {
                                    updateResult()
                                }
                            })
                        
                    }
                    
                    ZStack (alignment: .trailing){
                        Text("2мин.")
                            .offset(x: 60, y: -200)
                            .font(.caption2)
                        Text("1мин.")
                            .offset(x: 60, y: -100)
                            .font(.caption2)
                        
                        ZStack (alignment: .leading){
                            Text("Дни")
                                .font(.caption2)
                                .offset(x: -40, y: -20)
                            HStack (spacing: 35){
                                ForEach(days, id: \.self) {
                                    Text($0)
                                    
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .onAppear{
                    updateResult()
                }
              
        }
    }
    
    private func updateResult() {
        for result in testResults  {
            if result.week == String(week){
                if result.testName == "Тест на запоминание слов" {
                wordsTestResult = result.testResult!
                }
                
                if result.testName == "Тест Струпа"{
                StroopTestResult = result.testName! + " " + result.testResult!
                }
            if !results.contains(result.result) {
               results[Int(result.day!)! - 1] = result.result
                
            }
            }
        }
    }
    
}

struct ChartsResult_Previews: PreviewProvider {
    static var previews: some View {
        ChartsResult(currentWeek: .constant(1), week: 1)
            .environmentObject(ViewModel())
    }
}