//
//  Constants.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 02.08.2021.
//

import SwiftUI

let screenSize = UIScreen.main.bounds
let small = UIScreen.main.bounds.height < 750
let notificationCenter = UNUserNotificationCenter.current()
let showAppStoreCoverDay = [6, 24, 42]
let showFinishCoverDay = 60

func timeString(time: Double) -> String {
    let minutes   = Int(time) / 60
    let seconds = Int(time) - Int(minutes) * 60
    
    return String(format:"%02i:%02i", minutes, seconds)
}

var today: String {
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d MMM"
    
    return "\(dateFormatter.string(from: date))"
}


var tomorrow: String {
    let date = Date().addingTimeInterval(86400)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d MMM"
    
    return "\(dateFormatter.string(from: date))"
}

var time: String {
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = .short
    dateFormatter.locale = Locale(identifier: "ru")
    
    return "\(dateFormatter.string(from: date))"
}
