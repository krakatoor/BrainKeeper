//
//  Extensions.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 28.04.2021.
//

import SwiftUI

let screenSize = UIScreen.main.bounds

var date: String {
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.locale = Locale(identifier: "ru")
    
    return "\(dateFormatter.string(from: date))"
}
var time: String {
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = .short
    dateFormatter.locale = Locale(identifier: "ru")
    
    return "\(dateFormatter.string(from: date))"
}

//Blur effect
struct BlurView : UIViewRepresentable {
    var style : UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    }
}

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
            .mainFont(size: 20)
            .foregroundColor(.white)
            .frame(width: 150)
            .padding(10)
            .background(Color.blue.cornerRadius(15))
    }
}

extension View {
    func background () -> some View {
    self
    .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)).opacity(0.05), Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))]), startPoint: .top, endPoint: .bottom).ignoresSafeArea())
    }
}

extension View{
    func singBackground () -> some View {
        self
            .frame(width: screenSize.width - 20, height: 250)
            .background(BlurView(style: .regular).cornerRadius(15))
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 0.2))
    }
}

struct CustomCorner: Shape {
    var corners: UIRectCorner
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width:  18, height: 18))
        return Path(path.cgPath)
    }
}


