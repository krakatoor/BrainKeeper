//
//  MathTestFinish.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 01.07.2021.
//

import SwiftUI

struct MathTestFinish: View {
    @Binding var hideCover: Bool
    @EnvironmentObject var viewModel: ViewModel
        var body: some View {
            VStack (alignment: .leading, spacing: 10){
                LottieView(name: "MathFinish", loopMode: .playOnce, animationSpeed: 1)
                           .frame(height: 200)
                
                HStack {
                    Spacer()
                Text("Тест пройден!")
                    .font(.title2)
                    .bold()
                    Spacer()
                }
                Text("Следующй тест будет доступен завтра")
                    .multilineTextAlignment(.leading)
                
              
                    Text("Создать напоминание,чтобы не пропустить следующую тренировку?")
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
               
                
                Spacer()
                
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation{
                            hideCover.toggle()
                        }
                        
                    }, label: {
                        Text("Нет")
                            .mainFont(size: small ? 18 : 20)
                            .foregroundColor(.white)
                            .frame(width: 120)
                            .padding(10)
                            .background(Color.red.cornerRadius(15))
                })
                    
                    Button(action: {
                        viewModel.sendNotification()
                        withAnimation{
                            hideCover.toggle()
                        }
                        
                    }, label: {
                        Text("Да")
                            .mainFont(size: small ? 18 : 20)
                            .foregroundColor(.white)
                            .frame(width: 120)
                            .padding(10)
                            .background(Color.blue.cornerRadius(15))
                })
                    Spacer()
                }

            }
            .padding()
            .background(BlurView(style: .regular).cornerRadius(15).shadow(radius: 5))
            .frame(width: screenSize.width - 40, height: screenSize.height / 2)
            .padding(.bottom)
        }
    
}

struct MathTestFinish_Previews: PreviewProvider {
    static var previews: some View {
        MathTestFinish(hideCover: .constant(false))
            .environmentObject(ViewModel())
    }
}
