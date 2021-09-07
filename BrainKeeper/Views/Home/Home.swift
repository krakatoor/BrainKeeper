//
//  Home.swift
//  BrainKeeper
//
//  Created by Камиль Сулейманов on 15.06.2021.
//

import SwiftUI
import UserNotifications

struct Home: View {
    @EnvironmentObject private var viewModel: ViewModel
    @EnvironmentObject private var homeVM: HomeViewModel
    
    init() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    var body: some View {
        NavigationView {
            ZStack (alignment: .bottom) {
                ZStack {
                    
                    if homeVM.showLoadingScreen {
                        ProgressCard()
                            .zIndex(1)
                            .transition(.move(edge: .leading))
                    }
                    
                    MainScreenView()
                        .padding(.top)
                }
                .onDisappear{ viewModel.showSettings = false }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background()
                .navigationBarItems(trailing: settingButton())
                .padding(.top, -50)
                
                SettingsView()
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .accentColor(.primary)
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .environmentObject(ViewModel())
    }
}





