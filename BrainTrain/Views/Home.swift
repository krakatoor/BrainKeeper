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
    @State private var offset: CGFloat = .zero

    var body: some View {
        
        NavigationView {
            ZStack {
                    ProgressCard()
                        .zIndex(1)
                        .opacity(viewModel.currentView == .DateCard ? 1 : 0)
  
                TabView (selection: $viewModel.mainScreen){
                    ZStack{
                    FirstTestView()
                        .padding(.top, 30)
                        .opacity(viewModel.currentView != .MathTest ? 1 : 0)
                    mathTest()
                        .opacity(viewModel.currentView == .MathTest ? 1 : 0)
                        .padding(.top, 30)
                        .padding(.bottom)
                        .tag(1)
                    }
                    .rotation3DEffect(
                        .degrees(Double(getProgress()) * 90),
                        axis: (x: 0.0, y: 1.0, z: 0.0),
                        anchor: offset > 0 ? .leading : .trailing,
                        anchorZ: 0.0,
                        perspective: 0.6
                    )
                    .modifier(offsetModificator(anchorPoint: .leading, offset: $offset))
                    TestResultsView()
                        .tag(2)
                }
               
                .padding(.bottom, -30)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .opacity(viewModel.currentView != .DateCard ? 1 : 0)
               
            }
            .navigationBarHidden(true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background()
            .environmentObject(viewModel)
            .onAppear{
                viewModel.day = 1
                getPermession()
//                for i in testResults{
//                    viewContext.delete(i)
//                    do {
//                        try viewContext.save()
//                    } catch {return}
//                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation(.linear){
                            if viewModel.currentView == .DateCard && viewModel.brainTestsDay.contains(viewModel.day - 1) || viewModel.day == 1{
                            viewModel.currentView = .BrainTests
                            } else {
                                viewModel.currentView = .MathTest
                            }
                        }
                    }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func getProgress() -> CGFloat {
        let progress = offset / UIScreen.main.bounds.width
        return progress
    }
    
    private func getPermession() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in

            if(settings.authorizationStatus == .authorized) {
                print("Push notification is enabled")
            } else {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("All set!")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
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


