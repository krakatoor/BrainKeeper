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
    
    //Тест Струпа
    @Published var selectedStrupTag = 0
    @Published var prepareStrupTesting = true
    @Published var startStrupTest = false
    @Published var isStrupTestFinish = false
    @Published var strupTestResult = ""
    
    //Запомниние слов
    @Published var wordsTestResult = ""
    @Published var words: [String] = []
    let firstWeekWords = ["темница", "сервер", "кнут", "колье","белье","алебастр","копыто","косточка","задник","вертеп","перрон","чайка","ароматизатор","залог","журавль","мокасин","звено","миндаль","капсула","ягода"]
    
}
