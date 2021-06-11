//
//  CounterTestView.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 11.06.2021.
//

import SwiftUI

struct CounterTestView: View {
    @State private var startCountTest = false
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            
            Image("timer")
                .resizable()
                .scaledToFit()
            
            timerView(result: $viewModel.countTestResult, startTimer: $startCountTest, fontSize: 25).environmentObject(viewModel)
                .padding()
            
            VStack {
            Text("Максимально быстро сосчитайте вслух от 1 до 120.")
                .mainFont(size: 20)
            
           
            Button(action: {
                startCountTest.toggle()
            },
                label: {
                    Text(startCountTest ? "Стоп" : (viewModel.countTestResult == "" ? "Старт" : "Продолжить"))
                        .mainButton()
                })
            .padding()
            .padding(.top, 40)
            
        
            }
            
          
            Spacer()
        }
        .navigationBarTitle("Тест на счет")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background()
    }
}

struct CounterTestView_Previews: PreviewProvider {
    static var previews: some View {
        CounterTestView()
            .environmentObject(ViewModel())
    }
}
