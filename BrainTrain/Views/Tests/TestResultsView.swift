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
        
        
        ZStack (alignment: Alignment(horizontal: .leading, vertical: .bottom)){
            
            if viewModel.week > 1 {
            Image(systemName: "chevron.left")
                .font(.title2)
                .zIndex(1)
                .padding()
                .onTapGesture {
                    withAnimation{
                    viewModel.mainScreen = 1
                    }
                }
            }
            
            VStack{
                Text("Результаты тестов")
                    .bold()
                    .mainFont(size: 25)
                    .padding(.vertical, 30)
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            if viewModel.mathTestDay == 1 && viewModel.isTestFinish{
                                currentWeek = viewModel.week - 1
                            } else {
                                
                                currentWeek = viewModel.week
                            }
                        }
                     
                    }
                    
                if !testResults.isEmpty {
                   
                    TabView (selection: $currentWeek){
                                ForEach(1...viewModel.week , id: \.self) { week in
                                    VStack (spacing: 15) {
                                            Text("Неделя \(week)")
                                                .bold()
                                                .mainFont(size: 22)
                                        
                                        ChartsResult(currentWeek: $currentWeek, week: week)
                                            .environmentObject(viewModel)
                                    
                                    }
                                    .tag(week)
                                   
                                }
                            }
                    
                    .frame(width: screenSize.width, height: 450)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: currentWeek > 1 ? .always : .never))
                            
                    
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
            .onChange(of: viewModel.isWordsTestFinish) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        currentWeek = viewModel.week
                }
            }
            .onChange(of: viewModel.isWordsTestFinish) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        currentWeek = viewModel.week
                }
            }
            .onChange(of: viewModel.isMathTestFinish) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        currentWeek = viewModel.week
                }
            }
            .onDisappear{
                viewModel.mainScreen = 1
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
