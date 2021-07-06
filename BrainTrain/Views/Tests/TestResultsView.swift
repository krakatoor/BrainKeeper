//
//  TestResultsView.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 17.06.2021.
//

import SwiftUI

struct TestResultsView: View {
    @Environment(\.managedObjectContext) private var  viewContext
    @FetchRequest(entity: TestResult.entity(), sortDescriptors: [])
    private var testResults: FetchedResults<TestResult>
    @EnvironmentObject var viewModel: ViewModel
    @State private var currentWeek = 1

    var body: some View {
        VStack{
          
            Text("Результаты тестов")
                .bold()
                .mainFont(size: 25)
                .padding(.vertical, 30)
                
            if !testResults.isEmpty {
               
                TabView (selection: $currentWeek){
                            ForEach(1...viewModel.week , id: \.self) { week in
                                VStack (spacing: 15) {
                                        Text("Неделя \(week)")
                                            .bold()
                                            .mainFont(size: 22)
                                     
                                    
                                    
                                    
                                    ChartsResult(currentWeek: $currentWeek, week: week)
                                
                                }
                                .tag(week)
                               
                            }
                        }
                
                .frame(width: screenSize.width, height: 450)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: currentWeek > 1 ? .always : .never))
                        .onAppear{
                       
                        }
                
            } else {
                VStack {
                    LottieView(name: "results", loopMode: .loop, animationSpeed: 0.8)
                        .frame(height: 400)
                    Text("Ждем результатов...")
                        .bold()
                        .mainFont(size: 20)
                        .offset(y: -50)
                      
                    Spacer()
                   
                }
             
            }
            Spacer()
            }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background()
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    currentWeek = viewModel.week
            }
        }
        .onDisappear{
            viewModel.mainScreen = 1
        }
    }
}

struct TestResultsView_Previews: PreviewProvider {
    static var previews: some View {
        TestResultsView()
            .environmentObject(ViewModel())
    }
}
