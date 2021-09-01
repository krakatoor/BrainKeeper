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
    
    var week: Int
 
    var body: some View {
        let wordsTestResults = testResults.filter{$0.testName == "Тест на запоминание слов" && $0.week == String(week) }
        let stroopTestResults = testResults.filter{$0.testName == "Тест Струпа" && $0.week == String(week) }
        
        VStack {
            Rectangle()
                .fill(Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)))
                .frame(width: viewModel.startAnimation ? 0 : screenSize.width - 30,  height: 25)
                .leadingView()
                .overlay(
               
                    Text(viewModel.wordsTestResult.isEmpty ? "Тест не пройден".localized : "Слов запомнено: ".localized + (!wordsTestResults.isEmpty ? wordsTestResults[0].testResult! : viewModel.wordsTestResult))
                    .foregroundColor(.black)
                    .leadingView()
                    .padding(.leading, 10)
                )
               
         
            Rectangle()
                .fill(Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)))
                .frame(width: viewModel.startAnimation ? 0 : screenSize.width - 30,  height: 25)
                .leadingView()
                .overlay(
                    Text(viewModel.stroopTestResult.isEmpty ? "Тест не пройден".localized : "Тест Струпа: ".localized + (!stroopTestResults.isEmpty ? stroopTestResults[0].testResult! : viewModel.wordsTestResult))
                        .foregroundColor(.black)
                    .leadingView()
                    .padding(.leading, 10)
                )
            
            
                VStack {
                    
                    ZStack (alignment: .bottomLeading){
                        ChartView(week: week)
                            .environmentObject(viewModel)
                    
                    }
                    
                    
                    ZStack (alignment: .trailing){
                        Text("2мин.".localized)
                            .offset(x: 60, y: -200)
                            .font(.caption2)
                        Text("1мин.".localized)
                            .offset(x: 60, y: -100)
                            .font(.caption2)
                        
                        ZStack (alignment: .leading){
                            Text("Дни".localized)
                                .font(.caption2)
                                .offset(x: -50, y: -20)
                            HStack (spacing: 35){
                                ForEach(days, id: \.self) {
                                    Text($0)
                                    
                                }
                            }
                            
                            Text("Время".localized)
                                .font(.caption2)
                                .offset(x: 50,y:  -40)
                                .rotationEffect(.degrees(270))
                        }
                    }
                    
                }
                .padding()
            Spacer()
        }

    }
 
}

struct ChartsResult_Previews: PreviewProvider {
    static var previews: some View {
        ChartsResult(week: 1)
            .environmentObject(ViewModel())
    }
}
