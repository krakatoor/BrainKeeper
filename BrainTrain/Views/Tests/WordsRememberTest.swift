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
    @State private var startCountTest = false
    @State private var startTest = false
    @State private var word = ""
    @State private var error = false
    @State private var wordsAlreadyExist = false
    @State var timeRemaining = 7200
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        VStack {
            if !startTest {
                LottieView(name: "memory", loopMode: .playOnce, animationSpeed: 0.6)
                           .frame(width: 200, height: 200)
                
                Text("В течении 2х минут постарайтесь запомнить как можно больше слов.")
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 20)
                    .padding(.horizontal)
                
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .center, spacing: 3) {
                    ForEach(viewModel.firstWeekWords, id: \.self) {
                        Text($0)
                            .mainFont(size: 22)
                            .redacted(reason: !startCountTest ? .placeholder : [] )
                            .onChange(of: startCountTest, perform: { value in
                                if !startCountTest{
                                    startTest = true
                                }
                            })
                    }
                }
                
                timerView(result: $viewModel.wordsTestResult, startTimer: $startCountTest, timeRemaining: $timeRemaining, fontSize: 25, minus: true)
                    .padding(.top)
                
                
                
                Button(action: {
                    startCountTest.toggle()
                    timeRemaining = 7200
                },
                label: {
                    Text( startCountTest ? "Дальше" :  "Старт")
                        .mainButton()
                })
                .padding()
                
            } else {
                if !startCountTest && !viewModel.isWordsTestFinish{
                    Text("Постарайтесь вписать как можно больше запомненных слов.")
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                }
                VStack {
                    
                    Text("Слов запомнено: \(viewModel.words.count)")
                        .font(.title3)
                    
                    ZStack {
                        Text(error ? "Попробуйте другое слово" : " ")
                            .foregroundColor(.red)
                        
                        Text(wordsAlreadyExist ? "Слово уже добавлено" : " ")
                            .foregroundColor(.red)
                    }
                    
                    
                    TextField("Введите слово", text: $word)
                        .introspectTextField{ textfield in
                            textfield.becomeFirstResponder()
                        }
                        .keyboardType(.twitter)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .padding()
                        
                        .disabled(!startCountTest)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            startCountTest = true
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
                
                if !viewModel.isWordsTestFinish {
                timerView(result: $viewModel.wordsTestResult, startTimer: $startCountTest, timeRemaining: $timeRemaining, fontSize: 25, minus: true)
                    .onChange(of: startCountTest, perform: { value in
                        if !value{
                            viewModel.isWordsTestFinish = true
                        }
                        
                    })
                } else {
                    Text("Тест завершён")
                        .font(.title)
                        .bold()
                }
                
                Button(action: {
                    if   viewModel.isWordsTestFinish {
                        presentation.wrappedValue.dismiss()
                    } else {
                    if startCountTest {
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
                        startCountTest = true
                    }
                    }
                },
                label: {
                    if   viewModel.isWordsTestFinish {
                        Text("Назад" )
                            .mainButton()
                    } else {
                    Text(startCountTest ? "Добавить" : "Старт" )
                        .mainButton()
                    }
                })
                .padding()
            }
            
        }
        .navigationTitle("Тест на память")
        .mainFont(size: 18)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background()
    }
}

struct WordsRememberTest_Previews: PreviewProvider {
    static var previews: some View {
        WordsRememberTest()
            .environmentObject(ViewModel())
    }
}

