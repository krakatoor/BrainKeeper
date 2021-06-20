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
    @Binding var timeRemaining: Int
    var fontSize: CGFloat = 20
    var minus = false
    let timer = Timer.publish(every: 0.017, on: .main, in: .common).autoconnect()
 
    var body: some View {
        Text(minus ? "Осталось: \(timeString(time: timeRemaining))" : "Время теста: \(timeString(time: timeRemaining))")
            .font(.system(size: fontSize))
            .onChange(of: startTimer, perform: { value in
                if !value{
                result = "Время теста: \(timeString(time: timeRemaining))"
                }
            })
            .onReceive(timer){ _ in
                if startTimer {
                    if minus && timeRemaining == 0 {
                        timer.upstream.connect().cancel()
                        startTimer = false
                    }
                    if !minus{
                    timeRemaining += 1
                    } else {
                        if timeRemaining != 0 {
                        timeRemaining -= 1
                        }
                    }
                } else {
                    timer.upstream.connect().cancel()
                   
                }
            }
    }
    func timeString(time: Int) -> String {
        let minutes   = Int(time) / 3600
        let seconds = Int(time) / 60 % 60
        
        return String(format:"%02i:%02i", minutes, seconds)
    }
}


struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        timerView(result: .constant("2"), startTimer: .constant(true), timeRemaining: .constant(0))
    }
}
