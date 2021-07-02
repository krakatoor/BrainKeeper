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
    @State private var showDetail = false

    var body: some View {
        VStack{
            ScrollView(showsIndicators: false) {
            Text("Результаты тестов")
                .bold()
                .mainFont(size: 25)
                .padding(.vertical, 30)
                
            if !testResults.isEmpty {
                ForEach(1...viewModel.week , id: \.self) { week in
                    VStack (spacing: 15) {
                        HStack {
                            Text("Неделя \(week)")
                                .bold()
                                .mainFont(size: 22)
                            
                                Spacer()
                            
                            Text(showDetail && week == currentWeek ? "Скрыть" : "Показать")
                                .foregroundColor(.blue)
                                .mainFont(size: 16)
                            
                        }
                        .padding(.horizontal)
                        .onTapGesture {
                            currentWeek = week
                            showDetail.toggle()
                    }
                        resultCard(week: week, currentWeek: $currentWeek, showDetail: $showDetail)
                        
                    }
                }
            
            } else {
                VStack {
                    LottieView(name: "results", loopMode: .loop, animationSpeed: 0.8)
                        .frame(height: 400)
                    Text("Ждем результатов ")
                        .bold()
                        .mainFont(size: 20)
                        .offset(y: -50)
                      
                    Spacer()
                   
                }
             
            }
            Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background()
        .onAppear{
            currentWeek = viewModel.week
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

struct resultCard: View {
    @Environment(\.managedObjectContext) private var  viewContext
    @FetchRequest(entity: TestResult.entity(), sortDescriptors: [])
    private var testResults: FetchedResults<TestResult>
    @EnvironmentObject var viewModel: ViewModel
    var week: Int
    @Binding var currentWeek: Int
    @Binding var showDetail: Bool
    var body: some View {
        VStack {
            if showDetail && week == currentWeek{
            ForEach(testResults.sorted{$0.isMathTest == $1.isMathTest}.filter{$0.week == String(week)}, id: \.self) { result in
            HStack {
                VStack (alignment: .leading){
                    
                    if result.isMathTest{
                        
                        Text( "День " + (result.day ?? ""))
                            .bold()
                        Text("Дата прохождения теста:\n" + (result.date ?? ""))
                            .padding(.top, 1)
                        
                    } else {
                        
                        Text(result.testName ?? "")
                            .bold()
                    }
                    Text(result.testResult ?? "")
                        .padding(.top, 1)
                }
                .padding()
                
                Spacer()
                
                Image(systemName: "trash.circle.fill")
                    .renderingMode(.original)
                    .font(.title)
                    .onTapGesture {
                        viewContext.delete(result)
                        do {
                            try viewContext.save()
                        } catch {return}
                    }
            }
            .mainFont(size: 18)
            .padding(.horizontal)
            }
        }
        }
        .onAppear{
            if  currentWeek == viewModel.week {
                showDetail = true
            }
        }
        .onTapGesture {
            currentWeek = week
            showDetail.toggle()
    }
    }
}
