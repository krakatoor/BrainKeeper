//
//  MainScreenViewModel.swift
//  BrainKeeper
//
//  Created by Камиль Сулейманов on 06.09.2021.
//

import SwiftUI

class MainScreenViewModel: ObservableObject{
    @Published var blur: CGFloat = 15
    @Published var showFinishCover = false
    @Published var showAlert = false
}
