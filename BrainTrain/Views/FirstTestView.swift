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
    @State private var showAppStoreCover = false
    @State private var showFinishCover = false
    @State private var showAlert = false
    @State private var showDonatCover = false
    @Environment(\.managedObjectContext) private var  viewContext
    @FetchRequest(entity: TestResult.entity(), sortDescriptors: [])
    private var testResults: FetchedResults<TestResult>
    
    var body: some View {
        let applePay = ApplePayManager(countryCode: "US", currencyCode: "USD", itemCost: 1, shippingCost: 0)
        
        ZStack{
            
            
            if viewModel.day == showDonatCoverDay && showDonatCover {
                
                ZStack (alignment: Alignment(horizontal: .trailing, vertical: .top)){
                    
                    Image(systemName: "xmark.circle")
                        .font(.title)
                        .zIndex(1)
                        .padding(.top, 3)
                        .padding(.trailing, 3)
                        .onTapGesture {
                            withAnimation{
                                showDonatCover = false
                            blur = 0
                            }
                        }
                
                VStack (spacing: 10){
                    
                    Text("Понравилось приложение - угостите кофем разработчика)")
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom)
                        .padding(.top, 40)
                        .font(.system(size: 16))
                    
                    Button(action: {
                        applePay.buyBtnTapped()
                    }, label: {
                        Text("PAY WITH  APPLE")
                            .foregroundColor(Color("back"))
                            .font(.title3)
                            .padding(5)
                            .background(Color.primary.cornerRadius(10).shadow(radius: 10))
                    })
                  
                }
                .padding()
            }
                .background()
                .cornerRadius(15)
                .overlay(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 0.6))
                .frame(width: screenSize.width - 30, height: screenSize.height * 0.4)
                .padding(.bottom)
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                .zIndex(1)
            }
            
            
            if viewModel.day == showFinishCoverDay && showFinishCover {
                
                VStack (spacing: 10){
                    
                    Spacer()
                    
                    Text("Поздравляем!!!")
                        .font(.title2)
                        .bold()
                    
                    Text("Вы прошли первый курс тренировки мозга! Вы по-прежнему можете проходить тесты и они будут усложнены, либо сбросить результаты и начать сначала. Выбор за вами...")
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
                                Alert(title: Text("Начать тесты заново?"), message: Text("Все результаты будут сброшены!"),
                                      primaryButton: .destructive(Text("Да")) {
                                     
                                      },
                                      secondaryButton: .cancel(Text("Нет"))
                                )
                            }
                       
                        Spacer()
                        
                        Button(action: {
                         
                        }, label: {
                            Text("Продолжить")
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
            
            
            if viewModel.day == showAppStoreCoverDay && showAppStoreCover {
                
                ZStack (alignment: Alignment(horizontal: .trailing, vertical: .top)){
                    
                    Image(systemName: "xmark.circle")
                        .font(.title)
                        .zIndex(1)
                        .onTapGesture {
                            withAnimation{
                            showAppStoreCover = false
                            blur = 0
                            }
                        }
                    
                    VStack (spacing: 10){
                        
                        Text("Понравилось приложение?")
                            .font(.title2)
                            .bold()
                            .padding(.top, 50)
                        
                        Text("Пожалуйста, поставьте свою оценку в AppStore и напишите отзыв. Помогите разаботчику сделать его лучше.")
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, 3)
                            .padding(.bottom)
                        
                        
                        Link("В AppStore", destination: URL(string: "https://apps.apple.com/mv/developer/kamil-suleimanov/id1530811067")!)
                            .mainButton()
                    }
                }
                .zIndex(1)
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                .padding()
                .background()
                .cornerRadius(15)
                .overlay(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 0.5))
                .frame(width: screenSize.width - 30, height: screenSize.height * 0.5)
            }
            
            VStack  {
                let firstDay = viewModel.day == 1 && (!viewModel.isWordsTestFinish && !viewModel.isStroopTestFinish)
                
                if firstDay {
                    Text("Неделя \(viewModel.week)")
                        .bold()
                        .mainFont(size: 22)
                        .padding(.top, 20)
                    
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
                                        ZStack (alignment: Alignment(horizontal: .trailing, vertical: .top)){
                                            TestCard(title: "Тест Струпа", subTitle: "Оценка совместной работы полушарий")
                                            
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
                                    if viewModel.day != showAppStoreCoverDay && viewModel.day != showFinishCoverDay && viewModel.day != showDonatCoverDay {
                                    blur = 0
                                    
                                    if viewModel.isWordsTestFinish && viewModel.isStroopTestFinish && !viewModel.startAnimation {
                                        proxy.scrollTo(1)
                                    }
                                    }
                                }
                            }
                            
                            if viewModel.day == showAppStoreCoverDay && viewModel.startAnimation{
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.65) {
                                    withAnimation{
                                        showAppStoreCover = true
                                        viewModel.startAnimation = false
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
                            
                            if viewModel.day == showDonatCoverDay && viewModel.startAnimation{
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.65) {
                                    withAnimation{
                                        showDonatCover = true
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
                    .frame(height: small ? 120 : 150)
            }
            
        }
        .frame(width: screenSize.width / 1.2, height: subTitle == "" ? screenSize.height * 0.25 : screenSize.height * 0.077)
        .foregroundColor(.primary)
        .padding()
        .padding(.vertical, small ? 0 : 15)
        .background(Color("back").cornerRadius(15).shadow(color: Color.primary.opacity(0.5), radius: 3, x: 0, y: 0))
    }
}


