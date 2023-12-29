//
//  AddCardViewModel.swift
//  SafeWallet
//
//  Created by Gonçalo on 23/12/2023.
//

import Foundation
import CoreData
import SwiftUI

class AddCardViewModel: ObservableObject {
    
    var viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }
    
    func addCard(cardName: String, cardNumber: String, expiryDate: String, cvvCode: String) {
        guard !cardName.isEmpty, !cardNumber.isEmpty, !expiryDate.isEmpty, !cvvCode.isEmpty else { return }
        let newCard = Card(context: viewContext)
        newCard.cardNumber = cardNumber
        newCard.expiryDate = expiryDate
        newCard.cvvCode = cvvCode
        newCard.cardName = cardName

        do {
            try viewContext.save()
        } catch {
            // Handle the error appropriately
            // For example, you could set an error message property here that the view can display
            print("Could not save the card: \(error.localizedDescription)")
        }
    }
}

