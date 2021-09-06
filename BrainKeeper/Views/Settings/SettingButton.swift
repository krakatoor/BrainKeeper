//
//  settingButton.swift
//  BrainKeeper
//
//  Created by Камиль Сулейманов on 05.09.2021.
//

import SwiftUI


struct settingButton: View {
    @EnvironmentObject var viewModel: ViewModel
    var body: some View{
        HStack{
            Spacer()
            Image(systemName: "line.horizontal.3")
                .resizable()
                .frame(width: 20, height: 15)
        }
        .frame(width: 50, height: 25)
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.viewState = .zero
            withAnimation (.linear){
                viewModel.showSettings.toggle()
            }
        }
        .opacity(viewModel.startAnimation ? 0 : 1)
    }
}

struct settingButton_Previews: PreviewProvider {
    static var previews: some View {
        settingButton()
            .environmentObject(ViewModel())
    }
}
