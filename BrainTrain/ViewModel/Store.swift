//
//  Store.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 11.06.2021.
//

import SwiftUI

class ViewModel: ObservableObject{
   
    //Тест на счет
    @Published var countTestResult = ""
    @Published var isCountTestFinish = false
    
    //Тест Струпа
    @Published var selectedStroopTag = 0
    @Published var prepareStroopTesting = true
    @Published var startStroopTest = false
    @Published var isStroopTestFinish = false
    @Published var stroopTestResult = ""
    
    //Запомниние слов
    @Published var isWordsTestFinish = false
    @Published var wordsTestResult = ""
    @Published var words: [String] = []
    
    //Проверка функциональности олобных долей
    let firstWeekWords = ["темница", "сервер", "кнут", "колье","белье","алебастр","копыто","косточка","задник","шашлык","дерево","чайка","аромат","залог","журавль","мокасин","звено","миндаль","капсула","ягода"]
    
    
    //Ежедневные примеры
    @Published var mathTestResult = ""
    @Published var examplesCount = 0
    @Published var correctAnswers = 0
    @Published var isMathTestFinish = false
}

struct Results: Hashable {
    let date: String
    let week: Int
    let countTest: String
    let wordsTest: String
    let stroopTest: String

}
