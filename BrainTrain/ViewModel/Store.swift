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
    @AppStorage ("isTestFinish") var isTestFinish = false
    @AppStorage ("currentDay") var currentDay = today
    
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
    @AppStorage ("currentDate") var currentDate = today
    
    //Результаты тестов
    @Published var testsResults: [Result] = []

    
    @Published var wordsTestTapped = false
    @Published var stroopTestTapped = false
    
    //Тест Струпа
    @Published var isStroopTestFinish = false
    @Published var stroopTestResult = ""
    @Published var startStroopTestTimer = false
    
    //Запомниние слов
    @Published var isWordsTestFinish = false
    @Published var wordsTestResult = ""
    @Published var words: [String] = []
    @Published var timeRemaining:Double = 20 //in seconds
    //Проверка функциональности лобных долей
    let firstWeekWords = ["темница", "сервер", "кнут", "колье","белье","алебастр","копыто","косточка","задник","шашлык","дерево","чайка","аромат","залог","журавль","мокасин","звено","миндаль","капсула","ягода"]
    
    
    //Ежедневные примеры
    @Published var startTest = false
    @Published var mathTestResultTime = 0.0
    @Published var mathTestResult = ""
    @Published  var totalExample = 1
    @Published var examplesCount = 0
    @Published var correctAnswers = 0
    @Published var isMathTestFinish = false
    @Published var showResults = false
    
    //Результаты
    @Published var results = [0.0, 0.0, 0.0, 0.0, 0.0]

   
    
    func getPermession() {
        notificationCenter.getNotificationSettings { (settings) in

            if(settings.authorizationStatus == .authorized) {
                print("Push notification is enabled")
            } else {
                notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("All set!")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    @Published var notificationTime: Double = 86400 //86400
    
    func sendNotification() {
        getPermession()
        let content = UNMutableNotificationContent()
        content.title = "Пришло время размять мозги"
        content.subtitle = "Вы не тренировались уже 24 часа"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: notificationTime, repeats: false)

        let request = UNNotificationRequest(identifier: "timeToTrain", content: content, trigger: trigger)

        notificationCenter.add(request)
    }
  
 
}



enum CurrentView{
    case DateCard, BrainTests, MathTest, Result
}
