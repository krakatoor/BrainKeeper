//
//  colorsView.swift
//  BrainTrain
//
//  Created by Камиль  Сулейманов on 28.11.2020.
//

import SwiftUI


struct StrupTest: View {
    private var colums = Array(repeating: GridItem(.flexible(minimum: 100, maximum: 250),spacing: 0), count: 3)
    @State private var timeRemaining = 0
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.presentationMode) var presentation
    var body: some View {
        ZStack (alignment: .bottom){
            if !viewModel.startStrupTest {
                if viewModel.prepareStrupTesting{
                    VStack (spacing: 10){
                        
                        Image("thinkingBrain")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                       
                        
                        VStack (alignment: .leading, spacing: 0){
                            if viewModel.isStrupTestFinish{
                            Text("Тест завершён")
                                .font(.title)
                                .bold()
                            }
                            Text(viewModel.isStrupTestFinish ? viewModel.strupTestResult :  "Перед началом тестирования пройдите подготовку к нему.\n\nНазывайте в слух цвет слов, делая это как можно быстрее. Будьте внимательней вы должны не читать слова, а называть их цвет. Если ошиблись назовите цвет еще раз.")
                                .foregroundColor(.black)
                                .mainFont(size: 20)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.top)
                            
                            if !viewModel.isStrupTestFinish {
                            HStack {
                                Text("(Пример: если написано")
                                    .mainFont(size: 20)
                                Text("Красный,")
                                    .foregroundColor(.blue)
                                    .mainFont(size: 20)
                            }
                            .padding(.top)
                            
                            Text("говорите Синий.")
                                .mainFont(size: 20)
                            }
                        }
                        .padding(.horizontal)
                        
                        
                      Spacer()
                      
                        Button(action: {
                            timeRemaining = 0
                            viewModel.selectedStrupTag = 0
                            if viewModel.isStrupTestFinish {
                                presentation.wrappedValue.dismiss()
                            }
                            
                            viewModel.isStrupTestFinish = false
                                viewModel.startStrupTest = true
                           
                            
                        }, label: {
                            Text(viewModel.isStrupTestFinish  ? "Назад" : "Старт")
                                .mainFont(size: 20)
                                .foregroundColor(.white)
                                .frame(width:  viewModel.isStrupTestFinish  ? CGFloat(250) : 150)
                                .padding(10)
                                .background(Color.blue.cornerRadius(15))
                            
                        })
                       
                    }
                    
                    
                } else {
                    VStack (spacing: 10){
                        
                        Image("thinkingBrain")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                 
                        
                        VStack (spacing: 0){
                        Text("Вы дали правильные ответы: синий, чёрный, красный, зелёный, жёлтый?\n\nТеперь приступайте к упражнению.")
                            .mainFont(size: 18)
                            .foregroundColor(.black)
                            Spacer()
                            colorsView()
                            
                            Spacer()
                        
                        Button(action: {
                            timeRemaining = 0
                            viewModel.selectedStrupTag = 0
                                viewModel.startStrupTest = true
                            
                            
                        }, label: {
                            Text("Старт")
                                .mainFont(size: 20)
                                .foregroundColor(.white)
                                .frame(width: 150)
                                .padding(10)
                                .background(Color.blue.cornerRadius(15))
                        })
                        
                        }
                    }
                   
                }
            }
            
            VStack  (spacing: 20){
                
                colorsView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .opacity(viewModel.startStrupTest ? 1 : 0)
                
                
                if viewModel.startStrupTest && !viewModel.prepareStrupTesting{
                    timerView(result: $viewModel.strupTestResult, startTimer: $viewModel.startStrupTest)
                        .padding(.top, 10)
                }
                
                VStack {
                    HStack {
                        Button(action: {
                            viewModel.prepareStrupTesting = true
                                timeRemaining = 0
                                viewModel.selectedStrupTag = 0
                                viewModel.startStrupTest = false
                           
                            
                        }, label: {
                            Image(systemName: "xmark.circle")
                                .font(.title)
                                .foregroundColor(.black)
                        })
                        
                        
                        Spacer()
                        
                        Button(action: {
                            
                            if viewModel.prepareStrupTesting {
                                viewModel.prepareStrupTesting = false
                                viewModel.startStrupTest = false
                            } else {
                                if viewModel.selectedStrupTag ==  4 {
                                    viewModel.isStrupTestFinish = true
                                    viewModel.startStrupTest = false
                                    viewModel.prepareStrupTesting = true
                                }
                                viewModel.selectedStrupTag += 1
                            }
                            
                            
                        }, label: {
                            Text("Дальше")
                                .mainFont(size: 20)
                                .mainButton()
                                .padding(.leading, -20)
                        })
                       
                        Spacer()
                    }
                    .padding(.horizontal, 30)
                }
                .opacity(viewModel.startStrupTest ? 1 : 0)
                
            }
            
        }
        .navigationTitle(viewModel.startStrupTest ? "" : "Тест Струпа")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .environmentObject(viewModel)
        .background()
    }
    
}

struct StrupTest_Previews: PreviewProvider {
    static var previews: some View {
        StrupTest()
            .environmentObject(ViewModel())
    }
}

struct colorsView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var newColors = [Color(#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)),Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),Color(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)),Color(#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)),Color(#colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)),Color(#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)),Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),Color(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)),Color(#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)),Color(#colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1))]
    let colorsName = ["Синий","Красный","Зелёный","Жёлтый", "Чёрный"]
    @State private var selectedTag = 1
    
    var body: some View{
        
        if !viewModel.prepareStrupTesting && !viewModel.startStrupTest {
            
            VStack (spacing: 15){
                ForEach(0..<colorsName.count, id: \.self) { index in
                    Text(colorsName.reversed()[index])
                        .mainFont(size: 25)
                        .foregroundColor(colors[index])
                }
            }
            
        } else {
            VStack (alignment: .leading, spacing: 10){
                if viewModel.prepareStrupTesting && !viewModel.isStrupTestFinish {
                    ForEach(0..<colorsName.count, id: \.self) { index in
                        Text(colorsName.reversed()[index])
                            .mainFont(size: 25)
                            .foregroundColor(colors[index])
                    }
                    
                } else if !viewModel.prepareStrupTesting && viewModel.startStrupTest {
                    
                    TabView(selection: $viewModel.selectedStrupTag) {
                        
                        ForEach(0..<5) { index in
                            VStack (spacing: 10){
                            ForEach(0...9, id: \.self) {
                                Text(colorsName.randomElement()!)
                                    .mainFont(size: 25)
                                    .foregroundColor(newColors[$0])
                                    .onAppear{
                                        newColors = colors.shuffled()
                                    }
                            }
                        }
                        .tag(index)
                           
                        }
                       
                    }
                    .disabled(true)
                    .tabViewStyle(PageTabViewStyle())
                }
            }
            .animation(nil)
        }
    }
}

