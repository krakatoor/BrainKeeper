//
//  Settings.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 25.07.2021.
//

import SwiftUI

struct Settings: View {
    
    @State private var showAlert = false
    @EnvironmentObject var store: StoreKit
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.managedObjectContext) private var  viewContext
    @FetchRequest(entity: TestResult.entity(), sortDescriptors: [])
    private var testResults: FetchedResults<TestResult>
    @State private var showNotificationAlert = false
    @State private var showInAppPurchase = true
    @State private var notificationToggleText = "Уведомления включены"
    var body: some View {
        VStack {
          
            Capsule()
                .fill(Color.gray)
                .frame(width: 60, height: 5)
                .offset(y: -15)
            
      
            Text("Сложность ежедневных тестов:")
                .padding(.top)
            
            Picker("Please choose a color", selection: $viewModel.difficult) {
                ForEach(Difficult.allCases, id: \.self) {
                    Text($0.rawValue.localized)
                           }
                       }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            
            if viewModel.day != 1 || viewModel.isMathTestFinish {
            Toggle(notificationToggleText.localized, isOn: $viewModel.showNotificationCover)
                .font(.headline)
                .padding()
                .onAppear{ notificationToggleText = viewModel.showNotificationCover ? "Уведомления включены" : "Уведомления отключены"}
                .onChange(of: viewModel.showNotificationCover) { value in
                        if value {
                                    notificationCenter.getNotificationSettings { (settings) in
                                        if(settings.authorizationStatus == .authorized) {
                                            withAnimation{
                                                DispatchQueue.main.async {
                                                    viewModel.showNotificationCover = true
                                                    notificationToggleText = "Уведомления включены"
                                                }
                                            }
                                        } else {
                                            DispatchQueue.main.async{ showNotificationAlert = true }
                                        }
                                    }
                        } else {
                            DispatchQueue.main.async{
                                viewModel.showNotificationCover = false
                                notificationToggleText = "Уведомления отключены".localized
                            }
                            //remove notification if test fineshed early
                            notificationCenter.removeAllPendingNotificationRequests()
                            notificationCenter.removeAllDeliveredNotifications()}
                    
                }
                .alert(isPresented: $showNotificationAlert) {
                    Alert(title: Text("Включить уведомления?".localized), message: Text("У вас отключены уведомления. Перейти в настройки, чтобы включить их?"),
                          primaryButton: .destructive(Text("Да")) {
                            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                                DispatchQueue.main.async {
                                    UIApplication.shared.open(settingsUrl)
                                }
                            }
                          },
                          secondaryButton: .cancel(Text("Нет"))
                    )
                }
            } else {
                Spacer()
            }
            
            Button(action: { showAlert = true }, label: {
                Text("Сбросить прогресс")
                    .foregroundColor(.red)
            })
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Начать тесты заново?"), message: Text("Все результаты будут сброшены!"),
                      primaryButton: .destructive(Text("Да")) {
                        viewModel.day = 1
                        viewModel.mathTestDay = 0
                        viewModel.isTestFinish = false
                        viewModel.isWordsTestFinish = false
                        viewModel.isStroopTestFinish = false
                        viewModel.mathTestResult = ""
                        viewModel.wordsTestResult = ""
                        viewModel.stroopTestResult = ""
                        for i in testResults{
                            viewContext.delete(i)
                            do {try viewContext.save()} catch {return}}
                        viewModel.showSettings = false
                      },
                      secondaryButton: .cancel(Text("Нет"))
                )
            }
            .padding(.top)
            
            
            if showInAppPurchase {
          Divider()
            .padding(.bottom)
            
            storeKitView(showInAppPurchase: $showInAppPurchase)
            .environmentObject(store)
            .frame(height: 60)
            .padding(.vertical)
            }
            
            
            Text("instagram: @lvl.app")
                .font(.caption2)
                .centerView()
                .padding(.top)
            
            Spacer()
            
          
        }
        .frame(width: screenSize.width, height: showInAppPurchase ? 400 : 250)
        .background(Color("back").ignoresSafeArea().cornerRadius(15).shadow(color: Color.primary.opacity(0.5), radius: 3, x: 0, y: 0))
     
        
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
            .environmentObject(StoreKit())
            .environmentObject(ViewModel())
    }
}
