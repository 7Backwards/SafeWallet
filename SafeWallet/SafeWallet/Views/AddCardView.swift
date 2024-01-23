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
    @State private var cardNumber: String = ""
    @State private var expiryDate: String = ""
    @State private var cvvCode: String = ""
    @State private var cardColor: String = "systemBackground"
    @State private var showAlert = false
    @State private var alertMessage = ""
    @StateObject var viewModel: AddCardViewModel
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 20) {
                        CardDetailsView(
                                        viewModel: CardDetailsViewModel(appManager: viewModel.appManager),
                                        cardName: $cardName,
                                        cardNumber: $cardNumber,
                                        expiryDate: $expiryDate,
                                        cvvCode: $cvvCode,
                                        cardColor: $cardColor)
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                        
                        ColorCarouselView(cardColor: $cardColor, viewModel: ColorCarouselViewModel(appManager: viewModel.appManager))
                        
                        Button("Save Card") {
                            viewModel.addCard(cardName: cardName, cardNumber: cardNumber, expiryDate: expiryDate, cvvCode: cvvCode, cardColor: cardColor) { result in
                                switch result {
                                case .success:
                                    presentationMode.wrappedValue.dismiss()
                                case .failure(let error):
                                    // Handle the specific error, e.g., show an alert with the error description
                                    switch error {
                                    case .invalidDate:
                                        alertMessage = "Invalid expiration date, please update it."
                                    case .savingError:
                                        alertMessage = "Something went wrong, please try again."
                                    case .shortCardNumber:
                                        alertMessage = "Card number is not invalid, please update it."
                                    }
                                    showAlert = true
                                }
                            }
                            
                        }
                        .frame(width: geometry.size.width - 60, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
            }
            .navigationBarTitle("Add Card", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
            })
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}



// A placeholder Card object for preview purposes
extension Card {
    static var placeholder: Card {
        let card = Card(context: PersistenceController.preview.container.viewContext)
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
        AddCardView(viewModel: AddCardViewModel(appManager: AppManager(context: context)))
    }
}
