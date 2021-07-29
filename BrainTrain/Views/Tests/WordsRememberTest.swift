//
//  WordsRememberTest.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 12.06.2021.
//

import SwiftUI
import Introspect

struct WordsRememberTest: View {
    @Environment (\.locale) var locale
    @EnvironmentObject var viewModel: ViewModel
    @Environment (\.presentationMode) private var presentation
    @State private var startCount = false
    @State private var startTest = false
    @State private var word = ""
    @State private var error = false
    @State private var showAlert = false
    @State private var wordsAlreadyExist = false
    @State private var words: [String] = []
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: TestResult.entity(), sortDescriptors: [])
    private var testResults: FetchedResults<TestResult>
    
    var body: some View {
        VStack {
            
            if !startTest && viewModel.wordsTestResult.isEmpty {
                VStack {
                    Text("Тест на запоминание слов".localized)
                        .font(.title2)
                        .bold()
                        .padding(.top, small ? 0 : 20)
                    
                    
                    LottieView(name: "memory", loopMode: .loop, animationSpeed: 0.6)
                        .frame(height: small ? 100 : 200)
                        .padding(.top)
                    
                    Text("В течении 2х минут постарайтесь запомнить как можно больше слов.".localized)
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
                                viewModel.timeRemaining = 12
                            }
                        }
                        
                    },
                    label: {
                        Text( startCount ? "Дальше".localized :  "Старт".localized)
                            .mainButton()
                    })
                }
                .padding(.vertical, 20)
                
            } else {
                
                VStack{
                    if !startCount && viewModel.wordsTestResult.isEmpty{
                        Text("Постарайтесь вписать как можно больше запомненных слов.".localized)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding()
                            .padding(.top, small ? 0 : 18)
                        
                    }
                    VStack {
                        
                        if startCount {
                            HStack{
                            Text("Слов запомнено:".localized)
                                Text("\(viewModel.words.count)")
                            }
                                .font(.title3)
                                .padding(.top)
                        }
                        
                        ZStack {
                            Text(error ? "Попробуйте другое слово".localized : " ")
                                .foregroundColor(.red)
                            
                            Text(wordsAlreadyExist ? "Слово уже добавлено".localized : " ")
                                .foregroundColor(.red)
                        }
                        
                        if viewModel.wordsTestResult.isEmpty {
                            
                            TextField("Введите слово".localized, text: $word)
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
                                    if words.contains(word.firstUppercased.trimmingCharacters(in: .whitespacesAndNewlines)) && !viewModel.words.contains(word.firstUppercased.trimmingCharacters(in: .whitespacesAndNewlines)) {
                                        viewModel.words.append(word.firstUppercased.trimmingCharacters(in: .whitespacesAndNewlines))
                                        word = ""
                                    } else if viewModel.words.contains(word.firstUppercased.trimmingCharacters(in: .whitespacesAndNewlines)){
                                        wordsAlreadyExist.toggle()
                                        word = ""
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
                        
                        
                        if viewModel.wordsTestResult.isEmpty {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .center, spacing: 3) {
                                ForEach(viewModel.words, id: \.self) {
                                    Text($0)
                                        .mainFont(size: 22)
                                    
                                }
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
                                    testResult.day = Double(viewModel.day)
                                    testResult.testName = "Тест на запоминание слов"
                                    testResult.testResult = "\(viewModel.words.count)"
                                    testResult.isMathTest = false
                                    viewModel.wordsTestResult = "\(viewModel.words.count)"
                                   
                                        for result in testResults{
                                            if result.date == testResult.date {
                                                if result.testName == testResult.testName{
                                                    viewContext.delete(result)
                                                }
                                            }
                                            
                                        }
                                    
                                    do {try viewContext.save() } catch { return }
                                    print("words test saved")
                                }
                            })
                            .onChange(of: viewModel.words) { value in
                                if value.count == 20 {
                                    withAnimation{
                                    startCount = false
                                    }
                                }
                            }
                    } else {
                        VStack {
                            
                            LottieView(name: "memory", loopMode: .playOnce, animationSpeed: 0.6)
                                .frame(height: 200)
                            
                            Text("Тест завершён".localized)
                                .font(.title)
                                .bold()
                            
                            Text("Слов запомнено:".localized + " " + viewModel.wordsTestResult)
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
                                Alert(title: Text("Начать тест заново?".localized), message: Text("При прохождении теста результаты будут заменены".localized),
                                      primaryButton: .destructive(Text("Да")) {
                                        getWords()
                                        viewModel.words.removeAll()
                                        viewModel.timeRemaining = 12
                                        withAnimation{
                                            startTest = false
                                            viewModel.wordsTestResult = ""
                                        
                                        }
                                      },
                                      secondaryButton: .cancel(Text("Нет".localized))
                                )
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                    withAnimation() {
                                        presentation.wrappedValue.dismiss()
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
                                    if words.contains(word.firstUppercased.trimmingCharacters(in: .whitespacesAndNewlines)) && !viewModel.words.contains(word.firstUppercased.trimmingCharacters(in: .whitespacesAndNewlines)) {
                                        viewModel.words.append(word.firstUppercased.trimmingCharacters(in: .whitespacesAndNewlines))
                                        word = ""
                                    } else if viewModel.words.contains(word.firstUppercased.trimmingCharacters(in: .whitespacesAndNewlines)){
                                        wordsAlreadyExist.toggle()
                                        word = ""
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
                                
                                Text(startCount ? "Добавить".localized : "Старт".localized)
                                    .mainButton()
                                
                            })
                            .padding(.leading, !viewModel.wordsTestResult.isEmpty  ? -20 : viewModel.timeRemaining < 60 && viewModel.timeRemaining != 0 ? 35 : 0)
                        }
                        
                        Spacer()
                        
                        if viewModel.wordsTestResult.isEmpty && viewModel.timeRemaining < 60 {
                            Button(action: {withAnimation{ viewModel.timeRemaining = 0 }}, label: {
                            Image(systemName: "exclamationmark.arrow.circlepath".localized)
                                .font(.title)
                                .foregroundColor(.red)
                        })
                            .transition(.move(edge: .bottom))
                       

                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 5)
                    
                }
                .padding(.vertical, 20)
                .transition(.move(edge: .trailing))
                
            }
            
        }
        .padding(.bottom, -15)
        .onAppear{
            viewModel.timeRemaining = 12
        }
        
        .navigationBarTitleDisplayMode(.inline)
        .padding(.top, -50)
        .mainFont(size: 18)
        .background()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear{
            getWords()
        }
    }
    
    func getWords() {
        if let fileWithWords = Bundle.main.url(forResource: locale.identifier ==  "en" ? "wordsEng" : "words", withExtension: "txt") {
            if let word = try? String(contentsOf: fileWithWords) {
                let newWords =  word.components(separatedBy: "\n")
                while words.count != 20 {
                    if let randomWord = newWords.randomElement() {
                        if !words.contains(randomWord.firstUppercased){
                            words.append(randomWord.firstUppercased)
                        }
                    }
                }
            }
        }
    }
}

struct WordsRememberTest_Previews: PreviewProvider {
    static var previews: some View {
        WordsRememberTest()
            .environmentObject(ViewModel())
    }
}

