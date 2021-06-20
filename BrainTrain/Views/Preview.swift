//
//  Preview.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 13.06.2021.
//

import SwiftUI

struct Preview: View {
    @EnvironmentObject var viewModel: ViewModel
    @AppStorage ("skipTutorial") var skipTutorial = false
    
    var body: some View {
        VStack {
            
          
            tutorialCard(skipTutorial: $skipTutorial)
          
           

        }
       

    }
}

struct Preview_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
    }
}

struct tutorialCard: View {
    @State private var selectedTag = 0
    @Binding var skipTutorial: Bool
    var body: some View {

        VStack {
            TabView(selection: $selectedTag) {
                ForEach(tutotialCards) { card in
                    VStack{
                        LottieView(name: card.lottie, loopMode: .loop, animationSpeed: 0.6)
                        .frame(height: 180)
                    
                    Text(card.headline)
                        .bold()
                        .mainFont(size: 18)
                        .foregroundColor(.white)
                        .padding(.top)
                    
                    
                    Text(card.text)
                        .mainFont(size: 16)
                        .foregroundColor(.white)
                        .padding(.top, 5)
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        VStack {
                            Button(action: {
                                if selectedTag < 1 {
                                    withAnimation (.spring()){
                                selectedTag += 1
                                }
                                }
                            }, label: {
                                Text("Дальше")
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .padding(.horizontal, 20)
                                    .background(Color.blue.cornerRadius(10))
                                   
                            })
                            
                            Button(action: {
                                skipTutorial.toggle()
                            }, label: {
                                HStack {
                                    Text("Больше не показывать")
                                        .foregroundColor(.primary)
                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(width: 20, height: 20)
                                        .overlay(
                                            ZStack {
                                                Rectangle().stroke(lineWidth: 0.5)
                                                    .foregroundColor(.primary)
                                                if skipTutorial {
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(.red)
                                                }
                                            }
                                               
                                        )
                                }
                            })

                            HStack {
                                ForEach(tutotialCards.indices) {index in
                                    Circle()
                                        .frame(width: index == selectedTag ? 10 : 5, height: index == selectedTag ? 10 : 5)
                                }
                            }
                            .offset(y: 40)
                        }
                        .frame(width: 300, height: 100)
                        .background(Color.white.clipShape(CustomCorner(corners: [.bottomLeft, .bottomRight])))
                        
                        
                    }
                    .frame(width: 300, height: 500)
                    .background(BlurView(style: .systemMaterialDark).cornerRadius(20))
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 1))
                    .tag(card.id)
                }
                }
                .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
        }
    
    }
}

struct Tutorial: Identifiable{
    let id: Int
    let lottie: String
    let headline: String
    let text: String
}

let tutotialCards: [Tutorial] = [
    Tutorial(id: 0, lottie: "tutorial1", headline: "Как трениировать мозг?", text: "Важно тренироваться регулярно. Чтобы ежедневные тренировки давали лучший результат, страйтесь выполнять их в одно и то же время. Лучше в первую половину дня, когда мозг работает активнее."),
    Tutorial(id: 1, lottie: "tutorial2", headline: "", text: "Выполняйте упражнения каждую неделю с понедельника по пятницу, а в субботу проверяйте работу лобных долей мозга.")
]
