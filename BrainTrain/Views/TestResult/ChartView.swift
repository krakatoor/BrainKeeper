//
//  ChartView.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 03.07.2021.
//

import SwiftUI

struct ChartView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var showTime = 0.0
    @State private var showDetail = false
    @State private var viewHeight: CGFloat = 200
    @Environment(\.managedObjectContext) private var  viewContext
    @FetchRequest(entity: TestResult.entity(), sortDescriptors: [])
    private var testResults: FetchedResults<TestResult>
    var week: Int
    var body: some View {
        let results = testResults.filter({$0.isMathTest && $0.week == String(week)})
        ZStack (alignment: .top){
            
            if showDetail{

                VStack (spacing: 5){
                    Text("Время теста: " + timeString(time: showTime * 150)) 
                    Text(viewModel.mathTestResult + "/\(viewModel.totalExample)")
                    
                }
                .mainFont(size: 15)
                .padding(8)
                .background(BlurView(style: .regular).cornerRadius(10).shadow(color: Color.primary.opacity(0.5), radius: 3, x: 0, y: 0))
                .zIndex(1)
                .onTapGesture {
                    showDetail.toggle()
            }
            }
            
            HStack (spacing: 15){
                ForEach(results, id: \.self) { chart in
                    VStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 30)
                            .overlay(
                                VStack{
                                    Spacer()
                                    Rectangle()
                                        .foregroundColor(chart.result > 1.0 ? .red : .orange)
                                        .frame(height: viewModel.startAnimation ? 0 : CGFloat(chart.result > 1.0 ? 200 : chart.result * 210))
                                }
                            )
                    }
                    .frame(height: viewHeight < 210 ? 210 : viewHeight * 210)
                    .onAppear {
                        let sorted = results.map{$0.result}.sorted{$0 > $1}
                        viewHeight = CGFloat( sorted[0])
                    }
                    .onTapGesture {
                        showTime = chart.result
                        showDetail.toggle()
                    }
                }
            }
        }
        
        
    }
    func timeString(time: Double) -> String {
        let minutes   = Int(time) / 60
        let seconds = Int(time) - Int(minutes) * 60
        
        return String(format:"%02i:%02i", minutes, seconds)
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(week: 1)
            .environmentObject(ViewModel())
    }
}
