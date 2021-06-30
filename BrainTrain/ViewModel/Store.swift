//
//  Store.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 11.06.2021.
//

import SwiftUI
import Combine

class ViewModel: ObservableObject{
    
    @Published var mainScreen = 1
    
    @Published  var currentView = CurrentView.DateCard
    
    @AppStorage ("date") var day = 1
    let brainTestsDay = Array(1...60).filter {$0.isMultiple(of:5)}
    
    var week: Int {
     var current = 1
        for i in 1...day {
        for testDay in brainTestsDay {
            if testDay == i - 1 {
                current += 1
            }
        }
        }
        return current
    }
    
    @AppStorage ("skipBrainTest") var skipBrainTest = false
    @AppStorage ("currentDate") var currentDate = date
    
    //Результаты тестов
    @Published var testsResults: [Result] = []
   
    //Тест на счет
    @Published var countTestResult = ""
    @Published var isCountTestFinish = false
    
    //Тест Струпа
    @Published var isStroopTestFinish = false
    @Published var stroopTestResult = ""
    @Published var stage: StroopTestStages = .prepare
    @Published var startStroopTestTimer = false
    @Published var colorsViewTag = -1
    
    @ViewBuilder func stroopTestViews() -> some View {
 
        switch stage {
        case .prepare:
           StroopTestPreparing()
        case .test:
            StroopTesting()
        case .finish:
            StroopFinish()
        }
    }
    
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
    
    

    @Published var notificationTime: Double = 86400 //86400
    
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
