//
//  AppConstants.swift
//  SafeWallet
//
//  Created by Gonçalo on 21/01/2024.
//

import SwiftUI

enum AddCardErrorType: Error {
    case invalidDate
    case savingError
    case shortCardNumber
}

class AppConstants: ObservableObject {
    @Published var cardBackgroundOpacity = 0.35
    @Published var colors: [Color] = [.black, .purple, .red, .orange, .green, .blue, .yellow]
    @Published var colorCircleSize: CGFloat = 40
    @Published var cardHorizontalMarginSpacing: CGFloat = 20
    @Published var cardVerticalMarginSpacing: CGFloat = 20
    @Published var qrCodeHeight: CGFloat = 300
    
    func getCardHeight(sizeCategory: ContentSizeCategory) -> CGFloat {
        if sizeCategory >= .extraExtraLarge {
            return 200
        } else if sizeCategory <= .small {
            return 150
        } else {
            return 170
        }
    }
}
