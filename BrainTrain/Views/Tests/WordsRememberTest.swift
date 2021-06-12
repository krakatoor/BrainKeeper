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
    var body: some View {
        VStack {
            if !startTest {
                Image("memory")
                    .resizable()
                    .scaledToFit()
                
                Text("В течении 2х минут постарайтесь запомнить как можно больше слов.")
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 20)
                
                
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
                
                timerView(result: $viewModel.wordsTestResult, startTimer: $startCountTest, timeRemaining: 200, fontSize: 25, minus: true)
                    .padding(.top)
                
                
                
                Button(action: {
                    startCountTest.toggle()
                },
                label: {
                    Text( startCountTest ? "Стоп" : (viewModel.wordsTestResult == "" ? "Старт" : "Продолжить"))
                        .mainButton()
                })
                .padding()
                
            } else {
                if !startCountTest && viewModel.words.isEmpty{
                    Text("Постарайтесь вписать как можно больше запомненных слов.")
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                }
                VStack {
                    
                    Text("Слов запомнено: \(viewModel.words.count)")
                        .font(.title3)
                    
                    Text(error ? "Попробуйте другое слово" : " ")
                        .foregroundColor(.red)
                    
                    
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
                
                
                timerView(result: $viewModel.wordsTestResult, startTimer: $startCountTest, timeRemaining: 200, fontSize: 25, minus: true)
                
                Button(action: {
                    if startCountTest {
                        if viewModel.firstWeekWords.contains(word.trimmingCharacters(in: .whitespacesAndNewlines)) && !viewModel.words.contains(word.trimmingCharacters(in: .whitespacesAndNewlines)) {
                            viewModel.words.append(word)
                            word = ""
                        } else {
                            error.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                error.toggle()
                            }
                        }
                    } else {
                        startCountTest = true
                    }
                },
                label: {
                    Text(startCountTest ? "Добавить" : "Старт" )
                        .mainButton()
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

