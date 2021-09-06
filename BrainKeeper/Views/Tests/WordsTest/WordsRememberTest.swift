//
//  WordsRememberTest.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 12.06.2021.
//

import SwiftUI
import Introspect

struct WordsRememberTest: View {
    @StateObject private var vm = WordsTestViewModel()
    @EnvironmentObject var viewModel: ViewModel
    @Environment (\.presentationMode) private var presentation
    @EnvironmentObject private var coreData: CoreDataService
    
    var body: some View {
        VStack {
            
            if !vm.startTest && viewModel.wordsTestResult.isEmpty {
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
                        ForEach(vm.words, id: \.self) {
                            Text($0.capitalized)
                                .mainFont(size: 22)
                                .redacted(reason: !vm.startCount ? .placeholder : [] )
                                .onChange(of: vm.startCount, perform: { value in
                                    if !vm.startCount{
                                        withAnimation{
                                            vm.startTest = true
                                         
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            viewModel.timeRemaining = 120
                                        }
                                   
                                    }
                                })
                            
                        }
                    }
                    
                    Spacer()
                    timerView(result: .constant(""), startTimer: $vm.startCount, fontSize: small ? 20 : 25, minus: true)
                        .padding(.top)
                        .environmentObject(viewModel)
                    
                    
                    Button(action: {
                        vm.startCount.toggle()
                        if !vm.startCount {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                viewModel.timeRemaining = 120
                            }
                        }
                        
                    },
                    label: {
                        Text( vm.startCount ? "Дальше".localized :  "Старт".localized)
                            .mainButton()
                    })
                    
                }
                .padding(.vertical, 20)
                
            } else {
                
                VStack{
                    if !vm.startCount && viewModel.wordsTestResult.isEmpty{
                        Text("Постарайтесь вписать как можно больше запомненных слов.".localized)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding()
                            .padding(.top, small ? 0 : 18)
                        
                    }
                    VStack {
                        
                        if vm.startCount {
                            HStack{
                            Text("Слов запомнено:".localized)
                                Text("\(viewModel.words.count)")
                            }
                                .font(.title3)
                                .padding(.top)
                        }
                        
                        ZStack {
                            Text(vm.error ? "Попробуйте другое слово".localized : " ")
                                .foregroundColor(.red)
                            
                            Text(vm.wordsAlreadyExist ? "Слово уже добавлено".localized : " ")
                                .foregroundColor(.red)
                        }
                        
                        if viewModel.wordsTestResult.isEmpty {
                            
                            TextField("Введите слово".localized, text: $vm.word)
                                .introspectTextField{ textfield in
                                    textfield.becomeFirstResponder()
                                }
                                .keyboardType(.twitter)
                                .autocapitalization(.sentences)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .autocapitalization(.none)
                                .padding()
                                .disabled(!vm.startCount)
                                .contentShape(Rectangle())
                                .onChange(of: vm.word, perform: { value in
                                    if vm.words.contains(vm.word.firstUppercased.trimmingCharacters(in: .whitespacesAndNewlines)) && !viewModel.words.contains(vm.word.firstUppercased.trimmingCharacters(in: .whitespacesAndNewlines)) {
                                        viewModel.words.append(vm.word.firstUppercased.trimmingCharacters(in: .whitespacesAndNewlines))
                                        vm.word = ""
                                    } else if viewModel.words.contains(vm.word.firstUppercased.trimmingCharacters(in: .whitespacesAndNewlines)){
                                        vm.wordsAlreadyExist.toggle()
                                        vm.word = ""
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            vm.wordsAlreadyExist.toggle()
                                        }
                                    } else if vm.word.count > 15 {
                                        vm.error.toggle()
                                        vm.word = ""
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            vm.error.toggle()
                                        }
                                    }
                                })
                                .onTapGesture {
                                    vm.startCount = true
                                    
                                }
                                .overlay(
                                    HStack {
                                        Spacer()
                                        Button(action: { vm.word = ""}, label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.primary)
                                                .padding(.trailing, 25)
                                                .opacity(vm.word.isEmpty ? 0 : 1)
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
                        timerView(result: $viewModel.wordsTestResult, startTimer: $vm.startCount, fontSize: 25, minus: true)
                            .environmentObject(viewModel)
                            .onChange(of: vm.startCount, perform: { value in
                                if !value {
                                    viewModel.isWordsTestFinish = true
                                    let testResult = TestResult(context: coreData.container.viewContext)
                                    testResult.date = today
                                    testResult.week = String(viewModel.week)
                                    testResult.day = Double(viewModel.day)
                                    testResult.testName = "Тест на запоминание слов"
                                    testResult.testResult = "\(viewModel.words.count)"
                                    testResult.isMathTest = false
                                    viewModel.wordsTestResult = "\(viewModel.words.count)"
                                   
                                    for result in coreData.testResults{
                                            if result.week == testResult.week {
                                                if result.testName == testResult.testName{
                                                    coreData.delete(result)
                                                }
                                            }
                                            
                                        }
                                    
                                    coreData.save()
                                    print("words test saved")
                                }
                            })
                            .onChange(of: viewModel.words) { value in
                                if value.count == 20 {
                                    withAnimation{
                                        vm.startCount = false
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
                    
                    ZStack (alignment: .topTrailing){
                        
                        if viewModel.wordsTestResult.isEmpty && viewModel.timeRemaining < 60 &&  viewModel.timeRemaining > 57 {
                            Text("Завершить тест?".localized)
                            .transition(.move(edge: .bottom))
                            .offset(y: -70)
                            .padding(.trailing)
                        }
                        
                      
                    HStack {
                        
                        if !viewModel.wordsTestResult.isEmpty {
                            
                            Button(action: {
                                vm.showAlert = true
                            }, label: {
                                Image(systemName: "arrow.clockwise")
                                    .font(.title)
                            })
                            .alert(isPresented: $vm.showAlert) {
                                Alert(title: Text("Начать тест заново?".localized), message: Text("При прохождении теста результаты будут заменены".localized),
                                      primaryButton: .destructive(Text("Да")) {
                                        getWords()
                                        viewModel.words.removeAll()
                                        viewModel.timeRemaining = 120
                                        withAnimation{
                                            vm.startTest = false
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
                                
                                if vm.startCount {
                                    if vm.words.contains(vm.word.firstUppercased.trimmingCharacters(in: .whitespacesAndNewlines)) && !viewModel.words.contains(vm.word.firstUppercased.trimmingCharacters(in: .whitespacesAndNewlines)) {
                                        viewModel.words.append(vm.word.firstUppercased.trimmingCharacters(in: .whitespacesAndNewlines))
                                        vm.word = ""
                                    } else if viewModel.words.contains(vm.word.firstUppercased.trimmingCharacters(in: .whitespacesAndNewlines)){
                                        vm.wordsAlreadyExist.toggle()
                                        vm.word = ""
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            vm.wordsAlreadyExist.toggle()
                                        }
                                    } else {
                                        vm.error.toggle()
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            vm.error.toggle()
                                        }
                                    }
                                } else {
                                    
                                    vm.startCount = true
                                }
                                
                            },
                            label: {
                                
                                Text(vm.startCount ? "Добавить".localized : "Старт".localized)
                                    .mainButton()
                                
                            })
                            .padding(.leading, !viewModel.wordsTestResult.isEmpty  ? -20 : viewModel.timeRemaining < 60 && viewModel.timeRemaining != 0 ? 35 : 0)
                        }
                        
                        Spacer()
                        
                        if viewModel.wordsTestResult.isEmpty && viewModel.timeRemaining < 60 {
                            
                            Button(action: {withAnimation{ viewModel.timeRemaining = 0 }}, label: {
                            Image(systemName: "exclamationmark.arrow.circlepath")
                                .font(.title)
                                .foregroundColor(.red)
                        })
                            .transition(.move(edge: .bottom))
                       

                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 5)
                    }
                }
                .padding(.vertical, 20)
                .transition(.move(edge: .trailing))
                
            }
            
        }
        .padding(.bottom, -15)
        .onAppear{
            viewModel.timeRemaining = 120
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
        
        let currentLang = Locale.current.languageCode
        
        if let fileWithWords = Bundle.main.url(forResource: currentLang == "ru" ? "words" : "wordsEng", withExtension: "txt") {
            if let word = try? String(contentsOf: fileWithWords) {
                let newWords =  word.components(separatedBy: "\n")
                while vm.words.count != 20 {
                    if let randomWord = newWords.randomElement() {
                        if !vm.words.contains(randomWord.firstUppercased) && randomWord != ""{
                            vm.words.append(randomWord.firstUppercased)
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

