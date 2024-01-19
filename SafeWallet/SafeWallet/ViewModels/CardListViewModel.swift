//
//  CardListViewModel.swift
//  SafeWallet
//
//  Created by Gonçalo on 23/12/2023.
//

import Foundation
import CoreData
import SwiftUI

class CardListViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var showingAddCardView = false
    @Published var appManager: AppManager
    
    init(appManager: AppManager) {
        self.appManager = appManager
    }
    
    func deleteCards(at offsets: IndexSet, from cards: [Card], completion: @escaping (Bool) -> Void) {
        withAnimation {
            let cardsToDelete = offsets.map { cards[$0] }
            appManager.actionManager.doAction(action: .removeCards(cardsToDelete), completion: completion)
        }
    }
    
    func authenticate(completion: @escaping (Bool) -> Void) {
        BiometricAuth().authenticateUser { result in
            if let result = try? result.get(), result {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func refreshView() {
        objectWillChange.send()
    }
}
