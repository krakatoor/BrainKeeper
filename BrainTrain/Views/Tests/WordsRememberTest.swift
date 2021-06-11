//
//  WordsRememberTest.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 12.06.2021.
//

import SwiftUI

struct WordsRememberTest: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var startCountTest = false
    
    var body: some View {
        VStack {
            Text("В течении 2х минут постарайтесь запомнить как можно больше слов")
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, -30)
                .padding(.bottom, 20)
            
            VStack (alignment: .leading){
                ForEach(viewModel.firstWeekWords, id: \.self) {
                    Text($0)
                        .mainFont(size: 22)
                }
                
                
                timerView(result: $viewModel.wordsTest, startTimer: $startCountTest, timeRemaining: 7200, minus: true)
                    .padding(.top)
                Button(action: {
                    startCountTest.toggle()
                },
                    label: {
                        Text(startCountTest ? "Стоп" : (viewModel.countTestResult == "" ? "Старт" : "Продолжить"))
                            .mainButton()
                    })
                .padding()
            }
            Spacer()
        }
        .mainFont(size: 18)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background()
    }
}

struct WordsRememberTest_Previews: PreviewProvider {
    static var previews: some View {
        WordsRememberTest()
            .environmentObject(ViewModel())
    }
}
