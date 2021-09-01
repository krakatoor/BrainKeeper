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
                Text("Тест пройден!".localized)
                    .font(.title2)
                    .bold()
                    Spacer()
                }
                Text("Следующй тест будет доступен завтра".localized)
                    .multilineTextAlignment(.leading)
                
              
                Text("Создать напоминание, чтобы не пропустить следующую тренировку?".localized)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
               
                
                Spacer()
                
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation{
                            hideCover.toggle()
                            if viewModel.saveChoice {
                                viewModel.hideFinishCover = true
                                viewModel.showNotification = false
                            }
                        }
                        
                    }, label: {
                        Text("Нет".localized)
                            .mainFont(size: small ? 18 : 20)
                            .foregroundColor(.white)
                            .frame(width: 120)
                            .padding(10)
                            .background(Color.red.cornerRadius(15))
                })
                    
                    Button(action: {
                        viewModel.showNotification = true
                        viewModel.sendNotification()
                        withAnimation{
                            hideCover.toggle()
                            if viewModel.saveChoice {
                                viewModel.hideFinishCover = true
                            }
                        }
                        
                    }, label: {
                        Text("Да".localized)
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

                    Text("Запомнить выбор".localized)
                    
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 20, height: 20)
                            .overlay(Rectangle().stroke(lineWidth: 0.5)).foregroundColor(.primary)
                           
                        
                        if viewModel.saveChoice {
                        Image(systemName: "checkmark")
                            .foregroundColor(.black)
                            .zIndex(1)
                        }
                    }
                   
                    
                    Spacer()

                }
                .padding(.top, 5)
                .contentShape(Rectangle())
                .onTapGesture {
                    DispatchQueue.main.async {
                        viewModel.saveChoice.toggle()
                    }
                       
                }
            }
            .padding()
            .background(BlurView(style: .regular).cornerRadius(15).shadow(radius: 5))
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 0.3))
            .frame(width: screenSize.width - 40, height: screenSize.height / 2)
            .padding(.bottom)
        }
    
}

struct MathTestFinish_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        MathTestFinish(hideCover: .constant(false))
            .environmentObject(ViewModel())
    }
}
