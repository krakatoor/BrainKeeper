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
    @State private var wordsTestResult = "Тест на запоминание слов - не пройден"
    @State private var StroopTestResult = "Тест Струпа - не пройден"
    @State private var startAnimation = true
    @State private var correctAnswers = ""
    var week: Int
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.blue)
                .frame(width: startAnimation ? 0 : screenSize.width - 30,  height: 25)
                .leadingView()
                .overlay(
                Text(wordsTestResult)
                    .foregroundColor(.black)
                    .leadingView()
                    .padding(.leading, 10)
                )
         
            Rectangle()
                .fill(Color.green)
                .frame(width: startAnimation ? 0 : screenSize.width - 30,  height: 25)
                .leadingView()
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
                        
                        ChartView(results: $results, correctAnswers: correctAnswers)
                            .environmentObject(viewModel)
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
                                .offset(x: -50, y: -20)
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.linear) {
                            startAnimation = false
                        }
                    }
                }
        }
    }
    
    private func updateResult() {
        
        testResults.forEach  { result in 
            
            if result.week == String(week){
                
                if result.testName == "Тест на запоминание слов" {
                wordsTestResult = result.testResult!
                }
                
                if result.testName == "Тест Струпа"{
                StroopTestResult = result.testName! + ": " + result.testResult!
                }
                
                if !results.contains(result.result) {
               results[Int(result.day!)! - 1] = result.result
                correctAnswers = result.testResult!
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
