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
    @Binding var cardColor: String
    @Binding var isUnlocked: Bool
    @StateObject var viewModel: CardDetailsViewModel

    var isEditable: Bool

    init(viewModel: CardDetailsViewModel, cardName: Binding<String>, cardNumber: Binding<String>, expiryDate: Binding<String>, cvvCode: Binding<String>, cardColor: Binding<String>) {
        self._cardName = cardName
        self._cardNumber = cardNumber
        self._expiryDate = expiryDate
        self._cvvCode = cvvCode
        self._cardColor = cardColor
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._isUnlocked = .constant(true)
        isEditable = true
    }
    
    init(viewModel: CardDetailsViewModel, card: Card, isUnlocked: Binding<Bool>) {
        self._cardName = .constant(card.cardName)
        self._cardNumber = .constant(card.cardNumber)
        self._expiryDate = .constant(card.expiryDate)
        self._cvvCode = .constant(card.cvvCode)
        self._cardColor = .constant(card.cardColor)
        self._isUnlocked = isUnlocked
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.isEditable = false
    }
    
    init(viewModel: CardDetailsViewModel, card: Card, isUnlocked: Binding<Bool>, cardColor: Binding<String>) {
        self._cardName = .constant(card.cardName)
        self._cardNumber = .constant(card.cardNumber)
        self._expiryDate = .constant(card.expiryDate)
        self._cvvCode = .constant(card.cvvCode)
        self._cardColor = cardColor
        self._isUnlocked = isUnlocked
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.isEditable = false
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 15) {
                if isEditable {
                    TextField("Name", text: $cardName)
                } else {
                    Text(cardName.uppercased())
                        .font(.headline)
                        .fontWeight(.bold)
                        .textSelection(.enabled)
                }
                
            
                VStack(alignment: .leading) {
                    if isEditable {
                        TextField("Number", text: $cardNumber)
                            .font(cardNumber.isEmpty ? .body : .title3)
                            .fontWeight(cardNumber.isEmpty ? .none : .bold)
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
            .background(Color(wordName: cardColor).opacity(viewModel.getCardBackgroundOpacity()))
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

struct CardDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        
        let viewModel = CardDetailsViewModel(appManager: AppManager(context: context))
        
        // Binding variables for the preview
        let bindingCardName = Binding.constant("Visa")
        let bindingCardNumber = Binding.constant("4234 5678 0000 1111")
        let bindingExpiryDate = Binding.constant("12/25")
        let bindingCvvCode = Binding.constant("123")
        let bindingCardColor = Binding.constant("systemBackground")

        // Return the preview of CardDetailsView
        CardDetailsView(viewModel: viewModel,
                        cardName: bindingCardName,
                        cardNumber: bindingCardNumber,
                        expiryDate: bindingExpiryDate,
                        cvvCode: bindingCvvCode,
                        cardColor: bindingCardColor)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
