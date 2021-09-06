//
//  View.swift
//  BrainKeeper
//
//  Created by Камиль Сулейманов on 05.09.2021.
//

import SwiftUI

//Fonts
extension View {
    func mainFont(size: CGFloat) -> some View {
        self
            .font(.system(size: size, weight: .medium, design: .serif))
    }
}

extension View {
    func mainButton() -> some View {
        self
            .mainFont(size: small ? 18 : 20)
            .foregroundColor(.white)
            .frame(width: 150)
            .padding(10)
            .background(Color.blue.cornerRadius(15))
    }
}


extension View {
    func background () -> some View {
    self
        .background(Color("back").ignoresSafeArea())
    }
}


struct Leading: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            content
            Spacer()
        }
        .padding(.leading)
    }
}

extension View {
    func leadingView() -> some View {
        self
            .modifier(Leading())
    }
}


struct Center: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            Spacer()
            content
            Spacer()
        }
    }
}

extension View {
    func centerView() -> some View {
        self
            .modifier(Center())
    }
}
