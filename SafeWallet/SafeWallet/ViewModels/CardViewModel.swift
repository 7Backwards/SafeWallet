//
//  CardViewModel.swift
//  SafeWallet
//
//  Created by Gonçalo on 08/01/2024.
//

import SwiftUI

class CardViewModel: ObservableObject {
    var card: Card
    @Published var appManager: AppManager
    @Published var shouldShowDeleteConfirmation: Bool = false
    
    init(card: Card, appManager: AppManager) {
        self.card = card
        self.appManager = appManager
    }

    func delete(completion: @escaping (Bool) -> Void ) {
        appManager.actionManager.doAction(action: .removeCard(card), completion: completion)
    }
}