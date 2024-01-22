//
//  AppUtils.swift
//  SafeWallet
//
//  Created by Gonçalo on 20/01/2024.
//

import SwiftUI

class AppUtils {
    func formatCardNumber(_ number: String) -> String {
        // First, filter out any non-numeric characters
        let filtered = number.filter { "0123456789".contains($0) }
        
        // Then, limit to the first 16 characters
        let trimmed = String(filtered.prefix(16))
        
        // Finally, add a space after every 4 digits
        return stride(from: 0, to: trimmed.count, by: 4).map {
            let start = trimmed.index(trimmed.startIndex, offsetBy: $0)
            let end = trimmed.index(start, offsetBy: 4, limitedBy: trimmed.endIndex) ?? trimmed.endIndex
            return String(trimmed[start..<end])
        }.joined(separator: " ")
    }
    
    func getCardIssuerImage(cardNumber: String) -> Image? {
        let formattedNumber = cardNumber.replacingOccurrences(of: " ", with: "")
        
        if formattedNumber.hasPrefix("4") {
            return Image("visa")
        } else if formattedNumber.range(of: "^(51|52|53|54|55|2221|222[2-9]|22[3-9]\\d|2[3-6]\\d\\d|27[01]\\d|2720)", options: .regularExpression) != nil {
            return Image("mastercard")
        } else if formattedNumber.range(of: "^(34|37)", options: .regularExpression) != nil {
            return Image("american-express")
        } else {
            return nil
        }
    }
}