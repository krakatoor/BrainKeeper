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
    
    var body: some View {
        
        VStack{
            if !testResults.isEmpty {
                
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack{
                            ForEach(1...viewModel.week, id: \.self) { week in
                           
                                VStack (spacing: 15) {
                                    Text("Неделя \(week).  Результаты тестов")
                                        .bold()
                                        .mainFont(size: 22)
                                        .padding(.bottom)

                                    ChartsResult(week: week)
                                        .environmentObject(viewModel)

                                }
                                .frame(width: screenSize.width, height: 450)
                                .id(week)
                                
                            }
                        }
                        .onAppear{
                            proxy.scrollTo(viewModel.week)
                          
                        }
                       
                       
                    }
                }
                
                
            } else {
                VStack {
                    LottieView(name: "results", loopMode: .loop, animationSpeed: 0.8)
                        .frame(height: 300)
                    Text("Ждем результатов тестов...")
                        .bold()
                        .mainFont(size: 20)
                        .offset(y: -50)
                }
                
            }
            
        }
        .onAppear{
           
            UIScrollView.appearance().bounces = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
              
            }
            
        }
       
    }
}

struct TestResultsView_Previews: PreviewProvider {
    static var previews: some View {
        TestResultsView()
            .environmentObject(ViewModel())
    }
}


