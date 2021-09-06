//
//  WordsTestViewModel.swift
//  BrainKeeper
//
//  Created by Камиль Сулейманов on 06.09.2021.
//

import SwiftUI

class WordsTestViewModel: ObservableObject{
    @Published var startCount = false
    @Published var startTest = false
    @Published var word = ""
    @Published var error = false
    @Published var showAlert = false
    @Published var wordsAlreadyExist = false
    @Published var words: [String] = []
}
