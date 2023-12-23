//
//  AddCardView.swift
//  SafeWallet
//
//  Created by Gonçalo on 22/12/2023.
//

import SwiftUI
import CoreData
import Foundation

struct AddCardView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: AddCardViewModel

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Card Details")) {
                    TextField("Card Name", text: $viewModel.cardName)
                    TextField("Holder Name", text: $viewModel.holderName)
                    TextField("Card Number", text: $viewModel.cardNumber)
                        .keyboardType(.numberPad)
                    TextField("Expiry Date", text: $viewModel.expiryDate)
                        .keyboardType(.numberPad)
                    TextField("CVV Code", text: $viewModel.cvvCode)
                        .keyboardType(.numberPad)
                }
                
                Section {
                    Button("Save Card") {
                        viewModel.addCard()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationBarTitle("Add Card", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct AddCardView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        AddCardView(viewModel: AddCardViewModel(context: context))
    }
}

