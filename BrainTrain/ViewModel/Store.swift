//
//  Store.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 11.06.2021.
//

import SwiftUI
import Combine

class ViewModel: ObservableObject{
    
  
    @Published  var currentView = CurrentView.DateCard
    
    
    @AppStorage ("date") var day = 1
    let brainTestsDay = [1, 6, 11, 16]
    var week: Int{
     var currentWeek = 1
        
        if day > 5 {
            currentWeek = 2
        }
        if day > 10 {
            currentWeek = 3
        }
        
        if day > 15 {
            currentWeek = 4
        }
        
        return currentWeek
    }
    @AppStorage ("skipBrainTest") var skipBrainTest = false
    @AppStorage ("currentDate") var currentDate = date
    
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
    @Published var isMathTestFinish = false
    @Published var showResults = false
    
    

    @Published var notificationTime: Double = 10 //86400
    
    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Пришло время размять мозги"
        content.subtitle = "Вы не тренировались уже 24 часа"
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: notificationTime, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
 
}



enum CurrentView{
    case DateCard, BrainTests, MathTest, Result
}
