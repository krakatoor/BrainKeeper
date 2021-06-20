//
//  Home.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 15.06.2021.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var viewModel: ViewModel
    //coreData
    @Environment(\.managedObjectContext) private var  viewContext
    @FetchRequest(entity: TestResult.entity(), sortDescriptors: [])
    private var testResults: FetchedResults<TestResult>
    //
    @State private var showDateCard = true
    @State private var showTests = false
 
    var body: some View {
        
        NavigationView {
            ZStack {
            
                if showDateCard{
                ProgressCard()
                    .zIndex(1)
                    .transition(.move(edge: .bottom))
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation(.linear){
                            showDateCard.toggle()
                            }
                        }
                    }
                }
                
                if showTests && !viewModel.isBrainTestIsFinish && viewModel.day == 1{
                    FirstTestView()
                        .transition(.move(edge: .top))
                        .zIndex(1)
                        .animation(.spring())
                        .padding(.top, 70)
                       
                }
                
                if viewModel.isBrainTestIsFinish || viewModel.day != 1 && !showDateCard {
                    mathTest()
                        .zIndex(viewModel.isBrainTestIsFinish || viewModel.day != 1 ? 1 : 0)
                        .animation(viewModel.isMathTStarted ? nil : .spring())
                        .transition(.move(edge: .top))
                }
                
               
               
               
                LottieView(name: "mech1", loopMode: .loop, animationSpeed: 1)
                    .zIndex(0)
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            if !showTests {
                                showTests = true
                            }
                        }
                    }//onAppear
                    
            }
            .environmentObject(viewModel)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear{
                if testResults.isEmpty && !viewModel.testsResults.isEmpty{
                    for i in 0..<viewModel.testsResults.count{
                        let testResult = TestResult(context: viewContext)
                        testResult.testName = viewModel.testsResults[i].testName
                        testResult.date = viewModel.testsResults[i].date
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
            .navigationBarHidden(true)
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
        }
     
        
    }
}
