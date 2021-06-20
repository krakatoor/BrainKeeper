//
//  TestResult.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 17.06.2021.
//

import Foundation

struct Result {
    let testName: String
    let testResult: String
    let date: String
}


struct WeekResult: Hashable {
    let date: String
    let week: Int
    let countTest: String
    let wordsTest: String
    let stroopTest: String

}
