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
    @Published var isUnlocked = false
    private var viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }
    
    func deleteCards(at offsets: IndexSet, from cards: FetchedResults<Card>) {
        withAnimation {
            offsets.map { cards[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                // Handle the error appropriately
                print("Error when trying to delete card: \(error)")
            }
        }
    }
    
    func authenticate() {
        let biometricAuth = BiometricAuth()
        biometricAuth.authenticateUser { result in
            switch result {
            case .success:
                self.isUnlocked = true
            case .failure(let error):
                print("Authentication error: \(error.localizedDescription)")
            }
        }
    }
}
