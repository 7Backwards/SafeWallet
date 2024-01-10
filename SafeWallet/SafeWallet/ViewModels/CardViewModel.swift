//
//  CardViewModel.swift
//  SafeWallet
//
//  Created by Gonçalo on 08/01/2024.
//

import SwiftUI

class CardViewModel: ObservableObject {
    var card: Card
    @Published var shouldShowDeleteConfirmation: Bool = false
    
    init(card: Card) {
        self.card = card
    }

    func delete(completion: (Bool) -> Void ) {
        guard let context = card.managedObjectContext else {
            return
        }
        
        context.delete(card)
        
        do {
            try context.save()
            completion(true)
        } catch {
            completion(false)
            print("Error saving context after deleting card: \(error)")
        }
    }
}
