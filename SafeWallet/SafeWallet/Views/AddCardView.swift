//
//  AddCardView.swift
//  SafeWallet
//
//  Created by Gonçalo on 22/12/2023.
//

import SwiftUI

struct AddCardView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var cardName: String = ""
    @State private var holderName: String = ""
    @State private var cardNumber: String = ""
    @State private var expiryDate: String = ""
    @State private var cvvCode: String = ""
    @StateObject var viewModel: AddCardViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                Spacer()
                Spacer()
                Spacer()
                VStack(spacing: 30) {
                    CardDetailsView(cardName: $cardName,
                                    holderName: $holderName,
                                    cardNumber: $cardNumber,
                                    expiryDate: $expiryDate,
                                    cvvCode: $cvvCode)
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                    
                    Button("Save Card") {
                        viewModel.addCard(cardName: cardName, holderName: holderName, cardNumber: cardNumber, expiryDate: expiryDate, cvvCode: cvvCode)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .frame(width: UIScreen.main.bounds.width - 30, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .navigationBarTitle("Add Card", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}


// A placeholder Card object for preview purposes
extension Card {
    static var placeholder: Card {
        let card = Card(context: PersistenceController.preview.container.viewContext)
        card.holderName = "Holder Name"
        card.cardName = "Card Name"
        card.cardNumber = "Card Number"
        card.expiryDate = "MM/YY"
        card.cvvCode = "CVV"
        return card
    }
}

struct AddCardView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        AddCardView(viewModel: AddCardViewModel(context: context))
    }
}
