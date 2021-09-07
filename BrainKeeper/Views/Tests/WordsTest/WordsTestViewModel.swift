//
//  WordsTestViewModel.swift
//  BrainKeeper
//
//  Created by Камиль Сулейманов on 06.09.2021.
//

import SwiftUI

class WordsTestViewModel: ObservableObject{
    @Published var startCount = false
    @Published var startTest = false
    @Published var word = ""
    @Published var error = false
    @Published var showAlert = false
    @Published var wordsAlreadyExist = false
    @Published var words: [String] = []
    
    
    init() {
        getWords()
    }
    
    func getWords() {
        let currentLang = Locale.current.languageCode
        
        if let fileWithWords = Bundle.main.url(forResource: currentLang == "ru" ? "words" : "wordsEng", withExtension: "txt") {
            if let word = try? String(contentsOf: fileWithWords) {
                let newWords =  word.components(separatedBy: "\n")
                while words.count != 20 {
                    if let randomWord = newWords.randomElement() {
                        if !words.contains(randomWord.firstUppercased) && randomWord != ""{
                            words.append(randomWord.firstUppercased)
                        }
                    }
                }
            }
        }
    }
}
