//
//  WordsRememberTest.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 12.06.2021.
//

import SwiftUI
import Introspect

struct WordsRememberTest: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var startCount = false
    @State private var startTest = false
    @State private var word = ""
    @State private var error = false
    @State private var showAlert = false
    @State private var wordsAlreadyExist = false
    @State private var words: [String] = []
    @Environment(\.managedObjectContext) private var  viewContext
    @FetchRequest(entity: TestResult.entity(), sortDescriptors: [])
    private var testResults: FetchedResults<TestResult>
    var animation: Namespace.ID
    @StateObject var keyboard = KeyboardResponder()
    
    
    var body: some View {
        GeometryReader { geo in
            let y = geo.frame(in: .global).minY
            
            ZStack (alignment: Alignment(horizontal: .trailing, vertical: .top)){
                
                Image(systemName: "xmark.circle")
                    .font(.title)
                    .zIndex(1)
                    .padding(.trailing)
                    .padding(.top, -(y - 50))
                    .onTapGesture {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            withAnimation(.spring()) {
                                viewModel.wordsTestTapped = false
                            }
                        }
                    }
                
                VStack {
                    if !startTest && !viewModel.isWordsTestFinish {
                        VStack {
                            Text("Тест на запоминание слов")
                                .font(.title2)
                                .bold()
                                .padding(.top, small ? 0 : 20)
                                .matchedGeometryEffect(id: "Тест", in: animation)
                            
                            
                            
                            LottieView(name: "memory", loopMode: .loop, animationSpeed: 0.6)
                                .matchedGeometryEffect(id: "lamp", in: animation)
                                .frame(height: small ? 100 : 200)
                                .padding(.top)
                            
                            Text("В течении 2х минут постарайтесь запомнить как можно больше слов.")
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.bottom, 20)
                                .padding(.horizontal)
                            
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .center, spacing: 3) {
                                ForEach(words, id: \.self) {
                                    Text($0.capitalized)
                                        .mainFont(size: 22)
                                        .redacted(reason: !startCount ? .placeholder : [] )
                                        .onChange(of: startCount, perform: { value in
                                            if !startCount{
                                                withAnimation{
                                                    startTest = true
                                                }
                                            }
                                        })
                                    
                                }
                            }
                            
                            Spacer()
                            timerView(result: .constant(""), startTimer: $startCount, fontSize: small ? 20 : 25, minus: true)
                                .padding(.top)
                                .environmentObject(viewModel)
                            
                            
                            Button(action: {
                                startCount.toggle()
                                if !startCount {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        viewModel.timeRemaining = 120
                                    }
                                }
                                
                            },
                            label: {
                                Text( startCount ? "Дальше" :  "Старт")
                                    .mainButton()
                            })
                            .padding(.bottom, 20)
                        }
                        .padding(.vertical, 20)
                        
                    } else {
                        
                        VStack{
                            if !startCount && viewModel.wordsTestResult.isEmpty{
                                Text("Постарайтесь вписать как можно больше запомненных слов.")
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding()
                                    .padding(.top, small ? 0 : 18)
                                
                            }
                            VStack {
                                
                                if startCount {
                                    Text("Слов запомнено: \(viewModel.words.count)")
                                        .font(.title3)
                                        .padding(.top)
                                }
                                
                                ZStack {
                                    Text(error ? "Попробуйте другое слово" : " ")
                                        .foregroundColor(.red)
                                    
                                    Text(wordsAlreadyExist ? "Слово уже добавлено" : " ")
                                        .foregroundColor(.red)
                                }
                                
                                if viewModel.wordsTestResult.isEmpty {
                                    
                                    TextField("Введите слово", text: $word)
                                        .introspectTextField{ textfield in
                                            textfield.becomeFirstResponder()
                                        }
                                        .keyboardType(.twitter)
                                        .autocapitalization(.sentences)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .autocapitalization(.none)
                                        .padding()
                                        .disabled(!startCount)
                                        .contentShape(Rectangle())
                                        .onChange(of: word, perform: { value in
                                            if words.contains(word.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) && !viewModel.words.contains(word.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                                                viewModel.words.append(word)
                                                word = ""
                                            } else if viewModel.words.contains(word.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)){
                                                wordsAlreadyExist.toggle()
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                    wordsAlreadyExist.toggle()
                                                }
                                            }
                                        })
                                        .onTapGesture {
                                            startCount = true
                                            
                                        }
                                        .overlay(
                                            HStack {
                                                Spacer()
                                                Button(action: {word = ""}, label: {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .foregroundColor(.primary)
                                                        .padding(.trailing, 25)
                                                        .opacity(word.isEmpty ? 0 : 1)
                                                })
                                            })
                                }
                                ScrollView {
                                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .center, spacing: 3) {
                                        ForEach(viewModel.words, id: \.self) {
                                            Text($0)
                                                .mainFont(size: 22)
                                            
                                        }
                                    }
                                }
                            }
                            
                            
                            Spacer()
                            
                            if viewModel.wordsTestResult.isEmpty {
                                timerView(result: $viewModel.wordsTestResult, startTimer: $startCount, fontSize: 25, minus: true)
                                    .environmentObject(viewModel)
                                    .onChange(of: startCount, perform: { value in
                                        if !value {
                                            viewModel.isWordsTestFinish = true
                                            let testResult = TestResult(context: viewContext)
                                            testResult.date = today
                                            testResult.week = String(viewModel.week)
                                            testResult.day = String(viewModel.day)
                                            testResult.testName = "Тест на запоминание слов"
                                            testResult.testResult = "Слов запомнено: \(viewModel.words.count)"
                                            testResult.isMathTest = false
                                            viewModel.wordsTestResult = "Слов запомнено: \(viewModel.words.count)"
                                            do {
                                                for result in testResults{
                                                    if result.date == testResult.date {
                                                        if result.testName == testResult.testName{
                                                            viewContext.delete(result)
                                                        }
                                                    }
                                                    
                                                }
                                                
                                                try viewContext.save()
                                            } catch {return}
                                            print("words test saved")
                                        }
                                    })
                            } else {
                                VStack {
                                    
                                    LottieView(name: "memory", loopMode: .playOnce, animationSpeed: 0.6)
                                        .matchedGeometryEffect(id: "lamp", in: animation)
                                        .frame(height: 200)
                                    
                                    Text("Тест завершён")
                                        .font(.title)
                                        .bold()
                                    
                                    Text(viewModel.wordsTestResult)
                                        .font(.title)
                                        .padding(.bottom)
                                    
                                    
                                }
                            }
                            
                            HStack {
                                
                                
                                if !viewModel.wordsTestResult.isEmpty {
                                    
                                    Button(action: {
                                        showAlert = true
                                    }, label: {
                                        Image(systemName: "arrow.clockwise")
                                            .font(.title)
                                    })
                                    .alert(isPresented: $showAlert) {
                                        Alert(title: Text("Начать тест заново?"), message: Text("При прохождении теста результаты будут заменены"),
                                              primaryButton: .destructive(Text("Да")) {
                                                getWords()
                                                viewModel.wordsTestResult = ""
                                                startTest = false
                                                viewModel.isWordsTestFinish = false
                                                viewModel.words.removeAll()
                                                
                                                viewModel.timeRemaining = 120
                                              },
                                              secondaryButton: .cancel(Text("Нет"))
                                        )
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                            withAnimation() {
                                                viewModel.wordsTestTapped = false
                                            }
                                        }
                                        
                                        if viewModel.isStroopTestFinish{
                                            withAnimation(.linear){
                                                viewModel.currentView = .MathTest
                                            }
                                        }
                                    }, label: {
                                        Text("Назад" )
                                            .mainButton()
                                    })
                                    .padding(.leading, !viewModel.wordsTestResult.isEmpty  ? -20 : 0)
                                } else {
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        
                                        if startCount {
                                            if words.contains(word.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) && !viewModel.words.contains(word.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                                                viewModel.words.append(word)
                                                word = ""
                                            } else if viewModel.words.contains(word.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)){
                                                wordsAlreadyExist.toggle()
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                    wordsAlreadyExist.toggle()
                                                }
                                            } else {
                                                error.toggle()
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                    error.toggle()
                                                }
                                            }
                                        } else {
                                            
                                            startCount = true
                                        }
                                        
                                    },
                                    label: {
                                        
                                        Text(startCount ? "Добавить" : "Старт" )
                                            .mainButton()
                                        
                                    })
                                    .padding(.leading, !viewModel.wordsTestResult.isEmpty  ? -20 : 0)
                                }
                                
                                Spacer()
                            }
                            .padding(.bottom)
                            .padding(.horizontal, 30)
                            
                        }
                        .padding(.top, keyboard.currentHeight / 2.5)
                        .padding(.bottom, keyboard.currentHeight / 2.5)
                        .padding(.vertical, 20)
                        .transition(.move(edge: .trailing))
                        
                        
                    }
                    
                }
                .onAppear{
                    viewModel.timeRemaining = 120
                }
                .onDisappear{
                    viewModel.words.removeAll()
                    
                    if !viewModel.wordsTestResult.isEmpty{
                        viewModel.isWordsTestFinish = true
                    }
                    if viewModel.isWordsTestFinish && viewModel.isStroopTestFinish{
                        withAnimation(.linear){
                            viewModel.currentView = .MathTest
                        }
                    }
                }
                
            }
            .mainFont(size: 18)
            .background()
            .matchedGeometryEffect(id: "background", in: animation)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onChange(of: y) { _ in
                if y > 130 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        withAnimation {
                            viewModel.wordsTestTapped = false
                        }
                    }
                }
            }
            .onAppear{
                getWords()
            }
        }
        
    }
    
    func getWords() {
        if let fileWithWords = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let word = try? String(contentsOf: fileWithWords) {
                let newWords =  word.components(separatedBy: "\n")
                while words.count != 20 {
                    if let randomWord = newWords.randomElement() {
                        if !words.contains(randomWord){
                            words.append(randomWord)
                        }
                    }
                }
            }
        }
    }
}

struct WordsRememberTest_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        WordsRememberTest(animation: namespace)
            .environmentObject(ViewModel())
    }
}

