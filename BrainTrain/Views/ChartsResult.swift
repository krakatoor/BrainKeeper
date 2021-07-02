//
//  ChartsResult.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 02.07.2021.
//

import SwiftUI
import Charts

struct ChartsResult: View {
    @Environment(\.managedObjectContext) private var  viewContext
    @FetchRequest(entity: TestResult.entity(), sortDescriptors: [])
    private var testResults: FetchedResults<TestResult>
    @EnvironmentObject var viewModel: ViewModel
    let days = ["1","2","3","4","5"]
    @Binding var currentWeek: Int
    @Binding var showDetail: Bool
    var week: Int
    
    var body: some View {
        VStack {
            if showDetail && week == currentWeek{
            VStack {
                ZStack (alignment: .bottomLeading){
                    Text("Время")
                        .font(.caption2)
                        .offset(x: 40,y: -50)
                        .rotationEffect(.degrees(270))
                    
                    Chart(data: viewModel.results.reversed())
                        .chartStyle(
                            ColumnChartStyle(column: Rectangle().foregroundColor(.orange), spacing: 5)
                        )
                        .frame(width: 200, height: 200)
                }
                
                ZStack (alignment: .trailing){
                    Text("2мин.")
                        .offset(x: 40, y: -200)
                        .font(.caption2)
                    Text("1мин.")
                        .offset(x: 40, y: -100)
                        .font(.caption2)
                    
                    ZStack (alignment: .leading){
                        Text("Дни")
                            .font(.caption2)
                            .offset(x: -40, y: -20)
                        HStack (spacing: 30){
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
                
                    if  currentWeek == viewModel.week {
                        showDetail = true
                    }
              
                for result in testResults{
                    if !viewModel.results.contains(result.result) {
                        viewModel.results[Int(result.day!)! - 1] = result.result
                       
                    }

                }
             
            }
            .onTapGesture {
                currentWeek = week
                showDetail.toggle()
        }
            }
        }
    }
}

struct ChartsResult_Previews: PreviewProvider {
    static var previews: some View {
        ChartsResult(currentWeek: .constant(1), showDetail: .constant(true), week: 1)
            .environmentObject(ViewModel())
    }
}
