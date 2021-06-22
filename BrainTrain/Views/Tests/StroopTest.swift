//
//  colorsView.swift
//  BrainTrain
//
//  Created by Камиль  Сулейманов on 28.11.2020.
//

import SwiftUI


struct StroopTest: View {
    private var colums = Array(repeating: GridItem(.flexible(minimum: 100, maximum: 250),spacing: 0), count: 3)
    @State private var timeRemaining = 0
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.presentationMode) var presentation
    @Environment(\.managedObjectContext) private var viewContext
    @State private var disableButton = false
   
    
    var body: some View {
        ZStack (alignment: .bottom){
            if !viewModel.startStroopTest {
                if viewModel.prepareStroopTesting && viewModel.week == 1{
                    VStack (spacing: 10){
                        
                        LottieView(name: "stroop", loopMode: .autoReverse, animationSpeed: 0.6)
                                   .frame(width: 250, height: 250)
                       
                        
                        VStack (alignment: .center, spacing: 0){
                            if !viewModel.stroopTestResult.isEmpty {
                            Text("Тест завершён")
                                .font(.title)
                                .bold()
                            }
                            Text(!viewModel.stroopTestResult.isEmpty ? "\(viewModel.stroopTestResult)\n\n Тест Струпа оценивает совместную работу передних частей лобных долей левого и правого полушарий. Скорость его выполнения завист от индивидуальных особенностей, поэтому никакие верменые рамки не устанавливаются. Возьмите за основу свой результат, полученый на предыдущей неделе." :  "Перед началом тестирования пройдите подготовку к нему.\n\nНазывайте в слух цвет слов, делая это как можно быстрее. Будьте внимательней вы должны не читать слова, а называть их цвет. Если ошиблись назовите цвет еще раз.")
                                .mainFont(size: 20)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.top)
                            
                            if viewModel.stroopTestResult.isEmpty {
                            HStack {
                                Text("(Пример: если написано")
                                    .mainFont(size: 20)
                                Text("Красный,")
                                    .foregroundColor(.blue)
                                    .mainFont(size: 20)
                            }
                            .padding(.top)
                            
                                HStack {
                                    Text("говорите Синий.)")
                                        .mainFont(size: 20)
                                        .padding(.leading)
                                    Spacer()
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        
                      Spacer()
                      
                        Button(action: {
                            timeRemaining = 0
                            viewModel.selectedStroopTag = 0
                            if !viewModel.stroopTestResult.isEmpty {
                                viewModel.isStroopTestFinish = true
                                let testResult = TestResult(context: viewContext)
                                testResult.date = date
                                  testResult.week = String(viewModel.week)
                                  testResult.day = String(viewModel.day)
                                testResult.testName = "Тест Струпа"
                                testResult.testResult = viewModel.countTestResult
                                testResult.isMathTest = false
                                do {
                                    try viewContext.save()
                                } catch {return}
                                presentation.wrappedValue.dismiss()
                            }
                            
                            viewModel.isStroopTestFinish = false
                                viewModel.startStroopTest = true
                           
                            
                        }, label: {
                            Text(!viewModel.stroopTestResult.isEmpty  ? "Назад" : "Старт")
                                .mainFont(size: 20)
                                .foregroundColor(.white)
                                .frame(width:  viewModel.isStroopTestFinish  ? CGFloat(250) : 150)
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
                        Text("Вы дали правильные ответы: синий, фиолетовый, красный, зелёный, жёлтый?\n\nТеперь приступайте к упражнению.")
                            .mainFont(size: 18)
                            .padding(.horizontal)
                            Spacer()
                            colorsView()
                            
                            Spacer()
                        
                        Button(action: {
                            timeRemaining = 0
                            viewModel.selectedStroopTag = 0
                            viewModel.startStroopTest = true
                            disableButton = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                disableButton = false
                            }
                            
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
                    .opacity(viewModel.startStroopTest ? 1 : 0)
                
                
                if viewModel.startStroopTest && !viewModel.prepareStroopTesting{
                    timerView(result: $viewModel.stroopTestResult, startTimer: $viewModel.startStroopTest, timeRemaining: $timeRemaining)
                        .padding(.top, 10)
                }
                
                VStack {
                    HStack {
                        Button(action: {
                            viewModel.prepareStroopTesting = true
                                timeRemaining = 0
                                viewModel.selectedStroopTag = 0
                                viewModel.startStroopTest = false
                           
                            
                        }, label: {
                            Image(systemName: "xmark.circle")
                                .font(.title)
                        })
                        
                        
                        Spacer()
                        
                        Button(action: {
                            
                            if viewModel.prepareStroopTesting {
                                viewModel.prepareStroopTesting = false
                                viewModel.startStroopTest = false
                      
                            } else {
                                if viewModel.selectedStroopTag ==  4 {
                                    viewModel.startStroopTest = false
                                    viewModel.prepareStroopTesting = true
                                }
                                viewModel.selectedStroopTag += 1
                                disableButton = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    disableButton = false
                                }
                            }
                            
                            
                        }, label: {
                            Text("Дальше")
                                .mainFont(size: 20)
                                .mainFont(size: 20)
                                .foregroundColor(.white)
                                .frame(width: 150)
                                .padding(10)
                                .background(viewModel.selectedStroopTag < 5 && disableButton ? Color.gray.cornerRadius(15) : Color.blue.cornerRadius(15))
                                .padding(.leading, -20)
                        })
                        .disabled(disableButton)
                       
                        Spacer()
                    }
                    .padding(.horizontal, 30)
                }
                .opacity(viewModel.startStroopTest ? 1 : 0)
                
            }
            
        }
        .onDisappear{
            if !viewModel.stroopTestResult.isEmpty{
            viewModel.isStroopTestFinish = true
            }
        }
        .navigationTitle(viewModel.startStroopTest ? "" : "Тест Струпа")
        .background()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .environmentObject(viewModel)
    }
    
}

struct StrupTest_Previews: PreviewProvider {
    static var previews: some View {
        StroopTest()
            .environmentObject(ViewModel())
    }
}

struct colorsView: View {
    @EnvironmentObject var viewModel: ViewModel
    let colors = [Color(#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)),Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)),Color(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)),Color(#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)),Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)),Color(#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)),Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)),Color(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)),Color(#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)),Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))]
    let colorsName = ["Синий","Красный","Зелёный","Жёлтый", "Фиолетовый"]
    @State private var selectedTag = 1
    
    var body: some View{
        if !viewModel.prepareStroopTesting && !viewModel.startStroopTest {
            
            VStack (spacing: 15){
                ForEach(0..<colorsName.count, id: \.self) { index in
                    Text(colorsName.reversed()[index])
                        .mainFont(size: 25)
                        .foregroundColor(colors[index])
                }
            }
            
        } else {
            VStack (alignment: .leading, spacing: 10){
                if viewModel.prepareStroopTesting && !viewModel.isStroopTestFinish {
                    ForEach(0..<colorsName.count, id: \.self) { index in
                        Text(colorsName.reversed()[index])
                            .mainFont(size: 25)
                            .foregroundColor(colors[index])
                    }
                    
                } else if !viewModel.prepareStroopTesting && viewModel.startStroopTest {
                    
                    TabView(selection: $viewModel.selectedStroopTag) {
                        
                        ForEach(0..<5) { index in
                            VStack (spacing: 10){
                            ForEach(0...9, id: \.self) {
                                Text(colorsName.randomElement()!)
                                    .mainFont(size: 25)
                                    .foregroundColor(colors[$0])
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

