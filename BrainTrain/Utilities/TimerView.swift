//
//  TimerView.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 11.06.2021.
//

import SwiftUI

struct timerView: View {
    @EnvironmentObject var viewModel: ViewModel
    @Binding var result: String
    @Binding var startTimer: Bool
    var fontSize: CGFloat = 20
    var minus = false
    var isMathTest = false
    let timer = Timer.publish(every: 0.10, on: .main, in: .common).autoconnect()
 
    var body: some View {
        Text(minus ? "Осталось: \(timeString(time: viewModel.timeRemaining))" : "Время теста: \(timeString(time: viewModel.timeRemaining))")
            .font(.system(size: fontSize))
            .onChange(of: startTimer, perform: { value in
                if !value{
                    if isMathTest{
                        result = "Время теста: \(timeString(time: viewModel.timeRemaining)).\nПравильных ответов: \(viewModel.correctAnswers)"
                        viewModel.mathTestResultTime = viewModel.timeRemaining / 150
                        print("Done")
                    } else {
                        result = "Время теста: \(timeString(time: viewModel.timeRemaining))"
                    }
                }
            })
            .onReceive(timer){ _ in
                if startTimer {
                    if minus && timeString(time: viewModel.timeRemaining) == "00:00" {
                            timer.upstream.connect().cancel()
                        withAnimation (.spring()){
                        startTimer = false
                        }
                       
                    }
                    if !minus{
                        viewModel.timeRemaining += 0.10
                    } else {
                        if timeString(time: viewModel.timeRemaining) != "00:00" {
                            viewModel.timeRemaining -= 0.10
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


struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        timerView(result: .constant("2"), startTimer: .constant(true))
    }
}
