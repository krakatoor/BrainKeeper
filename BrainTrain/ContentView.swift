//
//  ContentView.swift
//  BrainTrain
//
//  Created by Камиль on 20.10.2020.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    var body: some View {
        mathTest()
            .environmentObject(viewModel)
            .preferredColorScheme(.light)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

