//
//  Extensions.swift
//  BrainKeeper
//
//  Created by Камиль Сулейманов on 28.04.2021.
//

import SwiftUI




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
