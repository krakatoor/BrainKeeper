//
//  Extensions.swift
//  BrainKeeper
//
//  Created by Камиль Сулейманов on 28.04.2021.
//

import SwiftUI

struct CustomCorner: Shape {
    var corners: UIRectCorner
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: small ? 0 : 22, height: small ? 0 : 22))
        return Path(path.cgPath)
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
