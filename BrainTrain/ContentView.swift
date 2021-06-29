//
//  ContentView.swift
//  BrainTrain
//
//  Created by Камиль on 20.10.2020.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
//    private var testResult: FetchedResults<TestResult>
    var body: some View {
      Home()
            .environmentObject(viewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

