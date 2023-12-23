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
    var holderName: String = ""
    var cardNumber: String = ""
    var expiryDate: String = ""
    var cvvCode: String = ""
    var cardName: String = ""
    
    var viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }
    
    func addCard() {
        let newCard = Card(context: viewContext)
        newCard.holderName = holderName
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

