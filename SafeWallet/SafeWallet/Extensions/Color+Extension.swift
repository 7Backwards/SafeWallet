//
//  Color+Extension.swift
//  SafeWallet
//
//  Created by Gonçalo on 20/01/2024.
//

import SwiftUI

extension Color {
    
    init?(wordName: String) {
        switch wordName {
        case "clear": self = .clear
        case "black": self = .black
        case "white": self = .white
        case "gray": self = .gray
        case "red": self = .red
        case "green": self = .green
        case "blue": self = .blue
        case "orange": self = .orange
        case "yellow": self = .yellow
        case "pink": self = .pink
        case "purple": self = .purple
        case "primary": self = .primary
        case "secondary": self = .secondary
        case "systemBackground": self = Color(uiColor: .systemBackground)
        default: return nil
        }
    }
}
