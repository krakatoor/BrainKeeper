//
//  FirstTestView.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 11.06.2021.
//

import SwiftUI
import StoreKit

struct FirstTestView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var blur: CGFloat = 15
    @State private var showFinishCover = false
    @State private var showAlert = false
    @Environment(\.managedObjectContext) private var  viewContext
    @FetchRequest(entity: TestResult.entity(), sortDescriptors: [])
    private var testResults: FetchedResults<TestResult>
    
    var body: some View {
        
        
        ZStack{
            if viewModel.day == showFinishCoverDay && showFinishCover {
                
                VStack (spacing: 10){
                    
                    Spacer()
                    
                    Text("Поздравляем!!!".localized)
                        .font(.title2)
                        .bold()
                    
                    Text("Вы прошли курс тренировки мозга! Сравните результаты первой и последней недель. Разница вас приятно удивит. \n\n Вы по-прежнему можете проходить тесты, либо сбросить результаты и начать сначала. Не забывайте, что вы можете повысить сложность тестов в меню настроек. Выбор за вами...".localized)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 3)
                    
                    Spacer()
                    
                    LottieView(name: "finish", loopMode: .loop, animationSpeed: 0.6)
                        .frame(height: 200)
                    
                    Spacer()
                    
                    Group{
                        HStack {
                            Button(action: {
                                showAlert = true
                            }, label: {
                                Image(systemName: "arrow.clockwise")
                                    .font(.title)
                            })
                            .alert(isPresented: $showAlert) {
                                Alert(title: Text("Начать тесты заново?".localized), message: Text("Все результаты будут сброшены!".localized),
                                      primaryButton: .destructive(Text("Да")) {
                                        viewModel.day = 1
                                        viewModel.mathTestDay = 0
                                        viewModel.isTestFinish = false
                                        viewModel.isWordsTestFinish = false
                                        viewModel.isStroopTestFinish = false
                                        viewModel.mathTestResult = ""
                                        viewModel.wordsTestResult = ""
                                        viewModel.stroopTestResult = ""
                                        viewModel.words = []
                                        viewModel.correctAnswers = 0
                                        viewModel.examplesCount = 0
                                        viewModel.results =  [0.0, 0.0, 0.0, 0.0, 0.0]
                                        for i in testResults{
                                            viewContext.delete(i)
                                            do {try viewContext.save()} catch {return}}
                                      },
                                      secondaryButton: .cancel(Text("Нет".localized))
                                )
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation{
                                showFinishCover = false
                                blur = 0
                                }
                            }, label: {
                                Text("Продолжить".localized)
                                    .mainButton()
                            })
                            .padding(.leading, -15)
                            .padding(.bottom, small ? 10 : 0)
                            
                            Spacer()
                            
                        }
                        .padding(.horizontal, 30)
                        
                        Spacer()
                        
                    }
                }
                .padding()
                .background()
                .cornerRadius(15)
                .overlay(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 0.5))
                .frame(width: screenSize.width - 30, height: screenSize.height * 0.7)
                .padding(.bottom)
                .zIndex(1)
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            }
            
            
            VStack  {
                let firstDay = viewModel.day == 1 && (!viewModel.isWordsTestFinish && !viewModel.isStroopTestFinish)
                
                if firstDay {
                    HStack{
                        Text("Неделя".localized)
                            .bold()
                            .mainFont(size: 22)
                            .padding(.top, 20)
                        
                        Text("\(viewModel.week)")
                            .bold()
                            .mainFont(size: 22)
                            .padding(.top, 20)
                    }
                    
                    Text("Прежде чем начать тренировку, определим с помощью тестов, как сейчас работает ваш мозг.".localized)
                        .mainFont(size: 16)
                        .padding()
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                
                ScrollViewReader { proxy in
                    ScrollView(viewModel.isStroopTestFinish && viewModel.isWordsTestFinish ? .horizontal : [], showsIndicators: false) {
                        HStack (spacing: 10) {
                            VStack (spacing: 20){
                                
                                NavigationLink(
                                    destination: WordsRememberTest().environmentObject(viewModel),
                                    label: {
                                        ZStack (alignment: Alignment(horizontal: .trailing, vertical: .top)){
                                            TestCard(title: "Тест на запоминание слов".localized, subTitle: "Проверим краткосрочную память".localized)
                                                .environmentObject(viewModel)
                                            
                                            if viewModel.isWordsTestFinish {
                                                Image(systemName: "checkmark.seal")
                                                    .font(.title2)
                                                    .foregroundColor(.green)
                                                    .padding(.trailing, 5)
                                                    .padding(.top, 5)
                                            }
                                        }
                                    })
                                    .buttonStyle(FlatLinkStyle())
                                
                                NavigationLink(
                                    destination: StroopTest().environmentObject(viewModel),
                                    label: {
                                        ZStack (alignment: Alignment(horizontal: .trailing, vertical: .top)){
                                            TestCard(title: "Тест Струпа".localized, subTitle: "Оценка совместной работы полушарий".localized)
                                            
                                            if viewModel.isStroopTestFinish {
                                                Image(systemName: "checkmark.seal")
                                                    .font(.title2)
                                                    .foregroundColor(.green)
                                                    .padding(.trailing, 5)
                                                    .padding(.top, 5)
                                            }
                                        }
                                        
                                    })
                                    .buttonStyle(FlatLinkStyle())
                            }
                            .padding(.top, firstDay ? 0 : 20)
                            
                            Spacer()
                            
                            if viewModel.isStroopTestFinish && viewModel.isWordsTestFinish {
                                NavigationLink(
                                    destination: mathTest().environmentObject(viewModel),
                                    label: {
                                        ZStack (alignment: Alignment(horizontal: .trailing, vertical: .center)){
                                            
                                            Text(viewModel.results[viewModel.mathTestDay] != 0.0 ? "Завершен".localized : "Не пройден".localized)
                                                .foregroundColor(viewModel.results[viewModel.mathTestDay] != 0.0 ? .green : .red)
                                                    .zIndex(1)
                                                    .padding(5)
                                                    .overlay(Rectangle().stroke().foregroundColor(viewModel.results[viewModel.mathTestDay] != 0.0 ? .green : .red))
                                                .rotationEffect(.degrees(viewModel.results[viewModel.mathTestDay] != 0.0 ? 25 : 0))
                                                    .padding(.trailing)
                                            
                                            
                                            TestCard(title: "Ежедневный тест № ".localized, subTitle: "")
                                        }
                                    })
                                    .buttonStyle(FlatLinkStyle())
                                    .padding(.trailing, 10)
                                    .padding(.top, 20)
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
                        if viewModel.startAnimation {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation(.spring()){
                                    if viewModel.day != showFinishCoverDay {
                                        blur = 0
                                        
                                        if viewModel.isWordsTestFinish && viewModel.isStroopTestFinish && !viewModel.startAnimation {
                                            proxy.scrollTo(1)
                                        }
                                    }
                                }
                            }
                            
                            if  showAppStoreCoverDay.contains(viewModel.day) && viewModel.startAnimation{
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                                    withAnimation{
                                        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                                            SKStoreReviewController.requestReview(in: scene)
                                            
                                        }
                                    }
                                }
                            }
                            
                            if viewModel.day == showFinishCoverDay && viewModel.startAnimation{
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.65) {
                                    withAnimation{
                                        showFinishCover = true
                                        viewModel.startAnimation = false
                                    }
                                }
                            }
                            
                        }
                    }
                }
                
                Spacer()
                
                TestResultsView()
                    .frame(height: screenSize.height *  (viewModel.day == 1 && (!viewModel.isWordsTestFinish && !viewModel.isStroopTestFinish) ? 0.30 : 0.38))
                    .padding(.bottom)
                    .environmentObject(viewModel)
                    .padding(.bottom, small ? 10 : 0)
            }
            .blur(radius: viewModel.startAnimation ? 15 : blur)
            .background()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
        
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
            
            Text(subTitle == "" ? title + "\(viewModel.day)" : title)
                .font(.title2)
                .bold()
                .padding(.top, 20)
            
            HStack {
                Spacer()
                Text(subTitle)
                    .foregroundColor(.secondary)
                    .mainFont(size: 14)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
            .padding([.leading, .bottom])
            
            Spacer()
            
            if subTitle == "" {
                LottieView(name: "math", loopMode: .loop, animationSpeed: 0.8)
                    .frame(height: small ? 120 : 150)
            }
            
        }
        .frame(width: screenSize.width / 1.2, height: subTitle == "" ? screenSize.height * 0.25 : screenSize.height * 0.077)
        .foregroundColor(.primary)
        .padding()
        .padding(.vertical, small ? 0 : 15)
        .background(Color("back").cornerRadius(15))
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 0.5))
    }
}


