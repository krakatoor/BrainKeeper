//
//  Settings.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 25.07.2021.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var showAlert = false
    @StateObject private var store = StoreKit()
    @EnvironmentObject var viewModel: ViewModel
    @State private var showNotificationAlert = false
    @State private var showInAppPurchase = true
    var body: some View {
        
        VStack {
          
            Capsule()
                .fill(Color.gray)
                .frame(width: 60, height: 5)
                .padding(.top, 7)
      
            Text("Сложность ежедневных тестов:".localized)
                .padding(.top)
            
            Picker("", selection: $viewModel.difficult) {
                ForEach(Difficult.allCases, id: \.self) {
                    Text($0.rawValue.localized)
                           }
                       }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            Toggle("Уведомления включены".localized, isOn: $viewModel.showNotification)
                .padding()
                .padding(.top, 3)
                .onChange(of: viewModel.showNotification) { value in
                        if value {
                                    notificationCenter.getNotificationSettings { (settings) in
                                        if(settings.authorizationStatus == .authorized) {
                                            withAnimation{
                                                DispatchQueue.main.async {
                                                    viewModel.saveChoice = false
                                                    viewModel.hideFinishCover = false
                                                    viewModel.showNotification = true
                                                }
                                            }
                                        } else {
                                            DispatchQueue.main.async{ showNotificationAlert = true }
                                        }
                                    }
                        } else {
                            DispatchQueue.main.async{
                                viewModel.saveChoice = false
                                viewModel.hideFinishCover = true
                                viewModel.showNotification = false
                            }
                            //remove notification if test fineshed early
                            notificationCenter.removeAllPendingNotificationRequests()
                            notificationCenter.removeAllDeliveredNotifications()}
                    
                }
                .alert(isPresented: $showNotificationAlert) {
                    Alert(title: Text("Включить уведомления?".localized), message: Text("У вас отключены уведомления. Перейти в настройки, чтобы включить их?".localized),
                          primaryButton: .destructive(Text("Да".localized)) {
                            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                                DispatchQueue.main.async {
                                    UIApplication.shared.open(settingsUrl)
                                }
                            }
                          },
                          secondaryButton: .cancel(Text("Нет".localized))
                    )
                }
            
            
            Button(action: { showAlert = true }, label: {
                Text("Сбросить прогресс")
                    .foregroundColor(.red)
            })
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Начать тесты заново?".localized), message: Text("Все результаты будут сброшены!".localized),
                      primaryButton: .destructive(Text("Да".localized)) {
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
                        for i in viewModel.testResults{
                            viewModel.coreData.delete(i)
                            viewModel.coreData.save() }
                        viewModel.showSettings = false
                      },
                      secondaryButton: .cancel(Text("Нет".localized))
                )
            }
            .padding(.top)
            
            
            if showInAppPurchase {
          Divider()
            .padding(.bottom)
            
                storeKitView(store: store, showInAppPurchase: $showInAppPurchase)
            .frame(height: 60)
            .padding(.vertical)
            }
            
            Spacer()
            
            Text("instagram: @lvl.app")
                .font(.caption2)
                .centerView()
                .padding(.vertical)
            
            Spacer()
            
          
        }
        .frame(width: screenSize.width, height: showInAppPurchase ? 400 : 300)
        .background(Color("back").ignoresSafeArea().cornerRadius(15).shadow(color: Color.primary.opacity(0.5), radius: 3, x: 0, y: 0))
        .zIndex(1)
        .offset(y: viewModel.showSettings ? 0 : 450)
        .offset(y:  viewModel.viewState)
        .gesture(
            DragGesture().onChanged{ value in
                if value.translation.height > 35 {
                    viewModel.viewState = value.translation.height
                }
            }
            .onEnded{ value in
                if value.translation.height > 120 {
                    withAnimation(.linear) {
                        viewModel.showSettings = false
                    }
                } else {
                    viewModel.viewState = .zero
                }
            }
        )
        
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(StoreKit())
            .environmentObject(ViewModel())
    }
}
