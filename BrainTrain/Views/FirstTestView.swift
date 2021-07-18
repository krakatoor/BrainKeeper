//
//  FirstTestView.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 11.06.2021.
//

import SwiftUI

struct FirstTestView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var blur: CGFloat = 15
    @Environment(\.managedObjectContext) private var  viewContext
    @FetchRequest(entity: TestResult.entity(), sortDescriptors: [])
    private var testResults: FetchedResults<TestResult>
    
    var body: some View {
        VStack  {
            
            if viewModel.day == 1 && (!viewModel.isWordsTestFinish && !viewModel.isStroopTestFinish) {
                Text("Неделя \(viewModel.week)")
                    .bold()
                    .mainFont(size: 22)
                
                
                Text("Прежде чем начать тренировку, определим с помощью тестов, как сейчас работает ваш мозг.")
                    .mainFont(size: 16)
                    .padding([.horizontal, .bottom])
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            
            ScrollViewReader { proxy in
                ScrollView(viewModel.isStroopTestFinish && viewModel.isWordsTestFinish ? .horizontal : [], showsIndicators: false) {
                    HStack (spacing: 10) {
                        VStack (spacing: 20){
                            
                            NavigationLink(
                                destination: WordsRememberTest().environmentObject(viewModel),
                                label: {
                                    ZStack (alignment: Alignment(horizontal: .trailing, vertical: .bottom)){
                                    TestCard(title: "Тест на запоминание слов", subTitle: "Проверим краткосрочную память")
                                        .environmentObject(viewModel)
                                        
                                        if viewModel.isWordsTestFinish {
                                            Image(systemName: "checkmark.seal")
                                                .font(.title2)
                                                .foregroundColor(.green)
                                                .padding(.trailing, 5)
                                                .padding(.bottom, 5)
                                        }
                                    }
                                })
                                .buttonStyle(FlatLinkStyle())
                            
                            NavigationLink(
                                destination: StroopTest().environmentObject(viewModel),
                                label: {
                                    ZStack (alignment: Alignment(horizontal: .trailing, vertical: .bottom)){
                                    TestCard(title: "Тест Струпа", subTitle: "Оценка совместной работы полушарий")
                                        
                                        if viewModel.isStroopTestFinish {
                                            Image(systemName: "checkmark.seal")
                                                .font(.title2)
                                                .foregroundColor(.green)
                                                .padding(.trailing, 5)
                                                .padding(.bottom, 5)
                                        }
                                    }
                                    
                                })
                                .buttonStyle(FlatLinkStyle())
                        }
                        
                        Spacer()
                        
                        if viewModel.isStroopTestFinish && viewModel.isWordsTestFinish {
                            NavigationLink(
                                destination: mathTest().environmentObject(viewModel),
                                label: {
                                    ZStack (alignment: Alignment(horizontal: .trailing, vertical: .center)){
                                        
                                        if viewModel.results[viewModel.mathTestDay] != 0.0 {
                                            Text("Завершен")
                                                .zIndex(1)
                                                .padding(5)
                                                .overlay(Rectangle().stroke())
                                                .rotationEffect(.degrees(25))
                                                .padding(.trailing)
                                        }
                                        
                                        TestCard(title: "Ежедневный тест № \(viewModel.day)", subTitle: "")
                                    }
                                })
                                .buttonStyle(FlatLinkStyle())
                                .padding(.trailing, 10)
                                .onAppear{
                                    withAnimation(.spring()){
                                        proxy.scrollTo(2)  
                                    }
                                }
                        }
                        NavigationLink(destination: EmptyView()) {
                            EmptyView()
                        }//need to escape from ios 14 navLink bug
                        .id(blur == 0 ? 2 : 1) //to avoid scroll after view appear
                        
                    }
                    .padding(.leading)
                    .padding(.vertical)
                }
                .onAppear{
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation(.spring()){
                            blur = 0
                            if viewModel.isWordsTestFinish && viewModel.isStroopTestFinish && !viewModel.startAnimation {
                                proxy.scrollTo(1)
                            }
                            
                        }
                        
                    }
                }
                
            }
            
            Spacer()
            
            TestResultsView()
                .frame(height: screenSize.height * 0.38)
                .padding(.bottom)
                .environmentObject(viewModel)
            
            
        }
        .blur(radius: blur)
        .background()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("")
    }
}

struct FirstTestView_Previews: PreviewProvider {
    static var previews: some View {
        FirstTestView()
            .environmentObject(ViewModel())
        
    }
}

struct TestCard: View {
    @EnvironmentObject var viewModel: ViewModel
    var title: String
    var subTitle: String
    
    var body: some View {
        VStack (spacing: 5) {
            
            Text(title)
                .font(.title2)
                .bold()
                .padding(.top, 20)
            
            HStack {
                Spacer()
                Text(subTitle)
                    .foregroundColor(.secondary)
                    .mainFont(size: 14)
                    .fixedSize()
                
                Spacer()
            }
            .padding([.leading, .bottom])
            
            Spacer()
            
            if subTitle == "" {
                LottieView(name: "math", loopMode: .loop, animationSpeed: 0.8)
                    .frame(height: 150)
            }
            
        }
        .frame(width: screenSize.width / 1.2, height: subTitle == "" ? screenSize.height * 0.25 : 50)
        .foregroundColor(.primary)
        .padding()
        .padding(.vertical, small ? 0 : 15)
        .background(Color("back").cornerRadius(15).shadow(color: Color.primary.opacity(0.5), radius: 3, x: 0, y: 0))
    }
}


