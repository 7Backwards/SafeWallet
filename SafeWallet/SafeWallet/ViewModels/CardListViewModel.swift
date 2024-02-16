//
//  CardListViewModel.swift
//  SafeWallet
//
//  Created by Gonçalo on 23/12/2023.
//

import Foundation
import CoreData
import SwiftUI

class CardListViewModel: ViewModelProtocol {
    @Published var searchText = ""
    @Published var showingAddCardView = false
    @Published var appManager: AppManager
    private var cardsViewModels = [NSManagedObjectID : CardViewModel]()
    
    init(appManager: AppManager) {
        self.appManager = appManager
    }
    
    func deleteCards(at offsets: IndexSet, from cards: FetchedResults<Card>) {
        withAnimation {
            let cardsToDelete = offsets.map { cards[$0] }
            appManager.actionManager.doAction(action: .removeCards(cardsToDelete))
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
    
    func getCardViewModel(for card: Card) -> CardViewModel {
        if let viewModel = cardsViewModels[card.objectID] {
            return viewModel
        } else {
            let viewModel = CardViewModel(card: card)
            cardsViewModels[card.objectID] = viewModel
            return viewModel
        }
    }
}
