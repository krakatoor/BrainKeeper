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
    @State private var wordsAlreadyExist = false
    @State private var timeRemaining = 7200
    @Environment(\.presentationMode) var presentation
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
       
            VStack {
                if !startTest && !viewModel.isWordsTestFinish {
                    VStack {
                    LottieView(name: "memory", loopMode: .playOnce, animationSpeed: 0.6)
                        .frame(height: small ? 120 : 200)
                    
                    Text("В течении 2х минут постарайтесь запомнить как можно больше слов.")
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 20)
                        .padding(.horizontal)
                    
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .center, spacing: 3) {
                        ForEach(viewModel.firstWeekWords, id: \.self) {
                            Text($0)
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
                    
                    
                    
                    Button(action: {
                        startCount.toggle()
                        timeRemaining = 200
                    },
                    label: {
                        Text( startCount ? "Дальше" :  "Старт")
                            .mainButton()
                    })
                    .padding(.bottom, 20)
                    }
                    
                } else {
                    
                    VStack{
                    if !startCount && viewModel.wordsTestResult.isEmpty{
                        Text("Постарайтесь вписать как можно больше запомненных слов.")
                            .fixedSize(horizontal: false, vertical: true)
                            .padding()
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
                        ZStack (alignment: .trailing){
                            TextField("Введите слово", text: $word)
                                .introspectTextField{ textfield in
                                    textfield.becomeFirstResponder()
                                }
                                .keyboardType(.twitter)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .autocapitalization(.none)
                                .padding()
                                .disabled(!startCount)
                                .contentShape(Rectangle())
                                .onChange(of: word, perform: { value in
                                    if viewModel.firstWeekWords.contains(word.trimmingCharacters(in: .whitespacesAndNewlines)) && !viewModel.words.contains(word.trimmingCharacters(in: .whitespacesAndNewlines)) {
                                        viewModel.words.append(word)
                                        word = ""
                                    }
                                })
                                .onTapGesture {
                                    startCount = true
                            }
                            
                            Button(action: {word = ""}, label: {
                                Image(systemName: "xmark.circle.fill")
                                    .padding(.trailing, 25)
                                    .opacity(word.isEmpty ? 0 : 1)
                            })

                        }
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
                       
                    } else {
                        VStack {
                            
                            LottieView(name: "memory", loopMode: .playOnce, animationSpeed: 0.6)
                                .frame(height: 200)
                            
                            Text("Тест завершён")
                                .font(.title)
                                .bold()
                               
                            if viewModel.isWordsTestFinish{
                                Text(viewModel.wordsTestResult)
                                    .font(.title)
                                    .padding(.bottom)
                            } else {
                            Text("Слов запомнено: \(viewModel.words.count)")
                                .font(.title)
                                .padding(.bottom)
                            }
                            
                           
                        }
                    }
                    
                        HStack {
                            if !viewModel.wordsTestResult.isEmpty  {
                            Button(action: {
                                viewModel.wordsTestResult = ""
                                timeRemaining = 0
                                startTest = false
                                viewModel.isWordsTestFinish = false
                                viewModel.words.removeAll()
                            }, label: {
                               Image(systemName: "arrow.clockwise")
                                .font(.title)
                            })
                            }
                            
                            Spacer()
                            
                            Button(action: {
                            if   !viewModel.wordsTestResult.isEmpty {
                                viewModel.isWordsTestFinish = true
                                let testResult = TestResult(context: viewContext)
                                testResult.date = date
                                  testResult.week = String(viewModel.week)
                                  testResult.day = String(viewModel.day)
                                testResult.testName = "Тест на запоминание слов"
                                testResult.testResult = "Слов запомнено: \(viewModel.words.count)"
                                testResult.isMathTest = false
                                      do {
                                          try viewContext.save()
                                      } catch {return}
                                if viewModel.isWordsTestFinish && viewModel.isStroopTestFinish{
                                    withAnimation(.linear){
                                        viewModel.currentView = .MathTest
                                    }
                                }
                                presentation.wrappedValue.dismiss()
                            } else {
                            if startCount {
                                if viewModel.firstWeekWords.contains(word.trimmingCharacters(in: .whitespacesAndNewlines)) && !viewModel.words.contains(word.trimmingCharacters(in: .whitespacesAndNewlines)) {
                                    viewModel.words.append(word)
                                    word = ""
                                } else if viewModel.words.contains(word.trimmingCharacters(in: .whitespacesAndNewlines)){
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
                            }
                        },
                        label: {
                            if   !viewModel.wordsTestResult.isEmpty {
                                Text("Назад" )
                                    .mainButton()
                            } else {
                            Text(startCount ? "Добавить" : "Старт" )
                                .mainButton()
                            }
                        })
                            .padding(.leading, -20)
                          
                            Spacer()
                        }
                        .padding(.bottom)
                        .padding(.horizontal, 30)
                        
                }
                    .transition(.move(edge: .trailing))
                }
               
            }
            .onDisappear{
                if !viewModel.wordsTestResult.isEmpty{
                viewModel.isWordsTestFinish = true
                }
                if viewModel.isWordsTestFinish && viewModel.isStroopTestFinish{
                    withAnimation(.linear){
                        viewModel.currentView = .MathTest
                    }
                }
            }
            .navigationTitle("Тест на память")
            .mainFont(size: 18)
            .navigationBarTitleDisplayMode(small ? .inline : .large)
      
        .background()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct WordsRememberTest_Previews: PreviewProvider {
    static var previews: some View {
        WordsRememberTest()
            .environmentObject(ViewModel())
    }
}

