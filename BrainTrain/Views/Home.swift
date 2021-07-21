//
//  Home.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 15.06.2021.
//

import SwiftUI
import UserNotifications

struct Home: View {
    @EnvironmentObject var viewModel: ViewModel
    //coreData
    @Environment(\.managedObjectContext) private var  viewContext
    @FetchRequest(entity: TestResult.entity(), sortDescriptors: [])
    private var testResults: FetchedResults<TestResult>
    //
   
    @State private var showAlert = false
  
    
    init() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    var body: some View {
        
        NavigationView {
            ZStack {
             
                if viewModel.showDayCard {
                    ProgressCard()
                        .zIndex(1)
                        .transition(.move(edge: .leading))
                        .environmentObject(viewModel)
                }
               
                    FirstTestView()
                        .environmentObject(viewModel)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background()
            .onAppear{
       
                //reset all data
                
                viewModel.day = 1
//                viewModel.mathTestDay = 0
//                viewModel.isTestFinish = false
//                for i in testResults{
//                    viewContext.delete(i)
//                    do {try viewContext.save()} catch {return}}
 
           
                
                if viewModel.startAnimation {

//                    viewModel.currentDay = tomorrow

                    //                viewModel.currentDay = today

                    if viewModel.currentDay != today {
                        viewModel.day += 1

                        if  viewModel.mathTestDay == 4{
                            viewModel.mathTestDay = 0
                            withAnimation{
                                viewModel.weekChange = true
                            }
                        } else {
                            viewModel.mathTestDay += 1
                            print("day + 1")
                        }
                    }
                }
                
                
                //                check if tests finish
                for result in testResults{
                    
                    if result.week == String(viewModel.week) {
                        if result.testName == "Тест на запоминание слов" {
                            if viewModel.wordsTestResult.isEmpty {
                                viewModel.wordsTestResult = result.testResult!
                                viewModel.isWordsTestFinish = true
                            }
                        }
                        
                        if result.testName == "Тест Струпа" {
                            if viewModel.stroopTestResult.isEmpty {
                                viewModel.stroopTestResult = result.testResult!
                                viewModel.isStroopTestFinish = true
                            }
                        }
                    }
                    
                 
                    if result.testName == "Ежедневный тест" {
                        if result.week == String(viewModel.week){
                                viewModel.results[Int(result.day)] = result.result
                            viewModel.mathTestResult = result.testResult!
                        }

                            if result.day == Double(viewModel.mathTestDay) {
                            viewModel.isMathTestFinish = true
                            }
                        
                    }
                 
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation{
                            viewModel.showDayCard = false
                            viewModel.startAnimation = false
                        }
                    }
                
                
            }
            .padding(.top, -50)
    }
        .accentColor(.primary)
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Group{
        Home()
            Home()
                .environment(\.locale, .init(identifier: "eng"))
        }
            .environmentObject(ViewModel())
    }
}



