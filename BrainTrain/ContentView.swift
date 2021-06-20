//
//  ContentView.swift
//  BrainTrain
//
//  Created by Камиль on 20.10.2020.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
//    private var testResult: FetchedResults<TestResult>
    var body: some View {
      Home()
            .environmentObject(viewModel)
            .preferredColorScheme(.light)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

