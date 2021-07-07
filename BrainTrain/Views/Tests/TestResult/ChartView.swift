//
//  ChartView.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 03.07.2021.
//

import SwiftUI

struct ChartView: View {
    @Binding var results: [Double]
    @State private var showTime = 0.0
    @State private var showDetail = false
    @State private var viewHeight: CGFloat = 200
    @State private var startAnimation = true
     var correctAnswers = ""

    var body: some View {
        
        ZStack (alignment: .top){
            
            if showDetail{

                VStack (spacing: 5){
                    Text("Время теста: " + timeString(time: showTime * 150)) 
                    Text(correctAnswers)
                    
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
                                        .foregroundColor(chart > 1.0 ? .red : .orange)
                                        .frame(height: startAnimation ? 0 : CGFloat(chart > 1.0 ? 200 : chart * 210))
                                }
                            )
                    }
                    .frame(height: viewHeight < 210 ? 210 : viewHeight * 210)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.linear) {
                                startAnimation = false
                            }
                        }
                        let sorted = results.sorted{$0 > $1}
                        viewHeight = CGFloat( sorted[0])
                    }
                    .onTapGesture {
                        showTime = chart
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
        ChartView(results: .constant([0.8, 2.3, 1.6, 4.7, 2,4]))
    }
}
