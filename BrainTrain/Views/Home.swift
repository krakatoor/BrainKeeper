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
   
   
    init() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    var body: some View {
        
        NavigationView {
            ZStack (alignment: .bottom) {
                ZStack {
                 
                    if viewModel.showDayCard {
                        ProgressCard()
                            .zIndex(1)
                            .transition(.move(edge: .leading))
                            .environmentObject(viewModel)
                    }
                   
                        FirstTestView()
                            .padding(.top)
                            .environmentObject(viewModel)
                    
                }
                .onDisappear{ viewModel.showSettings = false }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background()
                .navigationBarItems(trailing: settingButton().environmentObject(viewModel))
                .onAppear{
           
                    UIApplication.shared.applicationIconBadgeNumber = 0
                    //reset all data
                    
    //                viewModel.day = 1
    //                viewModel.mathTestDay = 0
    //                viewModel.isTestFinish = false
    //                for i in testResults{
    //                    viewContext.delete(i)
    //                    do {try viewContext.save()} catch {return}}
     
               
   
                    
                    // check if tests finish
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
                    
                    if viewModel.startAnimation && viewModel.isMathTestFinish{
    
    //                    viewModel.currentDay = tomorrow
    
    //                     viewModel.currentDay = today
    
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
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation{
                                viewModel.showDayCard = false
                                viewModel.startAnimation = false
                            }
                        }
                    
                    
                }
                .padding(.top, -50)
                
                
                Settings()
                    .offset(y: viewModel.showSettings ? 0 : 450)
                    .offset(y:  viewModel.viewState)
                    .gesture(
                        DragGesture().onChanged{ value in
                            if value.translation.height > 35 {
                                viewModel.viewState = value.translation.height
                            }
                        }
                        .onEnded{ value in
                            if value.translation.height > 120 {
                                withAnimation(.linear) {
                                    viewModel.showSettings = false
                                }
                            } else {
                                viewModel.viewState = .zero
                            }
                        }
                    )
            }
            .edgesIgnoringSafeArea(.bottom)
         
    }
        .accentColor(.primary)
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .environmentObject(ViewModel())
    }
}



struct settingButton: View {
    @EnvironmentObject var viewModel: ViewModel
    var body: some View{
        HStack{
            Spacer()
            Image(systemName: "line.horizontal.3")
                .resizable()
                .frame(width: 20, height: 15)
        }
        .frame(width: 50, height: 25)
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.viewState = .zero
            withAnimation (.linear){
                viewModel.showSettings.toggle()
            }
            
        }
        .opacity(viewModel.startAnimation ? 0 : 1)
    }
}
