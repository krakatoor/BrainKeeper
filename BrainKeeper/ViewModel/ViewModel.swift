//
//  swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 11.06.2021.
//

import SwiftUI
import Combine

enum Difficult: String, Equatable, CaseIterable  {
    case easy, normal, hard
}

class ViewModel: ObservableObject{
    
    let coreData = CoreDataService.shared
    
    @Published var testResults: [TestResult] = []
    @Published var subscriptions = Set<AnyCancellable>()
    
    @AppStorage ("difficult") var difficult = Difficult.normal
    @AppStorage ("day") var day = 1
    @AppStorage ("isTestFinish") var isTestFinish = false
    @AppStorage ("currentDay") var currentDay = today
    @AppStorage ("skipBrainTest") var skipBrainTest = false
    @AppStorage ("currentDate") var currentDate = today
    @AppStorage ("mathTestDay") var mathTestDay = 0
    @AppStorage("showNotification") var showNotification = true
    @AppStorage("hideFinishCover") var hideFinishCover = false
    @AppStorage("saveChoice") var saveChoice = false
    let brainTestsDay = stride(from: 1, to: 60, by: 6)

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
    
    @Published var viewState: CGFloat = .zero
    @Published var showSettings = false
    @Published var weekChange = false
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
    @Published var totalExample = 70
    @Published var examplesCount = 0
    @Published var correctAnswers = 0
    @Published var isMathTestFinish = false
    @Published var showResults = false
    
    //Результаты
    @Published var results = [0.0, 0.0, 0.0, 0.0, 0.0]
    
    
    
    init() {
        subscribeOnCoreData()
    }
   
    func subscribeOnCoreData() {
        coreData.$testResults
            .sink { [weak self] results in
                self?.testResults = results
            }
            .store(in: &subscriptions)
    }
    
    func checkDate() {
        for result in testResults{
            if result.week == String(week) {
                if result.testName == "Тест на запоминание слов" {
                    if wordsTestResult.isEmpty {
                       wordsTestResult = String(format: "%.0f", result.result)
                       isWordsTestFinish = true

                    }
                }
                if result.testName == "Тест Струпа" {
                    if stroopTestResult.isEmpty {
                        stroopTestResult = result.testResult!
                        isStroopTestFinish = true
                    }
                }
            }
            if result.testName == "Ежедневный тест" {
                if result.week == String(week){
                    results[Int(result.day)] = result.result
                    mathTestResultTime = result.result

                    if result.day == Double(mathTestDay) {

                        isMathTestFinish = true

                        if isMathTestFinish {
                            if currentDay != today {
                                day += 1
                                currentDay = today
                                isMathTestFinish = false

                                if  mathTestDay == 4{
                                    mathTestDay = 0
                                    withAnimation{
                                        weekChange = true
                                        isWordsTestFinish = false
                                        wordsTestResult = ""
                                        isStroopTestFinish = false
                                        stroopTestResult = ""

                                    }
                                } else {
                                    mathTestDay += 1
                                    print("day + 1")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
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
   
    func sendNotification() {
        getPermession()
        let content = UNMutableNotificationContent()
        content.title = "Пришло время размять мозги".localized
        content.subtitle = "Вы не тренировались уже 24 часа".localized
        content.sound = UNNotificationSound.default
        content.badge = 1
//        60 * 60 * 24
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60 * 60 * 24 , repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        notificationCenter.add(request)
    }
}






