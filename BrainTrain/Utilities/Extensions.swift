//
//  Extensions.swift
//  BrainTrain
//
//  Created by Камиль Сулейманов on 28.04.2021.
//

import SwiftUI
import CoreData

let screenSize = UIScreen.main.bounds
let small = UIScreen.main.bounds.height < 750
let notificationCenter = UNUserNotificationCenter.current()
let showAppStoreCoverDay = [6, 24]
let showFinishCoverDay = 60

func timeString(time: Double) -> String {
    let minutes   = Int(time) / 60
    let seconds = Int(time) - Int(minutes) * 60
    
    return String(format:"%02i:%02i", minutes, seconds)
}

var today: String {
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d MMM"
    
    return "\(dateFormatter.string(from: date))"
}

var tomorrow: String {
    let date = Date().addingTimeInterval(86400)
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


struct CustomCorner: Shape {
    var corners: UIRectCorner
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: small ? 0 : 22, height: small ? 0 : 22))
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



//Remove navLink tap animation
struct FlatLinkStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}


extension StringProtocol {
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { return prefix(1).capitalized + dropFirst() }
}
