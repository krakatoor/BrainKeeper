//
//  Store.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 11.06.2021.
//

import SwiftUI
import Combine

class ViewModel: ObservableObject{
    
    @AppStorage ("date") var day = 1
    @AppStorage ("week") var week = 1
    
    @Published var isBrainTestIsFinish = false
    
    private var isTestsFinish: AnyPublisher < Bool, Never> {
        Publishers.CombineLatest3($isCountTestFinish, $isWordsTestFinish, $isStroopTestFinish)
            .map{isCountTestFinish, isWordsTestFinish, isStroopTestFinish in
                return isCountTestFinish == true && isWordsTestFinish == true && isStroopTestFinish == true
            }
            .eraseToAnyPublisher()
    }
    

    @Published var progress = 0
    //Результаты тестов
    @Published var testsResults: [Result] = []
   
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
    
    //Проверка функциональности лобных долей
    let firstWeekWords = ["темница", "сервер", "кнут", "колье","белье","алебастр","копыто","косточка","задник","шашлык","дерево","чайка","аромат","залог","журавль","мокасин","звено","миндаль","капсула","ягода"]
    
    
    //Ежедневные примеры
    @Published var mathTestResult = ""
    @Published var examplesCount = 0
    @Published var correctAnswers = 0
    @Published var isMathTStarted = false
    @Published var isMathTestFinish = false
    
    
    private var cancellable: AnyCancellable?
    
    init(){
        isTestsFinish
            .receive(on: RunLoop.main)
            .assign(to: &$isBrainTestIsFinish)   
    }
    
 
}


