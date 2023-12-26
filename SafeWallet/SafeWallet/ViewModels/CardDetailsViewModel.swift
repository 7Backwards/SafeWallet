//
//  CardDetailsViewModel.swift
//  SafeWallet
//
//  Created by Gonçalo on 26/12/2023.
//

import Foundation

class CardDetailsViewModel: ObservableObject {
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
}
