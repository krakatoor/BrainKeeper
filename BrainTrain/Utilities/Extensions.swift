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


struct Center: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            content
            Spacer()
        }
        .padding(.leading)
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


// Keyboard Responder
final class KeyboardResponder: ObservableObject {
    private var notificationCenter: NotificationCenter
    @Published private(set) var currentHeight: CGFloat = 0
    @Published private(set) var keyboardShows = false

    init(center: NotificationCenter = .default) {
        notificationCenter = center
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        notificationCenter.removeObserver(self)
    }

    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            currentHeight = keyboardSize.height
            keyboardShows = true
        }
    }

    @objc func keyBoardWillHide(notification: Notification) {
        currentHeight = 0
        keyboardShows = false
    }
}
