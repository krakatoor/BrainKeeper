//
//  Extensions.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 28.04.2021.
//

import SwiftUI
import CoreData
let screenSize = UIScreen.main.bounds

//
//@objc(TestResult)
//public class TestResult: NSManagedObject {
//
//}


let small = UIScreen.main.bounds.height < 750

var date: String {
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d MMM"
    
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
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width:  15, height: 15))
        return Path(path.cgPath)
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
