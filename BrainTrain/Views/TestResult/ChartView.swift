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
    @State private var correctAnswers = ""
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
                    Text(correctAnswers + "/\(viewModel.totalExample)")
                    
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
                
                ForEach(results.sorted{$0.day < $1.day}, id: \.self) { result in
                    VStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 30)
                            .overlay(
                                VStack{
                                    Spacer()
                                    Rectangle()
                                        .foregroundColor(result.result  > 1.0 ? .red : .orange)
                                        .frame(height: viewModel.startAnimation ? 0 : CGFloat(result.result > 1.0 ? 200 : result.result * 210))
                                }
                            )
                    }
                    .frame(height: viewHeight < 210 ? 210 : viewHeight * 210)
                    .onAppear {
                        let sorted = viewModel.results.sorted{$0 > $1}
                        viewHeight = CGFloat( sorted[0])
                    }
                    .onTapGesture {
                        correctAnswers = result.testResult ?? ""
                        showTime = result.result
                        showDetail.toggle()
                    }
                  
                }
                
                if results.count < 5 {
                    ForEach(results.count...4, id: \.self) { index in
                        VStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 30)
                                .overlay(
                                    VStack{
                                        Spacer()
                                        Rectangle()
                                            .foregroundColor(.orange)
                                            .frame(height: 0 )
                                    }
                                )
                        }
                        .frame(height: 210)
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



