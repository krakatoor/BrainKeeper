//
//  Store.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 11.06.2021.
//

import SwiftUI
import Combine

class ViewModel: ObservableObject{
 
    
    @AppStorage ("day") var day = 1
    @AppStorage ("isTestFinish") var isTestFinish = false
    @AppStorage ("currentDay") var currentDay = today
    @AppStorage ("skipBrainTest") var skipBrainTest = false
    @AppStorage ("currentDate") var currentDate = today
    @AppStorage ("mathTestDay") var mathTestDay = 0
    @AppStorage("showNotification") var showNotificationCover = true
    
    let brainTestsDay = Array(1...60).filter {$0.isMultiple(of:5)}
//    or stride(from: 1, to: 60, by: 6)
    
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
    
    @Published var checkDay = false
    
    @Published var weekChange = false
    @Published var showDayCard = true
    @Published var startAnimation = true
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
 
    //Ежедневные примеры
    @Published var startMathTest = false
    @Published var mathTestResultTime = 0.0
    @Published var mathTestResult = ""
    @Published var totalExample = 5
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
                        print("Push notification set")
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








