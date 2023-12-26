//
//  CardDetailsView.swift
//  SafeWallet
//
//  Created by Gonçalo on 24/12/2023.
//

import Foundation
import SwiftUI
import Combine

struct CardDetailsView: View {
    @Binding var cardName: String
    @Binding var holderName: String
    @Binding var cardNumber: String
    @Binding var expiryDate: String
    @Binding var cvvCode: String
    @StateObject var viewModel = CardDetailsViewModel()
    var isEditable: Bool

    init(cardName: Binding<String>, holderName: Binding<String>, cardNumber: Binding<String>, expiryDate: Binding<String>, cvvCode: Binding<String>) {
        self._cardName = cardName
        self._holderName = holderName
        self._cardNumber = cardNumber
        self._expiryDate = expiryDate
        self._cvvCode = cvvCode
        isEditable = true
    }
    
    init(card: Card) {
        self._cardName = .constant(card.cardName)
        self._holderName = .constant(card.holderName)
        self._cardNumber = .constant(card.cardNumber)
        self._expiryDate = .constant(card.expiryDate)
        self._cvvCode = .constant(card.cvvCode)
        self.isEditable = false
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack() {
                if isEditable {
                    TextField("Holder Name", text: $holderName, prompt: Text("Name").foregroundColor(.white.opacity(0.5)))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .accentColor(.white)
                        .frame(width: 2/3 * UIScreen.main.bounds.width)
                        
                } else {
                    Text(holderName)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                Spacer()
                if isEditable {
                    TextField("Card Name", text: $cardName, prompt: Text("Alias").foregroundColor(.white.opacity(0.5)))
                        .font(.caption)
                        .foregroundColor(.white)
                        .accentColor(.white)
                } else {
                    Text(cardName)
                        .font(.caption)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                }
            }
            Spacer()
            if isEditable {
                TextField("Card Number", text: $cardNumber, prompt: Text("Number").foregroundColor(.white.opacity(0.5)))
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(width: 2/3 * UIScreen.main.bounds.width)
                    .accentColor(.white)
                    .keyboardType(.numberPad)
                    .onChange(of: cardNumber, initial: true) { oldValue, newValue in
                        self.cardNumber = self.viewModel.formatCardNumber(newValue)
                    }
            } else {
                Text(cardNumber)
                    .font(.title3)
                    .foregroundColor(.white)
            }
            Spacer()
            HStack {
                if isEditable {
                    TextField("Expires", text: $expiryDate, prompt: Text("Expire").foregroundColor(.white.opacity(0.5)))
                        .font(.footnote)
                        .foregroundColor(.white)
                        .frame(width: 2/3 * UIScreen.main.bounds.width)
                        .accentColor(.white)
                } else {
                    Text(expiryDate)
                        .font(.footnote)
                        .foregroundColor(.white)
                }
                Spacer()
                if isEditable {
                    TextField("CVC", text: $cvvCode, prompt: Text("CVV").foregroundColor(.white.opacity(0.5)))
                        .font(.footnote)
                        .foregroundColor(.white)
                        .accentColor(.white)
                        .keyboardType(.numberPad)
                } else {
                    Text(cvvCode)
                        .font(.footnote)
                        .foregroundColor(.white)
                }
            }
        }
    }
}
