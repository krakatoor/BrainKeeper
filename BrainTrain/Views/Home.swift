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

    var body: some View {
        
        NavigationView {
            ZStack {
                
//                    ProgressCard()
//                        .zIndex(1)
//                        .opacity(viewModel.currentView == .DateCard ? 1 : 0)
//
                
                    
                TabView {
                    ZStack{
                    FirstTestView()
                        .padding(.top)
                        .zIndex(viewModel.currentView == .MathTest && viewModel.brainTestsDay.contains(viewModel.day) ? 0 : 1)
                    mathTest()
                        .zIndex(viewModel.currentView == .MathTest ? 1 : 0)
                    }
                                            
                       
                    
                    TestResultsView()
                        
                    
                }
                .padding(.bottom, -30)
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle())
//                .opacity(viewModel.currentView != .DateCard ? 1 : 0)
               

                
                
            }
            .navigationBarHidden(true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background()
            .environmentObject(viewModel)
            .onAppear{

                        //push notofication permission
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                            if success {
                                print("All set!")
                            } else if let error = error {
                                print(error.localizedDescription)
                            }
                        }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation(.linear){
                            if viewModel.currentView == .DateCard {
                            viewModel.currentView = .BrainTests
                            }
                        }
                    }

                
                if testResults.isEmpty && !viewModel.testsResults.isEmpty{
                    for i in 0..<viewModel.testsResults.count{
                        let testResult = TestResult(context: viewContext)
                        testResult.testName = viewModel.testsResults[i].testName
                        testResult.date = viewModel.testsResults[i].date
                        testResult.week = viewModel.testsResults[i].week
                        testResult.day = viewModel.testsResults[i].day
                        testResult.testResult = viewModel.testsResults[i].testResult
                        do {
                            try viewContext.save()
                        } catch {
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .environmentObject(ViewModel())
    }
}





struct ProgressCard: View {
    @EnvironmentObject var viewModel: ViewModel
    var body: some View {
        VStack {
            VStack {
                Spacer()
                
                Text("День \(viewModel.day)")
                    .font(.system(size: 40, weight: .black, design: .serif))
                    .foregroundColor(.primary)
                    .transition(.scale)
                
                
                Spacer()
                Image("puzzle")
                    .resizable()
                    .scaledToFit()
            }
            .background(BlurView(style: .regular).cornerRadius(20).shadow(radius: 10))
            .frame(width: screenSize.width - 50, height: screenSize.height * 0.5)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 0.3))
        }
        
        
    }
}


