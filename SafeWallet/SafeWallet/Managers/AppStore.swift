//
//  AppStore.swift
//  SafeWallet
//
//  Created by Gonçalo on 18/01/2024.
//

import Combine
import Foundation
import CoreData

class AppStore: ObservableObject {
    @Published var cards: [Card] = []
    
    private var context: NSManagedObjectContext
    private var cancellables = Set<AnyCancellable>()
    
    init(context: NSManagedObjectContext) {
        self.context = context
        let request: NSFetchRequest<Card> = Card.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Card.cardName, ascending: true)]
        
        fetchCards()
        
        NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange, object: context)
            .sink { [weak self] _ in
                do {
                    self?.cards = try context.fetch(request)
                } catch {
                    print("Failed to fetch cards after context change: \(error)")
                }
            }
            .store(in: &cancellables)
    }
    
    private func fetchCards() {
        let request = Card.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Card.cardName, ascending: true)]
        do {
            self.cards = try context.fetch(request)
        } catch {
            // Handle the error
        }
    }
}

