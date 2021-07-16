//
//  MathTestFinish.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 01.07.2021.
//

import SwiftUI

struct MathTestFinish: View {
    @Binding var hideCover: Bool
    @State private var showNotificationToggle = false
    var animation: Namespace.ID
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
                
                HStack {
                    Spacer()

                    Text("Больше не показывать")
                    
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 20, height: 20)
                            .overlay(Rectangle().stroke(lineWidth: 0.5)).foregroundColor(.primary)
                           
                        
                        if showNotificationToggle{
                        Image(systemName: "checkmark")
                            .matchedGeometryEffect(id: "deskclock", in: animation)
                        }
                    }
                    .onTapGesture {
                        showNotificationToggle.toggle()
                        withAnimation(){
                        viewModel.showNotificationCover.toggle()
                        }
                    }
                    
                    Spacer()

                }
                .padding(.top, 5)

            }
            .padding()
            .background(BlurView(style: .regular).cornerRadius(15).shadow(radius: 5))
            .frame(width: screenSize.width - 40, height: screenSize.height / 2)
            .padding(.bottom)
        }
    
}

struct MathTestFinish_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        MathTestFinish(hideCover: .constant(false), animation: namespace)
            .environmentObject(ViewModel())
    }
}
