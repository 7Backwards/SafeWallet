//
//  AppActionManager.swift
//  SafeWallet
//
//  Created by Gonçalo on 18/01/2024.
//

import CoreData

enum AppAction {
    case addCard(cardName: String, cardNumber: String, expiryDate: String, cvvCode: String)
    case removeCard(Card)
    case removeCards([Card])
}

class AppActionManager {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func doAction(action: AppAction, completion: ((Bool) -> Void)? = nil) {
        func saveWithCompletion() {
            do {
                try context.save()
                completion?(true)
            } catch {
                completion?(false)
            }
        }

        switch action {
        case .addCard(let cardName, let cardNumber, let expiryDate, let cvvCode):
            let card = Card(context: context)
            card.cardNumber = cardNumber
            card.expiryDate = expiryDate
            card.cvvCode = cvvCode
            card.cardName = cardName
            saveWithCompletion()
        case .removeCard(let card):
            context.delete(card)
            saveWithCompletion()
        case .removeCards(let cards):
            cards.forEach {
                context.delete($0)
            }
            saveWithCompletion()
        }
        
    }
}
