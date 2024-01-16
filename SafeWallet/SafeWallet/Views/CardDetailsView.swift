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
    @Binding var cardNumber: String
    @Binding var expiryDate: String
    @Binding var cvvCode: String
    @Binding var isUnlocked: Bool
    @StateObject var viewModel = CardDetailsViewModel()

    var isEditable: Bool

    init(cardName: Binding<String>, cardNumber: Binding<String>, expiryDate: Binding<String>, cvvCode: Binding<String>) {
        self._cardName = cardName
        self._cardNumber = cardNumber
        self._expiryDate = expiryDate
        self._cvvCode = cvvCode
        self._isUnlocked = .constant(true)
        isEditable = true
    }
    
    init(card: Card, isUnlocked: Binding<Bool>) {
        self._cardName = .constant(card.cardName)
        self._cardNumber = .constant(card.cardNumber)
        self._expiryDate = .constant(card.expiryDate)
        self._cvvCode = .constant(card.cvvCode)
        self._isUnlocked = isUnlocked
        self.isEditable = false
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 15) {
                if isEditable {
                    TextField("Name", text: $cardName)
                        .font(.headline)
                } else {
                    Text(cardName.uppercased())
                        .font(.headline)
                        .fontWeight(.bold)
                        .textSelection(.enabled)
                }
                
            
                VStack(alignment: .leading) {
                    if isEditable {
                        TextField("Number", text: $cardNumber)
                            .font(.title2)
                            .keyboardType(.numberPad)
                            .frame(width: UIScreen.main.bounds.width * 0.58)
                            .onChange(of: cardNumber, initial: true) { oldValue, newValue in
                                self.cardNumber = self.viewModel.formatCardNumber(newValue)
                            }
                    } else {
                        HStack(spacing: 0) {
                            if !isUnlocked {
                                Text(String(repeating: "•", count: max(0, cardNumber.count - 4)))
                                    .redacted(reason: .placeholder)
                                Text(" " + cardNumber.suffix(4))
                            } else {
                                Text(cardNumber)
                            }
                            
                        }
                        .font(.title3)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .layoutPriority(1)
                        .textSelection(.enabled)

                    }
                }
            
                HStack {
                    if isEditable {
                        TextField("CVV", text: $cvvCode)
                            .font(.footnote)
                            .keyboardType(.numberPad)
                            .frame(width: UIScreen.main.bounds.width * 0.55)
                    } else {
                        if !cardName.isEmpty {
                            VStack {
                                Text("CVV")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                Text(cvvCode)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .redacted(reason: isUnlocked ? [] : .placeholder)
                                    .textSelection(.enabled)
                            }
                        }
                    }

                    Spacer()
                    Spacer()

                    VStack(alignment: .trailing) {
                        if isEditable {
                            TextField("Expires", text: $expiryDate)
                                .font(.headline)
                        } else {
                            Text("Expires on")
                                .font(.caption)
                                .fontWeight(.semibold)
                            Text(expiryDate)
                                .font(.headline)
                                .fontWeight(.bold)
                                .redacted(reason: isUnlocked ? [] : .placeholder)
                                .textSelection(.enabled)
                        }
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.secondary, lineWidth: 1)
            )
            .shadow(radius: 3)
            
            if let cardIssuerImage = viewModel.getCardIssuerImage(cardNumber: cardNumber) {
                cardIssuerImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .padding(.trailing, 15)
                    .padding(.top, 8)
            }
        }
    }
}
